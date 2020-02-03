Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B70C1509A4
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgBCPTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:19:03 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51527 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgBCPTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:19:03 -0500
Received: by mail-pj1-f68.google.com with SMTP id fa20so6500281pjb.1
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 07:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YtI3wko9t2oOAIREAUfJm0gqwgXj0Ak15/2Y+WhYEy8=;
        b=k9Vsr0TwVe7g/4grDXN9hkJZJsbpojRFe3qfhI1TxV6zt/LLOSkhRwXU6hfe7YqeIP
         E/fyx1pRXp/R4tj/PvG78ZU2TLLW/JfE+Rme1VSK6lwhOoY940Ah24K44tA/zijDf/Vc
         Gl0p33bU5YYSU505zeGLXcTwPZ6FwDhkkL0wdSCQlpO5ro6gAVWepUZ6a1bKmvCj7XZX
         0Jm/k+Rf0SO2r+V6GQGJdTD70xzXbhRkAy5Vtgpv7LZiIROm/IgcX/6/cGzN7Yi9K+I/
         hpjT68/m5N5WfiS5Plckd6tDJ9m1uYTyd55RYt4J1fiGQ/xf/DTzFEw4gDKtyLTMj5Kx
         jGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YtI3wko9t2oOAIREAUfJm0gqwgXj0Ak15/2Y+WhYEy8=;
        b=AyOSzq/fk0yxHfG3UTbVyn2Qo5cJ1EJPAJb/d/JIFrY4dWZAV9w7eROkgFHG3kI2vA
         vT6YiB8Ypw4Yy3LMUReyGUOOGHkcDnToJOcSh+aUSd5W/X2MuiNEUYXFym/TMYCU/Qov
         CE1rf7+sHKzkYhl8azlblYSDH5fw58Z+6qamJW77Sf/sM+raT7DxbCRFRIa9oajSjJw0
         piWKmr5ziYMCoeiAAFJfWqzGK5YeV/Qj1NQFoVRFVe7cismChn7X3tE3tdEPSNqor6QB
         iqKBx6Z1YKxg9ECEOJEjObTEOrkQr4mYvNIx1tzIHMxX/t3FSwbBnVADvy8QzWVX2np5
         RGew==
X-Gm-Message-State: APjAAAX8f7LaeSf/trpQAgQDfI7fATbmq25Bov5iu27Q6NM3F111kPaK
        zsGpxEcpK6tCN4HfSs4v55u4Pd1eoa3n6Fj6JW8PZw==
X-Google-Smtp-Source: APXvYqydqwFjJ7KIhfrB5Pm4jGzVBOS+I28Gm5EkJXdXEK+sFb79PGm4CuD3XNTph9XeVjoQg+idlgI4TsJauIBmlMU=
X-Received: by 2002:a17:902:760e:: with SMTP id k14mr22914555pll.119.1580743140892;
 Mon, 03 Feb 2020 07:19:00 -0800 (PST)
MIME-Version: 1.0
References: <20200130015905.18610-1-natechancellor@gmail.com>
In-Reply-To: <20200130015905.18610-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 3 Feb 2020 15:18:49 +0000
Message-ID: <CAKwvOd=kehh2A6O1my6FbYtSU7e=p0JVM0+RBSF=rpPU7QWbOw@mail.gmail.com>
Subject: Re: [PATCH] ath11k: Silence clang -Wsometimes-uninitialized in ath11k_update_per_peer_stats_from_txcompl
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        CI Notify <ci_notify@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 1:59 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns a few times (trimmed for brevity):
>
> ../drivers/net/wireless/ath/ath11k/debugfs_sta.c:185:7: warning:
> variable 'rate_idx' is used uninitialized whenever 'if' condition is
> false [-Wsometimes-uninitialized]
>
> It is not wrong, rate_idx is only initialized in the first if block.
> However, this is not necessarily an issue in practice because rate_idx
> will only be used when initialized because
> ath11k_accumulate_per_peer_tx_stats only uses rate_idx when flags is not
> set to RATE_INFO_FLAGS_HE_MCS, RATE_INFO_FLAGS_VHT_MCS, or
> RATE_INFO_FLAGS_MCS. Still, it is not good to stick uninitialized values
> into another function so initialize it to zero to prevent any issues
> down the line.
>
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Link: https://github.com/ClangBuiltLinux/linux/issues/832
> Reported-by: ci_notify@linaro.org
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch. A bit tricky to follow that this (previously) is safe.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/wireless/ath/ath11k/debugfs_sta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/debugfs_sta.c b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
> index 743760c9bcae..a5bdd16d6d46 100644
> --- a/drivers/net/wireless/ath/ath11k/debugfs_sta.c
> +++ b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
> @@ -136,7 +136,7 @@ void ath11k_update_per_peer_stats_from_txcompl(struct ath11k *ar,
>         struct ath11k_sta *arsta;
>         struct ieee80211_sta *sta;
>         u16 rate;
> -       u8 rate_idx;
> +       u8 rate_idx = 0;
>         int ret;
>         u8 mcs;
>
> --
> 2.25.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200130015905.18610-1-natechancellor%40gmail.com.



-- 
Thanks,
~Nick Desaulniers
