Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FE133E75E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCQDDv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 23:03:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10316 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229708AbhCQDDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:03:19 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12H30Jse013696
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:03:19 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37awqb44hr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:03:19 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 20:03:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3A29B2ED23D6; Tue, 16 Mar 2021 20:03:16 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/4] Generate NULL in vmlinux.h
Date:   Tue, 16 Mar 2021 20:03:08 -0700
Message-ID: <20210317030312.802233-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_09:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=470 impostorscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generate NULL definition as part of vmlinux.h. This is a pretty common and
unfortunate annoyance that most users of vmlinux.h have to deal with. Patch #2
drops such custom NULL definition in one of the selftests. Patches #3 and #4
make bpftool and selftests compilations stricter by treating warnings as
errors.

Andrii Nakryiko (4):
  bpftool: generate NULL definition in vmlinux.h
  selftests/bpf: drop custom NULL #define in skb_pkt_end selftest
  selftests/bpf: treat compilation warnings as errors
  bpftool: treat compilation warnings as errors

 tools/bpf/bpftool/Makefile                      | 3 ++-
 tools/bpf/bpftool/btf.c                         | 2 ++
 tools/bpf/bpftool/jit_disasm.c                  | 3 +++
 tools/testing/selftests/bpf/Makefile            | 4 ++--
 tools/testing/selftests/bpf/progs/skb_pkt_end.c | 1 -
 5 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.30.2

