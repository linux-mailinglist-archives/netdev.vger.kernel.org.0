Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EDEFF82C
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfKQHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbfKQHIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:20 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAH77gKC014582
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oZYLdEUDKPXcr8YUD7u9d6EvKlyuyedwmqbcejyfSKM=;
 b=gjGaU55coi+a8dnsVqToPtKb4/NyugW27P7kDR9ASJ17ty4zjZKj2/lfbsWxR1Eo5n6Z
 QGfTn5y44PF6067gt5LXqm8U2Rvhg1pj+1ZM1UtIBm4ExpU3Hpul/Ji9gWvqi3Lw08S4
 QBdcAkilFWg1i9n5D8ILGcn80FEV/sPO7aQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wadnn2xv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:19 -0800
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 16 Nov 2019 23:08:18 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 36FF82EC19AE; Sat, 16 Nov 2019 23:08:18 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/6] libbpf: fix various errors and warning reported by checkpatch.pl
Date:   Sat, 16 Nov 2019 23:08:04 -0800
Message-ID: <20191117070807.251360-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117070807.251360-1-andriin@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=9 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bunch of warnings and errors reported by checkpatch.pl, to make it
easier to spot new problems.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0fdca01f7e57..f6232aeefb9e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -105,7 +105,7 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 	err = action;			\
 	if (err)			\
 		goto out;		\
-} while(0)
+} while (0)
 
 
 /* Copied from tools/perf/util/util.h */
@@ -965,8 +965,7 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 		 obj->path, nr_maps, data->d_size);
 
 	if (!data->d_size || nr_maps == 0 || (data->d_size % nr_maps) != 0) {
-		pr_warn("unable to determine map definition size "
-			"section %s, %d maps in %zd bytes\n",
+		pr_warn("unable to determine map definition size section %s, %d maps in %zd bytes\n",
 			obj->path, nr_maps, data->d_size);
 		return -EINVAL;
 	}
@@ -1030,12 +1029,11 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 			 * incompatible.
 			 */
 			char *b;
+
 			for (b = ((char *)def) + sizeof(struct bpf_map_def);
 			     b < ((char *)def) + map_def_sz; b++) {
 				if (*b != 0) {
-					pr_warn("maps section in %s: \"%s\" "
-						"has unrecognized, non-zero "
-						"options\n",
+					pr_warn("maps section in %s: \"%s\" has unrecognized, non-zero options\n",
 						obj->path, map_name);
 					if (strict)
 						return -EINVAL;
@@ -1073,7 +1071,8 @@ skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
  */
 static bool get_map_field_int(const char *map_name, const struct btf *btf,
 			      const struct btf_type *def,
-			      const struct btf_member *m, __u32 *res) {
+			      const struct btf_member *m, __u32 *res)
+{
 	const struct btf_type *t = skip_mods_and_typedefs(btf, m->type, NULL);
 	const char *name = btf__name_by_offset(btf, m->name_off);
 	const struct btf_array *arr_info;
@@ -1387,7 +1386,8 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 	for (i = 0; i < vlen; i++) {
 		err = bpf_object__init_user_btf_map(obj, sec, i,
 						    obj->efile.btf_maps_shndx,
-						    data, strict, pin_root_path);
+						    data, strict,
+						    pin_root_path);
 		if (err)
 			return err;
 	}
@@ -1673,12 +1673,14 @@ static int bpf_object__elf_collect(struct bpf_object *obj, bool relaxed_maps,
 				if (strcmp(name, ".text") == 0)
 					obj->efile.text_shndx = idx;
 				err = bpf_object__add_program(obj, data->d_buf,
-							      data->d_size, name, idx);
+							      data->d_size,
+							      name, idx);
 				if (err) {
 					char errmsg[STRERR_BUFSIZE];
-					char *cp = libbpf_strerror_r(-err, errmsg,
-								     sizeof(errmsg));
+					char *cp;
 
+					cp = libbpf_strerror_r(-err, errmsg,
+							       sizeof(errmsg));
 					pr_warn("failed to alloc program %s (%s): %s",
 						name, obj->path, cp);
 					return err;
@@ -1824,7 +1826,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 	}
 
 	if (insn->code != (BPF_LD | BPF_IMM | BPF_DW)) {
-		pr_warn("bpf: relocation: invalid relo for insns[%d].code 0x%x\n",
+		pr_warn("invalid relo for insns[%d].code 0x%x\n",
 			insn_idx, insn->code);
 		return -LIBBPF_ERRNO__RELOC;
 	}
@@ -2140,7 +2142,7 @@ bpf_object__probe_global_data(struct bpf_object *obj)
 
 static int bpf_object__probe_btf_func(struct bpf_object *obj)
 {
-	const char strs[] = "\0int\0x\0a";
+	static const char strs[] = "\0int\0x\0a";
 	/* void x(int a) {} */
 	__u32 types[] = {
 		/* int */
@@ -2166,7 +2168,7 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
 
 static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
 {
-	const char strs[] = "\0x\0.data";
+	static const char strs[] = "\0x\0.data";
 	/* static int a; */
 	__u32 types[] = {
 		/* int */
@@ -5107,7 +5109,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 		*expected_attach_type = section_names[i].expected_attach_type;
 		return 0;
 	}
-	pr_warn("failed to guess program type based on ELF section name '%s'\n", name);
+	pr_warn("failed to guess program type from ELF section '%s'\n", name);
 	type_names = libbpf_get_type_names(false);
 	if (type_names != NULL) {
 		pr_info("supported section(type) names are:%s\n", type_names);
@@ -6333,7 +6335,8 @@ static struct bpf_prog_info_array_desc bpf_prog_info_array_desc[] = {
 
 };
 
-static __u32 bpf_prog_info_read_offset_u32(struct bpf_prog_info *info, int offset)
+static __u32 bpf_prog_info_read_offset_u32(struct bpf_prog_info *info,
+					   int offset)
 {
 	__u32 *array = (__u32 *)info;
 
@@ -6342,7 +6345,8 @@ static __u32 bpf_prog_info_read_offset_u32(struct bpf_prog_info *info, int offse
 	return -(int)offset;
 }
 
-static __u64 bpf_prog_info_read_offset_u64(struct bpf_prog_info *info, int offset)
+static __u64 bpf_prog_info_read_offset_u64(struct bpf_prog_info *info,
+					   int offset)
 {
 	__u64 *array = (__u64 *)info;
 
-- 
2.17.1

