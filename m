Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72EE5B1D90
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiIHMq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIHMq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:46:56 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5C92A243;
        Thu,  8 Sep 2022 05:46:54 -0700 (PDT)
X-QQ-mid: bizesmtp64t1662641198tfqe27i3
Received: from localhost.localdomain ( [182.148.14.0])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 08 Sep 2022 20:46:37 +0800 (CST)
X-QQ-SSF: 0100000000200090C000B00A0000000
X-QQ-FEAT: FVl8EHhfVR6WylzTTM32WST42hVCkKYXzWbR4oH25XAnPFuwhcyoL5E+weBUt
        ueYQ4psAkDKx6gcMwX9WPJZ4LT92vgUBITKpezSLAmFISQVjC50LOy0ddc0yUVkqaALWnWy
        PVYIiEdKxou/HxPFwOvdmIDk37ThBhQcEah4YU9iBIr19AU3sUGqqlIK+RuzPMy6CiyiuKl
        LW02S7jJiqRYrKx1mubAZRswcBuh1lYi9Xm7EsDhIBJRTN2LmidhqfZHaeTfvrxEcMIKrT2
        44N7a7XtGtydfvzL63jzbKw0BA3Dx86jbbEbe9BVbGVtt9gvWsv2oFJjOqqhl7Gy8Dx+w9W
        3ssqe095AKUBMWuDwPGuDijlz0oQAD67BVXwjMTSVx62HxUHEk=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] ethernet/sfc: fix repeated words in comments
Date:   Thu,  8 Sep 2022 20:46:30 +0800
Message-Id: <20220908124630.24314-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/ethernet/sfc/bitfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
index 1f981dfe4bdc..0b502d1c3c9e 100644
--- a/drivers/net/ethernet/sfc/bitfield.h
+++ b/drivers/net/ethernet/sfc/bitfield.h
@@ -117,7 +117,7 @@ typedef union efx_oword {
  *
  *   ( element ) << 4
  *
- * The result will contain the relevant bits filled in in the range
+ * The result will contain the relevant bits filled in the range
  * [0,high-low), with garbage in bits [high-low+1,...).
  */
 #define EFX_EXTRACT_NATIVE(native_element, min, max, low, high)		\
-- 
2.36.1

