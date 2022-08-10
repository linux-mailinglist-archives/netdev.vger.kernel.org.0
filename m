Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE9058EDCA
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbiHJOBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 10:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiHJOBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 10:01:46 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE46CD3B;
        Wed, 10 Aug 2022 07:01:42 -0700 (PDT)
X-QQ-mid: bizesmtp84t1660139949tp0prn7f
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 21:59:08 +0800 (CST)
X-QQ-SSF: 01000000002000B0D000B00A0000000
X-QQ-FEAT: znfcQSa1hKYKcWUXUgOYHDaF+k7+blBWmOmO/ZozdMD8l2QmecJmvkQoXtKNk
        VRLbdZdiylu4GyDoDoSEdc9aX4JSF8BlPeNMvEtBbvI9cAZzSTsj/YD/UMy/hhbckFVdQ/n
        Yqd9npLdw0QYiv9AOZb1i9yAdK+Tk12k2VVekVHQt9AY3juuuA5P+kdHpNF9n66eE8NwZix
        1lI9LQFk0f3wEY+eTGNaRoIMQusRCuAsyloCBTYbrHz7CkvgDIMIyBeJcL+IfhZzt4Uy6T3
        Ih9AE3AH1z7DQiUY8mHQxEAJWKQAOXHx8QLDGzKwnqZ213PPOKzyCIHgMBLmZA4YOzI5Cr8
        OeUv9ilNmQnyCZ+K2eynDScXa9fey4WPz3POXTJ2mliAt7Y4PPGrlf3nZy8Ug==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] skfp/h: fix repeated words in comments
Date:   Wed, 10 Aug 2022 21:59:01 +0800
Message-Id: <20220810135901.17400-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/fddi/skfp/h/hwmtm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/h/hwmtm.h b/drivers/net/fddi/skfp/h/hwmtm.h
index 76c4a709d73d..e97db826cdd4 100644
--- a/drivers/net/fddi/skfp/h/hwmtm.h
+++ b/drivers/net/fddi/skfp/h/hwmtm.h
@@ -348,7 +348,7 @@ do {									\
  *		This macro is invoked by the OS-specific before it left the
  *		function mac_drv_rx_complete. This macro calls mac_drv_fill_rxd
  *		if the number of used RxDs is equal or lower than the
- *		the given low water mark.
+ *		given low water mark.
  *
  * para	low_water	low water mark of used RxD's
  *
-- 
2.36.1

