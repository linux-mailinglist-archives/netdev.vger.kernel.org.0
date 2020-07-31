Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF4234B0C
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387915AbgGaS2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:28:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18382 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387903AbgGaS2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:28:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VIErxr011506
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JgfEaGwNQRVUqJr1ZSWmaVimqm5x282W48cubRvrXek=;
 b=jI+kXod4DW2ig+rcNzGnhg5SEv/8oIdKYTYtujj19TWBbhHllxBtSnB402S6yg/7bFcx
 U2zW+iQQC7E5qqZs9E5Hyh2Fr66evQEFumVvJ5NGlvGtJhJCQSyZMjJRv7opac8WCh0A
 gxcRZyMXE5jBCQiagii0f98we0S2EY4Ny8g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32m8dybyjj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:48 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 11:28:47 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 050E92EC4E02; Fri, 31 Jul 2020 11:28:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 5/5] tools/bpftool: add documentation and bash-completion for `link detach`
Date:   Fri, 31 Jul 2020 11:28:30 -0700
Message-ID: <20200731182830.286260-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200731182830.286260-1-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_07:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=985 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=8 spamscore=0 phishscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add info on link detach sub-command to man page. Add detach to bash-compl=
etion
as well.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/bpftool-link.rst | 8 ++++++++
 tools/bpf/bpftool/bash-completion/bpftool        | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf=
/bpftool/Documentation/bpftool-link.rst
index 38b0949a185b..4a52e7a93339 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -21,6 +21,7 @@ LINK COMMANDS
=20
 |	**bpftool** **link { show | list }** [*LINK*]
 |	**bpftool** **link pin** *LINK* *FILE*
+|	**bpftool** **link detach *LINK*
 |	**bpftool** **link help**
 |
 |	*LINK* :=3D { **id** *LINK_ID* | **pinned** *FILE* }
@@ -49,6 +50,13 @@ DESCRIPTION
 		  contain a dot character ('.'), which is reserved for future
 		  extensions of *bpffs*.
=20
+	**bpftool link detach** *LINK*
+		  Force-detach link *LINK*. BPF link and its underlying BPF
+		  program will stay valid, but they will be detached from the
+		  respective BPF hook and BPF link will transition into
+		  a defunct state until last open file descriptor for that
+		  link is closed.
+
 	**bpftool link help**
 		  Print short help message.
=20
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
index 257fa310ea2b..f53ed2f1a4aa 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -1122,7 +1122,7 @@ _bpftool()
             ;;
         link)
             case $command in
-                show|list|pin)
+                show|list|pin|detach)
                     case $prev in
                         id)
                             _bpftool_get_link_ids
@@ -1139,7 +1139,7 @@ _bpftool()
                     COMPREPLY=3D( $( compgen -W "$LINK_TYPE" -- "$cur" )=
 )
                     return 0
                     ;;
-                pin)
+                pin|detach)
                     if [[ $prev =3D=3D "$command" ]]; then
                         COMPREPLY=3D( $( compgen -W "$LINK_TYPE" -- "$cu=
r" ) )
                     else
--=20
2.24.1

