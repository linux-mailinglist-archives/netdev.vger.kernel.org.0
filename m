Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F0C1E65
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfI3JsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51943 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfI3JsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so12617678wme.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1HX76cOckEP8lAvcEQOIaQzAJtPydIj6nf0AC8fM2i8=;
        b=gsHwKpddgwLmGGomWODOisT0MlZsnbNMI+wyvPE58skQf/77e2/EynnhsQzkSpyFFx
         2js25LABVWa5Df5XdSDcf2jvxQrIxrP17hWZsWCRbK84ZfuYFd6DR2eDLxf/Y/u9o5Qj
         i7cSMxmV5TtdHaEElCHxQ73IJQyPQbeYLgFqEjifgI/RgE0Qxg/yccTy5l2gUuStoLiu
         uJrRWZhnmkuWzinTUKynBO60d3NeDEKoNV8xz3dbYD9ag0ulB+dk0A5Z+J8awHy2vXZV
         bgTJtKbuArYYa+i+HCUBpGDUbsKEKtmrYRO4mwDMTixxp4eNmv4jrWqYQxxantAu2Hn8
         iBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1HX76cOckEP8lAvcEQOIaQzAJtPydIj6nf0AC8fM2i8=;
        b=akQu80G3h3uBJrlRCjcrB0Isuo/3CUDDkfKSzsIDUnmad5UJnu8pbGpIlrNefDs3e0
         Ld8S492vn02yC/KX9RapqUTzCMtJDWGjEgJKCMSXDlpr9uWjJAsfDslt0fRKJbWNoa8p
         E1N7txjf/Ltf83wH8vkLNKFbOKPEdd+IdXiI9siw22pmqMLLCgXTbyIE/MhHqTOkK0R2
         OTzDGD/dlqsMbEdeV9R5E2lFdqqvY8QyX3Ra5tdqIJwQTsPw58KnaeX+vIW03KVdgbn3
         BXy4gxshQjypSLpH+KhVihJyH/PTLk6DPicZUB9xv64z+mgFrX6iyxGHHfKzHlNclhDx
         ri6A==
X-Gm-Message-State: APjAAAUoquTJM0BsmWKRW+vvNrmxz5vxgjYHjoTSz2VSQWbHQE2E5HBx
        N9u37njwTXdjZYB9QUMjNpbAykKpBr8=
X-Google-Smtp-Source: APXvYqzifimIpJy6oGWGAAjsyTsbvwLpeJhqs9bI0c8KAzEcRrhHoi1MbMe8LBveBUa4OvLQI6/Yew==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr15674718wmi.108.1569836901801;
        Mon, 30 Sep 2019 02:48:21 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id t14sm12277494wrs.6.2019.09.30.02.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:21 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 0/7] net: introduce alternative names for network interfaces
Date:   Mon, 30 Sep 2019 11:48:13 +0200
Message-Id: <20190930094820.11281-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
netdevice name length. Now when we have PF and VF representors
with port names like "pfXvfY", it became quite common to hit this limit:
0123456789012345
enp131s0f1npf0vf6
enp131s0f1npf0vf22

Udev cannot rename these interfaces out-of-the-box and user needs to
create custom rules to handle them.

Also, udev has multiple schemes of netdev names. From udev code:
 * Type of names:
 *   b<number>                             - BCMA bus core number
 *   c<bus_id>                             - bus id of a grouped CCW or CCW device,
 *                                           with all leading zeros stripped [s390]
 *   o<index>[n<phys_port_name>|d<dev_port>]
 *                                         - on-board device index number
 *   s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
 *                                         - hotplug slot index number
 *   x<MAC>                                - MAC address
 *   [P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
 *                                         - PCI geographical location
 *   [P<domain>]p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>]
 *                                         - USB port number chain
 *   v<slot>                               - VIO slot number (IBM PowerVM)
 *   a<vendor><model>i<instance>           - Platform bus ACPI instance id
 *   i<addr>n<phys_port_name>              - Netdevsim bus address and port name

One device can be often renamed by multiple patterns at the
same time (e.g. pci address/mac).

This patchset introduces alternative names for network interfaces.
Main goal is to:
1) Overcome the IFNAMSIZ limitation (altname limitation is 128 bytes)
2) Allow to have multiple names at the same time (multiple udev patterns)
3) Allow to use alternative names as handle for commands

The patchset introduces two new commands to add/delete list of properties.
Currently only alternative names are implemented but the ifrastructure
could be easily extended later on. This is very similar to the list of vlan
and tunnels being added/deleted to/from bridge ports.

See following examples.

$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff

-> Add alternative names for dummy0:
    
$ ip link prop add dummy0 altname someothername
$ ip link prop add dummy0 altname someotherveryveryveryverylongname 
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname someothername
    altname someotherveryveryveryverylongname
$ ip link show someotherveryveryveryverylongname
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname someothername
    altname someotherveryveryveryverylongname

-> Add bridge brx, add it's alternative name and use alternative names to
   do enslavement.
    
$ ip link add name brx type bridge
$ ip link prop add brx altname mypersonalsuperspecialbridge
$ ip link set someotherveryveryveryverylongname master mypersonalsuperspecialbridge
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname someothername
    altname someotherveryveryveryverylongname
3: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge

-> Add ipv4 address to the bridge using alternative name:

$ ip addr add 192.168.0.1/24 dev mypersonalsuperspecialbridge
$ ip addr show mypersonalsuperspecialbridge
3: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge
    inet 192.168.0.1/24 scope global brx
       valid_lft forever preferred_lft forever

-> Delete one of dummy0 alternative names:

$ ip link prop del dummy0 altname someotherveryveryveryverylongname
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname someothername
3: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge

-> Add multiple alternative names at once

$ ip link prop add dummy0 altname a altname b altname c altname d
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname someothername
    altname a
    altname b
    altname c
    altname d
3: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ae:67:a9:67:46:86 brd ff:ff:ff:ff:ff:ff
    altname mypersonalsuperspecialbridge

Jiri Pirko (7):
  net: procfs: use index hashlist instead of name hashlist
  net: introduce name_node struct to be used in hashlist
  net: rtnetlink: add linkprop commands to add and delete alternative
    ifnames
  net: rtnetlink: put alternative names to getlink message
  net: rtnetlink: unify the code in __rtnl_newlink get dev with the rest
  net: rtnetlink: introduce helper to get net_device instance by ifname
  net: rtnetlink: add possibility to use alternative names as message
    handle

 include/linux/netdevice.h      |  14 ++-
 include/uapi/linux/if.h        |   1 +
 include/uapi/linux/if_link.h   |   2 +
 include/uapi/linux/rtnetlink.h |   7 ++
 net/core/dev.c                 | 153 +++++++++++++++++++++---
 net/core/net-procfs.c          |   4 +-
 net/core/rtnetlink.c           | 206 +++++++++++++++++++++++++++++----
 security/selinux/nlmsgtab.c    |   4 +-
 8 files changed, 348 insertions(+), 43 deletions(-)

-- 
2.21.0

