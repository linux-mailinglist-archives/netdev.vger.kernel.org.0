Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715AB314609
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBICGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBICF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:05:59 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3794C061786;
        Mon,  8 Feb 2021 18:05:19 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id r2so16617480ybk.11;
        Mon, 08 Feb 2021 18:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JO5qLiF+a+hB9CUaJSVEMzuCKkUN/wHWCBTXp26fOdU=;
        b=utKJib+zv1hs1MYwf7oH+/3ONJyPZXj1bdWxHKMZLEwUIqA29FNsCybFJ9o2RzgJmA
         peZ/XXhWFbXRhkApUez+wcwoSx485s0FqQ1RWI0xf1lBQT3B6pRbLWVVph+sHjy1rDLC
         uqY4dZ4urFYBtGQ764SAnYfTcuTuEBdIlvaPIHoigPYGn3WFEgY8BdOI6yjBVnAIHW76
         aAteUKPPP0zWhBG+J91lvyN+Q3795aTLWHB+ngITpW2M2gIk7eBjSY6HjCEQGANdaeM/
         zeg8nsswihteJUNyIasdWVYwcr0Dvv49OhuX7/XfIJjM9pe4o4on7ZLJeppqFPWiSKxF
         NSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JO5qLiF+a+hB9CUaJSVEMzuCKkUN/wHWCBTXp26fOdU=;
        b=BmlHj1Wh/ssoXN+39DMuTf0vb9VB+yJPQiISnn7T6dH1dbYUnQwezYiQTgySZsMT4W
         xynVDeuhmLlmP44E/39JwhaFU7863YjEW0Q8vdAnu6sV0kEPT+nad08McEAvnJ6CamI7
         RWCcw7C19n4eqZB37tGvxICi99S/DvhpKndZ92/hZQsPL+vPVrd6A8iSpyS30IpAUVX/
         bFFos2ctuktetfdABre2GY3m6in5xqe595EEN/Gw+KJU444z9+gvq4fzKjLMTEdnMBz0
         Gu9gVy1r0QBJxMETYRhyJL4FdZokk7kQ6qL1gvj/yYJPYtpfPS3iMS3s9VzA+RpB431V
         a9Gg==
X-Gm-Message-State: AOAM533dsANc/mjVbdnV8TaxKmidpXkzRtO/CsoYsnPHlWQwH+x+N4IB
        qLCO7vId7ViJ7SgZxCbUBJDwlX/EAdYcrQFWghU=
X-Google-Smtp-Source: ABdhPJzS8LI/HnORR5Fnz81XjOCMXBAfgvuWJ4Szw+qFQjPrBM35hOyYaLOz+T8bDTPUdV3frgxbvesSokgDED+RMNU=
X-Received: by 2002:a25:4b86:: with SMTP id y128mr29262047yba.403.1612836318942;
 Mon, 08 Feb 2021 18:05:18 -0800 (PST)
MIME-Version: 1.0
References: <1612780213-84583-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1612780213-84583-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Feb 2021 18:05:08 -0800
Message-ID: <CAEf4Bzaugcu=fYrZxkkA+fssZPJooWbwQH4hGJTJReGR63Vkdw@mail.gmail.com>
Subject: Re: [PATCH] selftests: bpf: remove unneeded semicolon
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 2:30 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Eliminate the following coccicheck warning:
> ./tools/testing/selftests/bpf/test_flow_dissector.c:506:2-3: Unneeded
> semicolon
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---

Applied to bpf-next, changing subject to have more canonical
"selftests/bpf: " prefix. Thanks.

>  tools/testing/selftests/bpf/test_flow_dissector.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_flow_dissector.c b/tools/testing/selftests/bpf/test_flow_dissector.c
> index 01f0c63..571cc07 100644
> --- a/tools/testing/selftests/bpf/test_flow_dissector.c
> +++ b/tools/testing/selftests/bpf/test_flow_dissector.c
> @@ -503,7 +503,7 @@ static int do_rx(int fd)
>                 if (rbuf != cfg_payload_char)
>                         error(1, 0, "recv: payload mismatch");
>                 num++;
> -       };
> +       }
>
>         return num;
>  }
> --
> 1.8.3.1
>
