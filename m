Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7977D26653F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgIKQzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:55:19 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:55413 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbgIKPFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:05:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id AC403A53;
        Fri, 11 Sep 2020 11:05:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 11:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EQV7US
        Kk2WY6SYWoY3kUn0asdNYY27ZxgFT7AVvb2B8=; b=HPFVSXr351blRrcyvcLuOo
        22nRtadSULQTW2MsxhEvXwpgvz9fKVoN47byYfa2cCB+Q6XPX1wI5jnDZto7d3UD
        HOCtJ85z9snHuSf/fbIYJwSlSHFB9x3QJKVjMl+W0Kzno9apaAufFeGfWb/Msr8t
        d+qaWUCoBGzTbGvNGPHCkDTz26C+tViZdjWTORRJRxcF69EyMbcP0gJA2ZFHka3w
        G7NCkrpBUszrgJu10kXjqPIB5r6qOIBTgbWVwfT/hF5rNydC76sq2+TVToLzkWW4
        TQN9LntNJzz7LV1XUsdrAQTa63Sj1hihO5Y6NDLkZBPjLlc6P5ryIvc3yP7SzeUA
        ==
X-ME-Sender: <xms:SJJbXwbmQP9zF4xwgdmET-MadBBX7XGoCtsktY6OXnruB0HydJBH3Q>
    <xme:SJJbX7ZwyYbDzohoS7mqx2BaVKIOcEWfzStXV_oT-lSnZVqj-6-cOowpsNqNQbdq_
    RT3wI0Kzqvt9l4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedrudefudenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SJJbX6_ZMBJZh35QehQTDcTd-cqjAEVaK8b__zKxnz8nREuoIaaeow>
    <xmx:SJJbX6pVl1Y5W-a8BGpZUL2tcAZ4k8O9U7pyU6gkdG9Kv1fUnC1ALA>
    <xmx:SJJbX7r5YXaBFiKNI2dPsnvOQPl77x-2pML6EHWOKZe1UAb45wbhzg>
    <xmx:SZJbX6X-VuZKZNAxUZRtRWFMt0gHLBcwMedADyZeMlWvoax6Zw5nDA>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5547D306468A;
        Fri, 11 Sep 2020 11:05:44 -0400 (EDT)
Date:   Fri, 11 Sep 2020 18:05:42 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 08/22] nexthop: vxlan: Convert to new
 notification info
Message-ID: <20200911150542.GD3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-9-idosch@idosch.org>
 <636e2c33-6936-f703-6be9-4cec8aef4b6a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <636e2c33-6936-f703-6be9-4cec8aef4b6a@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 08:58:07AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Convert the sole listener of the nexthop notification chain (the VXLAN
> > driver) to the new notification info.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  drivers/net/vxlan.c | 9 +++++++--
> >  net/ipv4/nexthop.c  | 2 +-
> >  2 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> > index b9fefe27e3e8..29deedee6ef4 100644
> > --- a/drivers/net/vxlan.c
> > +++ b/drivers/net/vxlan.c
> > @@ -4687,9 +4687,14 @@ static void vxlan_fdb_nh_flush(struct nexthop *nh)
> >  static int vxlan_nexthop_event(struct notifier_block *nb,
> >  			       unsigned long event, void *ptr)
> >  {
> > -	struct nexthop *nh = ptr;
> > +	struct nh_notifier_info *info = ptr;
> > +	struct nexthop *nh;
> > +
> > +	if (event != NEXTHOP_EVENT_DEL)
> > +		return NOTIFY_DONE;
> >  
> > -	if (!nh || event != NEXTHOP_EVENT_DEL)
> > +	nh = nexthop_find_by_id(info->net, info->id);
> 
> hmmm.... why add the id to the info versus a nh pointer if a lookup is
> needed?

This goes back to my reasoning in patch #5. I preferred not to pass the
raw nexthop data structures to listeners as they usually have no
business poking into them. I believe the VXLAN driver is the exception
here as it does need access to 'fdb_list'.

> 
> > +	if (!nh)
> >  		return NOTIFY_DONE;
> >  
> >  	vxlan_fdb_nh_flush(nh);
> 
