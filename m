Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8954157DC46
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbiGVIXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiGVIXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:23:02 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDA5D9E2B5;
        Fri, 22 Jul 2022 01:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=EKCzv
        8X/Wpy29c+oOWbNpUVxsSnAvfHjUU+SI7a4Ngs=; b=LlN4OD08bfPW/LUB0SkLn
        81e28F+g68gi48wXND+fdVrRq8iF4vJjN4zWg5nagdbBB/16a9cio/iBo1scmPVs
        3/3MGNvQE6vastxvNp7totOYQ3n2p1w761BFKi+D0T+5c6fwpfBrsbiid+4WeI+Q
        dvCn5fyfQaOfWFfNEKXO8s=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp1 (Coremail) with SMTP id GdxpCgB3e8NEXtpi+K0fPw--.6434S2;
        Fri, 22 Jul 2022 16:22:30 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, elder@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] net: ipa: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:22:27 +0800
Message-Id: <20220722082227.74274-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgB3e8NEXtpi+K0fPw--.6434S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr48Xw1xJrW5AF4UCFg_yoW3twbE9r
        yfW3WSqw4rKw1xtws09Fs5ZFySyF1qvr9YvFs0v34Fq347Xr4xArWvyF9rJrn8uryDGasr
        WrZxCF18CasFgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCv31PUUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbCdQZGZGBbEbyAhgAAsB
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
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
2.25.1

