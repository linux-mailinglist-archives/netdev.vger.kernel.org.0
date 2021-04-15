Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1A36161B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDOXXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbhDOXXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:23:51 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DE7C061574;
        Thu, 15 Apr 2021 16:23:27 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g38so28029225ybi.12;
        Thu, 15 Apr 2021 16:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j1XPw7b/+W7Na1k6uIGrWaUES935coxa1bqROOuqck0=;
        b=fcEgboNwM2KbKeXZUxsxv4iUUD5VHu6aoWSIl9UsrG1hhh8cXAMpOfRAOcZvrOr6rG
         rjqX8aZp9BgjChXkjYDBLL6GPPKJsEgZUqQtUEIo8wyT/zXud/f3aktfAL3/oWF73l/D
         /wrrdod/5tCk3W7gKQHZM36hV18JKSISDNbNHWwgtN/Pjo86AxbnaN8PVmjbUTveJRi1
         /ynixGrP8UDTz6KPFYC2APryR/awsggzViV6WLXfcIv2qsBi2Dkd2LVZdlKtb6k+IloQ
         KVB6ub1PjPoljydk9QTEVTadaq0G73I+CFUAb7Ti288EmxaidC0UwSk0LfA5fuxn+VlZ
         wLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j1XPw7b/+W7Na1k6uIGrWaUES935coxa1bqROOuqck0=;
        b=MEDleMAmzfzRu2rAMgO9S7lEJ8YT2bTwU1fmjt3/FkLXxDLqzmvkGJDmDngwIDBpiD
         dPgorvSrKNmlXV0QACIcj9xu3vOHJ4pNsjzG/htaw0GDdR0fdJ0KtX1TRPvXz1yY88Lv
         CXE94tkbFZnb6XTxT4eWKegYoxZIM0siFVI4+LeGWjEEslfAc3QpGtixePzS6CmmUXEp
         tL5SSb/xTuxbkR23545bMq9FpV0cV/zoZj63PPmEOGXzzjUTxWpU5FZzBbbnA7RtpKqH
         zMZTu68qE6pqon1LoP3i8Ynknx5o+ILYAPK2YEOu65aXcqyq2kzpOVUOcXOTvgLfl2pi
         rJfw==
X-Gm-Message-State: AOAM531z9IMboMZI4UGhA3ba5zjYq5d9HSzrA+HinTDkKfZQwxiDjBwg
        ftz+P+bW3Ia8dN6RkZPHgcT64QJgNoR3YY7hZa4=
X-Google-Smtp-Source: ABdhPJwVTw31i9vrY0lMD5MROXRaOW5SYbugYIgBcbALCpUENsaIG29UNXDgqWnE6v5GaoJNizTPlQcEVAkDBMf15KM=
X-Received: by 2002:a25:3357:: with SMTP id z84mr7838536ybz.260.1618529007160;
 Thu, 15 Apr 2021 16:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210414195147.1624932-1-jolsa@kernel.org> <20210414195147.1624932-3-jolsa@kernel.org>
In-Reply-To: <20210414195147.1624932-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 16:23:16 -0700
Message-ID: <CAEf4BzbF03jhVuKsdsNxnpE-TE-M7AhuHBUGPvPVWpht_JMiUA@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 2/7] selftests/bpf: Add missing semicolon
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 5:43 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding missing semicolon.
>
> Fixes: 22ba36351631 ("selftests/bpf: Move and extend ASSERT_xxx() testing macros")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

this is already fixed by 1969b3c60db6 ("selftests/bpf: Fix the
ASSERT_ERR_PTR macro")

>  tools/testing/selftests/bpf/test_progs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index e87c8546230e..ee7e3b45182a 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -210,7 +210,7 @@ extern int test__join_cgroup(const char *path);
>  #define ASSERT_ERR_PTR(ptr, name) ({                                   \
>         static int duration = 0;                                        \
>         const void *___res = (ptr);                                     \
> -       bool ___ok = IS_ERR(___res)                                     \
> +       bool ___ok = IS_ERR(___res);                                    \
>         CHECK(!___ok, (name), "unexpected pointer: %p\n", ___res);      \
>         ___ok;                                                          \
>  })
> --
> 2.30.2
>
