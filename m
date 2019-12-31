Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485B512D694
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 07:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLaGVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 01:21:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16146 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725497AbfLaGVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 01:21:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBV6G5ZT017302
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 22:21:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=9ZmtUZE0KCjT48/efHjhXGhS2xo6nY/ckyGFV+ODGE0=;
 b=m2ildN/cWLxFOYPgoUJNRm82ObYknmImxXH4R4Tp/nQqdYcw6LncdcsznM5lUWdVRzKC
 V7fxfgt9XmlyzEKWMb3pjzEASu45fKi8KW2V79IT/SVCDjBts8xsTOE8p5ZgB8XAarb+
 lsPfvaffYvWr/U72qE6YlC5S/EAIbcslEjw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2x63e5hrgj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 22:21:31 -0800
Received: from intmgw001.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 30 Dec 2019 22:20:59 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 95654294410B; Mon, 30 Dec 2019 22:20:57 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 09/11] bpf: Synch uapi bpf.h to tools/
Date:   Mon, 30 Dec 2019 22:20:57 -0800
Message-ID: <20191231062057.282327-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191231062037.280596-1-kafai@fb.com>
References: <20191231062037.280596-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-30_08:2019-12-27,2019-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=13 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 mlxlogscore=968 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912310050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sync uapi bpf.h to tools/

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/include/uapi/linux/bpf.h | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7df436da542d..2d6a2e572f56 100644
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
@@ -397,6 +399,10 @@ union bpf_attr {
 		__u32	btf_fd;		/* fd pointing to a BTF type data */
 		__u32	btf_key_type_id;	/* BTF type_id of the key */
 		__u32	btf_value_type_id;	/* BTF type_id of the value */
+		__u32	btf_vmlinux_value_type_id;/* BTF type_id of a kernel-
+						   * struct stored as the
+						   * map value
+						   */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
@@ -2831,6 +2837,14 @@ union bpf_attr {
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
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2948,7 +2962,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(tcp_send_ack),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3349,7 +3364,7 @@ struct bpf_map_info {
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

