Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DCE3DF37A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhHCRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:05:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:55877 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbhHCRFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628010308; x=1659546308;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6M38VUr1joiElnH/HutPY11M2i82vpMBxrOp6TL+19c=;
  b=0ma17OquZ3D1Q+K73+yjNMiNNGEFCeXr6z2ns2CUyJjTUE/V37aBlvg7
   1J+2qas1cdDeo9VgP8M4gz/2dweQOFY0meaP7Ge/pIO7HLUWyK6DvL9LC
   ly2CRnHwBK81RZPbS44tHm18uE9yDKQ1y5LESBO7wb1E33mjJVQRLs7NY
   3pHVCx9bjTfD1BOK+herGGrFc2HQIEVl0d1aHSWB1xL/PGJNZe4VY/DHv
   GOmBTbR3Klk5a8UNJlB0ZnkncHRljDdhvpc8JyWMW+KadGMd9pTZC08fX
   b61YyMK/OdSAKDns2u02+Thk9xD/OxKa3OgzwfF7qWM0OD7f6uxssGbwS
   g==;
IronPort-SDR: RrT8eWG4lZzTH6FyUEm1utbuTUVtav2Vv5lyMl8LffK+gT+SbwcZbSz2fIaxmLtWzzymB2IME7
 +VDIg5tLutlVno8qLePohoGXNUp4Gjr59TaJRBeRXulYTx5FRA3RYgYidfNE7nDonRKcCM9TJ2
 WKY94a9Fg06+X4u+e6K9aejQ03KxqFhCVj5icDe77MGVq5CfHqAEfIrQLYN0nGuww5WQJ7h4UM
 e0/GFNlDIlXvyKlfYc6RTYsND1LigRaUZCetdCmRdVC94ZiLH18ZGVMJUujm2hCS5LrQ/0jEPJ
 1iP7f+d+zaZKLfbFzgQxPvM3
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="126942912"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Aug 2021 10:05:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 10:05:07 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 3 Aug 2021 10:05:01 -0700
Message-ID: <1ce139ac7eb4cb85c6cdb898545ba76729ac927b.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 06/10] net: dsa: microchip: add support for
 phylink management
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 3 Aug 2021 22:34:55 +0530
In-Reply-To: <20210731152729.r4lzc3md2bql2too@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
         <20210723173108.459770-7-prasanna.vengateshan@microchip.com>
         <20210731152729.r4lzc3md2bql2too@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 18:27 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Fri, Jul 23, 2021 at 11:01:04PM +0530, Prasanna Vengateshan wrote:
> > +static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
> > +                                  unsigned long *supported,
> > +                                  struct phylink_link_state *state)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +     /* Check for unsupported interfaces */
> > +     if (!phy_interface_mode_is_rgmii(state->interface) &&
> > +         state->interface != PHY_INTERFACE_MODE_RMII &&
> > +         state->interface != PHY_INTERFACE_MODE_MII &&
> > +         state->interface != PHY_INTERFACE_MODE_INTERNAL) {
> 
> According to include/linux/phylink.h, when phylink passes
> state->interface == PHY_INTERFACE_MODE_NA, you are expected to return
> all supported link modes.

Okay, Noted. i think PHY_INTERFACE_MODE_NA check should be added in all of the
'if' (==) checks down to the above one and including the above one (!=). 

