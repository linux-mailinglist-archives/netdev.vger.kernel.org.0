Return-Path: <netdev+bounces-7760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD73572168E
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2223C1C209FD
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B8D53BE;
	Sun,  4 Jun 2023 12:08:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7355236
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 12:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE52C433D2;
	Sun,  4 Jun 2023 12:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685880478;
	bh=+fYKNXIrhWAXWnAxtWNhnH5m/liyK8+5IVs1x7xn8uY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mpGdiOYJ4huRo5xBcpjmXsKOwHV2gh0/MGsLkkNOq0yQ1EwE8USg66crwQHLaasAn
	 AQTCwmC5Zc6RMhZOZdXJciwyFOYSB7NaLWvjEa3KxS/TNIHQy+kLiEK7BKSroVBY57
	 jihZKZlKif7sD/vfYR2iunAj4uA0SKoSSnxocaNMczmJF5dce7CHfAxnWV+Vo2SQYH
	 UsYPRO9pmr05RslU9ddNTXj97toiQHcYt6hxNx+s/M/Ampx91OqQ0lE0dk1F9yzUrm
	 mLfhl/dDCGJW5aws5LZsebxQNjUPYSXXvmoR3puTcDz8MD6SiMYXpN6YKFQXkfmcBE
	 aQo6WlmJfCqfA==
Date: Sun, 4 Jun 2023 20:07:48 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Andrew Lunn <andrew@lunn.ch>, s.hauer@pengutronix.de,
	Russell King <rmk+kernel@armlinux.org.uk>, arm@kernel.org,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: vf610: ZII: Add missing phy-mode and fixed
 links
Message-ID: <20230604120748.GC4199@dragon>
References: <20230525182606.3317923-1-andrew@lunn.ch>
 <20230525182606.3317923-1-andrew@lunn.ch>
 <20230529133507.y7ph5x2u3drlt5zd@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529133507.y7ph5x2u3drlt5zd@skbuf>

On Mon, May 29, 2023 at 04:35:07PM +0300, Vladimir Oltean wrote:
> On Thu, May 25, 2023 at 08:26:06PM +0200, Andrew Lunn wrote:
> > diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> > index 96495d965163..1a19aec8957b 100644
> > --- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> > @@ -202,7 +202,7 @@ port@5 {
> >  
> >  				port@6 {
> >  					reg = <6>;
> > -					label = "cpu";
> > +					phy-mode = "rmii";
> >  					ethernet = <&fec1>;
> >  
> >  					fixed-link {
> > diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> > index 6280c5e86a12..6071eb6b33a0 100644
> > --- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> > @@ -75,7 +75,7 @@ fixed-link {
> >  
> >  					port@6 {
> >  						reg = <6>;
> > -						label = "cpu";
> > +						phy-mode = "rmii";
> >  						ethernet = <&fec1>;
> >  
> >  						fixed-link {
> > diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > index c00d39562a10..6f9878f124c4 100644
> > --- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > @@ -44,7 +44,7 @@ ports {
> >  
> >  					port@0 {
> >  						reg = <0>;
> > -						label = "cpu";
> > +						phy-mode = "rmii";
> >  						ethernet = <&fec1>;
> >  
> >  						fixed-link {
> > diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> > index 7b3276cd470f..df1335492a19 100644
> > --- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> > @@ -59,7 +59,7 @@ ports {
> >  
> >  					port@0 {
> >  						reg = <0>;
> > -						label = "cpu";
> > +						phy-mode = "rmii";
> >  						ethernet = <&fec1>;
> >  
> >  						fixed-link {
> > diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
> > index 180acb0795b9..1461804ecaea 100644
> > --- a/arch/arm/boot/dts/vf610-zii-spb4.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
> > @@ -140,7 +140,7 @@ ports {
> >  
> >  				port@0 {
> >  					reg = <0>;
> > -					label = "cpu";
> > +					phy-mode = "rmii";
> >  					ethernet = <&fec1>;
> >  
> >  					fixed-link {
> > diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> > index 73fdace4cb42..463c2452b9b7 100644
> > --- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> > @@ -129,7 +129,7 @@ ports {
> >  
> >  				port@0 {
> >  					reg = <0>;
> > -					label = "cpu";
> > +					phy-mode = "rmii";
> >  					ethernet = <&fec1>;
> >  
> >  					fixed-link {
> > diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > index 20beaa8433b6..f5ae0d5de315 100644
> > --- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > +++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> > @@ -154,7 +154,7 @@ ports {
> >  
> >  				port@0 {
> >  					reg = <0>;
> > -					label = "cpu";
> > +					phy-mode = "rmii";
> >  					ethernet = <&fec1>;
> >  
> >  					fixed-link {
> 
> Shouldn't these have been rev-rmii to be consistent with what was done
> for arm64?

Should I drop the patch for now, or can this be changed incrementally if
needed?

Shawn

