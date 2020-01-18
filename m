Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA214164C
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgARHKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:10:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32839 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgARHKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:10:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id d139so10939169wmd.0
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=367/NeAP0+Lqf+D/EYvHIxDahisVyDxJWZ4hWa9Wa+4=;
        b=FfdikP4Be4dxt/T1cZDBis+6jFV6E0VT3Q5L3CK6tyncEOpft9aVTRa08U+eLeVnfO
         O7Ws9m38RVqUunjtwh7OTM1DGboh5cftfOzj+c+Vlq1KriJsU27M/nwOM3qJJoUyUoOk
         Hii+S36yUk+fC7dJfM6vx7c7o32y0jn/SDzbS8RAZe41/Q3eBWqajx/okTUq/gOJdLcc
         OKaGZUuWyh6rHlVcCQP8EhXzLESK1r5EnttilwgU2jftHEsrGgOcup47hdMcPXrPKLvl
         sBqBmv6B1iPy56/28ATsKgC1zmJLTSZpeeV7PQSiSHhVKgNxK5YzjBWOR61ZtWwGrhLn
         BBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=367/NeAP0+Lqf+D/EYvHIxDahisVyDxJWZ4hWa9Wa+4=;
        b=OAaufje9hf/IowV/tMV4AIcL1Gk2B6mvpDCleG3B9Mxc/pgdW0EtGkEZxkaV/Id12R
         LlhZU1NWUQrV45e+QwLOAHI2iako1AG9KpZr6KbxD+w8nMpNCKU4KRMqrvG46UwuLB9x
         E84ObVqumcFKiAL0ioQuTef0qq2VR6O4vZRHIArt7TVfzeI6IldS70Z5v2US/AbpZ/uj
         /emetGcAJviGWv6HPWVZrfnSX379AwAQYRrkiE2ZHKSjto63vWnR5dIVWpZUULekWIJ1
         D7t3VqCkjC6joQFfrz7SLA1Ht+BfFs7dX9O9R3bs3eWzeNq6Hm5Q1gJn8RfzwYrKzvjs
         2yZg==
X-Gm-Message-State: APjAAAWm7zigg8WgHeCjNLvDc/RGKTUaghwEWDZprypSx7HiIg+vZegZ
        A/EXTlpNlGWaIfYDHqy47SDP5w==
X-Google-Smtp-Source: APXvYqzcpAgeEbyb+V1kbmHNrCGZm9Lr0cx1vPN+QU+rtvunmHg/EA5njS/F9MGfM/5/FvTFq7h5bg==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr8392006wme.90.1579331415141;
        Fri, 17 Jan 2020 23:10:15 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id s128sm13320838wme.39.2020.01.17.23.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 23:10:14 -0800 (PST)
Date:   Sat, 18 Jan 2020 08:10:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [RFC net-next PATCH] ipv6: New define for reoccurring code
Message-ID: <20200118071013.GL2131@nanopsycho>
References: <20200117215642.2029945-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117215642.2029945-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 17, 2020 at 10:56:42PM CET, jeffrey.t.kirsher@intel.com wrote:
>Through out the kernel, sizeof() is used to determine the size of the IPv6
>address structure, so create a define for the commonly used code.
>
>s/sizeof(struct in6_addr)/ipv6_addr_size/g
>
>This is just a portion of the instances in the kernel and before cleaning
>up all the occurrences, wanted to make sure that this was a desired change
>or if this obfuscates the code.
>
>Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>---
> include/uapi/linux/in6.h                       |  1 +
> net/core/filter.c                              |  2 +-
> net/core/pktgen.c                              |  2 +-
> net/ipv6/addrconf.c                            | 14 +++++++-------
> net/ipv6/addrlabel.c                           |  2 +-
> net/ipv6/exthdrs.c                             |  4 ++--
> net/ipv6/fib6_rules.c                          |  6 +++---
> net/ipv6/ila/ila_lwt.c                         |  2 +-
> net/ipv6/ip6_gre.c                             | 18 +++++++++---------
> net/ipv6/ip6_output.c                          |  2 +-
> net/ipv6/ip6_tunnel.c                          | 14 +++++++-------
> net/ipv6/ip6_vti.c                             | 14 +++++++-------
> net/ipv6/ip6mr.c                               | 10 +++++-----
> net/ipv6/ipcomp6.c                             |  4 ++--
> net/ipv6/ndisc.c                               |  4 ++--
> net/ipv6/netfilter/ip6t_rpfilter.c             |  2 +-
> net/ipv6/netfilter/ip6t_srh.c                  |  4 ++--
> net/ipv6/netfilter/nft_dup_ipv6.c              |  2 +-
> net/ipv6/seg6.c                                |  4 ++--
> net/ipv6/seg6_iptunnel.c                       |  4 ++--
> net/ipv6/seg6_local.c                          | 12 ++++++------
> net/ipv6/sit.c                                 |  4 ++--
> net/openvswitch/conntrack.c                    |  4 ++--
> net/openvswitch/flow_netlink.c                 |  4 ++--
> net/sched/cls_flower.c                         | 16 ++++++++--------
> net/socket.c                                   |  2 +-
> security/selinux/netnode.c                     |  2 +-
> tools/lib/traceevent/event-parse.c             |  2 +-
> tools/testing/selftests/bpf/test_sock_addr.c   |  2 +-
> .../networking/timestamping/txtimestamp.c      |  2 +-
> 30 files changed, 83 insertions(+), 82 deletions(-)
>
>diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
>index 9f2273a08356..24547a51e715 100644
>--- a/include/uapi/linux/in6.h
>+++ b/include/uapi/linux/in6.h
>@@ -44,6 +44,7 @@ struct in6_addr {
> #define s6_addr32		in6_u.u6_addr32
> #endif
> };
>+#define ipv6_addr_size		sizeof(struct in6_addr)

Shouldn't it be rather "in6_addr_size" to be aligned with the struct
name? Also, as it is a define shouldn't it be rather "IN6_ADDR_SIZE"?

[...]
