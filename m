Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40CC2970
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfI3WZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:25:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58051 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728214AbfI3WZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:25:11 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UMIviI016785
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 15:25:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=mO3KZuL17cdXmEpSjAnW7N+6M7y171RiN149fTmK8lQ=;
 b=Uby+3yilEDPwJpKOD3a1wjzDdkGAuCUHGft2AK197ZwNzOAbFJpc8AT9lAUhv7ADtJ/t
 WRPZj5TC0L2A+U8JFPOzcTFHXQSTcsxxqbz9t7gP9ja+1DZ7Wndbdr+iMQWT3H4oRaTr
 iHPVReN9woEF8Kh1jtYUTeu9bUYL6OCJ8WE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vbnb29g1b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 15:25:08 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 30 Sep 2019 15:25:06 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2D1E9861880; Mon, 30 Sep 2019 15:25:06 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] libbpf: bump current version to v0.0.6
Date:   Mon, 30 Sep 2019 15:25:03 -0700
Message-ID: <20190930222503.519782-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_12:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=8
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=659 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909300184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New release cycle started, let's bump to v0.0.6 proactively.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.map | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d04c7cb623ed..8d10ca03d78d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -190,3 +190,6 @@ LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
 } LIBBPF_0.0.4;
+
+LIBBPF_0.0.6 {
+} LIBBPF_0.0.5;
-- 
2.17.1

