from flask import render_template
from netaddr import IPAddress, IPNetwork


class SubnetException(Exception):
    pass


def isIPv4(address):
    """Function will check if parameter is valid IPv4 address.
    If it's not, it will raise Exception with message "Wrong IP 'parameter'
    """
    if address.count('.') != 3:
        raise Exception('Wrong IP "{}"'.format(address))
    tmp = address.split('.')
    for octet in tmp:
        if (not octet.isnumeric()) or 0 > int(octet) or int(octet) > 255:
            raise Exception('Wrong IP "{}"'.format(address))
    return True


def findNearestPrefix(hosts):
    """Function will return first valid prefix that will cover all hosts + network address + broadcast address.
    """
    hosts += 2
    for x in range(32):
        if 2 ** x >= hosts:
            return 32 - x


def parseHosts(hosts):
    """Function will strip value from parameter to correct host form.
    If input is in wrong format it will raise SubnetException with message "Identical subnets name 'name'"
    """
    dt = dict()
    if ", " not in hosts:
        tmp = hosts.split("-")
        dt[tmp[0]] = int(tmp[1])
        return dt
    else:
        hosts = hosts.split(", ")
        for x in range(len(hosts)):
            tmp = hosts[x].split("-")
            if tmp[0] in dt.keys():
                raise SubnetException('Identical subnets name "{}"'.format(tmp[0]))
            dt[tmp[0]] = int(tmp[1])
        return dt


def processOutput(hosts, subnets, input):
    """Function will enable Flask to return template with data provided in parameter.
    data in template are provided as list, where each item is list means as subnet where subnet has its name,
    number of hosts and address with prefix.
    """
    output = list()
    i = 0
    for x in hosts.keys():
        tmp = (x, hosts.get(x), "{}/{}".format(subnets[i].ip, subnets[i].prefixlen))
        output.append(tmp)
        i += 1
    return render_template("subnets.html", data=output, input=input)


# todo remove function below, it's not used
def subnet(address, hosts, variableMask):
    if not variableMask:
        max_value = max(hosts.values())
        subnets = list(address.subnet(findNearestPrefix(max_value)))
        subnets = subnets[0:len(hosts)]
        return processOutput(hosts, subnets)
    else:
        hosts = dict(sorted(hosts.items(), key=lambda item: item[1]))

        tmpAdd = address
        subnets = list()

        for key in hosts.keys():
            tmpAdd.subnet(hosts.get(key))
            subnets.append(tmpAdd[0])
            tmpAdd = subnet(tmpAdd[1])
        return processOutput(hosts, subnets)


def maskIsValid(mask):
    """Function check if input is valid mask or valid prefix.
    If input is valid, then prefix will be returned.
    If input is not valid, then it will raise Exception "Wrong Mask 'mask'"
    """
    try:
        if len(mask) < 3 and 0 <= int(mask) <= 32:
            return mask
        isIPv4(mask)
        if IPAddress(mask).is_netmask():
            address = IPNetwork(mask + '/' + "24")
            address.netmask = mask
            return str(address.prefixlen)
        raise Exception()
    except Exception:
        raise Exception('Wrong Mask "{}"'.format(mask))


def getSubnets(address, mask, hosts, variableMask):
    """Function will process input enable Flask to return template with provided output.
    """
    input = [address, mask, hosts, variableMask]
    try:
        isIPv4(address)
        mask = maskIsValid(mask)
        address = IPNetwork(address + '/' + mask)
        hosts = parseHosts(hosts)

        if not variableMask:
            max_value = max(hosts.values())
            subnets = list(address.subnet(findNearestPrefix(max_value)))
            subnets = subnets[0:len(hosts)]
            return processOutput(hosts, subnets, input)
        else:
            hosts = dict(sorted(hosts.items(), reverse=True, key=lambda item: item[1]))
            networkList = list()
            networkList.append(address)
            subnets = list()

            for key in hosts.keys():
                nextPrefix = findNearestPrefix(hosts.get(key))

                if networkList[0].prefixlen == nextPrefix:
                    subnets.append(networkList[0])
                    networkList = networkList[1:]
                else:
                    networkList = list(networkList[0].subnet(nextPrefix)) + networkList[1:]
                    subnets.append(networkList[0])
                    networkList = networkList[1:]
                    print(networkList)

            return processOutput(hosts, subnets, input)
    except IndexError:
        data = list()
        data.append("address {}, mask {}, hosts {}, variableMask {}".format(address, mask, hosts, variableMask))
        data.append(["Hosts too big, not enough space in network"])
        return render_template("subnets_error.html", data=data, input=input)
    except Exception as ex:
        data = list()
        data.append("address {}, mask {}, hosts {}, variableMask {}".format(address, mask, hosts, variableMask))
        data.append(ex.args)
        return render_template("subnets_error.html", data=data, input=input)
