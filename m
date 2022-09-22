Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE3E5E5AAE
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 07:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiIVF2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 01:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiIVF2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 01:28:12 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7636BB088B;
        Wed, 21 Sep 2022 22:28:09 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,335,1654527600"; 
   d="scan'208";a="133616820"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Sep 2022 14:28:08 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id AF161400D0FF;
        Thu, 22 Sep 2022 14:28:08 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v3 0/3] net: ethernet: renesas: Add Ethernet Switch driver
Date:   Thu, 22 Sep 2022 14:28:00 +0900
Message-Id: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        KHOP_HELO_FCRDNS,SPF_HELO_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is based on next-20220915.
Add minimal support for R-Car S4-8 Etherent Switch. This hardware
supports a lot of features. But, this driver only supports it as
act as an ethernet controller for now.

Changes from v2:
 https://lore.kernel.org/all/20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com/
 - Separate patcheas into each subsystem.
 - Add spin lock protection for multiple registers access in patch [3/3].

Yoshihiro Shimoda (3):
  dt-bindings: net: renesas: Document Renesas Ethernet Switch
  net: ethernet: renesas: Add Ethernet Switch driver
  net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support

 .../bindings/net/renesas,etherswitch.yaml     |  286 +++
 drivers/net/ethernet/renesas/Kconfig          |   11 +
 drivers/net/ethernet/renesas/Makefile         |    4 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c  |  181 ++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h  |   72 +
 drivers/net/ethernet/renesas/rswitch.c        | 1779 +++++++++++++++++
 drivers/net/ethernet/renesas/rswitch.h        |  967 +++++++++
 7 files changed, 3300 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h

-- 
2.25.1

