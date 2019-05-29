Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8AC2E35C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfE2Rgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:36:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38602 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfE2Rgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:36:38 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4THTjrg026205
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=WKRsz83IKWLiUpzPWLqlhLZx/3zxLX8QH59aatFS9VA=;
 b=YZjuhfQ9qkXUQMk+W+DgOqfnfI0/rlXngz9wgRXe2iEe/1RnjhKRfm2WYtqFTp4NOzRb
 PoHO7yYynJz+8+cXvT8ti/sUAKu/vMnlnilinjSZxaB9JZCDuxN+woeFMiTg2/YeEj/D
 ZbH/rNv8Qh+V86YQTxWGFNlfj5t0PPZuRZg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ssv0ernjk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:36:37 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 29 May 2019 10:36:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E30B08617AE; Wed, 29 May 2019 10:36:33 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 9/9] libbpf: reduce unnecessary line wrapping
Date:   Wed, 29 May 2019 10:36:11 -0700
Message-ID: <20190529173611.4012579-10-andriin@fb.com>
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

There are a bunch of lines of code or comments that are unnecessary
wrapped into multi-lines. Fix that without violating any code
guidelines.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 52 +++++++++++++-----------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6bd7dd544e41..9042506acb65 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -497,8 +497,7 @@ static struct bpf_object *bpf_object__new(const char *path,
 
 	strcpy(obj->path, path);
 	/* Using basename() GNU version which doesn't modify arg. */
-	strncpy(obj->name, basename((void *)path),
-		sizeof(obj->name) - 1);
+	strncpy(obj->name, basename((void *)path), sizeof(obj->name) - 1);
 	end = strchr(obj->name, '.');
 	if (end)
 		*end = 0;
@@ -578,15 +577,13 @@ static int bpf_object__elf_init(struct bpf_object *obj)
 	}
 
 	if (!obj->efile.elf) {
-		pr_warning("failed to open %s as ELF file\n",
-				obj->path);
+		pr_warning("failed to open %s as ELF file\n", obj->path);
 		err = -LIBBPF_ERRNO__LIBELF;
 		goto errout;
 	}
 
 	if (!gelf_getehdr(obj->efile.elf, &obj->efile.ehdr)) {
-		pr_warning("failed to get EHDR from %s\n",
-				obj->path);
+		pr_warning("failed to get EHDR from %s\n", obj->path);
 		err = -LIBBPF_ERRNO__FORMAT;
 		goto errout;
 	}
@@ -622,18 +619,15 @@ static int bpf_object__check_endianness(struct bpf_object *obj)
 }
 
 static int
-bpf_object__init_license(struct bpf_object *obj,
-			 void *data, size_t size)
+bpf_object__init_license(struct bpf_object *obj, void *data, size_t size)
 {
-	memcpy(obj->license, data,
-	       min(size, sizeof(obj->license) - 1));
+	memcpy(obj->license, data, min(size, sizeof(obj->license) - 1));
 	pr_debug("license of %s is %s\n", obj->path, obj->license);
 	return 0;
 }
 
 static int
-bpf_object__init_kversion(struct bpf_object *obj,
-			  void *data, size_t size)
+bpf_object__init_kversion(struct bpf_object *obj, void *data, size_t size)
 {
 	__u32 kver;
 
@@ -643,8 +637,7 @@ bpf_object__init_kversion(struct bpf_object *obj,
 	}
 	memcpy(&kver, data, sizeof(kver));
 	obj->kern_version = kver;
-	pr_debug("kernel version of %s is %x\n", obj->path,
-		 obj->kern_version);
+	pr_debug("kernel version of %s is %x\n", obj->path, obj->kern_version);
 	return 0;
 }
 
@@ -800,8 +793,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
 	def->key_size = sizeof(int);
 	def->value_size = data->d_size;
 	def->max_entries = 1;
-	def->map_flags = type == LIBBPF_MAP_RODATA ?
-			 BPF_F_RDONLY_PROG : 0;
+	def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
 	if (data_buff) {
 		*data_buff = malloc(data->d_size);
 		if (!*data_buff) {
@@ -816,8 +808,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
 	return 0;
 }
 
-static int
-bpf_object__init_maps(struct bpf_object *obj, int flags)
+static int bpf_object__init_maps(struct bpf_object *obj, int flags)
 {
 	int i, map_idx, map_def_sz = 0, nr_syms, nr_maps = 0, nr_maps_glob = 0;
 	bool strict = !(flags & MAPS_RELAX_COMPAT);
@@ -1098,8 +1089,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 
 	/* Elf is corrupted/truncated, avoid calling elf_strptr. */
 	if (!elf_rawdata(elf_getscn(elf, ep->e_shstrndx), NULL)) {
-		pr_warning("failed to get e_shstrndx from %s\n",
-			   obj->path);
+		pr_warning("failed to get e_shstrndx from %s\n", obj->path);
 		return -LIBBPF_ERRNO__FORMAT;
 	}
 
@@ -1340,8 +1330,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 	size_t nr_maps = obj->nr_maps;
 	int i, nrels;
 
-	pr_debug("collecting relocating info for: '%s'\n",
-		 prog->section_name);
+	pr_debug("collecting relocating info for: '%s'\n", prog->section_name);
 	nrels = shdr->sh_size / shdr->sh_entsize;
 
 	prog->reloc_desc = malloc(sizeof(*prog->reloc_desc) * nrels);
@@ -1366,9 +1355,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 
-		if (!gelf_getsym(symbols,
-				 GELF_R_SYM(rel.r_info),
-				 &sym)) {
+		if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
 			pr_warning("relocation: symbol %"PRIx64" not found\n",
 				   GELF_R_SYM(rel.r_info));
 			return -LIBBPF_ERRNO__FORMAT;
@@ -1817,18 +1804,14 @@ check_btf_ext_reloc_err(struct bpf_program *prog, int err,
 	if (btf_prog_info) {
 		/*
 		 * Some info has already been found but has problem
-		 * in the last btf_ext reloc.  Must have to error
-		 * out.
+		 * in the last btf_ext reloc. Must have to error out.
 		 */
 		pr_warning("Error in relocating %s for sec %s.\n",
 			   info_name, prog->section_name);
 		return err;
 	}
 
-	/*
-	 * Have problem loading the very first info.  Ignore
-	 * the rest.
-	 */
+	/* Have problem loading the very first info. Ignore the rest. */
 	pr_warning("Cannot find %s for main program sec %s. Ignore all %s.\n",
 		   info_name, prog->section_name, info_name);
 	return 0;
@@ -2032,9 +2015,7 @@ static int bpf_object__collect_reloc(struct bpf_object *obj)
 			return -LIBBPF_ERRNO__RELOC;
 		}
 
-		err = bpf_program__collect_reloc(prog,
-						 shdr, data,
-						 obj);
+		err = bpf_program__collect_reloc(prog, shdr, data, obj);
 		if (err)
 			return err;
 	}
@@ -2354,8 +2335,7 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
 			 (unsigned long)obj_buf_sz);
 		name = tmp_name;
 	}
-	pr_debug("loading object '%s' from buffer\n",
-		 name);
+	pr_debug("loading object '%s' from buffer\n", name);
 
 	return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
 }
-- 
2.17.1

