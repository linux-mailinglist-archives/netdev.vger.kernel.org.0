Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0931FAC97D
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395268AbfIGVne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:43:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfIGVne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:43:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LcXAT183926;
        Sat, 7 Sep 2019 21:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=y5K1Htx/HZJSX2WyZpt6HBKBqeq94HX2NyaJiR8+ThM=;
 b=anV2z0dUgXdln/NAjts1P1LtBtUKI12/kVRSuSVZ3RfAWlZ7ugcXYQtmFsaviST+1Bz9
 sHto+CKFOyniOD/tv7SeuWvBjw4kAg4crc6GO5ZGkhoNoVpXzmQ6atMNtklAjkWRVEvJ
 5otCzyKhqYW0rrktkq/bzPXmeRlJpK8NhTG8oeJgbqSbp0oR7asNvibwy6iJhnUmn68M
 /yInuLqXnSVRXBdgyXqRxbGCIc83W/YXHL66/Yjf7rn1o/N0sUPN/RJPgk6RYmw9A4+d
 iv2mFaAz82UCNAS+ZPEW6LQQwKRfXABEeV3MjrdOBnqQWmwFqdg+LJYOk8Eq3Tjngfme uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uvmef011e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Lbu9J132928;
        Sat, 7 Sep 2019 21:42:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uv2kxje86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:13 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87LgBqX006371;
        Sat, 7 Sep 2019 21:42:11 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:42:11 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 3/7] bpf: sync tools/include/uapi/linux/bpf.h for pcap support
Date:   Sat,  7 Sep 2019 22:40:40 +0100
Message-Id: <1567892444-16344-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sync bpf.h updates for bpf_pcap helper and associated definitions

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/include/uapi/linux/bpf.h | 92 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be9..13f86d3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2750,6 +2750,54 @@ struct bpf_stack_build_id {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_pcap(void *data, u32 size, struct bpf_map *map, int protocol,
+ *		u64 flags)
+ *	Description
+ *		Write packet data from *data* into a special BPF perf event
+ *              held by *map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This
+ *		perf event has the same attributes as perf events generated
+ *		by bpf_perf_event_output.  For skb and xdp programs, *data*
+ *		is the relevant context, while for tracing programs,
+ *		*data* must be a pointer to a **struct sk_buff** derived
+ *		from kprobe or tracepoint arguments.
+ *
+ *		Metadata for this event is a **struct bpf_pcap_hdr**; this
+ *		contains the capture length, actual packet length and
+ *		the starting protocol.
+ *
+ *		The max number of bytes of context to store is specified via
+ *		*size*.
+ *
+ *		The flags value can be used to specify an id value of up
+ *		to 48 bits; the id can be used to correlate captured packets
+ *		with other trace data, since the passed-in flags value is stored
+ *		stored in the **struct bpf_pcap_hdr** in the **flags** field.
+ *		Specifying **BPF_F_PCAP_ID_IIFINDEX** and a non-zero value in
+ *		the id portion of the flags limits capture events to skbs
+ *		with the specified incoming ifindex, allowing limiting of
+ *		tracing to the the associated interface.  Specifying
+ *		**BPF_F_PCAP_STRICT_TYPE** will cause *bpf_pcap* to return
+ *		-EPROTO and skip capture if a specific protocol is specified
+ *		and it does not match the current skb.  These additional flags
+ *		are only valid (and useful) for tracing programs.
+ *
+ *		The *protocol* value specifies the protocol type of the start
+ *		of the packet so that packet capture can carry out
+ *		interpretation.  See **pcap-linktype** (7) for details on
+ *		the supported values.
+ *
+ *	Return
+ *		0 on success, or a negative error in case of failure.
+ *		-ENOENT will be returned if the associated perf event
+ *		map entry is empty, the skb is zero-length,  or the incoming
+ *		ifindex was specified and we failed to match.
+ *		-EPROTO will be returned if **BPF_PCAP_TYPE_UNSET** is specified
+ *		and no protocol can be determined, or if we specify a protocol
+ *		along with **BPF_F_PCAP_STRICT_TYPE** and the skb protocol does
+ *		not match.
+ *		-EINVAL will be returned if the flags value is invalid.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2862,7 +2910,8 @@ struct bpf_stack_build_id {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(pcap),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -2941,6 +2990,11 @@ enum bpf_func_id {
 /* BPF_FUNC_sk_storage_get flags */
 #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
 
+/* BPF_FUNC_pcap flags */
+#define	BPF_F_PCAP_ID_MASK		0xffffffffffff
+#define BPF_F_PCAP_ID_IIFINDEX		(1ULL << 48)
+#define BPF_F_PCAP_STRICT_TYPE         (1ULL << 56)
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
@@ -3613,4 +3667,40 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+/* bpf_pcap_hdr contains information related to a particular packet capture
+ * flow.  It specifies
+ *
+ * - a magic number BPF_PCAP_MAGIC which identifies the perf event as
+ *   a pcap-related event.
+ * - a starting protocol is the protocol associated with the header
+ * - a flags value, copied from the flags value passed into bpf_pcap().
+ *   IDs can be used to correlate packet capture data and other tracing data.
+ *
+ * bpf_pcap_hdr also contains the information relating to the to-be-captured
+ * packet, and closely corresponds to the struct pcap_pkthdr used by
+ * pcap_dump (3PCAP).  The bpf_pcap helper sets ktime_ns (nanoseconds since
+ * boot) to the ktime_ns value; to get sensible pcap times this value should
+ * be converted to a struct timeval time since epoch in the struct pcap_pkthdr.
+ *
+ * When bpf_pcap() is used, a "struct bpf_pcap_hdr" is stored as we
+ * need both information about the particular packet and the protocol
+ * we are capturing.
+ */
+
+#define BPF_PCAP_MAGIC		0xb7fca7
+
+struct bpf_pcap_hdr {
+	__u32			magic;
+	int			protocol;
+	__u64			flags;
+	__u64			ktime_ns;
+	__u32			tot_len;
+	__u32			cap_len;
+	__u8			data[0];
+};
+
+#define BPF_PCAP_TYPE_UNSET	-1
+#define BPF_PCAP_TYPE_ETH	1
+#define	BPF_PCAP_TYPE_IP	12
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
1.8.3.1

