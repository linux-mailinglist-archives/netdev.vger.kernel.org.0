Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2100A49666C
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiAUUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 15:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiAUUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:40:36 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05137C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:40:36 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id x26so1868426ljd.4
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 12:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SPAewH5gwxk3lAPR+3a4FCetLTARWfupHt55i1LGa8k=;
        b=Lu8EltZ7MbIM9Zjijlk1VXVbYtvyAsGnUdEsQ8HpvnJAAYxTuVmoO98Kmz6kEkrGMD
         GrJjIztnj1CvlzFo7JVk4FjerrgNjX3iApCaynMYMz2CsmQiMofWfJrUqaI7eWD4qkwL
         XMLzQroOFjLDLQaoVlf7eIJ1XzWev93dJd+OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SPAewH5gwxk3lAPR+3a4FCetLTARWfupHt55i1LGa8k=;
        b=w2E9N+Kny4T0hXuCdLUQC+iIL3d37NoLUw30/rD9S241VkPBbpV+7uGtfD0wULMAUy
         NeLR+KQ2xyHfX1u+JQimwBHpcefApRqiDJxQF4wUJcuFqetOnRG/m3fr8KlSttwG7mkm
         JwXqhyBMYK7vu2+AGWbU+kCg1QIrb18y6iFTD2ixzNKtPBID2WkLkNEXV+B9nJU8ZrNv
         M9B/cGAun6OAVOns6Qb5gb447Y07vFffo6gJ+WPIyPhph0z63aGAaRmiK5dMMa1+38X/
         lAuldPQLxDd0NJD6cegw2tjpEUKt5ROkUTXJwOMVIIiXJvCkbXM81YnrF3RJg/+g9o3Q
         eKRw==
X-Gm-Message-State: AOAM530EF4rGLKUiWjoy7wwbLc0IVAONKfqCmpu2mgQvl6FYsBtUEAUS
        izQS0Fm+4H521x1/Av7YZoVHJM80HhRSknm7oGEsQQ==
X-Google-Smtp-Source: ABdhPJyqsSheZOO/5zva4gv4fV73HsdBSEsrgV80cCZSJJv9K6jdZ92cLYG3ImBGWZF8JdLhFv2DNPcL5u4t5B+0POg=
X-Received: by 2002:a2e:b8c7:: with SMTP id s7mr4412304ljp.60.1642797634072;
 Fri, 21 Jan 2022 12:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-4-mauricio@kinvolk.io>
 <33e77eec-524a-ffb0-9efc-a58da532a578@isovalent.com>
In-Reply-To: <33e77eec-524a-ffb0-9efc-a58da532a578@isovalent.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 21 Jan 2022 15:40:22 -0500
Message-ID: <CAHap4ztH=EbFMtj1h5s3-23h06u_L3o8NU9cOL=6nzENZiq_XA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/8] bpftool: Add gen btf command
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 1:08 PM Quentin Monnet <quentin@isovalent.com> wrot=
e:
>
> 2022-01-12 09:27 UTC-0500 ~ Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > This command is implemented under the "gen" command in bpftool and the
> > syntax is the following:
> >
> > $ bpftool gen btf INPUT OUTPUT OBJECT(S)
>
> Thanks a lot for this work!
>
> Please update the relevant manual page under Documentation, to let users
> know how to use the feature. You may also consider adding an example at
> the end of that document.
>

We're working on it, and will be part of the next spin.

> The bash completion script should also be updated with the new "btf"
> subcommand for "gen". Given that all the arguments are directories and
> files, it should not be hard.
>

Will do.

> Have you considered adding tests for the feature? There are a few
> bpftool-related selftests under tools/testing/selftests/bpf/.
>

Yes, we have but it seems not that trivial. One idea I have is to
include a couple of BTF source files from
https://github.com/aquasecurity/btfhub-archive/ and create a test
program that generates some field, type and enum relocations. Then we
could check if the generated BTF file has the expected types, fields
and so on by parsing it and using the BTF API from libbpf. One concern
about it is the size of those two source BTF files (~5MB each),
perhaps we should not include a full file but something that is
already "trimmed"? Another possibility is to use
"/sys/kernel/btf/vmlinux" but it'll limit the test to machines with
CONFIG_DEBUG_INFO_BTF.

Do you have any ideas / feedback on this one? Should the tests be
included in this series or can we push them later on?

> >
> > INPUT can be either a single BTF file or a folder containing BTF files,
> > when it's a folder, a BTF file is generated for each BTF file contained
> > in this folder. OUTPUT is the file (or folder) where generated files ar=
e
> > stored and OBJECT(S) is the list of bpf objects we want to generate the
> > BTF file(s) for (each generated BTF file contains all the types needed
> > by all the objects).
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/bpf/bpftool/gen.c | 117 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 117 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 43e3f8700ecc..cdeb1047d79d 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -5,6 +5,7 @@
> >  #define _GNU_SOURCE
> >  #endif
> >  #include <ctype.h>
> > +#include <dirent.h>
> >  #include <errno.h>
> >  #include <fcntl.h>
> >  #include <linux/err.h>
> > @@ -1084,6 +1085,7 @@ static int do_help(int argc, char **argv)
> >       fprintf(stderr,
> >               "Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FI=
LE...]\n"
> >               "       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
> > +             "       %1$s %2$s btf INPUT OUTPUT OBJECT(S)\n"
> >               "       %1$s %2$s help\n"
> >               "\n"
> >               "       " HELP_SPEC_OPTIONS " |\n"
> > @@ -1094,9 +1096,124 @@ static int do_help(int argc, char **argv)
> >       return 0;
> >  }
> >
> > +/* Create BTF file for a set of BPF objects */
> > +static int btfgen(const char *src_btf, const char *dst_btf, const char=
 *objspaths[])
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static int is_file(const char *path)
> > +{
> > +     struct stat st;
> > +
> > +     if (stat(path, &st) < 0)
> > +             return -1;
> > +
> > +     switch (st.st_mode & S_IFMT) {
> > +     case S_IFDIR:
> > +             return 0;
> > +     case S_IFREG:
> > +             return 1;
> > +     default:
> > +             return -1;
> > +     }
> > +}
> > +
> > +static int do_gen_btf(int argc, char **argv)
> > +{
> > +     char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
> > +     bool input_is_file, output_is_file =3D false;
> > +     const char *input, *output;
> > +     const char **objs =3D NULL;
> > +     struct dirent *dir;
> > +     DIR *d =3D NULL;
> > +     int i, err;
> > +
> > +     if (!REQ_ARGS(3)) {
> > +             usage();
> > +             return -1;
> > +     }
> > +
> > +     input =3D GET_ARG();
> > +     err =3D is_file(input);
> > +     if (err < 0) {
> > +             p_err("failed to stat %s: %s", input, strerror(errno));
> > +             return err;
> > +     }
> > +     input_is_file =3D err;
> > +
> > +     output =3D GET_ARG();
> > +     err =3D is_file(output);
> > +     if (err !=3D 0)
> > +             output_is_file =3D true;
>
> Why not return if err < 0? This will set output_is_file to true and will
> fail later, I think?
>

I knew it was going to be confusing. is_file() returns -1 when the
file is not found, for the output one it's not a big deal as we're
going to create it, so this logic was correct. I decided to drop this
is_file() function and using stat() directly in the code.

> > +
> > +     objs =3D (const char **) malloc((argc + 1) * sizeof(*objs));
> > +     if (!objs)
> > +             return -ENOMEM;
>
> Let's p_err() a message.
>
> > +
> > +     i =3D 0;
> > +     while (argc > 0)
> > +             objs[i++] =3D GET_ARG();
> > +
> > +     objs[i] =3D NULL;
> > +
> > +     /* single BTF file */
> > +     if (input_is_file) {
> > +             printf("SBTF: %s\n", input);
>
> We can use "p_info()" instead of "printf()". In particular, this avoids
> printing the message when the JSON output is required.
>
> > +
> > +             if (output_is_file) {
> > +                     err =3D btfgen(input, output, objs);
> > +                     goto out;
> > +             }
> > +             snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", out=
put,
> > +                      basename(input));
>
> Am I right that the output file should be just a file name, and not a
> path, and that it will be created under the same directory as the input
> file?

No exactly. There are two ways we support (1) the source BTF file is a
single file and (2) it's a folder containing BTF files.
For the first case, we require the output path to be a file or a
folder and the second case requires the output to be a folder. The
reason we don't generate the files in the same input folder is that
the user can have a library with a lot of BTF files (like
https://github.com/aquasecurity/btfhub-archive/) and you don't want to
pollute it with the files you generate.

> And that providing a relative or absolute path instead will cause
> issues here? If so, please document it. It would be nice to be able to
> support paths too, but I'm not sure how much work that represents.
>

I tried with absolute and relative paths and it seems to work fine.

> > +             err =3D btfgen(input, dst_btf_path, objs);
> > +             goto out;
> > +     }
> > +
> > +     if (output_is_file) {
> > +             p_err("can't have just one file as output");
>
> See comment above, this message is misleading if stat() returned with an
> error.
>
> > +             err =3D -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     /* directory with BTF files */
> > +     d =3D opendir(input);
> > +     if (!d) {
> > +             p_err("error opening input dir: %s", strerror(errno));
> > +             err =3D -errno;
> > +             goto out;
> > +     }
> > +
> > +     while ((dir =3D readdir(d)) !=3D NULL) {
> > +             if (dir->d_type !=3D DT_REG)
> > +                     continue;
> > +
> > +             if (strncmp(dir->d_name + strlen(dir->d_name) - 4, ".btf"=
, 4))
> > +                     continue;
> > +
> > +             snprintf(src_btf_path, sizeof(src_btf_path), "%s/%s", inp=
ut, dir->d_name);
> > +             snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", out=
put, dir->d_name);
> > +
> > +             printf("SBTF: %s\n", src_btf_path);
> > +
> > +             err =3D btfgen(src_btf_path, dst_btf_path, objs);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +
> > +out:
> > +     if (!err)
> > +             printf("STAT: done!\n");
>
> p_info()
>
> > +     free(objs);
> > +     closedir(d);
>
> If input is a single file, "d" will not be a valid directory stream
> descriptor, and I expect closedir() to fail and set errno even if
> everything else went fine. The return code does not matter, but "errno
> !=3D 0" may cause bpftool's batch mode to error out. Can you please run
> closedir() only "if (d)"?
>

Yes, you're totally right.





> > +     return err;
> > +}
> > +
> >  static const struct cmd cmds[] =3D {
> >       { "object",     do_object },
> >       { "skeleton",   do_skeleton },
> > +     { "btf",        do_gen_btf},
> >       { "help",       do_help },
> >       { 0 }
> >  };
>
