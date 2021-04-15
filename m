Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3C73612FB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 21:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhDOTh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 15:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhDOTh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 15:37:28 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2DAC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 12:37:05 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so18533969otf.12
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 12:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2h3gtROlhSI143KNqPyfwPqrjs1J1mGE+cG873AbRSM=;
        b=LkSPGUcyAZiTb3NJgvYe3hV2zD4xx8XEM1g0D584kWeJD+GujxFpu9i/AapjIt1vOM
         Pk8WGom7fP3UScn8z5vGXMgiMCnVVX5Hs+4NO0WuLUPAaTgquPNXnS9Pfd9JeMtXmGOZ
         bhZ8EOITccbzI2L60yHUu7ZFr5Hi7G83R2Y2KFn3MjeZodN8iPzSNKBgYcTzZSqjOyX0
         1o8YcjbeiuIKo71cC6o5s0w7lQIppVFX1tNiiJuPMm8FImtKVQXQjbrqdViVfFoof5if
         WTCT37ei13G00T0qlmw9VNXN5tJLDVOfCG8T6GTn5/uEWG8pTCJTaRjd8Zeo3txJhAC7
         qI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2h3gtROlhSI143KNqPyfwPqrjs1J1mGE+cG873AbRSM=;
        b=aAIVpRnIEQso/Orl/PlTNBP8OcVsw2BstYJXlwiHDPmgK5XTeZz0jdEVpZc8xUdS4T
         iUg3UVA8KOzEB21C5lnOOM6XhZfte86Hl3g4bSXc1pwPlmDQrsT19w6CyQozhJ339IBI
         guTWmVYByh8xkvx8M+YBY+PpUzkKlEoMXidiOz8uNuO3v+72NwAJbeiV6+hasXmVo90E
         4tKdpdqWfCh4o7lehNTVa7AKyRkIc+JDi59U9gtyawGP4zILf4Bv8jAgo5FS9/9EZM/Y
         vfDdxNzuYAXBDl2HsnCiiMk6MYZFaF8L6dDRnCIUS3O5Atn+5e9giFhxeq7otBHOimSB
         AyRw==
X-Gm-Message-State: AOAM532p3lPvbzzFwGTI8/NlpnXcQUOpomtBzUtf5zxxTRGfebwq4wIw
        91pWu7E5xLiuYd4A0RIjpXs=
X-Google-Smtp-Source: ABdhPJxasqREV14l/+zn7uvWKI0y8aRCvuoJbgrvwtwKuFQhWVwtAChs+d/H+SQ8o87ymi0NRRy/tA==
X-Received: by 2002:a9d:4713:: with SMTP id a19mr653678otf.71.1618515424419;
        Thu, 15 Apr 2021 12:37:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id j2sm738328oii.38.2021.04.15.12.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 12:37:03 -0700 (PDT)
Subject: Re: XFRM programming with VRF enslaved interfaces
To:     Rob Dover <Rob.Dover@metaswitch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>
References: <DM5PR0201MB3527C144EC33D8E6519A7484814D9@DM5PR0201MB3527.namprd02.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd1ced20-899d-56a7-d01d-e62a15d04d2c@gmail.com>
Date:   Thu, 15 Apr 2021 12:37:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <DM5PR0201MB3527C144EC33D8E6519A7484814D9@DM5PR0201MB3527.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Ben ]

On 4/15/21 9:51 AM, Rob Dover wrote:
> Hi there,
> 
> I'm working on an application that's programming IPSec connections via XFRM on VRFs. I'm seeing some strange behaviour in cases where there is an enslaved interface on the VRF - was wondering if anyone has seen something like this before or perhaps knows how this is supposed to work? 

Ben was / is looking at ipsec and VRF. Maybe he has some thoughts.

> 
> In our setup, we have a VRF and an enslaved (sidebar: should I be using a different term for this? I would prefer to use something with fewer negative historic connotations if possible!) interface like so:

for the sidebar, you can just say that a netdev is a member of the L3
domain. iproute2 supports 'vrf' keyword for better user semantics than
'master'


Any chance you can create a shell script that creates your setup using
network namespaces?

tools/testing/selftests/net/fcnal-test.sh has some helpers --
create_vrf, create_ns and connect_ns -- which simplify the 'namespace as
a node' concept and configuring the interconnects.

A standalone script would allow runs across kernel versions and make it
easier for others (me) to debug.


> 
> ```
> # ip link show vrf-1
> 33: vrf-1: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 2a:71:ba:bd:33:4d brd ff:ff:ff:ff:ff:ff 
> 
> # ip link show master vrf-1
> 32: serv1: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master vrf-1 state UP mode DEFAULT group default qlen 1000
>     link/ether 00:13:3e:00:16:68 brd ff:ff:ff:ff:ff:ff
> ```
> 
> The serv1 interface has some associated IPs but the vrf-1 interface does not:
> 
> ```
> # ip addr show dev vrf-1
> 33: vrf-1: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP group default qlen 1000
>     link/ether 2a:71:ba:bd:33:4d brd ff:ff:ff:ff:ff:ff 
> 
> # ip addr show dev serv1
> 32: serv1: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master vrf-1 state UP group default qlen 1000
>     link/ether 00:13:3e:00:16:68 brd ff:ff:ff:ff:ff:ff
>     inet 10.248.0.191/16 brd 10.248.255.255 scope global serv1
>        valid_lft forever preferred_lft forever
>     inet 10.248.0.250/16 brd 10.248.255.255 scope global secondary serv1
>        valid_lft forever preferred_lft forever
>     inet6 fd5f:5d21:845:1401:213:3eff:fe00:1668/64 scope global
>        valid_lft forever preferred_lft forever
>     inet6 fe80::213:3eff:fe00:1668/64 scope link
>        valid_lft forever preferred_lft forever
> ```
> 
> We're trying to program XFRM using these addresses to send and receive IPSec traffic in transport mode. The interesting question is which interface the XFRM state should be programmed on. I started off by programming the following policies and SAs on the VRF:
> 
> ```
> # ip xfrm policy show
> src 10.254.13.16/32 dst 10.248.0.191/32 sport 37409 dport 5080 dev vrf-1
>         dir in priority 2147483648 ptype main
>         tmpl src 0.0.0.0 dst 0.0.0.0
>                 proto esp reqid 0 mode transport 
> src 10.248.0.191/32 dst 10.254.13.16/32 sport 16381 dport 37409 dev vrf-1
>         dir out priority 2147483648 ptype main
>         tmpl src 0.0.0.0 dst 0.0.0.0
>                 proto esp reqid 0 mode transport 
> # ip xfrm state show 
> src 10.254.13.16 dst 10.248.0.191
>         proto esp spi 0x03a0392c reqid 3892838400 mode transport
>         replay-window 0
>         auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
>         enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab9889
>         anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
>         sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 37409 dport 5080 dev vrf-1 
> src 10.248.0.191 dst 10.254.13.16
>         proto esp spi 0x00124f80 reqid 0 mode transport
>         replay-window 0
>         auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
>         enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab9889
>         anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
>         sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 16381 dport 37409 dev vrf-1
> ```
> 
> Having programmed these, I can then send ESP packets from 10.254.13.16:37409 -> 10.248.0.191:5080 and they are successfully decoded and passed up to my application. However, when I try to send UDP packets out again from 10.248.0.191:16381 -> 10.254.13.16:37409, the packets are not encrypted but sent out in the clear!
> 
> Now, I've done some experimentation and found that if I program the outbound XFRM policy (eg. 10.248.0.191->10.254.13.16) to be on serv1 rather than vrf-1, the packets are correctly encrypted. But if I program the inbound XFRM policy (eg. 10.254.13.16->10.248.0.191) to be on serv1 rather than vrf-1, the inbound packets are not passed up to my application! That leaves me in a situation where I need to program the inbound and outbound XFRM policies asymmetrically in order to get my traffic to be sent properly, like so:
> 
> ```
> # ip xfrm policy show
> src 10.254.13.16/32 dst 10.248.0.191/32 sport 37409 dport 5080 dev vrf-1
>         dir in priority 2147483648 ptype main
>         tmpl src 0.0.0.0 dst 0.0.0.0
>                 proto esp reqid 0 mode transport 
> src 10.248.0.191/32 dst 10.254.13.16/32 sport 16381 dport 37409 dev serv1
>         dir out priority 2147483648 ptype main
>         tmpl src 0.0.0.0 dst 0.0.0.0
>                 proto esp reqid 0 mode transport 
> # ip xfrm state show 
> src 10.254.13.16 dst 10.248.0.191
>         proto esp spi 0x03a0392c reqid 3892838400 mode transport
>         replay-window 0
>         auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
>         enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab9889
>         anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
>         sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 37409 dport 5080 dev vrf-1 
> src 10.248.0.191 dst 10.254.13.16
>         proto esp spi 0x00124f80 reqid 0 mode transport
>         replay-window 0
>         auth-trunc hmac(md5) 0x00112233445566778899aabbccddeeff 96
>         enc cbc(des3_ede) 0xfeefdccdbaab98897667544532231001feefdccdbaab9889
>         anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
>         sel src 0.0.0.0/0 dst 0.0.0.0/0 sport 16381 dport 37409 dev serv1
> ```
> 
> It feels like I'm doing something wrong here - the asymmetrical programming of the interfaces doesn't seem like the 'correct' approach. Seems like there are three possibilities: 
> (a) this is standard behaviour, I just have to live with it (although maybe there are some tweaks I can make to settings to change things?),
> (b) somewhere along the line the way the application is passing packets down to the kernel is incorrect and that's what's causing the mismatch,
> (c) this is a bug in how the kernel works and it's not attributing the packets to the appropriate interface.
> 
> Any idea which of these is the right answer?
> 
> I'm running with the kernel that ships with Centos8 (4.18.0-240.1.1), so I know I'm a bit out of date! But I've done a trawl through recent changes to the kernel code in this area and I can't see anything that would have obviously changed the behaviour I'm seeing (feel free to correct me if I've missed something!).
> 
> Thanks for your help,
> Rob Dover
> 

