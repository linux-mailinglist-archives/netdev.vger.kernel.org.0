Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B155B95C8
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIOHzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiIOHy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:54:58 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252DF10A7;
        Thu, 15 Sep 2022 00:54:44 -0700 (PDT)
X-QQ-mid: bizesmtp90t1663228460tiz19c29
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 15 Sep 2022 15:54:18 +0800 (CST)
X-QQ-SSF: 01000000002000E0G000B00A0000000
X-QQ-FEAT: LG+NUo/f6sFWA8hmhGcTYqNO/qD7DWaj4HkRGRFwvuweibZZXh9Pv+CzeFwn1
        KDwbN5nnZeUem32XsssK1QcGRXsYLrkJgJynV1c8VJn+8I4yeaLR8e/CmyjiaL/cn2K4IPG
        sGYZoX0JNoUF9rj4GWNjZ7INRpPLaTJG/YypjS9gv4CzWrGgKRWxrbf9eOgbH0GW2rGbHGZ
        uvGihhlx/oh+ujbdhHoLWpesjfgRdFeihovXuaeP69F5ivrLur525A+je3KNE3mRsKSG7cU
        YpWxDrufXT8A5LNbXiLQF7Km+M2JmxHGbTGZ/taeIGfjXQOhfR9Z0igP7jm3MbTV6dalBBt
        xgQHTqkKqoC6DanBxejdPm2mYFChc4wKd4Ni6C15lqxZJgD94QxaYzEaPNigfqIT/HT1Xuj
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] sfc: fix repeated words in comments
Date:   Thu, 15 Sep 2022 15:54:11 +0800
Message-Id: <20220915075411.33059-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
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

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
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

