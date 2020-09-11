Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670B26652D
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgIKQyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:54:43 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53265 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbgIKPGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:06:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B96CA793;
        Fri, 11 Sep 2020 10:40:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 10:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pOdmio
        6h62sSt85c7k/Gi6W3AnXBIQ1MkofEiJ65XVg=; b=ZZSj8+To75n3CaJ+3wzd9R
        ADKwker5YCDO3OGnjk7jt3O4vE/dZAeFTQLBd1DuMl37ylZlcbMvmKVaDLHSMdAY
        qAeZDI/P7eQ7QMHT46nyRPwNi9IDvgt54ugXuVZ8OY6Z6q+xjbPEwFQl9l830c9C
        HgxfwOGCmIdT6u9c8cSUJ/CuM7l7KBdO+hTm3qqM5er1x7uN+Q4T868OLGtpVMum
        yXL4EYMGMOHd8q2rBo4PiVLRZcu7kM/z1kwz+UkkHfiF6BeWO4eU6vXWlsCmZMwP
        Lj5fthuF15cEg+v8UeMsrhGeAcGlfaZCbauMgHkUhFjqsE40gr3iGl6K83cRhMBQ
        ==
X-ME-Sender: <xms:dIxbX9VZkqPi7noKsI_plEBxPxe6dUxWS9QbNPZxf3rA2tmRIHJZ7A>
    <xme:dIxbX9m5V_Ao5826B9v9O62dxLw_4WXEPcUdjmhFs6ZdmoTGOeEkMS0qEF66kkA2D
    W40061j8BiTMW8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedrudefudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:dIxbX5Zvv5_URfOFooTAtUFwjoK5T_F0bm738uVR0KOTX6lJUP9IOw>
    <xmx:dIxbXwWz7jm5QDvZkUUF3sqtZK8x7VOsyuS_JWZfkoUpHTYPvteBMA>
    <xmx:dIxbX3l7WLpZ3P2JXIW9t-Bf5_sR23P5gdLGgPt2vvL2Fbmd07LMuw>
    <xmx:dIxbXwCrIC84v7Fd-GmGOkWmrgnMU9KNxWtyxXnJjvp_6QZMFIx23Q>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F3CF328005A;
        Fri, 11 Sep 2020 10:40:51 -0400 (EDT)
Date:   Fri, 11 Sep 2020 17:40:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 03/22] nexthop: Only emit a notification
 when nexthop is actually deleted
Message-ID: <20200911144048.GA3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-4-idosch@idosch.org>
 <20200908143959.GP2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908143959.GP2997@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 04:39:59PM +0200, Jiri Pirko wrote:
> Tue, Sep 08, 2020 at 11:10:18AM CEST, idosch@idosch.org wrote:
> >From: Ido Schimmel <idosch@nvidia.com>
> >
> >Currently, the delete notification is emitted from the error path of
> >nexthop_add() and replace_nexthop(), which can be confusing to listeners
> >as they are not familiar with the nexthop.
> >
> >Instead, only emit the notification when the nexthop is actually
> >deleted. The following sub-cases are covered:
> 
> Well, in theory, this might break some very odd app that is adding a
> route and checking the errors using this notification. My opinion is to
> allow this breakage to happen, but I'm usually too benevolent :)

There is no uAPI breakage since the patch is only changing the in-kernel
notification. After this patch the in-kernel and RTM_DELNEXTHOP netlink
notifications are both emitted from the same function (i.e.,
remove_nexthop()).

I'll reword the commit message to make it clear.

> 
> 
> >
> >1. User space deletes the nexthop
> >2. The nexthop is deleted by the kernel due to a netdev event (e.g.,
> >   nexthop device going down)
> >3. A group is deleted because its last nexthop is being deleted
> >4. The network namespace of the nexthop device is deleted
> >
> >Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> >---
> > net/ipv4/nexthop.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> >index 13d9219a9aa1..8c0f17c6863c 100644
> >--- a/net/ipv4/nexthop.c
> >+++ b/net/ipv4/nexthop.c
> >@@ -870,8 +870,6 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
> > 	bool do_flush = false;
> > 	struct fib_info *fi;
> > 
> >-	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
> >-
> > 	list_for_each_entry(fi, &nh->fi_list, nh_list) {
> > 		fi->fib_flags |= RTNH_F_DEAD;
> > 		do_flush = true;
> >@@ -909,6 +907,8 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
> > static void remove_nexthop(struct net *net, struct nexthop *nh,
> > 			   struct nl_info *nlinfo)
> > {
> >+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
> >+
> > 	/* remove from the tree */
> > 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
> > 
> >-- 
> >2.26.2
> >
