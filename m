Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D635B34DC
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIIKKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIIKKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:10:18 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7FC79A4B
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 03:10:15 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:91db:705e:cfbc:a001])
        by xavier.telenet-ops.be with bizsmtp
        id HmAD2800A0sKggw01mADVF; Fri, 09 Sep 2022 12:10:13 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oWaxg-004c3E-P0; Fri, 09 Sep 2022 12:10:12 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oWaxg-004qsu-6t; Fri, 09 Sep 2022 12:10:12 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: ravb: Add R-Car Gen4 support
Date:   Fri,  9 Sep 2022 12:10:11 +0200
Message-Id: <2ee968890feba777e627d781128b074b2c43cddb.1662718171.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Renesas Ethernet AVB (EtherAVB-IF) blocks on R-Car
Gen4 SoCs (e.g. R-Car V4H) by matching on a family-specific compatible
value.

These are treated the same as EtherAVB on R-Car Gen3.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Corresponding DT binding update in "[PATCH 0/2] dt-bindings: net:
renesas,etheravb: R-Car Gen4 updates"
https://lore.kernel.org/r/cover.1662714607.git.geert+renesas@glider.be
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b357ac4c56c599ad..d013cc1c8a0ad007 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2512,6 +2512,7 @@ static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
+	{ .compatible = "renesas,etheravb-rcar-gen4", .data = &ravb_gen3_hw_info },
 	{ .compatible = "renesas,etheravb-rzv2m", .data = &ravb_rzv2m_hw_info },
 	{ .compatible = "renesas,rzg2l-gbeth", .data = &gbeth_hw_info },
 	{ }
-- 
2.25.1

