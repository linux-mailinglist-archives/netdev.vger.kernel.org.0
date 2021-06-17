Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726533AA954
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 05:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFQDC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 23:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhFQDC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 23:02:28 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E44C061574;
        Wed, 16 Jun 2021 20:00:19 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id f84so6100774ybg.0;
        Wed, 16 Jun 2021 20:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rl7FowVa5JRhUXtNcoTre9DnDT9sbwPZ6e1vTMQ7R8g=;
        b=m5+r0C726adGv7oVjW3mB/8OJJfm5slErt3FnMT5J8XqiiNAx9S/FXKOQOoAgkHDUr
         kPPeWy++WMMH6XDADfcHd4udk5qzLFk9mMZaji0KZ6Jq1cLpeECWXgynprLPnlGwU01T
         4pE20LMoGJ3xUmsslWGRJHYlYp28Qv45K4F2RYLDyFj3j35dq6hViOR8JFGvc1jULkJL
         scVTWr4vq+RE3vfET8u2wzYjHmQjMrG2uWFg2jk566CLIz7rsNoR1q8CVjdt21C+6i1w
         zhMdMpB0UE5EObh9UhzKCTH4hU0rXr/HlaeBewf8zl8tW2UAJx91QLPn7/TsuzQnJcnA
         DicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rl7FowVa5JRhUXtNcoTre9DnDT9sbwPZ6e1vTMQ7R8g=;
        b=ZqUI/VC78bMuNSwGYlKSQeM1XlVAKXEhhlqlmD/FWA+eFzHbgWc9f+n+bO/Xnom2w/
         NgWiVpY94YlQs07A1Vl+KW+5sA3sDw7Fxr03S3wb2bODYca6vEMRswHZgzEJeBaX2cel
         C6wj/qhQpgY1qwNbBegMRUFvedxP83ae5++0sW97ixE0LYyexRaDJBep6kzu6tOCIC5Q
         6toda3Y2BHVZZaK6lBUGoadF55yDzSk84FGVZ7AmX9c3O22AQmfdMFfMZW2Ly76OZiQb
         iSdtgj5QBjo7Iz0MkxcEWwO0ebrM5MR5zvb1wMyp1sEj7a1/WgIvyVYnHzQ94ISEvHZm
         GwCA==
X-Gm-Message-State: AOAM533pqtEpOOlxRDuQF5MXDn2b0U5R4pGcrHSrHxMB0DWe4oBHbtUv
        ohwwFc/ddH0+fyBVS74/Xevy2SeR9KhOkoyPH/8=
X-Google-Smtp-Source: ABdhPJyL73jrYb6zGXj7T7ouu2eU/5urBJ3TGHq4QdPpGdxAQMaLgQ1/Le76vH/gkRfzcuhnm0eS7PN48A57JNg2Ci8=
X-Received: by 2002:a25:9942:: with SMTP id n2mr3173195ybo.230.1623898818963;
 Wed, 16 Jun 2021 20:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <1623809076-97907-1-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1623809076-97907-1-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Jun 2021 20:00:08 -0700
Message-ID: <CAEf4BzbEHmBhmLfTKH6VkHSJgkZEHR6kf7+mJCitjMXPvtWt=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix typo in kernel/bpf/bpf_lsm.c
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     KP Singh <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 7:04 PM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:
>
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---

Applied to bpf-next, adding a minimal commit message. Please always
provide a commit message, however minimal it is.

>  kernel/bpf/bpf_lsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 5efb2b2..99ada85 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -125,7 +125,7 @@ static bool bpf_ima_inode_hash_allowed(const struct bpf_prog *prog)
>  }
>
>  /* The set of hooks which are called without pagefaults disabled and are allowed
> - * to "sleep" and thus can be used for sleeable BPF programs.
> + * to "sleep" and thus can be used for sleepable BPF programs.
>   */
>  BTF_SET_START(sleepable_lsm_hooks)
>  BTF_ID(func, bpf_lsm_bpf)
> --
> 1.8.3.1
>
