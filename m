Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6984C2523F8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHYXGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgHYXG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:06:27 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7837DC061574;
        Tue, 25 Aug 2020 16:06:27 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s9so7356162lfs.4;
        Tue, 25 Aug 2020 16:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m0w8/C3nNNWhHiTFS/rLyqNqZLaFpdzhoabKoFBS2uI=;
        b=Q26eCIigSXd1oH5D+9cCHLgFf82+zbrRPxkSf2Xh+wXySoUbi8eTxScnvJJYhCcV0l
         6OGnEABE51iIe970xzA6i4bAxcVuOmaBWDk5S6h1r7Xnjp/qnfp7Fj046UmOmbDfW6mh
         SXAylNPlL+2Y2bTGKZjxevOBudI1GmKCqvc1joD67eYvw/B5z5IW1NtxjXQ7kqm8b1KU
         Z8MFOEt+08U6L6Gv7LjVjx6vyqX1rTVOjB0GYEcsySMnTKF4vGJ6cYmAcAgROyJHv61u
         c+fbzOp7/l2mjrjbZn5TfgG/rjMTSbSMH4XQOpaX2bmsmTKOYl2Rkwi1jRKfnEKXUxHL
         QRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m0w8/C3nNNWhHiTFS/rLyqNqZLaFpdzhoabKoFBS2uI=;
        b=lChl+z5usoJeuuJNP05U8xZmbOrxo3hwz5BjwepCo1HiKKgr3OQzlhEoxj3qWgxoGq
         AKZr8fN4dcG6GTHmRvfRx5Li7vyBzrlBqAGCnfeuLAKyIlVrOf/KhfVZM4eEhufwUiWv
         uTIKh+s4H1/nVO0t0/WJhJMyKDMIR9WM5dqbnsXqQNuGNHjCY23CXbOXZuAJQUlUXW+L
         zRzGb6vfnBYDQhg4QzrvGieFbgEI7ykcNu/s6qtdMsPjhfjyE9k2HkTtnmr8++yoGDY5
         6aBbupBw1i4GUtrtXEhYYeLVm5pXG1gxSUhMOsIM/FSwoIiGh2V7HYuygJhWroMzEPvh
         Eo5w==
X-Gm-Message-State: AOAM531nWCCdfNkKEApIvtKvluNe8JV5n2tPi+kenpK6cfEWwZUVNZ+q
        1QHfABOFTm5CDNG1WQcgjqvFr0Y999W7/m6YBcI=
X-Google-Smtp-Source: ABdhPJwU0tc8FDQJuzlfUOjGLpD6Z1TVj2/8uBfcFr67ym5r4XWI7NVbs/LRNZ9nOrM8T97fc0qogoty5Es2+EvjcLM=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr5834310lfs.8.1598396785920;
 Tue, 25 Aug 2020 16:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200825192124.710397-1-jolsa@kernel.org> <20200825192124.710397-14-jolsa@kernel.org>
In-Reply-To: <20200825192124.710397-14-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Aug 2020 16:06:14 -0700
Message-ID: <CAADnVQ+_X4-eWW_wNDr9G+Ac6LObQeJ5uCxgetGpR2F33BFk5A@mail.gmail.com>
Subject: Re: [PATCH v12 bpf-next 13/14] selftests/bpf: Add test for d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 12:22 PM Jiri Olsa <jolsa@kernel.org> wrote:
> +
> +static int trigger_fstat_events(pid_t pid)
> +{
> +       int sockfd =3D -1, procfd =3D -1, devfd =3D -1;
> +       int localfd =3D -1, indicatorfd =3D -1;
> +       int pipefd[2] =3D { -1, -1 };
> +       struct stat fileStat;
> +       int ret =3D -1;
> +
> +       /* unmountable pseudo-filesystems */
> +       if (CHECK(pipe(pipefd) < 0, "trigger", "pipe failed\n"))
> +               return ret;
> +       /* unmountable pseudo-filesystems */
> +       sockfd =3D socket(AF_INET, SOCK_STREAM, 0);
> +       if (CHECK(sockfd < 0, "trigger", "scoket failed\n"))
> +               goto out_close;
> +       /* mountable pseudo-filesystems */
> +       procfd =3D open("/proc/self/comm", O_RDONLY);
> +       if (CHECK(procfd < 0, "trigger", "open /proc/self/comm failed\n")=
)
> +               goto out_close;
> +       devfd =3D open("/dev/urandom", O_RDONLY);
> +       if (CHECK(devfd < 0, "trigger", "open /dev/urandom failed\n"))
> +               goto out_close;
> +       localfd =3D open("/tmp/d_path_loadgen.txt", O_CREAT | O_RDONLY);

The work-in-progress CI caught a problem here:

In file included from /usr/include/fcntl.h:290:0,
4814                 from ./test_progs.h:29,
4815                 from
/home/travis/build/tsipa/bpf-next/tools/testing/selftests/bpf/prog_tests/d_=
path.c:3:
4816In function =E2=80=98open=E2=80=99,
4817    inlined from =E2=80=98trigger_fstat_events=E2=80=99 at
/home/travis/build/tsipa/bpf-next/tools/testing/selftests/bpf/prog_tests/d_=
path.c:50:10,
4818    inlined from =E2=80=98test_d_path=E2=80=99 at
/home/travis/build/tsipa/bpf-next/tools/testing/selftests/bpf/prog_tests/d_=
path.c:119:6:
4819/usr/include/x86_64-linux-gnu/bits/fcntl2.h:50:4: error: call to
=E2=80=98__open_missing_mode=E2=80=99 declared with attribute error: open w=
ith O_CREAT
or O_TMPFILE in second argument needs 3 arguments
4820    __open_missing_mode ();
4821    ^~~~~~~~~~~~~~~~~~~~~~

I don't see this bug in my setup, since I'm using an older glibc that
doesn't have this check,
so I've pushed it anyway since it was taking a bit long to land and folks w=
ere
eagerly waiting for the allowlist and d_path features.
But some other folks may complain about build breakage really soon.
So please follow up asap.
