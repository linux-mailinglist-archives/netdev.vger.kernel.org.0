Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2756BDE0
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbiGHPYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiGHPYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:24:39 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4D1EA2;
        Fri,  8 Jul 2022 08:24:34 -0700 (PDT)
X-QQ-mid: bizesmtp73t1657293841tk4og5o6
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:23:57 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: +HVWQWZs/U06PrLoaKVc06hTl196eHxl6vlvDoekGWywfqN3D5j1LSLTQgk5j
        POEJr2jKVJgEhVWhJxe/Dz9SCmx9PPiYO+M4gvFUr50dKrq6R8mGgkns2bY7GfpwwbrtVzo
        ltM5y1r/Ae13K6VlzFqJqQ5U7YF0gnandpoYXXv5jAL8KshTG6CEj4yPODoWSo70rKCIZLg
        dhbjfJIkH91SV8r4YyD6YaEQ/aQe7bb6wbi3UkucVkQlzszCzOdx2TQ/BzdHYbAdGCIKayN
        o3CFGQdUazupOd67xKV17lwwmhUGriNOItyZPPuFGIBxMFRDglD8uDxl72sA4FW/N0SnTXU
        WJN4HQ8QTW7/+1Ad599f0ru1tAj+4RDK2tmk4m1tCbR1dYiXow=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net/ipa: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:23:51 +0800
Message-Id: <20220708152351.58913-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ipa/ipa_qmi_msg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 3233d145fd87..495e85abe50b 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -214,7 +214,7 @@ struct ipa_init_modem_driver_req {
 
 /* The response to a IPA_QMI_INIT_DRIVER request begins with a standard
  * QMI response, but contains other information as well.  Currently we
- * simply wait for the the INIT_DRIVER transaction to complete and
+ * simply wait for the INIT_DRIVER transaction to complete and
  * ignore any other data that might be returned.
  */
 struct ipa_init_modem_driver_rsp {
-- 
2.36.1

