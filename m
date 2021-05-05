Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250CA37369F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhEEIvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:51:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54749 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232144AbhEEIvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:51:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F22415C0138;
        Wed,  5 May 2021 04:50:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 05 May 2021 04:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=a0uiHL
        uUs1PiRBzRoMM6D+kcIrhyTQN6pwXX94QsXdM=; b=BXB45fg88oAD5l+gs+p8G4
        mmt0aTOBmgIki10ix+hxeki2Ej5K9go7aEeC8Eiv+wRvy56lXluXxiYVPSwpezni
        IsGG7hBm7q12n47VYgC7uKvJXzef7+fHuxeEJptrY+PQ2S/K7Yv77dy7I0sqx/OO
        iqZ+/NnychNbAqc0ZSgUXW7vsK5LlY/WSQJd4c/DS/Kj9bZKx0GMfqXZ8sSBK9Df
        MmhepsZW75YdDhKAbYJsSkSLwyH78iazJOntYLORPZiBTAajOlflDdY8qwrPbu4d
        QJwYoCS+kDPhYVFNEy0wyAz96Qz82g6JQBxiBnuzCR2tINxaqGxBL77idIUu+2vA
        ==
X-ME-Sender: <xms:W1ySYN0bxtCMpiEryP8UosjkVRYRhb0rT8Ngh-aPFIipNkWb_QR0Wg>
    <xme:W1ySYEGHFH_QR3Lpm3uWiBE5w5FVWB2QWj1xjI96Dcy0BbqX5MceN6yeMx1T5Y6-5
    l-t4Ls8jpQoO9U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W1ySYN5UjpIMunUgvwiyyxFeKL0AqwdiOm4ryLXOPohe08bTE783AA>
    <xmx:W1ySYK0CZUzMMuOAuH2fPkVPI8_MHJSiwz-so1Be4Em2oTyG3S4R3g>
    <xmx:W1ySYAFWKQFUsxR9c-5wpiDyAhf6G3abdL8D9TVZ2W6iKzzM_JcQgA>
    <xmx:W1ySYF4yFrqpCD2QQCbywg8G7H8Dd-Jm7q0Mv_rvwFlsXAH2kAk3wg>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 04:50:35 -0400 (EDT)
Date:   Wed, 5 May 2021 11:50:31 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 07/10] ipv6: Add custom multipath hash policy
Message-ID: <YJJcV1Jp7r6j7hKP@shredder.lan>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-8-idosch@idosch.org>
 <1b0c0460-914c-ffa2-ae42-af0ea12ad596@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b0c0460-914c-ffa2-ae42-af0ea12ad596@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 08:46:18PM -0600, David Ahern wrote:
> On 5/2/21 10:22 AM, Ido Schimmel wrote:
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index 9935e18146e5..b4c65c5baf35 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -2326,6 +2326,125 @@ static void ip6_multipath_l3_keys(const struct sk_buff *skb,
> >  	}
> >  }
> >  
> > +static u32 rt6_multipath_custom_hash_outer(const struct net *net,
> > +					   const struct sk_buff *skb,
> > +					   bool *p_has_inner)
> > +{
> > +	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
> > +	struct flow_keys keys, hash_keys;
> > +
> > +	if (!net->ipv6.sysctl.multipath_hash_fields_need_outer)
> > +		return 0;
> > +
> > +	memset(&hash_keys, 0, sizeof(hash_keys));
> > +	skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_ENCAP);
> > +
> > +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
> > +		hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
> > +		hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
> > +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields))
> > +		hash_keys.tags.flow_label = keys.tags.flow_label;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
> > +		hash_keys.ports.src = keys.ports.src;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
> > +		hash_keys.ports.dst = keys.ports.dst;
> > +
> > +	*p_has_inner = !!(keys.control.flags & FLOW_DIS_ENCAPSULATION);
> > +	return flow_hash_from_keys(&hash_keys);
> > +}
> > +
> > +static u32 rt6_multipath_custom_hash_inner(const struct net *net,
> > +					   const struct sk_buff *skb,
> > +					   bool has_inner)
> > +{
> > +	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
> > +	struct flow_keys keys, hash_keys;
> > +
> > +	/* We assume the packet carries an encapsulation, but if none was
> > +	 * encountered during dissection of the outer flow, then there is no
> > +	 * point in calling the flow dissector again.
> > +	 */
> > +	if (!has_inner)
> > +		return 0;
> > +
> > +	if (!net->ipv6.sysctl.multipath_hash_fields_need_inner)
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
> > +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields))
> > +			hash_keys.addrs.v4addrs.src = keys.addrs.v4addrs.src;
> > +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields))
> > +			hash_keys.addrs.v4addrs.dst = keys.addrs.v4addrs.dst;
> > +	} else if (keys.control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
> > +		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> > +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_IP, hash_fields))
> > +			hash_keys.addrs.v6addrs.src = keys.addrs.v6addrs.src;
> > +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_IP, hash_fields))
> > +			hash_keys.addrs.v6addrs.dst = keys.addrs.v6addrs.dst;
> > +		if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_FLOWLABEL, hash_fields))
> > +			hash_keys.tags.flow_label = keys.tags.flow_label;
> > +	}
> > +
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_IP_PROTO, hash_fields))
> > +		hash_keys.basic.ip_proto = keys.basic.ip_proto;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_SRC_PORT, hash_fields))
> > +		hash_keys.ports.src = keys.ports.src;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(INNER_DST_PORT, hash_fields))
> > +		hash_keys.ports.dst = keys.ports.dst;
> > +
> > +	return flow_hash_from_keys(&hash_keys);
> > +}
> > +
> > +static u32 rt6_multipath_custom_hash_skb(const struct net *net,
> > +					 const struct sk_buff *skb)
> > +{
> > +	u32 mhash, mhash_inner;
> > +	bool has_inner = true;
> > +
> > +	mhash = rt6_multipath_custom_hash_outer(net, skb, &has_inner);
> > +	mhash_inner = rt6_multipath_custom_hash_inner(net, skb, has_inner);
> > +
> > +	return jhash_2words(mhash, mhash_inner, 0);
> > +}
> > +
> > +static u32 rt6_multipath_custom_hash_fl6(const struct net *net,
> > +					 const struct flowi6 *fl6)
> > +{
> > +	unsigned long *hash_fields = ip6_multipath_hash_fields(net);
> > +	struct flow_keys hash_keys;
> > +
> > +	if (!net->ipv6.sysctl.multipath_hash_fields_need_outer)
> > +		return 0;
> > +
> > +	memset(&hash_keys, 0, sizeof(hash_keys));
> > +	hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_IP, hash_fields))
> > +		hash_keys.addrs.v6addrs.src = fl6->saddr;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_IP, hash_fields))
> > +		hash_keys.addrs.v6addrs.dst = fl6->daddr;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(IP_PROTO, hash_fields))
> > +		hash_keys.basic.ip_proto = fl6->flowi6_proto;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(FLOWLABEL, hash_fields))
> > +		hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(SRC_PORT, hash_fields))
> > +		hash_keys.ports.src = fl6->fl6_sport;
> > +	if (FIB_MULTIPATH_HASH_TEST_FIELD(DST_PORT, hash_fields))
> > +		hash_keys.ports.dst = fl6->fl6_dport;
> > +
> > +	return flow_hash_from_keys(&hash_keys);
> > +}
> > +
> 
> given the amount of duplication with IPv4, should be able to use inline
> macros and the flowi_uli union to make some common helpers without
> impacting performance.

OK, will try to create some common helpers
