Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BF8A1207
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfH2Gpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727464AbfH2GpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6hQga008744
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wzOrNnsGqtGBec5jDXVNzT2WS3qWBIpUNIGl1NV+ky8=;
 b=iYcjyK87AYLpy2cbu5/ddnZSs9KymiPkN+HlQ/6PkY51Jj+VgpXr/qeNDJB3HFpyyeAN
 6XfF5ZAY8Vk9AjShhSw6vrWnKhD39oJLTMh3+VAvIDpotP38NGPbyTIUz6l+W5VaSC3k
 aFQusp0v+PS3HLY3CAynltiuM/Zyt85R5m4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2une016qub-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:12 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:45:10 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 14A823702BA3; Wed, 28 Aug 2019 23:45:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 06/13] tools/bpf: sync uapi header bpf.h
Date:   Wed, 28 Aug 2019 23:45:09 -0700
Message-ID: <20190829064509.2750871-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=833 phishscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290072
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync uapi header include/uapi/linux/bpf.h to
tools/include/uapi/linux/bpf.h.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/include/uapi/linux/bpf.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5d2fb183ee2d..576688f13e8c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -107,6 +107,10 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_MAP_LOOKUP_BATCH,
+	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+	BPF_MAP_UPDATE_BATCH,
+	BPF_MAP_DELETE_BATCH,
 };
 
 enum bpf_map_type {
@@ -347,6 +351,9 @@ enum bpf_attach_type {
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
+/* flags for BPF_MAP_*_BATCH */
+#define BPF_F_ENFORCE_ENOENT	(1U << 0)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY = 0,
@@ -396,6 +403,26 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_*_BATCH commands */
+		__aligned_u64	start_key;	/* input: storing start key,
+						 * if NULL, starting from the beginning.
+						 */
+		__aligned_u64	next_start_key;	/* output: storing next batch start_key,
+						 * if NULL, no next key.
+						 */
+		__aligned_u64	keys;		/* input/output: key buffer */
+		__aligned_u64	values;		/* input/output: value buffer */
+		__u32		count;		/* input: # of keys/values in
+						 *   or fits in keys[]/values[].
+						 * output: how many successful
+						 *   lookup/lookup_and_delete
+						 *   update/delete operations.
+						 */
+		__u32		map_fd;
+		__u64		elem_flags;	/* BPF_MAP_*_ELEM flags */
+		__u64		flags;		/* flags for batch operation */
+	} batch;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
-- 
2.17.1

