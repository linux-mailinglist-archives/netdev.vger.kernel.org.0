Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A632F6E8D1
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfGSQbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:31:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41519 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfGSQbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:31:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so14417966pff.8
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 09:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HtbCQ+t1CFj8uD7m4S+qpfptRPiWvIZqGmwF1a5d5Rw=;
        b=pO0ZRAraXTMSdb9BdxXZdaZy8P9OwCPfjajTuaUjbZ4wwEKzjbzGVv+w6BvVw2YUTt
         4WvytQPn4S0HU+HC/7RAsy0r8MGylNTdQA/ucbtTwRl/QRkixv6IReMRJaV6n7HOFfd/
         YuIsHWM4itLSIMVeBohvGm0o2XDZgiNc9pdSR8TSIwaBYO9oC2TrdC/SVfn/G9t8bZIZ
         OEmEMbVUTAfw8SvokN0MFg1B5D9mntP0ZPCKeYdCsobM1SvLC/kwfx7FWHOjOCHE5VXQ
         yuiQ6/YRws7qWL2yMDRzDI9hMZSodIB526xF8UrA5m9pU4Z1G6kw5J/gU159E2L9Ktf2
         qmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HtbCQ+t1CFj8uD7m4S+qpfptRPiWvIZqGmwF1a5d5Rw=;
        b=O+2EO+XElyFYgc3m5/mu9VJqh9HnSFvRMZxTS3n2YP7QLJhUJXySuVT7ebpfb3w95t
         hmL20DB1ISz3ySqxL9SIOj2RYmN1yaoztQO++KE0Cx03cIg7N4mOH5mWb+4xS86Xj/bI
         nfSdjn6gIenjo+ksPYmAfBTOPodbwrFyzkAqOUwNWJg+4gp2joQCdUzSf23CsMlgS5sV
         YEx5ZPkGz89yz0n+KRdpIjSrCg1ipSuGTQSAjsWG2NKIA4tfC//aompVeb1Y15G8dPwI
         Oj0cQFws/QC1KqWnaYsru854hfZIqqM3XtRfx2s721Pw5QSnV9WnfGBfhgxjJoPv3+ip
         CDHA==
X-Gm-Message-State: APjAAAXbCYwU0k0DCkKAzAc6Br/R57cj520TVlOL3ABcZlRcx8UUoaW1
        okiofBdqoglS9J8feO24ONI=
X-Google-Smtp-Source: APXvYqzQ+9UO1U6QnQZHLbrg/VKrohsz/bNDqh7fz2lEv+6XVheDlsn9+ZWYjH8UNW88LNf8IJgvMw==
X-Received: by 2002:a17:90a:ad93:: with SMTP id s19mr58713289pjq.36.1563553896878;
        Fri, 19 Jul 2019 09:31:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f20sm25351898pgg.56.2019.07.19.09.31.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 09:31:36 -0700 (PDT)
Date:   Fri, 19 Jul 2019 09:31:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 0/7] net: introduce alternative names for
 network interfaces
Message-ID: <20190719093135.5807f41c@hermes.lan>
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 13:00:22 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
> netdevice name length. Now when we have PF and VF representors
> with port names like "pfXvfY", it became quite common to hit this limit:
> 0123456789012345
> enp131s0f1npf0vf6
> enp131s0f1npf0vf22
> 
> Udev cannot rename these interfaces out-of-the-box and user needs to
> create custom rules to handle them.
> 
> Also, udev has multiple schemes of netdev names. From udev code:
>  * Type of names:
>  *   b<number>                             - BCMA bus core number
>  *   c<bus_id>                             - bus id of a grouped CCW or CCW device,
>  *                                           with all leading zeros stripped [s390]
>  *   o<index>[n<phys_port_name>|d<dev_port>]
>  *                                         - on-board device index number
>  *   s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
>  *                                         - hotplug slot index number
>  *   x<MAC>                                - MAC address
>  *   [P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
>  *                                         - PCI geographical location
>  *   [P<domain>]p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>]
>  *                                         - USB port number chain
>  *   v<slot>                               - VIO slot number (IBM PowerVM)
>  *   a<vendor><model>i<instance>           - Platform bus ACPI instance id
>  *   i<addr>n<phys_port_name>              - Netdevsim bus address and port name
> 
> One device can be often renamed by multiple patterns at the
> same time (e.g. pci address/mac).
> 
> This patchset introduces alternative names for network interfaces.
> Main goal is to:
> 1) Overcome the IFNAMSIZ limitation
> 2) Allow to have multiple names at the same time (multiple udev patterns)
> 3) Allow to use alternative names as handle for commands
> 
> See following examples.
> 
> $ ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
> 
> -> Add alternative names for dummy0:  
> 
> $ ip link altname add dummy0 name someothername
> $ ip link altname add dummy0 name someotherveryveryveryverylongname
> $ ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>     altname someothername
>     altname someotherveryveryveryverylongname
>   
> -> Add bridge brx, add it's alternative name and use alternative names to  
>    do enslavement.
> 
> $ ip link add name brx type bridge
> $ ip link altname add brx name mypersonalsuperspecialbridge
> $ ip link set someotherveryveryveryverylongname master mypersonalsuperspecialbridge
> $ ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>     altname someothername
>     altname someotherveryveryveryverylongname
> 4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>     altname mypersonalsuperspecialbridge
> 
> -> Add ipv4 address to the bridge using alternative name:  
>     
> $ ip addr add 192.168.0.1/24 dev mypersonalsuperspecialbridge
> $ ip addr show mypersonalsuperspecialbridge     
> 4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>     altname mypersonalsuperspecialbridge
>     inet 192.168.0.1/24 scope global brx
>        valid_lft forever preferred_lft forever
> 
> -> Delete one of dummy0 alternative names:  
> 
> $ ip link altname del someotherveryveryveryverylongname    
> $ ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>     altname someothername
> 4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>     altname mypersonalsuperspecialbridge
> 
> TODO:
> - notifications for alternative names add/removal
> - sanitization of add/del cmds (similar to get link)
> - test more usecases and write selftests
> - extend support for other netlink ifaces (ovs for example)
> - add sysfs symlink altname->basename?
> 
> Jiri Pirko (7):
>   net: procfs: use index hashlist instead of name hashlist
>   net: introduce name_node struct to be used in hashlist
>   net: rtnetlink: add commands to add and delete alternative ifnames
>   net: rtnetlink: put alternative names to getlink message
>   net: rtnetlink: unify the code in __rtnl_newlink get dev with the rest
>   net: rtnetlink: introduce helper to get net_device instance by ifname
>   net: rtnetlink: add possibility to use alternative names as message
>     handle
> 
>  include/linux/netdevice.h      |  14 ++-
>  include/uapi/linux/if.h        |   1 +
>  include/uapi/linux/if_link.h   |   3 +
>  include/uapi/linux/rtnetlink.h |   7 ++
>  net/core/dev.c                 | 152 ++++++++++++++++++++++----
>  net/core/net-procfs.c          |   4 +-
>  net/core/rtnetlink.c           | 192 +++++++++++++++++++++++++++++----
>  security/selinux/nlmsgtab.c    |   4 +-
>  8 files changed, 334 insertions(+), 43 deletions(-)
> 

You might want to add altname/ object property in sysfs?
I.e
   /sys/class/net/eth0/altname/

