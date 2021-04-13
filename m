Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4574635E8A1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbhDMV6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbhDMV56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:57:58 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684EAC061574;
        Tue, 13 Apr 2021 14:57:37 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y2so17744131ybq.13;
        Tue, 13 Apr 2021 14:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5IrWTZZIN00at0dbZXH9xeks+kY6tzTsb/SQ4iJewvQ=;
        b=O+zjg3BxnvJnCCUKF1Lfub2/UaCkY5V2Y++Vg42hzincwgK/beZBfnnGtzgxNNQgL7
         6vmhGXfpiTd9v29whMVeQBGLz7uMYVlsUTDeeFyi/UX/bHDusOT+JzrNwaryutvm14q2
         QGqJA/Ls9bL2GCmgS4EQNlhn9R+WROrKREbs+TndjfsN7w/HxPLKwiZcDWGmVv0iZiBH
         0EEYhujHJG/o7RSlzDAEd8R2alQplKGJQ1fEuaZOUr5pp8A0hVK1uEtHArlevdr1u9BF
         9lh8lIdRVJPBkhT0tv4APJgu6wliOBq0mw2BdxHh91X9R1C4ZRSOl5TRTr0LVJcvPNJZ
         mg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5IrWTZZIN00at0dbZXH9xeks+kY6tzTsb/SQ4iJewvQ=;
        b=DsE58H0VWCmopR+14S4n0dbVRLUy9LzInu89UCAzIOLuqQheSRApbLdkFYdua5+7lW
         +VAzxc+rHLT9EGT3HwltyhX4tFJP+4wi5BKcvYf/VA8ganiWrAIIk4t/vy3g043Ob9tB
         SBojnABNIO88Y0Y0K+/CQyV9izU9Ll46Gjjqv8gwLYv3Lnp9xRW3ThtcuIxmccWHYyd9
         WMSoyCsK+2niJhFDbiY3XzQYzY/GKr3Er2yBSmrTTwvH8YvMI3jaE767pZBpcUiyeh04
         lnw8o9e6PTBd3HuBBrEFJRl2+RxRsFxbPuHj14RDnbRJsjjbjTFmFqRvi+oM8hyu6GdT
         daDg==
X-Gm-Message-State: AOAM530azSNl9j4U0DZSYzcy+Q3EKxvRXsp1/+RaqsLtIvBxRor/ZlE8
        nBgtiC+NYkm8D+gJtq7P+YDThwiu/fANAzfZXLs=
X-Google-Smtp-Source: ABdhPJz1gSssJ5jZyOUVlnC0frQlu0WaRblVgUfnO82oXgtwm6EVc8jQLLV9Z8FvVkIckW4frURhOUUPsGojJ1ru5Sw=
X-Received: by 2002:a25:becd:: with SMTP id k13mr44727686ybm.459.1618351056750;
 Tue, 13 Apr 2021 14:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210412162502.1417018-1-jolsa@kernel.org> <20210412162502.1417018-5-jolsa@kernel.org>
In-Reply-To: <20210412162502.1417018-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Apr 2021 14:57:26 -0700
Message-ID: <CAEf4BzZfGccOFt6hJgRyONexLyVvV4q6ydQ86zeOBFnjo8PS0w@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 4/5] selftests/bpf: Add re-attach test to lsm test
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

On Mon, Apr 12, 2021 at 9:31 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding the test to re-attach (detach/attach again) lsm programs,
> plus check that already linked program can't be attached again.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/test_lsm.c       | 48 +++++++++++++++----
>  1 file changed, 38 insertions(+), 10 deletions(-)
>

Surprised you didn't switch this one to ASSERT, but ok, we can do it
some other time ;)

Acked-by: Andrii Nakryiko <andrii@kernel.org>


> diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> index 2755e4f81499..d492e76e01cf 100644
> --- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> +++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> @@ -18,6 +18,8 @@ char *CMD_ARGS[] = {"true", NULL};
>  #define GET_PAGE_ADDR(ADDR, PAGE_SIZE)                                 \
>         (char *)(((unsigned long) (ADDR + PAGE_SIZE)) & ~(PAGE_SIZE-1))
>

[...]
