Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096942A5A43
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgKCWqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbgKCWqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:46:24 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7331CC0613D1;
        Tue,  3 Nov 2020 14:46:24 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id n5so17636486ile.7;
        Tue, 03 Nov 2020 14:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lH5i5uFYniMMbkFnLq314abTav522BASpBwrryyYWwY=;
        b=tT3lywaupetn0TrYjXdzpPpxeD9U/1IlHZPYYir0qeOhE2FYiVW92l943BHtWSbs2v
         Df9YMKONfCDMM1nbDOgjntrym7OaJEdA8+oONqvsOKySS4L9Qw/7MuuZWFfm7/BupbCu
         xbNMTft7hB9pp83NslYC59CPvn1P5Feuxszcb13db+to4mZkXIzpuYTfU/j2W8La/Aiz
         Cr18py9cDYlTKTlt1nWXzElBMaoS4xpysLNjS8O27SXhh6/caIQxDGgm7Zpb4IFA4L0m
         YxDDVJQhVwZG/7dlBxY9QYJxSFPK0Ubj5a++0c0RBoO09xg17u1LlAfAy0TZQlpyOLOU
         UO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lH5i5uFYniMMbkFnLq314abTav522BASpBwrryyYWwY=;
        b=Sf4oakqRG0I4j+dI7WkcwIluxZ/uo8i13m+YjRnlBaPb8QEz7/usoiwihRy2VyMbeN
         NKAEZIM3OafFiKo5QM1qyRSdGAF93ZI/1VAiJcW7qvJI6eM6Vl4F2hbLsmQFpncFLKXo
         hL4MCJI3yyjMq+x2Z7OsovTY0jMRutKrIi6Xoob3A70mj8Vpu3E9/Q/t0EL3mULbE0t4
         oCq2kjbY1UI7BseB+oJFVK3N2K/FV03F1FZWyb2f5dZK1dQPMd34vJ3aKGQeD4CAy3VW
         OmMbYts2xEZ+wj0sn9xNAfEDTUIV8wI8OKtUh1k96iFALEtBVHMwZDxB1vhUfiqSJ8mG
         TtAQ==
X-Gm-Message-State: AOAM531Jc5SZrGXioYpua11EOAjWSQflsAZICBxVrPbctR7gGQVsUn1H
        JIlgiFZ4Vsc0dVYejRhgYcw=
X-Google-Smtp-Source: ABdhPJxiZRwOga+D4mV8ngi2qwi8CBgjbZ/33tzOxuxZ1xcEHzWJMQ+P7ohOYuUCdzNqc2/HDvjSyA==
X-Received: by 2002:a92:ae0e:: with SMTP id s14mr6751881ilh.94.1604443583815;
        Tue, 03 Nov 2020 14:46:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id l18sm94436ioc.31.2020.11.03.14.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 14:46:23 -0800 (PST)
Subject: Re: [net-next,v1,5/5] selftests: add selftest for the SRv6 End.DT4
 behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201103125242.11468-1-andrea.mayer@uniroma2.it>
 <20201103125242.11468-6-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2f11e5f5-7010-36e2-1e9b-800dc76d0091@gmail.com>
Date:   Tue, 3 Nov 2020 15:46:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103125242.11468-6-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 5:52 AM, Andrea Mayer wrote:
> this selftest is designed for evaluating the new SRv6 End.DT4 behavior
> used, in this example, for implementing IPv4 L3 VPN use cases.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  .../selftests/net/srv6_end_dt4_l3vpn_test.sh  | 494 ++++++++++++++++++
>  1 file changed, 494 insertions(+)
>  create mode 100755 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
> 
> diff --git a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
> new file mode 100755
> index 000000000000..a5547fed5048
> --- /dev/null
> +++ b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
> @@ -0,0 +1,494 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# author: Andrea Mayer <andrea.mayer@uniroma2.it>
> +
> +# This test is designed for evaluating the new SRv6 End.DT4 behavior used for
> +# implementing IPv4 L3 VPN use cases.
> +#
> +# Hereafter a network diagram is shown, where two different tenants (named 100
> +# and 200) offer IPv4 L3 VPN services allowing hosts to communicate with each
> +# other across an IPv6 network.
> +#
> +# Only hosts belonging to the same tenant (and to the same VPN) can communicate
> +# with each other. Instead, the communication among hosts of different tenants
> +# is forbidden.
> +# In other words, hosts hs-t100-1 and hs-t100-2 are connected through the IPv4
> +# L3 VPN of tenant 100 while hs-t200-3 and hs-t200-4 are connected using the
> +# IPv4 L3 VPN of tenant 200. Cross connection between tenant 100 and tenant 200
> +# is forbidden and thus, for example, hs-t100-1 cannot reach hs-t200-3 and vice
> +# versa.
> +#
> +# Routers rt-1 and rt-2 implement IPv4 L3 VPN services leveraging the SRv6
> +# architecture. The key components for such VPNs are: a) SRv6 Encap behavior,
> +# b) SRv6 End.DT4 behavior and c) VRF.
> +#
> +# To explain how an IPv4 L3 VPN based on SRv6 works, let us briefly consider an
> +# example where, within the same domain of tenant 100, the host hs-t100-1 pings
> +# the host hs-t100-2.
> +#
> +# First of all, L2 reachability of the host hs-t100-2 is taken into account by
> +# the router rt-1 which acts as an arp proxy.
> +#
> +# When the host hs-t100-1 sends an IPv4 packet destined to hs-t100-2, the
> +# router rt-1 receives the packet on the internal veth-t100 interface. Such
> +# interface is enslaved to the VRF vrf-100 whose associated table contains the
> +# SRv6 Encap route for encapsulating any IPv4 packet in a IPv6 plus the Segment
> +# Routing Header (SRH) packet. This packet is sent through the (IPv6) core
> +# network up to the router rt-2 that receives it on veth0 interface.
> +#
> +# The rt-2 router uses the 'localsid' routing table to process incoming
> +# IPv6+SRH packets which belong to the VPN of the tenant 100. For each of these
> +# packets, the SRv6 End.DT4 behavior removes the outer IPv6+SRH headers and
> +# performs the lookup on the vrf-100 table using the destination address of
> +# the decapsulated IPv4 packet. Afterwards, the packet is sent to the host
> +# hs-t100-2 through the veth-t100 interface.
> +#
> +# The ping response follows the same processing but this time the role of rt-1
> +# and rt-2 are swapped.
> +#
> +# Of course, the IPv4 L3 VPN for tenant 200 works exactly as the IPv4 L3 VPN
> +# for tenant 100. In this case, only hosts hs-t200-3 and hs-t200-4 are able to
> +# connect with each other.
> +#
> +#
> +# +-------------------+                                   +-------------------+
> +# |                   |                                   |                   |
> +# |  hs-t100-1 netns  |                                   |  hs-t100-2 netns  |
> +# |                   |                                   |                   |
> +# |  +-------------+  |                                   |  +-------------+  |
> +# |  |    veth0    |  |                                   |  |    veth0    |  |
> +# |  | 10.0.0.1/24 |  |                                   |  | 10.0.0.2/24 |  |
> +# |  +-------------+  |                                   |  +-------------+  |
> +# |        .          |                                   |         .         |
> +# +-------------------+                                   +-------------------+
> +#          .                                                        .
> +#          .                                                        .
> +#          .                                                        .
> +# +-----------------------------------+   +-----------------------------------+
> +# |        .                          |   |                         .         |
> +# | +---------------+                 |   |                 +---------------- |
> +# | |   veth-t100   |                 |   |                 |   veth-t100   | |
> +# | | 10.0.0.254/24 |    +----------+ |   | +----------+    | 10.0.0.254/24 | |
> +# | +-------+-------+    | localsid | |   | | localsid |    +-------+-------- |
> +# |         |            |   table  | |   | |   table  |            |         |
> +# |    +----+----+       +----------+ |   | +----------+       +----+----+    |
> +# |    | vrf-100 |                    |   |                    | vrf-100 |    |
> +# |    +---------+     +------------+ |   | +------------+     +---------+    |
> +# |                    |   veth0    | |   | |   veth0    |                    |
> +# |                    | fd00::1/64 |.|...|.| fd00::2/64 |                    |
> +# |    +---------+     +------------+ |   | +------------+     +---------+    |
> +# |    | vrf-200 |                    |   |                    | vrf-200 |    |
> +# |    +----+----+                    |   |                    +----+----+    |
> +# |         |                         |   |                         |         |
> +# | +---------------+                 |   |                 +---------------- |
> +# | |   veth-t200   |                 |   |                 |   veth-t200   | |
> +# | | 10.0.0.254/24 |                 |   |                 | 10.0.0.254/24 | |
> +# | +---------------+      rt-1 netns |   | rt-2 netns      +---------------- |
> +# |        .                          |   |                          .        |
> +# +-----------------------------------+   +-----------------------------------+
> +#          .                                                         .
> +#          .                                                         .
> +#          .                                                         .
> +#          .                                                         .
> +# +-------------------+                                   +-------------------+
> +# |        .          |                                   |          .        |
> +# |  +-------------+  |                                   |  +-------------+  |
> +# |  |    veth0    |  |                                   |  |    veth0    |  |
> +# |  | 10.0.0.3/24 |  |                                   |  | 10.0.0.4/24 |  |
> +# |  +-------------+  |                                   |  +-------------+  |
> +# |                   |                                   |                   |
> +# |  hs-t200-3 netns  |                                   |  hs-t200-4 netns  |
> +# |                   |                                   |                   |
> +# +-------------------+                                   +-------------------+
> +#
> +#
> +# ~~~~~~~~~~~~~~~~~~~~~~~~~
> +# | Network configuration |
> +# ~~~~~~~~~~~~~~~~~~~~~~~~~
> +#
> +# rt-1: localsid table (table 90)
> +# +----------------------------------------------+
> +# |SID              |Action                      |
> +# +----------------------------------------------+
> +# |fc00:21:100::6004|apply SRv6 End.DT4 table 100|
> +# +----------------------------------------------+
> +# |fc00:21:200::6004|apply SRv6 End.DT4 table 200|
> +# +----------------------------------------------+
> +#
> +# rt-1: VRF tenant 100 (table 100)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |10.0.0.2   |apply seg6 encap segs fc00:12:100::6004|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth_t100               |
> +# +---------------------------------------------------+
> +#
> +# rt-1: VRF tenant 200 (table 200)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |10.0.0.4   |apply seg6 encap segs fc00:12:200::6004|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth_t200               |
> +# +---------------------------------------------------+
> +#
> +#
> +# rt-2: localsid table (table 90)
> +# +----------------------------------------------+
> +# |SID              |Action                      |
> +# +----------------------------------------------+
> +# |fc00:12:100::6004|apply SRv6 End.DT4 table 100|
> +# +----------------------------------------------+
> +# |fc00:12:200::6004|apply SRv6 End.DT4 table 200|
> +# +----------------------------------------------+
> +#
> +# rt-2: VRF tenant 100 (table 100)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |10.0.0.1   |apply seg6 encap segs fc00:21:100::6004|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth_t100               |
> +# +---------------------------------------------------+
> +#
> +# rt-2: VRF tenant 200 (table 200)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |10.0.0.3   |apply seg6 encap segs fc00:21:200::6004|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth_t200               |
> +# +---------------------------------------------------+
> +#
> +
>

thanks for creating the very well documented test case.

Reviewed-by: David Ahern <dsahern@kernel.org>


