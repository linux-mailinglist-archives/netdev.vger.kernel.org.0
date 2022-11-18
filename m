Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCB262EA85
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbiKRAo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240667AbiKRAoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:44:17 -0500
Received: from finn.localdomain (finn.gateworks.com [108.161.129.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0302974CEF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:44:16 -0800 (PST)
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by finn.localdomain with esmtp (Exim 4.93)
        (envelope-from <tharvey@gateworks.com>)
        id 1ovp2s-000nxs-OE; Fri, 18 Nov 2022 00:15:50 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH 0/3] add dt configuration for dp83867 led modes
Date:   Thu, 17 Nov 2022 16:15:45 -0800
Message-Id: <20221118001548.635752-1-tharvey@gateworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a dt-prop ti,led-modes to configure dp83867 PHY led
modes, adds the code to implement it, and updates some board dt files
to use the new property.

Tim Harvey (3):
  dt-bindings: net: phy: dp83867: add LED mode property
  net: phy: dp83867: add LED mode configuration via dt
  arm64: dts: imx8m*-venice: add dp83867 PHY LED mode configuration

 .../devicetree/bindings/net/ti,dp83867.yaml   |  6 ++++
 .../dts/freescale/imx8mm-venice-gw700x.dtsi   |  6 ++++
 .../dts/freescale/imx8mm-venice-gw7902.dts    |  6 ++++
 .../dts/freescale/imx8mn-venice-gw7902.dts    |  6 ++++
 drivers/net/phy/dp83867.c                     | 32 +++++++++++++++++--
 include/dt-bindings/net/ti-dp83867.h          | 16 ++++++++++
 6 files changed, 70 insertions(+), 2 deletions(-)

-- 
2.25.1

