Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2A2EAA1B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbhAELmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbhAELmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:42:18 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0909C061794;
        Tue,  5 Jan 2021 03:41:38 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q137so27862353iod.9;
        Tue, 05 Jan 2021 03:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=dc3BOH7MMH0dcxYNu980rkZx8Z6ZOiyVqGx48ERObfc=;
        b=YWHVVxwzzq5xW0A03DhkYueDw+3XZg3c/XnR7VFtDzqnivceCeI6+Lg6x0jZYPifEs
         fcpX+Ff7xuiPkT/FOK/d92H6e5ZlvnSiY+jBr7zU6t0M0in67jW2QetttPGoKPxKfZnp
         BMMeYD7TeT2L32arYJ2E38TfCBWY/1YCpqrgQOe4587H8MIB6kg3skwOnhpyfSMVr3HS
         Q3NH8KMwLi4Bly+ZLE1UNKV1pOyJ5PkL6xSAQ1CHrgOIHvf/ST8TZG5GU7WyU5/98k5G
         SpV9mEqAmmgfwBO1jqiB0zd3x5wnzqCQWMqvkBAjO2Jr4zG9iHmG252UVSMZBP1DQnWV
         +agA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=dc3BOH7MMH0dcxYNu980rkZx8Z6ZOiyVqGx48ERObfc=;
        b=uFYI54TalEu0X98MIiUakAdsB3bW+MBb4+wm4MQlaFIxUPeorKNiakrtUfAofCsDzf
         PbhXj27t//QDzyyrzeBIEmE2jH55/7/R9N22WC1+sbDtL0SukKFYQbt9wag8H7gj2kTp
         WFnc4vJPlexmX76jfbBAutPmGWAyZTugbAanZ7WhJgSGplMAGe5c7mwxao/Rw833800k
         OkYo82wmZmReLhnav7g+xdhDbemdQdUXmIvy184V8Hm397y+C5zBYaTqlCdcCnf94xWq
         rr43s/bWd+NN8dVpKQ1u5FMeRl1icourftp1+6u1xdiYiei4GjORbcuC90YqR/t0jt7P
         041w==
X-Gm-Message-State: AOAM532e55JWFZFJ95ItASgCnLdVAhC90nRWBmV9OqDZQxmnD9uYLIg8
        zLXdNbvTm/3/uN5lRZ4F2DPFWlAfd8NZwcwB
X-Google-Smtp-Source: ABdhPJwiTZCnAiDwN57538vOJDQ6TBPpQEg/nBnojLkehjfq5z4g+CwfCHr+5a5Se2xn+/rPXzYxRQ==
X-Received: by 2002:a05:6602:24cb:: with SMTP id h11mr1251608ioe.79.1609846898107;
        Tue, 05 Jan 2021 03:41:38 -0800 (PST)
Received: from Gentoo ([156.146.37.136])
        by smtp.gmail.com with ESMTPSA id v6sm42027553ilo.61.2021.01.05.03.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:41:37 -0800 (PST)
Date:   Tue, 5 Jan 2021 17:11:46 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
Message-ID: <X/RQeqAikxaCO2o0@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, zhengbin13@huawei.com,
        baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
 <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
 <X/RD/pll4UoRJG0w@Gentoo>
 <CAGRGNgVHcOjt4at+tzgrPxn=04_Y3b16pihDw6xucg4Eh1GFSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IhVH58asFj2k5MBn"
Content-Disposition: inline
In-Reply-To: <CAGRGNgVHcOjt4at+tzgrPxn=04_Y3b16pihDw6xucg4Eh1GFSA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IhVH58asFj2k5MBn
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 22:24 Tue 05 Jan 2021, Julian Calaby wrote:
>Hi Bhaskar,
>
>On Tue, Jan 5, 2021 at 9:48 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>>
>> On 21:33 Tue 05 Jan 2021, Julian Calaby wrote:
>> >Hi Bhaskar,
>> >
>> >On Tue, Jan 5, 2021 at 9:19 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>> >>
>> >> s/defautly/de-faulty/p
>> >>
>> >>
>> >> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> >> ---
>> >>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> >> index c948dafa0c80..7d02d8abb4eb 100644
>> >> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> >> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> >> @@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
>> >>         u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);
>> >>
>> >>         /*beacon packet will only use the first
>> >> -        *descriptor defautly,and the own may not
>> >> +        *descriptor de-faulty,and the own may not
>> >
>> >Really? "de-faultly" isn't any better than "defaultly" and in fact
>> >it's even worse as it breaks up the word "default".
>> >
>> hey, it was written as "defautly" ...and that was simple spelling mistake ..
>> so,corrected it.
>
>Er, no, that isn't the correct replacement. They're using "default" as
>a verb and mean "by default".
>
>The sentence makes no sense with "de-faulty" there instead.
>
>Ultimately though the entire comment barely makes sense, so the best
>way to fix this spelling mistake is to re-write the entire comment so
>it does. I would have suggested a new wording for it, but I don't know

hmmmm make sense...

>enough about what's going on here to parse the rest of it.
>
>So therefore someone who knows what's going on here needs to fix this

>and your change is just making this comment worse.
really??? Not sure about it.
>
>Thanks,
>
>--
>Julian Calaby
>
>Email: julian.calaby@gmail.com
>Profile: http://www.google.com/profiles/julian.calaby/

--IhVH58asFj2k5MBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl/0UHYACgkQsjqdtxFL
KRXABgf+JnikP6OEx/OqXX8t+p0m5fgEtx52vDr0BQq5hCb4cf5XOEjbKVWBpngE
DUmCl3StxguVCKWTsIBaNcBQLHPaeHAbSAQ0MDo62gDj7NXKekPPjwVQ9jzM/aDr
8Qsut9J1Zv4Uj2K8rxu3lYw4l8ESM2efGHJuMmrsnhp5ar2cBcsUTtSNWcCXZrzJ
ANxWOLuxpA//ZqABcBEe3hx5T7E+SKafYS2ssODx02iO1ZwU1cOpm0WqYnjvFnEm
Bww8ODcPbJ7+Cq+NSwtISdRwY33jbBO6hOCm2Ga0SXCBax2Yn9W0CSvRE6dO1Gca
AK3+E0IO9btYfPKjVpmP++uj04Qp6A==
=R0yo
-----END PGP SIGNATURE-----

--IhVH58asFj2k5MBn--
