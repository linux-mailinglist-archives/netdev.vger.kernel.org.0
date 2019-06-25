Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6AA55C42
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFYX0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:26:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfFYX0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:26:08 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PNOhG5006000
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:26:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=87WU98tvN71fAkWZor9BJ45CxRmA6011j1Vb36IfTCA=;
 b=H4xAn47wMG5APPHTVQzL8fstpNwsUStLgCLbrbsKaimnyDDC+bqMDFWYD/zyFUHccCKL
 6V27qkCU7a93vfDqR/n7RvAEiVlhbT0LMpDErlEk0YrNpLIB8uUnlvou+n+DNzmyB5R6
 61q0Hj3OQD0F+UGQtPFYrfNe5sOxpzVHySQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbnnb1xv5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:26:07 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 16:26:06 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 49633861829; Tue, 25 Jun 2019 16:26:04 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/2] libbpf: add perf buffer API
Date:   Tue, 25 Jun 2019 16:25:59 -0700
Message-ID: <20190625232601.3227055-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=834 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a high-level API for setting up and polling perf buffers
associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
described in corresponding commit.

Andrii Nakryiko (2):
  libbpf: add perf buffer reading API
  selftests/bpf: test perf buffer API

 tools/lib/bpf/libbpf.c                        | 282 ++++++++++++++++++
 tools/lib/bpf/libbpf.h                        |  12 +
 tools/lib/bpf/libbpf.map                      |   5 +-
 .../selftests/bpf/prog_tests/perf_buffer.c    |  86 ++++++
 .../selftests/bpf/progs/test_perf_buffer.c    |  31 ++
 5 files changed, 415 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c

-- 
2.17.1

