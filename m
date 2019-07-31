Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147827B7AC
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfGaBij convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jul 2019 21:38:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726766AbfGaBii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:38:38 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V1WEtw000878
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:38:37 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u2uy0s36w-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:38:37 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 30 Jul 2019 18:38:30 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id B7640760C3C; Tue, 30 Jul 2019 18:38:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/2] bpf: fix bug in x64 JIT
Date:   Tue, 30 Jul 2019 18:38:25 -0700
Message-ID: <20190731013827.2445262-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=416 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bug in computation of the jump offset to 1st instruction in BPF JIT
and add 2 tests.

Alexei Starovoitov (2):
  bpf: fix x64 JIT code generation for jmp to 1st insn
  selftests/bpf: tests for jmp to 1st insn

 arch/x86/net/bpf_jit_comp.c                   |  7 +++--
 tools/testing/selftests/bpf/verifier/loops1.c | 28 +++++++++++++++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

-- 
2.20.0

