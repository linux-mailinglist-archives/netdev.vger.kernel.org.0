Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F2F37F2B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfFFU7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:59:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50010 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727391AbfFFU7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:59:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KwOa3026011
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 13:59:46 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxuce3dcv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 13:59:46 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 13:59:45 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id C3E0723327D56; Thu,  6 Jun 2019 13:59:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <toke@redhat.com>, <brouer@redhat.com>, <daniel@iogearbox.net>,
        <ast@kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v5 bpf-next 2/4] bpf/tools: sync bpf.h
Date:   Thu, 6 Jun 2019 13:59:41 -0700
Message-ID: <20190606205943.818795-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606205943.818795-1-jonathan.lemon@gmail.com>
References: <20190606205943.818795-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=719 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync uapi/linux/bpf.h 

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7c6aef253173..ae0907d8c03a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3083,6 +3083,10 @@ struct bpf_sock_tuple {
 	};
 };
 
+struct bpf_xdp_sock {
+	__u32 queue_id;
+};
+
 #define XDP_PACKET_HEADROOM 256
 
 /* User return codes for XDP prog type.
-- 
2.17.1

