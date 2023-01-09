Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95908662446
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbjAILfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjAILff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:35:35 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF93518B2B;
        Mon,  9 Jan 2023 03:35:33 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NrBhL1T7Rz5PkHg;
        Mon,  9 Jan 2023 19:35:30 +0800 (CST)
Received: from szxlzmapp07.zte.com.cn ([10.5.230.251])
        by mse-fl1.zte.com.cn with SMTP id 309BZMii086584;
        Mon, 9 Jan 2023 19:35:22 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Mon, 9 Jan 2023 19:35:26 +0800 (CST)
Date:   Mon, 9 Jan 2023 19:35:26 +0800 (CST)
X-Zmail-TransId: 2b0363bbfbfeffffffffaabc6a7b
X-Mailer: Zmail v1.0
Message-ID: <202301091935262709751@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <aelior@marvell.com>
Cc:     <manishc@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dai.shixin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBxZWQ6IGZpeCBhIHR5cG8gaW4gY29tbWVudA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 309BZMii086584
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 63BBFC02.000 by FangMail milter!
X-FangMail-Envelope: 1673264130/4NrBhL1T7Rz5PkHg/63BBFC02.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63BBFC02.000/4NrBhL1T7Rz5PkHg
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dai Shixin <dai.shixin@zte.com.cn>

Fix a typo of "permision" which should be "permission".

Signed-off-by: Dai Shixin <dai.shixin@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 0848b5529d48..2bf18748581d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -831,7 +831,7 @@ static int qed_iov_enable_vf_access(struct qed_hwfn *p_hwfn,
  * @p_hwfn: HW device data.
  * @p_ptt: PTT window for writing the registers.
  * @vf: VF info data.
- * @enable: The actual permision for this VF.
+ * @enable: The actual permission for this VF.
  *
  * In E4, queue zone permission table size is 320x9. There
  * are 320 VF queues for single engine device (256 for dual
-- 
2.15.2
