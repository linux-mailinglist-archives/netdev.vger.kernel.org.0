Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895F347F913
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 22:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhLZVvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 16:51:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234563AbhLZVvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 16:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KWjqwqswlcdAbUhm0etBm0ynDTKsWAc8HBTk4QxWbYs=; b=BI7SqIkp3zkvi0hI4KU5ODmyQD
        WGywKCiQGEmNIbfPZYXn5sRy4QU7/IFELfz/ieoz4BBOsEVK6NlgTBIUd2LQDnyAoqp/BXxZ8WUSk
        f/Y2q0sWTA/Eyug/EzLEQ1Z96l6upaCbWCDIz0HtX3SLSEf+yVWhzq74+3r+AkVgBbKI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n1bQ4-00HWwe-62; Sun, 26 Dec 2021 22:51:08 +0100
Date:   Sun, 26 Dec 2021 22:51:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <YcjjzNJ159Bo1xk7@lunn.ch>
References: <YcjepQ2fmkPZ2+pE@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcjepQ2fmkPZ2+pE@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (phy_register & MII_ADDR_C45) {
> +		u8 dev_num = (phy_register >> 16) & 0x1f;
> +		u16 reg = (u16)(phy_register & 0xffff);

Hi Daniel

You can use the helpers

mdio_phy_id_is_c45()
mdio_phy_id_prtad()
mdio_phy_id_devad()

	Andrew
