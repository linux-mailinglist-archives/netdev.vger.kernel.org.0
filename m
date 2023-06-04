Return-Path: <netdev+bounces-7762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B977216E4
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3976281080
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB885680;
	Sun,  4 Jun 2023 12:24:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A2F23C6
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 12:24:43 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5193983
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 05:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dZTGfCU3k24wgFyS6/hbvYGDltsSs+9ezPG8SsaJlTg=; b=Z7nIal4gDNljo0MIFZRJcUbkaz
	6ud/kwN37Ebn+m3T7v+7lwMqHse9Cha029eG+pNRtK+oJxq7/0PakymWXWQVdCeSXQRDGqDnnHTKe
	8CigIdAaIsSPFro49h2xoKTXEo0vWRA4R+qk2ejF21146d9NilC5WQduwlwwhJHXO/h6I6mG+iVd/
	7lECUmdy9yrRWGNRhxewuHYoLhX6C+OsZJeEqDkM2IdQBFyAWPwiJJOCiaW4p/J1bXIXPrXhKvNQC
	p/JYN1jBOjeFc+VHn4WP4e+LHAQPj0hW8EegBbKkQF6pTzApZbu9WPIlqqY3jUTJXtAEs02R8/gaK
	KgjqKgrA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38714)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q5mmi-0002Zj-Rp; Sun, 04 Jun 2023 13:24:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q5mmh-00053E-Lt; Sun, 04 Jun 2023 13:24:35 +0100
Date: Sun, 4 Jun 2023 13:24:35 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Shawn Guo <shawnguo@kernel.org>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
	s.hauer@pengutronix.de, arm@kernel.org,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: vf610: ZII: Add missing phy-mode and fixed
 links
Message-ID: <ZHyCg+Anqsdvt4V9@shell.armlinux.org.uk>
References: <20230525182606.3317923-1-andrew@lunn.ch>
 <20230525182606.3317923-1-andrew@lunn.ch>
 <20230529133507.y7ph5x2u3drlt5zd@skbuf>
 <20230604120748.GC4199@dragon>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604120748.GC4199@dragon>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 08:07:48PM +0800, Shawn Guo wrote:
> On Mon, May 29, 2023 at 04:35:07PM +0300, Vladimir Oltean wrote:
> > On Thu, May 25, 2023 at 08:26:06PM +0200, Andrew Lunn wrote:
> > > diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> > > index 96495d965163..1a19aec8957b 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> > > @@ -202,7 +202,7 @@ port@5 {
> > >  
> > >  				port@6 {
> > >  					reg = <6>;
> > > -					label = "cpu";
> > > +					phy-mode = "rmii";
> > >  					ethernet = <&fec1>;
> > >  
> > >  					fixed-link {
> > > diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> > > index 6280c5e86a12..6071eb6b33a0 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> > > @@ -75,7 +75,7 @@ fixed-link {
> > >  
> > >  					port@6 {
> > >  						reg = <6>;
> > > -						label = "cpu";
> > > +						phy-mode = "rmii";
> > >  						ethernet = <&fec1>;
> > >  
> > >  						fixed-link {
> > > diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > > index c00d39562a10..6f9878f124c4 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > > @@ -44,7 +44,7 @@ ports {
> > >  
> > >  					port@0 {
> > >  						reg = <0>;
> > > -						label = "cpu";
> > > +						phy-mode = "rmii";
> > >  						ethernet = <&fec1>;
> > >  
> > >  						fixed-link {
> > > diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> > > index 7b3276cd470f..df1335492a19 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> > > @@ -59,7 +59,7 @@ ports {
> > >  
> > >  					port@0 {
> > >  						reg = <0>;
> > > -						label = "cpu";
> > > +						phy-mode = "rmii";
> > >  						ethernet = <&fec1>;
> > >  
> > >  						fixed-link {
> > > diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
> > > index 180acb0795b9..1461804ecaea 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-spb4.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
> > > @@ -140,7 +140,7 @@ ports {
> > >  
> > >  				port@0 {
> > >  					reg = <0>;
> > > -					label = "cpu";
> > > +					phy-mode = "rmii";
> > >  					ethernet = <&fec1>;
> > >  
> > >  					fixed-link {
> > > diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> > > index 73fdace4cb42..463c2452b9b7 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> > > @@ -129,7 +129,7 @@ ports {
> > >  
> > >  				port@0 {
> > >  					reg = <0>;
> > > -					label = "cpu";
> > > +					phy-mode = "rmii";
> > >  					ethernet = <&fec1>;
> > >  
> > >  					fixed-link {
> > > diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > > index 20beaa8433b6..f5ae0d5de315 100644
> > > --- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > > +++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > > @@ -154,7 +154,7 @@ ports {
> > >  
> > >  				port@0 {
> > >  					reg = <0>;
> > > -					label = "cpu";
> > > +					phy-mode = "rmii";
> > >  					ethernet = <&fec1>;
> > >  
> > >  					fixed-link {
> > 
> > Shouldn't these have been rev-rmii to be consistent with what was done
> > for arm64?
> 
> Should I drop the patch for now, or can this be changed incrementally if
> needed?

What we have here is something that is "close enough". It isn't 100%
correct, but acceptable for the time being, and isn't something that
will ever become a problem, since the hardware itself can not have
its interface mode changed (it's set by pin strapping.)

It's something that can be fixed later.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

