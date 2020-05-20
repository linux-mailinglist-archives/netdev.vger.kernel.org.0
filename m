Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D0D1DB865
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgETPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:36:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgETPgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yf2T1OA+7ro3NTkAZ7MpRRj3wmSNrDc3pMVYXD/pwas=; b=oVGaWmuR0ujhYQHjzUI8aDreok
        pETv//GDy80mgnxR0bYog1ZKbxXKEdE+ygCS9hsyzYGzlkg3SLsEhxA1UI0tpPfUExZa6u1TUsjMX
        2dRGwnt3xraKVeFBfUYID7AwP4tiZenyNTftwg5bVo3FvSN4G6OYb5GOPk7rkwOwPn7w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbQlj-002opy-TO; Wed, 20 May 2020 17:36:31 +0200
Date:   Wed, 20 May 2020 17:36:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200520153631.GH652285@lunn.ch>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com>
 <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Dan
> > 
> > Having it required with PHY_INTERFACE_MODE_RGMII_ID or
> > PHY_INTERFACE_MODE_RGMII_RXID is pretty unusual. Normally these
> > properties are used to fine tune the delay, if the default of 2ns does
> > not work.
> 
> Also if the MAC phy-mode is configured with RGMII-ID and no internal delay
> values defined wouldn't that be counter intuitive?

Most PHYs don't allow the delay to be fine tuned. You just pass for
example PHY_INTERFACE_MODE_RGMII_ID to the PHY driver and it enables a
2ns delay. That is what people expect, and is documented.

Being able to tune the delay is an optional extra, which some PHYs
support, but that is always above and beyond
PHY_INTERFACE_MODE_RGMII_ID.

     Andrew
