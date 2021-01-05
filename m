Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045A62EA9D5
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbhAEL0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAELZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:25:54 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8E5C061795;
        Tue,  5 Jan 2021 03:25:33 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id b26so71792356lff.9;
        Tue, 05 Jan 2021 03:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/gWy++eAimDPktI4LIXt2raUQtiJ+JTKWeKyj4AzSs=;
        b=mfAnm64zGHKDb1cgB3lnY7ptnmD33qyt6MzIsGtxGzXWO5QisUMAfnl7tDwumXNJ7x
         llPFBW9ftyAhNYyW19npGmgMNBYQCaEG8Lq7wY2ib+Ohn4E1t0jn4UNnBPl3DQGlj0T9
         DiNlUVbpzV0G48nxj03j+uQvFxqjeDlWAjGZg4muUgM1nNeQmWvUNswYbqpouP1Qo9zU
         foz1tbYLlG+ejU7TyFURU140auYC7CPso7prHbbxUHqy1d66vvb30cA4zvdEoZvuvKxV
         uqJXpTnVHSOMXvvU9U2yRC0yxj/Q8SzzmqaGvtaICXHv9SdvVLEdG70qDAXnGbEPnqU1
         5SaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/gWy++eAimDPktI4LIXt2raUQtiJ+JTKWeKyj4AzSs=;
        b=nBMNu5QVwEEtinbmyf/6gQvUaUkFzvK4XvcIqvub4dJr7f9ZrcClfoEMlvUORPHz+/
         xZLnMJ5o4GikgcpAqMtDYivklZwRX/tQlowyuXm9zqTPpkk9uhKGf9UWltZynoi5Rvv4
         UrltC/EqoU36XzglC+BIqYomAT/F/17xe3FbheTD0GyYVY3eh/wOgGZp2t3Qw3YAYqUP
         sdzy/cEIyfqj4f2uiEnpRXnAH6dghBDaIzolFTnoJTcE777gcGZJm7wisnXyqqciRdPW
         RXNqJgBHFWczQiLZ+XIIDiS0Pm9T9bfmulSSidCTHi5VWd6NI/8U5qW6li8O5tIJ9bFB
         7YZA==
X-Gm-Message-State: AOAM532YkQ7K2pM3J3aGSH1yCswsllgfywKEeJlhJdzyTiZ7EC2/68DQ
        uCjRQrsW70GcIkyhhmvVL+UwtzE7iP6d3fDkHlI=
X-Google-Smtp-Source: ABdhPJyrPAqvc8pvf+Cg2S2Q2qqmvgstp0uLjXpxdmyPDyd7E8qb7To9ZBwkd+THx5NWkwYaq7ZKmj6suYTOj+Gv49I=
X-Received: by 2002:a19:8642:: with SMTP id i63mr14476146lfd.179.1609845931597;
 Tue, 05 Jan 2021 03:25:31 -0800 (PST)
MIME-Version: 1.0
References: <20210105104420.6051-1-unixbhaskar@gmail.com>
In-Reply-To: <20210105104420.6051-1-unixbhaskar@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Jan 2021 22:25:20 +1100
Message-ID: <CAGRGNgX_Lc=OqWNkquSD2YXjPDSmbku3iBGu1atQtgLZsCET1A@mail.gmail.com>
Subject: Re: [PATCH] drivers: rtlwifi: rtl8821ae: defautly to de-faulty ,last
 in the series
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

On Tue, Jan 5, 2021 at 9:48 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
> s/defautly/de-faulty/p
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
> index 9d6f8dcbf2d6..0e8f7c5fd028 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
> @@ -970,7 +970,7 @@ bool rtl8821ae_is_tx_desc_closed(struct ieee80211_hw *hw,
>
>         /**
>          *beacon packet will only use the first
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
