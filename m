Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A887DE0B69
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfJVS26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:28:58 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43441 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbfJVS26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:28:58 -0400
Received: by mail-qt1-f193.google.com with SMTP id t20so28221583qtr.10;
        Tue, 22 Oct 2019 11:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cn+ppTScQdfWATo7w7y1J4IsnYoScI94OveDbV3GFYg=;
        b=X2C6c+OYefC+Unlt04CBW++2sriVFP1yev2ECzn7Z/nzl/ubseuICw4Hiu7MZw7kOS
         Retdgsg0Px+kZ0tAwOt3hwIED/FBw4SEUrwd03BWCb4Fdh/s5hJaGZwhU5dFAnjMbanF
         ZNRB9uRfMAVdQZVF6vSVufFc02kYaqlij2BZFG4ai8WLLPxbeEhvsGIglGf2RpRN2HsC
         uQDJZtPkf0nN+JgQ8B56XWZzD+1XovAdSVlcOfwYtWc0wAFiQBYaBx8lH8sQbpcqyvlZ
         SOu6nBRvbR1SLThULe/m3SIbcOtEfqvXM4Oqy5r5syfAEvkvUCeQdHeN0dp/BdXeEbyj
         4oIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cn+ppTScQdfWATo7w7y1J4IsnYoScI94OveDbV3GFYg=;
        b=Posaq3Qv3u9bOB/+thJnyYvN0IH7h0AWqZ9KrZ0d1In4vsqviPA6OtBy8DB/5JiJ+h
         EjRlXAS76CFm8+DCsS2+lGS5F/mFTcPK1hV7uh4hHAgwKCt9zSaTlFgTWYB74tC0jsah
         T0GhtixDmV0m63MuS4Zolgvjz9Rpd+SyGpWHk2pJKtub4zQtA9/2hJC5GwXarr44sb65
         /UgeEvSXO/6a+XLHtfNGFH3H1xp3L/q/8Zv5Aa639Ac6veMKmoHloXaDeUkdrakru3Dv
         REiMxzofGKCv683wa+FeANAu+ThnFIZjKThojuZI5dHNVZ5ua9AElAmfrmDDwGhEGZHR
         21Sw==
X-Gm-Message-State: APjAAAUJ1xJkY9reSTjWynfXocuQh//70oPJTJVDPiCuu1wAoKmcLg8z
        3pvA7urcBkpHOFC2XY3aAfETn2n8KQxdD1LjU5c=
X-Google-Smtp-Source: APXvYqzTbnZEuBPnUSa+LWn+RKoAajOGxDdvvPou17S0PycvlskFR9kxaPbxzZterZ2tSNN3puhexlSVWBiHoGULqm4=
X-Received: by 2002:ac8:1242:: with SMTP id g2mr4836878qtj.141.1571768936334;
 Tue, 22 Oct 2019 11:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175669103.112621.7847833678119315310.stgit@toke.dk>
In-Reply-To: <157175669103.112621.7847833678119315310.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 11:28:45 -0700
Message-ID: <CAEf4BzbfV5vrFnkNyG35Db2iPmM2ubtFh6OTvLiaetAx6eFHHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Add pin option to automount BPF
 filesystem before pinning
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> While the current map pinning functions will check whether the pin path i=
s
> contained on a BPF filesystem, it does not offer any options to mount the
> file system if it doesn't exist. Since we now have pinning options, add a
> new one to automount a BPF filesystem at the pinning path if that is not

Next thing we'll be adding extra options to mount BPF FS... Can we
leave the task of auto-mounting BPF FS to tools/applications?

> already pointing at a bpffs.
>
> The mounting logic itself is copied from the iproute2 BPF helper function=
s.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c |   47 ++++++++++++++++++++++++++++++++++++++++++=
+++++
>  tools/lib/bpf/libbpf.h |    5 ++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index aea3916de341..f527224bb211 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -37,6 +37,7 @@
>  #include <sys/epoll.h>
>  #include <sys/ioctl.h>
>  #include <sys/mman.h>
> +#include <sys/mount.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/vfs.h>
> @@ -4072,6 +4073,35 @@ int bpf_map__unpin(struct bpf_map *map, const char=
 *path)
>         return 0;
>  }
>
> +static int mount_bpf_fs(const char *target)
> +{
> +       bool bind_done =3D false;
> +
> +       while (mount("", target, "none", MS_PRIVATE | MS_REC, NULL)) {

what does this loop do? we need some comments explaining what's going
on here (or better yet just drop this entirely and let
bpftool/iproute2 do the mounting).

> +               if (errno !=3D EINVAL || bind_done) {
> +                       pr_warning("mount --make-private %s failed: %s\n"=
,
> +                                  target, strerror(errno));
> +                       return -1;
> +               }
> +
> +               if (mount(target, target, "none", MS_BIND, NULL)) {
> +                       pr_warning("mount --bind %s %s failed: %s\n",
> +                                  target, target, strerror(errno));
> +                       return -1;
> +               }
> +
> +               bind_done =3D true;
> +       }
> +
> +       if (mount("bpf", target, "bpf", 0, "mode=3D0700")) {
> +               fprintf(stderr, "mount -t bpf bpf %s failed: %s\n",
> +                       target, strerror(errno));
> +               return -1;
> +       }
> +
> +       return 0;
> +}
> +
>  static int get_pin_path(char *buf, size_t buf_len,
>                         struct bpf_map *map, struct bpf_object_pin_opts *=
opts,
>                         bool mkdir)
> @@ -4102,6 +4132,23 @@ static int get_pin_path(char *buf, size_t buf_len,

Nothing in `get_pin_path` indicates that it's going to do an entire FS
mount, please split this out of get_pin_path.

>                 err =3D make_dir(path);
>                 if (err)
>                         return err;
> +
> +               if (OPTS_GET(opts, mount_bpf_fs, false)) {
> +                       struct statfs st_fs;
> +                       char *cp;
> +
> +                       if (statfs(path, &st_fs)) {
> +                               char errmsg[STRERR_BUFSIZE];
> +
> +                               cp =3D libbpf_strerror_r(errno, errmsg, s=
izeof(errmsg));
> +                               pr_warning("failed to statfs %s: %s\n", p=
ath, cp);
> +                               return -errno;
> +                       }
> +                       if (st_fs.f_type !=3D BPF_FS_MAGIC &&
> +                           mount_bpf_fs(path)) {
> +                               return -EINVAL;
> +                       }
> +               }
>         }
>
>         len =3D snprintf(buf, buf_len, "%s/%s", path, bpf_map__name(map))=
;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 2131eeafb18d..76b9a6cc7063 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -143,8 +143,11 @@ struct bpf_object_pin_opts {
>          * and this type used for all maps instead.
>          */
>         enum libbpf_pin_type override_type;
> +
> +       /* Whether to attempt to mount a BPF FS if it's not already mount=
ed */
> +       bool mount_bpf_fs;
>  };
> -#define bpf_object_pin_opts__last_field override_type
> +#define bpf_object_pin_opts__last_field mount_bpf_fs
>
>  LIBBPF_API int bpf_object__pin_maps(struct bpf_object *obj, const char *=
path);
>  LIBBPF_API int bpf_object__unpin_maps(struct bpf_object *obj,
>
