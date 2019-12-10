Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8765118E8E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfLJRH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:07:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfLJRH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LGbka/8dCqNj/EDKn5JGDTZmSg6pbK/+YGDg7iI9p+k=; b=aWWuKnmbNqtg6S7E8g31qfetRI
        h6QT1n8En/gSD2I13Zq3sFpP8x9jDd1avuTSIapV6Vr8Q12QWudE8DxQi7vFZ7ao3jyHgfazv5zDi
        Z7Y5wXylBEyj6Wv+s5P+OAT9SQbpHdlF+yDVBvk+JHjtm3SRkiyuzi37NNSAFrplEQUE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieizJ-0005aN-6G; Tue, 10 Dec 2019 18:07:53 +0100
Date:   Tue, 10 Dec 2019 18:07:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/14] net: phylink: support Clause 45 PHYs
 on SFP+ modules
Message-ID: <20191210170753.GN27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKoU-0004vM-Jr@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKoU-0004vM-Jr@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:19:06PM +0000, Russell King wrote:
> Some SFP+ modules have Clause 45 PHYs embedded on them, which need a
> little more handling in order to ensure that they are correctly setup,
> as they switch the PHY link mode according to the negotiated speed.
> 
> With Clause 22 PHYs, we assumed that they would operate in SGMII mode,
> but this assumption is now false.  Adapt phylink to support Clause 45
> PHYs on SFP+ modules.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
