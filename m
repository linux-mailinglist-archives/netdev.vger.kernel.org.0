Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4C6B8F8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfGQJKI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jul 2019 05:10:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfGQJKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 05:10:08 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6H982Wn014794
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 05:10:07 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tswnx8n28-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 05:10:06 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 17 Jul 2019 10:10:04 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 10:10:02 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6H9A1Y039059480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 09:10:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9643611C066;
        Wed, 17 Jul 2019 09:10:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DB3C11C052;
        Wed, 17 Jul 2019 09:10:01 +0000 (GMT)
Received: from dyn-9-152-96-15.boeblingen.de.ibm.com (unknown [9.152.96.15])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 09:10:01 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf] selftests/bpf: make directory prerequisites
 order-only
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <CAADnVQKzZQ_mbaMHEU6HA-JEy=1jXvBWULg8yKQY_2zwSmU86g@mail.gmail.com>
Date:   Wed, 17 Jul 2019 11:10:01 +0200
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Transfer-Encoding: 8BIT
References: <20190712135631.91398-1-iii@linux.ibm.com>
 <a3823fec-3816-9c38-bb2d-a8391766e64d@iogearbox.net>
 <CAADnVQKzZQ_mbaMHEU6HA-JEy=1jXvBWULg8yKQY_2zwSmU86g@mail.gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19071709-0008-0000-0000-000002FE4348
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071709-0009-0000-0000-0000226BBD1F
Message-Id: <FEFC7321-F112-4194-AF5E-0C237F351A04@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 16.07.2019 um 19:49 schrieb Alexei Starovoitov <alexei.starovoitov@gmail.com>:
> 
> On Mon, Jul 15, 2019 at 3:22 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> 
>> On 7/12/19 3:56 PM, Ilya Leoshkevich wrote:
>>> When directories are used as prerequisites in Makefiles, they can cause
>>> a lot of unnecessary rebuilds, because a directory is considered changed
>>> whenever a file in this directory is added, removed or modified.
>>> 
>>> If the only thing a target is interested in is the existence of the
>>> directory it depends on, which is the case for selftests/bpf, this
>>> directory should be specified as an order-only prerequisite: it would
>>> still be created in case it does not exist, but it would not trigger a
>>> rebuild of a target in case it's considered changed.
>>> 
>>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> 
>> Applied, thanks!
> 
> Hi Ilya,
> 
> this commit breaks map_tests.
> To reproduce:
> rm map_tests/tests.h
> make
> tests.h will not be regenerated.
> Please provide a fix asap.
> We cannot ship bpf tree with such failure.

Hi Alexei,

Sorry about this! I actually had the following in my local tree:

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f1f2b82b8fb8..95795cf5805c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -231,7 +231,7 @@ ifeq ($(DWARF2BTF),y)
 endif

 PROG_TESTS_H := $(OUTPUT)/prog_tests/tests.h
-test_progs.c: $(PROG_TESTS_H)
+$(OUTPUT)/test_progs: $(PROG_TESTS_H)
 $(OUTPUT)/test_progs: CFLAGS += $(TEST_PROGS_CFLAGS)
 $(OUTPUT)/test_progs: prog_tests/*.c

@@ -258,7 +258,7 @@ MAP_TESTS_DIR = $(OUTPUT)/map_tests
 $(MAP_TESTS_DIR):
 <------>mkdir -p $@
 MAP_TESTS_H := $(MAP_TESTS_DIR)/tests.h
-test_maps.c: $(MAP_TESTS_H)
+$(OUTPUT)/test_maps: $(MAP_TESTS_H)
 $(OUTPUT)/test_maps: CFLAGS += $(TEST_MAPS_CFLAGS)
 MAP_TESTS_FILES := $(wildcard map_tests/*.c)
 $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
@@ -275,7 +275,7 @@ $(MAP_TESTS_H): $(MAP_TESTS_FILES) | $(MAP_TESTS_DIR)
 <------><------> ) > $(MAP_TESTS_H))

 VERIFIER_TESTS_H := $(OUTPUT)/verifier/tests.h
-test_verifier.c: $(VERIFIER_TESTS_H)
+$(OUTPUT)/test_verifier: $(VERIFIER_TESTS_H)
 $(OUTPUT)/test_verifier: CFLAGS += $(TEST_VERIFIER_CFLAGS)

 VERIFIER_TESTS_DIR = $(OUTPUT)/verifier

but did not realise that this is a pre-requisite for my directories change.
I should have tested it separately, then I would have noticed.

Andrii,
Thanks for helping out and providing the fix!

Best regards,
Ilya
