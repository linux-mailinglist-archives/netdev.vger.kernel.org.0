Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EBBD4A2B
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 00:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfJKWDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 18:03:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729328AbfJKWDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 18:03:03 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BLrWFB000651
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:03:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=wzbFaj0jfMR4H1vIFPac8YMegU2yii0XLPWqoKNghsk=;
 b=iOWdv87gN7MTDKt6FHv+5XupQK2d7IbPDcO6LRrakqj9AJBLJicf3F3ehe7cHa6wdxvL
 VfH1y6Mp6Ow0mXDcHpZxf5Y1gW/uBoEeE1DgVMEeE/bZnjGnivxp5Tww6JKg7YyUePuc
 NcnssRSWtxCTuh1k0MOWuH9kmcP5A2i6rms= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjtsujd74-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:03:02 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Oct 2019 15:02:31 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Oct 2019 15:01:55 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D7EB2861869; Fri, 11 Oct 2019 15:01:47 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/2] selftests/bpf Makefile cleanup and fixes
Date:   Fri, 11 Oct 2019 15:01:44 -0700
Message-ID: <20191011220146.3798961-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_11:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=8 impostorscore=0 mlxlogscore=512 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 enforces libbpf build to have bpf_helper_defs.h ready before test BPF
programs are built.
Patch #2 drops obsolete BTF/pahole detection logic from Makefile.

v1->v2:
- drop CPU and PROBE (Martin).

Andrii Nakryiko (2):
  selftests/bpf: enforce libbpf build before BPF programs are built
  selftests/bpf: remove obsolete pahole/BTF support detection

 tools/testing/selftests/bpf/Makefile | 57 ++++------------------------
 1 file changed, 8 insertions(+), 49 deletions(-)

-- 
2.17.1

