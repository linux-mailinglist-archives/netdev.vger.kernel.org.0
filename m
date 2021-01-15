Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31A52F8339
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbhAOSC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:02:56 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44939 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbhAOSC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:02:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 04BAE9FB;
        Fri, 15 Jan 2021 13:01:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 13:01:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KTvSHC
        yEkVFzSOGimRbR6AVRFF/C+jZdp8/rnIaoUUA=; b=qsKKV+ydPS3ZnW05vx/wsH
        pghiV0+IvpSNSPmss9N+jju0sbkqLygImngsj7+D8a1ZDLkPde5/vihyZ7PTdeOW
        SBxYRrpNmQ71GWKk5nfrPiBTnf+phWhnkQEMXid1zohsIGlK88SUl44yN3ZS6slw
        ra/U6wC+cdMar1ACu/8OTwkV0633ISvMWEOE1CUfwoGoF06lOxromgMpkaLkO4J+
        oUrt/8JiVsysk50Um+Xq2on94QRBzqL0n6/2Z9ucs9ipyQ0N/z8mvOd+8PKlt2Kz
        52BcedoF/NqQsZKQmBUp6UIbjT1LdNotqvd53yOROdF57aXJPQOytO8JPFGz2XoQ
        ==
X-ME-Sender: <xms:jNgBYPMiKaxfrGjvDDfY_SSbOn1PuqBsv0NxQd5Qs-uVlRPIyfIq-w>
    <xme:jNgBYJ60Y51_PyU_rtKBYIYcSy43XD35StpMLagrMjigUH7a9cPwCbArKnerUk401
    VtiNO_ngdxcj6c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jNgBYLLQhr7qpMstXGBBIrsoC0ZnYFrCVFHFREtim-npM9Rgsf3KrQ>
    <xmx:jNgBYLe0qcDPt5V2CM8Rkemlu5oDrgVLHEWH12QmktddWdRZOclwKg>
    <xmx:jNgBYGdlUdoyWHBnJjp8CRtIPVgOEXqzMexDw2pnGpWEABd3bnWvig>
    <xmx:jdgBYHKmdsAGkCyPD_LXrOJU5V494uzKVmmz-pW9-x9tVNUngFsuLQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CC581080067;
        Fri, 15 Jan 2021 13:01:47 -0500 (EST)
Date:   Fri, 15 Jan 2021 20:01:45 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115180145.GA2074023@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210115154357.GA2064789@shredder.lan>
 <20210115165559.GS3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115165559.GS3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 05:55:59PM +0100, Jiri Pirko wrote:
> Fri, Jan 15, 2021 at 04:43:57PM CET, idosch@idosch.org wrote:
> >On Wed, Jan 13, 2021 at 01:12:12PM +0100, Jiri Pirko wrote:
> >> # Create a new netdevsim device, with no ports and 2 line cards:
> >> $ echo "10 0 2" >/sys/bus/netdevsim/new_device
> >> $ devlink port # No ports are listed
> >> $ devlink lc
> >> netdevsim/netdevsim10:
> >>   lc 0 state unprovisioned
> >>     supported_types:
> >>        card1port card2ports card4ports
> >>   lc 1 state unprovisioned
> >>     supported_types:
> >>        card1port card2ports card4ports
> >> 
> >> # Note that driver advertizes supported line card types. In case of
> >> # netdevsim, these are 3.
> >> 
> >> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
> >
> >Why do we need a separate command for that? You actually introduced
> >'DEVLINK_CMD_LINECARD_SET' in patch #1, but it's never used.
> >
> >I prefer:
> >
> >devlink lc set netdevsim/netdevsim10 index 0 state provision type card4ports
> 
> This is misleading. This is actually not setting state. The state gets
> changed upon successful provisioning process. Also, one may think that
> he can set other states, but he can't. I don't like this at all :/

So make state a read-only attribute. You really only care about setting
the type.

To provision:

# devlink lc set netdevsim/netdevsim10 index 0 type card4ports

To unprovsion:

# devlink lc set netdevsim/netdevsim10 index 0 type none

Or:

# devlink lc set netdevsim/netdevsim10 index 0 notype

> 
> 
> >devlink lc set netdevsim/netdevsim10 index 0 state unprovision
> >
> >It is consistent with the GET/SET/NEW/DEL pattern used by other
> >commands.
> 
> Not really, see split port for example. This is similar to that.

It's not. The split command creates new objects whereas this command
modifies an existing object.

> 
> >
> >> $ devlink lc
> >> netdevsim/netdevsim10:
> >>   lc 0 state provisioned type card4ports
> >>     supported_types:
> >>        card1port card2ports card4ports
> >>   lc 1 state unprovisioned
> >>     supported_types:
> >>        card1port card2ports card4ports
> >> $ devlink port
> >> netdevsim/netdevsim10/1000: type eth netdev eni10nl0p1 flavour physical lc 0 port 1 splittable false
> >> netdevsim/netdevsim10/1001: type eth netdev eni10nl0p2 flavour physical lc 0 port 2 splittable false
> >> netdevsim/netdevsim10/1002: type eth netdev eni10nl0p3 flavour physical lc 0 port 3 splittable false
> >> netdevsim/netdevsim10/1003: type eth netdev eni10nl0p4 flavour physical lc 0 port 4 splittable false
> >> #                                                 ^^                    ^^^^
> >> #                                     netdev name adjusted          index of a line card this port belongs to
> >> 
> >> $ ip link set eni10nl0p1 up 
> >> $ ip link show eni10nl0p1   
> >> 165: eni10nl0p1: <NO-CARRIER,BROADCAST,NOARP,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
> >>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
> >> 
> >> # Now activate the line card using debugfs. That emulates plug-in event
> >> # on real hardware:
> >> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
> >> $ ip link show eni10nl0p1
> >> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
> >>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
> >> # The carrier is UP now.
> >> 
> >> Jiri Pirko (10):
> >>   devlink: add support to create line card and expose to user
> >>   devlink: implement line card provisioning
> >>   devlink: implement line card active state
> >>   devlink: append split port number to the port name
> >>   devlink: add port to line card relationship set
> >>   netdevsim: introduce line card support
> >>   netdevsim: allow port objects to be linked with line cards
> >>   netdevsim: create devlink line card object and implement provisioning
> >>   netdevsim: implement line card activation
> >>   selftests: add netdevsim devlink lc test
> >> 
> >>  drivers/net/netdevsim/bus.c                   |  21 +-
> >>  drivers/net/netdevsim/dev.c                   | 370 ++++++++++++++-
> >>  drivers/net/netdevsim/netdev.c                |   2 +
> >>  drivers/net/netdevsim/netdevsim.h             |  23 +
> >>  include/net/devlink.h                         |  44 ++
> >>  include/uapi/linux/devlink.h                  |  25 +
> >>  net/core/devlink.c                            | 443 +++++++++++++++++-
> >>  .../drivers/net/netdevsim/devlink.sh          |  62 ++-
> >>  8 files changed, 964 insertions(+), 26 deletions(-)
> >> 
> >> -- 
> >> 2.26.2
> >> 
