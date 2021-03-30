Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E399834E0C5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC3Fmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:42:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230244AbhC3FmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 01:42:07 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12U5dtUP025715
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:42:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CJav6Pp0P5FSyGphlsXNYzRLZlckHY3wdCi3broulig=;
 b=TwIBtBUo4v3fogY/LauSQGVSKH+zi0p2ATGB3QwKlqQVG3fM8QCdMvr17EIz+v5F9atl
 eFA04d77gq0y9tTskthIQFuHIdBZcFtk8VYuuCJCT6CZFvlrPHNO+dAjwYtVxrxW189j
 NP6TdAaxyPbonKBs636qjRbTKC541MBP2y4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37kuvm0h2m-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 22:42:06 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 22:42:05 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 57D2E2942D2F; Mon, 29 Mar 2021 22:41:56 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 2/2] bpf: selftests: Update clang requirement in README.rst for testing kfunc call
Date:   Mon, 29 Mar 2021 22:41:56 -0700
Message-ID: <20210330054156.2933804-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330054143.2932947-1-kafai@fb.com>
References: <20210330054143.2932947-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -vfc8UYt7WD-k0vxBtvP7eKCAG9zZRYL
X-Proofpoint-ORIG-GUID: -vfc8UYt7WD-k0vxBtvP7eKCAG9zZRYL
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_01:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the README.rst to specify the clang requirement
to compile the bpf selftests that call kernel function.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/README.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftes=
ts/bpf/README.rst
index 3464161c8eea..65fe318d1e71 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -179,3 +179,17 @@ types, which was introduced in `Clang 13`__. The older=
 Clang versions will
 either crash when compiling these tests, or generate an incorrect BTF.
=20
 __  https://reviews.llvm.org/D83289
+
+Kernel function call test and Clang version
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Some selftests (e.g. kfunc_call and bpf_tcp_ca) require a LLVM support
+to generate extern function in BTF.  It was introduced in `Clang 13`__.
+
+Without it, the error from compiling bpf selftests looks like:
+
+.. code-block:: console
+
+  libbpf: failed to find BTF for extern 'tcp_slow_start' [25] section: -2
+
+__ https://reviews.llvm.org/D93563
--=20
2.30.2

