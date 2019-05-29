Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D702E35A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfE2Rgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:36:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52694 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbfE2Rge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:36:34 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4THTO9F017392
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=K+QUFWBAjwArLpgckJ2OYfjnuQ441fndsERnagPEokg=;
 b=TU/0JH/EvyhdmqXD35g07FdojVbnPajzDBacZNn7GiQKdrnv76dWI8aKTMZMhkwy+w3O
 becamsxBe/iP7fSlamgBDrr0sPwyooDd3rLxK/OYu6D9FW4jZVswPsC/rW7Pa6ZvtgsA
 cajRV3eqaJMlCvYyHs4uIMvs+ISBU4L+XoI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2ss7tv4f76-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:33 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 29 May 2019 10:36:32 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D65108617AE; Wed, 29 May 2019 10:36:31 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 8/9] libbpf: typo and formatting fixes
Date:   Wed, 29 May 2019 10:36:10 -0700
Message-ID: <20190529173611.4012579-9-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529173611.4012579-1-andriin@fb.com>
References: <20190529173611.4012579-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bunch of typo and formatting fixes.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5ea84ab69db1..6bd7dd544e41 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -505,7 +505,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 
 	obj->efile.fd = -1;
 	/*
-	 * Caller of this function should also calls
+	 * Caller of this function should also call
 	 * bpf_object__elf_finish() after data collection to return
 	 * obj_buf to user. If not, we should duplicate the buffer to
 	 * avoid user freeing them before elf finish.
@@ -574,8 +574,7 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 		}
 
 		obj->efile.elf = elf_begin(obj->efile.fd,
-				LIBBPF_ELF_C_READ_MMAP,
-				NULL);
+					   LIBBPF_ELF_C_READ_MMAP, NULL);
 	}
 
 	if (!obj->efile.elf) {
@@ -594,9 +593,9 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	ep = &obj->efile.ehdr;
 
 	/* Old LLVM set e_machine to EM_NONE */
-	if ((ep->e_type != ET_REL) || (ep->e_machine && (ep->e_machine != EM_BPF))) {
-		pr_warning("%s is not an eBPF object file\n",
-			obj->path);
+	if (ep->e_type != ET_REL ||
+	    (ep->e_machine && ep->e_machine != EM_BPF)) {
+		pr_warning("%s is not an eBPF object file\n", obj->path);
 		err = -LIBBPF_ERRNO__FORMAT;
 		goto errout;
 	}
@@ -1438,7 +1437,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 			}
 
 			if (map_idx >= nr_maps) {
-				pr_warning("bpf relocation: map_idx %d large than %d\n",
+				pr_warning("bpf relocation: map_idx %d larger than %d\n",
 					   (int)map_idx, (int)nr_maps - 1);
 				return -LIBBPF_ERRNO__RELOC;
 			}
@@ -1797,7 +1796,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 			}
 		}
 
-		pr_debug("create map %s: fd=%d\n", map->name, *pfd);
+		pr_debug("created map %s: fd=%d\n", map->name, *pfd);
 	}
 
 	return 0;
-- 
2.17.1

