Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01444972BF
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbiAWPyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 10:54:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbiAWPyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 10:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7QuzV0xUqMcqlybybHjjxruT8uYyoncKxFO84jO3pZw=; b=6RDIz5HpE/Hb76XWRZjGAksyKY
        ufq2ZfMZbZYskeE/CyfAwTIw7uqHxUZEbhvswZ5Lel1yuQFp33k+ktJTuvvmzj0+psykPL+FQwnMc
        n9oI4RcEi1LB5i5ImrzjA1iffn8B+LF1DOrstaDmET1hM0Isb4BRjw7xRix1PR+7LMkI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBfCC-002OMg-QW; Sun, 23 Jan 2022 16:54:24 +0100
Date:   Sun, 23 Jan 2022 16:54:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] net: dsa|ethernet: use bool values to pass bool param of
 phy_init_eee
Message-ID: <Ye16MDZ/Bp2KZcJq@lunn.ch>
References: <20220123152241.1480-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123152241.1480-1-jszhang@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 11:22:41PM +0800, Jisheng Zhang wrote:
> The 2nd param of phy_init_eee(): clk_stop_enable is a bool param, use
> true or false instead of 1/0.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
