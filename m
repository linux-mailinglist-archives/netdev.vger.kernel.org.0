Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C244C18249E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgCKWTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:19:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729726AbgCKWTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:19:00 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02BMBeqM027366
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=dxhvxvQRp4CSLyRuwoZDVH4m0ZyOP7Lbiby3kyfGQHc=;
 b=WRi2uvDkhcTUeMMMIhSrMz8kv+wAsIjexWl/NHDs1S9teojojWCUqehaA+/bUfQV5+NQ
 OBDv1wZPG4woRQaCYUhJyW+8fYZaBEL9zcEuqikHxTyt+Vp7HvIoVMHRUZBJ3IXCgN6p
 7YpFJ3xI0Li0pQdY/Q0ncP/gcD3tvdzo5xQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ypfj46x7p-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:18:59 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 11 Mar 2020 15:18:54 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A2CD662E2936; Wed, 11 Mar 2020 15:18:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/3] bpftool: add _bpftool and profiler.skel.h to .gitignore
Date:   Wed, 11 Mar 2020 15:18:44 -0700
Message-ID: <20200311221844.3089820-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200311221844.3089820-1-songliubraving@fb.com>
References: <20200311221844.3089820-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-11_11:2020-03-11,2020-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0
 suspectscore=0 impostorscore=0 phishscore=0 clxscore=1015 mlxlogscore=725
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110124
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These files are generated, so ignore them.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
index b13926432b84..8d6e8901ed2b 100644
--- a/tools/bpf/bpftool/.gitignore
+++ b/tools/bpf/bpftool/.gitignore
@@ -1,7 +1,9 @@
 *.d
+/_bpftool
 /bpftool
 bpftool*.8
 bpf-helpers.*
 FEATURE-DUMP.bpftool
 feature
 libbpf
+profiler.skel.h
-- 
2.17.1

