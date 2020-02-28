Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF4A1739B7
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgB1OWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:22:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726694AbgB1OWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582899753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9ZMk/n1SyOYfzSMp3fVt99Q+nfcbtLY9z6f7bR68u4=;
        b=fvJncugeJ6RNjeZ2xg3/iShvAUDdG2KZxTOuZohGdhmc2wf9CjOCjsjE8lR8tSP/gBW4e0
        Fpk8Y7QryUbLkr4eustWttoq3Zz+uNTMuCsPvNpvEqDg/MtQkwC78SylsEGtHBLK2F5yT/
        +e+Rvhy3AzEikYcspfciHNtl3Itj8fY=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-27tJyHWbPwSOMx9crsVSYw-1; Fri, 28 Feb 2020 09:22:26 -0500
X-MC-Unique: 27tJyHWbPwSOMx9crsVSYw-1
Received: by mail-lf1-f70.google.com with SMTP id q5so419878lfc.6
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:22:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=G9ZMk/n1SyOYfzSMp3fVt99Q+nfcbtLY9z6f7bR68u4=;
        b=CDHN5uMQ/gd9oKHw52/utrAsg5o0xZ+w2YTVp1zTAg1L02KlqpYf0aP2zKrPQx7THF
         tR5Pg4q8Z9gP/BZj0S3rx1PXOcpkdDJonVsyUPuEYfW+vnFiBhn3e/zrv4rkaYNe79kt
         Pjt8gFGcQN5B5uYN36y0YApBUqx5xqYveQb07RS8oC0qbhht52kIPKA93xmGS4i3+mbS
         FCHp/R2h1smDz5TIrXRzNpOCxenD+c4e9EbutmX0MU+R01J931F9wX4yeJ2hGzwkS9xy
         p0IJiRtHRERT/kjhxFNxk9ryJmkXdeepesSHjd78OGNYkTuXWzIAPaYqx4NQLpPgxwhW
         Wh+w==
X-Gm-Message-State: ANhLgQ1o2ThDe9o7xZlQfYbctu8hmTcY5wRdzSh8NG6yk0upONhI62U7
        awOIkob1DvLn9HR24sDBl+EQ6NDgW6RuZcWWKAQeZfNsDT32CrmfDVj8J5x3CBdS6GHyZripahJ
        MzEFXF8QCHpy8o9Qp
X-Received: by 2002:a2e:6c06:: with SMTP id h6mr3082438ljc.246.1582899744102;
        Fri, 28 Feb 2020 06:22:24 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvi29I3guQBPDRCxqJ5NFmLSjMurmWLppc0tEr6DEiAbvJCakP2WxmjD8KaanAD8sK/azvc8w==
X-Received: by 2002:a2e:6c06:: with SMTP id h6mr3082383ljc.246.1582899743171;
        Fri, 28 Feb 2020 06:22:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h9sm5686295ljg.3.2020.02.28.06.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 06:22:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 32016180370; Fri, 28 Feb 2020 15:22:21 +0100 (CET)
Subject: [PATCH RFC] libxdp: Add libxdp (FOR COMMENT ONLY)
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 28 Feb 2020 15:22:21 +0100
Message-ID: <158289974102.337029.4665273491352111017.stgit@toke.dk>
In-Reply-To: <158289973977.337029.3637846294079508848.stgit@toke.dk>
References: <158289973977.337029.3637846294079508848.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

**THIS IS A DUMMY PATCH TO EASE INLINE REVIEW ONLY; SEE COVER LETTER**

This adds tools/lib/xdp/ with the contents of the libxdp code. This is only
included to ease inline commenting on the code; it does not actually
compile in this form, and I am not (yet) proposing it should live in the
kernel tree.

There is a working version on Github; to clone and compile simply do this:

$ git clone --recurse-submodules -b xdp-multi-prog https://github.com/xdp-project/xdp-tools
$ cd xdp-tools && ./configure && make

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/xdp/libxdp.c          |  856 +++++++++++++++++++++++++++++++++++++++
 tools/lib/xdp/libxdp.h          |   38 ++
 tools/lib/xdp/prog_dispatcher.h |   17 +
 tools/lib/xdp/xdp-dispatcher.c  |  178 ++++++++
 tools/lib/xdp/xdp_helpers.h     |   12 +
 5 files changed, 1101 insertions(+)
 create mode 100644 tools/lib/xdp/libxdp.c
 create mode 100644 tools/lib/xdp/libxdp.h
 create mode 100644 tools/lib/xdp/prog_dispatcher.h
 create mode 100644 tools/lib/xdp/xdp-dispatcher.c
 create mode 100644 tools/lib/xdp/xdp_helpers.h

diff --git a/tools/lib/xdp/libxdp.c b/tools/lib/xdp/libxdp.c
new file mode 100644
index 000000000000..46f2a73157a0
--- /dev/null
+++ b/tools/lib/xdp/libxdp.c
@@ -0,0 +1,856 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * XDP management utility functions
+ *
+ * Copyright (C) 2020 Toke Høiland-Jørgensen <toke@redhat.com>
+ */
+
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+
+#include <linux/err.h> /* ERR_PTR */
+#include <linux/if_link.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include <xdp/libxdp.h>
+#include <xdp/prog_dispatcher.h>
+#include "logging.h"
+#include "util.h"
+
+#define XDP_RUN_CONFIG_SEC ".xdp_run_config"
+
+struct xdp_program {
+	/* one of prog or prog_fd should be set */
+	struct bpf_program *bpf_prog;
+	struct bpf_object *bpf_obj;
+	struct btf *btf;
+	int prog_fd;
+	int link_fd;
+	const char *prog_name;
+	__u8 prog_tag[BPF_TAG_SIZE];
+	__u64 load_time;
+	bool from_external_obj;
+	unsigned int run_prio;
+	unsigned int chain_call_actions; // bitmap
+};
+
+
+static const char *xdp_action_names[] = {
+	[XDP_ABORTED] = "XDP_ABORTED",
+	[XDP_DROP] = "XDP_DROP",
+	[XDP_PASS] = "XDP_PASS",
+	[XDP_TX] = "XDP_TX",
+	[XDP_REDIRECT] = "XDP_REDIRECT",
+};
+
+static struct btf *xdp_program__btf(struct xdp_program *xdp_prog)
+{
+	return xdp_prog->btf;
+}
+
+void xdp_program__set_chain_call_enabled(struct xdp_program *prog, unsigned int action,
+					 bool enabled)
+{
+	/* FIXME: Should this also update the BTF info? */
+	if (enabled)
+		prog->chain_call_actions |= (1<<action);
+	else
+		prog->chain_call_actions &= ~(1<<action);
+}
+
+bool xdp_program__chain_call_enabled(struct xdp_program *prog,
+				     enum xdp_action action)
+{
+	return !!(prog->chain_call_actions & (1<<action));
+}
+
+unsigned int xdp_program__run_prio(struct xdp_program *prog)
+{
+	return prog->run_prio;
+}
+
+void xdp_program__set_run_prio(struct xdp_program *prog, unsigned int run_prio)
+{
+	/* FIXME: Should this also update the BTF info? */
+	prog->run_prio = run_prio;
+}
+
+const char *xdp_program__name(struct xdp_program *prog)
+{
+	return prog->prog_name;
+}
+
+int xdp_program__print_chain_call_actions(struct xdp_program *prog,
+					  char *buf,
+					  size_t buf_len)
+{
+	bool first = true;
+	char *pos = buf;
+	size_t len = 0;
+	int i;
+
+	for (i = 0; i <= XDP_REDIRECT; i++) {
+		if (xdp_program__chain_call_enabled(prog, i)) {
+			if (!first) {
+				*pos++ = ',';
+				buf_len--;
+			} else {
+				first = false;
+			}
+			len = snprintf(pos, buf_len-len, "%s",
+				       xdp_action_names[i]);
+			pos += len;
+			buf_len -= len;
+		}
+	}
+	return 0;
+}
+
+static const struct btf_type *
+skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
+{
+	const struct btf_type *t = btf__type_by_id(btf, id);
+
+	if (res_id)
+		*res_id = id;
+
+	while (btf_is_mod(t) || btf_is_typedef(t)) {
+		if (res_id)
+			*res_id = t->type;
+		t = btf__type_by_id(btf, t->type);
+	}
+
+	return t;
+}
+
+static bool get_field_int(const char *prog_name, const struct btf *btf,
+			  const struct btf_type *def,
+			  const struct btf_member *m, __u32 *res)
+{
+	const struct btf_type *t = skip_mods_and_typedefs(btf, m->type, NULL);
+	const char *name = btf__name_by_offset(btf, m->name_off);
+	const struct btf_array *arr_info;
+	const struct btf_type *arr_t;
+
+	if (!btf_is_ptr(t)) {
+		pr_warn("prog '%s': attr '%s': expected PTR, got %u.\n",
+			prog_name, name, btf_kind(t));
+		return false;
+	}
+
+	arr_t = btf__type_by_id(btf, t->type);
+	if (!arr_t) {
+		pr_warn("prog '%s': attr '%s': type [%u] not found.\n",
+			prog_name, name, t->type);
+		return false;
+	}
+	if (!btf_is_array(arr_t)) {
+		pr_warn("prog '%s': attr '%s': expected ARRAY, got %u.\n",
+			prog_name, name, btf_kind(arr_t));
+		return false;
+	}
+	arr_info = btf_array(arr_t);
+	*res = arr_info->nelems;
+	return true;
+}
+
+static bool get_xdp_action(const char *act_name, unsigned int *act)
+{
+	const char **name = xdp_action_names;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(xdp_action_names); i++, name++) {
+		if (!strcmp(act_name, *name)) {
+			*act = i;
+			return true;
+		}
+	}
+	return false;
+}
+
+/**
+ * This function parses the run config information attached to an XDP program.
+ *
+ * This information is specified using BTF, in a format similar to how
+ * BTF-defined maps are done. The definition looks like this:
+ *
+ * struct {
+ *	__uint(priority, 10);
+ *	__uint(XDP_PASS, 1);
+ * } XDP_RUN_CONFIG(FUNCNAME);
+ *
+ * The priority is simply an integer that will be used to sort programs as they
+ * are attached on the interface (see cmp_xdp_programs() for full sort order).
+ * In addition to the priority, the run config can define an integer value for
+ * each XDP action. A non-zero value means that execution will continue to the
+ * next loaded program if the current program returns that action. I.e., in the
+ * above example, any return value other than XDP_PASS will cause the dispatcher
+ * to exit with that return code, whereas XDP_PASS means execution will
+ * continue.
+ *
+ * Since this information becomes part of the object file BTF info, it will
+ * survive loading into the kernel, and so it can be retrieved for
+ * already-loaded programs as well.
+ */
+static int xdp_parse_run_config(struct xdp_program *xdp_prog)
+{
+	const struct btf_type *t, *var, *def, *sec = NULL;
+	struct btf *btf = xdp_program__btf(xdp_prog);
+	int err, nr_types, i, j, vlen, mlen;
+	const struct btf_var_secinfo *vi;
+	const struct btf_var *var_extra;
+	const struct btf_member *m;
+	char struct_name[100];
+	const char *name;
+
+	if (!btf) {
+		pr_debug("No BTF found for program\n");
+		return -ENOENT;
+	}
+
+	err = check_snprintf(struct_name, sizeof(struct_name), "_%s",
+			     xdp_program__name(xdp_prog));
+	if (err)
+		return err;
+
+	nr_types = btf__get_nr_types(btf);
+	for (i = 1; i <= nr_types; i++) {
+		t = btf__type_by_id(btf, i);
+		if (!btf_is_datasec(t))
+			continue;
+		name = btf__name_by_offset(btf, t->name_off);
+		if (strcmp(name, XDP_RUN_CONFIG_SEC) == 0) {
+			sec = t;
+			break;
+		}
+	}
+
+	if (!sec) {
+		pr_debug("DATASEC '%s' not found.\n", XDP_RUN_CONFIG_SEC);
+		return -ENOENT;
+	}
+
+	vlen = btf_vlen(sec);
+	vi = btf_var_secinfos(sec);
+	for (i = 0; i < vlen; i++, vi++) {
+		var = btf__type_by_id(btf, vi->type);
+		var_extra = btf_var(var);
+		name = btf__name_by_offset(btf, var->name_off);
+
+		if (strcmp(name, struct_name))
+			continue;
+
+		if (!btf_is_var(var)) {
+			pr_warn("struct '%s': unexpected var kind %u.\n",
+				name, btf_kind(var));
+			return -EINVAL;
+		}
+		if (var_extra->linkage != BTF_VAR_GLOBAL_ALLOCATED &&
+		    var_extra->linkage != BTF_VAR_STATIC) {
+			pr_warn("struct '%s': unsupported var linkage %u.\n",
+				name, var_extra->linkage);
+			return -EOPNOTSUPP;
+		}
+
+		def = skip_mods_and_typedefs(btf, var->type, NULL);
+		if (!btf_is_struct(def)) {
+			pr_warn("struct '%s': unexpected def kind %u.\n",
+				name, btf_kind(var));
+			return -EINVAL;
+		}
+		if (def->size > vi->size) {
+			pr_warn("struct '%s': invalid def size.\n", name);
+			return -EINVAL;
+		}
+
+		mlen = btf_vlen(def);
+		m = btf_members(def);
+		for (j = 0; j < mlen; j++, m++) {
+			const char *mname = btf__name_by_offset(btf, m->name_off);
+			unsigned int val, act;
+
+			if (!mname) {
+				pr_warn("struct '%s': invalid field #%d.\n", name, i);
+				return -EINVAL;
+			}
+			if (!strcmp(mname, "priority")) {
+				if (!get_field_int(struct_name, btf, def, m,
+						   &xdp_prog->run_prio))
+					return -EINVAL;
+				continue;
+			} else if(get_xdp_action(mname, &act)) {
+				if (!get_field_int(struct_name, btf, def, m,
+						   &val))
+					return -EINVAL;
+				xdp_program__set_chain_call_enabled(xdp_prog, act, val);
+			} else {
+				pr_warn("Invalid mname: %s\n", mname);
+				return -ENOTSUP;
+			}
+		}
+		return 0;
+	}
+
+	pr_debug("Couldn't find run order struct %s\n", struct_name);
+	return -ENOENT;
+}
+
+static struct xdp_program *xdp_program__new()
+{
+	struct xdp_program *xdp_prog;
+
+	xdp_prog = malloc(sizeof(*xdp_prog));
+	if (!xdp_prog)
+		return ERR_PTR(-ENOMEM);
+
+	memset(xdp_prog, 0, sizeof(*xdp_prog));
+
+	xdp_prog->prog_fd = -1;
+	xdp_prog->link_fd = -1;
+	xdp_prog->run_prio = XDP_DEFAULT_RUN_PRIO;
+	xdp_prog->chain_call_actions = XDP_DEFAULT_CHAIN_CALL_ACTIONS;
+
+	return xdp_prog;
+}
+
+void xdp_program__free(struct xdp_program *xdp_prog)
+{
+	if (xdp_prog->link_fd >= 0)
+		close(xdp_prog->link_fd);
+	if (xdp_prog->prog_fd >= 0)
+		close(xdp_prog->prog_fd);
+
+	if (!xdp_prog->from_external_obj) {
+		if (xdp_prog->bpf_obj)
+			bpf_object__close(xdp_prog->bpf_obj);
+		else if (xdp_prog->btf)
+			btf__free(xdp_prog->btf);
+	}
+}
+
+static int xdp_program__fill_from_obj(struct xdp_program *xdp_prog,
+				      struct bpf_object *obj,
+				      const char *prog_name,
+				      bool external)
+{
+	struct bpf_program *bpf_prog;
+	int err;
+
+	if (prog_name)
+		bpf_prog = bpf_object__find_program_by_title(obj, prog_name);
+	else
+		bpf_prog = bpf_program__next(NULL, obj);
+
+	if(!bpf_prog)
+		return -ENOENT;
+
+	xdp_prog->bpf_prog = bpf_prog;
+	xdp_prog->bpf_obj = obj;
+	xdp_prog->btf = bpf_object__btf(obj);
+	xdp_prog->from_external_obj = external;
+	xdp_prog->prog_name = bpf_program__name(bpf_prog);
+
+	err = xdp_parse_run_config(xdp_prog);
+	if (err && err != -ENOENT)
+		return err;
+
+	return 0;
+}
+
+struct xdp_program *xdp_program__from_bpf_obj(struct bpf_object *obj,
+					      const char *prog_name)
+{
+	struct xdp_program *xdp_prog;
+	int err;
+
+	xdp_prog = xdp_program__new();
+	if (IS_ERR(xdp_prog))
+		return xdp_prog;
+
+	err = xdp_program__fill_from_obj(xdp_prog, obj, prog_name, true);
+	if (err)
+		goto err;
+
+	return xdp_prog;
+err:
+	xdp_program__free(xdp_prog);
+	return ERR_PTR(err);
+}
+
+struct xdp_program *xdp_program__open_file(const char *filename,
+					   const char *prog_name,
+					   struct bpf_object_open_opts *opts)
+{
+	struct xdp_program *xdp_prog;
+	struct bpf_object *obj;
+	int err;
+
+	obj = bpf_object__open_file(filename, opts);
+	err = libbpf_get_error(obj);
+	if (err)
+		return ERR_PTR(err);
+
+	xdp_prog = xdp_program__new();
+	if (IS_ERR(xdp_prog)) {
+		bpf_object__close(obj);
+		return xdp_prog;
+	}
+
+	err = xdp_program__fill_from_obj(xdp_prog, obj, prog_name, false);
+	if (err)
+		goto err;
+
+	return xdp_prog;
+err:
+	xdp_program__free(xdp_prog);
+	bpf_object__close(obj);
+	return ERR_PTR(err);
+}
+
+static int xdp_program__fill_from_fd(struct xdp_program *xdp_prog, int fd)
+{
+	struct bpf_prog_info info = {};
+	__u32 len = sizeof(info);
+	struct btf *btf = NULL;
+	int err = 0;
+
+	err = bpf_obj_get_info_by_fd(fd, &info, &len);
+	if (err) {
+		pr_warn("couldn't get program info: %s", strerror(errno));
+		err = -errno;
+		goto err;
+	}
+
+	if (!xdp_prog->prog_name) {
+		xdp_prog->prog_name = strdup(info.name);
+		if (!xdp_prog->prog_name) {
+			err = -ENOMEM;
+			pr_warn("failed to strdup program title");
+			goto err;
+		}
+	}
+
+	if (info.btf_id && !xdp_prog->btf) {
+		err = btf__get_from_id(info.btf_id, &btf);
+		if (err) {
+			pr_warn("Couldn't get BTF for ID %ul\n", info.btf_id);
+			goto err;
+		}
+		xdp_prog->btf = btf;
+	}
+
+	memcpy(xdp_prog->prog_tag, info.tag, BPF_TAG_SIZE);
+	xdp_prog->load_time = info.load_time;
+	xdp_prog->prog_fd = fd;
+
+	return 0;
+err:
+	btf__free(btf);
+	return err;
+}
+
+struct xdp_program *xdp_program__from_id(__u32 id)
+{
+	struct xdp_program *xdp_prog = NULL;
+	int fd, err;
+
+	fd = bpf_prog_get_fd_by_id(id);
+	if (fd < 0) {
+		pr_warn("couldn't get program fd: %s", strerror(errno));
+		err = -errno;
+		goto err;
+	}
+
+	xdp_prog = xdp_program__new();
+	if (IS_ERR(xdp_prog))
+		return xdp_prog;
+
+	err = xdp_program__fill_from_fd(xdp_prog, fd);
+	if (err)
+		goto err;
+
+	err = xdp_parse_run_config(xdp_prog);
+	if (err && err != -ENOENT)
+		goto err;
+
+	return xdp_prog;
+err:
+	free(xdp_prog);
+	return ERR_PTR(err);
+}
+
+static int cmp_xdp_programs(const void *_a, const void *_b)
+{
+	const struct xdp_program *a = *(struct xdp_program * const *)_a;
+	const struct xdp_program *b = *(struct xdp_program * const *)_b;
+	int cmp;
+
+	if (a->run_prio != b->run_prio)
+		return a->run_prio < b->run_prio ? -1 : 1;
+
+	cmp = strcmp(a->prog_name, b->prog_name);
+	if (cmp)
+		return cmp;
+
+	/* Hopefully the two checks above will resolve most comparisons; in
+	 * cases where they don't, hopefully the checks below will keep the
+	 * order stable.
+	 */
+
+	/* loaded before non-loaded */
+	if (a->prog_fd >= 0 && b->prog_fd < 0)
+		return -1;
+	else if (a->prog_fd < 0 && b->prog_fd >= 0)
+		return 1;
+
+	/* two unloaded programs - compare by size */
+	if (a->bpf_prog && b->bpf_prog) {
+		size_t size_a, size_b;
+
+		size_a = bpf_program__size(a->bpf_prog);
+		size_b = bpf_program__size(b->bpf_prog);
+		if (size_a != size_b)
+			return size_a < size_b ? -1 : 1;
+	}
+
+	cmp = memcmp(a->prog_tag, b->prog_tag, BPF_TAG_SIZE);
+	if (cmp)
+		return cmp;
+
+	/* at this point we are really grasping for straws */
+	if (a->load_time != b->load_time)
+		return a->load_time < b->load_time ? -1 : 1;
+
+	return 0;
+}
+
+int xdp_program__get_from_ifindex(int ifindex, struct xdp_program **progs,
+				  size_t *num_progs)
+{
+	struct xdp_link_info xinfo = {};
+	struct xdp_program *p;
+	__u32 prog_id;
+	int err;
+
+	err = bpf_get_link_xdp_info(ifindex, &xinfo, sizeof(xinfo), 0);
+	if (err)
+		return err;
+
+	if (xinfo.attach_mode == XDP_ATTACHED_SKB)
+		prog_id = xinfo.skb_prog_id;
+	else
+		prog_id = xinfo.drv_prog_id;
+
+	if (!prog_id)
+		return -ENOENT;
+
+	p = xdp_program__from_id(prog_id);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	/* FIXME: This should figure out whether the loaded program is a
+	 * dispatcher, and if it is, go find the component programs and return
+	 * those instead.
+	 */
+	progs[0] = p;
+	*num_progs = 1;
+
+	return 0;
+}
+
+int xdp_program__load(struct xdp_program *prog)
+{
+	int err;
+
+	if (prog->prog_fd >= 0)
+		return -EEXIST;
+
+	if (!prog->bpf_obj)
+		return -EINVAL;
+
+	err = bpf_object__load(prog->bpf_obj);
+	if (err)
+		return err;
+
+	pr_debug("Loaded XDP program %s, got fd %d\n",
+		 xdp_program__name(prog), bpf_program__fd(prog->bpf_prog));
+
+	return xdp_program__fill_from_fd(prog, bpf_program__fd(prog->bpf_prog));
+}
+
+int gen_xdp_multiprog(struct xdp_program **progs, size_t num_progs)
+{
+	struct bpf_program *dispatcher_prog;
+	struct bpf_map *prog_config_map;
+	int fd, prog_fd, err, i, lfd;
+	struct xdp_dispatcher_config *rodata;
+	struct xdp_program *prog;
+	struct bpf_object *obj;
+	struct stat sb = {};
+	char buf[PATH_MAX];
+	void *ptr = NULL;
+	size_t sz = 0;
+
+	/* The only way libbpf exposes access to the rodata section is through
+	 * the skeleton API. We need to modify it before loading a program,
+	 * hence all this boilerplate code, until we can fix libbpf to just
+	 * expose map->mmaped directly.
+	 */
+	struct bpf_prog_skeleton prog_skel = {
+		.name = "xdp_main",
+		.prog = &dispatcher_prog
+	};
+	struct bpf_map_skeleton map_skel = {
+		.name = "xdp_disp.rodata",
+		.map = &prog_config_map,
+		.mmaped = (void **)&rodata
+	};
+
+	struct bpf_object_skeleton s = {
+		.sz = sizeof(s),
+		.name = "xdp_dispatcher",
+		.obj = &obj,
+		.map_cnt = 1,
+		.map_skel_sz = sizeof(map_skel),
+		.maps = &map_skel,
+		.prog_cnt = 1,
+		.prog_skel_sz = sizeof(prog_skel),
+		.progs = &prog_skel
+	};
+
+	pr_debug("Generating multi-prog dispatcher for %zu programs\n", num_progs);
+
+	err = find_bpf_file(buf, sizeof(buf), "xdp-dispatcher.o");
+	if (err)
+		return err;
+
+	fd = open(buf, O_RDONLY);
+	if (fd < 0) {
+		err = -errno;
+		pr_warn("Couldn't open BPF file %s\n", buf);
+		return err;
+	}
+
+	err = fstat(fd, &sb);
+	if (err)
+		goto err;
+	sz = sb.st_size;
+
+	ptr = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (ptr == MAP_FAILED) {
+		err = -errno;
+		ptr = NULL;
+		pr_warn("Couldn't mmap BPF file\n");
+		goto err;
+	}
+	s.data = ptr;
+	s.data_sz = sz;
+
+	err = bpf_object__open_skeleton(&s, NULL);
+	if (err)
+		goto err;
+
+	munmap(ptr, sz);
+	ptr = NULL;
+	close(fd);
+	fd = -1;
+
+	if (!rodata) {
+		pr_warn("No mmaped rodat map area\n");
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* set dispatcher parameters before loading */
+	rodata->num_progs_enabled = num_progs;
+	for (i = 0; i < num_progs; i++)
+		rodata->chain_call_actions[i] = progs[i]->chain_call_actions;
+
+	err = bpf_object__load(obj);
+	if (err)
+		goto err;
+
+	prog_fd = bpf_program__fd(dispatcher_prog);
+	for (i = 0; i < num_progs; i++) {
+		prog = progs[i];
+		err = check_snprintf(buf, sizeof(buf), "prog%d", i);
+		if (err)
+			goto err_obj;
+
+		/* FIXME: The following assumes the component XDP programs are
+		 * not already loaded. We do want to be able to re-attach
+		 * already-loaded programs into a new dispatcher here; but the
+		 * kernel doesn't currently allow this. So for now, just assume
+		 * programs are not already loaded and load them as TYPE_EXT
+		 * programs.
+		 */
+
+		err = bpf_program__set_attach_target(prog->bpf_prog, prog_fd,
+						     buf);
+		if (err) {
+			pr_debug("Failed to set attach target: %s\n", strerror(-err));
+			goto err_obj;
+		}
+
+		bpf_program__set_type(prog->bpf_prog, BPF_PROG_TYPE_EXT);
+		err = xdp_program__load(prog);
+		if (err) {
+			pr_warn("Failed to load program %d ('%s'): %s\n",
+				i, xdp_program__name(prog), strerror(-err));
+			goto err_obj;
+		}
+
+		/* The attach will disappear once this fd is closed */
+		lfd = bpf_raw_tracepoint_open(NULL, prog->prog_fd);
+		if (lfd < 0) {
+			err = lfd;
+			pr_warn("Failed to attach program %d ('%s') to dispatcher: %s\n",
+				i, xdp_program__name(prog), strerror(-err));
+			goto err_obj;
+		}
+
+		pr_debug("Attached prog '%s' with priority %d in dispatcher entry '%s' with fd %d\n",
+			 xdp_program__name(prog), xdp_program__run_prio(prog),
+			 buf, lfd);
+		prog->link_fd = lfd;
+	}
+
+	return prog_fd;
+
+err_obj:
+	bpf_object__close(obj);
+err:
+	if (ptr)
+		munmap(ptr, sz);
+	if (fd > -1)
+		close(fd);
+	return err;
+}
+
+int xdp_attach_programs(struct xdp_program **progs, size_t num_progs,
+			int ifindex, bool force, enum xdp_attach_mode mode)
+{
+	int err = 0, xdp_flags = 0, prog_fd;
+
+	if (!num_progs)
+		return -EINVAL;
+
+	if (num_progs > 1) {
+		qsort(progs, num_progs, sizeof(*progs), cmp_xdp_programs);
+		prog_fd = gen_xdp_multiprog(progs, num_progs);
+	} else if (progs[0]->prog_fd >= 0) {
+		prog_fd = progs[0]->prog_fd;
+	} else {
+		prog_fd = xdp_program__load(progs[0]);
+	}
+
+	if (prog_fd < 0) {
+		err = prog_fd;
+		goto out;
+	}
+
+	pr_debug("Loading XDP fd %d onto ifindex %d\n", prog_fd, ifindex);
+
+	switch (mode) {
+	case XDP_MODE_SKB:
+		xdp_flags |= XDP_FLAGS_SKB_MODE;
+		break;
+	case XDP_MODE_NATIVE:
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+		break;
+	case XDP_MODE_HW:
+		xdp_flags |= XDP_FLAGS_HW_MODE;
+		break;
+	case XDP_MODE_UNSPEC:
+		break;
+	}
+
+	if (!force)
+		xdp_flags |= XDP_FLAGS_UPDATE_IF_NOEXIST;
+
+	err = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
+	if (err == -EEXIST && !(xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
+		/* Program replace didn't work, probably because a program of
+		 * the opposite type is loaded. Let's unload that and try
+		 * loading again.
+		 */
+
+		__u32 old_flags = xdp_flags;
+
+		xdp_flags &= ~XDP_FLAGS_MODES;
+		xdp_flags |= (mode == XDP_MODE_SKB) ? XDP_FLAGS_DRV_MODE :
+			XDP_FLAGS_SKB_MODE;
+		err = bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+		if (!err)
+			err = bpf_set_link_xdp_fd(ifindex, prog_fd, old_flags);
+	}
+	if (err < 0) {
+		pr_warn("Error attaching XDP program to ifindex %d: %s\n",
+			ifindex, strerror(-err));
+
+		switch (-err) {
+		case EBUSY:
+		case EEXIST:
+			pr_warn("XDP already loaded on device;"
+				" use --force to replace\n");
+			break;
+		case EOPNOTSUPP:
+			pr_warn("Native XDP not supported;"
+				" try using --skb-mode\n");
+			break;
+		default:
+			break;
+		}
+		goto out;
+	}
+
+	pr_debug("Loaded %zu programs on ifindex '%d'%s\n",
+		 num_progs, ifindex,
+		 mode == XDP_MODE_SKB ? " in skb mode" : "");
+
+	return prog_fd;
+out:
+	return err;
+}
+
+
+int xdp_program__attach(const struct xdp_program *prog,
+			int ifindex, bool replace, enum xdp_attach_mode mode)
+{
+	struct xdp_program *old_progs[10], *all_progs[10];
+	size_t num_old_progs = 10, num_progs;
+	int err, i;
+
+	/* FIXME: The idea here is that the API should allow the caller to just
+	 * attach a program; and the library will take care of finding the
+	 * already-attached programs, inserting the new one into the sequence
+	 * based on its priority, build a new dispatcher, and atomically replace
+	 * the old one. This needs a kernel API to allow re-attaching already
+	 * loaded freplace programs, as well as the ability to attach each
+	 * program to multiple places. So for now, this function doesn't really
+	 * work.
+	 */
+	err = xdp_program__get_from_ifindex(ifindex, old_progs, &num_old_progs);
+	if (err && err != -ENOENT)
+		return err;
+
+	if (replace) {
+		num_progs = 1;
+		all_progs[0] = (struct xdp_program *)prog;
+	} else {
+		for (i = 0; i < num_old_progs; i++)
+			all_progs[i] = old_progs[i];
+		num_progs = num_old_progs +1;
+	}
+
+	err = xdp_attach_programs(all_progs, num_progs, ifindex, true, mode);
+	if (err)
+		return err;
+	return 0;
+}
diff --git a/tools/lib/xdp/libxdp.h b/tools/lib/xdp/libxdp.h
new file mode 100644
index 000000000000..2ee960ec68b9
--- /dev/null
+++ b/tools/lib/xdp/libxdp.h
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+
+/*
+ * XDP management utility functions
+ *
+ * Copyright (C) 2020 Toke Høiland-Jørgensen <toke@redhat.com>
+ */
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include "xdp_helpers.h"
+#include "util.h"
+
+struct xdp_program;
+
+struct xdp_program *xdp_program__from_bpf_obj(struct bpf_object *obj,
+					      const char *prog_name);
+struct xdp_program *xdp_program__open_file(const char *filename,
+					   const char *prog_name,
+					   struct bpf_object_open_opts *opts);
+struct xdp_program *xdp_program__from_id(__u32 prog_id);
+
+void xdp_program__free(struct xdp_program *xdp_prog);
+
+const char *xdp_program__name(struct xdp_program *xdp_prog);
+unsigned int xdp_program__run_prio(struct xdp_program *xdp_prog);
+void xdp_program__set_run_prio(struct xdp_program *xdp_prog, unsigned int run_prio);
+bool xdp_program__chain_call_enabled(struct xdp_program *xdp_prog,
+				     enum xdp_action action);
+void xdp_program__set_chain_call_enabled(struct xdp_program *prog, unsigned int action,
+                                         bool enabled);
+
+int xdp_program__print_chain_call_actions(struct xdp_program *prog,
+					  char *buf,
+					  size_t buf_len);
+
+int xdp_attach_programs(struct xdp_program **progs, size_t num_progs,
+                        int ifindex, bool force, enum xdp_attach_mode mode);
diff --git a/tools/lib/xdp/prog_dispatcher.h b/tools/lib/xdp/prog_dispatcher.h
new file mode 100644
index 000000000000..25311dc137ff
--- /dev/null
+++ b/tools/lib/xdp/prog_dispatcher.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-2-clause) */
+
+#ifndef __PROG_DISPATCHER_H
+#define __PROG_DISPATCHER_H
+
+#include <linux/types.h>
+
+#ifndef MAX_DISPATCHER_ACTIONS
+#define MAX_DISPATCHER_ACTIONS 10
+#endif
+
+struct xdp_dispatcher_config {
+	__u8 num_progs_enabled;
+	__u32 chain_call_actions[MAX_DISPATCHER_ACTIONS];
+};
+
+#endif
diff --git a/tools/lib/xdp/xdp-dispatcher.c b/tools/lib/xdp/xdp-dispatcher.c
new file mode 100644
index 000000000000..0d965c48bdb8
--- /dev/null
+++ b/tools/lib/xdp/xdp-dispatcher.c
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#include <xdp/prog_dispatcher.h>
+
+/* While 'const volatile' sounds a little like an oxymoron, there's reason
+ * behind the madness:
+ *
+ * - const places the data in rodata, where libbpf will mark it as read-only and
+ *   frozen on program load, letting the kernel do dead code elimination based
+ *   on the values.
+ *
+ * - volatile prevents the compiler from optimising away the checks based on the
+ *   compile-time value of the variables, which is important since we will be
+ *   changing the values before loading the program into the kernel.
+ */
+static volatile const struct xdp_dispatcher_config conf = {};
+
+/* The volatile return value prevents the compiler from assuming it knows the
+ * return value and optimising based on that.
+ */
+__attribute__ ((noinline))
+int prog0(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog1(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog2(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog3(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog4(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog5(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog6(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog7(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog8(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+__attribute__ ((noinline))
+int prog9(struct xdp_md *ctx) {
+        volatile int ret = XDP_PASS;
+
+        if (!ctx)
+          return XDP_ABORTED;
+        return ret;
+}
+
+
+SEC("xdp_dispatcher")
+int xdp_main(struct xdp_md *ctx)
+{
+        __u8 num_progs_enabled = conf.num_progs_enabled;
+        int ret;
+
+        if (num_progs_enabled < 1)
+                goto out;
+        ret = prog0(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[0]))
+                return ret;
+
+        if (num_progs_enabled < 2)
+                goto out;
+        ret = prog1(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[1]))
+                return ret;
+
+        if (num_progs_enabled < 3)
+                goto out;
+        ret = prog2(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[2]))
+                return ret;
+
+        if (num_progs_enabled < 4)
+                goto out;
+        ret = prog3(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[3]))
+                return ret;
+
+        if (num_progs_enabled < 5)
+                goto out;
+        ret = prog4(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[4]))
+                return ret;
+
+        if (num_progs_enabled < 6)
+                goto out;
+        ret = prog5(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[5]))
+                return ret;
+
+        if (num_progs_enabled < 7)
+                goto out;
+        ret = prog6(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[6]))
+                return ret;
+
+        if (num_progs_enabled < 8)
+                goto out;
+        ret = prog7(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[7]))
+                return ret;
+
+        if (num_progs_enabled < 9)
+                goto out;
+        ret = prog8(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[8]))
+                return ret;
+
+        if (num_progs_enabled < 10)
+                goto out;
+        ret = prog9(ctx);
+        if (!((1 << ret) & conf.chain_call_actions[9]))
+                return ret;
+
+out:
+        return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/lib/xdp/xdp_helpers.h b/tools/lib/xdp/xdp_helpers.h
new file mode 100644
index 000000000000..ec295367a8a0
--- /dev/null
+++ b/tools/lib/xdp/xdp_helpers.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-2-clause) */
+
+#ifndef __XDP_HELPERS_H
+#define __XDP_HELPERS_H
+
+#define _CONCAT(x,y) x ## y
+#define XDP_RUN_CONFIG(f) _CONCAT(_,f) SEC(".xdp_run_config")
+
+#define XDP_DEFAULT_RUN_PRIO 50
+#define XDP_DEFAULT_CHAIN_CALL_ACTIONS (1<<XDP_PASS)
+
+#endif

