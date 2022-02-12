Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3020E4B32E6
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 04:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiBLDuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 22:50:16 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLDuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 22:50:14 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9299B2DA90
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:50:12 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id om7so9683531pjb.5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ToDuYWxzQ7so6bNytt48fp6jQVudPA4euyEihsjYYMs=;
        b=B9EDUsS+gxqmtE6HJWaMp7iGVDfRoplYq8qSb5ROuOAr7+IAOz3MVjIpIf8+nNQWfZ
         eCSBFHGnsAin3Es+1o19PdD6WSRs4jk40Sx3FOcXZR22hQ/MRRcbSdxE1jrC0lDZ1WQC
         NdH3GJy6Q8sdv2q/Do2X6uN0tgF9vihYSS7PI31ETQ/U0fLuidIabR0PVUAAQuvalsS/
         n+wqWyi3A7ZObfV274rg8+aBTQIC/9HfNa2PWzExfs96tkVB4Gcu4UymTeVgIn+IBUwK
         +Gz2U+R1H5RDXI5pud9W5SsHVBMsWVdcqHgc7PQNl6tzxFRhXu5PeFBCl9P/ewRvqbMk
         WGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ToDuYWxzQ7so6bNytt48fp6jQVudPA4euyEihsjYYMs=;
        b=Ffyi4AFzJcqhQnJE1EbZsE9Pdf6iDhtHNaeSfNPtwSj21FbJTwA5xb2v3gO28dUjGk
         0nXkzc6Ymi4R0mC60VVt9cPFJYIn3dO2qmyldWP+9kxGXe90hClT6z/k38EpucHFXSLw
         y3sTyRnTgpVQUrf/iHjsgWutuo7io4ya78yceBDzx63+xkqsNdLpzqDT90LuPr6vsT5T
         8BJSYymWl6udg9DQAvzZxrbYlIjaWBmvu55GZC0DfGiXdGO32aggy+e6uDwNRnZOzkBG
         yplKhSOrowJVzC+dDlg6VTrtZpouwvjcfaauGK2rtXXmecr9bjGxxLwnbxg69LeIjr7l
         yMrA==
X-Gm-Message-State: AOAM532DrqapLMJeu67dZ+ENDc6mOXEKT9IQLKjBTevhO2jrOMcsSWK3
        /NGDK9/mp6ynwS4QcpW9lZk=
X-Google-Smtp-Source: ABdhPJx+n5rAwOnCrFnUG7YBgLJWGqOqtr7NyB7hkw+QF6jYxODHcHiTtl4ArKaRrSkqF+0O03H3uw==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr3492885pjb.125.1644637812002;
        Fri, 11 Feb 2022 19:50:12 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:b84a:fcb5:bf5e:eb1b? ([2600:8802:b00:4a48:b84a:fcb5:bf5e:eb1b])
        by smtp.gmail.com with ESMTPSA id 14sm19012248pgk.85.2022.02.11.19.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 19:50:11 -0800 (PST)
Message-ID: <263df461-1bd5-6cea-06c3-140f6da3b043@gmail.com>
Date:   Fri, 11 Feb 2022 19:50:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v2] net: dsa: realtek: realtek-mdio: reset before
 setup
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Frank Wunderlich <frank-w@public-files.de>
References: <20220212022735.18085-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220212022735.18085-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/2022 6:27 PM, Luiz Angelo Daros de Luca wrote:
> Some devices, like the switch in Banana Pi BPI R64 only starts to answer
> after a HW reset. It is the same reset code from realtek-smi.
> 
> In realtek-smi, only assert the reset when the gpio is defined.
> 
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>   drivers/net/dsa/realtek/realtek-mdio.c | 19 +++++++++++++++++++
>   drivers/net/dsa/realtek/realtek-smi.c  | 17 ++++++++++-------
>   drivers/net/dsa/realtek/realtek.h      |  3 +++
>   3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
> index 0c5f2bdced9d..fa2339763c71 100644
> --- a/drivers/net/dsa/realtek/realtek-mdio.c
> +++ b/drivers/net/dsa/realtek/realtek-mdio.c
> @@ -152,6 +152,21 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
>   	/* TODO: if power is software controlled, set up any regulators here */
>   	priv->leds_disabled = of_property_read_bool(np, "realtek,disable-leds");
>   
> +	/* Assert then deassert RESET */

This is extra nitpicky and I would not want you to submit a v3 just 
because of that, but the comment applies to the block of code after that 
one. Immediately below is when you fetch the reset line.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
