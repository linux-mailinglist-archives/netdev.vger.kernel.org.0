Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B15C2EA8E9
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbhAEKfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbhAEKfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:35:02 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8C8C061793;
        Tue,  5 Jan 2021 02:34:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r5so30489992eda.12;
        Tue, 05 Jan 2021 02:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0IitIxggjRtubYf3eiD+ChikL84gPXjPs+LCAIMgPA=;
        b=mFKwCZNzUSi+MfC3beRDBD5yhqJgixvjGSrtfskHwAzBsbGMsHYMLWr7VPunxb+xMe
         UcLbt0YlMabNOl5HwUoCe3YgrAELHuvz1EhnciFryLQ/qwzLDMOlm4p5+wqfaAYDPVXX
         yeFqpI/NG0ukMzHIYMMOKwjGyP2PJNlquqI+2HmR69n+rB1WcRGW2bd+uGEkJfyUBNmS
         997b9QI++b8Zv2iFMy914XoV66dRwNqiKovazJy224k5rH1/0wZn9jxFoYRLkjap+lQ5
         3ruPpApSKRv/RjXy1JymRwp01kyiaKFjMltE9VdnI072cBfes2c4ku7XnSX25JSvDAHw
         ACvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0IitIxggjRtubYf3eiD+ChikL84gPXjPs+LCAIMgPA=;
        b=DcKywQmnOzC8U8tr6QABhuaY+MPpSqmpXm7XrlRgfJjw6bUI46yX1bnXauY0m9+zjS
         HzI3YeoOjsEvQb7VUt1s1tQQBc8hMduk4Pe9KvUQv41jZKPtkc/ZACa7h7zLi1Wq8v21
         OSx8LNkF1ufwEjCSB8OSblce+TABJ4LiP6DXbrmas1xPvZ8JM7EEmLsNNBpuz18hs8Pb
         yPVhhygEWGvvDxk64OyoAGq2tDJt5C3uGoFclhTGl6R6UULjy3sPHqNo3px8tLUT6pFf
         EJl+H6CVbYge6w04P/7ei6S0YgUWkC8f3X5ndYjO8hQSDdsAIL75wU2CJBxTnnozcAu8
         wOTQ==
X-Gm-Message-State: AOAM531ZDEGmWiVk0fQaT2Q0NdLT/h2ER9maeLpFsuR5qxrY5b5PB2sg
        jJty36jDNIMFyltT/+cgxgUJfZCv6NdBNyNA/AE=
X-Google-Smtp-Source: ABdhPJxkdpLot+eRxy6syj0eQB6JdTmQjK+c8SzzR0blXkzKOa//8OYsWZ+g2QYDr+vMSj+y7bUkLE24JPjYB1ojNrk=
X-Received: by 2002:aa7:d154:: with SMTP id r20mr77683811edo.258.1609842860736;
 Tue, 05 Jan 2021 02:34:20 -0800 (PST)
MIME-Version: 1.0
References: <20210105102751.21237-1-unixbhaskar@gmail.com>
In-Reply-To: <20210105102751.21237-1-unixbhaskar@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Jan 2021 21:34:08 +1100
Message-ID: <CAGRGNgWfHb=5jS_Dg0pKw7q_K9mkd8S2o70OCBEnWmaJY+5V9w@mail.gmail.com>
Subject: Re: [PATCH] drivers: wireless: rtlwifi: rtl8192ce: Fix construction
 of word rtl8192ce/trx.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        baijiaju1990@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhaskar,

On Tue, Jan 5, 2021 at 9:32 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
> s/defautly/de-faulty/p
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
> index 4165175cf5c0..d53397e7eb2e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
> @@ -671,7 +671,7 @@ bool rtl92ce_is_tx_desc_closed(struct ieee80211_hw *hw,
>         u8 own = (u8)rtl92ce_get_desc(hw, entry, true, HW_DESC_OWN);
>
>         /*beacon packet will only use the first
> -        *descriptor defautly,and the own may not
> +        *descriptor de-faulty,and the own may not

Same comments here as the previous patch:

"de-faultly" makes less sense than "defaultly". This comment needs to
be re-written by someone who knows what's going on here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
