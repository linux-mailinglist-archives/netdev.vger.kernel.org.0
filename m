Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1CAA0BFB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfH1VEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65252 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfH1VEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:04 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7SL3DLG027737
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=luB/P6B7Bs6XQoDFTkWB3eskeA3/FPdPWOldlXkrQkA=;
 b=iRt8sbmasKH8mHgNGfrxSipPx6c33u39tNIx/hv98L+dHZ3Qcfy3qvWwnqk+JJ8IDRuO
 shXq/tCrx2hzZv0B62smfuPqTFul/IjvbU25LAxTznwAL7vuH8zFl1xJOEDGkAd2RkD/
 uVtTArbkyGrVq3BmmluLfx9FEYo36xiWES0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2untb0j7fq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:02 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 14:04:00 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id 8BAF2A25D5E1; Wed, 28 Aug 2019 14:03:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 02/10] tools/bpf: sync bpf.h to tools/
Date:   Wed, 28 Aug 2019 14:03:05 -0700
Message-ID: <6c3d8803a29cf7147242dfe43af101ecb9f40f99.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=951 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908280205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce __MAX_BPF_MAP_TYPE and __MAX_BPF_MAP_TYPE enum values.

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/include/uapi/linux/bpf.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5d2fb183ee2d..9b681bb82211 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -136,8 +136,11 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
+	__MAX_BPF_MAP_TYPE
 };
 
+#define MAX_BPF_MAP_TYPE __MAX_BPF_MAP_TYPE
+
 /* Note that tracing related programs such as
  * BPF_PROG_TYPE_{KPROBE,TRACEPOINT,PERF_EVENT,RAW_TRACEPOINT}
  * are not subject to a stable API since kernel internal data
@@ -173,8 +176,11 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	__MAX_BPF_PROG_TYPE
 };
 
+#define MAX_BPF_PROG_TYPE __MAX_BPF_PROG_TYPE
+
 enum bpf_attach_type {
 	BPF_CGROUP_INET_INGRESS,
 	BPF_CGROUP_INET_EGRESS,
-- 
2.17.1

