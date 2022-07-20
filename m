Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677D057B17C
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiGTHPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiGTHPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:15:00 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC12D62493
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:14:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l14-20020a17090a72ce00b001f20ed3c55dso1282630pjk.5
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVkItwTHcetYXqroDuMt1lH+JgP0rFpRC16Og54SJ64=;
        b=SEMQmcQLfL7FTqdD64nANbE/RadG5iHYHFE5Ojo16Nxd4Fh0MAQqZ2WiVrxbovNDPI
         3m/zEef4JHoP9UGmF1ojhpLJqBUFapQnTiRvYan/LWJKdlvIXE6esfcOJ2KDJiEgznc5
         0k3z8xszPxHBEoEQsDWMIax3XWjFU1K9ZvLnELZtnI6xw4PYN/80AoblZYN6yfj8POzo
         PCnQkj3nOEB0U+6qB3IG9l1ypzqudIGTFs9gnUy1tVmsmFjD+YS7PTobV7sn60Xz0sOP
         aabWzHaVWyIeHror+J6D5FKppwZywlB5J82h1HEgRECEr5SR9Ji7F+3kbjtnZzJWiQCa
         /SzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVkItwTHcetYXqroDuMt1lH+JgP0rFpRC16Og54SJ64=;
        b=D2K9VXhE/26bVw0Q70CwcMbs1IA7Dxz/A/TUq/tGDLGCWFhz+ihLBLfkMcoljITy12
         rbbC9EfG8gBoNUR09BOkKORkmlEanN7JBQ4ZU11qGUSx5ap9wIjHIsaJtk4DmrkEK1bM
         h7G71YKQV5O+HQneUshvPewrxWsCFvCTzbpUHNnSqYCyY8xvLEdrcwggpXdQJP6yr76z
         zN8w3Np2TUfs58Qx/EgqxQ8rflONxS+xS41AMU+tRley2AiuDmnEQxl75AH3PdhhSXHi
         9pbhHSDzjRzN1nuZ3RskbkzQQUdXa2bQsCPZWL7hQ+fxlHWGpys1sfaJJzMQcoioTl4F
         dvJA==
X-Gm-Message-State: AJIora/fzP1zTpCcwB46cQfmZPazaFJLhwDw13hay0jzidL2kGFTZxqx
        z97tzzqpCogt6NAKIsQxZlHd3y+JHn0GRvc27I3HLHk7Se8=
X-Google-Smtp-Source: AGRyM1thKRI2Q3Wt20w/gs/+kf+0PUWGAccSpvKv4GztFsnkMc9x75eCTUOqVa70Wis9GA9jFjpgZzlnKJAZbfjdzOQ=
X-Received: by 2002:a17:90b:681:b0:1f2:147a:5e55 with SMTP id
 m1-20020a17090b068100b001f2147a5e55mr3719444pjz.159.1658301299301; Wed, 20
 Jul 2022 00:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org> <20220719143302.2071223-2-bryan.odonoghue@linaro.org>
In-Reply-To: <20220719143302.2071223-2-bryan.odonoghue@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 20 Jul 2022 09:14:22 +0200
Message-ID: <CAMZdPi8RpNvycWx7rMMSY31FDkW2Dcyw0jC-eQKKL+rzzit2Gw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] wcn36xx: Rename clunky firmware feature bit enum
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 at 16:33, Bryan O'Donoghue
<bryan.odonoghue@linaro.org> wrote:
>
> The enum name "place_holder_in_cap_bitmap" is self descriptively asking to
> be changed to something else.
>
> Rename place_holder_in_cap_bitmap to wcn36xx_firmware_feat_caps so that the
> contents and intent of the enum is obvious.
>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>  drivers/net/wireless/ath/wcn36xx/hal.h  | 2 +-
>  drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
>  drivers/net/wireless/ath/wcn36xx/smd.c  | 6 +++---
>  drivers/net/wireless/ath/wcn36xx/smd.h  | 6 +++---
>  4 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index 46a49f0a51b3..5e48c97682c2 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -4760,7 +4760,7 @@ struct wcn36xx_hal_set_power_params_resp {
>
>  /* Capability bitmap exchange definitions and macros starts */
>
> -enum place_holder_in_cap_bitmap {
> +enum wcn36xx_firmware_feat_caps {
>         MCC = 0,
>         P2P = 1,
>         DOT11AC = 2,
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index e34d3d0b7082..efd776b20e60 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -260,7 +260,7 @@ static const char * const wcn36xx_caps_names[] = {
>
>  #undef DEFINE
>
> -static const char *wcn36xx_get_cap_name(enum place_holder_in_cap_bitmap x)
> +static const char *wcn36xx_get_cap_name(enum wcn36xx_firmware_feat_caps x)
>  {
>         if (x >= ARRAY_SIZE(wcn36xx_caps_names))
>                 return "UNKNOWN";
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 7ac9a1e6f768..88ee92be8562 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2431,7 +2431,7 @@ int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
>         return ret;
>  }
>
> -void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
> +void set_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
>  {
>         int arr_idx, bit_idx;
>
> @@ -2445,7 +2445,7 @@ void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
>         bitmap[arr_idx] |= (1 << bit_idx);
>  }
>
> -int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
> +int get_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
>  {
>         int arr_idx, bit_idx;
>
> @@ -2460,7 +2460,7 @@ int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
>         return (bitmap[arr_idx] & (1 << bit_idx)) ? 1 : 0;
>  }
>
> -void clear_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
> +void clear_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
>  {
>         int arr_idx, bit_idx;
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
> index 3fd598ac2a27..186dad4fe80e 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.h
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.h
> @@ -125,9 +125,9 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
>  int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
>                              u32 arg3, u32 arg4, u32 arg5);
>  int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn);
> -void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
> -int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
> -void clear_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
> +void set_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
> +int get_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
> +void clear_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
>
>  int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
>                 struct ieee80211_sta *sta,
> --
> 2.36.1
>
