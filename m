Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB72925CB04
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgICUhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:37:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729744AbgICUhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:37:06 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083KXvK7024388
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 13:37:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xZfr7J7vumhx1Zgou/Z0il+VrwbvbOFRutiV/wfxi9k=;
 b=NWEf/WBWYouPNDxR8+RV9FudEaJJHqtGbyAmHaaBQRxMQEaZV6jJPn4nqi0oxQxkiAdC
 Xuro7qQVgwWUOlP881MngTiv8RlyzfO8o83Ph5oL/mBqEwIq5lhkZX4Fm2/gJ8EdzEko
 rwRAn1h1MOPUgwcbkjvLL3Gqr/rmzW2pwIc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33879p1tht-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:37:05 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 13:36:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BA61D2EC6814; Thu,  3 Sep 2020 13:36:00 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v3 bpf-next 08/14] tools/bpftool: replace bpf_program__title() with bpf_program__section_name()
Date:   Thu, 3 Sep 2020 13:35:36 -0700
Message-ID: <20200903203542.15944-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200903203542.15944-1-andriin@fb.com>
References: <20200903203542.15944-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=608 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__title() is deprecated, switch to bpf_program__section_name()=
 and
avoid compilation warnings.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/prog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index d393eb8263a6..f7923414a052 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1304,7 +1304,7 @@ static int load_with_options(int argc, char **argv,=
 bool first_prog_only)
 		enum bpf_prog_type prog_type =3D common_prog_type;
=20
 		if (prog_type =3D=3D BPF_PROG_TYPE_UNSPEC) {
-			const char *sec_name =3D bpf_program__title(pos, false);
+			const char *sec_name =3D bpf_program__section_name(pos);
=20
 			err =3D get_prog_type_by_name(sec_name, &prog_type,
 						    &expected_attach_type);
@@ -1398,7 +1398,7 @@ static int load_with_options(int argc, char **argv,=
 bool first_prog_only)
 		err =3D bpf_obj_pin(bpf_program__fd(prog), pinfile);
 		if (err) {
 			p_err("failed to pin program %s",
-			      bpf_program__title(prog, false));
+			      bpf_program__section_name(prog));
 			goto err_close_obj;
 		}
 	} else {
--=20
2.24.1

