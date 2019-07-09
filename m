Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F0E63878
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGIPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:18:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726229AbfGIPSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:18:45 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69FDdp0071105
        for <netdev@vger.kernel.org>; Tue, 9 Jul 2019 11:18:44 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tmw60h3ss-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:18:43 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 9 Jul 2019 16:18:41 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 16:18:37 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69FIaIL52625636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 15:18:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C26DB4205E;
        Tue,  9 Jul 2019 15:18:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E42F4204F;
        Tue,  9 Jul 2019 15:18:36 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.145.146.163])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 15:18:36 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     sdf@fomichev.me, ys114321@gmail.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 bpf-next 2/4] selftests/bpf: fix s930 -> s390 typo
Date:   Tue,  9 Jul 2019 17:18:07 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709151809.37539-1-iii@linux.ibm.com>
References: <20190709151809.37539-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070915-4275-0000-0000-0000034B1344
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070915-4276-0000-0000-0000385B1434
Message-Id: <20190709151809.37539-3-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=730 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also check for __s390__ instead of __s390x__, just in case bpf_helpers.h
is ever used by 32-bit userspace.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 5a3d92c8bec8..73071a94769a 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -315,8 +315,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #if defined(__TARGET_ARCH_x86)
 	#define bpf_target_x86
 	#define bpf_target_defined
-#elif defined(__TARGET_ARCH_s930x)
-	#define bpf_target_s930x
+#elif defined(__TARGET_ARCH_s390)
+	#define bpf_target_s390
 	#define bpf_target_defined
 #elif defined(__TARGET_ARCH_arm)
 	#define bpf_target_arm
@@ -341,8 +341,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #ifndef bpf_target_defined
 #if defined(__x86_64__)
 	#define bpf_target_x86
-#elif defined(__s390x__)
-	#define bpf_target_s930x
+#elif defined(__s390__)
+	#define bpf_target_s390
 #elif defined(__arm__)
 	#define bpf_target_arm
 #elif defined(__aarch64__)
@@ -369,7 +369,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
 #define PT_REGS_SP(x) ((x)->sp)
 #define PT_REGS_IP(x) ((x)->ip)
 
-#elif defined(bpf_target_s390x)
+#elif defined(bpf_target_s390)
 
 #define PT_REGS_PARM1(x) ((x)->gprs[2])
 #define PT_REGS_PARM2(x) ((x)->gprs[3])
-- 
2.21.0

