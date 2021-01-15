Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451142F7FE9
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbhAOPor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:44:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41635 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727198AbhAOPor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:44:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 02CFC5C01E9;
        Fri, 15 Jan 2021 10:44:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 15 Jan 2021 10:44:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f9YIVE
        6NCOoCcCZtYt93p7Be1ZlVO7Tt8ZT5tMC2470=; b=XuLjh4hvM4RyO4XL2Xa7oY
        +h3Ch0NhnlEQZBMRU3ITJZMSXkDjkjhNyCyXRrEPU/HzOwoNP3qHM4/5gqmFw8Qg
        Rp3lOBF9KoVLF8RnWPLYkd5lpm3Rn8Nfjpv5YoIVrTecHY4r2jszJ03qvLEfWhLj
        DN5siqdqOeeIHlDzme38M8LirHleGjv3yDJYFRuMXwOjet8f3Ou/lQVBlirxJKon
        dKhqgtdeidofIDGVkE+SygdIo96XqudKcE8ambDzc0efizUL4ejQXdoYN9FuibVK
        xcW1n33NQAsnYI8Ms0sKNvxAYu+7I5+mlpLKsTEpoHflss53cYDT+s6O8h9j2G+Q
        ==
X-ME-Sender: <xms:QLgBYL-9UjIRYpPJkP18IdqTgHxTK06vUY5PCBLrUJiRYIWFoOuZ5g>
    <xme:QLgBYJvP6s0Gv_nlLP9l8b9Syi7mXPRbYcEDHVP-0DwF59EE_6mdNXDnHUKlHc2AD
    mLVWKvk48gJy8Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QLgBYCYo2djT5HEHRZrmTMDITcchju2thrDaMLhneCmVI6IpGBqHtQ>
    <xmx:QLgBYJoxtQbP_TwinYxkOn56S0qtZP2y9lYpcejvM0kYWX37bFtD8g>
    <xmx:QLgBYH9nWa3hS2S0nUEYvgvm7IE7hCkynFbAI1yaVt4TGJFRvga9lw>
    <xmx:QbgBYG6R8wfUQccLzhnwKfOuH_B4xEgowd_1wifqsz7N6uNu2d790A>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F0B3108005F;
        Fri, 15 Jan 2021 10:43:59 -0500 (EST)
Date:   Fri, 15 Jan 2021 17:43:57 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115154357.GA2064789@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:12:12PM +0100, Jiri Pirko wrote:
> # Create a new netdevsim device, with no ports and 2 line cards:
> $ echo "10 0 2" >/sys/bus/netdevsim/new_device
> $ devlink port # No ports are listed
> $ devlink lc
> netdevsim/netdevsim10:
>   lc 0 state unprovisioned
>     supported_types:
>        card1port card2ports card4ports
>   lc 1 state unprovisioned
>     supported_types:
>        card1port card2ports card4ports
> 
> # Note that driver advertizes supported line card types. In case of
> # netdevsim, these are 3.
> 
> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports

Why do we need a separate command for that? You actually introduced
'DEVLINK_CMD_LINECARD_SET' in patch #1, but it's never used.

I prefer:

devlink lc set netdevsim/netdevsim10 index 0 state provision type card4ports
devlink lc set netdevsim/netdevsim10 index 0 state unprovision

It is consistent with the GET/SET/NEW/DEL pattern used by other
commands.

> $ devlink lc
> netdevsim/netdevsim10:
>   lc 0 state provisioned type card4ports
>     supported_types:
>        card1port card2ports card4ports
>   lc 1 state unprovisioned
>     supported_types:
>        card1port card2ports card4ports
> $ devlink port
> netdevsim/netdevsim10/1000: type eth netdev eni10nl0p1 flavour physical lc 0 port 1 splittable false
> netdevsim/netdevsim10/1001: type eth netdev eni10nl0p2 flavour physical lc 0 port 2 splittable false
> netdevsim/netdevsim10/1002: type eth netdev eni10nl0p3 flavour physical lc 0 port 3 splittable false
> netdevsim/netdevsim10/1003: type eth netdev eni10nl0p4 flavour physical lc 0 port 4 splittable false
> #                                                 ^^                    ^^^^
> #                                     netdev name adjusted          index of a line card this port belongs to
> 
> $ ip link set eni10nl0p1 up 
> $ ip link show eni10nl0p1   
> 165: eni10nl0p1: <NO-CARRIER,BROADCAST,NOARP,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
> 
> # Now activate the line card using debugfs. That emulates plug-in event
> # on real hardware:
> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
> $ ip link show eni10nl0p1
> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
> # The carrier is UP now.
> 
> Jiri Pirko (10):
>   devlink: add support to create line card and expose to user
>   devlink: implement line card provisioning
>   devlink: implement line card active state
>   devlink: append split port number to the port name
>   devlink: add port to line card relationship set
>   netdevsim: introduce line card support
>   netdevsim: allow port objects to be linked with line cards
>   netdevsim: create devlink line card object and implement provisioning
>   netdevsim: implement line card activation
>   selftests: add netdevsim devlink lc test
> 
>  drivers/net/netdevsim/bus.c                   |  21 +-
>  drivers/net/netdevsim/dev.c                   | 370 ++++++++++++++-
>  drivers/net/netdevsim/netdev.c                |   2 +
>  drivers/net/netdevsim/netdevsim.h             |  23 +
>  include/net/devlink.h                         |  44 ++
>  include/uapi/linux/devlink.h                  |  25 +
>  net/core/devlink.c                            | 443 +++++++++++++++++-
>  .../drivers/net/netdevsim/devlink.sh          |  62 ++-
>  8 files changed, 964 insertions(+), 26 deletions(-)
> 
> -- 
> 2.26.2
> 
