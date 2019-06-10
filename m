Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6EA3B7CB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390998AbfFJOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:52:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389123AbfFJOw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ED2pky0FTB45xnVL6dthSJCZIJGqY34fD49Gx4xy+1U=; b=0gX1TrK9/BThK6tE3UCCb8nGR5
        8ChgklA4PBWDd7OQblRURjPEiKVrX3LxwVXldmTSQ7Qj65Vt3yWctap+kJqovoG1XcQfqLlYFC37k
        n+Y9S+2AShG2OsTdxCRe02pMpv8tNntWhQfZIlwEG+P3len6TiUKMQnehb/JMPGHVFH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haLel-0007wg-5K; Mon, 10 Jun 2019 16:52:19 +0200
Date:   Mon, 10 Jun 2019 16:52:19 +0200
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
Subject: Re: [PATCH v2 11/11] ARM: dts: sunxi: Switch to the generic PHY
 properties
Message-ID: <20190610145219.GJ28724@lunn.ch>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <af3a342a6cba1dda27763c13093a8fc060946c1e.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3a342a6cba1dda27763c13093a8fc060946c1e.1560158667.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:25:50AM +0200, Maxime Ripard wrote:
> The DWMAC specific properties to manage the PHY have been superseeded by
> the generic PHY properties. Let's move to it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
