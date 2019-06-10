Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939683B742
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403870AbfFJOZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:25:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403856AbfFJOZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0dnN1/LB2mUfaXo+9py5WO3Xb+pACF5PH+CoF4T1TaE=; b=LZtX7PwfSrYZB6Q1cBk8ty4bc/
        Gtz2ZTqMraFmWdHRMjnJyj9bSyon5Snm65venVlgmq8XPgn96nIAPy1FuYxbrDCHzBeqhaWwdxPH3
        2hetBoZZcGhwLV2/sc/+ctb1N7rXDDEIuPFCbkQ14QoWyQvNHq/Uy4AQGLnsQVHeNpQY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haLEM-0007bO-Cy; Mon, 10 Jun 2019 16:25:02 +0200
Date:   Mon, 10 Jun 2019 16:25:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 04/11] dt-bindings: net: phy: The interrupt property
 is not mandatory
Message-ID: <20190610142502.GF28724@lunn.ch>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <19f160b6edf5a11171cea249305b7458c96a7187.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f160b6edf5a11171cea249305b7458c96a7187.1560158667.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:25:43AM +0200, Maxime Ripard wrote:
> Unlike what was initially claimed in the PHY binding, the interrupt
> property of a PHY can be omitted, and the OS will turn to polling instead.
> 
> Document that.

Ah!

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
