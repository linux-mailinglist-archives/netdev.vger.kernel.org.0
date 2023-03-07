Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B1A6AD6EF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 06:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCGFmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 00:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCGFmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 00:42:53 -0500
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B5E6C1A5;
        Mon,  6 Mar 2023 21:42:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VdJyV4n_1678167700;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VdJyV4n_1678167700)
          by smtp.aliyun-inc.com;
          Tue, 07 Mar 2023 13:42:48 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ajit.khaparde@broadcom.com
Cc:     sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] emulex/benet: clean up some inconsistent indenting
Date:   Tue,  7 Mar 2023 13:41:38 +0800
Message-Id: <20230307054138.21632-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional modification involved.

drivers/net/ethernet/emulex/benet/be_cmds.c:1120 be_cmd_pmac_add() warn: inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4396
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 27 +++++++++++----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 08ec84cd21c0..61adcebeef01 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -135,7 +135,8 @@ static int be_mcc_notify(struct be_adapter *adapter)
 
 /* To check if valid bit is set, check the entire word as we don't know
  * the endianness of the data (old entry is host endian while a new entry is
- * little endian) */
+ * little endian)
+ */
 static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
 {
 	u32 flags;
@@ -248,7 +249,8 @@ static int be_mcc_compl_process(struct be_adapter *adapter,
 	u8 opcode = 0, subsystem = 0;
 
 	/* Just swap the status to host endian; mcc tag is opaquely copied
-	 * from mcc_wrb */
+	 * from mcc_wrb
+	 */
 	be_dws_le_to_cpu(compl, 4);
 
 	base_status = base_status(compl->status);
@@ -657,8 +659,7 @@ static int be_mbox_db_ready_wait(struct be_adapter *adapter, void __iomem *db)
 	return 0;
 }
 
-/*
- * Insert the mailbox address into the doorbell in two steps
+/* Insert the mailbox address into the doorbell in two steps
  * Polls on the mbox doorbell till a command completion (or a timeout) occurs
  */
 static int be_mbox_notify_wait(struct be_adapter *adapter)
@@ -802,7 +803,7 @@ static void be_wrb_cmd_hdr_prepare(struct be_cmd_req_hdr *req_hdr,
 	req_hdr->subsystem = subsystem;
 	req_hdr->request_length = cpu_to_le32(cmd_len - sizeof(*req_hdr));
 	req_hdr->version = 0;
-	fill_wrb_tags(wrb, (ulong) req_hdr);
+	fill_wrb_tags(wrb, (ulong)req_hdr);
 	wrb->payload_length = cmd_len;
 	if (mem) {
 		wrb->embedded |= (1 & MCC_WRB_SGE_CNT_MASK) <<
@@ -832,8 +833,8 @@ static void be_cmd_page_addrs_prepare(struct phys_addr *pages, u32 max_pages,
 static inline struct be_mcc_wrb *wrb_from_mbox(struct be_adapter *adapter)
 {
 	struct be_dma_mem *mbox_mem = &adapter->mbox_mem;
-	struct be_mcc_wrb *wrb
-		= &((struct be_mcc_mailbox *)(mbox_mem->va))->wrb;
+	struct be_mcc_wrb *wrb = &((struct be_mcc_mailbox *)(mbox_mem->va))->wrb;
+
 	memset(wrb, 0, sizeof(*wrb));
 	return wrb;
 }
@@ -896,7 +897,7 @@ static struct be_mcc_wrb *be_cmd_copy(struct be_adapter *adapter,
 
 	memcpy(dest_wrb, wrb, sizeof(*wrb));
 	if (wrb->embedded & cpu_to_le32(MCC_WRB_EMBEDDED_MASK))
-		fill_wrb_tags(dest_wrb, (ulong) embedded_payload(wrb));
+		fill_wrb_tags(dest_wrb, (ulong)embedded_payload(wrb));
 
 	return dest_wrb;
 }
@@ -1114,7 +1115,7 @@ int be_cmd_pmac_add(struct be_adapter *adapter, const u8 *mac_addr,
 err:
 	mutex_unlock(&adapter->mcc_lock);
 
-	 if (base_status(status) == MCC_STATUS_UNAUTHORIZED_REQUEST)
+	if (base_status(status) == MCC_STATUS_UNAUTHORIZED_REQUEST)
 		status = -EPERM;
 
 	return status;
@@ -1803,7 +1804,7 @@ int be_cmd_get_fat_dump(struct be_adapter *adapter, u32 buf_len, void *buf)
 
 	total_size = buf_len;
 
-	get_fat_cmd.size = sizeof(struct be_cmd_req_get_fat) + 60*1024;
+	get_fat_cmd.size = sizeof(struct be_cmd_req_get_fat) + 60 * 1024;
 	get_fat_cmd.va = dma_alloc_coherent(&adapter->pdev->dev,
 					    get_fat_cmd.size,
 					    &get_fat_cmd.dma, GFP_ATOMIC);
@@ -1813,7 +1814,7 @@ int be_cmd_get_fat_dump(struct be_adapter *adapter, u32 buf_len, void *buf)
 	mutex_lock(&adapter->mcc_lock);
 
 	while (total_size) {
-		buf_size = min(total_size, (u32)60*1024);
+		buf_size = min(total_size, (u32)60 * 1024);
 		total_size -= buf_size;
 
 		wrb = wrb_from_mccq(adapter);
@@ -3362,7 +3363,7 @@ int be_cmd_ddr_dma_test(struct be_adapter *adapter, u64 pattern,
 	req->pattern = cpu_to_le64(pattern);
 	req->byte_count = cpu_to_le32(byte_cnt);
 	for (i = 0; i < byte_cnt; i++) {
-		req->snd_buff[i] = (u8)(pattern >> (j*8));
+		req->snd_buff[i] = (u8)(pattern >> (j * 8));
 		j++;
 		if (j > 7)
 			j = 0;
@@ -3846,7 +3847,7 @@ int be_cmd_set_mac_list(struct be_adapter *adapter, u8 *mac_array,
 	req->hdr.domain = domain;
 	req->mac_count = mac_count;
 	if (mac_count)
-		memcpy(req->mac, mac_array, ETH_ALEN*mac_count);
+		memcpy(req->mac, mac_array, ETH_ALEN * mac_count);
 
 	status = be_mcc_notify_wait(adapter);
 
-- 
2.20.1.7.g153144c

