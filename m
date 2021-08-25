Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32293F79F9
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbhHYQQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbhHYQQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:16:14 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C1DC0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:15:28 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id g8so96021ilc.5
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ojab.ru; s=ojab;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBQ7/GEOmYXjqJRDQP512nK1xmzb2LUIy5CzP7HmLLc=;
        b=Le+0CERPASqTwIsSfzVaah29zkhbQegc50elIeB//BGmKeq/nqrS+dWxbohxzVbCsT
         h8M54sG98n2ayYPHa7thQjLg244JEA9OQVIK+USUQvYoNrBXzGcB0QAIuTt5UZalOgWI
         7WYNIMxhzOj2PVBzbH04wbIAYcwDPMwFLOQrs7VwyRB7sznMSKDrRXtkSReIu0C5x58S
         wj6+fI5ROlCLW+2Kz0GN4/lzi0U9sH+C2mTI38hRN+z7NqqVdhlWBT6FnMXwahRf8wyh
         7C7L95dflKKXVg/Q1fbUL/cZsyfdhMxmYSyiJA6YfoKwwCJ+RCjnvdSomgDJ5Uy8OPHY
         7v2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBQ7/GEOmYXjqJRDQP512nK1xmzb2LUIy5CzP7HmLLc=;
        b=JAZE5mNJdxIrb9RjSSEnvP462Xrj91dmAZvnPUv5FtuJCmyZ+3TdujRKNQtS232M6p
         OC78cSb15bgEMhvSAygIZIAyGAp4YMFGdwq/biVksRkKVAoG9Noj5+S38anNz9wWoLC1
         TTR4sVn/fZxUwjA+gt8MDW6LdzB+GNKPr/em8e26nCH5uCKzaMQp8PTbljOY72QMXMV1
         UerOuCUCYA4lypQvwi9sI6wk3X9TEvVutCmyh0dOdkx6JsJUQ4Oz76DdrXCZDcmzi3al
         SPMQjNGTtKmqKfRyEbmdMwV94kC8AhXQYjAt5nccngCNhhrMk64ny1iCsyY4wSqypONZ
         Kp0Q==
X-Gm-Message-State: AOAM5322RfzVy4frfBswqK7EcroMl1IG83emoeVJYgVw7ev4CdG/bMBu
        4i+uGsyVGWYQWac2xO++T1GLtNmnoknK7ET/M0Bi9w==
X-Google-Smtp-Source: ABdhPJyadvErapiS94DOEhvjeAXjHPr6wwH/FOcNWNYsGlyYK8iYlTrYsnOCICA7ZuQRZDvHJbiSP+9lePQkbVIw4vY=
X-Received: by 2002:a92:a008:: with SMTP id e8mr30590006ili.187.1629908127732;
 Wed, 25 Aug 2021 09:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210722193459.7474-1-ojab@ojab.ru>
In-Reply-To: <20210722193459.7474-1-ojab@ojab.ru>
From:   "ojab //" <ojab@ojab.ru>
Date:   Wed, 25 Aug 2021 19:15:16 +0300
Message-ID: <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can I haz it merged?

//wbr ojab

On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
>
> After reboot with kernel & firmware updates I found `failed to copy
> target iram contents:` in dmesg and missing wlan interfaces for both
> of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
> it, so while I have no idea what's actually happening, I don't see why
> we should fail in this case, looks like some optional firmware ability
> that could be skipped.
>
> Also with additional logging there is
> ```
> [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
> [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
> [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
> [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram contents: -12
> ```
> so exact branch could be seen.
>
> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> ---
>  Of course I forgot to sing off, since I don't use it by default because I
>  hate my real name and kernel requires it
>
>  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 2f9be182fbfb..d9fd5294e142 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
>         u32 len, remaining_len;
>
>         hw_mem = ath10k_coredump_get_mem_layout(ar);
> -       if (!hw_mem)
> +       if (!hw_mem) {
> +               ath10k_warn(ar, "No hardware memory");
>                 return -ENOMEM;
> +       }
>
>         for (i = 0; i < hw_mem->region_table.size; i++) {
>                 tmp = &hw_mem->region_table.regions[i];
> @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
>                 }
>         }
>
> -       if (!mem_region)
> +       if (!mem_region) {
> +               ath10k_warn(ar, "No memory region");
>                 return -ENOMEM;
> +       }
>
>         for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
>                 if (ar->wmi.mem_chunks[i].req_id ==
> @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>                 if (status) {
>                         ath10k_warn(ar, "failed to copy target iram contents: %d",
>                                     status);
> -                       goto err_hif_stop;
>                 }
>         }
>
> --
> 2.32.0
