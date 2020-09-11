Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6316726647F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIKQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:40:33 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:40057 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbgIKQk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:40:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 2E4FF6DA;
        Fri, 11 Sep 2020 12:40:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 12:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4x/owW
        xbJBKpWRsYUTE7xrQ0qjO3e5Z65wBY2/mlBws=; b=WjKnoUTUGnXgkzvgVTzZLa
        IrqiJGbO+wZT4fqdcSE7zvKbIL+rAtUio59OVwxDrcYe68O+Ki2Keo81qqz7cgfq
        ciiDAtx8mRFQ9gHa+ZcFJeJdq8GM+BJ/uIlcihIp5X+XmzrO8Y6Z5e0bYA3aep8Q
        U8YEk3tzELcwiav6CJkjZpFiHJUgyNSH0Jjy35o50PJXeR6NIrQgGf0yVBE86evQ
        nOwn+BVeqTWQyU7jmv+6kx1fZ71jUYohnrTyTBVgGXZL+YKImutp+WMg118RdxrH
        A2pPPR9Mkzad9hqJ/ozhi1ai1/XqAQQv06U5T1Sa8KDNusswJo3+rb6wJkx8QQTw
        ==
X-ME-Sender: <xms:eqhbX4sZSQ8AK1meYdclattSXMLiSJcM24vBxRoXkWrqcmu2SUeCBw>
    <xme:eqhbX1feLI0aP7NEzvvrQf72xS4h-MNdDNnZ7cQWcbN2FhKMa7eIeU6ITrzXtWYzo
    kt3JjJ7E6Tb-z4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrfeeirddufedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:eqhbXzwtcc3wa_fR5MrwKonZOrifC5tP_z2ilv8J-KjQztv7fM-IAA>
    <xmx:eqhbX7OWByjfovkoCnEM8eY2H99GsqBbgaHU1Wwy0B-6e7z8nXzqxg>
    <xmx:eqhbX4_A5z_AmZ1c9mI5xAv-QZW6YGPSIFRu_ssqiyTjUJddhHpudQ>
    <xmx:eqhbX3bKqRvAGvzJqEmlhqzfrtv1-YqdFAkYvLaQupB4XbnvRtWxyw>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE57A306467E;
        Fri, 11 Sep 2020 12:40:25 -0400 (EDT)
Date:   Fri, 11 Sep 2020 19:40:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 17/22] nexthop: Replay nexthops when
 registering a notifier
Message-ID: <20200911164023.GJ3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-18-idosch@idosch.org>
 <8191326b-0656-e7bb-1c94-7beb9097c423@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8191326b-0656-e7bb-1c94-7beb9097c423@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:37:10AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > When registering a new notifier to the nexthop notification chain,
> > replay all the existing nexthops to the new notifier so that it will
> > have a complete picture of the available nexthops.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  net/ipv4/nexthop.c | 54 ++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 52 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index b40c343ca969..6505a0a28df2 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -156,6 +156,27 @@ static int call_nexthop_notifiers(struct net *net,
> >  	return notifier_to_errno(err);
> >  }
> >  
> > +static int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
> > +				 enum nexthop_event_type event_type,
> > +				 struct nexthop *nh,
> > +				 struct netlink_ext_ack *extack)
> > +{
> > +	struct nh_notifier_info info = {
> > +		.net = net,
> > +		.extack = extack,
> > +	};
> > +	int err;
> > +
> > +	err = nh_notifier_info_init(&info, nh);
> > +	if (err)
> > +		return err;
> > +
> > +	err = nb->notifier_call(nb, event_type, &info);
> > +	nh_notifier_info_fini(&info);
> > +
> > +	return notifier_to_errno(err);
> > +}
> > +
> >  static unsigned int nh_dev_hashfn(unsigned int val)
> >  {
> >  	unsigned int mask = NH_DEV_HASHSIZE - 1;
> > @@ -2116,11 +2137,40 @@ static struct notifier_block nh_netdev_notifier = {
> >  	.notifier_call = nh_netdev_event,
> >  };
> >  
> > +static int nexthops_dump(struct net *net, struct notifier_block *nb,
> > +			 struct netlink_ext_ack *extack)
> > +{
> > +	struct rb_root *root = &net->nexthop.rb_root;
> > +	struct rb_node *node;
> > +	int err = 0;
> > +
> > +	for (node = rb_first(root); node; node = rb_next(node)) {
> > +		struct nexthop *nh;
> > +
> > +		nh = rb_entry(node, struct nexthop, rb_node);
> > +		err = call_nexthop_notifier(nb, net, NEXTHOP_EVENT_REPLACE, nh,
> > +					    extack);
> > +		if (err)
> > +			break;
> > +	}
> > +
> > +	return err;
> > +}
> > +
> >  int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
> >  			      struct netlink_ext_ack *extack)
> >  {
> > -	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
> > -						nb);
> > +	int err;
> > +
> > +	rtnl_lock();
> > +	err = nexthops_dump(net, nb, extack);
> 
> can the unlock be moved here? register function below should not need it.

It can result in this unlikely race:

<t0> - rtnl_lock(); nexthops_dump(); rtnl_unlock()
<t1> - Nexthop is added / deleted
<t2> - blocking_notifier_chain_register()

It is possible to flip the order:

<t0> - blocking_notifier_chain_register()
<t1> - rtnl_lock(); nexthops_dump(); rtnl_unlock()

Worst case:

<t0> - blocking_notifier_chain_register()
<t1> - Nexthop is added / deleted
<t2> - rtnl_lock(); nexthops_dump(); rtnl_unlock()

Which is OK. If we get a delete notification for a nexthop we don't
know, we ignore it. If we get two replace notifications for the same
nexthop we just "update" it.

> 
> > +	if (err)
> > +		goto unlock;
> > +	err = blocking_notifier_chain_register(&net->nexthop.notifier_chain,
> > +					       nb);
> > +unlock:
> > +	rtnl_unlock();
> > +	return err;
> >  }
> >  EXPORT_SYMBOL(register_nexthop_notifier);
> >  
> > 
> 
