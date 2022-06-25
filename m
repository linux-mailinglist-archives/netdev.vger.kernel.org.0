Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E0355A7B1
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 09:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiFYHRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 03:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiFYHRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 03:17:45 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A48A31DE3;
        Sat, 25 Jun 2022 00:17:39 -0700 (PDT)
X-QQ-mid: bizesmtp63t1656141369t59nl9jx
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 25 Jun 2022 15:16:06 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: F3yR32iATbhwg5TZeoOG9uLEKCHC2CVB50VEogDWj3iho83m5a1OwNpzqodz8
        xcyuVDoz7a0ZEt4/HYWY+REO0LpQD1sLfOixsHCEpH6dUuXxSjWCJQ00gER+D5/c5oQpX3p
        +AaGI/SVTCAalpm3XPTpOFyngWgEma8ZpBoYWL7Tr3aUgRgRQE4FAZ8BP9/dIOxXwZKP4Mj
        e8o3Ks9qwHAx1IsA6QcB+ht1SjaeN2oc7WDAw+mw7Pq0tVl2mh7sxQNPXxVbXJ5WtHNksgC
        E0vxg2ffnb9vlBV6ZQ4E2buPa9YTHC5t85Jk1N8JW2poBCq3ca7I6752KupMuOfAmqE/NZt
        Hh+liJGj4pkChK2eE8=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net: atlantic:fix repeated words in comments
Date:   Sat, 25 Jun 2022 15:15:58 +0800
Message-Id: <20220625071558.3852-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
index b6119dcc3bb9..c2fda80fe1cc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
@@ -158,7 +158,7 @@ struct aq_mss_egress_class_record {
 	 *  1: compare the SNAP header.
 	 *  If this bit is set to 1, the extracted filed will assume the
 	 *  SNAP header exist as encapsulated in 802.3 (RFC 1042). I.E. the
-	 *  next 5 bytes after the the LLC header is SNAP header.
+	 *  next 5 bytes after the LLC header is SNAP header.
 	 */
 	u32 snap_mask;
 	/*! 0: don't care and no LLC header exist.
@@ -422,7 +422,7 @@ struct aq_mss_ingress_preclass_record {
 	 *  1: compare the SNAP header.
 	 *  If this bit is set to 1, the extracted filed will assume the
 	 *  SNAP header exist as encapsulated in 802.3 (RFC 1042). I.E. the
-	 *  next 5 bytes after the the LLC header is SNAP header.
+	 *  next 5 bytes after the LLC header is SNAP header.
 	 */
 	u32 snap_mask;
 	/*! Mask is per-byte.
-- 
2.36.1

