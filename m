Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7784D3479
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiCIQZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbiCIQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC221520D3;
        Wed,  9 Mar 2022 08:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 098EAB82020;
        Wed,  9 Mar 2022 16:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BBDC340E8;
        Wed,  9 Mar 2022 16:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842727;
        bh=moiyWWCvlKZ5DvlGhseaEz8RqE7nWQEU8CCZWeccmlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kq2vsmMDgjgy6pUZTBjbLkGXyb8N46iavvCJuwBHex0W/AoOhncAtbHMleeWB6vQo
         G9VN5wxRGtTyYjNoRyaFz++u1fZQ7zswFICVptCT4GncK1q4iocr/gvHukKs5NlwVu
         H9iPvagPy11xRbKp8amosi8sEJZEsY0UZuix7+LeqpUpPSU2BFX/yRNbqhhg9FC+39
         nEImSK1Blf7KpACYxQix5OAE09VOucVqMiYFS1FevUh5dBBkqe8R9PyRkqVKwWQSuA
         CvgfTNAKB6H2O3IviRiGFZtAv8HLb8YuoF/BIOaXO52GUoCEkZzzwZbCpUAU9bnR/s
         5dCX1lresDl3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Casper Andersson <casper.casan@gmail.com>,
        Joacim Zetterling <joacim.zetterling@westermo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 16/27] net: sparx5: Add #include to remove warning
Date:   Wed,  9 Mar 2022 11:16:53 -0500
Message-Id: <20220309161711.135679-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit 90d4025285748448809701a44cf466a3f5443eaa ]

main.h uses NUM_TARGETS from main_regs.h, but
the missing include never causes any errors
because everywhere main.h is (currently)
included, main_regs.h is included before.
But since it is dependent on main_regs.h
it should always be included.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Joacim Zetterling <joacim.zetterling@westermo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index a1acc9b461f2..d40e18ce3293 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -16,6 +16,8 @@
 #include <linux/phylink.h>
 #include <linux/hrtimer.h>
 
+#include "sparx5_main_regs.h"
+
 /* Target chip type */
 enum spx5_target_chiptype {
 	SPX5_TARGET_CT_7546    = 0x7546,  /* SparX-5-64  Enterprise */
-- 
2.34.1

