Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE5F13667D
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgAJFRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:17:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42716 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgAJFRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:17:20 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A5D4sK031944
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 21:17:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=nLD1LGzF1eNhTOffLynd5BAvnsy8BAlcGR1Rr0nSEoI=;
 b=GTTIsWwnK25gg5Buw7+ACyDBreAPqDA9pPOBKC5vYkEDBZOn1CdR5nr5ltD9YfGIYetq
 tlwZawLvtyvMNggLq43ElYnuu0hyUkNfMIkIaC7oI0i1pjknutx55Vjd0Ev/vZOOyFd4
 S/mViaMDYezdTTflUJVuj45PGfS8u2QS1aI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xe7u4kj9c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 21:17:19 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 9 Jan 2020 21:17:19 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A0F0C2EC158B; Thu,  9 Jan 2020 21:17:17 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] Fix usage of bpf_helper_defs.h in selftests/bpf
Date:   Thu, 9 Jan 2020 21:17:13 -0800
Message-ID: <20200110051716.1591485-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=755 malwarescore=0 suspectscore=8 clxscore=1015
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001100045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix issues with bpf_helper_defs.h usage in selftests/bpf. As part of that, fix
the way clean up is performed for libbpf and selftests/bpf. Some for Makefile
output clean ups as well.

Andrii Nakryiko (3):
  libbpf,selftests/bpf: fix clean targets
  selftests/bpf: ensure bpf_helper_defs.h are taken from selftests dir
  selftests/bpf: further clean up Makefile output

 tools/lib/bpf/Makefile                 |  9 +++++----
 tools/lib/bpf/bpf_helpers.h            |  2 +-
 tools/testing/selftests/bpf/.gitignore |  2 --
 tools/testing/selftests/bpf/Makefile   | 27 +++++++++++++++-----------
 4 files changed, 22 insertions(+), 18 deletions(-)

-- 
2.17.1

