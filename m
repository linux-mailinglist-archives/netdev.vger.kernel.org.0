Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96537229C01
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbgGVPy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:54:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6426 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726098AbgGVPyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:54:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFUJwx010149;
        Wed, 22 Jul 2020 08:54:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=FhAggLZ0tLiue9xeV5tnAuoxZeC8O3N9g9v9jT+7MzA=;
 b=uMfuS56bCbQ6cHJE/ybpVWmbM3UCW9J0dseHfYPUPLaLVuTpncxND7ODssTiTfX7CKhq
 MYJMR2s3FrNG8+uQW4O/Lep6HHeRwBgxE8G0aknvTI11ez8bDrXdPe2NnCR3XOmmrYPV
 kyUp7s8WNWkB5MMJWtpC4MFpip7pjrk4CAUYoYJXM3EpBJIjKXKUfiPfsksONCsRpZaQ
 Eif1wpVhj3/DaNlBCU9bXrT6IcAVEQq8rWUHUh+Yd8Z7RIespDUY8WaJLWvgEa4nyNNW
 yFaqQAv81pznKW5Lle2yDEQvCy82IaswihP3BZQPWdyBCSYIQwCNU02KGba7IgMkyaG6 yg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxensfnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:54:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:54:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:54:36 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 28A6E3F703F;
        Wed, 22 Jul 2020 08:54:30 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 01/15] qed: reformat "qed_chain.h" a bit
Date:   Wed, 22 Jul 2020 18:53:35 +0300
Message-ID: <20200722155349.747-2-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722155349.747-1-alobakin@marvell.com>
References: <20200722155349.747-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reformat structs and macros definitions a bit prior to making functional
changes.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 include/linux/qed/qed_chain.h | 126 ++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 60 deletions(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 7071dc92b4e2..087073517c09 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -26,9 +26,9 @@ enum qed_chain_mode {
 };
 
 enum qed_chain_use_mode {
-	QED_CHAIN_USE_TO_PRODUCE,		/* Chain starts empty */
-	QED_CHAIN_USE_TO_CONSUME,		/* Chain starts full */
-	QED_CHAIN_USE_TO_CONSUME_PRODUCE,	/* Chain starts empty */
+	QED_CHAIN_USE_TO_PRODUCE,			/* Chain starts empty */
+	QED_CHAIN_USE_TO_CONSUME,			/* Chain starts full */
+	QED_CHAIN_USE_TO_CONSUME_PRODUCE,		/* Chain starts empty */
 };
 
 enum qed_chain_cnt_type {
@@ -40,84 +40,86 @@ enum qed_chain_cnt_type {
 };
 
 struct qed_chain_next {
-	struct regpair	next_phys;
-	void		*next_virt;
+	struct regpair					next_phys;
+	void						*next_virt;
 };
 
 struct qed_chain_pbl_u16 {
-	u16 prod_page_idx;
-	u16 cons_page_idx;
+	u16						prod_page_idx;
+	u16						cons_page_idx;
 };
 
 struct qed_chain_pbl_u32 {
-	u32 prod_page_idx;
-	u32 cons_page_idx;
+	u32						prod_page_idx;
+	u32						cons_page_idx;
 };
 
 struct qed_chain_ext_pbl {
-	dma_addr_t p_pbl_phys;
-	void *p_pbl_virt;
+	dma_addr_t					p_pbl_phys;
+	void						*p_pbl_virt;
 };
 
 struct qed_chain_u16 {
 	/* Cyclic index of next element to produce/consme */
-	u16 prod_idx;
-	u16 cons_idx;
+	u16						prod_idx;
+	u16						cons_idx;
 };
 
 struct qed_chain_u32 {
 	/* Cyclic index of next element to produce/consme */
-	u32 prod_idx;
-	u32 cons_idx;
+	u32						prod_idx;
+	u32						cons_idx;
 };
 
 struct addr_tbl_entry {
-	void *virt_addr;
-	dma_addr_t dma_map;
+	void						*virt_addr;
+	dma_addr_t					dma_map;
 };
 
 struct qed_chain {
-	/* fastpath portion of the chain - required for commands such
+	/* Fastpath portion of the chain - required for commands such
 	 * as produce / consume.
 	 */
+
 	/* Point to next element to produce/consume */
-	void *p_prod_elem;
-	void *p_cons_elem;
+	void						*p_prod_elem;
+	void						*p_cons_elem;
 
 	/* Fastpath portions of the PBL [if exists] */
+
 	struct {
 		/* Table for keeping the virtual and physical addresses of the
 		 * chain pages, respectively to the physical addresses
 		 * in the pbl table.
 		 */
-		struct addr_tbl_entry *pp_addr_tbl;
+		struct addr_tbl_entry			*pp_addr_tbl;
 
 		union {
-			struct qed_chain_pbl_u16 u16;
-			struct qed_chain_pbl_u32 u32;
-		} c;
-	} pbl;
+			struct qed_chain_pbl_u16	u16;
+			struct qed_chain_pbl_u32	u32;
+		}					c;
+	}						pbl;
 
 	union {
-		struct qed_chain_u16 chain16;
-		struct qed_chain_u32 chain32;
-	} u;
+		struct qed_chain_u16			chain16;
+		struct qed_chain_u32			chain32;
+	}						u;
 
 	/* Capacity counts only usable elements */
-	u32 capacity;
-	u32 page_cnt;
+	u32						capacity;
+	u32						page_cnt;
 
-	enum qed_chain_mode mode;
+	enum qed_chain_mode				mode;
 
 	/* Elements information for fast calculations */
-	u16 elem_per_page;
-	u16 elem_per_page_mask;
-	u16 elem_size;
-	u16 next_page_mask;
-	u16 usable_per_page;
-	u8 elem_unusable;
+	u16						elem_per_page;
+	u16						elem_per_page_mask;
+	u16						elem_size;
+	u16						next_page_mask;
+	u16						usable_per_page;
+	u8						elem_unusable;
 
-	u8 cnt_type;
+	u8						cnt_type;
 
 	/* Slowpath of the chain - required for initialization and destruction,
 	 * but isn't involved in regular functionality.
@@ -125,43 +127,47 @@ struct qed_chain {
 
 	/* Base address of a pre-allocated buffer for pbl */
 	struct {
-		dma_addr_t p_phys_table;
-		void *p_virt_table;
-	} pbl_sp;
+		dma_addr_t				p_phys_table;
+		void					*p_virt_table;
+	}						pbl_sp;
 
 	/* Address of first page of the chain - the address is required
 	 * for fastpath operation [consume/produce] but only for the SINGLE
 	 * flavour which isn't considered fastpath [== SPQ].
 	 */
-	void *p_virt_addr;
-	dma_addr_t p_phys_addr;
+	void						*p_virt_addr;
+	dma_addr_t					p_phys_addr;
 
 	/* Total number of elements [for entire chain] */
-	u32 size;
+	u32						size;
 
-	u8 intended_use;
+	u8						intended_use;
 
-	bool b_external_pbl;
+	bool						b_external_pbl;
 };
 
-#define QED_CHAIN_PBL_ENTRY_SIZE        (8)
-#define QED_CHAIN_PAGE_SIZE             (0x1000)
-#define ELEMS_PER_PAGE(elem_size)       (QED_CHAIN_PAGE_SIZE / (elem_size))
+#define QED_CHAIN_PBL_ENTRY_SIZE			8
+#define QED_CHAIN_PAGE_SIZE				0x1000
+
+#define ELEMS_PER_PAGE(elem_size)					     \
+	(QED_CHAIN_PAGE_SIZE / (elem_size))
 
-#define UNUSABLE_ELEMS_PER_PAGE(elem_size, mode)	 \
-	(((mode) == QED_CHAIN_MODE_NEXT_PTR) ?		 \
-	 (u8)(1 + ((sizeof(struct qed_chain_next) - 1) / \
-		   (elem_size))) : 0)
+#define UNUSABLE_ELEMS_PER_PAGE(elem_size, mode)			     \
+	(((mode) == QED_CHAIN_MODE_NEXT_PTR) ?				     \
+	 (u8)(1 + ((sizeof(struct qed_chain_next) - 1) / (elem_size))) :     \
+	 0)
 
-#define USABLE_ELEMS_PER_PAGE(elem_size, mode) \
-	((u32)(ELEMS_PER_PAGE(elem_size) -     \
-	       UNUSABLE_ELEMS_PER_PAGE(elem_size, mode)))
+#define USABLE_ELEMS_PER_PAGE(elem_size, mode)				     \
+	((u32)(ELEMS_PER_PAGE(elem_size) -				     \
+	       UNUSABLE_ELEMS_PER_PAGE((elem_size), (mode))))
 
-#define QED_CHAIN_PAGE_CNT(elem_cnt, elem_size, mode) \
-	DIV_ROUND_UP(elem_cnt, USABLE_ELEMS_PER_PAGE(elem_size, mode))
+#define QED_CHAIN_PAGE_CNT(elem_cnt, elem_size, mode)			     \
+	DIV_ROUND_UP((elem_cnt), USABLE_ELEMS_PER_PAGE((elem_size), (mode)))
 
-#define is_chain_u16(p) ((p)->cnt_type == QED_CHAIN_CNT_TYPE_U16)
-#define is_chain_u32(p) ((p)->cnt_type == QED_CHAIN_CNT_TYPE_U32)
+#define is_chain_u16(p)							     \
+	((p)->cnt_type == QED_CHAIN_CNT_TYPE_U16)
+#define is_chain_u32(p)							     \
+	((p)->cnt_type == QED_CHAIN_CNT_TYPE_U32)
 
 /* Accessors */
 static inline u16 qed_chain_get_prod_idx(struct qed_chain *p_chain)
-- 
2.25.1

