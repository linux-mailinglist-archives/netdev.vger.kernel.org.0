Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA525E36D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgIDVpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgIDVpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:45:22 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFD3C061244;
        Fri,  4 Sep 2020 14:45:21 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id p6so5349306ybk.10;
        Fri, 04 Sep 2020 14:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RNnBMYaj8AWCa7vdMI51j0bw8ftf1o5SqrZT0PbE4v0=;
        b=omI7yJpdvd0tPcT17qcbQC59dM8u1qPeZ6cGaD7PTNmYi8d1RAIgz2zlGg5LH1J3Ur
         copFsxA3j4OcV0nfI33ouJHcMHx9H0LI/EU6L1ZA8B/VrxjRUdQYNz0brKEByCW8uYqt
         iM2/nkkY5sMMsnhlB73AjgjhlvzEjGIjLtXBlmsqFtbXmBXMIMHsEOKNOXFa3ZuaQuJJ
         Yi+rLZWeQ+7vpy2tX2RC7jxGaLE6hCO7VGPgE7K8FUaKmfN1Jh2WmABCK0w8eP5pm6rW
         Jsf98TK5U7W4MkFgqkwwgui1dl5sjCy6rLUokpN29fBNfjArDfBG+7pR1rUNFifo5eeR
         zpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RNnBMYaj8AWCa7vdMI51j0bw8ftf1o5SqrZT0PbE4v0=;
        b=SLetuZlf4pyHsdVmYAOFcteqXXaKijmmUJIyMooHFd4v9WbkxOpZKyIfyBo/ZL/idg
         ShWw4VjxCyb0sxT4k5H/h0nKbcZyWewmjbOtXDXxeMAJUJt33E9T5u94aiSVKJqu9CoI
         ctSzdgbVcAwPAt7mhm0N+d832rwCAMlW/CgrbXCnThLcSdamokGsIERr7WhhVWUliRjN
         GFAkcANYOjOHrdCrNNa2atfiTJ9e1C4hg9rWgX2P9vx3P1fBicKwDL1CVTTN2NAbHfra
         /ZzlnBBb/gqkpqq6keTZkfG50O1S7A9jTpCjt4ufJbGuYTop8KddOA6Zb3LFvkeBcfbH
         m5Cg==
X-Gm-Message-State: AOAM5314IsJeNVTapdb2by8JdkBZvJfFUtvceTQkgIU7Z65DJQ26ERCC
        Yu1zRpBBv3gF1J6LMpAE5+jzHHgJZTMsmxuGCEM=
X-Google-Smtp-Source: ABdhPJwoo4krDZoErzkdnX1Ow6pRJcS2RvaSGLvaIMlPVb0358npGRkfICUbv62QokgVyKFf1Jl0N26NIae0efoSW3E=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr12238024ybe.510.1599255920753;
 Fri, 04 Sep 2020 14:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200904205657.27922-1-quentin@isovalent.com> <20200904205657.27922-2-quentin@isovalent.com>
In-Reply-To: <20200904205657.27922-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 14:45:10 -0700
Message-ID: <CAEf4Bzbf_igYVP+NfrVV86AZGQT7+2NF1JR6GzcEOymV9_vgNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] tools: bpftool: print optional built-in
 features along with version
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 1:57 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool has a number of features that can be included or left aside
> during compilation. This includes:
>
> - Support for libbfd, providing the disassembler for JIT-compiled
>   programs.
> - Support for BPF skeletons, used for profiling programs or iterating on
>   the PIDs of processes associated with BPF objects.
>
> In order to make it easy for users to understand what features were
> compiled for a given bpftool binary, print the status of the two
> features above when showing the version number for bpftool ("bpftool -V"
> or "bpftool version"). Document this in the main manual page. Example
> invocation:
>
>     $ bpftool -p version
>     {
>         "version": "5.9.0-rc1",
>         "features": [
>             "libbfd": true,
>             "skeletons": true
>         ]

Is this a valid JSON? array of key/value pairs?

>     }
>
> Some other parameters are optional at compilation
> ("DISASM_FOUR_ARGS_SIGNATURE", LIBCAP support) but they do not impact
> significantly bpftool's behaviour from a user's point of view, so their
> status is not reported.
>
> Available commands and supported program types depend on the version
> number, and are therefore not reported either. Note that they are
> already available, albeit without JSON, via bpftool's help messages.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool.rst |  8 +++++++-
>  tools/bpf/bpftool/main.c                    | 22 +++++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
> index 420d4d5df8b6..a3629a3f1175 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool.rst
> @@ -50,7 +50,13 @@ OPTIONS
>                   Print short help message (similar to **bpftool help**).
>
>         -V, --version
> -                 Print version number (similar to **bpftool version**).
> +                 Print version number (similar to **bpftool version**), and
> +                 optional features that were included when bpftool was
> +                 compiled. Optional features include linking against libbfd to
> +                 provide the disassembler for JIT-ted programs (**bpftool prog
> +                 dump jited**) and usage of BPF skeletons (some features like
> +                 **bpftool prog profile** or showing pids associated to BPF
> +                 objects may rely on it).

nit: I'd emit it as a list, easier to see list of features visually

>
>         -j, --json
>                   Generate JSON output. For commands that cannot produce JSON, this
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 4a191fcbeb82..2ae8c0d82030 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -70,13 +70,35 @@ static int do_help(int argc, char **argv)
>
>  static int do_version(int argc, char **argv)
>  {
> +#ifdef HAVE_LIBBFD_SUPPORT
> +       const bool has_libbfd = true;
> +#else
> +       const bool has_libbfd = false;
> +#endif
> +#ifdef BPFTOOL_WITHOUT_SKELETONS
> +       const bool has_skeletons = false;
> +#else
> +       const bool has_skeletons = true;
> +#endif
> +
>         if (json_output) {
>                 jsonw_start_object(json_wtr);
> +
>                 jsonw_name(json_wtr, "version");
>                 jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
> +
> +               jsonw_name(json_wtr, "features");
> +               jsonw_start_array(json_wtr);
> +               jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
> +               jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
> +               jsonw_end_array(json_wtr);
> +
>                 jsonw_end_object(json_wtr);
>         } else {
>                 printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
> +               printf("features: libbfd=%s, skeletons=%s\n",
> +                      has_libbfd ? "true" : "false",
> +                      has_skeletons ? "true" : "false");

now imagine parsing this with CLI text tools, you'll have to find
"skeletons=(false|true)" and then parse "true" to know skeletons are
supported. Why not just print out features that are supported?

>         }
>         return 0;
>  }
> --
> 2.25.1
>
