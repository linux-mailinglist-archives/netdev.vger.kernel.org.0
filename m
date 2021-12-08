Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14EA46CE99
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240937AbhLHICN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Dec 2021 03:02:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43269 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhLHICM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:02:12 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 6A529E0011;
        Wed,  8 Dec 2021 07:58:38 +0000 (UTC)
Date:   Wed, 8 Dec 2021 08:58:14 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v6 4/4] net: ocelot: add FDMA support
Message-ID: <20211208085814.19e4ec71@fixe.home>
In-Reply-To: <20211207194514.32218911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207154839.1864114-1-clement.leger@bootlin.com>
        <20211207154839.1864114-5-clement.leger@bootlin.com>
        <20211207194514.32218911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 7 Dec 2021 19:45:14 -0800,
Jakub Kicinski <kuba@kernel.org> a écrit :

> On Tue,  7 Dec 2021 16:48:39 +0100 Clément Léger wrote:
> > + * struct ocelot_fdma - FDMA struct
> > + *
> > + * @ocelot: Pointer to ocelot struct
> > + * @base: base address of FDMA registers
> > + * @irq: FDMA interrupt
> > + * @ndev: Net device used to initialize NAPI
> > + * @dcbs_base: Memory coherent DCBs
> > + * @dcbs_dma_base: DMA base address of memory coherent DCBs
> > + * @tx_ring: Injection ring
> > + * @rx_ring: Extraction ring
> > + */
> > +struct ocelot_fdma {
> > +	int irq;
> > +	struct net_device *ndev;
> > +	struct ocelot_fdma_dcb *dcbs_base;
> > +	dma_addr_t dcbs_dma_base;
> > +	struct ocelot_fdma_tx_ring tx_ring;
> > +	struct ocelot_fdma_rx_ring rx_ring;
> > +	struct napi_struct napi;
> > +	struct ocelot *ocelot;  
> 
> one more nit:
> 
> drivers/net/ethernet/mscc/ocelot_fdma.h:156: warning: Function parameter or member 'napi' not described in 'ocelot_fdma'

And base does not exists anymore. I will also reorder the members in
the doc to match the struct.



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
