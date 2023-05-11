Return-Path: <netdev+bounces-1872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 905766FF602
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876E81C20F8F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47DF63B;
	Thu, 11 May 2023 15:31:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C2629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:31:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FF619B2
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4h3dmmuALJdCr/psbewZqnRPGTDxPIxfCajBna/URVM=; b=mJ8wVHewr+CZadlJl0196yqaEw
	umH/yuy1ho751rwKwV7KZGDuWEO1R7GLnNoyWlGUv+u/S8BiPQktv2FsTsnT3Uhk247BgG9ZRxjHA
	Jc3X84KlDaJNkj+HcWqzy2LqEBbNCJYTtfgDnNQQ086pq3o8uT5YVgn18pQ/0G8uZEWwGQk2i+chv
	VhrGA6L/PZ9ZG7MYW/x+ybEfKy9m7gkdTCVX8e/2FVAn7/NDj0KueRN7oY68cbks4eWnwC62i35YI
	wRR0bZfF50BEsOEoaKcu3YlQri3cHKlzDtOrT8wmF5b9L4q6UKaP8FC0/1vmUdX+gG4rYccCfQD5o
	y9PU7+Pw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34782)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1px8GW-0006qO-H1; Thu, 11 May 2023 16:31:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1px8GU-00047v-GB; Thu, 11 May 2023 16:31:34 +0100
Date: Thu, 11 May 2023 16:31:34 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
Message-ID: <ZF0KVgNylhJ/4m26@shell.armlinux.org.uk>
References: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
 <75dd5f74abe1d168e9bb679d1e47947f4900a1f9.camel@redhat.com>
 <ZFzSVciEsAU/pKLB@shell.armlinux.org.uk>
 <be53eff275623c55263a2e9b123cd77d453e8778.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be53eff275623c55263a2e9b123cd77d453e8778.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:47:13PM +0200, Paolo Abeni wrote:
> On Thu, 2023-05-11 at 12:32 +0100, Russell King (Oracle) wrote:
> > On Thu, May 11, 2023 at 01:29:50PM +0200, Paolo Abeni wrote:
> > > On Wed, 2023-05-10 at 12:03 +0100, Russell King (Oracle) wrote:
> > > > diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> > > > index 71755c66c162..02c777ad18f2 100644
> > > > --- a/include/linux/phylink.h
> > > > +++ b/include/linux/phylink.h
> > > > @@ -568,7 +568,8 @@ void phylink_generic_validate(struct phylink_config *config,
> > > >  			      unsigned long *supported,
> > > >  			      struct phylink_link_state *state);
> > > >  
> > > > -struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
> > > > +struct phylink *phylink_create(struct phylink_config *,
> > > > +			       const struct fwnode_handle *,
> > > 
> > > While touching the above, could you please also add the missing params
> > > name, to keep checkpatch happy and be consistent with the others
> > > arguments?
> > 
> > For interest, when did naming parameters in a prototype become a
> > requirement?
> 
> I would not call it a general requirement, but in this specific case we
> have 2 named params and 2 unnamed ones for the same function, which
> looks not good to me. Since you are touching that function definition
> and checkpatch is complaining about the above, I think it would be
> better to make the function declaration self-consistent.
> 
> Looking again at the checkpatch warning, that is possibly a false
> positive - git history hints such check should apply only to function
> definition, not declaration. 
> 
> I still think it would be better removing the mixed unnamed/named
> params usage.

In this particular instance, I think removing them is appropriate,
since giving names for them doesn't contribute anything useful
(since the types give allt he information necessary.)

However, for something like a function that takes e.g. a u32 and a
bunch of other unique structs, I think it is entirely appropriate
to use mixed named/unnamed parameters - since a "u32" can't describe
on its own what it is. Hence, I think, e.g.:

int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);

is entirely reasonable, since "flags" describes what the u32 is.
Adding "pl" and "dn" to the other two arguments doesn't add any
useful value.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

