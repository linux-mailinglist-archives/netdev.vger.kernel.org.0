Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A65BE9D0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiITPOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiITPOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:14:17 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685B65AC6C;
        Tue, 20 Sep 2022 08:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1663686857;
  x=1695222857;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RDguGnCJWx2LYWh0w/V/PjZ1+JkfuIMZE53nxHj5EEY=;
  b=qJII7PAzH5OomoWyWgIVMhlUa2jOmteYqBxot9vWrGJwGdBgI+OdjAhG
   35ZNFrZRgZ8yOVY++FXurUwLMFx9kJRQh9QIwGrVMz0pHlNQIOgxDMVjp
   JAe1uuVf0Wvnjr26fVt45d8t+vfcO7H0d7kFALd0ozOUH5+4mbSeHBvH6
   T4r2MU1dyl6qKboraCD+x/nZMDyBhx/IG6eiWCD8Zdy7n4Kcf2p8cu1tW
   l+18MexznJ+jpGknJg0EZ7VAf0NVqs78+3GFTbTPnc+wosRCN2vArHfnq
   BY9GFNyxN3XDSqfv2LjnbDI0KgbG4esQbXmd3htny3AR4wlFvoyP5H6Lg
   g==;
From:   Marcus Carlberg <marcus.carlberg@axis.com>
To:     <lxu@maxlinear.com>, <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <kernel@axis.com>,
        Marcus Carlberg <marcus.carlberg@axis.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <devicetree@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] net: phy: mxl-gpy: Add mode for 2 leds
Date:   Tue, 20 Sep 2022 17:14:09 +0200
Message-ID: <20220920151411.12523-1-marcus.carlberg@axis.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPY211 phy default to using all four led pins.
Hardwares using only two leds where led0 is used as the high
network speed led and led1 the low network speed led will not
get the correct behaviour since 1Gbit and 2.5Gbit will not be
represented at all in the existing leds.


Marcus Carlberg (2):
  dt-bindings: net: Add mxl,gpy
  net: phy: mxl-gpy: Add mode for 2 leds

 .../devicetree/bindings/net/mxl,gpy.yaml      | 39 ++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
 MAINTAINERS                                   |  1 +
 drivers/net/phy/mxl-gpy.c                     | 45 +++++++++++++++++++
 4 files changed, 87 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mxl,gpy.yaml

--
2.20.1

