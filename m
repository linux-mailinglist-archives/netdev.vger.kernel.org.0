Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02378EB692
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfJaSCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:02:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40029 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaSCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:02:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id o49so9737262qta.7;
        Thu, 31 Oct 2019 11:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EmsJxDxXZo8hGavu2AeDIgchhwdEKp5t2d8n6gOkGaU=;
        b=vNEkw3+hnBdrqXGfXR1iutZFPpr/+rTopd1n8OmIHUyjr663rlCA842x2ZzocxRuZK
         J0j6QwriJc33ZNzhd8mCrz3zqpECeCz4QKilc4dAlKE/ytPJazUH0iOyP4EcOxZsfApD
         4jKBPqhw7ll1NQMcOhLmo3fclFYvkBJU/l5vIj3p64HvodNzVgDstEVdrtDHrykyzA7R
         bOedHLzZDT3dDLUy8U0bfdAYZDoLKMesl+2L8ojeCFyb2+4GC80d4jwyLzcxUUtngRdX
         OZhaMxs7fsEN4YI/ZowB4Mqgf0qRIxCqRSm1RQCtMxe3MayVb83+0vDFabMbMi/tnoaD
         hTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EmsJxDxXZo8hGavu2AeDIgchhwdEKp5t2d8n6gOkGaU=;
        b=E0hvENtbyi/XpJ+C2Og6CYIJAAY8nP4dMUFPEXLxZ3HTF0az08gYrWyETwEJ7XEY8O
         eAZpIgE0EvrhhrN1dlcaBwXrlniUuk0Je+BFutcnPyRCF2foujvbwkvMEDBD6Z3F96AT
         dywesdoK7kNtobt78wIudUYRWmx3rQjIgjwl8Ad8MIygxYmcEqpRMy1cYhfAx13klGI3
         QojUhLRwBa44Cy+6J8anfsuaJV2HjOphYwT/W40An18pxO0Tbv+jOK3rDitPg+gQD6JU
         CKJmGtNhXwR2YS4BGgQq1o9JxLa8v7jcy3ac1j2oE5dj4g08VRez4yGq69alYimuF6yB
         jPgA==
X-Gm-Message-State: APjAAAX2YccBTkXak6FykoP9oVYefQXQ56Y6HrOPFNWPKyhuA3VEMTEg
        GzMJ7hWTXJmHbYprAxFjFeIRid7pjj9viAc/ch8=
X-Google-Smtp-Source: APXvYqxZNPsfBDBRpb8pOnE8i11Upbr0YO5dqwefH0BQg1NyNi8F+Z0F6GIaXokUCQhhSOTqSdzN/3W/ttuDG2TIZPc=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr6750300qte.59.1572544954503;
 Thu, 31 Oct 2019 11:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796779.169521.16760790702202542513.stgit@toke.dk>
In-Reply-To: <157237796779.169521.16760790702202542513.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 11:02:23 -0700
Message-ID: <CAEf4BzZ6OYFYZNfQ4n7gPjyg0tWtsAaNWzZie3L23TE9KNtOoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 5/5] selftests: Add tests for automatic map pinning
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

On Tue, Oct 29, 2019 at 12:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a new BPF selftest to exercise the new automatic map pinning
> code.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/pinning.c |  157 ++++++++++++++++=
++++++
>  tools/testing/selftests/bpf/progs/test_pinning.c |   29 ++++
>  2 files changed, 186 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/tes=
ting/selftests/bpf/prog_tests/pinning.c
> new file mode 100644
> index 000000000000..71f7dc51edc7
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <test_progs.h>
> +
> +__u32 get_map_id(struct bpf_object *obj, const char *name)
> +{
> +       __u32 map_info_len, duration, retval;
> +       struct bpf_map_info map_info =3D {};
> +       struct bpf_map *map;
> +       int err;
> +
> +       map_info_len =3D sizeof(map_info);
> +
> +       map =3D bpf_object__find_map_by_name(obj, name);
> +       if (CHECK(!map, "find map", "NULL map"))
> +               return 0;
> +
> +       err =3D bpf_obj_get_info_by_fd(bpf_map__fd(map),
> +                                    &map_info, &map_info_len);
> +       CHECK(err, "get map info", "err %d errno %d", err, errno);
> +       return map_info.id;
> +}
> +
> +void test_pinning(void)
> +{
> +       __u32 duration, retval, size, map_id, map_id2;
> +       const char *custpinpath =3D "/sys/fs/bpf/custom/pinmap";
> +       const char *nopinpath =3D "/sys/fs/bpf/nopinmap";
> +       const char *custpath =3D "/sys/fs/bpf/custom";

Should this test mount/unmount (if necessary) /sys/fs/bpf? They will
all fail if BPF FS is not mounted, right?

> +       const char *pinpath =3D "/sys/fs/bpf/pinmap";
> +       const char *file =3D "./test_pinning.o";
> +       struct stat statbuf =3D {};
> +       struct bpf_object *obj;
> +       struct bpf_map *map;
> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +               .pin_root_path =3D custpath,
> +       );
> +
> +       int err;
> +       obj =3D bpf_object__open_file(file, NULL);
> +       if (CHECK_FAIL(libbpf_get_error(obj)))
> +               return;
> +
> +       err =3D bpf_object__load(obj);
> +       if (CHECK(err, "default load", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       /* check that pinmap was pinned */
> +       err =3D stat(pinpath, &statbuf);
> +       if (CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +        /* check that nopinmap was *not* pinned */
> +       err =3D stat(nopinpath, &statbuf);
> +       if (CHECK(!err || errno !=3D ENOENT, "stat nopinpath",
> +                 "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +        map_id =3D get_map_id(obj, "pinmap");

something wrong with whitespaces here? can you please run
scripts/checkpatch.pl to double-check?

> +       if (!map_id)
> +               goto out;
> +
> +       bpf_object__close(obj);
> +
> +       obj =3D bpf_object__open_file(file, NULL);
> +       if (CHECK_FAIL(libbpf_get_error(obj)))

obj =3D NULL here before you go to out

> +               goto out;
> +
> +       err =3D bpf_object__load(obj);
> +       if (CHECK(err, "default load", "err %d errno %d\n", err, errno))
> +               goto out;
> +

[...]

> +       err =3D rmdir(custpath);
> +       if (CHECK(err, "rmdir custpindir", "err %d errno %d\n", err, errn=
o))
> +               goto out;
> +
> +       bpf_object__close(obj);
> +
> +       /* test auto-pinning at custom path with open opt */
> +       obj =3D bpf_object__open_file(file, &opts);
> +       if (CHECK_FAIL(libbpf_get_error(obj)))
> +               return;

obj =3D NULL; goto out; to ensure pinpath is unlinked?

> +
> +       err =3D bpf_object__load(obj);
> +       if (CHECK(err, "custom load", "err %d errno %d\n", err, errno))
> +               goto out;
> +
> +       /* check that pinmap was pinned at the custom path */
> +       err =3D stat(custpinpath, &statbuf);
> +       if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errn=
o))
> +               goto out;
> +
> +out:
> +       unlink(pinpath);
> +       unlink(nopinpath);
> +       unlink(custpinpath);
> +       rmdir(custpath);
> +       if (obj)
> +               bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/tes=
ting/selftests/bpf/progs/test_pinning.c
> new file mode 100644
> index 000000000000..ff2d7447777e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_pinning.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +int _version SEC("version") =3D 1;
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u64);
> +       __uint(pinning, LIBBPF_PIN_BY_NAME);
> +} pinmap SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u64);
> +} nopinmap SEC(".maps");


would be nice to ensure that __uint(pinning, LIBBPF_PIN_NONE) also
works as expected, do you mind adding one extra map?

> +
> +SEC("xdp_prog")
> +int _xdp_prog(struct xdp_md *xdp)
> +{
> +       return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
>
