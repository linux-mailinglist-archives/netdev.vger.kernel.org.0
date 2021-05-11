Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5737A715
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhEKMwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:52:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhEKMwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DW48e5Npn7R7tB8swHUZe5/3E7cCipTaOiEJN6MrJgo=; b=MPO+gfijbOPT3RTKKkHl75Dei3
        d68moy6gpPptJxHKB0Wv9SDMFVFwpCNnGOvS2svYXWVNhVK6mvqB8FcFRFkz0/DjAJbpeRxOODdkN
        OoH9WqVFMQKHQ0ZcadYN+IaSTT3Y8h9gh/4tF87PwapCYlqr8p/phN9Fxdp41RUFXsKA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRqe-003kE3-MQ; Tue, 11 May 2021 14:50:52 +0200
Date:   Tue, 11 May 2021 14:50:52 +0200
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
Subject: Re: [PATCH v3 3/7] ARM i.MX6q: remove BMCR_PDOWN handler in
 ar8035_phy_fixup()
Message-ID: <YJp9rN4F1Nczd15C@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:31AM +0200, Oleksij Rempel wrote:
> BMCR_PDOWN is removed by resume handler at803x_resume() in
> drivers/net/phy/at803x.c
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
