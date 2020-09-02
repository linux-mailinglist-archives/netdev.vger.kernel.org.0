Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A8A25A258
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgIBAlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIBAlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 20:41:49 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C601C061244;
        Tue,  1 Sep 2020 17:41:49 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x10so1883563ybj.13;
        Tue, 01 Sep 2020 17:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIdCv98QPlZ7UG3Qf+jAB8LmpERQN1I37TUmHwnMDq8=;
        b=HF3KQxzSVM8Z6Q2hV5FsgtUUrjsrZWfL7aI5Cc/j2RnmiROEeDlLnUapJ7zpb2bB5X
         /MUUb7v+GDr0zMG9TDyeQzILtYhlD7iGdZ9pxqefHlenWnZ6zn9jWPhQY4QjYHOR76fJ
         7K3/t117vTjm8e++SGVbhLPV7OMDsycgNgBhg6mkpM44wkBL+GfJ83aJXTa+1LPWo7ed
         c+RybF9aD7GbTq0JJFwRJ49wzUCKhGUxBmsqqKV7zKu7n/+Ag+/VMg0pdP9kA9sDtV7o
         JKedeMhB+PAW7jPUm3YYxHy0N7cJcF19XlZpynEhpPLMTxbWgVkQUOdfljo5WMlfvC5n
         BaJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIdCv98QPlZ7UG3Qf+jAB8LmpERQN1I37TUmHwnMDq8=;
        b=BI8hnGlYE1N5hG8k9bN3etXOkKWiDz/NzDbCbUM0DHHV502wu1KBtOskX6HKKbMlb8
         7K2UsOPxQeQzoBTtWLj0/3HE+hvZSeGmov9CNv2DPTKedfDfb7DSWFpPi+TWo88KiW2i
         SLloIGnu0LxM9hvbsOtKxCumvHy61i2NIi0uPwKp4TMhioChaXyRs1mrMz8lLDYJ9bYv
         cENXLKm/d4q9GYXBhrtQBKMYjY6R1eEeGHEFOQ8WUB7Y0oy4Nv8uU+DBxmXGH/87nV+h
         yf94u8ZjqDnTSISJHpmMVOb9DIRznJ0Z2DBpOBGTDl8cQEZiu5HGp9pGNgRHCbkehX1A
         Ekkw==
X-Gm-Message-State: AOAM532xAyJzZs5Po3ja7zFkO0HTCIK9h5rnq6TtCOXb8dJ67FK36ZW7
        ocaqhTfI77FjLk/OAVbDvYat3bDpj0ejbs98uqw=
X-Google-Smtp-Source: ABdhPJxZpaUH5GcFzg6G4d0OE0tnNapGQGVs+h+fci+3Y3eTTz9jHxJ6kMwrJP25kUsxgwqo5+gEIr+wh6nhZzO/kGs=
X-Received: by 2002:a25:ae43:: with SMTP id g3mr6670340ybe.459.1599007308295;
 Tue, 01 Sep 2020 17:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200828053815.817726-1-yhs@fb.com> <20200828053817.817890-1-yhs@fb.com>
In-Reply-To: <20200828053817.817890-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Sep 2020 17:41:37 -0700
Message-ID: <CAEf4BzbQboQ3uPmXG2HAsv2=S3iJ5-6RQiC8Z8OymnCCyMJ77A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: test task_file iterator
 without visiting pthreads
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 10:38 PM Yonghong Song <yhs@fb.com> wrote:
>
> Modified existing bpf_iter_test_file.c program to check whether
> all accessed files from the main thread or not.
>
> Modified existing bpf_iter_test_file program to check
> whether all accessed files from the main thread or not.
>   $ ./test_progs -n 4
>   ...
>   #4/7 task_file:OK
>   ...
>   #4 bpf_iter:OK
>   Summary: 1/24 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/bpf_iter.c       | 21 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_task_file.c  | 10 ++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
>

[...]

> +       if (CHECK(pthread_join(thread_id, &ret) || ret != NULL,
> +                 "pthread_join", "pthread_join failed\n"))
> +               goto done;
> +
> +       CHECK(skel->bss->count != 0, "",

nit: please use non-empty string for second argument

> +             "invalid non pthread file visit %d\n", skel->bss->count);
> +
> +done:
>         bpf_iter_task_file__destroy(skel);
>  }
>

[...]
