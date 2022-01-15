Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497C748F44E
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiAOCJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiAOCJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:09:50 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EBCC061574;
        Fri, 14 Jan 2022 18:09:50 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id v17so2178911ilg.4;
        Fri, 14 Jan 2022 18:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yJJXFXwDuA6TsUr0tR9KlBAJIXjs/afmjZHAGye8Lgc=;
        b=KW55wvnbvB52DkPilJLKstPj+0aqvusOmtS2U2vMWGyXxRD16+dRLGYUK4QLoZ9gGb
         sy6Gz0GVPLXgtfitYu5sgSfuHpcgcyK6cbAZryZBRECOCIdhuYkFxhUFl7qBZfdTq5At
         u0nRDKJZNCca6AghMPweKBz2WE93ZVdz+4dUkvYr4iEiZZph113+f6nvcInpwZzhkwVB
         EJzzN1/CEFdyrgHtwg21c0/xn3XsMNvRtQWHsGcw4xl+DSMxEF5q8QRqWkQkrumffiv5
         w3gws/K+M8b1wQGETW3qjkvHQvFhrePlf98a/rYb8pIcmOumtTyejkT97yBGuW7vyLP9
         jvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yJJXFXwDuA6TsUr0tR9KlBAJIXjs/afmjZHAGye8Lgc=;
        b=AZjzxpsW4pIz7SA03bM4X0LjltIgGSEUUhz54G1n3QmkOaHk1Gxc2fWt6OsoOBC0dH
         M3JYzHcPI+8gM73nJQQdcG2miI6deq8jPydvMxz+5PpzPvWmaVQqLFhB9PpaswUwBacA
         Hxl+F21xbZE6I4a8iIdZNvNq4cqUd1ztWCNK56eNKn1jK4hVuizA+wM7VKR0mO985vFd
         bEAp57vffv4mrostg2scC7WsnVLVCUpsyTmiD+EBJbVzzIMhI1huWyZhx9GYHRndVHnX
         PPN0Iz92Tc791+uLCSKSvw++p8MCDaSPksThH6G7H96GeWC8CCiIdLRpNkiZk94rbVH5
         9POw==
X-Gm-Message-State: AOAM532fn2fFpuYiWJw4waFVjMTOzMggEeuOcrR+HKYu3+EvxcPDp71T
        s32cDdJnQU27seIG6DNc3jel51LY0oWrbvjGUHo=
X-Google-Smtp-Source: ABdhPJydAqQ+y+egtf4+eaUM0Gctqsj5aYo/3fBzlFaJf19BivGj183h4I1pNLolhaiP3UAQi24YVRDUacOSa1aclCE=
X-Received: by 2002:a05:6e02:1748:: with SMTP id y8mr6271898ill.305.1642212589691;
 Fri, 14 Jan 2022 18:09:49 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-4-mauricio@kinvolk.io>
In-Reply-To: <20220112142709.102423-4-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 18:09:38 -0800
Message-ID: <CAEf4BzZ2LEFzX1VoWY_NNowbS2+j04pCWS4DdrDi5nFe7CvcXw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/8] bpftool: Add gen btf command
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> This command is implemented under the "gen" command in bpftool and the
> syntax is the following:
>
> $ bpftool gen btf INPUT OUTPUT OBJECT(S)

"gen btf" doesn't really convey that it's a minimized BTF for CO-RE,
maybe let's do something more verbose but also more precise, it's not
like this is going to be used by everyone multiple times a day, so
verboseness is not a bad thing here. Naming is hard, but something
like `bpftool gen min_core_btf` probably would give a bit better
pointer as to what this command is doing (minimal CO-RE BTF, right?)

>
> INPUT can be either a single BTF file or a folder containing BTF files,
> when it's a folder, a BTF file is generated for each BTF file contained
> in this folder. OUTPUT is the file (or folder) where generated files are
> stored and OBJECT(S) is the list of bpf objects we want to generate the
> BTF file(s) for (each generated BTF file contains all the types needed
> by all the objects).
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 117 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
>

[...]

> +
> +       while ((dir =3D readdir(d)) !=3D NULL) {
> +               if (dir->d_type !=3D DT_REG)
> +                       continue;
> +
> +               if (strncmp(dir->d_name + strlen(dir->d_name) - 4, ".btf"=
, 4))
> +                       continue;
> +
> +               snprintf(src_btf_path, sizeof(src_btf_path), "%s/%s", inp=
ut, dir->d_name);
> +               snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", out=
put, dir->d_name);
> +
> +               printf("SBTF: %s\n", src_btf_path);

What's SBTF? Is this part of bpftool "protocol" now? It should be
something a bit more meaningful...

> +
> +               err =3D btfgen(src_btf_path, dst_btf_path, objs);
> +               if (err)
> +                       goto out;
> +       }
> +
> +out:
> +       if (!err)
> +               printf("STAT: done!\n");

similar, STAT? what's that? Do we need "done!" message in tool's output?

> +       free(objs);
> +       closedir(d);
> +       return err;
> +}
> +
>  static const struct cmd cmds[] =3D {
>         { "object",     do_object },
>         { "skeleton",   do_skeleton },
> +       { "btf",        do_gen_btf},
>         { "help",       do_help },
>         { 0 }
>  };
> --
> 2.25.1
>
