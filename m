Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1376B262376
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgIHXLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgIHXLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:11:33 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA01AC061573;
        Tue,  8 Sep 2020 16:11:32 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h126so548369ybg.4;
        Tue, 08 Sep 2020 16:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fK4mU354PSklYuVfpadzK7cREzU8VARbra5GPxSVrIM=;
        b=FzWKqBCLVFhVwhpJ2xbARGh65Y10+Fbq3OKbLP8/fUZyGRGt0Hgpq+sZr4gnlWdJtY
         3pToZAXrzo1T0Wi3RYvfcxt7KJFofcwzYqUZpbeqJTjOEzT86OMe4QybDux0QjL34g6n
         pOuQ8Bw3cgGh9KGFCli6h+7kKFs5DXUAzKl8wxyQrBz3HY2l4GMQ0U3y8uUHHGmnxgoF
         I2BPrcn/Uxw6DIwSe288qR2HdK3SAvTtSyPr9+1rRHeZsk0ZUoe/PZXpXETUDPlkdJKW
         /B6r5Hgfoja2WX1UUHr8KW28/fs3s2lKwQRQdSecKoqSVA1a0bynbi3Ae3xQvkTLEtk+
         vFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fK4mU354PSklYuVfpadzK7cREzU8VARbra5GPxSVrIM=;
        b=lm1bXvdC7HNV+Ln74BwWK+LuFNuHRLuroU3jsHeIxYBgRWdC0lz89cM4YeVeF8zY1B
         YvnZ2FYoj4WnKfmbvVOAQabkkq8H2DmmR0asD5tWkx4b1ne2C1Ru6WFNq+Npfi8wpF9d
         yUoCs+Aby/aZzwj+aLsq1crkGnlR3uFm/6RmsWHQSkNxsxocvUb6djPP7GoiAbXQ9Ye0
         7kOtOwFO7CL+6pAkV3hLyqcs2uuYhZgn4b/MkM6x1Uc8rHBXn/DQiDdkJsZJqAvlxqw/
         JsGjcMrV3aXm7zmR4RvYCbr65YVls/Lu2Fm4sy1YE4HknViulP/Gdk1PGfay4jO0b4SI
         WH9A==
X-Gm-Message-State: AOAM530V61tcXMnYy0tuPrIYxEAdu3VZGLjvLn4u8ycuA8IK2/VK6+Rw
        SClQxbuSOxwDmvGjJ+/SiNexfXr8Ahk6d7yGvws=
X-Google-Smtp-Source: ABdhPJy22AdtTiUijhK9g7zw1gMqqO8cbiKjofa5gUEmnF0B0fEGQQbudSkhv55sZI+jsh4+qYAfUaKAFszPt2h+xoA=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr1706637ybm.230.1599606691638;
 Tue, 08 Sep 2020 16:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200908175702.2463416-1-yhs@fb.com> <20200908175703.2463721-1-yhs@fb.com>
In-Reply-To: <20200908175703.2463721-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 16:11:21 -0700
Message-ID: <CAEf4BzZJ5MfLryVjZfp4TLHLmbukTm9k9EUgko1eyPAds+A2pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: add test for map_ptr arithmetic
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

On Tue, Sep 8, 2020 at 10:58 AM Yonghong Song <yhs@fb.com> wrote:
>
> Change selftest map_ptr_kern.c with disabling inlining for
> one of subtests, which will fail the test without previous
> verifier change. Also added to verifier test for both
> "map_ptr += scalar" and "scalar += map_ptr" arithmetic.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/map_ptr_kern.c        | 10 +++++-
>  .../testing/selftests/bpf/verifier/map_ptr.c  | 32 +++++++++++++++++++
>  2 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> index 982a2d8aa844..0b754106407d 100644
> --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> @@ -82,6 +82,14 @@ static inline int check_default(struct bpf_map *indirect,
>         return 1;
>  }
>
> +static __attribute__ ((noinline)) int

just fyi: there is now __noinline defined in bpf_helpers.h, saving a
bunch of typing

> +check_default_noinline(struct bpf_map *indirect, struct bpf_map *direct)
> +{
> +       VERIFY(check(indirect, direct, sizeof(__u32), sizeof(__u32),
> +                    MAX_ENTRIES));
> +       return 1;
> +}
> +
>  typedef struct {
>         int counter;
>  } atomic_t;

[...]
