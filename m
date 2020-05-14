Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC591D3F49
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgENUuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:50:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgENUuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 16:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=es/CsLq8I+C86pPy2FssTUxIO7+EJSFkoJt71yhuz78=; b=EQUj4mCwaQ2bRT9ABmfNVxTYQa
        EFyLDyc7U7/E7FASHsAML5wxmmEfKhtLoBaUfkLLQg8J3pL+dEnaRUaYnwfGDY085dMfvroZjwZKq
        EZQl85VFlsjgaVd8JOKofKGUsoQILOQO3cSX1r8gNGNcIMJ4gA+u6myEr2ot7xoc1X4U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZKoG-002KR5-8a; Thu, 14 May 2020 22:50:28 +0200
Date:   Thu, 14 May 2020 22:50:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822
 phy
Message-ID: <20200514205028.GA499265@lunn.ch>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-2-dmurphy@ti.com>
 <20200514183912.GW499265@lunn.ch>
 <2f03f066-38d0-a7c7-956d-e14356ca53b3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f03f066-38d0-a7c7-956d-e14356ca53b3@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Dan
> > 
> > You say 10/100 Mbps Ethernet PHY, but then list RGMII?
> Copied from the data sheet.

O.K. So maybe it can connect over RGMII, but then only run 100Mbps
over it, rather than 1G.

> The LED_1 pin can be strapped to be an input to the chip for signal loss
> detection.  This is an optional feature of the PHY.
> 
> This property defines the polarity for the 822 LED_1/GPIO input pin.
> 
> The LOS is not required to be connected to the PHY.  If the preferred method
> is to use the SFP framework and Processor GPIOs then I can remove this from
> the patch set.
> 
> And if a user would like to use the feature then they can add it.

Well, both options are supported by the hardware. So i'm wondering if
we need to support both. So one property indicating the LOS is
actually connected to the PHY and a second indicating the polarity?

	 Andrew
