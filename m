Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149161E4552
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgE0OLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:11:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgE0OLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 10:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OxoZRRNFyEC3aeUrvp7I7AVP/BuK0CH9HF7YxNLFjfs=; b=C3MXryOhx1h1lN38xLxSDauguG
        2JQf4I5B8KWc1P/PSDlksb256/xVaykxHFLvACcbFOOfoV029nQ4kuFt/AUHsLeoJA7AJqwvFY9FA
        Qx+BomREiqbUNzSfJk0MSTWtYhooq2xLP3q/pHKB9MsCTQkRwy3TicHvn8VbyJ6e96Wc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdwmG-003PYn-MO; Wed, 27 May 2020 16:11:28 +0200
Date:   Wed, 27 May 2020 16:11:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 1/2] net: mscc: use the PHY MII ioctl interface
 when possible
Message-ID: <20200527141128.GC812580@lunn.ch>
References: <20200526150149.456719-1-antoine.tenart@bootlin.com>
 <20200526150149.456719-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526150149.456719-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 05:01:48PM +0200, Antoine Tenart wrote:
> Allow ioctl to be implemented by the PHY, when a PHY is attached to the
> Ocelot switch. In case the ioctl is a request to set or get the hardware
> timestamp, use the Ocelot switch implementation for now.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
