Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEAE263506
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgIIRxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIRxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:53:30 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAEAC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 10:53:29 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i22so4838744eja.5
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 10:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9OIe9ODyhdqAar6vIhIoBiXPdCtm/nr7i5INmCz1xiI=;
        b=C9r4brq9wuJZ1lWKfAelJwLVS2EGB20yd/FVcJ6us+3rEUZrVMK37rYszWIKrqD17l
         e+wE/iQdhxSwuRjwx5Cw7ZSJEGVSR/XnBfJ/90xdH3KvHWXDqjU2xIVPZx4Ub9MmUJDW
         o6at0qoiR/TNTXvFtkYUwA9ltpIYXKtrfp4f7cHb5hgsC5GLYxSeHVGRdwJSKqIxHbDl
         ev3R6Woj+Mw9939T8RjgwK4I9oHpTMnABc07q1HN5ORAn3CDawH/rPJYKd0I1OVjyfTj
         xac/7Gku0iZZ1Mn/y0zd0gyVp4wv5MDvJ9jukKPsXpjr6hyzcR55GYPBDc2IQ/SZyOSM
         BbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9OIe9ODyhdqAar6vIhIoBiXPdCtm/nr7i5INmCz1xiI=;
        b=LI1tAtRPCC1KiF3BZ4p9ySk5b0ilD0XH2IVPt7o6XBXXdLjHk/pMn8ecT9icQwK36q
         Hm7jA38Wxs+DtmpWrld6B+7xReTHcig+mRnNlwA2cHy3oAARUKt+3G23Qfb0/cL6xMQ1
         rTH65/DgGbU12v5VB7olYNQN2MJp/eCI+8jBB9RsbP7Wm9VPzdkRyBooMubs7iGvjIWz
         z1NKlmmiKgj9UxuXSxvVBVkYGyVp15InFkKblBKBsTJ81PpqF/iQx733TjotfW2GrcQL
         pU5BqMP0xo/5jnYSeulbzJUbBMGB1NphgQbgu3LobXYwy1VhMrk3pELPq2X/wzLgok6P
         ewMg==
X-Gm-Message-State: AOAM532G0dnulIMWtts0GCLlBigEtVx6h2yE5oxsameACYpExVza4u5Q
        QmbnVhFw6DPEyFlaOw2fPAk=
X-Google-Smtp-Source: ABdhPJySN5t9eOP6r7t/uIClMOX3hS2YtE03BtEhNuNFraNvBxhECc8nTbldtCt8iNl4zQ8f+tD2lw==
X-Received: by 2002:a17:906:2dc1:: with SMTP id h1mr4748993eji.436.1599674008427;
        Wed, 09 Sep 2020 10:53:28 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id jo2sm3072974ejb.101.2020.09.09.10.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 10:53:27 -0700 (PDT)
Date:   Wed, 9 Sep 2020 20:53:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20200909175325.bshts3hl537xtz2q@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
 <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
 <f0217ae5-7897-17e2-a807-fc0ba0246c74@gmail.com>
 <20200909163105.nynkw5jvwqapzx2z@skbuf>
 <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11268219-286d-7daf-9f4e-50bdc6466469@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 10:22:42AM -0700, Florian Fainelli wrote:
> How do you make sure that the CPU port sees the frame untagged which would
> be necessary for a VLAN-unaware bridge? Do you have a special remapping
> rule?

No, I don't have any remapping rules that would be relevant here.
Why would the frames need to be necessarily untagged for a VLAN-unaware
bridge, why is it a problem if they aren't?

bool br_allowed_ingress(const struct net_bridge *br,
			struct net_bridge_vlan_group *vg, struct sk_buff *skb,
			u16 *vid, u8 *state)
{
	/* If VLAN filtering is disabled on the bridge, all packets are
	 * permitted.
	 */
	if (!br_opt_get(br, BROPT_VLAN_ENABLED)) {
		BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
		return true;
	}

	return __allowed_ingress(br, vg, skb, vid, state);
}

If I have a VLAN on a bridged switch port where the bridge is not
filtering, I have an 8021q upper of the bridge with that VLAN ID.

> Initially the concern I had was with the use case described above which was
> a 802.1Q separation, but in hindsight MAC address learning would result in
> the frames going to the appropriate ports/VLANs anyway.

If by "separation" you mean "limiting the forwarding domain", the switch
keeps the same VLAN associated with the frame internally, regardless of
whether it's egress-tagged or not.

> > 
> > > Tangentially, maybe we should finally add support for programming the CPU
> > > port's VLAN membership independently from the other ports.
> > 
> > How?
> 
> Something like this:
> 
> https://lore.kernel.org/lkml/20180625091713.GA13442@apalos/T/

I need to take some time to understand what's going on there.
