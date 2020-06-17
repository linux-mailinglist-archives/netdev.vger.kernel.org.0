Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC0E1FD498
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFQSbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:31:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbgFQSbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:31:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HIR7w6003300
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:31:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Hog2WRzHsPvlpflu20cK3q7w333zbbJl1cXOhbC1Ei0=;
 b=DEatwJA2NIk0QTg5shFrO5w8mepqD4fH/B36XCDgNnhz7RuLFRWbC3U+cpow4kfRRQpM
 n0aQP5qm1oJ766PW1N1gLDUAgszNtFdBeUSwf8Ztw6myBY2UQwh4vrh+7haEagAOUPW0
 9xYB8W3IZHgzqpPJdXXhmP/e4KGVuTFYiYk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q65sq1c0-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:31:46 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Jun 2020 11:31:40 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BE4212EC3CD6; Wed, 17 Jun 2020 11:31:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] libbpf: bump version to 0.1.0
Date:   Wed, 17 Jun 2020 11:31:32 -0700
Message-ID: <20200617183132.1970836-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_10:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 phishscore=0 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=706 suspectscore=8 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bump libbpf version to 0.1.0, as new development cycle starts.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.map | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index f732c77b7ed0..c914347f5065 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -270,3 +270,6 @@ LIBBPF_0.0.9 {
 		ring_buffer__new;
 		ring_buffer__poll;
 } LIBBPF_0.0.8;
+
+LIBBPF_0.1.0 {
+} LIBBPF_0.0.9;
--=20
2.24.1

