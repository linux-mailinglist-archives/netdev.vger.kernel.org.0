Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EC9ECD42
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 06:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKBFIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 01:08:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45252 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 01:08:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id x21so15807519qto.12;
        Fri, 01 Nov 2019 22:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CArxfq9JiPlQkcRrbvVOMl9cqlwVD7wA50QdqFjV2ck=;
        b=tnqBkGiG780NOuBwyM9RQUFVr6D55Tu1maXU98yB/MnOzcuGC3PvwZTa8NvIs+9LuJ
         337FsFvBEdCc8+dGL9SVei46ZttE2bim+ncaUUkui3+wnbvgrOpeMJUMz3qkfGGganby
         kRO0K/LLETk1Q88kGou2GIw85WNEWL5dmOy7KY1DuB243VhAQKgj+JN6c9rcigce/yJT
         TQPS7tDQDqa6vKSIFpELUMWH4UvUPM3TCwcmIzdl/5gkqWN86U6hkY6lJoKIT5LbE0tU
         etsOtIdeM2FQ6OhuAV/M3pwTDpWkYggYRBU0KZO34SIX6IXUQsNuwSesIRATOg9Rg1Bt
         EIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CArxfq9JiPlQkcRrbvVOMl9cqlwVD7wA50QdqFjV2ck=;
        b=oF1rh6beqekjf4ZHLDnpQzr5MgLE11NrNUQpmGcK41Rft99yRuWx7uz7LmndU/Cyd+
         Ib0e9Mk2L2sM4xrbnyqtxEO2JHsiA2h7k4eU3A5mqBXTo1tZS7/tC5tbPkDYyJKiAF/M
         oGI5r1zB5EO9IzrYrbI1pnti6af1ukoQ1aMFH/0ty749hwamXVaIi3qHPq+ailydnm+k
         zeKu66BF7liruBdThtlA8NbxELpITg6iHzXeZ5UzbAOEIYH8GgpeZs6rnC6Equ6EXicb
         jv5EuSWVqCFpxWZCaNKpGDwwoATnLS43W9e0qnRMLYEfXTZwVWbrupfMOj2ModDdLgAi
         1UyA==
X-Gm-Message-State: APjAAAW3gSebtcIbtA0A7o4yHVHtp5Qgqy2zKTgB11Cfqyb16YjHYVNF
        9kJZkWZm+bqc6FIVNzXV8uJ8pjRen9NkmipOh+Q=
X-Google-Smtp-Source: APXvYqyRAjec4VONtAs6OQzOBIipEh5P4ryYwblHuUu2FSJr4M/AFSQ83tPUUMMmg9hpERE7Z+jncPoHAIFXuKLK4BQ=
X-Received: by 2002:ac8:4890:: with SMTP id i16mr3197520qtq.141.1572671289898;
 Fri, 01 Nov 2019 22:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <157260197645.335202.2393286837980792460.stgit@toke.dk> <157260198209.335202.12139424443191715742.stgit@toke.dk>
In-Reply-To: <157260198209.335202.12139424443191715742.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Nov 2019 22:07:58 -0700
Message-ID: <CAEf4BzYWgnek1QYyQm4U0qakP=Si0vEJ2bLKHeJhambyX7EnCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/5] selftests: Add tests for automatic map pinning
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

On Fri, Nov 1, 2019 at 2:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a new BPF selftest to exercise the new automatic map pinning
> code.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

I don't believe I acked this patch before, must have been added by
mistake. But either way thanks for improving tests and testing a good
variety of scenarios, I appreciate the work. Please fix bpf_object
leak below and keep my Acked-by :)

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/pinning.c   |  208 ++++++++++++++=
++++++
>  tools/testing/selftests/bpf/progs/test_pinning.c   |   31 +++
>  .../selftests/bpf/progs/test_pinning_invalid.c     |   16 ++
>  3 files changed, 255 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_invali=
d.c
>

[...]

> +       /* should fail because of map parameter mismatch */
> +       err =3D bpf_object__load(obj);
> +       if (CHECK(err !=3D -EINVAL, "param mismatch load", "err %d errno =
%d\n", err, errno))
> +               goto out;
> +

You need to close obj here, before overwriting it below?

> +       /* test auto-pinning at custom path with open opt */
> +       obj =3D bpf_object__open_file(file, &opts);
> +       if (CHECK_FAIL(libbpf_get_error(obj))) {
> +               obj =3D NULL;
> +               goto out;
> +       }

[...]
