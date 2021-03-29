Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B60B34D8CC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhC2UFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhC2UFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:05:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E631561959;
        Mon, 29 Mar 2021 20:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617048310;
        bh=2++uRKTU4b8WWT9+vLiSjF8hbqooGsi8cRzTV06BIUQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JteAGXDeqZGzWh5gwim4TjGjyw45Xh39iDdWsW0sD73DHkPTRcbbUlzkfLpWsGzLF
         faGJ8wPweUfxEPJzIrCvYm+K4IqHPuFkSXvsMrZtHztr4WMOH5AsDlJ37LCN5PLKkZ
         I7QBlhin0qMxviE3mOUVz/lOLDiQwsVDvrJUcfIF1XajhbsaQAzfqhCZUe6/gjf+JG
         BEBcSqzoRoG3DGSR3M6n+hXyjHG7VOP0kvw5Y/4r9aXYMkE9eKt/RDwx/fC2r8Bcrw
         YM3jRRoq7Zfo1BN0xfFVxQv76nuUfbxwqYUOZWWzcVeXe9Vc/tqywzeFMRSgSrMyiU
         mrxcG0XJTanCw==
Received: by mail-lj1-f175.google.com with SMTP id u4so17331037ljo.6;
        Mon, 29 Mar 2021 13:05:09 -0700 (PDT)
X-Gm-Message-State: AOAM531xh2aP8V1NAQDf+UWYacfoHJFXgnk1omJAXvJFhSO7VHs7igvk
        ph0tYk9uZP/rhGDFXMW24zQBtFDfhooxU054zJw=
X-Google-Smtp-Source: ABdhPJygEQ9lfnd9I5K8XYuLNeiEtYlNMTXr2rh8VK6zhBztNef0K3tBq2Lw29o4mAGcmIOEzHOAxDMeYN5ioZMmSIg=
X-Received: by 2002:a2e:809a:: with SMTP id i26mr18623975ljg.357.1617048308267;
 Mon, 29 Mar 2021 13:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210330020656.26bb2dfd@xhacker>
In-Reply-To: <20210330020656.26bb2dfd@xhacker>
From:   Song Liu <song@kernel.org>
Date:   Mon, 29 Mar 2021 13:04:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Y1DGP-F2=R7ni7VqnGVes+g2xWWuT-ADOfRPTEkF=mg@mail.gmail.com>
Message-ID: <CAPhsuW4Y1DGP-F2=R7ni7VqnGVes+g2xWWuT-ADOfRPTEkF=mg@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: add LDFLAGS when building test_verifier
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 11:13 AM Jisheng Zhang
<jszhang3@mail.ustc.edu.cn> wrote:
>
> From: Jisheng Zhang <jszhang@kernel.org>
>
> This is useful for cross compile process to point linker to the
> correct libelf, libcap, libz path.

LGTM:
Acked-by: Song Liu <songliubraving@fb.com>

btw: Do we also need LDFLAGS for some other binaries, like test_cpp,
TRUNNER_BINARY, etc?

Thanks,
Song

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
