Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2097B183888
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCLSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:24:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726437AbgCLSYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:24:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02CIGSeg019705
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:24:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gcGaEU8fagjhbFrsiNJilfSh/p+dJinqNDLvnER0gS8=;
 b=CeN5CWnVIz0JIGhA32qMa5LIM9Vres1ElrwrhmRhcl7bgaNtaKcGoNjnB4T03P4JEmeK
 LIl6dLgMzHtOEB+ayt++vBo4P4mwGvoKGC7mJfyq4DRpkJpGGmFkj8EZhY86sJ99iYIr
 WHPkoLZ++2h0F5cGRYP3GkSgtEqrLAxpwCw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2yqt7e8195-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:24:21 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 11:23:45 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5018662E0874; Thu, 12 Mar 2020 11:23:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/3] bpftool: add _bpftool and profiler.skel.h to .gitignore
Date:   Thu, 12 Mar 2020 11:23:32 -0700
Message-ID: <20200312182332.3953408-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312182332.3953408-1-songliubraving@fb.com>
References: <20200312182332.3953408-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=659 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120093
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These files are generated, so ignore them.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
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

