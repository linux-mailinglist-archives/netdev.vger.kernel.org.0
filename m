Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBD05B38E7
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiIIN0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiIIN03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:26:29 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E2B5138835;
        Fri,  9 Sep 2022 06:26:27 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,303,1654527600"; 
   d="scan'208";a="134336781"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 09 Sep 2022 22:26:27 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 5E45243BD5A1;
        Fri,  9 Sep 2022 22:26:27 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 0/5] treewide: Add R-Car S4-8 Ethernet Switch support
Date:   Fri,  9 Sep 2022 22:26:09 +0900
Message-Id: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        KHOP_HELO_FCRDNS,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20220901.
Add minimal support for R-Car S4-8 Etherent Switch. This hardware
supports a lot of features. But, this driver only supports it as
act as an ethernet controller for now.

Yoshihiro Shimoda (5):
  clk: renesas: r8a779f0: Add Ethernet Switch clocks
  dt-bindings: net: renesas: Document Renesas Ethernet Switch
  net: ethernet: renesas: Add Ethernet Switch driver
  arm64: dts: renesas: r8a779f0: Add Ethernet Switch node
  arm64: dts: renesas: r8a779f0: spider: Enable Ethernet Switch

 .../bindings/net/renesas,etherswitch.yaml     |  252 +++
 .../dts/renesas/r8a779f0-spider-ethernet.dtsi |   44 +
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi     |   87 +
 drivers/clk/renesas/r8a779f0-cpg-mssr.c       |    2 +
 drivers/net/ethernet/renesas/Kconfig          |   11 +
 drivers/net/ethernet/renesas/Makefile         |    4 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  154 ++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   71 +
 drivers/net/ethernet/renesas/rswitch.c        | 1674 +++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h        |  971 ++++++++++
 drivers/net/ethernet/renesas/rswitch_serdes.c |  192 ++
 drivers/net/ethernet/renesas/rswitch_serdes.h |   16 +
 12 files changed, 3478 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch_serdes.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch_serdes.h

-- 
2.25.1

