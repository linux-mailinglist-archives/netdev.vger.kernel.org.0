Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0322A202
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbgGVWMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:12:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10194 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732822AbgGVWMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:12:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM6OQ6027398;
        Wed, 22 Jul 2020 15:12:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=jo7zq49EmldMSHyr0Cgl+awUK69ydVsJpsPNWv3pVX0=;
 b=GEOJAg5YopPfRQLgYK9fdZndFpkfI0v3VwGIGftNTF4CBTEVIoLHT8N4NXL5x+x5CMCm
 tLMs0LOjgJOLh26mww6rWZV29QLdQ0c7bRUPkUxO8Kfh4HD466Y1uS+NgPprGb3h09Gk
 UhZlPPHliGtRVTOQ5m6tFXSVWUhLogyXs2nNzk79cw34bhelp3W3Ew20PeD07Y+GqIYQ
 9iAShbZacWBQYWxcRUdpeKJIGMvw1nC6Fadc8MG6B+4HiOKow36mq6Id3MVdQgF7E/Ub
 i/1RDPm5vvBgpEd2wXGzpase26SmlG4xLNd0/lyFnVgDH5bb90pGXZ9wR21gOXkh5o02 0g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxentxa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:12:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:12:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:12:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:12:27 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 2678A3F703F;
        Wed, 22 Jul 2020 15:12:20 -0700 (PDT)
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
Subject: [PATCH v2 net-next 12/15] qede: reformat several structures in "qede.h"
Date:   Thu, 23 Jul 2020 01:10:42 +0300
Message-ID: <20200722221045.5436-13-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722221045.5436-1-alobakin@marvell.com>
References: <20200722221045.5436-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_16:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the file more readable and easier for adding new fields.

Misc: use IFNAMSIZ and netdev_name() instead of sizeof_field()
and direct net_device::name dereferencing.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h | 166 +++++++++++++-----------
 1 file changed, 89 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f1d7f73de902..e8ed0bb94ee0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -176,16 +176,17 @@ struct qede_dev {
 	u32				dp_module;
 	u8				dp_level;
 
-	unsigned long flags;
-#define IS_VF(edev)	(test_bit(QEDE_FLAGS_IS_VF, &(edev)->flags))
+	unsigned long			flags;
+#define IS_VF(edev)			test_bit(QEDE_FLAGS_IS_VF, \
+						 &(edev)->flags)
 
 	const struct qed_eth_ops	*ops;
 	struct qede_ptp			*ptp;
 	u64				ptp_skip_txts;
 
-	struct qed_dev_eth_info dev_info;
-#define QEDE_MAX_RSS_CNT(edev)	((edev)->dev_info.num_queues)
-#define QEDE_MAX_TSS_CNT(edev)	((edev)->dev_info.num_queues)
+	struct qed_dev_eth_info		dev_info;
+#define QEDE_MAX_RSS_CNT(edev)		((edev)->dev_info.num_queues)
+#define QEDE_MAX_TSS_CNT(edev)		((edev)->dev_info.num_queues)
 #define QEDE_IS_BB(edev) \
 	((edev)->dev_info.common.dev_type == QED_DEV_TYPE_BB)
 #define QEDE_IS_AH(edev) \
@@ -198,14 +199,15 @@ struct qede_dev {
 	u8				fp_num_rx;
 	u16				req_queues;
 	u16				num_queues;
-#define QEDE_QUEUE_CNT(edev)	((edev)->num_queues)
-#define QEDE_RSS_COUNT(edev)	((edev)->num_queues - (edev)->fp_num_tx)
+
+#define QEDE_QUEUE_CNT(edev)		((edev)->num_queues)
+#define QEDE_RSS_COUNT(edev)		((edev)->num_queues - (edev)->fp_num_tx)
 #define QEDE_RX_QUEUE_IDX(edev, i)	(i)
-#define QEDE_TSS_COUNT(edev)	((edev)->num_queues - (edev)->fp_num_rx)
+#define QEDE_TSS_COUNT(edev)		((edev)->num_queues - (edev)->fp_num_rx)
 
 	struct qed_int_info		int_info;
 
-	/* Smaller private varaiant of the RTNL lock */
+	/* Smaller private variant of the RTNL lock */
 	struct mutex			qede_lock;
 	u32				state; /* Protected by qede_lock */
 	u16				rx_buf_size;
@@ -226,22 +228,28 @@ struct qede_dev {
 	      SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 	struct qede_stats		stats;
-#define QEDE_RSS_INDIR_INITED	BIT(0)
-#define QEDE_RSS_KEY_INITED	BIT(1)
-#define QEDE_RSS_CAPS_INITED	BIT(2)
-	u32 rss_params_inited; /* bit-field to track initialized rss params */
-	u16 rss_ind_table[128];
-	u32 rss_key[10];
-	u8 rss_caps;
-
-	u16			q_num_rx_buffers; /* Must be a power of two */
-	u16			q_num_tx_buffers; /* Must be a power of two */
-
-	bool gro_disable;
-	struct list_head vlan_list;
-	u16 configured_vlans;
-	u16 non_configured_vlans;
-	bool accept_any_vlan;
+
+	/* Bitfield to track initialized RSS params */
+	u32				rss_params_inited;
+#define QEDE_RSS_INDIR_INITED		BIT(0)
+#define QEDE_RSS_KEY_INITED		BIT(1)
+#define QEDE_RSS_CAPS_INITED		BIT(2)
+
+	u16				rss_ind_table[128];
+	u32				rss_key[10];
+	u8				rss_caps;
+
+	/* Both must be a power of two */
+	u16				q_num_rx_buffers;
+	u16				q_num_tx_buffers;
+
+	bool				gro_disable;
+
+	struct list_head		vlan_list;
+	u16				configured_vlans;
+	u16				non_configured_vlans;
+	bool				accept_any_vlan;
+
 	struct delayed_work		sp_task;
 	unsigned long			sp_flags;
 	u16				vxlan_dst_port;
@@ -252,14 +260,14 @@ struct qede_dev {
 
 	struct qede_rdma_dev		rdma_info;
 
-	struct bpf_prog *xdp_prog;
+	struct bpf_prog			*xdp_prog;
 
-	unsigned long err_flags;
-#define QEDE_ERR_IS_HANDLED	31
-#define QEDE_ERR_ATTN_CLR_EN	0
-#define QEDE_ERR_GET_DBG_INFO	1
-#define QEDE_ERR_IS_RECOVERABLE	2
-#define QEDE_ERR_WARN		3
+	unsigned long			err_flags;
+#define QEDE_ERR_IS_HANDLED		31
+#define QEDE_ERR_ATTN_CLR_EN		0
+#define QEDE_ERR_GET_DBG_INFO		1
+#define QEDE_ERR_IS_RECOVERABLE		2
+#define QEDE_ERR_WARN			3
 
 	struct qede_dump_info		dump_info;
 };
@@ -372,29 +380,30 @@ struct sw_tx_bd {
 };
 
 struct sw_tx_xdp {
-	struct page *page;
-	dma_addr_t mapping;
+	struct page			*page;
+	dma_addr_t			mapping;
 };
 
 struct qede_tx_queue {
-	u8 is_xdp;
-	bool is_legacy;
-	u16 sw_tx_cons;
-	u16 sw_tx_prod;
-	u16 num_tx_buffers; /* Slowpath only */
+	u8				is_xdp;
+	bool				is_legacy;
+	u16				sw_tx_cons;
+	u16				sw_tx_prod;
+	u16				num_tx_buffers; /* Slowpath only */
 
-	u64 xmit_pkts;
-	u64 stopped_cnt;
-	u64 tx_mem_alloc_err;
+	u64				xmit_pkts;
+	u64				stopped_cnt;
+	u64				tx_mem_alloc_err;
 
-	__le16 *hw_cons_ptr;
+	__le16				*hw_cons_ptr;
 
 	/* Needed for the mapping of packets */
-	struct device *dev;
+	struct device			*dev;
+
+	void __iomem			*doorbell_addr;
+	union db_prod			tx_db;
 
-	void __iomem *doorbell_addr;
-	union db_prod tx_db;
-	int index; /* Slowpath only */
+	int				index; /* Slowpath only */
 #define QEDE_TXQ_XDP_TO_IDX(edev, txq)	((txq)->index - \
 					 QEDE_MAX_TSS_CNT(edev))
 #define QEDE_TXQ_IDX_TO_XDP(edev, idx)	((idx) + QEDE_MAX_TSS_CNT(edev))
@@ -406,22 +415,22 @@ struct qede_tx_queue {
 #define QEDE_NDEV_TXQ_ID_TO_TXQ(edev, idx)	\
 	(&((edev)->fp_array[QEDE_NDEV_TXQ_ID_TO_FP_ID(edev, idx)].txq \
 	[QEDE_NDEV_TXQ_ID_TO_TXQ_COS(edev, idx)]))
-#define QEDE_FP_TC0_TXQ(fp)	(&((fp)->txq[0]))
+#define QEDE_FP_TC0_TXQ(fp)		(&((fp)->txq[0]))
 
 	/* Regular Tx requires skb + metadata for release purpose,
 	 * while XDP requires the pages and the mapped address.
 	 */
 	union {
-		struct sw_tx_bd *skbs;
-		struct sw_tx_xdp *xdp;
-	} sw_tx_ring;
+		struct sw_tx_bd		*skbs;
+		struct sw_tx_xdp	*xdp;
+	}				sw_tx_ring;
 
-	struct qed_chain tx_pbl;
+	struct qed_chain		tx_pbl;
 
 	/* Slowpath; Should be kept in end [unless missing padding] */
-	void *handle;
-	u16 cos;
-	u16 ndev_txq_id;
+	void				*handle;
+	u16				cos;
+	u16				ndev_txq_id;
 };
 
 #define BD_UNMAP_ADDR(bd)		HILO_U64(le32_to_cpu((bd)->addr.hi), \
@@ -435,32 +444,35 @@ struct qede_tx_queue {
 #define BD_UNMAP_LEN(bd)		(le16_to_cpu((bd)->nbytes))
 
 struct qede_fastpath {
-	struct qede_dev	*edev;
-#define QEDE_FASTPATH_TX	BIT(0)
-#define QEDE_FASTPATH_RX	BIT(1)
-#define QEDE_FASTPATH_XDP	BIT(2)
-#define QEDE_FASTPATH_COMBINED	(QEDE_FASTPATH_TX | QEDE_FASTPATH_RX)
-	u8			type;
-	u8			id;
-	u8			xdp_xmit;
-	struct napi_struct	napi;
-	struct qed_sb_info	*sb_info;
-	struct qede_rx_queue	*rxq;
-	struct qede_tx_queue	*txq;
-	struct qede_tx_queue	*xdp_tx;
-
-#define VEC_NAME_SIZE  (sizeof_field(struct net_device, name) + 8)
-	char	name[VEC_NAME_SIZE];
+	struct qede_dev			*edev;
+
+	u8				type;
+#define QEDE_FASTPATH_TX		BIT(0)
+#define QEDE_FASTPATH_RX		BIT(1)
+#define QEDE_FASTPATH_XDP		BIT(2)
+#define QEDE_FASTPATH_COMBINED		(QEDE_FASTPATH_TX | QEDE_FASTPATH_RX)
+
+	u8				id;
+
+	u8				xdp_xmit;
+
+	struct napi_struct		napi;
+	struct qed_sb_info		*sb_info;
+	struct qede_rx_queue		*rxq;
+	struct qede_tx_queue		*txq;
+	struct qede_tx_queue		*xdp_tx;
+
+	char				name[IFNAMSIZ + 8];
 };
 
 /* Debug print definitions */
-#define DP_NAME(edev) ((edev)->ndev->name)
+#define DP_NAME(edev)			netdev_name((edev)->ndev)
 
-#define XMIT_PLAIN		0
-#define XMIT_L4_CSUM		BIT(0)
-#define XMIT_LSO		BIT(1)
-#define XMIT_ENC		BIT(2)
-#define XMIT_ENC_GSO_L4_CSUM	BIT(3)
+#define XMIT_PLAIN			0
+#define XMIT_L4_CSUM			BIT(0)
+#define XMIT_LSO			BIT(1)
+#define XMIT_ENC			BIT(2)
+#define XMIT_ENC_GSO_L4_CSUM		BIT(3)
 
 #define QEDE_CSUM_ERROR			BIT(0)
 #define QEDE_CSUM_UNNECESSARY		BIT(1)
-- 
2.25.1

