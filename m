Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FBE5EDCB
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfGCUqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:46:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34247 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfGCUqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:46:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so1861442plt.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 13:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oTkEYpQN/NBrw7dXftOXN7NBhFg/b02Ykn5JMD61qmE=;
        b=OkcOafZYWFlnQelddhq7i4lqrly5qcCx1qYzJ+ecsWDMJzQ2dFg89kVrIQv2hpEZqB
         7othDvtesYLJySESnzt4Ci5m6AQOlnr3Tk3zDMwfYqyJCVdAEJ6W9o5T3xNFkFzHCkZW
         QCNIqyTea7m73B/bU4NsRGjdzugdxxmwUs0ug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oTkEYpQN/NBrw7dXftOXN7NBhFg/b02Ykn5JMD61qmE=;
        b=iZSefgKXrCmTUCySHFHtgxiyk4l+HjS0fp4omKB/MA/ZmBsu9JkZjItnwpe/fFVV/B
         HP5G0YvXmjnLaVmbYjGPHH1QkiLpRwRxPFo2l4MLgLIVM2MVLExIb/mvh6Dxn8Xo1EvF
         AP7btor+ouBa9jCJj3jerEopx9AsjwhYL7f7d3quCv9AZiSZnTojel+HEozoNhPs9olv
         uHOIo1pC5qC11wqVkX0flhYSEXDea1H8r8fkAqr+tVqJoyS3BXmF6BhnU4qgmAZVd1Uy
         k4lXoHDw8YUQe8Gi7ro2d8WcBzZ1ToPDXN4uTCE9zTeWTsUK4r0FSh7XfRPZE9nYr70+
         6X4w==
X-Gm-Message-State: APjAAAUULqwySZW71PJz+cOp1dQTKWzjpGV3vEB8qeidmDX88Cf7fLxK
        OCy6mgqDRxC6ERn7ygYWz8+O/g==
X-Google-Smtp-Source: APXvYqzUW8l4EWMeThaai5UNtNS7VKQQXt96zHjfC393F6AbD2cn+V1EPxmDKgh1E1+59GXvnCD3kw==
X-Received: by 2002:a17:902:f301:: with SMTP id gb1mr44050568plb.292.1562186761658;
        Wed, 03 Jul 2019 13:46:01 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id b126sm3510935pfa.126.2019.07.03.13.46.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:46:01 -0700 (PDT)
Date:   Wed, 3 Jul 2019 13:45:59 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 7/7] net: phy: realtek: configure RTL8211E LEDs
Message-ID: <20190703204559.GH250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-7-mka@chromium.org>
 <189ec367-2085-056b-61a9-90f0044b55ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <189ec367-2085-056b-61a9-90f0044b55ba@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 10:28:17PM +0200, Heiner Kallweit wrote:
> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> > Configure the RTL8211E LEDs behavior when the device tree property
> > 'realtek,led-modes' is specified.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Changes in v2:
> > - patch added to the series
> > ---
> >  drivers/net/phy/realtek.c | 63 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 61 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index 45fee4612031..559aec547738 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -9,6 +9,7 @@
> >   * Copyright (c) 2004 Freescale Semiconductor, Inc.
> >   */
> >  #include <linux/bitops.h>
> > +#include <linux/bits.h>
> >  #include <linux/device.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> > @@ -35,6 +36,15 @@
> >  #define RTL8211E_EEE_LED_MODE1			0x05
> >  #define RTL8211E_EEE_LED_MODE2			0x06
> >  
> > +/* RTL8211E extension page 44 */
> > +#define RTL8211E_LACR				0x1a
> > +#define RLT8211E_LACR_LEDACTCTRL_SHIFT		4
> > +#define RLT8211E_LACR_LEDACTCTRL_MASK		GENMASK(6, 4)
> > +#define RTL8211E_LCR				0x1c
> > +#define RTL8211E_LCR_LEDCTRL_MASK		(GENMASK(2, 0) | \
> > +						 GENMASK(6, 4) | \
> > +						 GENMASK(10, 8))
> > +
> >  /* RTL8211E extension page 160 */
> >  #define RTL8211E_SCR				0x1a
> >  #define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
> > @@ -124,6 +134,56 @@ static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
> >  	return phy_restore_page(phydev, oldpage, ret);
> >  }
> >  
> > +static int rtl8211e_config_leds(struct phy_device *phydev)
> > +{
> > +	struct device *dev = &phydev->mdio.dev;
> > +	int count, i, oldpage, ret;
> > +	u16 lacr_bits = 0, lcr_bits = 0;
> > +
> > +	if (!dev->of_node)
> > +		return 0;
> > +
> > +	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
> > +		rtl8211e_disable_eee_led_mode(phydev);
> > +
> > +	count = of_property_count_elems_of_size(dev->of_node,
> > +						"realtek,led-modes",
> > +						sizeof(u32));
> > +	if (count < 0 || count > 3)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < count; i++) {
> > +		u32 val;
> > +
> > +		of_property_read_u32_index(dev->of_node,
> > +					   "realtek,led-modes", i, &val);
> > +		lacr_bits |= (u16)(val >> 16) <<
> > +			(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);
> 
> This may be done in an easier to read way:
> 
> if (val & RTL8211E_LINK_ACTIVITY)
> 	lacr_bits |= BIT(RLT8211E_LACR_LEDACTCTRL_SHIFT + i);

indeed, that's more readable, thanks for the suggestion!

> > +		lcr_bits |= (u16)(val & 0xf) << (i * 4);
> > +	}
> > +
> > +	oldpage = rtl8211e_select_ext_page(phydev, 44);
> > +	if (oldpage < 0) {
> > +		dev_err(dev, "failed to select extended page: %d\n", oldpage);
> 
> In a PHY driver it may be more appropriate to use phydev_err() et al,
> even though effectively it's the same.

sounds good, I'll change it to the phydev_err() et al.

Thanks for the reviews!

Matthias
