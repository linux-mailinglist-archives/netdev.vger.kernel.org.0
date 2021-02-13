Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450CB31A950
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhBMBIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhBMBHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:07:35 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B1C061221;
        Fri, 12 Feb 2021 17:05:57 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e24so1108829ioc.1;
        Fri, 12 Feb 2021 17:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QS14DSyVoYhnhBJd21fvPa5ns3qQm6pUG7hqDGWG8vw=;
        b=e21mlly4RMovvZSEAJRHLx/QaJF4ajPzMw26KUS04VJiinMuK+vLuGX0TNyn1aGGKy
         6pU71ZghPVYNFPMYLpz1jpGI7a6XWBv+8ssGT5RcXwiXw1KrJhPMdtlvN46B63qBG/lG
         b5T2aiAHobwvRQPNjk1afqrF+2rrTRmxRSigXJ/HGISc6F69VjUtuwmMyz7CvUcO77Au
         3WFlfdjj0d5oZNcgLCZ9zjv4DGq5oxdQ1e+RavQG+ADC8tGmEH8TvzGSpIcqbpJSJRXH
         FkT7qomKItOLe+04HELsTqsAObZ91SOKSvLiHbd+ngNyVBP81VUBYvMzBKuB4U1soU7i
         BIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QS14DSyVoYhnhBJd21fvPa5ns3qQm6pUG7hqDGWG8vw=;
        b=GpIO3AZj14nWLkTkMCd8P7jCH5eGy1wFqAoFrbB9GVHSmsxZvlZ/QtkiZ7NhQwepdq
         0uiKOKO4uE1oreJ8lWMPmZ2ryO/W0hWZYo1qAwd/OPhMqOzYhEQNpHptctUEvOpKH/OO
         QgoG8iGCMGnc2ifc5tQf35k9Djj/rwF0B1KwPbr7seYMt2rZKqQfqF6GppirdL6AWRqf
         MUtKVlmIohgt1ayPqdMC8sTG/cSR3q0DLhN5K4USU54yWE0as3riYt3ttY4q8D6UHPqY
         S/Qm5TEFBgdo5mWL+MNPIFQDKsSL0ncDu16w3oYR63hezl2MPe9K5h+0+yzcGXr1OpfJ
         Umnw==
X-Gm-Message-State: AOAM5339xq/Wu33JICR6GrRbyrkBW+xAep0r1XSdsUru0fr9TyWGl7kT
        yEXFGtLeT5rfLdeEyVwghv3H1gXFHZ54KXb/BDk=
X-Google-Smtp-Source: ABdhPJwrhkkBcra8U/GdViG9g3Kc8Yi6uSathKWPlzx4gali43VFI0yGB3DYbrtC7LmINKU2Fs0gdttVuf5VH6bDH9Y=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr4338955iov.5.1613178356468;
 Fri, 12 Feb 2021 17:05:56 -0800 (PST)
MIME-Version: 1.0
References: <20210212143402.2691-1-elder@linaro.org> <20210212143402.2691-5-elder@linaro.org>
In-Reply-To: <20210212143402.2691-5-elder@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Feb 2021 17:05:45 -0800
Message-ID: <CAKgT0Ue7x9M9qyLffeXDLv0D3gnFzimAbd==5A_t0r3WpxMgcQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 4/5] net: ipa: introduce ipa_table_hash_support()
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 6:40 AM Alex Elder <elder@linaro.org> wrote:
>
> Introduce a new function to abstract the knowledge of whether hashed
> routing and filter tables are supported for a given IPA instance.
>
> IPA v4.2 is the only one that doesn't support hashed tables (now
> and for the foreseeable future), but the name of the helper function
> is better for explaining what's going on.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: - Update copyrights.
>
>  drivers/net/ipa/ipa_cmd.c   |  2 +-
>  drivers/net/ipa/ipa_table.c | 16 +++++++++-------
>  drivers/net/ipa/ipa_table.h |  8 +++++++-
>  3 files changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
> index fd8bf6468d313..35e35852c25c5 100644
> --- a/drivers/net/ipa/ipa_cmd.c
> +++ b/drivers/net/ipa/ipa_cmd.c
> @@ -268,7 +268,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
>         /* If hashed tables are supported, ensure the hash flush register
>          * offset will fit in a register write IPA immediate command.
>          */
> -       if (ipa->version != IPA_VERSION_4_2) {
> +       if (ipa_table_hash_support(ipa)) {
>                 offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
>                 name = "filter/route hash flush";
>                 if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> index 32e2d3e052d55..baaab3dd0e63c 100644
> --- a/drivers/net/ipa/ipa_table.c
> +++ b/drivers/net/ipa/ipa_table.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>
>  /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
> - * Copyright (C) 2018-2020 Linaro Ltd.
> + * Copyright (C) 2018-2021 Linaro Ltd.
>   */
>
>  #include <linux/types.h>
> @@ -239,6 +239,11 @@ static void ipa_table_validate_build(void)
>
>  #endif /* !IPA_VALIDATE */
>
> +bool ipa_table_hash_support(struct ipa *ipa)
> +{
> +       return ipa->version != IPA_VERSION_4_2;
> +}
> +

Since this is only a single comparison it might make more sense to
make this a static inline and place it in ipa.h. Otherwise you are
just bloating the code up to jump to such a small function.

>  /* Zero entry count means no table, so just return a 0 address */
>  static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
>  {
> @@ -412,8 +417,7 @@ int ipa_table_hash_flush(struct ipa *ipa)
>         struct gsi_trans *trans;
>         u32 val;
>
> -       /* IPA version 4.2 does not support hashed tables */
> -       if (ipa->version == IPA_VERSION_4_2)
> +       if (!ipa_table_hash_support(ipa))
>                 return 0;
>
>         trans = ipa_cmd_trans_alloc(ipa, 1);
> @@ -531,8 +535,7 @@ static void ipa_filter_config(struct ipa *ipa, bool modem)
>         enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
>         u32 ep_mask = ipa->filter_map;
>
> -       /* IPA version 4.2 has no hashed route tables */
> -       if (ipa->version == IPA_VERSION_4_2)
> +       if (!ipa_table_hash_support(ipa))
>                 return;
>
>         while (ep_mask) {
> @@ -582,8 +585,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
>  {
>         u32 route_id;
>
> -       /* IPA version 4.2 has no hashed route tables */
> -       if (ipa->version == IPA_VERSION_4_2)
> +       if (!ipa_table_hash_support(ipa))
>                 return;
>
>         for (route_id = 0; route_id < IPA_ROUTE_COUNT_MAX; route_id++)
> diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
> index 78038d14fcea9..1a68d20f19d6a 100644
> --- a/drivers/net/ipa/ipa_table.h
> +++ b/drivers/net/ipa/ipa_table.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>
>  /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
> - * Copyright (C) 2019-2020 Linaro Ltd.
> + * Copyright (C) 2019-2021 Linaro Ltd.
>   */
>  #ifndef _IPA_TABLE_H_
>  #define _IPA_TABLE_H_
> @@ -51,6 +51,12 @@ static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
>
>  #endif /* !IPA_VALIDATE */
>
> +/**
> + * ipa_table_hash_support() - Return true if hashed tables are supported
> + * @ipa:       IPA pointer
> + */
> +bool ipa_table_hash_support(struct ipa *ipa);
> +
>  /**
>   * ipa_table_reset() - Reset filter and route tables entries to "none"
>   * @ipa:       IPA pointer

Just define the function here and make it a static inline.
