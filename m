Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9361817E578
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCIROS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:14:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53550 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbgCIROR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 13:14:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CwSFcsr7HUwB0+SG3NfecvwPFIxrrFqaamNRSJhEx7Q=; b=sydw3DNLseHbaZT/EsNigrcvx9
        hJse2Wrqva+aolZTXuD6GT9QtHYisXijO/wFsYPx2Fwfx6oNBZlLUAXssNKGoFZgaC5T8NBPR4AC5
        Mrg/1cn64UqH44ksvAgLBfr9G/QDvla9+rkstXKwmei2NRQ4TY2OY3Tbx2ZXc7Cl2cxQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jBLyn-0003l2-Jn; Mon, 09 Mar 2020 18:14:13 +0100
Date:   Mon, 9 Mar 2020 18:14:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
Subject: Re: [PATCH v2 1/2] net: phy: tja11xx: add TJA1102 support
Message-ID: <20200309171413.GA14181@lunn.ch>
References: <20200309074044.21399-1-o.rempel@pengutronix.de>
 <20200309074044.21399-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309074044.21399-2-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 08:40:43AM +0100, Oleksij Rempel wrote:
> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> configured in device tree by setting compatible = "ethernet-phy-id0180.dc81".

Hi Oleksij

Given what the second patch does, there is no need to set the
compatible. So please reword this.

	    Andrew
