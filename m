Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D726622C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIKPaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:30:16 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42605 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgIKP3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:29:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E4899A5C;
        Fri, 11 Sep 2020 11:29:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 11:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jCZ5P3
        xkvWzhCVk9BB+MeKSlQ9cpovY9fKkdl2gJJCo=; b=G3dlTdmApDcH+F35jBddNx
        Pku6JNj7jZIqEu6VVQX8XhxyUD/RmR4mrPAYGnF2YupNDDMxgo26YJFlHmm/pTf7
        Tkr3hR9IPpCZJr16yL2rWTqFtYheeqfrSGnsxmG5+nMSvExg2YvATb/bcWD2ylUv
        txav4q0ahLFldMoc4ZSCSlhJJ2GPaWX/Y82hsr8A9miO1FNSYPwoAh19P5F3eCuM
        IyJwv3r2zBI4jfQQTieqdVU1zR+g/KB9/Nfyc0rNw+sULXe4yNJELUbfYAx+tVp7
        VmCo4mVwp9fcAspMjod7x5bZq/WBXP3q3m7C6OEeIgLI6sIUr5LVYh0Ea6f2XXiQ
        ==
X-ME-Sender: <xms:5ZdbX7gqwvtS1AlgOWb3tz7D3Z-6aaa1OZwXGhG-_p_XJVpNmzGqTA>
    <xme:5ZdbX4Cco91XDMEq4LaFk68LG3u4k4oRbb7D7moL_mZNPxNB9_U-okOgENZg6PfAq
    HFXrChy2PLyo7s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedrudefudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5ZdbX7H6pJrqcQt-HzYjmfYM8cS9dnva0cllJohlL4dGcTwJpXf_oQ>
    <xmx:5ZdbX4Qvie_TttNkIr_VW5nNKAeMEEmb3C99DJP7FqHMU1MaSCRFIA>
    <xmx:5ZdbX4yXDcCUKzrAs6pMT9TKE9moNhu_msuexKhhhcpLbOTw2hus8w>
    <xmx:5ZdbX0-A3Y19qtTCR0CfLWSNz_1cf5WTLC-7t2u-42OUyTY1omZg1A>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id E49E9306467D;
        Fri, 11 Sep 2020 11:29:40 -0400 (EDT)
Date:   Fri, 11 Sep 2020 18:29:39 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 10/22] nexthop: Allow setting "offload" and
 "trap" indications on nexthops
Message-ID: <20200911152939.GF3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-11-idosch@idosch.org>
 <e07b34f5-b36e-b0f7-8f1a-e8a7ae5131ac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e07b34f5-b36e-b0f7-8f1a-e8a7ae5131ac@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:14:37AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Add a function that can be called by device drivers to set "offload" or
> > "trap" indication on nexthops following nexthop notifications.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  include/net/nexthop.h |  1 +
> >  net/ipv4/nexthop.c    | 21 +++++++++++++++++++++
> >  2 files changed, 22 insertions(+)
> > 
> > diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> > index 0bde1aa867c0..4147681e86d2 100644
> > --- a/include/net/nexthop.h
> > +++ b/include/net/nexthop.h
> > @@ -146,6 +146,7 @@ struct nh_notifier_info {
> >  
> >  int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
> >  int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
> > +void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap);
> 
> how about nexthop_set_hw_flags? consistency with current nexthop_get_
> ... naming

Sure. I opted for consistency with fib_alias_hw_flags_set() and
fib6_info_hw_flags_set(), but I'll change to be consistent with nexthop
code.

> 
> >  
> >  /* caller is holding rcu or rtnl; no reference taken to nexthop */
> >  struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index 70c8ab6906ec..71605c612458 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -2080,6 +2080,27 @@ int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
> >  }
> >  EXPORT_SYMBOL(unregister_nexthop_notifier);
> >  
> > +void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap)
> > +{
> > +	struct nexthop *nexthop;
> > +
> > +	rcu_read_lock();
> > +
> > +	nexthop = nexthop_find_by_id(net, id);
> > +	if (!nexthop)
> > +		goto out;
> > +
> > +	nexthop->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
> > +	if (offload)
> > +		nexthop->nh_flags |= RTNH_F_OFFLOAD;
> > +	if (trap)
> > +		nexthop->nh_flags |= RTNH_F_TRAP;
> > +
> > +out:
> > +	rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL(nexthop_hw_flags_set);
> > +
> >  static void __net_exit nexthop_net_exit(struct net *net)
> >  {
> >  	rtnl_lock();
> > 
> 
