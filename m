Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650DC4E839D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiCZS5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiCZS5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:57:15 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C63241B69;
        Sat, 26 Mar 2022 11:55:38 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 12so11626132oix.12;
        Sat, 26 Mar 2022 11:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=od8p5pl2U97jeU4B5zrg7n+5mCzeV+pC/ksqgi0ZrCg=;
        b=FLgjPZbpsRgixevsWBrkzNi6JX+0JOdLVae2WiE33dW2CYOkn5xqbMkUlVUP8W2wu7
         GkxJRlQBc9JikV5LxxH776y/rCGduf9iWPHNwF2JwC98xLaDJOBMG8veU5JxGQ7nOAvJ
         m/+JrXhLeGunBEipRoADOWS5rGjDCc6Gz4IggFgtvunK5yE88pyhHsgbZfGiHbN0KDJE
         NB8NTlDVtPBrxk4PUIVxhTUnFKrA8WccJDTDtm7JqRWvIiRfCooKnwEhY3aTmayCwMpQ
         V3hyLVfO0DlGQFzspBvlHmqHXQ6R9+E5kFXKetAYpzKWkBQUTmJFethoAMM1paiNI8zm
         YaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=od8p5pl2U97jeU4B5zrg7n+5mCzeV+pC/ksqgi0ZrCg=;
        b=r4k/ZLMSm2hGaZp0BJolxckS67SFML0s78RsE+8NiRJtTIJjiR7iTUcsPn2boAz2Vv
         ybz7IlRpirjSR8WbZcmDUi67Wcdi/CEzM6IC75FzjbT5nPLL5uTrMwJ4OsKlNa4JEuV7
         6kdnURfSa8SzqlfjT2hUHF2o46YRSK/+FU7aTVgoSqiwpoHmYmttls0pWSo8pEGumHfo
         VJahmxfnNxAiHJtGzGQEfZkToklM6Hkq7P71exK6vCC8vpz1uiMqqs26cOr8wMZflN/v
         PWEstBAt2MWu3qzuSeCYUKmLcIwynnKFScUNbwqPhMENULFQvDB4S2ey95MG6cdsR2IG
         iviA==
X-Gm-Message-State: AOAM530nuM0l5w3i2NKx96h5mNEYhFz/NwcMZWQRJgsZ9MFzEF3DaqbJ
        oDO63FLHbDAVpIwc7lRXkd8=
X-Google-Smtp-Source: ABdhPJwENpqHi0yoebC6ynBYdoBH1ZAUKF4tDj7px8PfwrXlpK2apNGv6Udv3OPe7ze8luScmr+hMg==
X-Received: by 2002:a05:6808:118c:b0:2d4:4194:70db with SMTP id j12-20020a056808118c00b002d4419470dbmr8444758oil.93.1648320937799;
        Sat, 26 Mar 2022 11:55:37 -0700 (PDT)
Received: from [192.168.1.103] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id k4-20020a9d4b84000000b005b2310ebdffsm4697502otf.54.2022.03.26.11.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 11:55:37 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <f7bb9164-2f66-8985-5771-5f31ee5740b7@lwfinger.net>
Date:   Sat, 26 Mar 2022 13:55:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 21/22] rtw89: Replace comments with C99 initializers
Content-Language: en-US
To:     =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>, andrew@lunn.ch
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-21-benni@stuerz.xyz>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20220326165909.506926-21-benni@stuerz.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/22 11:59, Benjamin Stürz wrote:
> This replaces comments with C99's designated
> initializers because the kernel supports them now.
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>   drivers/net/wireless/realtek/rtw89/coex.c | 40 +++++++++++------------
>   1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
> index 684583955511..3c83a0bfb120 100644
> --- a/drivers/net/wireless/realtek/rtw89/coex.c
> +++ b/drivers/net/wireless/realtek/rtw89/coex.c
> @@ -97,26 +97,26 @@ static const struct rtw89_btc_fbtc_slot s_def[] = {
>   };
>   
>   static const u32 cxtbl[] = {
> -	0xffffffff, /* 0 */
> -	0xaaaaaaaa, /* 1 */
> -	0x55555555, /* 2 */
> -	0x66555555, /* 3 */
> -	0x66556655, /* 4 */
> -	0x5a5a5a5a, /* 5 */
> -	0x5a5a5aaa, /* 6 */
> -	0xaa5a5a5a, /* 7 */
> -	0x6a5a5a5a, /* 8 */
> -	0x6a5a5aaa, /* 9 */
> -	0x6a5a6a5a, /* 10 */
> -	0x6a5a6aaa, /* 11 */
> -	0x6afa5afa, /* 12 */
> -	0xaaaa5aaa, /* 13 */
> -	0xaaffffaa, /* 14 */
> -	0xaa5555aa, /* 15 */
> -	0xfafafafa, /* 16 */
> -	0xffffddff, /* 17 */
> -	0xdaffdaff, /* 18 */
> -	0xfafadafa  /* 19 */
> +	[0]  = 0xffffffff,
> +	[1]  = 0xaaaaaaaa,
> +	[2]  = 0x55555555,
> +	[3]  = 0x66555555,
> +	[4]  = 0x66556655,
> +	[5]  = 0x5a5a5a5a,
> +	[6]  = 0x5a5a5aaa,
> +	[7]  = 0xaa5a5a5a,
> +	[8]  = 0x6a5a5a5a,
> +	[9]  = 0x6a5a5aaa,
> +	[10] = 0x6a5a6a5a,
> +	[11] = 0x6a5a6aaa,
> +	[12] = 0x6afa5afa,
> +	[13] = 0xaaaa5aaa,
> +	[14] = 0xaaffffaa,
> +	[15] = 0xaa5555aa,
> +	[16] = 0xfafafafa,
> +	[17] = 0xffffddff,
> +	[18] = 0xdaffdaff,
> +	[19] = 0xfafadafa
>   };
>   
>   struct rtw89_btc_btf_tlv {


Is this change really necessary? Yes, the entries must be ordered; however, the 
comment carries that information at very few extra characters. To me, this patch 
looks like unneeded source churn. One other concern is that this driver is 
backported to older kernels and older compilers by several distros. Will this 
change require adding extra conditional statements to the source used in these 
applications?

Larry

