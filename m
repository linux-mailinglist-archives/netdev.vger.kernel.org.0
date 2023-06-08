Return-Path: <netdev+bounces-9303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC2372861C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B78A2816AE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF4319922;
	Thu,  8 Jun 2023 17:18:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D86B10973
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:18:09 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B504FE59;
	Thu,  8 Jun 2023 10:18:06 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686244685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JloVVkRUCrOBf964M9cSz6IG1kWpPZ1DM7vwOfF5Jy8=;
	b=ZmAd4v3AspZjOKuyH1fbC7yCuK6o2qMvN0DP1LsVo/o9uIj9QAy7oWM/DYwu3x5I1EqZul
	kCFwten5eXWftRKNgRhitus5GElXFFtJnUk8vk15eYIzPrptd4B9nUWlt+UPzAD0A2AS/x
	1QxbpzOFvxbuY/vp8QiDbFih02N2uDmOM0l3echMF2uaDfaVAiNEGodgEf0g3nAM8oYZK1
	J7QBQvYngtFpIqBPzcT9MkEz5+n1a/O4xtjhLhE4yWi7pznDShc3oJ8e6X/9UEY1Eacyjm
	OXnWOeg9STcqJB5sGmNwxEM3icq7VKKJghB4B3U0k9jmLRju3mq+tBtJRHTBiQ==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id E09CD60003;
	Thu,  8 Jun 2023 17:18:03 +0000 (UTC)
Date: Thu, 8 Jun 2023 19:53:30 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com, Andrew Lunn
 <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Heiner Kallweit
 <hkallweit1@gmail.com>, linux-arm-kernel@lists.infradead.org,
 Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
 UNGLinuxDriver@microchip.com, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: phylink: use USXGMII control-word format
 to parse Q-USGMII word
Message-ID: <20230608195330.476fca86@pc-7.home>
In-Reply-To: <ZIICtN5zrxvTuEwz@shell.armlinux.org.uk>
References: <20230608163415.511762-1-maxime.chevallier@bootlin.com>
	<20230608163415.511762-4-maxime.chevallier@bootlin.com>
	<ZIICtN5zrxvTuEwz@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Russell,

On Thu, 8 Jun 2023 17:32:52 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Thu, Jun 08, 2023 at 06:34:15PM +0200, Maxime Chevallier wrote:
> > diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> > index 256b463e47a6..1d20a9082507 100644
> > --- a/include/uapi/linux/mdio.h
> > +++ b/include/uapi/linux/mdio.h
> > @@ -444,4 +444,7 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
> >  #define MDIO_USXGMII_5000FULL		0x1a00	/* 5000Mbps full-duplex */
> >  #define MDIO_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */
> >  
> > +/* Usgmii control word is based on Usxgmii, masking away 2.5, 5 and 10Gbps */
> > +#define MDIO_USGMII_SPD_MASK		0x0600  
> 
> This isn't correct:
> 
> 11:9	Speed: Bit 11, 10, 9:
> 	1 1 1 to 011 = Reserved
> 	0 1 0 = 1000 Mbps: 1000BASE-TX, 1000BASE-X
> 	0 0 1 = 100 Mbps: 100BASE-TX, 100BASE-FX
> 	0 0 0 = 10 Mbps: 10BASET, 10BASE2, 10BASE5
> 
> If we only look at bits 10 and 9, then we're interpreting the reserved
> combinations as valid as well.

That's why I rewrote the decoding helper instead of simply masking away
the extra bit, so that we exclude the 0 1 1 combination ( 10G speed ).

The comment is wrong though.

This patch set needs more coffee,

Best regards,

Maxime

