Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F06C8B5C5
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfHMKjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:39:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38803 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbfHMKjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:39:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DF27B21903;
        Tue, 13 Aug 2019 06:39:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 06:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vSADTg
        YYe70qQvEnQ/VEVEtV1pTHyHREzF3WFn0leMM=; b=Fh2KgJcI+WG2SuFuUFfZme
        DGYQHHjsRtCY4/hJ85HC9KScbN4+RIViEOXU3XFA2govgGqsO1cCFuJSFlwoI2UE
        H6MtIQdzjh+CWil5b5FcSeUjs1xXQyl5OTRzD3nTJoY5fi4M+rSI6itPyCEi6tCt
        F15rVZ1TcbXKrENo59IyX0ab/e5BTXMkL7/n+C3ulDQsJFuf85kIvLOQg0IOMXZ6
        2VWUMRy4eIfefkLr0yuVPOXbsVVRvXh0q5nGnm9bcgadIZ6WWH6zUwR6lGmiUi16
        fuOcCddk1VXuCI3YPQTUzZCUBDcm0ywineMAwfQ37CiiIvtHecfOMpsabSxfVJQg
        ==
X-ME-Sender: <xms:S5NSXeMlocT34LgiKCWWWf4Lu9njqeq0id5wJznknF9ZOYANZZTsMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:S5NSXVuvE-WPysq5vrVVWc7no_GkwVGnf7qvkLkmrst7s1TGVME6OQ>
    <xmx:S5NSXT-LcBVtipqanC6PM4BlcwZyeKXPB9nnf30fuVnjF_gZDKWAig>
    <xmx:S5NSXRF7NKCrrpXKjCHd79iVV50H1sstTvfYhgkP-C4RXX2y11NiDw>
    <xmx:S5NSXTJDBeuNu77109i3EXujA3ANF7EQyQYLgpJB_wGV0ATmsTEIHw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B920380065;
        Tue, 13 Aug 2019 06:39:06 -0400 (EDT)
Date:   Tue, 13 Aug 2019 13:39:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 4/4] devlink: Add man page for
 devlink-trap
Message-ID: <20190813103904.GA16305@splinter>
References: <20190813083143.13509-1-idosch@idosch.org>
 <20190813083143.13509-5-idosch@idosch.org>
 <20190813102037.GP2428@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813102037.GP2428@nanopsycho>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 12:20:37PM +0200, Jiri Pirko wrote:
> Tue, Aug 13, 2019 at 10:31:43AM CEST, idosch@idosch.org wrote:
> >From: Ido Schimmel <idosch@mellanox.com>
> >
> >Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> >---
> > man/man8/devlink-monitor.8 |   3 +-
> > man/man8/devlink-trap.8    | 138 +++++++++++++++++++++++++++++++++++++
> > man/man8/devlink.8         |  11 ++-
> > 3 files changed, 150 insertions(+), 2 deletions(-)
> > create mode 100644 man/man8/devlink-trap.8
> >
> >diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
> >index 13fe641dc8f5..fffab3a4ce88 100644
> >--- a/man/man8/devlink-monitor.8
> >+++ b/man/man8/devlink-monitor.8
> >@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
> > .I OBJECT-LIST
> > is the list of object types that we want to monitor.
> > It may contain
> >-.BR dev ", " port ".
> >+.BR dev ", " port ", " trap ", " trap-group .
> 
> Looks like "trap-group" is a leftover here, isn't it?

You get events when traps and groups are created / destroyed. See below output
when creating a new netdevsim device:

$ devlink mon trap-group
[trap-group,new] netdevsim/netdevsim20: name l2_drops generic true
[trap-group,new] netdevsim/netdevsim20: name l3_drops generic true
[trap-group,new] netdevsim/netdevsim20: name buffer_drops generic true

$ devlink mon trap
[trap,new] netdevsim/netdevsim10: name source_mac_is_multicast type drop generic true action drop group l2_drops
[trap,new] netdevsim/netdevsim10: name vlan_tag_mismatch type drop generic true action drop group l2_drops
[trap,new] netdevsim/netdevsim10: name ingress_vlan_filter type drop generic true action drop group l2_drops
[trap,new] netdevsim/netdevsim10: name ingress_spanning_tree_filter type drop generic true action drop group l2_drops
[trap,new] netdevsim/netdevsim10: name port_list_is_empty type drop generic true action drop group l2_drops
[trap,new] netdevsim/netdevsim10: name port_loopback_filter type drop generic true action drop group l2_drops
[trap,new] netdevsim/netdevsim10: name fid_miss type exception generic false action trap group l2_drops
[trap,new] netdevsim/netdevsim10: name blackhole_route type drop generic true action drop group l3_drops
[trap,new] netdevsim/netdevsim10: name ttl_value_is_too_small type exception generic true action trap group l3_drops
[trap,new] netdevsim/netdevsim10: name tail_drop type drop generic true action drop group buffer_drops
