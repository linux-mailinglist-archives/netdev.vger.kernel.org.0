Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFAA37A714
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhEKMve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:51:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhEKMvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k+0in8olmq8op0O1A2AVJ/9QwpXrYDyhMJYyJr1iSyY=; b=GuvjeAVwIPepqF+En/OUexakgN
        l6RRoj7tfbHIFZQ5wM6RKa4D5jg+72sSSAi/wXE2Ma8anv210EFzW7+3uqEu3CSMIYCR/p7VBBAca
        7oX1t0sevSi394yN12qv/3bD/2Vqslf17frVBWWk0zxT+6U8GlsLiicCy34f4T8O0+kI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRqB-003kCg-3B; Tue, 11 May 2021 14:50:23 +0200
Date:   Tue, 11 May 2021 14:50:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v3 2/7] ARM i.MX6q: remove part of ar8031_phy_fixup()
Message-ID: <YJp9j41v8iWBnJwI@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:30AM +0200, Oleksij Rempel wrote:
> This part of this fixup is overwritten by at803x_config_init() in
> drivers/net/phy/at803x.c. No additional devicetree fixes are needed.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
