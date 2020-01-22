Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04131144BDD
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 07:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgAVGmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 01:42:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57970 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgAVGmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 01:42:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00M6e9eG015486
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 22:42:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=4PyWDKYpsa2cjVMpH3P7OQvk3szcUPYHBiTfB+7LxcE=;
 b=g0LR3qBIjPY0LhY0coTJmpwZBXT8PvYNkOBRgNq4/X93AoBQuZfeYS5YumJ7tB6862/Z
 l6l0WeF6D9epbzqnL+nI7W9IdVnTaGFxEmOrSSOKhuqjBjQv389DBEfPenFya4eWqqj5
 k+70TtUwyiAuBm1zLKvg4FRmcyuVgN2c9qw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xnr6hp19m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 22:42:09 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 22:42:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id BFBAC2944F3E; Tue, 21 Jan 2020 22:42:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] bpf: Sync uapi bpf.h to tools/
Date:   Tue, 21 Jan 2020 22:42:04 -0800
Message-ID: <20200122064204.1834348-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122064152.1833564-1-kafai@fb.com>
References: <20200122064152.1833564-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=822
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 impostorscore=0
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sync uapi bpf.h to tools/.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/include/uapi/linux/bpf.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 033d90a2282d..d17c6bcd50cd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2885,6 +2885,12 @@ union bpf_attr {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * u64 bpf_jiffies64(void)
+ *	Description
+ *		Obtain the 64bit jiffies
+ *	Return
+ *		The 64 bit jiffies
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3004,7 +3010,8 @@ union bpf_attr {
 	FN(probe_read_user_str),	\
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
-	FN(send_signal_thread),
+	FN(send_signal_thread),		\
+	FN(jiffies64),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

