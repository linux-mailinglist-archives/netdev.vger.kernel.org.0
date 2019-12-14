Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED0B11EF5F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfLNAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:48:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58392 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfLNAsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:48:04 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0Tvmh029935
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=GIbrwAH03UgxoiBjij2bCQHSary/JIpWqcXiMokDRJo=;
 b=GhfLZhcivnV8slc9TJpDTMqOt0tCV7MTDadpTwJw1tL4ibed95E3nRpuFx6eTkegzcsv
 NPyyDWy4oaPJepUw3544+cz90b0oDvBHHIGD5gKegzfNff42++M3VWR/t09nTLuG7lMP
 dtNgfqf3VROY+TChhj2tamwJpIEEXAnQbVA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvd4vaav7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:02 -0800
Received: from intmgw003.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 16:48:01 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DC8C72943AB4; Fri, 13 Dec 2019 16:48:00 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 10/13] bpf: Synch uapi bpf.h to tools/
Date:   Fri, 13 Dec 2019 16:48:00 -0800
Message-ID: <20191214004800.1653481-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=863
 suspectscore=13 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sync uapi bpf.h to tools/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/include/uapi/linux/bpf.h | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b02970..cf864a5f7d61 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -136,6 +136,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
 	BPF_MAP_TYPE_DEVMAP_HASH,
+	BPF_MAP_TYPE_STRUCT_OPS,
 };
 
 /* Note that tracing related programs such as
@@ -174,6 +175,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 	BPF_PROG_TYPE_TRACING,
+	BPF_PROG_TYPE_STRUCT_OPS,
 };
 
 enum bpf_attach_type {
@@ -391,6 +393,10 @@ union bpf_attr {
 		__u32	btf_fd;		/* fd pointing to a BTF type data */
 		__u32	btf_key_type_id;	/* BTF type_id of the key */
 		__u32	btf_value_type_id;	/* BTF type_id of the value */
+		__u32	btf_vmlinux_value_type_id;/* BTF type_id of a kernel-
+						   * struct stored as the
+						   * map value
+						   */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
@@ -2821,6 +2827,24 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ *
+ * int bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
+ *	Description
+ *		Send out a tcp-ack. *tp* is the in-kernel struct tcp_sock.
+ *		*rcv_nxt* is the ack_seq to be sent out.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_jiffies(u64 in, u64 flags)
+ *	Description
+ *		jiffies helper.
+ *	Return
+ *		*flags*: 0, return the current jiffies.
+ *			 BPF_F_NS_TO_JIFFIES, convert *in* from ns to jiffies.
+ *			 BPF_F_JIFFIES_TO_NS, convert *in* from jiffies to
+ *			 ns.  If *in* is zero, it returns the current
+ *			 jiffies as ns.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2938,7 +2962,9 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(tcp_send_ack),		\
+	FN(jiffies),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3017,6 +3043,9 @@ enum bpf_func_id {
 /* BPF_FUNC_sk_storage_get flags */
 #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
 
+#define BPF_F_NS_TO_JIFFIES		(1ULL << 0)
+#define BPF_F_JIFFIES_TO_NS		(1ULL << 1)
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
@@ -3339,7 +3368,7 @@ struct bpf_map_info {
 	__u32 map_flags;
 	char  name[BPF_OBJ_NAME_LEN];
 	__u32 ifindex;
-	__u32 :32;
+	__u32 btf_vmlinux_value_type_id;
 	__u64 netns_dev;
 	__u64 netns_ino;
 	__u32 btf_id;
-- 
2.17.1

