Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3172CA88D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgLAQom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:44:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbgLAQol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 11:44:41 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GLwdE024103
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 08:44:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KGAgx0m/Rj86KBMvIa/DgtAMVpNIMeawRc3BiS3LgYw=;
 b=XVwWD8K9oPjS7owpRj8pYXQJK527DV171V2H8/C2qRJQ6d4fV2MHPbKmQYzLOVW4Rfwt
 4/YfY9qzo8Xo/4rrTuJ5LR/DlgCjz7aN3cTP4fluCh+n8eUZZjxOsrNBQCNVkK+FH6Ng
 nnOHcOGfOsORifxiEaVdqC6AyOjPxx6MzAY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsykejv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 08:44:00 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 08:43:58 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 0BFBE4757EBA2; Tue,  1 Dec 2020 08:43:57 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 0/2] Add support to set window_clamp from bpf setsockops
Date:   Tue, 1 Dec 2020 08:43:55 -0800
Message-ID: <20201201164357.2623610-1-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=13 mlxlogscore=999
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains support to set tcp window_field field from bpf setsoc=
kops.

v2: Used TCP_WINDOW_CLAMP setsockopt logic for bpf_setsockopt (review com=
ment addressed)

Prankur gupta (2):
  bpf: Adds support for setting window clamp
  selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP

 net/core/filter.c                             | 13 ++++++++
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  1 +
 .../selftests/bpf/prog_tests/tcpbpf_user.c    |  4 +++
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 33 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tcpbpf.h     |  2 ++
 5 files changed, 53 insertions(+)

--=20
2.24.1

