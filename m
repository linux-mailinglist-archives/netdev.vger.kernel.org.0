Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CE2CBC9D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbfJDOF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:05:29 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42828 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388270AbfJDOF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:05:29 -0400
Received: by mail-io1-f67.google.com with SMTP id n197so13720095iod.9;
        Fri, 04 Oct 2019 07:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bDTKfu+ejKRK+adYoy6fnBSPT/VXZuxJ5Rl3WF3I6Pg=;
        b=kRtH8CQfWnRBUhEmC0zRYmi7cDsFLuqwYdIG8u1iEixXil+XlY2RJDtn+k9mZbZrS6
         pMKLCGEcOSDqYI7IYKqtR9PYrcQheBkLaAXbTtBSiYUyGNypdNIGFkdqJs8e3ai9fqIT
         462TSgElW52mhpof/fOqfFr3De3aIovIfpN4lCxnOtGCDQR5mnJKzuk7gQyQmfZRuRtP
         Zns36ekzyY37DWhA4ve8cB4TbQ3sDSw7Mm26yv3knVRjD4eRGrdxFfE1a41agB7n8CE+
         mm0gLqKHkXBxHN/xrx/zKEkE0yhd2N8OGRgfz30O+4IRKF+fM5FBf5s5a4nmjpu+Jq2U
         0D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bDTKfu+ejKRK+adYoy6fnBSPT/VXZuxJ5Rl3WF3I6Pg=;
        b=ouMIIEozBpGI8f31xvV2UkywMThb9L0Iix5zwKqDAJXd5wuOC6c36VMBnfzU94s5at
         UzRqp6Pmr9lfEoaJZhl9oa8aXvrVt/JCd4cIephMjId/bS/0aKWxUmx2pJGAjBnP5BkY
         ihvK8sEq3GE9v15lKr/zy6GNbuxnxPJdiO39nsllWfdxDHs1hNsnc7yA7ShMH5JiTj92
         goKqlYFw85rqcl+WfJs1qYAI+ahFq9w6xGGOeojrxftjK897Ir9eKeQs4xd1ZxWLys2m
         DuIZm90/uyDbvlGMP/L/x8eCGTsOyND9rELs5vBq/Ron682NKETTvFvzRuU3k9kU7uqq
         dQfQ==
X-Gm-Message-State: APjAAAWe7QbXBaavKYdXWpA3mR/u0wsUnpugNTYg0HZj6ccFlYBh4lKO
        DScq+RnQwGIl4zeqUp15btdvTYFmBx8=
X-Google-Smtp-Source: APXvYqzM7GbCzI1E1SVWT93K2qa5R0zjAa634eIT9NaeJf2U3wd1Yw9Oc+Om1CcdHmleJH8VoUr3BQ==
X-Received: by 2002:a5e:c241:: with SMTP id w1mr1690679iop.36.1570197926614;
        Fri, 04 Oct 2019 07:05:26 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l186sm2399905ioa.54.2019.10.04.07.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 07:05:25 -0700 (PDT)
Date:   Fri, 04 Oct 2019 07:05:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d97519e9e7f3_4e6d2b183260e5bcbf@john-XPS-13-9370.notmuch>
In-Reply-To: <20191004030058.2248514-2-andriin@fb.com>
References: <20191004030058.2248514-1-andriin@fb.com>
 <20191004030058.2248514-2-andriin@fb.com>
Subject: RE: [PATCH bpf-next 1/2] libbpf: stop enforcing kern_version,
 populate it for users
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Kernel version enforcement for kprobes/kretprobes was removed from
> 5.0 kernel in 6c4fc209fcf9 ("bpf: remove useless version check for prog load").
> Since then, BPF programs were specifying SEC("version") just to please
> libbpf. We should stop enforcing this in libbpf, if even kernel doesn't
> care. Furthermore, libbpf now will pre-populate current kernel version
> of the host system, in case we are still running on old kernel.
> 
> This patch also removes __bpf_object__open_xattr from libbpf.h, as
> nothing in libbpf is relying on having it in that header. That function
> was never exported as LIBBPF_API and even name suggests its internal
> version. So this should be safe to remove, as it doesn't break ABI.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c                        | 79 ++++++-------------
>  tools/lib/bpf/libbpf.h                        |  2 -
>  .../selftests/bpf/progs/test_attach_probe.c   |  1 -
>  .../bpf/progs/test_get_stack_rawtp.c          |  1 -
>  .../selftests/bpf/progs/test_perf_buffer.c    |  1 -
>  .../selftests/bpf/progs/test_stacktrace_map.c |  1 -
>  6 files changed, 22 insertions(+), 63 deletions(-)

[...]

>  static struct bpf_object *
> -__bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
> -		   bool needs_kver, int flags)
> +__bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
> +		   int flags)
>  {
>  	struct bpf_object *obj;
>  	int err;
> @@ -3617,7 +3585,6 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
>  	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
>  	CHECK_ERR(bpf_object__elf_collect(obj, flags), err, out);

If we are not going to validate the section should we also skip collect'ing it?

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..22a458cd602c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1567,12 +1567,6 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
                                                       data->d_size);
                        if (err)
                                return err;
-               } else if (strcmp(name, "version") == 0) {
-                       err = bpf_object__init_kversion(obj,
-                                                       data->d_buf,
-                                                       data->d_size);
-                       if (err)
-                               return err;
                } else if (strcmp(name, "maps") == 0) {
                        obj->efile.maps_shndx = idx;
                } else if (strcmp(name, MAPS_ELF_SEC) == 0) {


>  	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
> -	CHECK_ERR(bpf_object__validate(obj, needs_kver), err, out);
>  
>  	bpf_object__elf_finish(obj);
>  	return obj;
> @@ -3626,8 +3593,8 @@ __bpf_object__open(const char *path, void *obj_buf, size_t obj_buf_sz,
>  	return ERR_PTR(err);
>  }
