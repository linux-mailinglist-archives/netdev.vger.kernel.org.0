Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0813ECC8AA
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 09:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfJEH7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 03:59:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbfJEH7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 03:59:49 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x957xkVv025165
        for <netdev@vger.kernel.org>; Sat, 5 Oct 2019 00:59:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=mXZaDbpWnMwPftxowO69SVcC0IStzLOuYnUNof4o4uc=;
 b=G6Heetz1WL2vKajlj8XI6cwKV3CY7Zk8D5jd3LLTfi2KQnQyloQdztGvApjn3lgzqhjB
 2qNFXaCFLaUklT26Rg1n8rS66FgT1th1klSVMU0/N14t0HG2Y8fY+fqcFukGeAI9AY18
 jMxK6wp8s5tNSf32mKynEX3phrgHvfGdv8M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vepp1g34g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 00:59:46 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 5 Oct 2019 00:59:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id ED0A286182A; Sat,  5 Oct 2019 00:59:33 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/3] uapi/bpf: fix helper docs
Date:   Sat, 5 Oct 2019 00:59:19 -0700
Message-ID: <20191005075921.3310139-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191005075921.3310139-1-andriin@fb.com>
References: <20191005075921.3310139-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_04:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 suspectscore=8 bulkscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050077
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various small fixes to BPF helper documentation comments, enabling
automatic header generation with a list of BPF helpers.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h       | 32 ++++++++++++++++----------------
 tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++----------------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77c6be96d676..a65c3b0c6935 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -794,7 +794,7 @@ union bpf_attr {
  * 		A 64-bit integer containing the current GID and UID, and
  * 		created as such: *current_gid* **<< 32 \|** *current_uid*.
  *
- * int bpf_get_current_comm(char *buf, u32 size_of_buf)
+ * int bpf_get_current_comm(void *buf, u32 size_of_buf)
  * 	Description
  * 		Copy the **comm** attribute of the current task into *buf* of
  * 		*size_of_buf*. The **comm** attribute contains the name of
@@ -1023,7 +1023,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * int bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1068,7 +1068,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
+ * int bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 len)
  * 	Description
  * 		This helper was provided as an easy way to load data from a
  * 		packet. It can be used to load *len* bytes from *offset* from
@@ -1085,7 +1085,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
+ * int bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1154,7 +1154,7 @@ union bpf_attr {
  * 		The checksum result, or a negative error code in case of
  * 		failure.
  *
- * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
+ * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Retrieve tunnel options metadata for the packet associated to
  * 		*skb*, and store the raw tunnel option data to the buffer *opt*
@@ -1172,7 +1172,7 @@ union bpf_attr {
  * 	Return
  * 		The size of the option data retrieved.
  *
- * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
+ * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Set tunnel options metadata for the packet associated to *skb*
  * 		to the option data contained in the raw buffer *opt* of *size*.
@@ -1511,7 +1511,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, char *optval, int optlen)
+ * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **setsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1595,7 +1595,7 @@ union bpf_attr {
  * 	Return
  * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
  *
- * int bpf_sk_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * int bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u32 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the socket referenced by *map* (of type
  * 		**BPF_MAP_TYPE_SOCKMAP**) at index *key*. Both ingress and
@@ -1715,7 +1715,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, char *optval, int optlen)
+ * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1947,7 +1947,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stack(struct pt_regs *regs, void *buf, u32 size, u64 flags)
+ * int bpf_get_stack(void *ctx, void *buf, u32 size, u64 flags)
  * 	Description
  * 		Return a user or a kernel stack in bpf program provided buffer.
  * 		To achieve this, the helper needs *ctx*, which is a pointer
@@ -1980,7 +1980,7 @@ union bpf_attr {
  * 		A non-negative value equal to or less than *size* on success,
  * 		or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes_relative(const struct sk_buff *skb, u32 offset, void *to, u32 len, u32 start_header)
+ * int bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
  * 	Description
  * 		This helper is similar to **bpf_skb_load_bytes**\ () in that
  * 		it provides an easy way to load *len* bytes from *offset*
@@ -2033,7 +2033,7 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
- * int bpf_sock_hash_update(struct bpf_sock_ops_kern *skops, struct bpf_map *map, void *key, u64 flags)
+ * int bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
  *		The *skops* is used as a new value for the entry associated to
@@ -2392,7 +2392,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_push_data(struct sk_buff *skb, u32 start, u32 len, u64 flags)
+ * int bpf_msg_push_data(struct sk_msg_buff *msg, u32 start, u32 len, u64 flags)
  *	Description
  *		For socket policies, insert *len* bytes into *msg* at offset
  *		*start*.
@@ -2408,9 +2408,9 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 pop, u64 flags)
+ * int bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 len, u64 flags)
  *	Description
- *		Will remove *pop* bytes from a *msg* starting at byte *start*.
+ *		Will remove *len* bytes from a *msg* starting at byte *start*.
  *		This may result in **ENOMEM** errors under certain situations if
  *		an allocation and copy are required due to a full ring buffer.
  *		However, the helper will try to avoid doing the allocation
@@ -2505,7 +2505,7 @@ union bpf_attr {
  *		A **struct bpf_tcp_sock** pointer on success, or **NULL** in
  *		case of failure.
  *
- * int bpf_skb_ecn_set_ce(struct sk_buf *skb)
+ * int bpf_skb_ecn_set_ce(struct sk_buff *skb)
  *	Description
  *		Set ECN (Explicit Congestion Notification) field of IP header
  *		to **CE** (Congestion Encountered) if current value is **ECT**
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be96d676..a65c3b0c6935 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -794,7 +794,7 @@ union bpf_attr {
  * 		A 64-bit integer containing the current GID and UID, and
  * 		created as such: *current_gid* **<< 32 \|** *current_uid*.
  *
- * int bpf_get_current_comm(char *buf, u32 size_of_buf)
+ * int bpf_get_current_comm(void *buf, u32 size_of_buf)
  * 	Description
  * 		Copy the **comm** attribute of the current task into *buf* of
  * 		*size_of_buf*. The **comm** attribute contains the name of
@@ -1023,7 +1023,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * int bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1068,7 +1068,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
+ * int bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 len)
  * 	Description
  * 		This helper was provided as an easy way to load data from a
  * 		packet. It can be used to load *len* bytes from *offset* from
@@ -1085,7 +1085,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
+ * int bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1154,7 +1154,7 @@ union bpf_attr {
  * 		The checksum result, or a negative error code in case of
  * 		failure.
  *
- * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
+ * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Retrieve tunnel options metadata for the packet associated to
  * 		*skb*, and store the raw tunnel option data to the buffer *opt*
@@ -1172,7 +1172,7 @@ union bpf_attr {
  * 	Return
  * 		The size of the option data retrieved.
  *
- * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
+ * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Set tunnel options metadata for the packet associated to *skb*
  * 		to the option data contained in the raw buffer *opt* of *size*.
@@ -1511,7 +1511,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, char *optval, int optlen)
+ * int bpf_setsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **setsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1595,7 +1595,7 @@ union bpf_attr {
  * 	Return
  * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
  *
- * int bpf_sk_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * int bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u32 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the socket referenced by *map* (of type
  * 		**BPF_MAP_TYPE_SOCKMAP**) at index *key*. Both ingress and
@@ -1715,7 +1715,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, char *optval, int optlen)
+ * int bpf_getsockopt(struct bpf_sock_ops *bpf_socket, int level, int optname, void *optval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1947,7 +1947,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stack(struct pt_regs *regs, void *buf, u32 size, u64 flags)
+ * int bpf_get_stack(void *ctx, void *buf, u32 size, u64 flags)
  * 	Description
  * 		Return a user or a kernel stack in bpf program provided buffer.
  * 		To achieve this, the helper needs *ctx*, which is a pointer
@@ -1980,7 +1980,7 @@ union bpf_attr {
  * 		A non-negative value equal to or less than *size* on success,
  * 		or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes_relative(const struct sk_buff *skb, u32 offset, void *to, u32 len, u32 start_header)
+ * int bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
  * 	Description
  * 		This helper is similar to **bpf_skb_load_bytes**\ () in that
  * 		it provides an easy way to load *len* bytes from *offset*
@@ -2033,7 +2033,7 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
- * int bpf_sock_hash_update(struct bpf_sock_ops_kern *skops, struct bpf_map *map, void *key, u64 flags)
+ * int bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
  *		The *skops* is used as a new value for the entry associated to
@@ -2392,7 +2392,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_push_data(struct sk_buff *skb, u32 start, u32 len, u64 flags)
+ * int bpf_msg_push_data(struct sk_msg_buff *msg, u32 start, u32 len, u64 flags)
  *	Description
  *		For socket policies, insert *len* bytes into *msg* at offset
  *		*start*.
@@ -2408,9 +2408,9 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 pop, u64 flags)
+ * int bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 len, u64 flags)
  *	Description
- *		Will remove *pop* bytes from a *msg* starting at byte *start*.
+ *		Will remove *len* bytes from a *msg* starting at byte *start*.
  *		This may result in **ENOMEM** errors under certain situations if
  *		an allocation and copy are required due to a full ring buffer.
  *		However, the helper will try to avoid doing the allocation
@@ -2505,7 +2505,7 @@ union bpf_attr {
  *		A **struct bpf_tcp_sock** pointer on success, or **NULL** in
  *		case of failure.
  *
- * int bpf_skb_ecn_set_ce(struct sk_buf *skb)
+ * int bpf_skb_ecn_set_ce(struct sk_buff *skb)
  *	Description
  *		Set ECN (Explicit Congestion Notification) field of IP header
  *		to **CE** (Congestion Encountered) if current value is **ECT**
-- 
2.17.1

