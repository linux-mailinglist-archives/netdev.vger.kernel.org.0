Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6533265908
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfGKOab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:30:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728998AbfGKOaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 10:30:30 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BESvjK135145
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:30:29 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tp5p9uqn8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 10:30:29 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 11 Jul 2019 15:30:27 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 15:30:24 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BEUNnj57999478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:30:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CF8D42047;
        Thu, 11 Jul 2019 14:30:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E722B4204F;
        Thu, 11 Jul 2019 14:30:22 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 14:30:22 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ys114321@gmail.com, daniel@iogearbox.net, sdf@fomichev.me,
        davem@davemloft.net, ast@kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 bpf-next 2/4] selftests/bpf: fix s930 -> s390 typo
Date:   Thu, 11 Jul 2019 16:29:28 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711142930.68809-1-iii@linux.ibm.com>
References: <20190711142930.68809-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071114-0008-0000-0000-000002FC7505
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071114-0009-0000-0000-00002269DD9D
Message-Id: <20190711142930.68809-3-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=732 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110163
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

