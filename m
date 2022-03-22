Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7164E4304
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbiCVPdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 11:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbiCVPdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 11:33:02 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074E5240A3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:31:35 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D9AA5C010D;
        Tue, 22 Mar 2022 11:31:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 22 Mar 2022 11:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=edi1Avf6TKC+cH05A
        9XGNw+gdRFjteMtQu1DgSgPUGs=; b=PzdmvQfSEhX47zpyQF1OMaV8jG8wsjFRy
        dYr8Z8qJ9TaKBjGLqpVsZGZAcM1EEQufzlyzjjkZVAt4MJ7fUSKICTjXduy1jBz5
        WS867tx7WiYc8Ur5KorgRNDEVA2JciOj3zW5F965LSUfVjWPWNIKEa5IFH6zB017
        Qct6wW8VJhUHGMkML/0IWwG9RCP8bMeF4ogFpicTRlNJqX2GG6EUeuDgoVO2Qlz+
        wKvEq1FpRRLsMeubOw5IJRVQhqQY2V6cCmbFflCMVq3W30+p0kGJowo0eEtUJZWp
        hTAz40qRcveJUE/jpyg9kLCFGXymbm48y2uxCVN7N9d0rbTFKiivg==
X-ME-Sender: <xms:1Os5YjM_53goo6zAqNBGK2WAEL8wgfRbIq9F1A0Tutuw5kblITSS8A>
    <xme:1Os5Yt_WNwIZ6A__UadNF63weM-YoEa8vdCQ1klt88YR5NPVMP4kBsIzSA6OiWg3Q
    dMuGiu_3R4VFgc>
X-ME-Received: <xmr:1Os5YiQvx4sxhhazGiUIMdSakLYroCYNEMZ-9WBpnw3jYX8OkVJ2FsdF5lnvglaxNzSS8gpOHdySi3PzZgmcdo2KAUk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeghedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1Os5YnvWPGphvjY8IRYNoZzoml9ydvEYuiiY2VfSFRg5Y31i1EJMqA>
    <xmx:1Os5YreYQYQSs4qeXzJQazhawdhbIRZBMcpXyVtaeaHhgI3xeLPLVw>
    <xmx:1Os5Yj0MvToPouHHYW1oLad_lHERb16hpIqYAaA2FCXW3upjj4imPA>
    <xmx:1Os5YspljEJXCjXvT71ecX_WI9gG-R6sE1LTkPNFQCA-4KY_wdk3nA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Mar 2022 11:31:31 -0400 (EDT)
Date:   Tue, 22 Mar 2022 17:31:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        greearb@candelatech.com
Subject: Re: [PATCH net-next] net: Add l3mdev index to flow struct and avoid
 oif reset for port devices
Message-ID: <Yjnrz7vL9HqE5UBz@shredder>
References: <20220314204551.16369-1-dsahern@kernel.org>
 <YjmVZzwE3XY750v6@shredder>
 <0b0b61a1-e46d-6134-0151-913b324f056a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b0b61a1-e46d-6134-0151-913b324f056a@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 08:26:48AM -0600, David Ahern wrote:
> On 3/22/22 3:22 AM, Ido Schimmel wrote:
> > On Mon, Mar 14, 2022 at 02:45:51PM -0600, David Ahern wrote:
> >> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> >> index 2af2b99e0bea..fb0e49c36c2e 100644
> >> --- a/net/ipv4/fib_trie.c
> >> +++ b/net/ipv4/fib_trie.c
> >> @@ -1429,11 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
> >>  	    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
> >>  		return false;
> >>  
> >> -	if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
> >> -		if (flp->flowi4_oif &&
> >> -		    flp->flowi4_oif != nhc->nhc_oif)
> >> -			return false;
> >> -	}
> >> +	if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
> >> +		return false;
> > 
> > David, we have several test cases that are failing which I have tracked
> > down to this patch.
> > 
> > Before the patch, if the original output interface was enslaved to a
> > VRF, the output interface in the flow struct would be updated to the VRF
> > and the 'FLOWI_FLAG_SKIP_NH_OIF' flag would be set, causing the above
> > check to be skipped.
> > 
> > After the patch, the check is no longer skipped, as original output
> > interface is retained and the flag was removed.
> > 
> > This breaks scenarios where a GRE tunnel specifies a dummy device
> > enslaved to a VRF as its physical device. The purpose of this
> > configuration is to redirect the underlay lookup to the table associated
> > with the VRF to which the dummy device is enslaved to. The check fails
> > because 'flp->flowi4_oif' points to the dummy device, whereas
> > 'nhc->nhc_oif' points to the interface via which the encapsulated packet
> > should egress.
> > 
> > Skipping the check when an l3mdev was set seems to solve the problem:
> > 
> > diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> > index fb0e49c36c2e..cf1164e05d92 100644
> > --- a/net/ipv4/fib_trie.c
> > +++ b/net/ipv4/fib_trie.c
> > @@ -1429,7 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
> >             !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
> >                 return false;
> >  
> > -       if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
> > +       if (!flp->flowi4_l3mdev &&
> > +           flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
> >                 return false;
> >  
> >         return true;
> > 
> > AFAICT, this scenario does not break with ip6gre/ip6gretap tunnels
> > because 'RT6_LOOKUP_F_IFACE' is not set in
> > ip6_route_output_flags_noref() in this case.
> > 
> > WDYT? I plan to test this patch in our regression, but I'm not sure if I
> > missed other cases that might remain broken.
> 
> one of the requests with VRF has been to bind a socket to a port device
> and expect the lookup to enforce use of that egress port (e.g.,
> multipath). Switching the oif to the VRF device and then ignoring the
> oif check was making that check too flexible for that use case.

I see

> 
> What's the callchain for this failure? Perhaps the
> FLOWI_FLAG_SKIP_NH_OIF needs to be kept for this particular use case.

This is the stack trace for the failure:

    fib_lookup_good_nhc+5
    fib_table_lookup+3281
    fib4_rule_action+501
    fib_rules_lookup+858
    __fib_lookup+233
    fib_lookup.constprop.0+926
    ip_route_output_key_hash_rcu+3707
    ip_route_output_key_hash+392
    ip_route_output_flow+33
    ip_tunnel_xmit+1794
    gre_tap_xmit+1312
    dev_hard_start_xmit+448
    sch_direct_xmit+615
    __dev_queue_xmit+4841

The GRE tap is using a dummy device enslaved to a VRF as its physical
device.
