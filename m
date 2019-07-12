Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2494670D5
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 16:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGLOAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 10:00:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727064AbfGLOAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 10:00:03 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CDw1Jm082142
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:00:02 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tpswbve5g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:00:02 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 12 Jul 2019 15:00:00 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 14:59:56 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CDxtSJ38207496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:59:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A4614C046;
        Fri, 12 Jul 2019 13:59:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2007A4C040;
        Fri, 12 Jul 2019 13:59:55 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.97.237])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 13:59:55 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf] selftests/bpf: put test_stub.o into $(OUTPUT)
Date:   Fri, 12 Jul 2019 15:59:50 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071213-0012-0000-0000-000003321DCD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071213-0013-0000-0000-0000216B8E68
Message-Id: <20190712135950.91600-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a rule to put test_stub.o in $(OUTPUT) and change the references to
it accordingly. This prevents test_stub.o from being created in the
source directory.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 277d8605e340..66b6f7fb683c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -83,13 +83,16 @@ all: $(TEST_CUSTOM_PROGS)
 $(OUTPUT)/urandom_read: $(OUTPUT)/%: %.c
 	$(CC) -o $@ $< -Wl,--build-id
 
+$(OUTPUT)/test_stub.o: test_stub.c
+	$(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) -c -o $@ $<
+
 $(OUTPUT)/test_maps: map_tests/*.c
 
 BPFOBJ := $(OUTPUT)/libbpf.a
 
-$(TEST_GEN_PROGS): test_stub.o $(BPFOBJ)
+$(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
-$(TEST_GEN_PROGS_EXTENDED): test_stub.o $(OUTPUT)/libbpf.a
+$(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(OUTPUT)/libbpf.a
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
 $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
-- 
2.21.0

