Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A9C2E336
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfE2R1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:27:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39173 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfE2R1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:27:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id i125so2000154qkd.6;
        Wed, 29 May 2019 10:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMy8ZEY2Y23QzTFGZvChoPurhtqnRLcjF45a9p240bg=;
        b=fYHg6EMAle6dpyQpEfbmaOhny7uxMFOOLWPCxFjoBKrBAkjdy0cZSWQgBp7xuFwT3W
         Mc4UyIPOgjuZoSH69K0vXyUBxWjY+FMyYawwewOngjq3a8jNdfcRWw0E6E/VS/M3woCD
         Qf9bd2U0EzWxmw6HY3JLMyyswP6o07+83DZpJzt3CQBU8XsfzDscW+AZ697fCqxisjrW
         w3gSMoDFT3x1Ys9+S5na8UmCJdL8miyTCAEtzh0Ie3fuogh/mIOfsqHkq3X4V9dMuxan
         LvKszk7BJ2gxi14SJ+XY/Id+f9G6Mf7+FM+UY+x/YhqAPULtEaMI8kDCxz+hxE6pY/tO
         Mf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMy8ZEY2Y23QzTFGZvChoPurhtqnRLcjF45a9p240bg=;
        b=oSLVoCOoY6Of7jf2Uck6/7TV0qH+Ti8zIkoEIiZWeI69YO4xL782SpmYF4T2d1hYji
         kl4Y9KLDqn+GrqTSGMtXNjA3IgbUjWLwXJVd+vKFqRBcaRIllWXXXRdFpuuwCv+tS74g
         cipexKTlHFB8eEhLavFfFw4g7lp7+GdA2plrgA9S29KaPqCA+D7ClkzIFeb1P8XUzcu7
         wuSun+EiwF5P7ZSjgeh6yVv+NRYgN9StNEavMEfyfb4y90tP5dQkK2FasHLvh6o5b3Nq
         NNqEo5jLubgpeGHIkYEh4o3FQYUo5zHn87W/o1Oe619Z6drmmVbV+8fjb1iFHsDDa+xS
         Vong==
X-Gm-Message-State: APjAAAWa6f+vS3eo+zFfhNOcNdFWj0AXcDNKa18pYXsjZkJJSoexqwu/
        9fizJVe5G/cg+MWJu8oyeM/jmfiJHWi/ISAFql0=
X-Google-Smtp-Source: APXvYqz6P7Ndj7REm3VkR8uSToBs7eq5ofCOakpreDqX3LsYWgM8UYk9UFDwpDgg+QU2IiY09tcvecuyETupHr5gQ8g=
X-Received: by 2002:a05:620a:12f8:: with SMTP id f24mr12709239qkl.202.1559150832682;
 Wed, 29 May 2019 10:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-10-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-10-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:27:01 -0700
Message-ID: <CAPhsuW61Q8vH_yhoemN8-Nm+cKhY5nkt4aOeK-5rUJ=0vEzOVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 9/9] libbpf: reduce unnecessary line wrapping
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> There are a bunch of lines of code or comments that are unnecessary
> wrapped into multi-lines. Fix that without violating any code
> guidelines.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
>  tools/lib/bpf/libbpf.c | 52 +++++++++++++-----------------------------
>  1 file changed, 16 insertions(+), 36 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 9d9c19a1b2fe..2c576843ea40 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -497,8 +497,7 @@ static struct bpf_object *bpf_object__new(const char *path,
>
>         strcpy(obj->path, path);
>         /* Using basename() GNU version which doesn't modify arg. */
> -       strncpy(obj->name, basename((void *)path),
> -               sizeof(obj->name) - 1);
> +       strncpy(obj->name, basename((void *)path), sizeof(obj->name) - 1);
>         end = strchr(obj->name, '.');
>         if (end)
>                 *end = 0;
> @@ -578,15 +577,13 @@ static int bpf_object__elf_init(struct bpf_object *obj)
>         }
>
>         if (!obj->efile.elf) {
> -               pr_warning("failed to open %s as ELF file\n",
> -                               obj->path);
> +               pr_warning("failed to open %s as ELF file\n", obj->path);
>                 err = -LIBBPF_ERRNO__LIBELF;
>                 goto errout;
>         }
>
>         if (!gelf_getehdr(obj->efile.elf, &obj->efile.ehdr)) {
> -               pr_warning("failed to get EHDR from %s\n",
> -                               obj->path);
> +               pr_warning("failed to get EHDR from %s\n", obj->path);
>                 err = -LIBBPF_ERRNO__FORMAT;
>                 goto errout;
>         }
> @@ -622,18 +619,15 @@ static int bpf_object__check_endianness(struct bpf_object *obj)
>  }
>
>  static int
> -bpf_object__init_license(struct bpf_object *obj,
> -                        void *data, size_t size)
> +bpf_object__init_license(struct bpf_object *obj, void *data, size_t size)
>  {
> -       memcpy(obj->license, data,
> -              min(size, sizeof(obj->license) - 1));
> +       memcpy(obj->license, data, min(size, sizeof(obj->license) - 1));
>         pr_debug("license of %s is %s\n", obj->path, obj->license);
>         return 0;
>  }
>
>  static int
> -bpf_object__init_kversion(struct bpf_object *obj,
> -                         void *data, size_t size)
> +bpf_object__init_kversion(struct bpf_object *obj, void *data, size_t size)
>  {
>         __u32 kver;
>
> @@ -643,8 +637,7 @@ bpf_object__init_kversion(struct bpf_object *obj,
>         }
>         memcpy(&kver, data, sizeof(kver));
>         obj->kern_version = kver;
> -       pr_debug("kernel version of %s is %x\n", obj->path,
> -                obj->kern_version);
> +       pr_debug("kernel version of %s is %x\n", obj->path, obj->kern_version);
>         return 0;
>  }
>
> @@ -800,8 +793,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
>         def->key_size = sizeof(int);
>         def->value_size = data->d_size;
>         def->max_entries = 1;
> -       def->map_flags = type == LIBBPF_MAP_RODATA ?
> -                        BPF_F_RDONLY_PROG : 0;
> +       def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
>         if (data_buff) {
>                 *data_buff = malloc(data->d_size);
>                 if (!*data_buff) {
> @@ -816,8 +808,7 @@ bpf_object__init_internal_map(struct bpf_object *obj, struct bpf_map *map,
>         return 0;
>  }
>
> -static int
> -bpf_object__init_maps(struct bpf_object *obj, int flags)
> +static int bpf_object__init_maps(struct bpf_object *obj, int flags)
>  {
>         int i, map_idx, map_def_sz = 0, nr_syms, nr_maps = 0, nr_maps_glob = 0;
>         bool strict = !(flags & MAPS_RELAX_COMPAT);
> @@ -1098,8 +1089,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
>
>         /* Elf is corrupted/truncated, avoid calling elf_strptr. */
>         if (!elf_rawdata(elf_getscn(elf, ep->e_shstrndx), NULL)) {
> -               pr_warning("failed to get e_shstrndx from %s\n",
> -                          obj->path);
> +               pr_warning("failed to get e_shstrndx from %s\n", obj->path);
>                 return -LIBBPF_ERRNO__FORMAT;
>         }
>
> @@ -1340,8 +1330,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>         size_t nr_maps = obj->nr_maps;
>         int i, nrels;
>
> -       pr_debug("collecting relocating info for: '%s'\n",
> -                prog->section_name);
> +       pr_debug("collecting relocating info for: '%s'\n", prog->section_name);
>         nrels = shdr->sh_size / shdr->sh_entsize;
>
>         prog->reloc_desc = malloc(sizeof(*prog->reloc_desc) * nrels);
> @@ -1366,9 +1355,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>                         return -LIBBPF_ERRNO__FORMAT;
>                 }
>
> -               if (!gelf_getsym(symbols,
> -                                GELF_R_SYM(rel.r_info),
> -                                &sym)) {
> +               if (!gelf_getsym(symbols, GELF_R_SYM(rel.r_info), &sym)) {
>                         pr_warning("relocation: symbol %"PRIx64" not found\n",
>                                    GELF_R_SYM(rel.r_info));
>                         return -LIBBPF_ERRNO__FORMAT;
> @@ -1817,18 +1804,14 @@ check_btf_ext_reloc_err(struct bpf_program *prog, int err,
>         if (btf_prog_info) {
>                 /*
>                  * Some info has already been found but has problem
> -                * in the last btf_ext reloc.  Must have to error
> -                * out.
> +                * in the last btf_ext reloc. Must have to error out.
>                  */
>                 pr_warning("Error in relocating %s for sec %s.\n",
>                            info_name, prog->section_name);
>                 return err;
>         }
>
> -       /*
> -        * Have problem loading the very first info.  Ignore
> -        * the rest.
> -        */
> +       /* Have problem loading the very first info. Ignore the rest. */
>         pr_warning("Cannot find %s for main program sec %s. Ignore all %s.\n",
>                    info_name, prog->section_name, info_name);
>         return 0;
> @@ -2032,9 +2015,7 @@ static int bpf_object__collect_reloc(struct bpf_object *obj)
>                         return -LIBBPF_ERRNO__RELOC;
>                 }
>
> -               err = bpf_program__collect_reloc(prog,
> -                                                shdr, data,
> -                                                obj);
> +               err = bpf_program__collect_reloc(prog, shdr, data, obj);
>                 if (err)
>                         return err;
>         }
> @@ -2354,8 +2335,7 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
>                          (unsigned long)obj_buf_sz);
>                 name = tmp_name;
>         }
> -       pr_debug("loading object '%s' from buffer\n",
> -                name);
> +       pr_debug("loading object '%s' from buffer\n", name);
>
>         return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
>  }
> --
> 2.17.1
>
