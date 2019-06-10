Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6EE3B76A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403904AbfFJObv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:31:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41730 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403864AbfFJObu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JRYueMLRQECogmZaB6ntHx4NwLFSr0m7XU9IdQBzel4=; b=m06qR7H0rnzOHJEwWUJ9aqNCao
        yHKplEn/FE3sVKF8/vKlMlQq8dwQiN+HnzaDdA17NCQ6HIftnvxJAonp8myb6r9qOI0EY0bhzEx8S
        cBOeIg3pl/zsC8/rW8TJMUcf1A7TMYAWVagSWhyTJUV1ElJpgOzXe+VGBh2nXURittk8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haLKl-0007g3-EW; Mon, 10 Jun 2019 16:31:39 +0200
Date:   Mon, 10 Jun 2019 16:31:39 +0200
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
Subject: Re: [PATCH v2 05/11] dt-bindings: net: sun4i-emac: Convert the
 binding to a schemas
Message-ID: <20190610143139.GG28724@lunn.ch>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d198d29119b37b2fdb700d8992b31963e98b6693.1560158667.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - phy
> +  - allwinner,sram

Quoting ethernet.txt:

- phy: the same as "phy-handle" property, not recommended for new bindings.

- phy-handle: phandle, specifies a reference to a node representing a PHY
  device; this property is described in the Devicetree Specification and so
  preferred;

Can this be expressed in Yaml? Accept phy, but give a warning. Accept
phy-handle without a warning? Enforce that one or the other is
present?

Thanks
	Andrew
