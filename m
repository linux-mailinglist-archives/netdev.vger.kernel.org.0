Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5816449C54F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiAZIcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:32:01 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45367 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbiAZIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 03:32:00 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AFB3F3200929;
        Wed, 26 Jan 2022 03:31:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 26 Jan 2022 03:32:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QUo6781SxULPMHpoj
        nTNwQpKL0Js0yzIOxH8yB78W9M=; b=GJynzN7jMMXqYICZmRu/KfVyS3Q1xK/jN
        vv7jsQQMsdjvLJps2f93/mRuIFKEcqit17NEXjwN4oNuIO0Ig7U0tX9TfX0LcuZT
        Prj0Fph1ralF6RSNjcxg/vfwKPIk2eEv6ylfY+Bmp1ddIktBCYtQ2azOWs4PVqgP
        gXl2PJGbpeDRS/69km6TspfcmNqIZvxuGHR2NoFZi+z2K5Qh/c6pRGUMRW2Ans3j
        9rnWb9yul9DzrcVKqTxZPga+4tZJVmF8Nj2ZtOAzjoUGsspHAKVifdCZeYbj4PGF
        T5XVBDKOrlcoeWloD5gJ4oqFc5HHCAsecxRgBuX7/Fl3M/4hh+k0g==
X-ME-Sender: <xms:_gbxYcv-RvJCPPFK31F44YE3J3fFN03-E7H-Wo13jlN5DdAhRi-K9A>
    <xme:_gbxYZf6Pia8hqjDwvuV7G-oww2WuK7GVN2PK-9dNmuUYHFKIg4j1DspGeYV7o39z
    0z7cZ-QKTsUMxs>
X-ME-Received: <xmr:_gbxYXy0iMqtCMmejKr5kTMCWPJbncpstpQFjPFdl7PWtRWn4DN63aFmPBv5S0P4VAxtpGMAmHRkpqMnVK1hMLGTSOUYKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfedtgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeekueeukeejfeevtefggfejieetveevudevteehieettdefvdfhueevfeduuddv
    feenucffohhmrghinhepnhgvthifohhrkhdrtgiinecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_gbxYfOsjz3DC4_YvaUEM6MGBWDeSdc5ACe2AvqqD4_Pn7QhU0gO1Q>
    <xmx:_gbxYc-51rH8rZN4UrKvoxsNF0bePXKPoNzKo0YwCu5CPfbEwp1aBw>
    <xmx:_gbxYXWzF_GjzsCpYNuIatVGw1DMsIhRKY9wyz-_sYfhP2VnoiCjuA>
    <xmx:_wbxYbn7xHsl1sSk4h5mxwFtBXAFKDOpuFmP1wZZoZKGMbwBsp2rSw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jan 2022 03:31:58 -0500 (EST)
Date:   Wed, 26 Jan 2022 10:31:54 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Tomas Hlavacek <tmshlvck@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [RFC PATCH] ipv4: fix fnhe dump record multiplication
Message-ID: <YfEG+mWz0vmrNWj3@shredder>
References: <20220120235028.9040-1-tmshlvck@gmail.com>
 <ee82bed1-7033-406d-4738-cab6d0ec8fb6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee82bed1-7033-406d-4738-cab6d0ec8fb6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 09:55:18AM -0700, David Ahern wrote:
> [ cc Stefano and Ido ]
> 
> On 1/20/22 4:50 PM, Tomas Hlavacek wrote:
> > Fix the multiplication of the FNHE records during dump: Check in
> > fnhe_dump_bucket() that the dumped record destination address falls
> > within the key (prefix, prefixlen) of the FIB leaf that is being dumped.
> > 
> > FNHE table records can be dumped multiple times to netlink on RTM_GETROUTE
> > command with NLM_F_DUMP flag - either to "ip route show cache" or to any
> > routing daemon. The multiplication is substantial under specific
> > conditions - it can produce over 120M netlink messages in one dump.
> > It happens if there is one shared struct fib_nh linked through
> > struct fib_info (->fib_nh) from many leafs in FIB over struct fib_alias.
> > 
> > This situation can be triggered by importing a full BGP table over GRE
> > tunnel. In this case there are ~800k routes that translates to ~120k leafs
> > in FIB that all ulimately links the same next-hop (the other end of
> > the GRE tunnel). The GRE tunnel creates one FNHE record for each
> > destination IP that is routed to the tunnel because of PMTU. In my case
> > I had around 1000 PMTU records after a few minutes in a lab connected to
> > the public internet so the FNHE dump produced 120M records that easily
> > stalled BIRD routing daemon as described here:
> > http://trubka.network.cz/pipermail/bird-users/2022-January/015897.html
> > (There is a work-around already committed to BIRD that removes unnecessary
> > dumps of FNHE.)
> > 
> > Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
> > ---
> >  include/net/route.h |  3 ++-
> >  net/ipv4/fib_trie.c |  3 ++-
> >  net/ipv4/route.c    | 25 ++++++++++++++++++++++---
> >  3 files changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/net/route.h b/include/net/route.h
> > index 2e6c0e153e3a..066eab9c5d99 100644
> > --- a/include/net/route.h
> > +++ b/include/net/route.h
> > @@ -244,7 +244,8 @@ void rt_del_uncached_list(struct rtable *rt);
> >  
> >  int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
> >  		       u32 table_id, struct fib_info *fi,
> > -		       int *fa_index, int fa_start, unsigned int flags);
> > +		       int *fa_index, int fa_start, unsigned int flags,
> > +		       __be32 prefix, unsigned char prefixlen);
> >  
> >  static inline void ip_rt_put(struct rtable *rt)
> >  {
> > diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> > index 8060524f4256..7a42db70f46d 100644
> > --- a/net/ipv4/fib_trie.c
> > +++ b/net/ipv4/fib_trie.c
> > @@ -2313,7 +2313,8 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
> >  
> >  		if (filter->dump_exceptions) {
> >  			err = fib_dump_info_fnhe(skb, cb, tb->tb_id, fi,
> > -						 &i_fa, s_fa, flags);
> > +						 &i_fa, s_fa, flags, xkey,
> > +						 (KEYLENGTH - fa->fa_slen));
> >  			if (err < 0)
> >  				goto stop;
> >  		}
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 0b4103b1e622..bc882c85228d 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -3049,10 +3049,25 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
> >  	return -EMSGSIZE;
> >  }
> >  
> > +static int fnhe_daddr_check(__be32 daddr, struct net *net, u32 table_id,
> > +			    __be32 prefix, unsigned char prefixlen)
> > +{
> > +	struct flowi4 fl4 = { .daddr = daddr };
> > +	struct fib_table *tb = fib_get_table(net, table_id);
> > +	struct fib_result res;
> > +	int err = fib_table_lookup(tb, &fl4, &res, FIB_LOOKUP_NOREF);
> 
> I get the fundamental problem you want to solve. I think a fib lookup on
> each nexthop exception for each leaf is a heavyweight solution this is
> going to add up to significant overhead.

I agree

> 
> The fundamental problem you are trying to solve is to not walk the
> exceptions for a fib_info more than once. A fib_info can be used with
> many fib_entries so perhaps the solution is to walk the fib_info structs
> that exist in fib_info_hash outside of the trie walk.

Sounds like a good idea, though I'm not sure how difficult to implement.
If a dump needs to be restarted, then the netlink callback arguments
need to differentiate between the place in the FIB trie where the dump
was stopped and the FIB info hash table.

Also, isn't the problem also present in IPv6 when nexthop objects are
used? In the legacy model, IPv6 nexthops are not shared (which means
exceptions are not dumped multiple times), but with nexthop objects they
can be shared.

> 
> 
> > +
> > +	if (!err && res.prefix == prefix && res.prefixlen == prefixlen)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> >  static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
> >  			    struct netlink_callback *cb, u32 table_id,
> >  			    struct fnhe_hash_bucket *bucket, int genid,
> > -			    int *fa_index, int fa_start, unsigned int flags)
> > +			    int *fa_index, int fa_start, unsigned int flags,
> > +			    __be32 prefix, unsigned char prefixlen)
> >  {
> >  	int i;
> >  
> > @@ -3067,6 +3082,9 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
> >  			if (*fa_index < fa_start)
> >  				goto next;
> >  
> > +			if (!fnhe_daddr_check(fnhe->fnhe_daddr, net, table_id, prefix, prefixlen))
> > +				goto next;
> > +
> >  			if (fnhe->fnhe_genid != genid)
> >  				goto next;
> >  
> > @@ -3096,7 +3114,8 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
> >  
> >  int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
> >  		       u32 table_id, struct fib_info *fi,
> > -		       int *fa_index, int fa_start, unsigned int flags)
> > +		       int *fa_index, int fa_start, unsigned int flags,
> > +		       __be32 prefix, unsigned char prefixlen)
> >  {
> >  	struct net *net = sock_net(cb->skb->sk);
> >  	int nhsel, genid = fnhe_genid(net);
> > @@ -3115,7 +3134,7 @@ int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
> >  		if (bucket)
> >  			err = fnhe_dump_bucket(net, skb, cb, table_id, bucket,
> >  					       genid, fa_index, fa_start,
> > -					       flags);
> > +					       flags, prefix, prefixlen);
> >  		rcu_read_unlock();
> >  		if (err)
> >  			return err;
> 
