Return-Path: <netdev+bounces-7564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4CA7209C6
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E55301C21126
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E061E51F;
	Fri,  2 Jun 2023 19:26:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8640B1E510
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:26:55 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C948BCE;
	Fri,  2 Jun 2023 12:26:53 -0700 (PDT)
Received: from arisu.localnet (unknown [23.233.251.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id 0850C66066EC;
	Fri,  2 Jun 2023 20:26:50 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685734012;
	bh=K2VKtEmDpy08yDsNjAgi61u3CcMiqyOtI/vNCwLfGaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpgWdHN9Xowv7q0wPCaVOGHELi+gsTTsQR8A2pIbhFfJEghkY56y493jFVDarsu7O
	 dRUAaEXzj8CUwQPgY1VkbBuCgME3IsDFpWJOWDDXip9TIY98ikv2rtJnW7tSWk0QJf
	 WenvFzPMDo73fivy4/tfFQRfBbP5w81N9/mX9Lv8PfHV5moA23Jy6YISpiAWsAgLfk
	 kvARRnZLQ+CTHCl3VStLQG6SVXPi3F1QxZ5jNul8LqjiSg/EFgrbVEmU28s8Kj2wtT
	 GKkb3KNUbPdO+Gapiou/O8ldel0unGq6pR0Juj5q+WZxZApylc4ZjggzuUUh6SX5DD
	 yKmMOgA6tZgEA==
From: Detlev Casanova <detlev.casanova@collabora.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject:
 Re: [PATCH v2 2/3] dt-bindings: net: phy: Document support for external PHY
 clk
Date: Fri, 02 Jun 2023 15:26:53 -0400
Message-ID: <2288019.ElGaqSPkdT@arisu>
In-Reply-To: <4255bc0a-491c-4fbb-88ea-ec1d864a1a24@lunn.ch>
References:
 <20230602182659.307876-1-detlev.casanova@collabora.com>
 <20230602182659.307876-3-detlev.casanova@collabora.com>
 <4255bc0a-491c-4fbb-88ea-ec1d864a1a24@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Friday, June 2, 2023 2:42:38 P.M. EDT Andrew Lunn wrote:
> On Fri, Jun 02, 2023 at 02:26:58PM -0400, Detlev Casanova wrote:
> > Ethern PHYs can have external an clock that needs to be activated before
> > probing the PHY.
> 
> `Ethernet PHYs can have an external clock.`
> 
> We need to be careful with 'activated before probing the PHY'. phylib
> itself will not activate the clock. You must be putting the IDs into
> the compatible string, so the correct driver is loaded, and its probe
> function is called. The probe itself enables the clock, so it is not
> before probe, but during probe.
> 
> I'm picky about this because we have issues with enumerating the MDIO
> bus to find PHYs. Some boards needs the PHY taking out of reset,
> regulators enabled, clocks enabled etc, before the PHY will respond on
> the bus. It is hard for the core to do this, before the probe. So we
> recommend putting IDs in the compatible, so the driver probe function
> to do any additional setup needed.

That makes sense, In my head, "probing" == calling phy_write/read() functions. 
But I get how this could be confused with the _probe() function. (And I just 
realised that there are typos)

What about "Ethernet PHYs can have an external clock that needs to be 
activated before communicating with the PHY" ?

> > Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
> > ---
> > 
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > b/Documentation/devicetree/bindings/net/ethernet-phy.yaml index
> > 4f574532ee13..c1241c8a3b77 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > 
> > @@ -93,6 +93,12 @@ properties:
> >        the turn around line low at end of the control phase of the
> >        MDIO transaction.
> > 
> > +  clocks:
> > +    maxItems: 1
> > +    description:
> > +      External clock connected to the PHY. If not specified it is assumed
> > +      that the PHY uses a fixed crystal or an internal oscillator.
> 
> This text is good.

Detlev





