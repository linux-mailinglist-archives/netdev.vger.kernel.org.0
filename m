Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28E517E5C5
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCIRci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:32:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49524 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727313AbgCIRci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:32:38 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029HP2YD032288
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 10:32:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gdFmlJTRxcq7QMjYODJoYXA513BFSRyf4af8ShgSyRA=;
 b=BALtzGVFwJQukqbxwgwiTy5A5GRkZrHcgetQ5NUQ9PV0ojHS0hHyIMQtiWWzleNeWHGI
 u3L/sqC3fTuHFgTP1ziolqG4/6WrpiixjHsWAHLBHmvZHpaE8yP+d2Rf5pFMZu8JWDcf
 OfU6mEBcMb4sBint8cOzMQD7t0uEXxKpyjA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymaaq0an0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:32:37 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 10:32:36 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 3176762E27FD; Mon,  9 Mar 2020 10:32:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>,
        Paul Chaignon <paul.chaignon@orange.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v6 bpf-next 4/4] bpftool: fix typo in bash-completion
Date:   Mon, 9 Mar 2020 10:32:18 -0700
Message-ID: <20200309173218.2739965-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309173218.2739965-1-songliubraving@fb.com>
References: <20200309173218.2739965-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=678 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090110
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

