Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F00C3735B5
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 09:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhEEHlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 03:41:05 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37727 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEHlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 03:41:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C325A58095A;
        Wed,  5 May 2021 03:40:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 05 May 2021 03:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XGAZ/H
        Ub1ggaRYimKsJOVdJMZycWod7347H73fuhCGY=; b=D1N5qqeiHaEaEHhEL6jiu3
        P2uWIqjr3JjFcPYiEWhGcBB1JNfiecYZ9VQCVuiWLasYA+oHBAwkRbcdDVgK3O03
        SIlP5iPe9TQ30STXOA3auIpgr+GCw9p1Feye6FiqDkMh7RnL3PeTdy3aRYzZeLiB
        nqLvUOS5a6tLdULj9C31IJMF3ckKKWRw9Vt2o9WHuEgH1EU9XvMxedPjg1DUVxLC
        oerpeLFfd5rFAgYhj8QsB8HKysyzQJ0+42fq74EhgGyox6a+iZASx/D5fVFq9ANw
        /xqpZk9jSFoPIDSTEFMP6RXkV+217vJpcmnn4fyCgENncJL9lkrlA3OtsCekKEfA
        ==
X-ME-Sender: <xms:00uSYHUihf4d1QjKyA07Xr7-UqoXKAHac00JGV1BWzWGmkcypb_cmg>
    <xme:00uSYPnldn2lqww0jFJqBtshsyysPUv8naP8SWpUo5M07Y6Ybp0bJ0DLLYESW8G61
    nuXDf3XVH9EioI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:00uSYDb5KSWqMLYB8WYrKAOQV2kK7nEMxeUkrHE1Z53CAOZpwb1iwQ>
    <xmx:00uSYCUMcV9uah9CDZ_aidGfKYXtASMVabQdsHmpszKtwkmIgo5JZQ>
    <xmx:00uSYBkua7gJK8pX1x_tH33qv3xiXSHk-w9k_Q4-YrGnYk3uxUcrTA>
    <xmx:1UuSYCiApZvkqH-2B5PQh7GX7dY1mhzxxUGxrGZfeCZNXIHL1zzcMQ>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:40:02 -0400 (EDT)
Date:   Wed, 5 May 2021 10:39:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 2/9] net: bridge: Disambiguate offload_fwd_mark
Message-ID: <YJJLzr5sJ2FYZRZ4@shredder.lan>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-3-tobias@waldekranz.com>
 <YI6+kQxjCcnYmwkx@shredder>
 <87h7jknqwn.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7jknqwn.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 10:49:12AM +0200, Tobias Waldekranz wrote:
> On Sun, May 02, 2021 at 18:00, Ido Schimmel <idosch@idosch.org> wrote:
> > On Mon, Apr 26, 2021 at 07:04:04PM +0200, Tobias Waldekranz wrote:
> >> - skb->cb->offload_fwd_mark becomes skb->cb->src_hwdom. There is a
> >>   slight change here: Whereas previously this was only set for
> >>   offloaded packets, we now always track the incoming hwdom. As all
> >>   uses where already gated behind checks of skb->offload_fwd_mark,
> >>   this will not introduce any functional change, but it paves the way
> >>   for future changes where the ingressing hwdom must be known both for
> >>   offloaded and non-offloaded frames.
> >
> > [...]
> >
> >> @@ -43,15 +43,15 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
> >>  void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
> >>  			      struct sk_buff *skb)
> >>  {
> >> -	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
> >> -		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
> >> +	if (p->hwdom)
> >> +		BR_INPUT_SKB_CB(skb)->src_hwdom = p->hwdom;
> >>  }
> >
> > I assume you are referring to this change? "src_hwdom" sounds weird if
> > it's expected to be valid for non-offloaded frames.
> 
> Perhaps "non-offloaded" was a sloppy description on my part. I was
> trying to describe frames that originate from a switchdev, but have not
> been forwarded by hardware; e.g. STP BPDUs, IGMP reports, etc. So
> nbp_switchdev_frame_mark now basically says: "If this skb came in from a
> switchdev, make sure to note which one".
> 
> > Can you elaborate about "future changes where the ingressing hwdom must
> > be known both for offloaded and non-offloaded frames"?
> 
> Typical example: The switchdev has a fixed configuration to trap STP
> BPDUs, but STP is not running on the bridge and the group_fwd_mask
> allows them to be forwarded. Say we have this setup:
> 
>       br0
>     /  |  \
> swp0 swp1 swp2
> 
> A BPDU comes in on swp0 and is trapped to the CPU; the driver does not
> set skb->offload_fwd_mark. The bridge determines that the frame should
> be forwarded to swp{1,2}. It is imperative that forward offloading is
> _not_ allowed in this case, as the source hwdom is already "poisoned".
> 
> Recording the source hwdom allows this case to be handled properly.

OK, thanks for the explanation. If it is allowed, then the packet will
be transmitted from swp0, from which it was received.

> 
> > Probably best to split this change to a different patch given the rest
> > of the changes are mechanical.
> 
> Right, but I think the change in name to warrants a change in
> semantics. It is being renamed to src_hwdom because it now holds just
> that information. Again, there is no functional change introduced by
> this since nbp_switchdev_allowed_egress always checks for the presence
> of skb->offload_fwd_mark anyway. But if you feel strongly about it, I
> will split it up.

If you put the explanation above in the changelog, then it should be
fine to keep it as one patch.

> 
> >>  
> >>  bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> >>  				  const struct sk_buff *skb)
> >>  {
> >>  	return !skb->offload_fwd_mark ||
> >> -	       BR_INPUT_SKB_CB(skb)->offload_fwd_mark != p->offload_fwd_mark;
> >> +	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
> >>  }
> >>  
> >>  /* Flags that can be offloaded to hardware */
> >> -- 
> >> 2.25.1
> >> 
