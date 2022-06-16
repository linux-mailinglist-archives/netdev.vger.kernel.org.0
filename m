Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BED54E35C
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377656AbiFPO2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376939AbiFPO2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 10:28:04 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252E61116A;
        Thu, 16 Jun 2022 07:27:54 -0700 (PDT)
X-QQ-mid: bizesmtp74t1655389596t1j0bi5p
Received: from localhost.localdomain ( [153.0.97.30])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 16 Jun 2022 22:26:31 +0800 (CST)
X-QQ-SSF: 01000000003000D0I000B00A0000000
X-QQ-FEAT: FXvDfBZI5O56AgfY+y0EGHBY3j6zgMvT0PfShBaBl2GAqPoKvhB/MZWbB44z3
        /nX30qdY08GnpBykwBv9D2LafbusBvrPO8OSNp+kZARzhX7kLFLlJ7m+78dOKt/WerR8qTN
        WsNBulpyEAHvZbxFXnvT1onP040gUY5IsaGfDU1OG9fE+ZIk9Rm5+ckO0gbB0L8g2pWB2wu
        NM1H+xkuBpbRgvax1Bhqir/lzHUCFpaR2UWFneIkoD9Ig9JI0UgqEDhjZ7KQL2kM17v7GtB
        Qchb+WstPQ+UuNd+M7l6e4YOrKxKvGX/oU4rD5Q3+v5e14wAdUr1Pa8XxAm/UwwJ2euEKGl
        O5YG8Sw3kmtUDfyDlw=
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     paulus@samba.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] ppp: Fix typo in comment
Date:   Thu, 16 Jun 2022 22:26:24 +0800
Message-Id: <20220616142624.3397-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/ppp/ppp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 4a365f15533e..9206c660a72e 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2968,7 +2968,7 @@ ppp_unregister_channel(struct ppp_channel *chan)
 	chan->ppp = NULL;
 
 	/*
-	 * This ensures that we have returned from any calls into the
+	 * This ensures that we have returned from any calls into
 	 * the channel's start_xmit or ioctl routine before we proceed.
 	 */
 	down_write(&pch->chan_sem);
-- 
2.36.1

