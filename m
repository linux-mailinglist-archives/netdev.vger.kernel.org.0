Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D3B17C990
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCGARg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:17:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32044 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgCGARe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:17:34 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0270GDFa032427
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 16:17:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gdFmlJTRxcq7QMjYODJoYXA513BFSRyf4af8ShgSyRA=;
 b=Qg4DHWhm3zvx23UDj3o8eGTwTHorJGdrlwpe3StBG0+fMNJ8SfJqS7AEV40b6HctDCwq
 OQQXK0UavcBuPekG8QBNhijPCdI4o9o8Pc2EPgfgwpu/W0JmUpQGDh8EPhjUT81VFebn
 bYw9QVIAd3YxrVMDXo6pePlEAvrZNdhSbBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ykrv7jgfh-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 16:17:33 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 6 Mar 2020 16:17:32 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 1EDF562E2880; Fri,  6 Mar 2020 16:17:27 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>,
        Paul Chaignon <paul.chaignon@orange.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 4/4] bpftool: fix typo in bash-completion
Date:   Fri, 6 Mar 2020 16:17:13 -0800
Message-ID: <20200307001713.3559880-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307001713.3559880-1-songliubraving@fb.com>
References: <20200307001713.3559880-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_09:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015
 mlxlogscore=681 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003070000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

_bpftool_get_map_names => _bpftool_get_prog_names for prog-attach|detach.

Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
Cc: Paul Chaignon <paul.chaignon@orange.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 49f4ab2f67e3..a9cce9d3745a 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -389,7 +389,7 @@ _bpftool()
                                     _bpftool_get_prog_ids
                                     ;;
                                 name)
-                                    _bpftool_get_map_names
+                                    _bpftool_get_prog_names
                                     ;;
                                 pinned)
                                     _filedir
-- 
2.17.1

