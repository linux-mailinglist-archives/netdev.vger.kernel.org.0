Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 261549A73C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392015AbfHWFwU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Aug 2019 01:52:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391856AbfHWFwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 01:52:20 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7N5phHl025530
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:18 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2uj4jqh344-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 22:52:18 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 22 Aug 2019 22:52:17 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id C6F09760BEC; Thu, 22 Aug 2019 22:52:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] bpf: precision tracking tests
Date:   Thu, 22 Aug 2019 22:52:11 -0700
Message-ID: <20190823055215.2658669-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=549 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add few additional tests for precision tracking in the verifier.

Alexei Starovoitov (4):
  bpf: introduce verifier internal test flag
  tools/bpf: sync bpf.h
  selftests/bpf: verifier precise tests
  selftests/bpf: add precision tracking test

 include/linux/bpf_verifier.h                  |   1 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/syscall.c                          |   1 +
 kernel/bpf/verifier.c                         |   5 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/testing/selftests/bpf/test_verifier.c   |  68 +++++++--
 .../testing/selftests/bpf/verifier/precise.c  | 142 ++++++++++++++++++
 7 files changed, 211 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/precise.c

-- 
2.20.0

