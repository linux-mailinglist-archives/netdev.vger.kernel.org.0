Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25460C90A2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfJBSSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:18:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55082 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfJBSSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:18:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so8211907wmp.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6+5Jz0QuEJsvcpdSF/39N53Au07XijpgmdlOXOdmHgg=;
        b=n1wGp8NGJEeF4ZlMqWwP4il2hFj0Gh1ctyYcNyHVnWykpSmQOVfKTH3GmWakovpT4U
         1R61z1iu3Y7vdOyY394G8I5FSRFLt49TVhIgwwCKeR+l/hfYZvCplPV9gJoxYFqohxKR
         +lLo06nBD0w7pFYONAeNBTgSk90JdGJFcmhm14jfjji8Z63ohAwdpPVdRtJRJlZvLd5H
         OpDyPVVZfD7EtU/Qqf0S08UZdX4Tpx3YPiUwuH7JseoFPHM94/Z5n2VZbz31391JX8s/
         pI4mTvLqK81R1zxikggpODCaVRCqthHgPGky2hEpbN1treL8Ab2DvHWVZ+QU6iGHgrOh
         PjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6+5Jz0QuEJsvcpdSF/39N53Au07XijpgmdlOXOdmHgg=;
        b=AQk8SvVdV51kq3FHdzZ6jKbdxQY2lwbEDmOdD8dpvx23srxbgsE+QCkuWGRM5ZV8Wn
         LDlP0f/pm07/dS1J0H1p7FZF8QNFka7B/Oh1Dz9iKjOgSnCmzVLsmWWxLIqpOew0Tm4L
         vgnxcoZz4YRvrvrGjexr2lpCT167qR4bG/iwbutliiA7oGQhfxdKp+Qj4wPdmq/gc4eW
         JD1lUBrVe9M4GH1pbTVrWJ0gQBN8aCykUwXBMZeLCj0Rw6wcoSX5Eo0Q2Z5TYUDySqdX
         ACH4TkvuRmC1nU8FzUzAFndJ32DIHnK8bO/zr7jtckM+3Rw1l58XChrUvVxh15RkCL36
         jOaA==
X-Gm-Message-State: APjAAAXlOvVrEjPUr/P3JrLg0FVCYU1W7LSaIXVXeSQO1pbiNvPY8yhs
        duUqugaHSnXakMPSX7xkd9yO5Q==
X-Google-Smtp-Source: APXvYqyNi1Kd99Atp2hp2EwDV86j1ruZaVLzgh+QUS31yQkZcEWcJ3d1h8NR7wKUzjDDg7ywsGFZRQ==
X-Received: by 2002:a1c:60c1:: with SMTP id u184mr3785702wmb.32.1570040280066;
        Wed, 02 Oct 2019 11:18:00 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c4sm249361wru.31.2019.10.02.11.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:17:59 -0700 (PDT)
Date:   Wed, 2 Oct 2019 20:17:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/15] Simplify IPv4 route offload API
Message-ID: <20191002181759.GE2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 10:40:48AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>Today, whenever an IPv4 route is added or deleted a notification is sent
>in the FIB notification chain and it is up to offload drivers to decide
>if the route should be programmed to the hardware or not. This is not an
>easy task as in hardware routes are keyed by {prefix, prefix length,
>table id}, whereas the kernel can store multiple such routes that only
>differ in metric / TOS / nexthop info.
>
>This series makes sure that only routes that are actually used in the
>data path are notified to offload drivers. This greatly simplifies the
>work these drivers need to do, as they are now only concerned with
>programming the hardware and do not need to replicate the IPv4 route
>insertion logic and store multiple identical routes.
>
>The route that is notified is the first FIB alias in the FIB node with
>the given {prefix, prefix length, table ID}. In case the route is
>deleted and there is another route with the same key, a replace
>notification is emitted. Otherwise, a delete notification is emitted.
>
>The above means that in the case of multiple routes with the same key,
>but different TOS, only the route with the highest TOS is notified.
>While the kernel can route a packet based on its TOS, this is not
>supported by any hardware devices I'm familiar with. Moreover, this is
>not supported by IPv6 nor by BIRD/FRR from what I could see. Offload
>drivers should therefore use the presence of a non-zero TOS as an
>indication to trap packets matching the route and let the kernel route
>them instead. mlxsw has been doing it for the past two years.
>
>The series also adds an "in hardware" indication to routes, in addition

I think this might be a separate patchset. I mean patch "ipv4: Replace
route in list before notifying" and above.


>to the offload indication we already have on nexthops today. Besides
>being long overdue, the reason this is done in this series is that it
>makes it possible to easily test the new FIB notification API over
>netdevsim.
>
>To ensure there is no degradation in route insertion rates, I used
>Vincent Bernat's script [1][2] from [3] to inject 500,000 routes from an
>MRT dump from a router with a full view. On a system with Intel(R)
>Xeon(R) CPU D-1527 @ 2.20GHz I measured 8.184 seconds, averaged over 10
>runs and saw no degradation compared to net-next from today.
>
>Patchset overview:
>Patches #1-#7 introduce the new FIB notifications
>Patches #8-#9 convert listeners to make use of the new notifications
>Patches #10-#14 add "in hardware" indication for IPv4 routes, including
>a dummy FIB offload implementation in netdevsim
>Patch #15 adds a selftest for the new FIB notifications API over
>netdevsim
>
>The series is based on Jiri's "devlink: allow devlink instances to
>change network namespace" series [4]. The patches can be found here [5]
>and patched iproute2 with the "in hardware" indication can be found here
>[6].
>
>IPv6 is next on my TODO list.
>
>[1] https://github.com/vincentbernat/network-lab/blob/master/common/helpers/lab-routes-ipvX/insert-from-bgp
>[2] https://gist.github.com/idosch/2eb96efe50eb5234d205e964f0814859
>[3] https://vincent.bernat.ch/en/blog/2017-ipv4-route-lookup-linux
>[4] https://patchwork.ozlabs.org/cover/1162295/
>[5] https://github.com/idosch/linux/tree/fib-notifier
>[6] https://github.com/idosch/iproute2/tree/fib-notifier
>
>Ido Schimmel (15):
>  ipv4: Add temporary events to the FIB notification chain
>  ipv4: Notify route after insertion to the routing table
>  ipv4: Notify route if replacing currently offloaded one
>  ipv4: Notify newly added route if should be offloaded
>  ipv4: Handle route deletion notification
>  ipv4: Handle route deletion notification during flush
>  ipv4: Only Replay routes of interest to new listeners
>  mlxsw: spectrum_router: Start using new IPv4 route notifications
>  ipv4: Remove old route notifications and convert listeners
>  ipv4: Replace route in list before notifying
>  ipv4: Encapsulate function arguments in a struct
>  ipv4: Add "in hardware" indication to routes
>  mlxsw: spectrum_router: Mark routes as "in hardware"
>  netdevsim: fib: Mark routes as "in hardware"
>  selftests: netdevsim: Add test for route offload API
>
> .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   4 -
> .../ethernet/mellanox/mlxsw/spectrum_router.c | 152 ++-----
> drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
> drivers/net/netdevsim/fib.c                   | 263 ++++++++++-
> include/net/ip_fib.h                          |   5 +
> include/uapi/linux/rtnetlink.h                |   1 +
> net/ipv4/fib_lookup.h                         |  18 +-
> net/ipv4/fib_semantics.c                      |  30 +-
> net/ipv4/fib_trie.c                           | 223 ++++++++--
> net/ipv4/route.c                              |  12 +-
> .../drivers/net/netdevsim/fib_notifier.sh     | 411 ++++++++++++++++++
> 11 files changed, 938 insertions(+), 185 deletions(-)
> create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifier.sh
>
>-- 
>2.21.0
>
