Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807EE550515
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 15:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiFRNYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 09:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRNYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 09:24:20 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1041E140D3;
        Sat, 18 Jun 2022 06:24:15 -0700 (PDT)
X-QQ-mid: bizesmtp80t1655558570tjkc0f6g
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 18 Jun 2022 21:22:47 +0800 (CST)
X-QQ-SSF: 01000000002000D0I000B00A0000000
X-QQ-FEAT: F3yR32iATbgOjg0qmhZ3EhjfVBRB7HlbMiwwprrbO5kNKrgdobTIyr8egc30n
        7DLVgKAorFXRTQrBHnC6bCqzn82GDgG2vT/EqQyzUxLbHQ+Y+EWaC/XRvxYNp92G1XaDhj1
        gR6tcQf5QzuFWc4rFIRnNviHCxMPYXtfdi5X/P5GGb+1qR0e0+SXMJGshz2uOuRf6N4nJ3L
        /LnME37p+eVruWtmsPBf50azqbB1rxSChSH/211yC4IZjiCVwRwUUg72JDZ7A8OGTHrMYGf
        qDu+MuLvfhwZ6Vvpe+Tzogi3duujK8+5EWyMYDLrIPlMQghxK28x5fHMdPTfIucCUceH7w3
        TRhdP9bWybgHPMaxgE=
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] sfc/siena: Fix typo in comment
Date:   Sat, 18 Jun 2022 21:22:41 +0800
Message-Id: <20220618132241.15288-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'and'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/ethernet/sfc/siena/mcdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 3df0f0eca3b7..3f7899daa86a 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -1264,7 +1264,7 @@ static void efx_mcdi_ev_death(struct efx_nic *efx, int rc)
 }
 
 /* The MC is going down in to BIST mode. set the BIST flag to block
- * new MCDI, cancel any outstanding MCDI and and schedule a BIST-type reset
+ * new MCDI, cancel any outstanding MCDI and schedule a BIST-type reset
  * (which doesn't actually execute a reset, it waits for the controlling
  * function to reset it).
  */
-- 
2.36.1

