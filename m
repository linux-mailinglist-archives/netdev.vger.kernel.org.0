Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CA71B4677
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgDVNow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:44:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgDVNov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 09:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=39hwadweG9ZMKAwh1ehBCYMhj/x5JCoSO4kLzo1Ms5M=; b=3AuQG2Zl7GoNnqXbaAoC906fjI
        8mM9jGTLDIVYS/uFyswT6L0XYKNv/DhU+Rayfr4Ssa7JmlTBOBI6sJtNSn4s376kwSBli0EH+R8eW
        UU22fWJ2VDtWBsdnvrTBsc0J772sfnordP4SugiO2B2lOprOKdeTrIr2VnWJVRyphiW0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRFgA-004D5t-9f; Wed, 22 Apr 2020 15:44:42 +0200
Date:   Wed, 22 Apr 2020 15:44:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/4] net: phy: tja11xx: add initial TJA1102
 support
Message-ID: <20200422134442.GB974925@lunn.ch>
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422092456.24281-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:24:54AM +0200, Oleksij Rempel wrote:
> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> Both PHYs are similar but have different amount of functionality. For
> example PHY 1 has no PHY ID and no health monitor.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
