Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAD1196911
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgC1UGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 16:06:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37793 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgC1UGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 16:06:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id x3so14816771qki.4;
        Sat, 28 Mar 2020 13:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LfdHDYK3Vm2J1kxTCZuWKmTRy//Ek2MwrGP3qQN9WsY=;
        b=j0HZ8oNdaPD1Cf93feMWbB6KoSIpuuFglrvx6Sl60CFs9htw+4Sdfw2ywDsFl9VHMK
         6hBFxm78/SK6W68T/c3MhuFM+EfexlT2/PgDZkEWX7KozduhfCQmlKMs0kRgtYR43xnl
         eAEBzqd7uOb7uEqmTpxufWnpxveS/hqS8aKWCCoXqU9Yd7XrVSBFY3CfAQ0+H2Mjv4D4
         2NmgVUrBk2gPXDvzsPTjJCOFW+G7kmV/ZCmfRkv/4Hgyn2PrGlTLkLcWXmlh7TKZ/60P
         +nr4Ellj8cD401TmN/Nu3c9plySl/WbVINM56rJK7R4ZccpgB+toTDbsolsaRj9/QAxb
         pIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LfdHDYK3Vm2J1kxTCZuWKmTRy//Ek2MwrGP3qQN9WsY=;
        b=qZBVvHL1JIuvoc18kQ1gLW0x9FPossgiWMjOFZaF1SQGcwiHU4FfM9lwfuISlWK2DC
         h8+VWNs3+wsVmVbT10INiq0VNVzWOv3H8LvlWOxL54pLGgKiObtIYMZgXIvmk5b7UiuE
         zoAcwYqzZ091k658OPF9cVWWL/5Iw+EvjgfTk451CFQDM/sKnMYNYLXk4ON8CF092RVq
         +2hOD1UOnOl0A/c5YvWRJSkWqXC07mJKEKXGpxxXdYox61yBTJAdin3uPxmOeB2k3pyU
         xb/4VnS7WTN8f35slP5rVuzKwG+Ncd2meRcmi5SPFsbhT4rUTpvGzRpPDO4BSJ7yzdtT
         QAtg==
X-Gm-Message-State: ANhLgQ2QBFjtrQfZDugREhupUptra5S3q/KyaufCEJicG7S1q6hr/f6Y
        Gq3ojn4WW5rQDvdG/jIyaQtIQO8lWgzjrC2zWsk=
X-Google-Smtp-Source: ADFU+vuMAq0Nv1gpC4ZjF3d0I18tRUJj61IJ/yStU3WU47uxD79JNBektoTYEQ619DPZP4xihWaqk4qAGrptQ3u5LKE=
X-Received: by 2002:a37:b786:: with SMTP id h128mr1760516qkf.92.1585425989325;
 Sat, 28 Mar 2020 13:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200327125818.155522-1-toke@redhat.com> <20200328182834.196578-2-toke@redhat.com>
In-Reply-To: <20200328182834.196578-2-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 28 Mar 2020 13:06:18 -0700
Message-ID: <CAEf4BzZPd0-unT7ChKNFCYRVU2NHfdp8kKuEFSZgaDxm9ndC8w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: Add test for overriding global data
 value before load
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 11:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> This extends the global_data test to also exercise the new
> bpf_map__set_initial_value() function. The test simply overrides the glob=
al
> data section with all zeroes, and checks that the new value makes it into
> the kernel map on load.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/global_data.c    | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools=
/testing/selftests/bpf/prog_tests/global_data.c
> index c680926fce73..f018ce53a8d1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/global_data.c
> +++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
> @@ -121,6 +121,65 @@ static void test_global_data_rdonly(struct bpf_objec=
t *obj, __u32 duration)
>               "err %d errno %d\n", err, errno);
>  }
>
> +static void test_global_data_set_rdonly(__u32 duration)
> +{
> +       const char *file =3D "./test_global_data.o";
> +       int err =3D -ENOMEM, map_fd, zero =3D 0;
> +       __u8 *buff =3D NULL, *newval =3D NULL;
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +       struct bpf_map *map;
> +       size_t sz;
> +
> +       obj =3D bpf_object__open_file(file, NULL);

Try using skeleton open and load .o file, it will cut this code almost in h=
alf.

> +       if (CHECK_FAIL(!obj))
> +               return;
> +       prog =3D bpf_program__next(NULL, obj);
> +       if (CHECK_FAIL(!prog))
> +               goto out;
> +       err =3D bpf_program__set_sched_cls(prog);

Please fix SEC() name for that program instead of setting type explicitly.

> +       if (CHECK_FAIL(err))
> +               goto out;
> +
> +       map =3D bpf_object__find_map_by_name(obj, "test_glo.rodata");
> +       if (CHECK_FAIL(!map || !bpf_map__is_internal(map)))
> +               goto out;
> +
> +       sz =3D bpf_map__def(map)->value_size;
> +       newval =3D malloc(sz);
> +       if (CHECK_FAIL(!newval))
> +               goto out;
> +       memset(newval, 0, sz);
> +
> +       /* wrong size, should fail */
> +       err =3D bpf_map__set_initial_value(map, newval, sz - 1);
> +       if (CHECK(!err, "reject set initial value wrong size", "err %d\n"=
, err))
> +               goto out;
> +
> +       err =3D bpf_map__set_initial_value(map, newval, sz);
> +       if (CHECK_FAIL(err))
> +               goto out;
> +
> +       err =3D bpf_object__load(obj);
> +       if (CHECK_FAIL(err))
> +               goto out;
> +
> +       map_fd =3D bpf_map__fd(map);
> +       if (CHECK_FAIL(map_fd < 0))
> +               goto out;
> +
> +       buff =3D malloc(sz);
> +       if (buff)
> +               err =3D bpf_map_lookup_elem(map_fd, &zero, buff);
> +       CHECK(!buff || err || memcmp(buff, newval, sz),
> +             "compare .rodata map data override",
> +             "err %d errno %d\n", err, errno);
> +out:
> +       free(buff);
> +       free(newval);
> +       bpf_object__close(obj);
> +}
> +
>  void test_global_data(void)
>  {
>         const char *file =3D "./test_global_data.o";
> @@ -144,4 +203,6 @@ void test_global_data(void)
>         test_global_data_rdonly(obj, duration);
>
>         bpf_object__close(obj);
> +
> +       test_global_data_set_rdonly(duration);

This should either be a sub-test or better yet a separate test altogether.

>  }
> --
> 2.26.0
>
