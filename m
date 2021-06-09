Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486C73A08EE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhFIBTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:19:45 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:39425 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFIBTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 21:19:44 -0400
Received: by mail-ot1-f41.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so21203161otu.6;
        Tue, 08 Jun 2021 18:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fkNB6uxxS1NeSmXOEZIqWDl1MSy6K7aoh4bmsCB77t0=;
        b=h6ZQ4wyQxQgRQ0EwpcfJ1igugD56Kgq+1j9mdx3FLzXglzLiveXo14QzxnOJT08ca7
         rZcVe2CrTEN0Ut7HSC1JcW7dV5nwFub/IXVhbIBG4fShDJzqcyKeyJW/iYC45xVoEzvB
         rDCAomGM1VV4xzVpdn5u9XafyhxnNikJrYAhcREqDlriZJeNP9Ir35DQ6Bg2BNhvXqI5
         2MzDPod2jdIVL+1ueREioZdzqh9XJ8kVPvohfhkynsZkAvT4B8qM53lfsECEdegxQ4LE
         z3/ve2k4HPmIQcjRZvKZ48Rf/Ynd6Y1zJ1e9RLXdo0xt7wgvzrAIpYM6oKBiID5WFcwH
         FSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fkNB6uxxS1NeSmXOEZIqWDl1MSy6K7aoh4bmsCB77t0=;
        b=UCRLLTtCsrvPgP6oIwpHsfy5VtV4ZNYpWsmkFk075TGL/1s8BuAQYCIzSgpMMysTyB
         QHW4a6Tj2TZj91jruQggc8o3N4Qfg+wNF45gAlv91abFjNArJlxSF3fNPl1k1EuNIdVJ
         ms36nNYzB0ee5fj//I9Pq7iIWT2BQFIwoQH3daoNvlGa+GLBu8PcNxlmEEK7vuWaWTXF
         Z+zeS/KlplMF0PDAbEdlZDlHCo8Zi568fuAe2AgsbCyE/B1JpXa8QaYDYeTpgtqWiqvP
         xqNfJt+4+YMvQu4EwamnNiwoHVRZkB66/4qdwtyRzMzi/E3+O8MCeE/8/yw8o9wareub
         rjwQ==
X-Gm-Message-State: AOAM531g2PoKOtx6g9ZuZF9K7ATgsrTyGjkgzvTt781qE60762KENBcG
        2sm5FIGEsGGEMHVJLUkLyIw=
X-Google-Smtp-Source: ABdhPJxx0fMyyDYlSDDEd2V3hnbuTmAdoRRS44aHFsPrsWnfE58uN9jkudv4UHdZSCtZR8IWEroWYA==
X-Received: by 2002:a9d:443:: with SMTP id 61mr14893387otc.305.1623201394567;
        Tue, 08 Jun 2021 18:16:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id m6sm3444886ots.74.2021.06.08.18.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 18:16:34 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] selftests: seg6: add selftest for SRv6
 End.DT46 Behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210608104017.21181-1-andrea.mayer@uniroma2.it>
 <20210608104017.21181-3-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05849360-7608-f160-e921-8f08fe40bee9@gmail.com>
Date:   Tue, 8 Jun 2021 19:16:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608104017.21181-3-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/21 4:40 AM, Andrea Mayer wrote:
> this selftest is designed for evaluating the new SRv6 End.DT46 Behavior
> used, in this example, for implementing IPv4/IPv6 L3 VPN use cases.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> ---
>  .../selftests/net/srv6_end_dt46_l3vpn_test.sh | 573 ++++++++++++++++++
>  1 file changed, 573 insertions(+)
>  create mode 100755 tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
> 
> diff --git a/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
> new file mode 100755
> index 000000000000..d1e156433b98
> --- /dev/null
> +++ b/tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
> @@ -0,0 +1,573 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# author: Andrea Mayer <andrea.mayer@uniroma2.it>
> +# author: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> +
> +# This test is designed for evaluating the new SRv6 End.DT46 Behavior used for
> +# implementing IPv4/IPv6 L3 VPN use cases.
> +#
> +# The current SRv6 code in the Linux kernel only implements SRv6 End.DT4 and
> +# End.DT6 Behaviors which can be used respectively to support IPv4-in-IPv6 and
> +# IPv6-in-IPv6 VPNs. With End.DT4 and End.DT6 it is not possible to create a
> +# single SRv6 VPN tunnel to carry both IPv4 and IPv6 traffic.
> +# The SRv6 End.DT46 Behavior implementation is meant to support the
> +# decapsulation of IPv4 and IPv6 traffic coming from a single SRv6 tunnel.
> +# Therefore, the SRv6 End.DT46 Behavior in the Linux kernel greatly simplifies
> +# the setup and operations of SRv6 VPNs.
> +#
> +# Hereafter a network diagram is shown, where two different tenants (named 100
> +# and 200) offer IPv4/IPv6 L3 VPN services allowing hosts to communicate with
> +# each other across an IPv6 network.
> +#
> +# Only hosts belonging to the same tenant (and to the same VPN) can communicate
> +# with each other. Instead, the communication among hosts of different tenants
> +# is forbidden.
> +# In other words, hosts hs-t100-1 and hs-t100-2 are connected through the
> +# IPv4/IPv6 L3 VPN of tenant 100 while hs-t200-3 and hs-t200-4 are connected
> +# using the IPv4/IPv6 L3 VPN of tenant 200. Cross connection between tenant 100
> +# and tenant 200 is forbidden and thus, for example, hs-t100-1 cannot reach
> +# hs-t200-3 and vice versa.
> +#
> +# Routers rt-1 and rt-2 implement IPv4/IPv6 L3 VPN services leveraging the SRv6
> +# architecture. The key components for such VPNs are: a) SRv6 Encap behavior,
> +# b) SRv6 End.DT46 Behavior and c) VRF.
> +#
> +# To explain how an IPv4/IPv6 L3 VPN based on SRv6 works, let us briefly
> +# consider an example where, within the same domain of tenant 100, the host
> +# hs-t100-1 pings the host hs-t100-2.
> +#
> +# First of all, L2 reachability of the host hs-t100-2 is taken into account by
> +# the router rt-1 which acts as a arp/ndp proxy.
> +#
> +# When the host hs-t100-1 sends an IPv6 or IPv4 packet destined to hs-t100-2,
> +# the router rt-1 receives the packet on the internal veth-t100 interface. Such
> +# interface is enslaved to the VRF vrf-100 whose associated table contains the
> +# SRv6 Encap route for encapsulating any IPv6 or IPv4 packet in a IPv6 plus the
> +# Segment Routing Header (SRH) packet. This packet is sent through the (IPv6)
> +# core network up to the router rt-2 that receives it on veth0 interface.
> +#
> +# The rt-2 router uses the 'localsid' routing table to process incoming
> +# IPv6+SRH packets which belong to the VPN of the tenant 100. For each of these
> +# packets, the SRv6 End.DT46 Behavior removes the outer IPv6+SRH headers and
> +# performs the lookup on the vrf-100 table using the destination address of
> +# the decapsulated IPv6 or IPv4 packet. Afterwards, the packet is sent to the
> +# host hs-t100-2 through the veth-t100 interface.
> +#
> +# The ping response follows the same processing but this time the role of rt-1
> +# and rt-2 are swapped.
> +#
> +# Of course, the IPv4/IPv6 L3 VPN for tenant 200 works exactly as the IPv4/IPv6
> +# L3 VPN for tenant 100. In this case, only hosts hs-t200-3 and hs-t200-4 are
> +# able to connect with each other.
> +#
> +#
> +# +-------------------+                                   +-------------------+
> +# |                   |                                   |                   |
> +# |  hs-t100-1 netns  |                                   |  hs-t100-2 netns  |
> +# |                   |                                   |                   |
> +# |  +-------------+  |                                   |  +-------------+  |
> +# |  |    veth0    |  |                                   |  |    veth0    |  |
> +# |  |  cafe::1/64 |  |                                   |  |  cafe::2/64 |  |
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
> +# | |  cafe::254/64 |                 |   |                 |  cafe::254/64 | |
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
> +# | +-------+-------+                 |   |                 +-------+-------- |
> +# | |   veth-t200   |                 |   |                 |   veth-t200   | |
> +# | |  cafe::254/64 |                 |   |                 |  cafe::254/64 | |
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
> +# |  |  cafe::3/64 |  |                                   |  |  cafe::4/64 |  |
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
> +# +--------------------------------------------------+
> +# |SID              |Action                          |
> +# +--------------------------------------------------+
> +# |fc00:21:100::6046|apply SRv6 End.DT46 vrftable 100|
> +# +--------------------------------------------------+
> +# |fc00:21:200::6046|apply SRv6 End.DT46 vrftable 200|
> +# +--------------------------------------------------+
> +#
> +# rt-1: VRF tenant 100 (table 100)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |cafe::2    |apply seg6 encap segs fc00:12:100::6046|
> +# +---------------------------------------------------+
> +# |cafe::/64  |forward to dev veth-t100               |
> +# +---------------------------------------------------+
> +# |10.0.0.2   |apply seg6 encap segs fc00:12:100::6046|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth-t100               |
> +# +---------------------------------------------------+
> +#
> +# rt-1: VRF tenant 200 (table 200)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |cafe::4    |apply seg6 encap segs fc00:12:200::6046|
> +# +---------------------------------------------------+
> +# |cafe::/64  |forward to dev veth-t200               |
> +# +---------------------------------------------------+
> +# |10.0.0.4   |apply seg6 encap segs fc00:12:200::6046|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth-t200               |
> +# +---------------------------------------------------+
> +#
> +#
> +# rt-2: localsid table (table 90)
> +# +--------------------------------------------------+
> +# |SID              |Action                          |
> +# +--------------------------------------------------+
> +# |fc00:12:100::6046|apply SRv6 End.DT46 vrftable 100|
> +# +--------------------------------------------------+
> +# |fc00:12:200::6046|apply SRv6 End.DT46 vrftable 200|
> +# +--------------------------------------------------+
> +#
> +# rt-2: VRF tenant 100 (table 100)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |cafe::1    |apply seg6 encap segs fc00:21:100::6046|
> +# +---------------------------------------------------+
> +# |cafe::/64  |forward to dev veth-t100               |
> +# +---------------------------------------------------+
> +# |10.0.0.1   |apply seg6 encap segs fc00:21:100::6046|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth-t100               |
> +# +---------------------------------------------------+
> +#
> +# rt-2: VRF tenant 200 (table 200)
> +# +---------------------------------------------------+
> +# |host       |Action                                 |
> +# +---------------------------------------------------+
> +# |cafe::3    |apply seg6 encap segs fc00:21:200::6046|
> +# +---------------------------------------------------+
> +# |cafe::/64  |forward to dev veth-t200               |
> +# +---------------------------------------------------+
> +# |10.0.0.3   |apply seg6 encap segs fc00:21:200::6046|
> +# +---------------------------------------------------+
> +# |10.0.0.0/24|forward to dev veth-t200               |
> +# +---------------------------------------------------+
> +#
> +

Great description of the test; thanks for adding that documentation.

Acked-by: David Ahern <dsahern@kernel.org>


