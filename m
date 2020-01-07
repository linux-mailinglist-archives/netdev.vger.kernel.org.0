Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32AFD13277B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgAGNVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:21:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgAGNVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 08:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CrkNjGazMW+zoOdGlarP5I4eBBOORn1ZisIsMHSTOR8=; b=kpMZwwj+gfZ7Ut8xreJoKRuJxE
        qI/81PKNiiLyo+J4nuq5VkeUfwJMKcK/phV4qUNMGN09W4sSUttlRz1dMqvDqNlxQrbCvNK3Z/Jxz
        eyo4StP9zAU1MpxiTi/QXuVMYhwcIWeks1/aEeNqWbWbfCjsURkRAMteEDszISNSCwP0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioonu-0007uq-JR; Tue, 07 Jan 2020 14:21:50 +0100
Date:   Tue, 7 Jan 2020 14:21:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Johnson CH Chen =?utf-8?B?KOmZs+aYreWLsyk=?= 
        <JohnsonCH.Chen@moxa.com>
Cc:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Subject: Re: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Message-ID: <20200107132150.GB23819@lunn.ch>
References: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 72868a28b621..ab4e45199df9 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -833,6 +833,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
>  
>  	/* Find the TBI PHY.  If it's not there, we don't support SGMII */
>  	priv->tbi_node = of_parse_phandle(np, "tbi-handle", 0);
> +	priv->dma_endian_le = of_property_read_bool(np, "fsl,dma-endian-le");

Hi Johnson

You need to document this new property in the binding.

Thanks
	Andrew
