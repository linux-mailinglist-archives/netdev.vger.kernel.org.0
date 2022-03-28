Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B2F4E9148
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 11:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiC1Ja3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 05:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238057AbiC1Ja1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 05:30:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8888F38BF0;
        Mon, 28 Mar 2022 02:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DC2260F1F;
        Mon, 28 Mar 2022 09:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF3EC004DD;
        Mon, 28 Mar 2022 09:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648459726;
        bh=YbP5lj9aEd4DoYw2/KO0XgPscMHFUgkHCQI0zXuUgAI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=q2kwNuWnLPg3ldJ06RzOoGZgjEApk2emBsBlcC4DIWDBf6XS6buiB/pFE0ki2GKr6
         ErVihGEORLk+Kl/joyYFH9Qnn5WIKisIJs2koQm75vxblzUACLdba7bLBadv34jqHa
         gG/dyimPa3QMXarS8taeQrItnA+PyE+69QfmI1x+OIRN37CqA8RGmFSfy8wCk32LYd
         wWNPuDjDJII9jb6UiZjaJQY+mrErr5hXT95wGlcXLjmEq3JrFXNadx78JuJyNsfATA
         KRM4AmAlzGRVV2bBDL3KM8oNuNDKBwh/AqLu5QcMplbJuTfwuOcAa7hX9WZ9rw1WWk
         IPDzzpGq0+fyA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Benjamin =?utf-8?Q?St=C3=BCrz?= <benni@stuerz.xyz>, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
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
        nico@fluxnic.net, loic.poulain@linaro.org, pkshih@realtek.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-input@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 21/22] rtw89: Replace comments with C99 initializers
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <20220326165909.506926-21-benni@stuerz.xyz>
        <f7bb9164-2f66-8985-5771-5f31ee5740b7@lwfinger.net>
Date:   Mon, 28 Mar 2022 12:28:30 +0300
In-Reply-To: <f7bb9164-2f66-8985-5771-5f31ee5740b7@lwfinger.net> (Larry
        Finger's message of "Sat, 26 Mar 2022 13:55:33 -0500")
Message-ID: <87k0cezarl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 3/26/22 11:59, Benjamin St=C3=BCrz wrote:
>> This replaces comments with C99's designated
>> initializers because the kernel supports them now.
>>
>> Signed-off-by: Benjamin St=C3=BCrz <benni@stuerz.xyz>
>> ---
>>   drivers/net/wireless/realtek/rtw89/coex.c | 40 +++++++++++------------
>>   1 file changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wir=
eless/realtek/rtw89/coex.c
>> index 684583955511..3c83a0bfb120 100644
>> --- a/drivers/net/wireless/realtek/rtw89/coex.c
>> +++ b/drivers/net/wireless/realtek/rtw89/coex.c
>> @@ -97,26 +97,26 @@ static const struct rtw89_btc_fbtc_slot s_def[] =3D {
>>   };
>>     static const u32 cxtbl[] =3D {
>> -	0xffffffff, /* 0 */
>> -	0xaaaaaaaa, /* 1 */
>> -	0x55555555, /* 2 */
>> -	0x66555555, /* 3 */
>> -	0x66556655, /* 4 */
>> -	0x5a5a5a5a, /* 5 */
>> -	0x5a5a5aaa, /* 6 */
>> -	0xaa5a5a5a, /* 7 */
>> -	0x6a5a5a5a, /* 8 */
>> -	0x6a5a5aaa, /* 9 */
>> -	0x6a5a6a5a, /* 10 */
>> -	0x6a5a6aaa, /* 11 */
>> -	0x6afa5afa, /* 12 */
>> -	0xaaaa5aaa, /* 13 */
>> -	0xaaffffaa, /* 14 */
>> -	0xaa5555aa, /* 15 */
>> -	0xfafafafa, /* 16 */
>> -	0xffffddff, /* 17 */
>> -	0xdaffdaff, /* 18 */
>> -	0xfafadafa  /* 19 */
>> +	[0]  =3D 0xffffffff,
>> +	[1]  =3D 0xaaaaaaaa,
>> +	[2]  =3D 0x55555555,
>> +	[3]  =3D 0x66555555,
>> +	[4]  =3D 0x66556655,
>> +	[5]  =3D 0x5a5a5a5a,
>> +	[6]  =3D 0x5a5a5aaa,
>> +	[7]  =3D 0xaa5a5a5a,
>> +	[8]  =3D 0x6a5a5a5a,
>> +	[9]  =3D 0x6a5a5aaa,
>> +	[10] =3D 0x6a5a6a5a,
>> +	[11] =3D 0x6a5a6aaa,
>> +	[12] =3D 0x6afa5afa,
>> +	[13] =3D 0xaaaa5aaa,
>> +	[14] =3D 0xaaffffaa,
>> +	[15] =3D 0xaa5555aa,
>> +	[16] =3D 0xfafafafa,
>> +	[17] =3D 0xffffddff,
>> +	[18] =3D 0xdaffdaff,
>> +	[19] =3D 0xfafadafa
>>   };
>>     struct rtw89_btc_btf_tlv {
>
>
> Is this change really necessary? Yes, the entries must be ordered;
> however, the comment carries that information at very few extra
> characters. To me, this patch looks like unneeded source churn.

One small benefit I see is to avoid the comment index being wrong and
there would be no way to catch that. But otherwise I don't have any
opinion about this.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
