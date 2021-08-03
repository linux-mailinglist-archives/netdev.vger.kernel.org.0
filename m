Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6F53DF356
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbhHCQyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:54:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6977 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhHCQyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628009676; x=1659545676;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uYIt3x/8UHN6h9hCPScdrOwlr7B4rNtt+KlMSwn88bw=;
  b=oJtdk9/02wgZSRwrSrqSvQqezegiqZ22ujMy1QyisbyKO/zjeWpquBgs
   pDVIK0vQZsmt4ZBQzFmQlgiE7Ce1xgvYnAbiB9L+iZ/MEh1DUopCSFH5J
   kQrVPeXOW3Hnt70tqVgyMVHrhiFy4gRkU9IMYFq3ra6+mLUPYDoNdqeJo
   2cxVEGGQQ6yvQuRmliArP8P4v0XwS37V1DSKJJu1zZVu0KAycXzSbRsog
   tfhbHptb8bz/33yn2u8fT2YrlPvWl0eVqHOyXreAPnFrgTY0MgVzwRkMH
   wgPYifR5NU/3NStzPRvNB2Z0zQxDYSCEIyp8Q3Mubg4kitqTKfGzpw2m2
   g==;
IronPort-SDR: QbaPTeX+b/60wgqTxQHWWt9ose+3MWMZqr0EDkgGtmht1tChGwp++QPcZqH3jBEBT7HXzVoDAC
 GZgUA1INXoBc+sWmQ2TAQHG99V5j7OzVcktq9TfbDHEA/fb0K0jxzqixh4ecgUMXbR266O2clL
 2yxqIw1lNoASjVijRyw6lE9NRw0zNqKsuvVi6YIEfiSwM159J2wMGxfwkVEQZq1rEpgZ8lLBwP
 xkzWzd33jmJZ1mHDIxxI+773r0ICLQYHEkN91UOW/RmsiC4NTGZEscWTRzWR1Wr9r63pu+wdUm
 Mmcq9raeUDwtPHgIbciU11fJ
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="130883369"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Aug 2021 09:54:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 09:54:34 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 3 Aug 2021 09:54:28 -0700
Message-ID: <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 3 Aug 2021 22:24:27 +0530
In-Reply-To: <20210802135911.inpu6khavvwsfjsp@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
         <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
         <20210731150416.upe5nwkwvwajhwgg@skbuf>
         <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
         <20210802121550.gqgbipqdvp5x76ii@skbuf> <YQfvXTEbyYFMLH5u@lunn.ch>
         <20210802135911.inpu6khavvwsfjsp@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-08-02 at 16:59 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Mon, Aug 02, 2021 at 03:13:01PM +0200, Andrew Lunn wrote:
> > In general, the MAC does nothing, and passes the value to the PHY. The
> > PHY inserts delays as requested. To address Vladimir point,
> > PHY_INTERFACE_MODE_RGMII_TXID would mean the PHY adds delay in the TX
> > direction, and assumes the RX delay comes from somewhere else,
> > probably the PCB.
> 
> For the PHY, that is the only portion where things are clear.
> 
> > I only recommend the MAC adds delays when the PHY cannot, or there is
> > no PHY, e.g. SoC to switch, or switch to switch link. There are a few
> > MAC drivers that do add delays, mostly because that is how the vendor
> > crap tree does it.
> > 
> > So as i said, what you propose is O.K, it follows this general rule of
> > thumb.
> 
> The "rule of thumb" for a MAC driver is actually applied in reverse by
> most MAC drivers compared to what Russell described should be happening.
> For example, mv88e6xxx_port_set_rgmii_delay():
> 
>         switch (mode) {
>         case PHY_INTERFACE_MODE_RGMII_RXID:
>                 reg |= MV88E6XXX_PORT_MAC_CTL_RGMII_DELAY_RXCLK;
> 
> The mv88e6xxx is a MAC, so when it has a phy-mode = "rgmii-rxid", it
> should assume it is connected to a link partner (PHY or otherwise) that
> has applied the RXCLK delay already. So it should only be concerned with
> the TXCLK delay. That is my point. I am just trying to lay out the
> points to Prasanna that would make a sane system going forward. I am not
> sure that we actually have an in-tree driver that is sane in that
> regard.
> 
> That discussion, and Russell's point, was here, btw:
> https://patchwork.ozlabs.org/project/netdev/patch/20200616074955.GA9092@laureti-dev/#2461123

Thanks Vladimir & Andrew for the right pointers and info. The thread talks about
"rgmii-*" are going to be applied by the PHY only as per the doc. For fixed-
link, MAC needs to add the delay. This fixed-link can be No-PHY or MAC-MAC or
MAC to in-accessible PHY. In such case, i am not convinced in using rgmii-tx-
delay-ps & rgmii-rx-delay-ps on the MAC side and apply delay. I still think
proposed code in earlier mail thread should still be okay. 

