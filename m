Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F603BC07
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbfFJSv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:51:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387643AbfFJSv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 14:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lbqqcddIXUK4Qt7ADiSO1yJTcmHpDZCJi6Xhhhmc1fA=; b=dCH0J7KKGXlYUBZ/L4WeB7kDVr
        iS/Jz1qB4h7Ok+g6qIVkIAHlTpe4Xp+CvOUglOc5V58OSXdbVCk0wRRm6qEgCiBt1fxCJJoSPmbyg
        96LiLSv+5tuUOAZETvEj7flHBuwbCYsIFDFRHvBs3xJ7iSdeTbuvjacXEglpDcDmeKkA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haPO7-00018u-4b; Mon, 10 Jun 2019 20:51:23 +0200
Date:   Mon, 10 Jun 2019 20:51:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] net: phy: add state PERM_FAIL
Message-ID: <20190610185123.GA2191@lunn.ch>
References: <8e4cd03b-2c0a-ada9-c44d-2b5f5bd4f148@gmail.com>
 <9e1b2e30-139d-c3b9-0ac3-5775a4ade3a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e1b2e30-139d-c3b9-0ac3-5775a4ade3a6@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - a PHY driver that requires a firmware should either be loaded prior to
> Linux taking over the PHY, or should be loaded by the PHY driver itself

Hi Florian

Both the Marvell10g and Aquantia PHY need the firmware in their FLASH.
It is a slow operation to perform. And so far, everybody has done it
from user space. I'm not sure we want to hold up the PHY driver probe
for multiple minutes if we where to do this in kernel.

> So the bottom line of my reasoning is that, if we could make this
> marvell10g specific for now, and we generalize that later once we find a
> second candidate, that would seem preferable.

The obvious second candidate is the Aquantia PHY. And i probably have
a board without firmware.

  Andrew
