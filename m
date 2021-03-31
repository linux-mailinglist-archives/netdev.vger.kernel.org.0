Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DB935071F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 21:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhCaTDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 15:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbhCaTCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 15:02:54 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBF6C061574;
        Wed, 31 Mar 2021 12:02:54 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i144so22295716ybg.1;
        Wed, 31 Mar 2021 12:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4YJuvsy/+GmcZTEa0tdVi7R2ikqrBhX1iPZvjApLAs=;
        b=eh6miJHWMN67GvZJKMUUlqC/vt5HffuuJekrIXqnOFja9szLbtMyRO2kQ460axt5em
         voPwdMMQ3q0ES1q7EpvecsLeEmghddOhd0LySWDFG37IUR5V3YSgFq9SVDFWFjLMs5Wl
         5fY1Jd7i7xv650MK/jcIsoBAWbRncrPdNEXAGBg8gH8Tj7Cv3AnsMlHnY3Ty0MtvAz5h
         aKulvk61B21qI3rxwRL39Ln4W89Cw+eY5SJItZtc1/XfIihM/wseanCoGxjbXYcHlnTG
         +cGAl7Tf0Clek2mGcqnr+MHuGwB1WMD3KX1huwbPC/NKnwfxIA9mfwVp2fxi6TPhEeq1
         gMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4YJuvsy/+GmcZTEa0tdVi7R2ikqrBhX1iPZvjApLAs=;
        b=d1J9T1nE03qfTxf/pR0jArl/+hUqI0J7kwKBz/Xazlz/uKpau3sm4wAY1BRqZUq9Bw
         zAqBuTbeJ4tlMuF7j/J0jFTLsxuF/uPkkihmnI/EiZ06JiNuRgh00VI7hQK+irYrM7aM
         2h55kmHKEMX9NW+kdFQxFfozRgAMUbrRKVsKQwu4OvCvdsNngq9BBKYSExgk4V9VIvpA
         eID4t3TTB4kPTXV2EG5NXqw19w5XX3oX4ukl5xExW3bC2Q77cMyGLjgoN7/uGK7TEEgk
         xMnJig5DRnsEE3gphnrPgxJryvw9tPgw9wzSQe0B5liWs1yZby2v+ehD6/mOg43w6BrW
         Gd3g==
X-Gm-Message-State: AOAM532IrP8bpfrATz7ZCZ4b3h1HM0DjkuSWLFyGnyFOQ/SILD0qWDLh
        DMlVp2CWqG4T5FfZrK6CVGXQlkpxufwx/458iuQ=
X-Google-Smtp-Source: ABdhPJwoyy0ZYnVd7MLaLqauT7nPJ6FBJnNpTBaiWgC42URXaos//I5E6tR5+2lkl7HE7aazVbTzr7Dv4aKh9XbhEeQ=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr6243094ybb.510.1617217373404;
 Wed, 31 Mar 2021 12:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210330020656.26bb2dfd@xhacker>
In-Reply-To: <20210330020656.26bb2dfd@xhacker>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Mar 2021 12:02:42 -0700
Message-ID: <CAEf4BzZv7SHKFQ1CX4omQXotA=t4Vhdbd6=1aObpNeu03tT5qQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: add LDFLAGS when building test_verifier
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 11:11 AM Jisheng Zhang
<jszhang3@mail.ustc.edu.cn> wrote:
>
> From: Jisheng Zhang <jszhang@kernel.org>
>
> This is useful for cross compile process to point linker to the
> correct libelf, libcap, libz path.

Is this enough to make cross-compilation of selftests/bpf work? I
think there was a discussion another day about cross-compiling
selftests/bpf, so I wonder if this is the only change that's needed to
make it work.

>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  tools/testing/selftests/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 044bfdcf5b74..dac1c5094e28 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -447,7 +447,7 @@ verifier/tests.h: verifier/*.c
>                 ) > verifier/tests.h)
>  $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
>         $(call msg,BINARY,,$@)
> -       $(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
> +       $(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
>
>  # Make sure we are able to include and link libbpf against c++.
>  $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
> --
> 2.31.0
>
>
