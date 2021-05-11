Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC13C37AFE1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhEKUED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 16:04:03 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37741 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhEKUEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 16:04:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 736A65C015A;
        Tue, 11 May 2021 16:02:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 11 May 2021 16:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fYjX4i
        O11k8bNtsYVd27mENS5H+dJPUYVGBYOxd0ZYg=; b=hnn3oemTG8RrYfBVcsYYNi
        w+f/IoQXod2Ru6wnWdhJTU6W7BwYIBf3PffpGpRhOtgFthC/BKa5iF7vtAx5e4+V
        XFznCk0i8RobzHQi/56a0scZNogOyMEXZrCukq6SJSg4eOARCBJOUVVXR/wHhht6
        0XD9wxXIuYhtlgTbWNzslt6a1RT2sb5eSdKysDS4qVzqWGr53IcyGUKVhmqtwdCS
        1vaqdjM5tpCSw0IzMcg1rTruTTKTbrE0NhOMpZ9fskaK9VOXnZyYutlkDeinvcrk
        8OuKpP4U4Ir69uKJrCCASo7EvrBCUfnF1dEd5d9ejI+tp/0mKpxw+EKh/Kk6Tolw
        ==
X-ME-Sender: <xms:7-KaYGQoI4GGIn0YLJrXC3c0G6e225UhvTv1ajFAAtehdDyGG8zMmw>
    <xme:7-KaYLwmaM6VusLQxz3xvYHfBVSDJ6yIDT3jhIgQ1eZDiUnLob6e-FXoXRoffHhFb
    VM46AqHtYBxTA8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehtddgudeghecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7-KaYD2-1Sna9Hjkp5bhQOX3Bx5LBIdNipmRjxAcx5Mj98jmqlVUgw>
    <xmx:7-KaYCA6DGRAwdrgDvJl5Npe9OodCLIXj79D5fSh0NtlaT2NVAHupQ>
    <xmx:7-KaYPhDMScl2E3RqITJTykBsQboHgHGbRYv9DiNX39uSWhYal1YAg>
    <xmx:7-KaYKVu-4jD7h5q3AeVsRzIuiWoQoDf0-ul_t2SpPHj66yBgbXpoA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 11 May 2021 16:02:54 -0400 (EDT)
Date:   Tue, 11 May 2021 23:02:52 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 03/10] ipv4: Add custom multipath hash
 policy
Message-ID: <YJri7JmNKYQED29J@shredder>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-4-idosch@idosch.org>
 <0a199bbf-0ee7-1826-0906-dcfed8c86c7d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a199bbf-0ee7-1826-0906-dcfed8c86c7d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 09:46:27AM -0600, David Ahern wrote:
> On 5/9/21 9:16 AM, Ido Schimmel wrote:
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 9d61e969446e..a4c477475f4c 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -1906,6 +1906,121 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
> >  	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
> >  }
> >  
> > +static u32 fib_multipath_custom_hash_outer(const struct net *net,
> > +					   const struct sk_buff *skb,
> > +					   bool *p_has_inner)
> > +{
> > +	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
> > +	struct flow_keys keys, hash_keys;
> > +
> > +	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
> > +		return 0;
> > +
> > +	memset(&hash_keys, 0, sizeof(hash_keys));
> > +	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
> > +
> > +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
> > +		hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
> > +		hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
> > +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
> > +		hash_keys.ports.src = keys.ports.src;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
> > +		hash_keys.ports.dst = keys.ports.dst;
> > +
> > +	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
> > +	return flow_hash_from_keys(&hash_keys);
> > +}
> > +
> > +static u32 fib_multipath_custom_hash_inner(const struct net *net,
> > +					   const struct sk_buff *skb,
> > +					   bool has_inner)
> > +{
> > +	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
> > +	struct flow_keys keys, hash_keys;
> > +
> > +	/* We assume the packet carries an encapsulation, but if none was
> > +	 * encountered during dissection of the outer flow, then there is no
> > +	 * point in calling the flow dissector again.
> > +	 */
> > +	if (!has_inner)
> > +		return 0;
> > +
> > +	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_MASK))
> > +		return 0;
> > +
> > +	memset(&hash_keys, 0, sizeof(hash_keys));
> > +	skb_flow_dissect_flow_keys(skb, &keys, 0);
> > +
> > +	if (!(keys.control.flags & FLOW_DIS_ENCAPSULATION))
> > +		return 0;
> > +
> > +	if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
> > +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> > +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
> > +			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> > +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
> > +			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> > +	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
> > +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> > +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_IP)
> > +			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
> > +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_IP)
> > +			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
> > +		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_FLOWLABEL)
> > +			hash_keys.tags.flow_label = keys.tags.flow_label;
> > +	}
> > +
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_IP_PROTO)
> > +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_SRC_PORT)
> > +		hash_keys.ports.src = keys.ports.src;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_DST_PORT)
> > +		hash_keys.ports.dst = keys.ports.dst;
> > +
> > +	return flow_hash_from_keys(&hash_keys);
> > +}
> > +
> > +static u32 fib_multipath_custom_hash_skb(const struct net *net,
> > +					 const struct sk_buff *skb)
> > +{
> > +	u32 mhash, mhash_inner;
> > +	bool has_inner = true;
> > +
> 
> Is it not possible to do the dissect once here and pass keys to outer
> and inner functions?
> 
> 	memset(&hash_keys, 0, sizeof(hash_keys));
> 	skb_flow_dissect_flow_keys(skb, &keys, flag);

Not that I'm aware. For outer flow we need to pass
'FLOW_DISSECTOR_F_STOP_AT_ENCAP'. For inner flow, we shouldn't pass any
flags, but make sure encapsulation was encountered by checking
'keys.control.flags & FLOW_DIS_ENCAPSULATION'.

Also, 'struct flow_keys' has keys for a single flow.

> 
> 
> > +	mhash = fib_multipath_custom_hash_outer(net, skb, &has_inner);
> > +	mhash_inner = fib_multipath_custom_hash_inner(net, skb, has_inner);
> > +
> > +	return jhash_2words(mhash, mhash_inner, 0);
> > +}
> > +
> > +static u32 fib_multipath_custom_hash_fl4(const struct net *net,
> > +					 const struct flowi4 *fl4)
> > +{
> > +	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
> > +	struct flow_keys hash_keys;
> > +
> > +	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
> > +		return 0;
> > +
> > +	memset(&hash_keys, 0, sizeof(hash_keys));
> > +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_IP)
> > +		hash_keys.addrs.v4addrs.src = fl4->saddr;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_IP)
> > +		hash_keys.addrs.v4addrs.dst = fl4->daddr;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_IP_PROTO)
> > +		hash_keys.basic.ip_proto = fl4->flowi4_proto;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_SRC_PORT)
> > +		hash_keys.ports.src = fl4->fl4_sport;
> > +	if (hash_fields & FIB_MULTIPATH_HASH_FIELD_DST_PORT)
> > +		hash_keys.ports.dst = fl4->fl4_dport;
> > +
> > +	return flow_hash_from_keys(&hash_keys);
> > +}
> > +
> >  /* if skb is set it will be used and fl4 can be NULL */
> >  int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
> >  		       const struct sk_buff *skb, struct flow_keys *flkeys)
