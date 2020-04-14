Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF11A8A21
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504390AbgDNStF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:49:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37422 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504372AbgDNStD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 14:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OxNpUlNUMK2ThL4G37x7qilt6pOwxaWeKjcSrWQZuEU=; b=Hr8ic4xoLmRAc/SmERd5yeQF+U
        nVeHXZzHEWwXiRGSXCAyUUATS+Vq0N9LWfkWrKRCLDwobF1MrTUNT6MmIkKhp4+CDTVL5y8rXxSgL
        +kCxg2pVtKCW1ORV/g/6rIXP/ssFaqHzWO+sjSrr53Uq10aH6PBcDU3bJFxj7U3w/LL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOQcD-002i4U-RX; Tue, 14 Apr 2020 20:48:57 +0200
Date:   Tue, 14 Apr 2020 20:48:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: marvell10g: soft-reset the PHY when coming
 out of low power
Message-ID: <20200414184857.GE637127@lunn.ch>
References: <20200414182935.GY25745@shell.armlinux.org.uk>
 <E1jOQKC-0001WS-OW@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jOQKC-0001WS-OW@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 07:30:20PM +0100, Russell King wrote:
> Soft-reset the PHY when coming out of low power mode, which seems to
> be necessary with firmware versions 0.3.3.0 and 0.3.10.0.
> 
> This depends on ("net: marvell10g: report firmware version")
> 
> Fixes: c9cc1c815d36 ("net: phy: marvell10g: place in powersave mode at probe")
> Reported-by: Matteo Croce <mcroce@redhat.com>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
