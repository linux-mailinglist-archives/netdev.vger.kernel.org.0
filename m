Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FE43DCB1A
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhHAK3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:29:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231461AbhHAK3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:29:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171ANv6f015561;
        Sun, 1 Aug 2021 03:28:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=ke4gyB5ij2SuQzxPgLIiKAQtRxchNGim7N9SceNCtuQ=;
 b=QRYZRukFx8PlUzFp/QhPP7PiyocPTQpfj0E5UtBjDjT1XXPVFyo+4DPCPv9mZZNRvV+x
 ikRRIAyYw9UOf56gr1PNnAdaoHgaaiSKiHRtKJHrJkzsxCWMhNJAryDTdVXW2FZcWnAt
 Su+L7kCarnWx9dOc1O9ajRDVtp9FaXXuKTiA775wjYD0X/V267OwB+dxWb0dz15UwwzF
 UuUmCiXf4+K7HgGV50aHiombquEHSYsIdnW+gKIsXnYUILyoviJZaLcsvxF5Ex7IrKh+
 aqfBytp163H5TM0VcKvjqeqN5W58Xo1JoFsurragWkbsPY+7f4zPw5o5XKHrL/fp43QP 1g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a53vrahfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Aug 2021 03:28:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 1 Aug
 2021 03:28:56 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 1 Aug 2021 03:28:55 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH] qed: Remove redundant prints from the iWARP SYN handling
Date:   Sun, 1 Aug 2021 13:28:40 +0300
Message-ID: <20210801102840.21822-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UEiLo2TRfbV9nHDAv9Ev470ehLMrgwph
X-Proofpoint-GUID: UEiLo2TRfbV9nHDAv9Ev470ehLMrgwph
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-31_14:2021-07-30,2021-07-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant prints from the iWARP SYN handling.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index a99861124630..fc8b3e64f153 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1624,8 +1624,6 @@ qed_iwarp_get_listener(struct qed_hwfn *p_hwfn,
 	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
 	bool found = false;
 
-	qed_iwarp_print_cm_info(p_hwfn, cm_info);
-
 	list_for_each_entry(listener,
 			    &p_hwfn->p_rdma_info->iwarp.listen_list,
 			    list_entry) {
-- 
2.22.0

