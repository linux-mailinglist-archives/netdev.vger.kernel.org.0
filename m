Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A172D8178
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 23:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404842AbgLKWAV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Dec 2020 17:00:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39988 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405003AbgLKV7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 16:59:19 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BBLiwcw018825
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 13:58:34 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35cacstfyv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 13:58:33 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 13:58:32 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8B7E92ECB252; Fri, 11 Dec 2020 13:58:27 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/2] libbpf: support modules in set_attach_target() API
Date:   Fri, 11 Dec 2020 13:58:23 -0800
Message-ID: <20201211215825.3646154-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_09:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015 mlxlogscore=562
 priorityscore=1501 suspectscore=8 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for finding BTF-based kernel attach targets (fentry/fexit
functions, tp_btf tracepoints, etc) with programmatic
bpf_program__set_attach_target() API. It is now as capable as libbpf's
SEC()-based logic.

Andrii Nakryiko (2):
  libbpf: support modules in bpf_program__set_attach_target() API
  selftests/bpf: add set_attach_target() API selftest for module target

 tools/lib/bpf/libbpf.c                        | 64 ++++++++++++-------
 .../selftests/bpf/prog_tests/module_attach.c  | 11 +++-
 .../selftests/bpf/progs/test_module_attach.c  | 11 ++++
 3 files changed, 61 insertions(+), 25 deletions(-)

-- 
2.24.1

