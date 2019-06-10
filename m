Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119913B737
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403854AbfFJOX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:23:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403788AbfFJOX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9OSybgnmQ91PoaXFVruGCEv1Em60aOgOJ3s88JwC90A=; b=JUHX3imtoLCTLucGaqpxbV3ecD
        fDbWpXOLo+4pMwc7VsQeUy++5XgaTm20OURI7N1WnP6SHAUeCoU0JiRIjXbJSlBXVIcHEYkuyyLZF
        ySOyOCEV+wodnQNbm2ZLDR7LUNNbMVbhd+9efQsZC290P/r4bz1095EI0z9ZJO/uSPN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haLD5-0007YS-3K; Mon, 10 Jun 2019 16:23:43 +0200
Date:   Mon, 10 Jun 2019 16:23:43 +0200
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
Subject: Re: [PATCH v2 02/11] dt-bindings: net: Add a YAML schemas for the
 generic PHY options
Message-ID: <20190610142343.GD28724@lunn.ch>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <b5c46cff5b59d021634be143cf559c597f0a0e1f.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5c46cff5b59d021634be143cf559c597f0a0e1f.1560158667.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +required:
> +  - reg
> +  - interrupts

Hi Maxime

Interrupts are not required. That is an error in the .txt binding
document.

Otherwise, this looks good:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
