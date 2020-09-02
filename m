Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316BD25B290
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 19:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIBRBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 13:01:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46174 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbgIBQ6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GtHHR032487;
        Wed, 2 Sep 2020 09:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DlnYCg5hjrZxLLwYazRdwDYCn5nVYJYeJqYeotpm5Dg=;
 b=GE5Hw+nAwFDbERKcx8+9intCOF2CC1a/+U17htfn6ziZS7c2PcnJah4d2N9Pq7qsjFBz
 1kvXYsaMlnQYl0u2y9A73G/+JljJIhinr6voeaS9CNIe3Kb5ynt60Fz8lXAObCN71cKF
 ebif+gyuIRBr99CQLkuuhbHF5UtMKKucoc3bOFqCttxRW2qzv30PulKTeJ3XMKvzv3G8
 jlv3DJBClFm+PGkVd069rJgpW1XCadxbGP9jGvWjrYWrCv5vorBqcyaqBGm5TxWwAiYY
 acLHwXGblcyta9R2dzZm6MktLX64W6HNdw7W002Yh3XfqAPIaEt7s+2FfBZ8IU7NpaTj 6Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq7jf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:32 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:30 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2289B3F703F;
        Wed,  2 Sep 2020 09:58:27 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 8/8] RDMA/qedr: Fix function prototype parameters alignment
Date:   Wed, 2 Sep 2020 19:57:41 +0300
Message-ID: <20200902165741.8355-9-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200902165741.8355-1-michal.kalderon@marvell.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_11:2020-09-02,2020-09-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alignment of parameters was off by one

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 3b19afdf71b8..0227540838ee 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1249,8 +1249,8 @@ static int qedr_copy_srq_uresp(struct qedr_dev *dev,
 }
 
 static void qedr_copy_rq_uresp(struct qedr_dev *dev,
-			      struct qedr_create_qp_uresp *uresp,
-			      struct qedr_qp *qp)
+			       struct qedr_create_qp_uresp *uresp,
+			       struct qedr_qp *qp)
 {
 	/* iWARP requires two doorbells per RQ. */
 	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
-- 
2.14.5

