Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C30458FBD1
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiHKMCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiHKMC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:02:28 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6248074E0C;
        Thu, 11 Aug 2022 05:02:26 -0700 (PDT)
X-QQ-mid: bizesmtp64t1660219329t2zcllc5
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 20:02:07 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000000
X-QQ-FEAT: zT6n3Y95oi23CoVou9i63cAEjgfZuVTZYTNVKwzk/iXjxwHGZ4TUwFmp7IvnQ
        nmCGX3DOTwYMKOrDfFclJJM5HOFoZckCBfRUMSwc9QbYjsf1owpwiyYTjnGVgJGxXnp1HS/
        RQWCdiuVHgzfD9WUNFahgeKu5OrVSbhZfXpn+QwHKkVwB8bOlJAo8am7kGqPsJjl+7UThCY
        vzuO6vMWLSzKt7IEYGWOdolI4aEJxOk59Hvl0LAg/888ATfa96WI2Ax/zROX7N9XOxTdPUD
        CrSkFHspsoAoOXp2rDc9s5Y2Jv3BF7w8+H5cnhcix5I8y5JmDL7q+rE1GyWLdczNqx2Ae2d
        7TdpP4b3QWc7RKu5LMP9IUXzc3wOd0srXpqZHz2X3+PUFDFhjwEH8FXUbOCgeq8nvoz+NlX
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     ganapathi017@gmail.com
Cc:     amitkarwar@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] mwifiex: Fix comment typo
Date:   Thu, 11 Aug 2022 20:02:01 +0800
Message-Id: <20220811120201.10824-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index bd835288ce57..a04b66284af4 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -335,7 +335,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	struct mwifiex_sta_node *node;
 
 	/*
-	 * If we get a TID, ta pair which is already present dispatch all the
+	 * If we get a TID, ta pair which is already present dispatch all
 	 * the packets and move the window size until the ssn
 	 */
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
-- 
2.36.1

