Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8ED1E8100
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgE2Oya convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 May 2020 10:54:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbgE2Oy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 10:54:28 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04TEWbFH146374
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:54:26 -0400
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [158.85.210.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31as1dv1jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 10:54:25 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Fri, 29 May 2020 14:54:24 -0000
Received: from us1b3-smtp06.a3dr.sjc01.isc4sb.com (10.122.203.184)
        by smtp.notes.na.collabserv.com (10.122.47.48) with smtp.notes.na.collabserv.com ESMTP;
        Fri, 29 May 2020 14:54:15 -0000
Received: from us1b3-mail162.a3dr.sjc03.isc4sb.com ([10.160.174.187])
          by us1b3-smtp06.a3dr.sjc01.isc4sb.com
          with ESMTP id 2020052914541423-481199 ;
          Fri, 29 May 2020 14:54:14 +0000 
In-Reply-To: <12-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     "Jason Gunthorpe" <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        "Ariel Elior" <aelior@marvell.com>,
        "Dennis Dalessandro" <dennis.dalessandro@intel.com>,
        "Devesh Sharma" <devesh.sharma@broadcom.com>,
        "Max Gurtovoy" <maxg@mellanox.com>,
        "Mike Marciniszyn" <mike.marciniszyn@intel.com>,
        "Michal Kalderon" <mkalderon@marvell.com>, oren@mellanox.com,
        "Selvin Xavier" <selvin.xavier@broadcom.com>, shlomin@mellanox.com,
        vladimirk@mellanox.com
Date:   Fri, 29 May 2020 14:54:14 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <12-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
X-Mailer: IBM iNotes ($HaikuForm 1054.1) | IBM Domino Build
 SCN1812108_20180501T0841_FP65 April 15, 2020 at 09:48
X-KeepSent: 78FEA9FD:1742AE45-00258577:0051870C;
 type=4; name=$KeepSent
X-LLNOutbound: False
X-Disclaimed: 62691
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
x-cbid: 20052914-1429-0000-0000-000002153B00
X-IBM-SpamModules-Scores: BY=0; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.399202; ST=0; TS=0; UL=0; ISC=; MB=0.000259
X-IBM-SpamModules-Versions: BY=3.00013187; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000295; SDB=6.01383825; UDB=6.00740078; IPR=6.01166097;
 MB=3.00032375; MTD=3.00000008; XFM=3.00000015; UTC=2020-05-29 14:54:22
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2020-05-29 08:17:51 - 6.00011419
x-cbparentid: 20052914-1430-0000-0000-0000D0703DC0
Message-Id: <OF78FEA9FD.1742AE45-ON00258577.0051870C-00258577.0051DEBC@notes.na.collabserv.com>
Subject: Re:  [PATCH v3 12/13] RDMA: Remove 'max_fmr'
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_07:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Reason: orgsafe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----"Jason Gunthorpe" <jgg@ziepe.ca> wrote: -----

>To: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
>From: "Jason Gunthorpe" <jgg@ziepe.ca>
>Date: 05/28/2020 09:46PM
>Cc: "Ariel Elior" <aelior@marvell.com>, "Bernard Metzler"
><bmt@zurich.ibm.com>, "Dennis Dalessandro"
><dennis.dalessandro@intel.com>, "Devesh Sharma"
><devesh.sharma@broadcom.com>, "Max Gurtovoy" <maxg@mellanox.com>,
>"Mike Marciniszyn" <mike.marciniszyn@intel.com>, "Michal Kalderon"
><mkalderon@marvell.com>, oren@mellanox.com, "Selvin Xavier"
><selvin.xavier@broadcom.com>, shlomin@mellanox.com,
>vladimirk@mellanox.com
>Subject: [EXTERNAL] [PATCH v3 12/13] RDMA: Remove 'max_fmr'
>
>From: Jason Gunthorpe <jgg@mellanox.com>
>
>Now that FMR support is gone, this attribute can be deleted from all
>places.
>
>Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
>Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>Cc: Bernard Metzler <bmt@zurich.ibm.com>
>Cc: Selvin Xavier <selvin.xavier@broadcom.com>
>Cc: Devesh Sharma <devesh.sharma@broadcom.com>
>Cc: Michal Kalderon <mkalderon@marvell.com>
>Cc: Ariel Elior <aelior@marvell.com>
>Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
>Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
>---
> drivers/infiniband/core/uverbs_cmd.c        | 1 -
> drivers/infiniband/hw/ocrdma/ocrdma.h       | 1 -
> drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 1 -
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 -
> drivers/infiniband/hw/qedr/main.c           | 1 -
> drivers/infiniband/hw/qedr/qedr.h           | 1 -
> drivers/infiniband/hw/qedr/verbs.c          | 1 -
> drivers/infiniband/sw/rdmavt/mr.c           | 1 -
> drivers/infiniband/sw/siw/siw.h             | 2 --
> drivers/infiniband/sw/siw/siw_main.c        | 1 -
> drivers/infiniband/sw/siw/siw_verbs.c       | 1 -
> drivers/net/ethernet/qlogic/qed/qed_rdma.c  | 1 -
> drivers/net/ethernet/qlogic/qed/qed_rdma.h  | 1 -
> include/linux/qed/qed_rdma_if.h             | 1 -
> include/rdma/ib_verbs.h                     | 1 -
> net/rds/ib.c                                | 2 +-
> 16 files changed, 1 insertion(+), 17 deletions(-)
>
>diff --git a/drivers/infiniband/core/uverbs_cmd.c
>b/drivers/infiniband/core/uverbs_cmd.c
>index 2067a939788bd5..56d207405dbd1c 100644
>--- a/drivers/infiniband/core/uverbs_cmd.c
>+++ b/drivers/infiniband/core/uverbs_cmd.c
>@@ -356,7 +356,6 @@ static void copy_query_dev_fields(struct
>ib_ucontext *ucontext,
> 	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
> 	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
> 	resp->max_ah			= attr->max_ah;
>-	resp->max_fmr			= attr->max_fmr;
> 	resp->max_map_per_fmr		= attr->max_map_per_fmr;
> 	resp->max_srq			= attr->max_srq;
> 	resp->max_srq_wr		= attr->max_srq_wr;
>diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h
>b/drivers/infiniband/hw/ocrdma/ocrdma.h
>index 7baedc74e39d7e..fcfe0e82197a24 100644
>--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
>+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
>@@ -98,7 +98,6 @@ struct ocrdma_dev_attr {
> 	u64 max_mr_size;
> 	u32 max_num_mr_pbl;
> 	int max_mw;
>-	int max_fmr;
> 	int max_map_per_fmr;
> 	int max_pages_per_frmr;
> 	u16 max_ord_per_qp;
>diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>index d82d3ec3649ea0..e07bf0b2209a4c 100644
>--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
>@@ -1190,7 +1190,6 @@ static void ocrdma_get_attr(struct ocrdma_dev
>*dev,
> 	attr->max_mr = rsp->max_mr;
> 	attr->max_mr_size = ((u64)rsp->max_mr_size_hi << 32) |
> 			      rsp->max_mr_size_lo;
>-	attr->max_fmr = 0;
> 	attr->max_pages_per_frmr = rsp->max_pages_per_frmr;
> 	attr->max_num_mr_pbl = rsp->max_num_mr_pbl;
> 	attr->max_cqe = rsp->max_cq_cqes_per_cq &
>diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>index 10e34389459592..890e3fd41d2199 100644
>--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>@@ -99,7 +99,6 @@ int ocrdma_query_device(struct ib_device *ibdev,
>struct ib_device_attr *attr,
> 	attr->max_mw = dev->attr.max_mw;
> 	attr->max_pd = dev->attr.max_pd;
> 	attr->atomic_cap = 0;
>-	attr->max_fmr = 0;
> 	attr->max_map_per_fmr = 0;
> 	attr->max_qp_rd_atom =
> 	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
>diff --git a/drivers/infiniband/hw/qedr/main.c
>b/drivers/infiniband/hw/qedr/main.c
>index dcdc85a1ab2540..ccaedfd53e49e2 100644
>--- a/drivers/infiniband/hw/qedr/main.c
>+++ b/drivers/infiniband/hw/qedr/main.c
>@@ -632,7 +632,6 @@ static int qedr_set_device_attr(struct qedr_dev
>*dev)
> 	attr->max_mr_size = qed_attr->max_mr_size;
> 	attr->max_cqe = min_t(u64, qed_attr->max_cqe, QEDR_MAX_CQES);
> 	attr->max_mw = qed_attr->max_mw;
>-	attr->max_fmr = qed_attr->max_fmr;
> 	attr->max_mr_mw_fmr_pbl = qed_attr->max_mr_mw_fmr_pbl;
> 	attr->max_mr_mw_fmr_size = qed_attr->max_mr_mw_fmr_size;
> 	attr->max_pd = qed_attr->max_pd;
>diff --git a/drivers/infiniband/hw/qedr/qedr.h
>b/drivers/infiniband/hw/qedr/qedr.h
>index 5488dbd59d3c15..fdf90ecb26990f 100644
>--- a/drivers/infiniband/hw/qedr/qedr.h
>+++ b/drivers/infiniband/hw/qedr/qedr.h
>@@ -103,7 +103,6 @@ struct qedr_device_attr {
> 	u64	max_mr_size;
> 	u32	max_cqe;
> 	u32	max_mw;
>-	u32	max_fmr;
> 	u32	max_mr_mw_fmr_pbl;
> 	u64	max_mr_mw_fmr_size;
> 	u32	max_pd;
>diff --git a/drivers/infiniband/hw/qedr/verbs.c
>b/drivers/infiniband/hw/qedr/verbs.c
>index d6b94a71357323..ca88006eaa667c 100644
>--- a/drivers/infiniband/hw/qedr/verbs.c
>+++ b/drivers/infiniband/hw/qedr/verbs.c
>@@ -145,7 +145,6 @@ int qedr_query_device(struct ib_device *ibdev,
> 	attr->max_mw = qattr->max_mw;
> 	attr->max_pd = qattr->max_pd;
> 	attr->atomic_cap = dev->atomic_cap;
>-	attr->max_fmr = qattr->max_fmr;
> 	attr->max_map_per_fmr = 16;
> 	attr->max_qp_init_rd_atom =
> 	    1 << (fls(qattr->max_qp_req_rd_atomic_resc) - 1);
>diff --git a/drivers/infiniband/sw/rdmavt/mr.c
>b/drivers/infiniband/sw/rdmavt/mr.c
>index ddb0c0d771c257..60864e5ca7cb67 100644
>--- a/drivers/infiniband/sw/rdmavt/mr.c
>+++ b/drivers/infiniband/sw/rdmavt/mr.c
>@@ -97,7 +97,6 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
> 		RCU_INIT_POINTER(rdi->lkey_table.table[i], NULL);
> 
> 	rdi->dparms.props.max_mr = rdi->lkey_table.max;
>-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
> 	return 0;
> }
> 
>diff --git a/drivers/infiniband/sw/siw/siw.h
>b/drivers/infiniband/sw/siw/siw.h
>index 5a58a1cc7a7e84..e9753831ac3f33 100644
>--- a/drivers/infiniband/sw/siw/siw.h
>+++ b/drivers/infiniband/sw/siw/siw.h
>@@ -30,7 +30,6 @@
> #define SIW_MAX_MR (SIW_MAX_QP * 10)
> #define SIW_MAX_PD SIW_MAX_QP
> #define SIW_MAX_MW 0 /* to be set if MW's are supported */
>-#define SIW_MAX_FMR SIW_MAX_MR
> #define SIW_MAX_SRQ SIW_MAX_QP
> #define SIW_MAX_SRQ_WR (SIW_MAX_QP_WR * 10)
> #define SIW_MAX_CONTEXT SIW_MAX_PD
>@@ -59,7 +58,6 @@ struct siw_dev_cap {
> 	int max_mr;
> 	int max_pd;
> 	int max_mw;
>-	int max_fmr;
> 	int max_srq;
> 	int max_srq_wr;
> 	int max_srq_sge;
>diff --git a/drivers/infiniband/sw/siw/siw_main.c
>b/drivers/infiniband/sw/siw/siw_main.c
>index 5cd40fb9e20ce5..a0b8cc643c5cfc 100644
>--- a/drivers/infiniband/sw/siw/siw_main.c
>+++ b/drivers/infiniband/sw/siw/siw_main.c
>@@ -413,7 +413,6 @@ static struct siw_device
>*siw_device_create(struct net_device *netdev)
> 	sdev->attrs.max_mr = SIW_MAX_MR;
> 	sdev->attrs.max_pd = SIW_MAX_PD;
> 	sdev->attrs.max_mw = SIW_MAX_MW;
>-	sdev->attrs.max_fmr = SIW_MAX_FMR;
> 	sdev->attrs.max_srq = SIW_MAX_SRQ;
> 	sdev->attrs.max_srq_wr = SIW_MAX_SRQ_WR;
> 	sdev->attrs.max_srq_sge = SIW_MAX_SGE;
>diff --git a/drivers/infiniband/sw/siw/siw_verbs.c
>b/drivers/infiniband/sw/siw/siw_verbs.c
>index aeb842bc7a1ee9..987e2ba05dbc06 100644
>--- a/drivers/infiniband/sw/siw/siw_verbs.c
>+++ b/drivers/infiniband/sw/siw/siw_verbs.c
>@@ -136,7 +136,6 @@ int siw_query_device(struct ib_device *base_dev,
>struct ib_device_attr *attr,
> 	attr->max_cq = sdev->attrs.max_cq;
> 	attr->max_cqe = sdev->attrs.max_cqe;
> 	attr->max_fast_reg_page_list_len = SIW_MAX_SGE_PBL;
>-	attr->max_fmr = sdev->attrs.max_fmr;
> 	attr->max_mr = sdev->attrs.max_mr;
> 	attr->max_mw = sdev->attrs.max_mw;
> 	attr->max_mr_size = ~0ull;
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
>b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
>index 38b1f402f7ed29..5dc18a4bdda4a8 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
>@@ -499,7 +499,6 @@ static void qed_rdma_init_devinfo(struct qed_hwfn
>*p_hwfn,
> 		dev->max_cqe = QED_RDMA_MAX_CQE_16_BIT;
> 
> 	dev->max_mw = 0;
>-	dev->max_fmr = QED_RDMA_MAX_FMR;
> 	dev->max_mr_mw_fmr_pbl = (PAGE_SIZE / 8) * (PAGE_SIZE / 8);
> 	dev->max_mr_mw_fmr_size = dev->max_mr_mw_fmr_pbl * PAGE_SIZE;
> 	dev->max_pkey = QED_RDMA_MAX_P_KEY;
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
>b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
>index 3689fe3e593542..dfaa2f552627f7 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
>+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
>@@ -45,7 +45,6 @@
> #include "qed_iwarp.h"
> #include "qed_roce.h"
> 
>-#define QED_RDMA_MAX_FMR                    (RDMA_MAX_TIDS)
> #define QED_RDMA_MAX_P_KEY                  (1)
> #define QED_RDMA_MAX_WQE                    (0x7FFF)
> #define QED_RDMA_MAX_SRQ_WQE_ELEM           (0x7FFF)
>diff --git a/include/linux/qed/qed_rdma_if.h
>b/include/linux/qed/qed_rdma_if.h
>index 74efca15fde7dd..c90276cda5c162 100644
>--- a/include/linux/qed/qed_rdma_if.h
>+++ b/include/linux/qed/qed_rdma_if.h
>@@ -91,7 +91,6 @@ struct qed_rdma_device {
> 	u64 max_mr_size;
> 	u32 max_cqe;
> 	u32 max_mw;
>-	u32 max_fmr;
> 	u32 max_mr_mw_fmr_pbl;
> 	u64 max_mr_mw_fmr_size;
> 	u32 max_pd;
>diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>index d275ca1e97b7d3..a84f91c2816add 100644
>--- a/include/rdma/ib_verbs.h
>+++ b/include/rdma/ib_verbs.h
>@@ -430,7 +430,6 @@ struct ib_device_attr {
> 	int			max_mcast_qp_attach;
> 	int			max_total_mcast_qp_attach;
> 	int			max_ah;
>-	int			max_fmr;
> 	int			max_map_per_fmr;
> 	int			max_srq;
> 	int			max_srq_wr;
>diff --git a/net/rds/ib.c b/net/rds/ib.c
>index 6c43b3e4c73618..deecbdcdae84ef 100644
>--- a/net/rds/ib.c
>+++ b/net/rds/ib.c
>@@ -217,7 +217,7 @@ static int rds_ib_add_one(struct ib_device
>*device)
> 	}
> 
> 	rdsdebug("RDS/IB: max_mr = %d, max_wrs = %d, max_sge = %d,
>max_1m_mrs = %d, max_8k_mrs = %d\n",
>-		 device->attrs.max_fmr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
>+		 device->attrs.max_mr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
> 		 rds_ibdev->max_1m_mrs, rds_ibdev->max_8k_mrs);
> 
> 	pr_info("RDS/IB: %s: added\n", device->name);
>-- 
>2.26.2
>
>

Thank you, Jason.

Regarding the siw driver part of it, this looks good.
siw never implemented the 'classical' fast memory registration,
but only supporting the more recent FRWR way, which stays intact.
With that, we remove only the leftovers of a never implemented
functionality. So, for siw there is nothing to test.

Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>

