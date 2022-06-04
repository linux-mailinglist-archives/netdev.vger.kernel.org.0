Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6462E53D526
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 06:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348491AbiFDEMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 00:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiFDEMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 00:12:01 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84222F54;
        Fri,  3 Jun 2022 21:11:53 -0700 (PDT)
X-QQ-mid: bizesmtp84t1654315764tu72evam
Received: from localhost.localdomain ( [111.9.5.115])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 04 Jun 2022 12:09:18 +0800 (CST)
X-QQ-SSF: 01000000002000B0G000B00A0000000
X-QQ-FEAT: Jd++W0FxedGV1px0YD3yQaciTCdGANzros9vt3mxHdpGtICynb/IJd6W/y344
        ds8as5wzvL9HiRLviuq4fAYoajSxYACKA+juIMvqk8fRZIm7RAcvnAeCVHEldgWyQSRQDca
        TZBU9oa+rRf9hYfhcsVsMZVUwKmiB2a0FABoCBLk+ULpZwYJbKBRN/LvV0V9KHoh007cM3O
        9vxHsAQ/BozRMVu0Coka0uM+hGe3nWbKNhswRVLXOFZ9kYSQL5typ9iv0Fgo5y/gKSMlL9Z
        /c+NQFw5aH+gwuloklZY5glnizlIqVCyZb+IB5RVAlt2Pvh3CBsdx+WtlBtuuXApbBeiT6i
        J9kOtOat1vGvSs6iE8=
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     davem@davemloft.net
Cc:     kevin.curtis@farsite.co.uk, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] WAN: Fix syntax errors in comments
Date:   Sat,  4 Jun 2022 12:09:17 +0800
Message-Id: <20220604040917.8926-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/wan/farsync.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/farsync.h b/drivers/net/wan/farsync.h
index 5f43568a9715..63908dbbb02d 100644
--- a/drivers/net/wan/farsync.h
+++ b/drivers/net/wan/farsync.h
@@ -43,7 +43,7 @@
  *      This version number is incremented with each official release of the
  *      package and is a simplified number for normal user reference.
  *      Individual files are tracked by the version control system and may
- *      have individual versions (or IDs) that move much faster than the
+ *      have individual versions (or IDs) that move much faster than
  *      the release version as individual updates are tracked.
  */
 #define FST_USER_VERSION        "1.04"
-- 
2.36.1

