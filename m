Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4F23486AE
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239802AbhCYBxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:53:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4028 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235981AbhCYBws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1nmR4002852
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Ekz2xQpl6hvRIpFqiImrMaWq7vxuOqL1U+6rhOy6VG4=;
 b=FbfMyK57qkBDcEr80RQcpPwDfdjOYqOMidtALSKXUgVmd9k72srIMOAWjez3cC7jAQi3
 BwtMSr4rYbqsNM1kfsxDuaO3JlDrasqkIvA5ZCPQgt7eW/g5SyGDW/nPKpw5NFXJTW6b
 msISBqIUWv9jHDb4dn6yBmX3TkhMtLKX6hY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37fnsxh6bs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:48 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:47 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5129229429D7; Wed, 24 Mar 2021 18:52:40 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf-next 12/14] bpf: selftests: Rename bictcp to bpf_cubic
Date:   Wed, 24 Mar 2021 18:52:40 -0700
Message-ID: <20210325015240.1550074-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=768 bulkscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a similar chanage in the kernel, this patch gives the proper
name to the bpf cubic.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_cubic.c b/tools/testin=
g/selftests/bpf/progs/bpf_cubic.c
index 6939bfd8690f..33c4d2bded64 100644
--- a/tools/testing/selftests/bpf/progs/bpf_cubic.c
+++ b/tools/testing/selftests/bpf/progs/bpf_cubic.c
@@ -174,8 +174,8 @@ static __always_inline void bictcp_hystart_reset(stru=
ct sock *sk)
  * as long as it is used in one of the func ptr
  * under SEC(".struct_ops").
  */
-SEC("struct_ops/bictcp_init")
-void BPF_PROG(bictcp_init, struct sock *sk)
+SEC("struct_ops/bpf_cubic_init")
+void BPF_PROG(bpf_cubic_init, struct sock *sk)
 {
 	struct bictcp *ca =3D inet_csk_ca(sk);
=20
@@ -192,7 +192,7 @@ void BPF_PROG(bictcp_init, struct sock *sk)
  * The remaining tcp-cubic functions have an easier way.
  */
 SEC("no-sec-prefix-bictcp_cwnd_event")
-void BPF_PROG(bictcp_cwnd_event, struct sock *sk, enum tcp_ca_event even=
t)
+void BPF_PROG(bpf_cubic_cwnd_event, struct sock *sk, enum tcp_ca_event e=
vent)
 {
 	if (event =3D=3D CA_EVENT_TX_START) {
 		struct bictcp *ca =3D inet_csk_ca(sk);
@@ -384,7 +384,7 @@ static __always_inline void bictcp_update(struct bict=
cp *ca, __u32 cwnd,
 }
=20
 /* Or simply use the BPF_STRUCT_OPS to avoid the SEC boiler plate. */
-void BPF_STRUCT_OPS(bictcp_cong_avoid, struct sock *sk, __u32 ack, __u32=
 acked)
+void BPF_STRUCT_OPS(bpf_cubic_cong_avoid, struct sock *sk, __u32 ack, __=
u32 acked)
 {
 	struct tcp_sock *tp =3D tcp_sk(sk);
 	struct bictcp *ca =3D inet_csk_ca(sk);
@@ -403,7 +403,7 @@ void BPF_STRUCT_OPS(bictcp_cong_avoid, struct sock *s=
k, __u32 ack, __u32 acked)
 	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
=20
-__u32 BPF_STRUCT_OPS(bictcp_recalc_ssthresh, struct sock *sk)
+__u32 BPF_STRUCT_OPS(bpf_cubic_recalc_ssthresh, struct sock *sk)
 {
 	const struct tcp_sock *tp =3D tcp_sk(sk);
 	struct bictcp *ca =3D inet_csk_ca(sk);
@@ -420,7 +420,7 @@ __u32 BPF_STRUCT_OPS(bictcp_recalc_ssthresh, struct s=
ock *sk)
 	return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
 }
=20
-void BPF_STRUCT_OPS(bictcp_state, struct sock *sk, __u8 new_state)
+void BPF_STRUCT_OPS(bpf_cubic_state, struct sock *sk, __u8 new_state)
 {
 	if (new_state =3D=3D TCP_CA_Loss) {
 		bictcp_reset(inet_csk_ca(sk));
@@ -496,7 +496,7 @@ static __always_inline void hystart_update(struct soc=
k *sk, __u32 delay)
 	}
 }
=20
-void BPF_STRUCT_OPS(bictcp_acked, struct sock *sk,
+void BPF_STRUCT_OPS(bpf_cubic_acked, struct sock *sk,
 		    const struct ack_sample *sample)
 {
 	const struct tcp_sock *tp =3D tcp_sk(sk);
@@ -525,7 +525,7 @@ void BPF_STRUCT_OPS(bictcp_acked, struct sock *sk,
 		hystart_update(sk, delay);
 }
=20
-__u32 BPF_STRUCT_OPS(tcp_reno_undo_cwnd, struct sock *sk)
+__u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
 {
 	const struct tcp_sock *tp =3D tcp_sk(sk);
=20
@@ -534,12 +534,12 @@ __u32 BPF_STRUCT_OPS(tcp_reno_undo_cwnd, struct soc=
k *sk)
=20
 SEC(".struct_ops")
 struct tcp_congestion_ops cubic =3D {
-	.init		=3D (void *)bictcp_init,
-	.ssthresh	=3D (void *)bictcp_recalc_ssthresh,
-	.cong_avoid	=3D (void *)bictcp_cong_avoid,
-	.set_state	=3D (void *)bictcp_state,
-	.undo_cwnd	=3D (void *)tcp_reno_undo_cwnd,
-	.cwnd_event	=3D (void *)bictcp_cwnd_event,
-	.pkts_acked     =3D (void *)bictcp_acked,
+	.init		=3D (void *)bpf_cubic_init,
+	.ssthresh	=3D (void *)bpf_cubic_recalc_ssthresh,
+	.cong_avoid	=3D (void *)bpf_cubic_cong_avoid,
+	.set_state	=3D (void *)bpf_cubic_state,
+	.undo_cwnd	=3D (void *)bpf_cubic_undo_cwnd,
+	.cwnd_event	=3D (void *)bpf_cubic_cwnd_event,
+	.pkts_acked     =3D (void *)bpf_cubic_acked,
 	.name		=3D "bpf_cubic",
 };
--=20
2.30.2

