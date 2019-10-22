Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2406E0AC7
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfJVRha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:37:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36819 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfJVRha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:37:30 -0400
Received: by mail-qk1-f195.google.com with SMTP id y189so17058035qkc.3;
        Tue, 22 Oct 2019 10:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DBoXiMo1Ww5J4RL33+vqmYoMKt+Afg6FuK0Fio0nDA8=;
        b=A9OCz0/293hQ5ETxWZeZyzzEMLNX0w7KlksnsaTG1eIA5DXvl0gEKJQR/UcHxQEvRx
         +R0vOyNdZTwkW5iG8NcXyhUAh/1i3A2OGdQk9ElgN7huG+IvTtPhkRlmgnfPesGzk+ET
         FmVkEUXKmIv20/h5InYmizuxTByRjygArK1d/b/khYomGcuVy2OBcn0YXUtfnRMKd1SF
         bXpqmGRkkXWMxnHoxefYX6OuMfqHdh40OywV5Wxkch2SgT4d1OX2bNDUABK8IiMF8IOB
         I3WdZw6YfG67Cw+mUxGLWh0YWYdi1awvGQeUYiJntbrmeEmIB+RN09VG2CSVSjTNJbvZ
         /eZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DBoXiMo1Ww5J4RL33+vqmYoMKt+Afg6FuK0Fio0nDA8=;
        b=Lb3EYXXfAnzz6Sj3zWNjnaloEaxCkuruxc2k6UO0MC9svGcb6oc9thtyRkcRySLTWQ
         oo143CVWrUZH7ERoTNtqOnInoXpZMSJ189fdOgANGPWfmXimggwZfPTmXdWUKS5JeCZB
         SMe9h5bwpMXOvKJP9jujL3tOk6Up8vax41wMnzuh8DKwfUVHXiN2ujnW2x5clr+wUP8N
         VNN1ZJDPjICCCfZHqA8A+ES8aT2RoloVafgouRxkhwwLVeZ6KoY70U9vN5lVPKSes71Q
         3uPi7a8FmfY+lAPLsM4WZ+3x4RqCMAq3v5Abschf6hw1vOBSsvKWcdUnB2QhUI6MbWy7
         89wA==
X-Gm-Message-State: APjAAAUx8UCrHoLHg1xLh7MlYvDqeYKaT2vzXlIztn7gewS1xIKbLsQ6
        mrhJAl367K1CIhY2P+XFOvAs3qJRAnzGmwSnX2w=
X-Google-Smtp-Source: APXvYqwf/ORL7W6Evz3AZ7Kt6katWIB1MaAbHNZBi8fNOk28oVevDDXORPhS++eU7klYj5tsbqEQCqq8EOAeOtYL5oA=
X-Received: by 2002:a37:520a:: with SMTP id g10mr4188717qkb.39.1571765848782;
 Tue, 22 Oct 2019 10:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <157175668770.112621.17344362302386223623.stgit@toke.dk> <157175668879.112621.10917994557478417780.stgit@toke.dk>
In-Reply-To: <157175668879.112621.10917994557478417780.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 10:37:17 -0700
Message-ID: <CAEf4BzatAgkOiS2+EpauWsUWymmjM4YRBJcSqYj15Ywk8aP6Lw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: Store map pin path in struct bpf_map
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
> When pinning a map, store the pin path in struct bpf_map so it can be
> re-used later for un-pinning. This simplifies the later addition of per-m=
ap
> pin paths.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index cccfd9355134..b4fdd8ee3bbd 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -226,6 +226,7 @@ struct bpf_map {
>         void *priv;
>         bpf_map_clear_priv_t clear_priv;
>         enum libbpf_map_type libbpf_type;
> +       char *pin_path;
>  };
>
>  struct bpf_secdata {
> @@ -1929,6 +1930,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
>         if (err)
>                 goto err_close_new_fd;
>         free(map->name);
> +       zfree(&map->pin_path);
>

While you are touching this function, can you please also fix error
handling in it? We should store -errno locally on error, before we
call close() which might change errno.

>         map->fd =3D new_fd;
>         map->name =3D new_name;
> @@ -4022,6 +4024,7 @@ int bpf_map__pin(struct bpf_map *map, const char *p=
ath)
>                 return -errno;
>         }
>
> +       map->pin_path =3D strdup(path);

if (!map->pin_path) {
    err =3D -errno;
    goto err_close_new_fd;
}


>         pr_debug("pinned map '%s'\n", path);
>
>         return 0;
> @@ -4031,6 +4034,9 @@ int bpf_map__unpin(struct bpf_map *map, const char =
*path)
>  {
>         int err;
>
> +       if (!path)
> +               path =3D map->pin_path;

This semantics is kind of weird. Given we now remember pin_path,
should we instead check that user-provided path is actually correct
and matches what we stored? Alternatively, bpf_map__unpin() w/o path
argument looks like a cleaner API.

> +
>         err =3D check_path(path);
>         if (err)
>                 return err;
> @@ -4044,6 +4050,7 @@ int bpf_map__unpin(struct bpf_map *map, const char =
*path)
>         if (err !=3D 0)
>                 return -errno;
>         pr_debug("unpinned map '%s'\n", path);
> +       zfree(&map->pin_path);
>
>         return 0;
>  }
> @@ -4088,17 +4095,10 @@ int bpf_object__pin_maps(struct bpf_object *obj, =
const char *path)
>
>  err_unpin_maps:
>         while ((map =3D bpf_map__prev(map, obj))) {
> -               char buf[PATH_MAX];
> -               int len;
> -
> -               len =3D snprintf(buf, PATH_MAX, "%s/%s", path,
> -                              bpf_map__name(map));
> -               if (len < 0)
> -                       continue;
> -               else if (len >=3D PATH_MAX)
> +               if (!map->pin_path)
>                         continue;
>
> -               bpf_map__unpin(map, buf);
> +               bpf_map__unpin(map, NULL);
>         }
>
>         return err;
> @@ -4248,6 +4248,7 @@ void bpf_object__close(struct bpf_object *obj)
>
>         for (i =3D 0; i < obj->nr_maps; i++) {
>                 zfree(&obj->maps[i].name);
> +               zfree(&obj->maps[i].pin_path);
>                 if (obj->maps[i].clear_priv)
>                         obj->maps[i].clear_priv(&obj->maps[i],
>                                                 obj->maps[i].priv);
>
