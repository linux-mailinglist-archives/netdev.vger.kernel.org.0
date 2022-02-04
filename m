Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6E4AA3F2
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377849AbiBDXEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376312AbiBDXEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:04:33 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9C5DF2D306;
        Fri,  4 Feb 2022 15:04:32 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id 9so9308844iou.2;
        Fri, 04 Feb 2022 15:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1pu0d3Yf+q8xwC8OB6WG8Zu+IuarbmMd83H8xXGaDAA=;
        b=AvaK0n/Yfmy2XVA1XWg5y+qZ03Q0D0UV3wjhdcEk41jPkroj3o+yldgJx3fID0JWH4
         YwzM/hzDJoCQ3OeVWY8RmqN9w5LJPWz9Dp4INgJuPoGzGMXIM/mQPhvFzaLHCdxmvV5p
         Nita63CWaHMZpp8mxdWpQlWrZck438+iTSueDYwh4fejwjOG6fr+COO5kTpalRo/gjUP
         L2Tqlg1K4jkZyLuHfW0M70Rmt6XPK/uj+jksaGWtuagti9DV+M6ryf6sD8wNm6BK2km6
         KukznX/0wf5SFWNyPvxslzMtsZZqq5xVaLT7JSWW7vHBKsY4QwV/JMfdmZGap8O8NH1X
         9+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1pu0d3Yf+q8xwC8OB6WG8Zu+IuarbmMd83H8xXGaDAA=;
        b=ypmUhAOqUQMCGVdwyePXfoMVkYkbya7cCj9gKHDx3jAF/IZf9VksTqYnZFMo0ds9CX
         qByv4PYE1ikywK+sSCuaT7iIn6le79G1mBa5FfjYeFECBaZszYZwxHgDSAN3HJSj6/4u
         LgmnunbjqWYBxl0WR4lxvhBr7ho4azVCpTq019tA1FWqt9wmAke8Sb2UpPSf376tx/b8
         K3yTetIZAWrbZwRNq/HN/hOfd7lPRnhn+SkrAnw5tQ0a8PsHHIVmQR9FAplG2CDHfrJx
         6vV21QSZ0rbTrehU8vz/n/0ngmIzT/7APcIIiCEX5SqKqJatBXfWAZoRpvPSEXvjzHnH
         KlyQ==
X-Gm-Message-State: AOAM533PVYItITtC4alilCD9RlU9tXbwGE/o8jJHAt+x39DAcG4M+Gsr
        6q9egGGxhQ+4EAsfYyRJEL+J++INNNqcigyNqS8=
X-Google-Smtp-Source: ABdhPJxGn6X0tnh1ZZV2A823OiJ7fsZdLht1/AEVhJFQddEJRHLe30NZvNA9qCihSXQalGEmXF/wHrx/+33+QHD6cIs=
X-Received: by 2002:a02:2422:: with SMTP id f34mr626422jaa.237.1644015872355;
 Fri, 04 Feb 2022 15:04:32 -0800 (PST)
MIME-Version: 1.0
References: <20220204225823.339548-1-jolsa@kernel.org>
In-Reply-To: <20220204225823.339548-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 15:04:21 -0800
Message-ID: <CAEf4BzY66WPKQbDe74AKZ6nFtZjq5e+G3Ji2egcVytB9R6_sGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: Add names for auxiliary maps
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 2:58 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding names for maps that bpftool uses for various detections.
> These maps can appear in final map show output (due to deferred
> removal in kernel) so some tests (like test_offload.py) needs
> to filter them out.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 904cdf83002b..38294ce935d6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4412,7 +4412,7 @@ static int probe_kern_global_data(void)
>         };
>         int ret, map, insn_cnt = ARRAY_SIZE(insns);
>
> -       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "global_data", sizeof(int), 32, 1, NULL);

some old kernel versions don't support map names, so you can't just
blindly specify them and log error

I'd rather fix test_offload.py instead of "fixing" libbpf.


>         if (map < 0) {
>                 ret = -errno;
>                 cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> @@ -4545,7 +4545,7 @@ static int probe_kern_array_mmap(void)
>         LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
>         int fd;
>
> -       fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
> +       fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "array_mmap", sizeof(int), sizeof(int), 1, &opts);
>         return probe_fd(fd);
>  }
>
> @@ -4592,7 +4592,7 @@ static int probe_prog_bind_map(void)
>         };
>         int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
>
> -       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "bind_map_detect", sizeof(int), 32, 1, NULL);
>         if (map < 0) {
>                 ret = -errno;
>                 cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> --
> 2.34.1
>
