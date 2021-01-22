Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7398D3007FE
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbhAVP5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbhAVP4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:56:24 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4FCC06174A;
        Fri, 22 Jan 2021 07:55:44 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n42so5467081ota.12;
        Fri, 22 Jan 2021 07:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lVwBZlqiYAkRijUO0G3Pdgufy3KTr/KU+bLABsRacK0=;
        b=o3cV7KBYdJWHwjHBJpMCzihXhznKL1pW79F6twFp3Vr788Uig3i00AbOCbPit72oYv
         wziGblz8dA+bIKUHN09rqDQeIurEs3dReqCnqMkXO0lhCp4wxaCXZ8sY1P4bPxvUS0vP
         ykOWb0FR+uK7HBwROaw7vbCcrj2sPnXf8PM6h3+6eNuEcWONv2vlrVbcTYZ8WeENlg6u
         fFcdAN0FxgFiGJaEjtDi0RiTeDIZPx6gdMKXcLUSdDwGvxaA2I8BaWZFyGALO+4i4p8U
         BBUN9DCvY5QI1Or8qGcCak9BaO6hgzNlkt9gnK23K8/6KVvw5QUpx4YFdieJlUBNwLRb
         DzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lVwBZlqiYAkRijUO0G3Pdgufy3KTr/KU+bLABsRacK0=;
        b=CBaCXNdBmqqoQ9cf+b1768tvVIPTVuSUljv3oW+QpBDMwvsM0xL2RwK3gYsIQQ/MTd
         R1AL77/x6GxTMf/9cpdqWPUucGO5KYEsTdVciGpCp8TVhHr2e4Ql/kDDngiy/Nuu2v+g
         jXOA9WdAyi1ByIE7ar1tYIB9DEAEEWG4unzI1dIU8bN8RLasJUqr679VaspEUajPkcHR
         47o4vpwygbj8o39kxL1p3N+GEvDTPue6zqHkGVuhhRIWjFyKuyu25XWyBNOzi6oPa3Ac
         wHGIdTUbZn/Ehm+mngwXt9pvgr1so5i0BeJSYbLuZpadqRj928iivDjInoVOOoeaeg7O
         SR8w==
X-Gm-Message-State: AOAM532gCeP0qbhEJsbo7BwUece6S39dMb8tZwI0I6YckkxP4iFcOLQq
        xdH0gJvSSZ3FDRxsQd4O8zs=
X-Google-Smtp-Source: ABdhPJx9oAWwSu666d9+RiZPNbctzTlb8yeHu4vEo52+ZLz0UdxaZBqtC1t4CxdlvDW68G/+B6SkAg==
X-Received: by 2002:a05:6830:796:: with SMTP id w22mr1581370ots.297.1611330944051;
        Fri, 22 Jan 2021 07:55:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id y24sm1672792oos.44.2021.01.22.07.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 07:55:43 -0800 (PST)
Subject: Re: [PATCH v3 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     Praveen Chaudhary <praveen5582@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>
References: <20210119212959.25917-1-pchaudhary@linkedin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1cc9e887-a984-c14a-451c-60a202c4cf20@gmail.com>
Date:   Fri, 22 Jan 2021 08:55:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119212959.25917-1-pchaudhary@linkedin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/21 2:29 PM, Praveen Chaudhary wrote:
> For IPv4, default route is learned via DHCPv4 and user is allowed to change
> metric using config etc/network/interfaces. But for IPv6, default route can
> be learned via RA, for which, currently a fixed metric value 1024 is used.
> 
> Ideally, user should be able to configure metric on default route for IPv6
> similar to IPv4. This fix adds sysctl for the same.
> 
> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> 
> Changes in v1.
> 1.) Correct the call to rt6_add_dflt_router.
> 
> Changes in v2.
> 1.) Replace accept_ra_defrtr_metric to ra_defrtr_metric.
> 2.) Change Type to __u32 instead of __s32.
> 3.) Change description in Documentation/networking/ip-sysctl.rst.
> 4.) Use proc_douintvec instead of proc_dointvec.
> 5.) Code style in ndisc_router_discovery().
> 6.) Change Type to u32 instead of unsigned int.
> 
> Changes in v3:
> 1.) Removed '---' and '```' from description.
> 2.) Remove stray ' after accept_ra_defrtr.
> 3.) Fix tab in net/ipv6/addrconf.c.
> 
> Logs:
> 
> For IPv4:
> 
> Config in etc/network/interfaces:
> auto eth0
> iface eth0 inet dhcp
>     metric 4261413864
> 
> IPv4 Kernel Route Table:
> $ ip route list
> default via 172.21.47.1 dev eth0 metric 4261413864
> 
> FRR Table, if a static route is configured:
> [In real scenario, it is useful to prefer BGP learned default route over DHCPv4 default route.]
> Codes: K - kernel route, C - connected, S - static, R - RIP,
>        O - OSPF, I - IS-IS, B - BGP, P - PIM, E - EIGRP, N - NHRP,
>        T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
>        > - selected route, * - FIB route
> 
> S>* 0.0.0.0/0 [20/0] is directly connected, eth0, 00:00:03
> K   0.0.0.0/0 [254/1000] via 172.21.47.1, eth0, 6d08h51m
> 
> i.e. User can prefer Default Router learned via Routing Protocol in IPv4.
> Similar behavior is not possible for IPv6, without this fix.
> 
> After fix [for IPv6]:
> sudo sysctl -w net.ipv6.conf.eth0.net.ipv6.conf.eth0.ra_defrtr_metric=1996489705
> 
> IP monitor: [When IPv6 RA is received]
> default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  pref high
> 
> Kernel IPv6 routing table
> $ ip -6 route list
> default via fe80::be16:65ff:feb3:ce8e dev eth0 proto ra metric 1996489705 expires 21sec hoplimit 64 pref high
> 
> FRR Table, if a static route is configured:
> [In real scenario, it is useful to prefer BGP learned default route over IPv6 RA default route.]
> Codes: K - kernel route, C - connected, S - static, R - RIPng,
>        O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
>        v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
>        > - selected route, * - FIB route
> 
> S>* ::/0 [20/0] is directly connected, eth0, 00:00:06
> K   ::/0 [119/1001] via fe80::xx16:xxxx:feb3:ce8e, eth0, 6d07h43m
> 
> If the metric is changed later, the effect will be seen only when next IPv6
> RA is received, because the default route must be fully controlled by RA msg.
> Below metric is changed from 1996489705 to 1996489704.
> 
> $ sudo sysctl -w net.ipv6.conf.eth0.ra_defrtr_metric=1996489704
> net.ipv6.conf.eth0.ra_defrtr_metric = 1996489704
> 
> IP monitor:
> [On next IPv6 RA msg, Kernel deletes prev route and installs new route with updated metric]
> 
> Deleted default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489705  expires 3sec hoplimit 64 pref high
> default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 1996489704  pref high
> ---
>  Documentation/networking/ip-sysctl.rst | 12 ++++++++++++
>  include/linux/ipv6.h                   |  1 +
>  include/net/ip6_route.h                |  3 ++-
>  include/uapi/linux/ipv6.h              |  1 +
>  include/uapi/linux/sysctl.h            |  1 +
>  net/ipv6/addrconf.c                    | 10 ++++++++++
>  net/ipv6/ndisc.c                       | 14 ++++++++++----
>  net/ipv6/route.c                       |  5 +++--
>  8 files changed, 40 insertions(+), 7 deletions(-)
> 

LGTM. I can't think of a better way to do this than a sysctl. Shame that
the metric/priority is not an RA option.

Reviewed-by: David Ahern <dsahern@kernel.org>
