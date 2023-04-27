Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474AC6F042B
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243508AbjD0KZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243438AbjD0KZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:25:45 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 0736440E6;
        Thu, 27 Apr 2023 03:25:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 8D665180119BD7;
        Thu, 27 Apr 2023 18:25:33 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   wuych <yunchuan@nfschina.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        irusskikh@marvell.com, wuych <yunchuan@nfschina.com>
Subject: [PATCH] atlantic:hw_atl2:hw_atl2_utils_fw:  Remove unnecessary (void*) conversions
Date:   Thu, 27 Apr 2023 18:25:31 +0800
Message-Id: <20230427102531.14783-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer variables of void * type do not require type cast.

Signed-off-by: wuych <yunchuan@nfschina.com>
---
 .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 58d426dda3ed..674683b54304 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -336,7 +336,7 @@ static int aq_a2_fw_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 static void aq_a2_fill_a0_stats(struct aq_hw_s *self,
 				struct statistics_s *stats)
 {
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	struct aq_stats_s *cs = &self->curr_stats;
 	struct aq_stats_s curr_stats = *cs;
 	bool corrupted_stats = false;
@@ -378,7 +378,7 @@ do { \
 static void aq_a2_fill_b0_stats(struct aq_hw_s *self,
 				struct statistics_s *stats)
 {
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	struct aq_stats_s *cs = &self->curr_stats;
 	struct aq_stats_s curr_stats = *cs;
 	bool corrupted_stats = false;
-- 
2.30.2

