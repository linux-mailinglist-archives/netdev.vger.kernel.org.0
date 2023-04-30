Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B326F29FA
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjD3RTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjD3RTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:19:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE5E3AAE;
        Sun, 30 Apr 2023 10:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=W2m9o5cAZcUL4YwF6LNqupdePboCY6WLH6EEUshsr3k=; b=h/
        v1BqlSOSj4XcZqtRa6+SdSZW7KyYBo8pN4hWyOTz+aKTF/WiuNz2KryyZ+I7WmRK9FCVsahgmC/qx
        Gcgk+6q+8JKcX8VvNm23QRkNth3TIQea829DuinR4SMHPcZ/7/WlqUJTXcaPw8QepSNQOSHRJ0iJv
        qKBPQzX4m04tydo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ptAgT-00BYs6-15; Sun, 30 Apr 2023 19:18:01 +0200
Date:   Sun, 30 Apr 2023 19:18:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     David Bauer <mail@david-bauer.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
Message-ID: <04cc2904-6d61-416e-bfbe-c24d96fe261b@lunn.ch>
References: <20230430112834.11520-1-mail@david-bauer.net>
 <20230430112834.11520-2-mail@david-bauer.net>
 <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
 <396fad42-89d0-114d-c02e-ac483c1dd1ed@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <396fad42-89d0-114d-c02e-ac483c1dd1ed@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 07:17:10PM +0300, Arınç ÜNAL wrote:
> On 30.04.2023 15:34, Arınç ÜNAL wrote:
> > On 30.04.2023 14:28, David Bauer wrote:
> > > Document the ability to add nodes for the MDIO bus connecting the
> > > switch-internal PHYs.
> > 
> > This is quite interesting. Currently the PHY muxing feature for the
> > MT7530 switch looks for some fake ethernet-phy definitions on the
> > mdio-bus where the switch is also defined.
> > 
> > Looking at the binding here, there will be an mdio node under the switch
> > node. This could be useful to define the ethernet-phys for PHY muxing
> > here instead, so we don't waste the register addresses on the parent
> > mdio-bus for fake things. It looks like this should work right out of
> > the box. I will do some tests.
> 
> Once I start using the mdio node it forces me to define all the PHYs which
> were defined as ports.

Try setting ds->slave_mii_bus to the MDIO bus you register via
of_mdiobus_register().

	Andrew
