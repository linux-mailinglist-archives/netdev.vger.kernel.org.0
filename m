Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B0352065
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 22:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbhDAUJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 16:09:23 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:35294 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbhDAUJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 16:09:23 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 6694B2016A82;
        Thu,  1 Apr 2021 22:09:21 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 6694B2016A82
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1617307761;
        bh=1qLfIpqlX1fyVGnclmA3s1aggsCPjxmwtaBB1E7dSCM=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=zPkb5ujOHwZg9n9bhSZx7sGa4ozPdUvXDjzeaL1CuHXEkWKsSycO3nUBT0mzwWUbY
         PJlKvHBmOOTLawlpLEUK5UDuphzjp44D9fFYGDSta6QVt/a6si+gjGDZZWXR79dsbO
         OwxmAmMDjj+AG0wXVfk3D2JQ9VVCOw+s5DNRe3p8+XN4CF8IUj3+Rpdtaoc7mJXWmw
         T/UD6n76V0RHx/qgsd6pbAnbw49bb4s5ZQIGH9ih64NOjEJkJeH7rx2HNVeOHTT0wo
         ZPFaHwDBweWgnt67ySRsX9eakzOP7UaSpNaaoEWGG2KpSSiTROmRVzlXKp2CL85T8C
         Ds/JKedS/KqTg==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 52817129EBBA;
        Thu,  1 Apr 2021 22:09:21 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HHaFOhJGsu-C; Thu,  1 Apr 2021 22:09:21 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 293ED129E60C;
        Thu,  1 Apr 2021 22:09:21 +0200 (CEST)
Date:   Thu, 1 Apr 2021 22:09:21 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        Iurman Justin <Justin.Iurman@uliege.be>
Message-ID: <824286239.81720523.1617307761110.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210401182338.24077-1-justin.iurman@uliege.be>
References: <20210401182338.24077-1-justin.iurman@uliege.be>
Subject: Re: [PATCH net-next v3 0/5] Support for the IOAM Pre-allocated
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.200.18.124]
X-Mailer: Zimbra 8.8.15_GA_3980 (ZimbraWebClient - FF87 (Linux)/8.8.15_GA_3980)
Thread-Topic: Support for the IOAM Pre-allocated
Thread-Index: lsblb3+TWs+RDWTNv6vZMlJ8PWcXtw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just noticed that the patchset title has been shortened, don't know what happened... sorry for that. The entire one is "Support for the IOAM Pre-allocated Trace with IPv6".

> v3:
> - Fix warning "unused label 'out_unregister_genl'" by adding conditional macro
> - Fix lwtunnel output redirect bug: dst cache useless in this case, use
>   orig_output instead
> 
> v2:
> - Fix warning with static for __ioam6_fill_trace_data
> - Fix sparse warning with __force when casting __be64 to __be32
> - Fix unchecked dereference when removing IOAM namespaces or schemas
> - exthdrs.c: Don't drop by default (now: ignore) to match the act bits "00"
> - Add control plane support for the inline insertion (lwtunnel)
> - Provide uapi structures
> - Use __net_timestamp if skb->tstamp is empty
> - Add note about the temporary IANA allocation
> - Remove support for "removable" TLVs
> - Remove support for virtual/anonymous tunnel decapsulation
> 
> In-situ Operations, Administration, and Maintenance (IOAM) records
> operational and telemetry information in a packet while it traverses
> a path between two points in an IOAM domain. It is defined in
> draft-ietf-ippm-ioam-data [1]. IOAM data fields can be encapsulated
> into a variety of protocols. The IPv6 encapsulation is defined in
> draft-ietf-ippm-ioam-ipv6-options [2], via extension headers. IOAM
> can be used to complement OAM mechanisms based on e.g. ICMP or other
> types of probe packets.
> 
> This patchset implements support for the Pre-allocated Trace, carried
> by a Hop-by-Hop. Therefore, a new IPv6 Hop-by-Hop TLV option is
> introduced, see IANA [3]. The three other IOAM options are not included
> in this patchset (Incremental Trace, Proof-of-Transit and Edge-to-Edge).
> The main idea behind the IOAM Pre-allocated Trace is that a node
> pre-allocates some room in packets for IOAM data. Then, each IOAM node
> on the path will insert its data. There exist several interesting use-
> cases, e.g. Fast failure detection/isolation or Smart service selection.
> Another killer use-case is what we have called Cross-Layer Telemetry,
> see the demo video on its repository [4], that aims to make the entire
> stack (L2/L3 -> L7) visible for distributed tracing tools (e.g. Jaeger),
> instead of the current L5 -> L7 limited view. So, basically, this is a
> nice feature for the Linux Kernel.
> 
> This patchset also provides support for the control plane part, but only for the
> inline insertion (host-to-host use case), through lightweight tunnels. Indeed,
> for in-transit traffic, the solution is to have an IPv6-in-IPv6 encapsulation,
> which brings some difficulties and still requires a little bit of work and
> discussion (ie anonymous tunnel decapsulation and multi egress resolution).
> 
> - Patch 1: IPv6 IOAM headers definition
> - Patch 2: Data plane support for Pre-allocated Trace
> - Patch 3: IOAM Generic Netlink API
> - Patch 4: Support for IOAM injection with lwtunnels
> - Patch 5: Documentation for new IOAM sysctls
> 
>  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
>  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
>  [3]
>  https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
>  [4] https://github.com/iurmanj/cross-layer-telemetry
> 
> Justin Iurman (5):
>  uapi: IPv6 IOAM headers definition
>  ipv6: ioam: Data plane support for Pre-allocated Trace
>  ipv6: ioam: IOAM Generic Netlink API
>  ipv6: ioam: Support for IOAM injection with lwtunnels
>  ipv6: ioam: Documentation for new IOAM sysctls
> 
> Documentation/networking/ioam6-sysctl.rst |  20 +
> Documentation/networking/ip-sysctl.rst    |   5 +
> include/linux/ioam6.h                     |  13 +
> include/linux/ioam6_genl.h                |  13 +
> include/linux/ioam6_iptunnel.h            |  13 +
> include/linux/ipv6.h                      |   2 +
> include/net/ioam6.h                       |  65 ++
> include/net/netns/ipv6.h                  |   2 +
> include/uapi/linux/in6.h                  |   1 +
> include/uapi/linux/ioam6.h                | 124 +++
> include/uapi/linux/ioam6_genl.h           |  49 ++
> include/uapi/linux/ioam6_iptunnel.h       |  19 +
> include/uapi/linux/ipv6.h                 |   2 +
> include/uapi/linux/lwtunnel.h             |   1 +
> net/core/lwtunnel.c                       |   2 +
> net/ipv6/Kconfig                          |  11 +
> net/ipv6/Makefile                         |   3 +-
> net/ipv6/addrconf.c                       |  20 +
> net/ipv6/af_inet6.c                       |   7 +
> net/ipv6/exthdrs.c                        |  51 ++
> net/ipv6/ioam6.c                          | 872 ++++++++++++++++++++++
> net/ipv6/ioam6_iptunnel.c                 | 273 +++++++
> net/ipv6/sysctl_net_ipv6.c                |   7 +
> 23 files changed, 1574 insertions(+), 1 deletion(-)
> create mode 100644 Documentation/networking/ioam6-sysctl.rst
> create mode 100644 include/linux/ioam6.h
> create mode 100644 include/linux/ioam6_genl.h
> create mode 100644 include/linux/ioam6_iptunnel.h
> create mode 100644 include/net/ioam6.h
> create mode 100644 include/uapi/linux/ioam6.h
> create mode 100644 include/uapi/linux/ioam6_genl.h
> create mode 100644 include/uapi/linux/ioam6_iptunnel.h
> create mode 100644 net/ipv6/ioam6.c
> create mode 100644 net/ipv6/ioam6_iptunnel.c
> 
> --
> 2.17.1
