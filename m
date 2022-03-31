Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3CF4EDC93
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiCaPUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiCaPUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:20:01 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C51C220B23;
        Thu, 31 Mar 2022 08:18:14 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0F5EE22239;
        Thu, 31 Mar 2022 17:18:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648739893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Kc6voaVT0wBbGgckX1LSOGvhb3m0uQ57t2GbwUzI8o=;
        b=rMXJB/PGKE2jWLKL6XnO7Zk3OaHQ12CN2WFl0ciM/P4VJl+IlrKW9REGBJQyVwahpZmKLf
        0QTrpdmCAl3rc0EoYebHtHrcn+pGpZBjOR5Cjr1dsgkXsUJwk7OlCij0sqirFPpMAujmW+
        xs07enw0CrAn2ZsA8jKbFnpBwIKblmI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Mar 2022 17:18:12 +0200
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/3] dt-bindings: net: convert mscc-miim to
 YAML format
In-Reply-To: <20220331151440.3643482-1-michael@walle.cc>
References: <20220331151440.3643482-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <86d28971a11f08a9b402d81d485fb95b@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Forgot the cover letter]

Subject: [PATCH RFC net-next 0/3] net: phy: mscc-miim: add MDIO bus
  frequency support

Introduce MDIO bus frequency support. This way the board can have a
faster (or maybe slower) bus frequency than the hardware default.

Michael Walle (3):
   dt-bindings: net: convert mscc-miim to YAML format
   dt-bindings: net: mscc-miim: add clock and clock-frequency
   net: phy: mscc-miim: add support to set MDIO bus frequency

  .../devicetree/bindings/net/mscc,miim.yaml    | 60 +++++++++++++++++++
  .../devicetree/bindings/net/mscc-miim.txt     | 26 --------
  drivers/net/mdio/mdio-mscc-miim.c             | 52 +++++++++++++++-
  3 files changed, 110 insertions(+), 28 deletions(-)
  create mode 100644 Documentation/devicetree/bindings/net/mscc,miim.yaml
  delete mode 100644 Documentation/devicetree/bindings/net/mscc-miim.txt

-- 
2.30.2
