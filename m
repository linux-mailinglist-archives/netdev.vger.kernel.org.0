Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD353B786
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389910AbfFJOhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:37:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388932AbfFJOhj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HYYn865njW+2W8J+eqxrwIHkaNNxdD54yyMpNkodzM0=; b=uxDrju9eEcQmw4Tk8oZUqdFbTK
        3OWC9nYXDuIZpNyADLbkfap6YB15xFamOw8k/X8ZxyjTRLbUDYJrlNxiZHD8nKPjE0o2d4slQ4KGy
        yJHgMQ+OHeNoVFXpDfpPQtEd27s4p5f3gEwPbFhv6ow3I1xXZTxtz55NpI3ARJa4mVBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haLQQ-0007nJ-DG; Mon, 10 Jun 2019 16:37:30 +0200
Date:   Mon, 10 Jun 2019 16:37:30 +0200
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
Subject: Re: [PATCH v2 06/11] dt-bindings: net: sun4i-mdio: Convert the
 binding to a schemas
Message-ID: <20190610143730.GH28724@lunn.ch>
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
 <664da05aaf9a7029494d72d7c536baa192672fbe.1560158667.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <664da05aaf9a7029494d72d7c536baa192672fbe.1560158667.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:25:45AM +0200, Maxime Ripard wrote:
> Switch our Allwinner A10 MDIO controller binding to a YAML schema to enable
> the DT validation.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Should there be a generic part to cover what is listed in:

Documentation/devicetree/bindings/net/mdio.txt

	Andrew
