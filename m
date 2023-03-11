Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0297F6B5C28
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 14:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCKNNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 08:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCKNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 08:13:50 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAF1F4010;
        Sat, 11 Mar 2023 05:13:48 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32BDDQDD069314;
        Sat, 11 Mar 2023 07:13:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678540406;
        bh=UH5FY4fr60bN/vvaymUr93ONSchdoiNAbwtq+FANNYY=;
        h=From:To:CC:Subject:Date;
        b=smZJixvZsH1PgjqkMJJMZT2XPKxh2jLIh28PAWkw75cnf0JQbINSZH8ui2nVX56E8
         FrfqCDSZhjx305I/tgDc1rEbv8sSylCYW3qwtvv0Ta819VHTvoV1NrOxorYZrLjTW1
         X2Rp0BSFOkbHAK75IxCSNBnKkqUpSEqRkNAlmeqQ=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32BDDQDG041947
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 11 Mar 2023 07:13:26 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Sat, 11
 Mar 2023 07:13:25 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Sat, 11 Mar 2023 07:13:25 -0600
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32BDDPxF007407;
        Sat, 11 Mar 2023 07:13:25 -0600
From:   Nishanth Menon <nm@ti.com>
To:     Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] dt-bindings: pinctrl: ti-k3: Move k3.h to arch specific
Date:   Sat, 11 Mar 2023 07:13:23 -0600
Message-ID: <20230311131325.9750-1-nm@ti.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

As discussed in [1], lets do some basic cleanups and move pin ctrl
definitions to arch folder.

Base: next-20230310

Nishanth Menon (2):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Drop pinmux header
  dt-bindings: pinctrl: Move k3.h to arch

 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml      | 1 -
 MAINTAINERS                                                 | 1 -
 arch/arm64/boot/dts/ti/k3-am62.dtsi                         | 3 ++-
 arch/arm64/boot/dts/ti/k3-am62a.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-am64.dtsi                         | 3 ++-
 arch/arm64/boot/dts/ti/k3-am65.dtsi                         | 3 ++-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-j721s2.dtsi                       | 3 ++-
 arch/arm64/boot/dts/ti/k3-j784s4.dtsi                       | 3 ++-
 .../pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h     | 6 +++---
 11 files changed, 19 insertions(+), 13 deletions(-)
 rename include/dt-bindings/pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h (94%)

[1] https://lore.kernel.org/all/c4d53e9c-dac0-8ccc-dc86-faada324beba@linaro.org/
-- 
2.37.2

