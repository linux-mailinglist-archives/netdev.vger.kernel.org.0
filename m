Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244E6136103
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgAITXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:23:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729845AbgAITXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:23:31 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009JNQro008765
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 11:23:30 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdrj8n6pf-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:23:30 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 11:23:18 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 29CBE91C8AA3; Thu,  9 Jan 2020 11:23:17 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>, <tariqt@mellanox.com>
CC:     <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
Date:   Thu, 9 Jan 2020 11:23:17 -0800
Message-ID: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_04:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1034 mlxscore=0 mlxlogscore=959 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On modern hardware with a large number of cpus and using XDP,
the current MSIX limit is insufficient.  Bump the limit in
order to allow more queues.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/mlx4/device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 36e412c3d657..20372de0b587 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -47,7 +47,7 @@
 #define DEFAULT_UAR_PAGE_SHIFT  12
 
 #define MAX_MSIX_P_PORT		17
-#define MAX_MSIX		64
+#define MAX_MSIX		128
 #define MIN_MSIX_P_PORT		5
 #define MLX4_IS_LEGACY_EQ_MODE(dev_cap) ((dev_cap).num_comp_vectors < \
 					 (dev_cap).num_ports * MIN_MSIX_P_PORT)
-- 
2.17.1

