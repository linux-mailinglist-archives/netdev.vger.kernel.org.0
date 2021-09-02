Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671C13FF7B1
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347958AbhIBXPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241671AbhIBXPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:15:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A50AC061575;
        Thu,  2 Sep 2021 16:14:41 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id v17so1357027ybs.9;
        Thu, 02 Sep 2021 16:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=egUHntY0l18Btcd+MAvFt6A4IxhhYFZI9sARDFUH9wQ=;
        b=nBNWgz7C5eDRyzjXg4Fzh7KWaQdnrFIKuVFb5z0NZAqrmd4HzptgnO7LHB1lX5tjf8
         UlkX/pAUMntXip8quh32PD8CgWFU5FMAjpQGrYWPbqsqjzKFbTmD2QsbxEArajZxHLkG
         InSz3zNY0IPzQTNLDFqmhADvuVLarPwvatfwvr/EQjyioDL3wrasBRWer6btGzZqnqRX
         u60+PZHBkqDAHosnKcr9CGmRjXdBJfnEmL+HFX/NhV4A77sK2bVI5rn3hPzx4tCdnjPP
         TTpMN2syZJZQs5tNTXZtjCjgmjh/i9Oj5ckls+JxeHQ8jrObn6nFS84ACMgO7YBZ+FSl
         rhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=egUHntY0l18Btcd+MAvFt6A4IxhhYFZI9sARDFUH9wQ=;
        b=A5CRneUVkJjYCQFsF14Azd6QYl8xVcst0w0nBXn1SSd8ALxmmepgnNr+ibyb0x8X4f
         hyroZXTzTztaaIKtZ2yxB1YlfrdynUOUSAsYSmE9QyfqH4A20ajXnb2b1MQ3jcS4Xc7O
         erQc8QlZ5Uy72KrI2U/dUvetHz60S6y7uxVC93XUO/hwQJohjOHYWcZRHR8nXSd+CvOg
         SlnlZNANFuNfI/QcxdsrJwSf3B0MGC5FFN/Vs3PX3rWIg3FXPn6USv165eqEOx0iiLrg
         hPIHDJx+Qh4+bVtK8QeWacMy29DpSZak7DF4JeBjgoBI4DEGdPV4/7W3oHQc1MUB+CxW
         p75w==
X-Gm-Message-State: AOAM533wPIA46TjayEtyDjyxDEoiwFvBhhrG2YDogv8mIxnRwu22YpIH
        8It/eJ5y7HrNMTrvlj7wbd3/8oykuDVTKQ2d5cay4tvH
X-Google-Smtp-Source: ABdhPJxfB2gbhYTLixQXJghftagWO+hQY8MamPEyErl5jY2DwQsXpv59zV8xPZAnCvAmMj3K5nTmaQ4yR7/FMfMNyoo=
X-Received: by 2002:a5b:142:: with SMTP id c2mr983483ybp.425.1630624480487;
 Thu, 02 Sep 2021 16:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210902171929.3922667-1-davemarchevsky@fb.com> <20210902171929.3922667-10-davemarchevsky@fb.com>
In-Reply-To: <20210902171929.3922667-10-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Sep 2021 16:14:29 -0700
Message-ID: <CAEf4Bzb8BgSpKRysgX1uCcTfjd7ZmtTPkHB0H6ufAsJMe8MKvQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 9/9] selftests/bpf: Add test for bpf_printk w/
 0 fmt args
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:23 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This corner case isn't covered by existing selftests' use of bpf_printk.
>
> Just test compilation, not output, as trace_vprintk already tests
> trace_pipe output.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/testing/selftests/bpf/progs/trace_vprintk.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/trace_vprintk.c b/tools/testing/selftests/bpf/progs/trace_vprintk.c
> index 255e2f018efe..33455e48a9ab 100644
> --- a/tools/testing/selftests/bpf/progs/trace_vprintk.c
> +++ b/tools/testing/selftests/bpf/progs/trace_vprintk.c
> @@ -23,3 +23,10 @@ int sys_enter(void *ctx)
>                 one, 2, three, 4, five, 6, seven, 8, nine, 10, ++trace_vprintk_ran);
>         return 0;
>  }
> +
> +SEC("fentry/__x64_sys_nanosleep")
> +int zero_fmt_args(void *ctx)
> +{
> +       bpf_printk("\t"); // runner doesn't search for this, just ensure it compiles

C++ comments :( please use /* */

I'd probably just add this bpf_printk() in the same BPF program above
and roll it into previous patch. Doesn't seem like we need dedicated
BPF program just for this.


> +       return 0;
> +}
> --
> 2.30.2
>
