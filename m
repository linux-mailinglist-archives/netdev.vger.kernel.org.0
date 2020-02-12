Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED915AECB
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgBLRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:34:33 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36740 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgBLRec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:34:32 -0500
Received: by mail-qt1-f195.google.com with SMTP id t13so2212188qto.3;
        Wed, 12 Feb 2020 09:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tIHXn6N00kGFOZyvCFeSbdqF+gyL/3bpmWiyT3M77oM=;
        b=IDIJoEKEkINhB4MgwGYgRQ4JTnT6k/5qFsNMx3NHVKHQSpVzihvgbokWLPv4kPu7Qr
         cH3NvHe2Vk5dMq95r8WEbHR9sRsJQvpKk2tiZu3G8toU9C9K8v0GjRPiCual7yUQFO8S
         icI3RJjkFvoeOaohHLL9+kK5FBCvXOAP7x9mL1Jka7Zs6KhNOSrI0INcwyco3iuR9UGT
         3bPAwxGJ1Vn3B3tobwciCcvbP0dgQdqktSmmlGqpZ/sZ+zJxB7sdu+iWYaXgs2PCUoWQ
         efaKyNZQRuL9yjpG59Lyhou/j3L8/WSqNhEzRjR0hv5dC+S4wjO3mjX5WeelPe6W3fn/
         nAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tIHXn6N00kGFOZyvCFeSbdqF+gyL/3bpmWiyT3M77oM=;
        b=tXrVmXol7C+kryu0JARDhQg+YR8faENaxcZBnyKPtApjeiQLs3eX5SpiiudxUHhqSi
         TiVTaO7qkRgcK4pRwj+enjjTz8I/3YOPCipMCNIUvSzpAqOBDeAxOVJKQXTn+kItdLsq
         PiL1gjJ+OEKPK+2CA6siuBqCypHdTScqL0oFq1WEyp1FhoSYy0ZxyZC9NOPS+tVLgcdH
         OZR+HqlcrF/CSaE6ohYgDgsUqCgWey0DRSQdckVaEiYctwpOlIhkAbrv9nPrDaxnYr1r
         CUv1xNJlNwkW8c8Z7RPLQGJVKRbOPpRlYepi51aQTuszb/krnim+cgtXrJOolDuG9r1T
         GCrQ==
X-Gm-Message-State: APjAAAU/DH+N2ycFgw+YS6xHfgeLRaJgpTzeKjPtkCx0xUyArMD3nFBv
        CiiQM4iTP0nCSdQa6RFlgWhUK4i6AduL5I+u0JApxO78trs=
X-Google-Smtp-Source: APXvYqx8BKrKGyS+EFvMSc5E6o6FbR71IFBxNop2UVZqkfmO7IjVIaJkOOaLLpCxrWSzxtUsIFg4PUXXi9ZtqtnkYZs=
X-Received: by 2002:a37:785:: with SMTP id 127mr12141727qkh.437.1581528869534;
 Wed, 12 Feb 2020 09:34:29 -0800 (PST)
MIME-Version: 1.0
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
In-Reply-To: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Feb 2020 09:34:18 -0800
Message-ID: <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach target
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 4:32 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Currently when you want to attach a trace program to a bpf program
> the section name needs to match the tracepoint/function semantics.
>
> However the addition of the bpf_program__set_attach_target() API
> allows you to specify the tracepoint/function dynamically.
>
> The call flow would look something like this:
>
>   xdp_fd = bpf_prog_get_fd_by_id(id);
>   trace_obj = bpf_object__open_file("func.o", NULL);
>   prog = bpf_object__find_program_by_title(trace_obj,
>                                            "fentry/myfunc");
>   bpf_program__set_attach_target(prog, xdp_fd,
>                                  "fentry/xdpfilt_blk_all");
>   bpf_object__load(trace_obj)
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c   |   41 +++++++++++++++++++++++++++++++++++------
>  tools/lib/bpf/libbpf.h   |    4 ++++
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 40 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 514b1a524abb..2ce879c301bb 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4933,15 +4933,16 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         return ret;
>  }
>
> -static int libbpf_find_attach_btf_id(struct bpf_program *prog);
> +static int libbpf_find_attach_btf_id(struct bpf_program *prog,
> +                                    const char *name);
>
>  int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>  {
>         int err = 0, fd, i, btf_id;
>
> -       if (prog->type == BPF_PROG_TYPE_TRACING ||
> -           prog->type == BPF_PROG_TYPE_EXT) {
> -               btf_id = libbpf_find_attach_btf_id(prog);
> +       if ((prog->type == BPF_PROG_TYPE_TRACING ||
> +            prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> +               btf_id = libbpf_find_attach_btf_id(prog, NULL);
>                 if (btf_id <= 0)
>                         return btf_id;
>                 prog->attach_btf_id = btf_id;
> @@ -6202,6 +6203,31 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
>         prog->expected_attach_type = type;
>  }
>
> +int bpf_program__set_attach_target(struct bpf_program *prog,
> +                                  int attach_prog_fd,
> +                                  const char *attach_func_name)
> +{
> +       __u32 org_attach_prog_fd;
> +       int btf_id;
> +
> +       if (!prog || attach_prog_fd < 0 || !attach_func_name)
> +               return -EINVAL;
> +
> +       org_attach_prog_fd = prog->attach_prog_fd;
> +       prog->attach_prog_fd = attach_prog_fd;
> +
> +       btf_id = libbpf_find_attach_btf_id(prog,
> +                                          attach_func_name);
> +
> +       if (btf_id < 0) {
> +               prog->attach_prog_fd = org_attach_prog_fd;

I don't think there is a need to restore original attach_prog_fd (most
probably it's going to be invalid either way). If explicit
set_attach_target fails, user application will have to fail or do some
other set_attach_target call.

> +               return btf_id;
> +       }
> +
> +       prog->attach_btf_id = btf_id;
> +       return 0;
> +}
> +
>  #define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, atype) \
>         { string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype }
>
> @@ -6633,13 +6659,16 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
>         return err;
>  }
>
> -static int libbpf_find_attach_btf_id(struct bpf_program *prog)
> +static int libbpf_find_attach_btf_id(struct bpf_program *prog,
> +                                    const char *name)
>  {
>         enum bpf_attach_type attach_type = prog->expected_attach_type;
>         __u32 attach_prog_fd = prog->attach_prog_fd;
> -       const char *name = prog->section_name;
>         int i, err;
>
> +       if (!name)
> +               name = prog->section_name;
> +

I second Toke, name should be just a function name, not including
"fentry/" (and others) part. If user want to programmatically
set/override attach type, we already have
bpf_program__set_expected_attach_type() API for that. So this
function's logic should do prefix/name extraction from
prog->section_name only if name is not explicitly specified.

>         if (!name)
>                 return -EINVAL;
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 3fe12c9d1f92..02fc58a21a7f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -334,6 +334,10 @@ LIBBPF_API void
>  bpf_program__set_expected_attach_type(struct bpf_program *prog,
>                                       enum bpf_attach_type type);
>
> +LIBBPF_API int
> +bpf_program__set_attach_target(struct bpf_program *prog, int attach_prog_fd,
> +                              const char *attach_func_name);
> +
>  LIBBPF_API bool bpf_program__is_socket_filter(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program *prog);
>  LIBBPF_API bool bpf_program__is_raw_tracepoint(const struct bpf_program *prog);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b035122142bb..8aba5438a3f0 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -230,6 +230,7 @@ LIBBPF_0.0.7 {
>                 bpf_program__name;
>                 bpf_program__is_extension;
>                 bpf_program__is_struct_ops;
> +               bpf_program__set_attach_target;
>                 bpf_program__set_extension;
>                 bpf_program__set_struct_ops;
>                 btf__align_of;
>
