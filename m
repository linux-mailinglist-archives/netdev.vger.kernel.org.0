Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51DB2EA9E0
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbhAEL0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbhAEL0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:26:50 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0756DC061574;
        Tue,  5 Jan 2021 03:26:10 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id a12so71783013lfl.6;
        Tue, 05 Jan 2021 03:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCI7v7ANooZCULC72pLq7a1JFEmBmonJESDym+rY7Z0=;
        b=kilbFJJ4OYIE0D+BFknpE97whwE5IBKi5Heur10Pn4D1M5BiDNIrIFgPYz7VDUf4ID
         kT7HHoRZZgnUPi7BLC/uT6AODsEK3XmrxjGQrV+nDI5C6Wnh86Pgjq6mol0a8aB9vT2f
         ooDNd8VF9JB7S045i7h0y0bqeoLvtlYW8vUU3ePMRT3bY1ZqvZH8RTtPmr/no9dQpgHZ
         6E2qKw5PMO6JA4w/8BatG9+uccfLnOI76G2mEWpJsN/MsFz65oi96kYS2IQ0wJbRMSkA
         Z5fD+uizH7ma3e171lZUYNaebVC3Y9mxQcB2ZzHolKVpnRkCio2Jsrb9tmpso4lQCzLj
         Kr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCI7v7ANooZCULC72pLq7a1JFEmBmonJESDym+rY7Z0=;
        b=c9NXrpPIQC5LCcd4XUho1AIMHtJbg1yPqkJSfKEqFdz4xI111CUVrkzAMPRk2CH6e6
         1tfau3mUOGebpqA2wqOsjV+g+LYme7cJXRidpuvShei9+rtkILvWrdkjXEerKj6gQdfu
         3O+xZxlquFiEhnGPdnIoB2bM1f7GTekM7mp5lnMt8r1jBfIJWPH/UNgo2xtRKzYD7XDF
         2+1YhOtKzjiv7QHO53cmFm92hr5h5jP5Z2XX27TOJ6JNXGNrmwh0m+S1sK509RWCdcvy
         e00Bib1rWA9BZncamvMj3broMPT+9ih6EInJ1O0JBZchetKh5cKn8SlaTwrP7MNZO/Gs
         VYvQ==
X-Gm-Message-State: AOAM530YuVTmM5/Bqq4Qfb6pptwSPezGUTlJF6yPh5mZ6rBavwHQaFDf
        vq/5kgiW1NcUOT835bJtpP08HTov1f33Y/KQvDM=
X-Google-Smtp-Source: ABdhPJz1pNvV0c53ivGzp8KpqTt+GxkWyu/+pbUtncis71sW0vKBdzFQgamfwFnjNKbapQcFu9z9QLihgXXP0eYzM5Y=
X-Received: by 2002:a05:6512:74e:: with SMTP id c14mr37155334lfs.529.1609845968585;
 Tue, 05 Jan 2021 03:26:08 -0800 (PST)
MIME-Version: 1.0
References: <20210105104000.14545-1-unixbhaskar@gmail.com>
In-Reply-To: <20210105104000.14545-1-unixbhaskar@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Jan 2021 22:25:57 +1100
Message-ID: <CAGRGNgUsMPyKwv5_qQ14frXKyuudhDWZwZSXLnb8-c6Pk9f6vw@mail.gmail.com>
Subject: Re: [PATCH] drivers: realtek: rtl8723be: Correct word presentation as
 defautly to de-faulty
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhaskar,

On Tue, Jan 5, 2021 at 9:44 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
> s/defautly/de-faulty/p
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
> index 5a7cd270575a..47886a19ed8c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
> @@ -724,7 +724,7 @@ bool rtl8723be_is_tx_desc_closed(struct ieee80211_hw *hw,
>         u8 own = (u8)rtl8723be_get_desc(hw, entry, true, HW_DESC_OWN);
>
>         /*beacon packet will only use the first
> -        *descriptor defautly,and the own may not
> +        *descriptor de-faulty,and the own may not

Same comments here as the previous patches:

"de-faultly" makes less sense than "defaultly". This comment needs to
be re-written by someone who knows what's going on here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
