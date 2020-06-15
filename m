Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245E21FA3C4
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 00:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgFOWyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 18:54:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63878 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726408AbgFOWyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 18:54:04 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FMjVZb001817
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 15:54:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=2eD8IxW0E51tBxi6wZ/BHDjjdTMYLiR6zvpUup5wNqs=;
 b=eR4pRF7Ofbhu6XBzmtXrsUxBdpXhk/I8haSru5ZU5P5yfBcHL8p4w+7Qur7KINIdmR6o
 EZmgDzgPduPLFqzwVOdsVmBa24hfR7RsphENjg9tHLUkpJY2z11rs2bnWjemrvHZrB0O
 gwkLD/YadwhQlQ6dYZO9Plqdt8mf8S5Ztnc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31mvamhrt1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 15:54:02 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Jun 2020 15:54:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7E6422EC3A4B; Mon, 15 Jun 2020 15:53:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] tools/bpftool: add ringbuf map to a list of known map types
Date:   Mon, 15 Jun 2020 15:53:55 -0700
Message-ID: <20200615225355.366256-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_11:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0
 phishscore=0 cotscore=-2147483648 mlxlogscore=728 lowpriorityscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006150162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add symbolic name "ringbuf" to map to BPF_MAP_TYPE_RINGBUF. Without this,
users will see "type 27" instead of "ringbuf" in `map show` output.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c5fac8068ba1..99109a6afe17 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -49,6 +49,7 @@ const char * const map_type_name[] =3D {
 	[BPF_MAP_TYPE_STACK]			=3D "stack",
 	[BPF_MAP_TYPE_SK_STORAGE]		=3D "sk_storage",
 	[BPF_MAP_TYPE_STRUCT_OPS]		=3D "struct_ops",
+	[BPF_MAP_TYPE_RINGBUF]			=3D "ringbuf",
 };
=20
 const size_t map_type_name_size =3D ARRAY_SIZE(map_type_name);
--=20
2.24.1

