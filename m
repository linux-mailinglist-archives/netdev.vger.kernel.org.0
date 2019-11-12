Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03C6F90B2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKLNbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:31:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfKLNbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+iMNtfFuKMPapocSrYm5/yUtVQ820Y9VqKwYVdIubW8=; b=NiaaLD2Yv5aWU5N8OMZn/RGWex
        c7KYLimfibMoZq34x5/N9KaTjwn1AUEMTC/7xiXhYdQUKFDZ/JpFUc4FhC7TCUMXJllPPG2cHNvs7
        f0+zxtqUIlgjj1Ie8u5DWdkPk5DNuo/WA43u10A8/6wX66RCFWSWwh8pzGnj0OU6gFT8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWGh-0001Yx-RF; Tue, 12 Nov 2019 14:31:39 +0100
Date:   Tue, 12 Nov 2019 14:31:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 02/12] net: mscc: ocelot: filter out ocelot SoC
 specific PCS config from common path
Message-ID: <20191112133139.GD5090@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 02:44:10PM +0200, Vladimir Oltean wrote:
> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> The adjust_link routine should be generic enough to be (re)used by
> any SoC that integrates a switch core compatible with the Ocelot
> core switch driver.  Currently all configurations are generic except
> for the PCS settings that are SoC specific.  Move these out to the
> Ocelot SoC/board instance.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
