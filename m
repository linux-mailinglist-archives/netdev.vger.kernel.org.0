Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE801B469B
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgDVNtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:49:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVNtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 09:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xsc2UCHP/bV75vanRUlXAA/m2cJnJh00qNoPF97HRqY=; b=39uh4IYxufmxsYJIUKaZlK17cx
        0LVvqkAEoAMQFsba/IW81vxR5zBu4xaeBG0ZnrbOHz8dh+6hWDyi1UMA26DB2xRTBCXRjf/As4stm
        ELLsjKkJh6sgdf0Et7ar8tSMORcxIm/YCzaCriGVN0TPKDGKIw8PMwIb6JOCLU70CI4Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRFkl-004D9b-Ll; Wed, 22 Apr 2020 15:49:27 +0200
Date:   Wed, 22 Apr 2020 15:49:27 +0200
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
Subject: Re: [PATCH net-next v5 1/4] dt-bindings: net: phy: Add support for
 NXP TJA11xx
Message-ID: <20200422134927.GE974925@lunn.ch>
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422092456.24281-2-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:24:53AM +0200, Oleksij Rempel wrote:
> Document the NXP TJA11xx PHY bindings.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
