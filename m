Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD0A11F837
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 15:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfLOO4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 09:56:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfLOO4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 09:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aSDoYvski6KrHjO/SxQdaLmUSwInVtrjI5zilo+uW/M=; b=uoZ5zrawSEEKi2ySQK+8iUHtAU
        tM8YHSSrGboDc5OHvOu2UlKj3eGlaeBZrbLbEO3jvt6IkPLWVzFXYS4T/h5X4a0RV7pTcPAttm3rb
        UJCHaOkko5iXqj9bP+G86PMaXJ0gpwGUH5BaokGciSn2VHEuHyyj6bUAWm6mAfEIhK8c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1igVJW-0004bR-1U; Sun, 15 Dec 2019 15:56:06 +0100
Date:   Sun, 15 Dec 2019 15:56:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Milind Parab <mparab@cadence.com>
Cc:     nicolas.nerre@microchip.com, antoine.tenart@bootlin.com,
        f.fainelli@gmail.com, rmk+kernel@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, dkangude@cadence.com,
        a.fatoum@pengutronix.de, brad.mouring@ni.com, pthombar@cadence.com
Subject: Re: [PATCH v2 2/3] net: macb: add support for C45 MDIO read/write
Message-ID: <20191215145606.GC22725@lunn.ch>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
 <1576230111-11325-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576230111-11325-1-git-send-email-mparab@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 09:41:51AM +0000, Milind Parab wrote:
> This patch modify MDIO read/write functions to support
> communication with C45 PHY.
> 
> Signed-off-by: Milind Parab <mparab@cadence.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
