Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36676EAF7
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfGSTQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 15:16:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39808 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfGSTQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 15:16:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so33223395wrt.6
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 12:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JjAmuo208q3AMhN944SfgFADRgEQ4KOjNqn2x56qwD0=;
        b=uvsxxjGQOrEqZZp4nCBrTgeCk1nc26kh9x6LC7pcx2zE8aYfPn4Ycule0JH0lrV1QV
         ZcjULE4d4/66cG6c2RNhGYax2GpGvskhA7IiEINg8sN4IRpRPuKqpSbzD40T92OLEUnn
         l4U0FqeMc+AulvpPyynLz4c+1yYGgDVBIXASCNphPRWlH1LL/XavEwBFdQhvIkK7Okv9
         wKO+99u81L4NUk3m4gM9ZCGBmQqziqU7votKJANNoh4vY/hOIg63FxUKJ2A5AEPr5hT2
         QD9DcL5a8g8so2nt+CbPUsO2u/NkcRb0/bq6N2lh+gObs0//ldRG7CG8TglJc3QEZD5X
         IoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JjAmuo208q3AMhN944SfgFADRgEQ4KOjNqn2x56qwD0=;
        b=OQmvHU3AybXaBNPVIYcOVXkTZaEcukwp7BQxEr4enett0MnUX+PZZRnmhjo4RhRcv2
         3RPXkqgoqL9EQVuNJdBkA1Eg7SBigs9hLxjiWFAns522ArfyJsQ7WX9QFzN/ofqPNsR7
         JFukRoPuo+sd/xmC6X8qhShLTWgnPacIPmJ/eUUrGHzeQPgWgbWkVHd88kFU3Djj0nbU
         uoESoRCOUT62YvgrJTcZ5EKBhtZHb3aZt5G+lliVmOX0SDm/TrLXnAzbFBaDsLbDyGob
         i5oWksnhn98KpepAdocUr4b4oDjNxBAJow0tijV/5BNWMYQ8/Hb/JisjZjZISkIf5Ks1
         Agqg==
X-Gm-Message-State: APjAAAXuPaG2SGaIAs08svEmtKI+n1W2/hoYD70+jc/BAyly3jbHRha4
        cCdcR2sULp7qVR1SE5RFD3Q=
X-Google-Smtp-Source: APXvYqwm5//mCoLSl2iedUq+7ORoIMoU703OQsGdCMzJYiGpUadujbYpCOMZA69r85Th7P/Af9LKcQ==
X-Received: by 2002:a05:6000:12c2:: with SMTP id l2mr28113329wrx.65.1563563796088;
        Fri, 19 Jul 2019 12:16:36 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id s188sm23763764wmf.40.2019.07.19.12.16.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 12:16:35 -0700 (PDT)
Date:   Fri, 19 Jul 2019 21:16:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 0/7] net: introduce alternative names for
 network interfaces
Message-ID: <20190719191634.GE2230@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719093135.5807f41c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719093135.5807f41c@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 19, 2019 at 06:31:35PM CEST, stephen@networkplumber.org wrote:
>On Fri, 19 Jul 2019 13:00:22 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
>> netdevice name length. Now when we have PF and VF representors
>> with port names like "pfXvfY", it became quite common to hit this limit:
>> 0123456789012345
>> enp131s0f1npf0vf6
>> enp131s0f1npf0vf22
>> 
>> Udev cannot rename these interfaces out-of-the-box and user needs to
>> create custom rules to handle them.
>> 
>> Also, udev has multiple schemes of netdev names. From udev code:
>>  * Type of names:
>>  *   b<number>                             - BCMA bus core number
>>  *   c<bus_id>                             - bus id of a grouped CCW or CCW device,
>>  *                                           with all leading zeros stripped [s390]
>>  *   o<index>[n<phys_port_name>|d<dev_port>]
>>  *                                         - on-board device index number
>>  *   s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
>>  *                                         - hotplug slot index number
>>  *   x<MAC>                                - MAC address
>>  *   [P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
>>  *                                         - PCI geographical location
>>  *   [P<domain>]p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>]
>>  *                                         - USB port number chain
>>  *   v<slot>                               - VIO slot number (IBM PowerVM)
>>  *   a<vendor><model>i<instance>           - Platform bus ACPI instance id
>>  *   i<addr>n<phys_port_name>              - Netdevsim bus address and port name
>> 
>> One device can be often renamed by multiple patterns at the
>> same time (e.g. pci address/mac).
>> 
>> This patchset introduces alternative names for network interfaces.
>> Main goal is to:
>> 1) Overcome the IFNAMSIZ limitation
>> 2) Allow to have multiple names at the same time (multiple udev patterns)
>> 3) Allow to use alternative names as handle for commands
>> 
>> See following examples.
>> 
>> $ ip link
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>> 
>> -> Add alternative names for dummy0:  
>> 
>> $ ip link altname add dummy0 name someothername
>> $ ip link altname add dummy0 name someotherveryveryveryverylongname
>> $ ip link
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>>     altname someothername
>>     altname someotherveryveryveryverylongname
>>   
>> -> Add bridge brx, add it's alternative name and use alternative names to  
>>    do enslavement.
>> 
>> $ ip link add name brx type bridge
>> $ ip link altname add brx name mypersonalsuperspecialbridge
>> $ ip link set someotherveryveryveryverylongname master mypersonalsuperspecialbridge
>> $ ip link
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>>     altname someothername
>>     altname someotherveryveryveryverylongname
>> 4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>>     altname mypersonalsuperspecialbridge
>> 
>> -> Add ipv4 address to the bridge using alternative name:  
>>     
>> $ ip addr add 192.168.0.1/24 dev mypersonalsuperspecialbridge
>> $ ip addr show mypersonalsuperspecialbridge     
>> 4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>>     altname mypersonalsuperspecialbridge
>>     inet 192.168.0.1/24 scope global brx
>>        valid_lft forever preferred_lft forever
>> 
>> -> Delete one of dummy0 alternative names:  
>> 
>> $ ip link altname del someotherveryveryveryverylongname    
>> $ ip link
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop master brx state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>>     altname someothername
>> 4: brx: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>     link/ether 7e:a2:d4:b8:91:7a brd ff:ff:ff:ff:ff:ff
>>     altname mypersonalsuperspecialbridge
>> 
>> TODO:
>> - notifications for alternative names add/removal
>> - sanitization of add/del cmds (similar to get link)
>> - test more usecases and write selftests
>> - extend support for other netlink ifaces (ovs for example)
>> - add sysfs symlink altname->basename?
>> 
>> Jiri Pirko (7):
>>   net: procfs: use index hashlist instead of name hashlist
>>   net: introduce name_node struct to be used in hashlist
>>   net: rtnetlink: add commands to add and delete alternative ifnames
>>   net: rtnetlink: put alternative names to getlink message
>>   net: rtnetlink: unify the code in __rtnl_newlink get dev with the rest
>>   net: rtnetlink: introduce helper to get net_device instance by ifname
>>   net: rtnetlink: add possibility to use alternative names as message
>>     handle
>> 
>>  include/linux/netdevice.h      |  14 ++-
>>  include/uapi/linux/if.h        |   1 +
>>  include/uapi/linux/if_link.h   |   3 +
>>  include/uapi/linux/rtnetlink.h |   7 ++
>>  net/core/dev.c                 | 152 ++++++++++++++++++++++----
>>  net/core/net-procfs.c          |   4 +-
>>  net/core/rtnetlink.c           | 192 +++++++++++++++++++++++++++++----
>>  security/selinux/nlmsgtab.c    |   4 +-
>>  8 files changed, 334 insertions(+), 43 deletions(-)
>> 
>
>You might want to add altname/ object property in sysfs?
>I.e
>   /sys/class/net/eth0/altname/

Sysfs representation is one point on my TODO list.
I didn't look much into this, but yeah, that would work.
I also want to have symlinks altname->basename.

>
