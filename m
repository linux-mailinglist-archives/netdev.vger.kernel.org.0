Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E1C11EFBB
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLNBo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:44:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12776 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbfLNBo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:44:26 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE1iEJG004189
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:44:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=1dJG8uMwcBDrpwgMjW91dzs8cFo6UiMu8gULn0pA6II=;
 b=oWIZt+nkx70mPmJdzMl82zZtq6hi7mqD/U56yu0Sz2pPyh6FSH66+HPfIwdxK0Nu+w/l
 ySTSQrdJHQDF8bw5u5uMRvyCpah0n1CM/woMgUICUmBmYya9ca2ZIgm0mdL+KeiWwwxZ
 1K95C5+qKURTjLZ6MgbazB4wYMx8URfPHzM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvjpr0x6e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:44:25 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 13 Dec 2019 17:44:24 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0E4CE2EC1D51; Fri, 13 Dec 2019 17:44:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 17/17] bpftool: add `gen skeleton` BASH completions
Date:   Fri, 13 Dec 2019 17:43:41 -0800
Message-ID: <20191214014341.3442258-18-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014341.3442258-1-andriin@fb.com>
References: <20191214014341.3442258-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=725
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 suspectscore=8 phishscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BASH completions for gen sub-command.

Cc: Quentin Monnet <quentin.monnet@netronome.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 70493a6da206..986519cc58d1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -716,6 +716,17 @@ _bpftool()
                     ;;
             esac
             ;;
+        gen)
+            case $command in
+                skeleton)
+                    _filedir
+		    ;;
+                *)
+                    [[ $prev == $object ]] && \
+                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
+                    ;;
+            esac
+            ;;
         cgroup)
             case $command in
                 show|list|tree)
-- 
2.17.1

