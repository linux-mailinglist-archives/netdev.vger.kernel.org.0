Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783B52E95B5
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 14:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhADNR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 08:17:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35840 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbhADNR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 08:17:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609766278; x=1641302278;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lNzNAdTOYx2pjuGsUTzIN9MNbB9H3ZibeHIbH3hq/Ks=;
  b=MAs7mP9iqWK7kS7xECwOqXGapoz6amu8ngHegMX4XmEy971OlN1UT6Tw
   esTFKLu0OCgKtw9Fdzd66TA9ZlJzAjthWTYrPzXrvuDFlks53iMlwqRX+
   AqDzyuwn2Lwq8WFCjd0sMktJh2jpZsdBJWOLDmg2LMjan1OceXQIxn2UH
   IB0Uf0veRU3eKGaommgpFfL0ulFBVPPN63jYmjD4DEpxOwWkk8Xy/SLeJ
   f19Qj56ybyIiA4asjhuhV5eayG0fh77qSj3rvOwTSLbT83mchY3sTTT5F
   vRrLn3oGqjVclCXJ1JnNiBztAVI9xBRXstk41H/TpD4zcyVSRecWJB0Cv
   Q==;
IronPort-SDR: i6V5r2H9h4gkVbFlnAER8oRXNV9bi9wIa8upERa+cj0ltYQfPJ6SwllsBWLyyLrr1ClxBwavsI
 HsC/E6wy4UVTeidQzdEv7R4lInu35grPiygmM+Xo+NZUf3K5ezxEpH1g/X7WnEOxhavLfppOyT
 gEFlBnaJgblJRsFYaJX7FahWoHqEHLetjNFLcnvyXkQz617XyKurEPbKByHUFQtNbvrhF3ZNzT
 96+5iwN6BU/w2rrG27bVET73WsZhe6fmQe0NFTpjE2gOd1ACrGVOHYKUyPpJtjcwZrODIHOdFg
 LkM=
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="104168103"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2021 06:16:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 06:16:41 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 4 Jan 2021 06:16:39 -0700
Message-ID: <5e5332e026af5d3716cf9bb0aa404783b53f9e02.camel@microchip.com>
Subject: Re: [PATCH v11 3/4] phy: Add Sparx5 ethernet serdes PHY driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Mon, 4 Jan 2021 14:16:38 +0100
In-Reply-To: <20210104121502.GK31158@unreal>
References: <20210104082218.1389450-1-steen.hegelund@microchip.com>
         <20210104082218.1389450-4-steen.hegelund@microchip.com>
         <20210104121502.GK31158@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,


On Mon, 2021-01-04 at 14:15 +0200, Leon Romanovsky wrote:
> 
> <...>
> 
> > +struct sparx5_sd10g28_args {
> > +     bool                 skip_cmu_cfg; /* Enable/disable CMU cfg
> > */
> > +     bool                 no_pwrcycle;  /* Omit initial power-
> > cycle */
> > +     bool                 txinvert;     /* Enable inversion of
> > output data */
> > +     bool                 rxinvert;     /* Enable inversion of
> > input data */
> > +     bool                 txmargin;     /* Set output level to 
> > half/full */
> > +     u16                  txswing;      /* Set output level */
> > +     bool                 mute;         /* Mute Output Buffer */
> > +     bool                 is_6g;
> > +     bool                 reg_rst;
> > +};
> 
> All those bools in structs can be squeezed into one u8, just use
> bitfields, e.g. "u8 a:1;".

Got you.

> 
> Also I strongly advise do not do vertical alignment, it will cause to
> too many churn later when this code will be updated.

So just a single space between the type and the name and the comment is
preferable?

> 
> > +
> 
> <...>
> 
> > +static inline void __iomem *sdx5_addr(void __iomem *base[],
> > +                                   int id, int tinst, int tcnt,
> > +                                   int gbase, int ginst,
> > +                                   int gcnt, int gwidth,
> > +                                   int raddr, int rinst,
> > +                                   int rcnt, int rwidth)
> > +{
> > +#if defined(CONFIG_DEBUG_KERNEL)
> > +     WARN_ON((tinst) >= tcnt);
> > +     WARN_ON((ginst) >= gcnt);
> > +     WARN_ON((rinst) >= rcnt);
> > +#endif
> 
> Please don't put "#if defined(CONFIG_DEBUG_KERNEL)", print WARN_ON().

OK, I will drop the #if and keep the WARN_ON...

> 
> Thanks

Thank you for your comments.

BR
Steen

