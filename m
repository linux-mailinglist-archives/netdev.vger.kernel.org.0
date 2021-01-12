Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF02F2B09
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392469AbhALJRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731388AbhALJR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:17:29 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976CAC061786;
        Tue, 12 Jan 2021 01:16:49 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q137so2515903iod.9;
        Tue, 12 Jan 2021 01:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=0rs16umwmg5bxBnvtK2lANJcCTaRnPAf7Ji9fS2owgs=;
        b=uavE4JM+SQ9WjAfNY4123EDjxpHtFxnrMJQ+xBx//G5vy/+c78iVwzoTsQVxgR7PKi
         DDPuR3D1CKpiDQGkw22MPTi2Ge9ff+aaEI5L35g+fIRnTO9kflhyxFi5pT94MeGpr+rJ
         levaTUszl8Ba0insqGXV4r7cXfR97SdeVw4KbmFkPbvlOoHN94Cw/fIhljnnmtDzTGYx
         NMJf/LjWFkZKk+YFOaA0+IZFo6yikoksDljTEtrA0XGhPl36tnTWw1c6VjNY6Yx0oExD
         KmSaU6zm8h2yeyAly3lhCKmbJc6Eoqmw807X4Qgk7eakrP8LVsviH0BsT2Cab6YKhu6P
         Pm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=0rs16umwmg5bxBnvtK2lANJcCTaRnPAf7Ji9fS2owgs=;
        b=YFo7Gwq1OVNDQl9sMC2YCxeHFhRkijKV/AUfxCP9yvBeyEiAkFYrMmAyX/j+5tDSy7
         DAtYxuYRzojjGeo/azR9bnh4YW47aYNT0czqWXjpbHizcqMP6pTzrhiZCX+M9Zt4AXtb
         eJ+6AWUJwZVK5sGeLgVk+ks7hReQETGYXVhvGxInasCnYHz4F0FU5KY1Axz1UOVSWnLz
         g2E/jc/amN1F/2t906tVbTArWcJSlw6kzAEMXpMfszOW4cTBxf7Cb9J5yYcc3nqdYVt9
         58ID4bA371jQtqF54yF5hZctOd5WZYM1nt35JAqo+C1K06Rk3mU3FUBOEqftIen9D+VK
         VegA==
X-Gm-Message-State: AOAM533z+koAuYCcP8b+wlG0Y0pGorgJi0251Df2H+fzmRUkEhtN9jOV
        A+hut2zDwjSxng83OVlfVR4VDcjl9oO74Iz/
X-Google-Smtp-Source: ABdhPJypLzPc3VkGqoXsB90ETIw1CQZELaBrDdLsAmDTdQGly1HQtbOREa5CMrmME3phjlKvIbQZZg==
X-Received: by 2002:a92:cb43:: with SMTP id f3mr3027657ilq.50.1610443009021;
        Tue, 12 Jan 2021 01:16:49 -0800 (PST)
Received: from Gentoo ([156.146.37.213])
        by smtp.gmail.com with ESMTPSA id p3sm1461828iol.35.2021.01.12.01.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:16:48 -0800 (PST)
Date:   Tue, 12 Jan 2021 14:46:47 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH V2] drivers: net: marvell: Fix two spellings, controling
 to controlling and oen to one
Message-ID: <X/1o/0kYmtvZAU4g@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>, mw@semihalf.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
References: <20210112051342.26064-1-unixbhaskar@gmail.com>
 <458cf124-1c35-3761-4558-53283213cad8@embeddedor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qGKz3WLiFb1GZqpT"
Content-Disposition: inline
In-Reply-To: <458cf124-1c35-3761-4558-53283213cad8@embeddedor.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qGKz3WLiFb1GZqpT
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 23:20 Mon 11 Jan 2021, Gustavo A. R. Silva wrote:
>
>
>On 1/11/21 23:13, Bhaskar Chowdhury wrote:
>> s/controling/controlling/
>>
>> s/oen/one/
>>
>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> ---
>>  As Gustavo mentioned in reply, so included that missed one before
>
>This is not how you version patches for maintainers and reviewers to
>know you made changes to the patch.
>
Ahhh... Recollects my faint memory about it ...let me try again with that


>I encourage you to take a look at this to see examples on how to properly
>version your patches and other good practices:
>
>https://kernelnewbies.org/Outreachyfirstpatch
>
>--
>Gustavo
>
>>
>>  drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
>> index 8867f25afab4..663157dc8062 100644
>> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
>> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
>> @@ -143,7 +143,7 @@ struct mvpp2_cls_c2_entry {
>>  /* Number of per-port dedicated entries in the C2 TCAM */
>>  #define MVPP22_CLS_C2_PORT_N_FLOWS	MVPP2_N_RFS_ENTRIES_PER_FLOW
>>
>> -/* Each port has oen range per flow type + one entry controling the global RSS
>> +/* Each port has one range per flow type + one entry controlling the global RSS
>>   * setting and the default rx queue
>>   */
>>  #define MVPP22_CLS_C2_PORT_RANGE	(MVPP22_CLS_C2_PORT_N_FLOWS + 1)
>> --
>> 2.26.2
>>

--qGKz3WLiFb1GZqpT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl/9aPsACgkQsjqdtxFL
KRWNVwf/afQAVWUMnu6uxB9aUcKEyJCljttGzsM4k++d1Cqa4di+7WBoijmsglzQ
VQr7dNArbEoe7zd9RiIonJ6SaPE9xNR79xSFUHXr79Zx9/KFUJnY/XO+m1x2tVFY
mfsaZ+Ozr5POmkT9RYgN28uJS58+aqSZWXy6TEEzlfkcHtGpkxzYztOlywX7sXo/
fg5zMw1tpKHP9DV4O0A9TaP5dRJyeyCf60wv/JmGhIvCNIZwq0DEi+C8ziZJNGAW
QSWSIyGuR8YqFXulCsobtYRh3a/VFdzoxJz1CwEc0bsfhuL1A7i1V7J2wag8lLXV
2FHJ53DIB/yyr/Tg1agjYJqhY20IKw==
=8wes
-----END PGP SIGNATURE-----

--qGKz3WLiFb1GZqpT--
