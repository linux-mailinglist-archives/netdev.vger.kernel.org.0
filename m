Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1320A6BB89D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjCOPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbjCOPxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:20 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68207DFAA;
        Wed, 15 Mar 2023 08:52:48 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32FFqTEF030611;
        Wed, 15 Mar 2023 10:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678895549;
        bh=1oLs8kVXFMGqsqHcTeZ5AMcOozd9zBYmHQzSXko8XM0=;
        h=From:To:CC:Subject:Date;
        b=WefKotbACu4GMu95+Ymwf+TR/ZuSIp2IeaG9jFuINAxSfp2T6DV0KhO7dhY6vC3yO
         Ghq6eANEkRsf4QWtMFbO/AO1WGN/2ONuIJm2uo25N8L6bcsLR7qYi3CCg+bO1hPUK/
         xqz9xUiaYGVc8BsiAzX8IV7Em4J9PPzfJ3+iNzks=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32FFqTQh070921
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Mar 2023 10:52:29 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 15
 Mar 2023 10:52:29 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 15 Mar 2023 10:52:29 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32FFqTWI009345;
        Wed, 15 Mar 2023 10:52:29 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/3] pinctrl/arm: dt-bindings: k3: Deprecate header with register constants
Date:   Wed, 15 Mar 2023 10:52:25 -0500
Message-ID: <20230315155228.1566883-1-nm@ti.com>
X-Mailer: git-send-email 2.40.0
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

This is an updated series to move the pinctrl bindings over to arch as
the definitions are hardware definitions without driver usage.

This series was triggered by the discussion in [1]

v1: https://lore.kernel.org/linux-arm-kernel/20230311131325.9750-1-nm@ti.com/

Nishanth Menon (3):
  dt-bindings: net: ti: k3-am654-cpsw-nuss: Drop pinmux header
  arm64: dts: ti: Use local header for pinctrl register values
  dt-bindings: pinctrl: k3: Deprecate header with register constants

 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml     | 1 -
 arch/arm64/boot/dts/ti/k3-am62.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-am62a.dtsi                       | 3 ++-
 arch/arm64/boot/dts/ti/k3-am64.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-am65.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                       | 3 ++-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                       | 3 ++-
 arch/arm64/boot/dts/ti/k3-j721s2.dtsi                      | 3 ++-
 arch/arm64/boot/dts/ti/k3-j784s4.dtsi                      | 3 ++-
 .../pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h    | 6 +++---
 include/dt-bindings/pinctrl/k3.h                           | 7 +++++++
 11 files changed, 26 insertions(+), 12 deletions(-)
 copy include/dt-bindings/pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h (93%)

[1] https://lore.kernel.org/all/c4d53e9c-dac0-8ccc-dc86-faada324beba@linaro.org/
-- 
2.40.0

