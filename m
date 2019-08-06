Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17E58298A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbfHFCRs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Aug 2019 22:17:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40408 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731148AbfHFCRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:17:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x762EeMM027684
        for <netdev@vger.kernel.org>; Mon, 5 Aug 2019 19:17:47 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u6xqg8a1q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 19:17:47 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 5 Aug 2019 19:17:45 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 5D49F7601A6; Mon,  5 Aug 2019 19:17:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] selftests/bpf: more loop tests
Date:   Mon, 5 Aug 2019 19:17:42 -0700
Message-ID: <20190806021744.2953168-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=591 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060025
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two bounded loop tests.

v1-v2: addressed feedback from Yonghong.

Alexei Starovoitov (2):
  selftests/bpf: add loop test 4
  selftests/bpf: add loop test 5

 .../bpf/prog_tests/bpf_verif_scale.c          |  2 ++
 tools/testing/selftests/bpf/progs/loop4.c     | 18 +++++++++++
 tools/testing/selftests/bpf/progs/loop5.c     | 32 +++++++++++++++++++
 3 files changed, 52 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/loop4.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop5.c

-- 
2.20.0

