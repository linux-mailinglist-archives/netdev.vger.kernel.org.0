Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529D52EBE7C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbhAFNTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbhAFNTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:19:14 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D0C06134C;
        Wed,  6 Jan 2021 05:18:34 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id q137so2663117iod.9;
        Wed, 06 Jan 2021 05:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=5VBmwWJQ/Z8tEn7n5E3cHqf7DPvH3rWmDH//OQeLdX0=;
        b=KrcepEFMLoeHwbNrtoewRgL6lbhBjoI4lg+128lq6+SClTgfnL1BMinNk5FeVthz4G
         W4tWS+b+7EbcN/xNi2MJEXAWJ36syIgiev+Ylm3WqC+hiK6RaodLIc1dkwSpgfTXFXFo
         0rfmr78DEbkWkDp4ctnTn6xj5ah9S6QbfXFLS5G+uPvrcoNDNhWtChI7YXCkfAaJ9L9J
         QaLlm0RscewfFK1lNNf5cydDFDFQaXoJAtlQ42tV/YFwcVxlqt2OzDBuAKBV0m6w119j
         VKr53rrRzhqQvej2pTjg8zcv/5iXNWJdJwLyx0t0Fltl9Iztaw8RRaR760ZKVGc8bqPw
         53oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=5VBmwWJQ/Z8tEn7n5E3cHqf7DPvH3rWmDH//OQeLdX0=;
        b=BKfYiHoYYL5o2hQaQmmExu6U/movRnA3b/EGnNCwK+ijRPQOfsDv0HHbwAuOCguSUZ
         UiDCA4P4rZsZSiSK5RrnUojqdV0GrZBdJ2+4yBybC3uphg4Lkac6sXYHS6JuI5xIYOVF
         6/23q/7ehrHWqiQIg49+MNrGXRuBbx4DU7YVqWPZqghj5R8kIyrIUxxDPo8DQQNabRLz
         QLj38V5oEOAniZZjSE0b3JjG+x3lCU42P8RKqH/peoLnP8yeHZc7Y/wcrQKeU0KA0CDM
         tWxYrRve+LZqeh4633oRlRBoXl/gnsVhyklVmRdsPTz+ej2AzXrnFW1OaXPEIlW+8NNl
         VHNg==
X-Gm-Message-State: AOAM533RHcXUc1Tgx0OELUBwnjGnLckSni9xzLvPs93isSgIIsbIgiuF
        8gCF9UrfIa0o4bfCNgSAvv8GkZdO0aW5aFBY
X-Google-Smtp-Source: ABdhPJyEVln6ocpKLV7/aNPE8PKWtpkZ+ZISWLMEhbXM1kVzGNbsD+VCSWmp1KgixfB2ukDThe966w==
X-Received: by 2002:a5e:a614:: with SMTP id q20mr2823318ioi.198.1609939113786;
        Wed, 06 Jan 2021 05:18:33 -0800 (PST)
Received: from Gentoo ([143.244.44.193])
        by smtp.gmail.com with ESMTPSA id n11sm1382104ioh.37.2021.01.06.05.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:18:32 -0800 (PST)
Date:   Wed, 6 Jan 2021 18:48:39 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
Message-ID: <X/W4r1rmMCnKQAQZ@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
 <35a634c1-3672-b757-101e-9b8f3c0163a7@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8oi4LiPskI3t3s5l"
Content-Disposition: inline
In-Reply-To: <35a634c1-3672-b757-101e-9b8f3c0163a7@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8oi4LiPskI3t3s5l
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 09:02 Tue 05 Jan 2021, Randy Dunlap wrote:
>On 1/5/21 2:17 AM, Bhaskar Chowdhury wrote:
>> s/defautly/de-faulty/p
>>
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> index c948dafa0c80..7d02d8abb4eb 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
>> @@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
>>  	u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);
>>
>>  	/*beacon packet will only use the first
>> -	 *descriptor defautly,and the own may not
>> +	 *descriptor de-faulty,and the own may not
>>  	 *be cleared by the hardware
>>  	 */
>>  	if (own)
>> --
>
>Yes, I agree with "by default". I don't know what "the own"
>means.
>
>Also, there should be a space after each beginning "*.
>
>I saw another patch where the comment block began with /**,
>which should mean "begin kernel-doc comment block", but it's
>not kernel-doc, so that /** should be changed to just "/*".
>
>
Good point Randy, there were several driver file witch have "defautly" in it
and I tried to correct that.Only that spell made it a "de-faulty" as dic
suggested . But I think it should be "by default" as you said.

The comment beginning part , let me hunt down that and fix it as you mentioned
the way it should be.

Thanks Randy.
>--
>~Randy
>

--8oi4LiPskI3t3s5l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl/1uKwACgkQsjqdtxFL
KRUbSwgAqAHzxh4ctvWHliXHP4VxS9gkvFP8OO7rIqgcWx3ct6KtuoOIz0Ohs1VR
1V8prG5Ij7FFjEjbUsE1EOFrCdycIEHkCtsHKCnGC/Kxq8GI05nfYQjuqg3S+Kb0
7siy+xtkazGnccGPIVxI9lYU7mrsNom5+ojj0d+oLKiE1ndG+VTgye47koiEiSG5
SzQ1TcqPGBp5Y/rMSjLlhGz/K29I5dixNc0ixe5XIPwVBN4Fa/JdIHiZzITnjelc
AY+waGdO/DtPUUcien86TEO8izRH8E9YUFTHBOt8HbO0TW5zn4uErLmRvDmR4diP
W2Lk94eVBZwkzfVVDE+yYJWLdB/kpg==
=jlOy
-----END PGP SIGNATURE-----

--8oi4LiPskI3t3s5l--
