Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78452C9398
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgLAAE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:04:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730986AbgLAAE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:04:28 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B101o80006920
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:03:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=w5sEoSNi/hOic74AF7SaCo6Z2BfWFRfKgWDRCUfDgzU=;
 b=RFdk9rzxagSnHbPh9q9KIyZCG+KnxDfML/jy4Mp1bnDXEGiEyzW0r3UgEpxSY03Y+5yF
 nDJXsbm9NZtk9xQT3g37F2OyHGXqyNf1hOl90jyMKVxGjELW9mtuB3NYMr2+RCuZIRf3
 LOU34DKN3aTKQZIKoOqI6Iwlm1P9t44CoXU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsyep4c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:03:48 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 16:03:44 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 121BC4752A005; Mon, 30 Nov 2020 16:03:39 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 0/2] Add support to set window_clamp from bpf setsockops
Date:   Mon, 30 Nov 2020 16:03:37 -0800
Message-ID: <20201201000339.3310760-1-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=13 mlxlogscore=962
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011300150
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains support to set tcp window_field field from bpf setsoc=
kops.

Prankur gupta (2):
  bpf: Adds support for setting window clamp
  selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP

 net/core/filter.c                             |  8 +++++
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  1 +
 .../selftests/bpf/prog_tests/tcpbpf_user.c    |  4 +++
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 33 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tcpbpf.h     |  2 ++
 5 files changed, 48 insertions(+)

--=20
2.24.1

