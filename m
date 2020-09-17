Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5E526DEE5
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgIQO6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgIQO6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 10:58:12 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975A2C06178B;
        Thu, 17 Sep 2020 07:58:09 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a22so2274423ljp.13;
        Thu, 17 Sep 2020 07:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ewdb/5Luu0M1Zlvd5mbxKVbE7mouw/5QSqBvh/Tsm34=;
        b=stLXKjGAsmeHxLLHNtha9cMqFeZVf4hQkQzUwa8WbmDPPvPuWlFY0mn3aNGLg28Yyz
         JCxQ32eETI53110Z0gkaQPJ2sXGxcAlD08ywBOuh4+nMSpe6oJSirP/ydLw3h0ID8sWH
         QlnXXvqTSreZ62s4CrcAx4iT3BHiROSAyD6n+3I2YOybQ+uP9td1SGFezcRaSjb1eSxz
         2LyTWtlQCHj12S7ENTKAooKtXHRwEkaLnhVRJa4Ja1ZLbJylmOQp+/Kly9wwYhq6WJ40
         Aeym7wVJTfujkGTXsWAHTT8mCIxQi36mXcz52cs7ewwZgLLcQZqqYoN5HlosnaJjNKAU
         0FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ewdb/5Luu0M1Zlvd5mbxKVbE7mouw/5QSqBvh/Tsm34=;
        b=E+5eNNwauiQj8JW+55U3xp4CPkxa/8X6RLtE4isohT0sqB3oKDse3DUkm2envrxbCS
         sUqCQHCGF1tNdqb+R934Pol5C6fXfbsahdaHL66fwXoeN5bArdBkjg3xevzTqL835zPm
         JRIWTBi6jIG47hVF7jpZAx7rfkHxHXUWYg9K3F0kMl5GPafmhiBAM+zpWeDjkgOSHGdP
         2KcRbFBuTGIK6kBcRhmw0vQJlQCnYzWSSP9AxRLk0O5SCI9Ie2eEAQyNm6qKmzuS4J1f
         1ICsSaxO5KowRzupq37g8xeg7/5Xj1HjTTiMQlgk1UYrmevdfL2mgD+RIxkkRMvaShli
         4TSA==
X-Gm-Message-State: AOAM530Hbn1ARUK/zHe7tOiNHHU/P2EGn13cQd88RSSEs3YHBAaxt2sK
        YT/3S8OmE6b1d8W6v8LiIZBfJnhEZR23Ul0G7hQ=
X-Google-Smtp-Source: ABdhPJwN5AmQBJJ2AO+EFJ66Tw4J2dPtIALeak4KqJXY5jpmOy7HWt6GfFR1+fP1XxI0NpLo5TsZeSAuHlEAZUXa0+E=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr9643911ljg.51.1600354687981;
 Thu, 17 Sep 2020 07:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600328701.git.mchehab+huawei@kernel.org> <442b27cc035ab7f9e5e000f2ac44ce88ea8b16a6.1600328701.git.mchehab+huawei@kernel.org>
In-Reply-To: <442b27cc035ab7f9e5e000f2ac44ce88ea8b16a6.1600328701.git.mchehab+huawei@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Sep 2020 07:57:56 -0700
Message-ID: <CAADnVQJr+FAnRCtKxpi97qw1aGZe6D9g-VHjjWLfyQbeEZFYAQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs: bpf: ringbuf.rst: fix a broken cross-reference
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 1:04 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> Sphinx warns about a broken cross-reference:
>
>         Documentation/bpf/ringbuf.rst:194: WARNING: Unknown target name: "bench_ringbufs.c".
>
> It seems that the original idea were to add a reference for this file:
>
>         tools/testing/selftests/bpf/benchs/bench_ringbufs.c
>
> However, this won't work as such file is not part of the
> documentation output dir. It could be possible to use
> an extension like interSphinx in order to make external
> references to be pointed to some website (like kernel.org),
> where the file is stored, but currently we don't use it.
>
> It would also be possible to include this file as a
> literal include, placing it inside Documentation/bpf.
>
> For now, let's take the simplest approach: just drop
> the "_" markup at the end of the reference. This
> should solve the warning, and it sounds quite obvious
> that the file to see is at the Kernel tree.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/bpf/ringbuf.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/bpf/ringbuf.rst b/Documentation/bpf/ringbuf.rst
> index 4d4f3bcb1477..6a615cd62bda 100644
> --- a/Documentation/bpf/ringbuf.rst
> +++ b/Documentation/bpf/ringbuf.rst
> @@ -197,7 +197,7 @@ a self-pacing notifications of new data being availability.
>  being available after commit only if consumer has already caught up right up to
>  the record being committed. If not, consumer still has to catch up and thus
>  will see new data anyways without needing an extra poll notification.
> -Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c_) show that
> +Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c) show that

This fix already landed in bpf and net trees.
Did you miss it?
