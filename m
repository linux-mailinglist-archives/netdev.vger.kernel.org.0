Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE48215AE2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgGFPjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729505AbgGFPjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066FaWY0025630;
        Mon, 6 Jul 2020 08:39:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=VrE/xmQPvt3bGBeOCv6FUw5AiqlfHe4nNnrkHA+Soe0=;
 b=K1Ggxq54U24dQhjFIBbVTlnr8wNHoj+eNXqK3FTYRRBBWStAvZRZF6lP0lAeZTcvoY2f
 z3Himp/P5rI57y+hRl/Y8hXL9XwmeiWOawuxxhnEQoHbv3FT/895R696qURmwW8N5WIp
 dlwaZjYSVd4wR75/UVULRVgNpI6ool+Z107hOn9GfTeDR71LSXIK9IobE3X7LdD7g1TH
 fLmSIjkPchB5qevTdea+1VLakDQhWWqZGd1dIG81Ad4IVF4p1v6pAz1Nt3VNXHIUBxkc
 nS+TTf/KpwzonnV+z9VpTzOCSrwjW2fQ48mjOs89eEWLySAQvwsfKNbpQg/9IzZfUQ4s fQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:05 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 5957C3F7041;
        Mon,  6 Jul 2020 08:39:02 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/9] net: qed: address kernel-doc warnings
Date:   Mon, 6 Jul 2020 18:38:16 +0300
Message-ID: <20200706153821.786-5-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of the kernel-doc warnings when building with W=1+ by
rewriting the problematic doc comments according to the
recommended format and style.

Note that this only fixes problems found in C source files,
headers aren't in scope for now.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   | 17 ++++---
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 49 ++++++++++---------
 drivers/net/ethernet/qlogic/qed/qed_spq.c     | 16 +++---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   | 21 ++++----
 4 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 1eb48ea80484..2ce1f5180231 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -996,14 +996,17 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
 	} while (0)
 
 /**
- * @brief qed_dmae_to_grc - is an internal function - writes from host to
- * wide-bus registers (split registers are not supported yet)
+ * qed_dmae_to_grc() - Internal function for writing from host to
+ * wide-bus registers (split registers are not supported yet).
  *
- * @param p_hwfn - HW device data
- * @param p_ptt - ptt window used for writing the registers.
- * @param p_data - pointer to source data.
- * @param addr - Destination register address.
- * @param len_in_dwords - data length in DWARDS (u32)
+ * @p_hwfn: HW device data.
+ * @p_ptt: PTT window used for writing the registers.
+ * @p_data: Pointer to source data.
+ * @addr: Destination register address.
+ * @len_in_dwords: Data length in dwords (u32).
+ *
+ * Return: Length of the written data in dwords (u32) or -1 on invalid
+ *         input.
  */
 static int qed_dmae_to_grc(struct qed_hwfn *p_hwfn,
 			   struct qed_ptt *p_ptt,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 297983d66e2f..0da38c47a8cf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -816,11 +816,12 @@ static inline u16 qed_attn_update_idx(struct qed_hwfn *p_hwfn,
 }
 
 /**
- *  @brief qed_int_assertion - handles asserted attention bits
+ * qed_int_assertion() - Handle asserted attention bits.
  *
- *  @param p_hwfn
- *  @param asserted_bits newly asserted bits
- *  @return int
+ * @p_hwfn: HW device data.
+ * @asserted_bits: Newly asserted bits.
+ *
+ * Return: Zero value.
  */
 static int qed_int_assertion(struct qed_hwfn *p_hwfn, u16 asserted_bits)
 {
@@ -880,16 +881,17 @@ static void qed_int_attn_print(struct qed_hwfn *p_hwfn,
 }
 
 /**
- * @brief qed_int_deassertion_aeu_bit - handles the effects of a single
- * cause of the attention
+ * qed_int_deassertion_aeu_bit() - Handles the effects of a single
+ * cause of the attention.
  *
- * @param p_hwfn
- * @param p_aeu - descriptor of an AEU bit which caused the attention
- * @param aeu_en_reg - register offset of the AEU enable reg. which configured
- *  this bit to this group.
- * @param bit_index - index of this bit in the aeu_en_reg
+ * @p_hwfn: HW device data.
+ * @p_aeu: Descriptor of an AEU bit which caused the attention.
+ * @aeu_en_reg: Register offset of the AEU enable reg. which configured
+ *              this bit to this group.
+ * @p_bit_name: AEU bit description for logging purposes.
+ * @bitmask: Index of this bit in the aeu_en_reg.
  *
- * @return int
+ * Return: Zero on success, negative errno otherwise.
  */
 static int
 qed_int_deassertion_aeu_bit(struct qed_hwfn *p_hwfn,
@@ -938,12 +940,12 @@ qed_int_deassertion_aeu_bit(struct qed_hwfn *p_hwfn,
 }
 
 /**
- * @brief qed_int_deassertion_parity - handle a single parity AEU source
+ * qed_int_deassertion_parity() - Handle a single parity AEU source.
  *
- * @param p_hwfn
- * @param p_aeu - descriptor of an AEU bit which caused the parity
- * @param aeu_en_reg - address of the AEU enable register
- * @param bit_index
+ * @p_hwfn: HW device data.
+ * @p_aeu: Descriptor of an AEU bit which caused the parity.
+ * @aeu_en_reg: Address of the AEU enable register.
+ * @bit_index: Index (0-31) of an AEU bit.
  */
 static void qed_int_deassertion_parity(struct qed_hwfn *p_hwfn,
 				       struct aeu_invert_reg_bit *p_aeu,
@@ -976,12 +978,13 @@ static void qed_int_deassertion_parity(struct qed_hwfn *p_hwfn,
 }
 
 /**
- * @brief - handles deassertion of previously asserted attentions.
+ * qed_int_deassertion() - Handle deassertion of previously asserted
+ * attentions.
  *
- * @param p_hwfn
- * @param deasserted_bits - newly deasserted bits
- * @return int
+ * @p_hwfn: HW device data.
+ * @deasserted_bits: newly deasserted bits.
  *
+ * Return: Zero value.
  */
 static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 			       u16 deasserted_bits)
@@ -2241,9 +2244,9 @@ int qed_int_igu_read_cam(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 }
 
 /**
- * @brief Initialize igu runtime registers
+ * qed_int_igu_init_rt() - Initialize IGU runtime registers.
  *
- * @param p_hwfn
+ * @p_hwfn: HW device data.
  */
 void qed_int_igu_init_rt(struct qed_hwfn *p_hwfn)
 {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index ee89a8f4f585..92ab029789e5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -642,18 +642,18 @@ void qed_spq_return_entry(struct qed_hwfn *p_hwfn, struct qed_spq_entry *p_ent)
 }
 
 /**
- * @brief qed_spq_add_entry - adds a new entry to the pending
- *        list. Should be used while lock is being held.
+ * qed_spq_add_entry() - Add a new entry to the pending list.
+ *                       Should be used while lock is being held.
  *
- * Addes an entry to the pending list is there is room (en empty
+ * @p_hwfn: HW device data.
+ * @p_ent: An entry to add.
+ * @priority: Desired priority.
+ *
+ * Adds an entry to the pending list is there is room (an empty
  * element is available in the free_pool), or else places the
  * entry in the unlimited_pending pool.
  *
- * @param p_hwfn
- * @param p_ent
- * @param priority
- *
- * @return int
+ * Return: zero on success, -EINVAL on invalid @priority.
  */
 static int qed_spq_add_entry(struct qed_hwfn *p_hwfn,
 			     struct qed_spq_entry *p_ent,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index fcf4d82da161..3930958f0ffa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -823,16 +823,17 @@ static int qed_iov_enable_vf_access(struct qed_hwfn *p_hwfn,
 }
 
 /**
- * @brief qed_iov_config_perm_table - configure the permission
- *      zone table.
- *      In E4, queue zone permission table size is 320x9. There
- *      are 320 VF queues for single engine device (256 for dual
- *      engine device), and each entry has the following format:
- *      {Valid, VF[7:0]}
- * @param p_hwfn
- * @param p_ptt
- * @param vf
- * @param enable
+ * qed_iov_config_perm_table() - Configure the permission zone table.
+ *
+ * @p_hwfn: HW device data.
+ * @p_ptt: PTT window for writing the registers.
+ * @vf: VF info data.
+ * @enable: The actual permision for this VF.
+ *
+ * In E4, queue zone permission table size is 320x9. There
+ * are 320 VF queues for single engine device (256 for dual
+ * engine device), and each entry has the following format:
+ * {Valid, VF[7:0]}
  */
 static void qed_iov_config_perm_table(struct qed_hwfn *p_hwfn,
 				      struct qed_ptt *p_ptt,
-- 
2.25.1

