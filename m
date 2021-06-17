Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A7F3ABCD5
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhFQTfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhFQTfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:35:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646A8C061574;
        Thu, 17 Jun 2021 12:33:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso5949745pjx.1;
        Thu, 17 Jun 2021 12:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MCJAcAU9VoN4JY0oEgPtECXuC31Vy2JvOEA1VBc9sDw=;
        b=UPEsxovc2Y09xZYaBxnyeFtXo427iRLxnstW4aMwQc96vTTCjnbHq7CGo0qc3ucIEs
         g/CUgZu4SYpD/e68uh98b/fHBLEofqNvBjWVixJhWn9ge5z96IoFi26BKqbIiabKBcJ7
         esurzVlbAoIyIZqiFzUP8Po3+JYPLVV1Jt006Ioq3mMVznjHkU0b3twMSp3cSx9KZC73
         N3Lqk42ZIbKIf2akV5uDxCGB5ybfUan1WK4bPVkk5k0sXGeTCLX0LL+3qYEr0hQ/3t6C
         tBrNr30OjNUcMUIY5X2x24WrJcidycB5/z0MaYWbATMt9lnW15UmjNWWWlfNjJLuuMrl
         cjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MCJAcAU9VoN4JY0oEgPtECXuC31Vy2JvOEA1VBc9sDw=;
        b=rxOsQHicLVxvyk1zSKwjyzwUCJkEWVusF9PYu15/ZI+Av+PgZUIQHeFdwOP+Ph2exv
         9SkAcKbkiR+LdBhlGrkCEjFMUCeCFmSJ9cdD+/gA8Un3c3N5npMAOdhezTwzAecuO2KE
         e0/dGBGh9ILPw8RdpfOWIAdcM1+KjhoMfftepnfzH8km4okcrFrCX6nE1CFwAHB5m1PI
         ykb4Y5pRdBc8qyfxMeepA8ZnLUgeaPoqOTeE4Mfm5T++xQuGWipv53IEKnVWNLPTo7pg
         0E1qivLFEZkwcVkhPFAJGVZQr3QqWj+b2JNu0seTtUAj47Op4CH+k0J1v3hbMRfXGxlc
         Vf0g==
X-Gm-Message-State: AOAM533vwBInuRGFIQaluRq4MyLYmggFTgflibSCrrq1YpmkJZFT8sNk
        ehcX59r+4Boo27tyRlHDexCsf/IumjZ10w==
X-Google-Smtp-Source: ABdhPJxShRBdD1hYA4gHFNg4vtI6UYwLlOw79cNNq3C9hXnkz7MIkWY2f+jhrOxjL57HjlCbhxRXWg==
X-Received: by 2002:a17:90a:420b:: with SMTP id o11mr6830776pjg.201.1623958416549;
        Thu, 17 Jun 2021 12:33:36 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:24ad:f001:d22a:9271? ([2001:df0:0:200c:24ad:f001:d22a:9271])
        by smtp.gmail.com with ESMTPSA id c62sm5939886pfa.12.2021.06.17.12.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 12:33:36 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, alex@kazik.de,
        netdev@vger.kernel.org
References: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com>
 <1623907712-29366-3-git-send-email-schmitzmic@gmail.com>
 <d661fb8-274d-6731-75f4-685bb2311c41@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <1fa288e2-3157-68f8-32c1-ffa1c63e4f85@gmail.com>
Date:   Fri, 18 Jun 2021 07:33:31 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <d661fb8-274d-6731-75f4-685bb2311c41@linux-m68k.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Finn,

thanks for your review!

On 17/06/21 6:51 pm, Finn Thain wrote:
> On Thu, 17 Jun 2021, Michael Schmitz wrote:
>
>> Add Kconfig option, module parameter and PCMCIA reset code
>> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>>
>> 10 Mbit and 100 Mbit mode are supported by the same module.
>> A module parameter switches Amiga ISA IO accessors to word
>> access by changing isa_type at runtime. Additional code to
>> reset the PCMCIA hardware is also added to the driver probe.
>>
>> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
>> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
>> Kazik <alex@kazik.de>.
>>
>> CC: netdev@vger.kernel.org
>> Tested-by: Alex Kazik <alex@kazik.de>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>>
>> --
>> Changes from v1:
>>
>> - fix module parameter name in Kconfig help text
>>
>> Alex Kazik:
>> - change module parameter type to bool, fix module parameter
>>    permission
>>
>> Changes from RFC:
>>
>> Geert Uytterhoeven:
>> - change APNE_100MBIT to depend on APNE
>> - change '---help---' to 'help' (former no longer supported)
>> - fix whitespace errors
>> - fix module_param_named() arg count
>> - protect all added code by #ifdef CONFIG_APNE_100MBIT
>> ---
>>   drivers/net/ethernet/8390/Kconfig | 12 ++++++++++++
>>   drivers/net/ethernet/8390/apne.c  | 21 +++++++++++++++++++++
>>   2 files changed, 33 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
>> index 9f4b302..6e4db63 100644
>> --- a/drivers/net/ethernet/8390/Kconfig
>> +++ b/drivers/net/ethernet/8390/Kconfig
>> @@ -143,6 +143,18 @@ config APNE
>>   	  To compile this driver as a module, choose M here: the module
>>   	  will be called apne.
>>   
>> +config APNE100MBIT
>> +	bool "PCMCIA NE2000 100MBit support"
>> +	depends on APNE
>> +	default n
>> +	help
>> +	  This changes the driver to support 10/100Mbit cards (e.g. Netgear
>> +	  FA411, CNet Singlepoint). 10 MBit cards and 100 MBit cards are
>> +	  supported by the same driver.
>> +
>> +	  To activate 100 Mbit support at runtime or from the kernel
>> +	  command line, use the apne.100mbit module parameter.
>> +
>>   config PCMCIA_PCNET
>>   	tristate "NE2000 compatible PCMCIA support"
>>   	depends on PCMCIA
>> diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
>> index fe6c834..59e41ad 100644
>> --- a/drivers/net/ethernet/8390/apne.c
>> +++ b/drivers/net/ethernet/8390/apne.c
>> @@ -120,6 +120,12 @@ static u32 apne_msg_enable;
>>   module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>>   MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>>   
>> +#ifdef CONFIG_APNE100MBIT
>> +static bool apne_100_mbit;
>> +module_param_named(apne_100_mbit_msg, apne_100_mbit, bool, 0444);
>> +MODULE_PARM_DESC(apne_100_mbit_msg, "Enable 100 Mbit support");
>> +#endif
>> +
>>   struct net_device * __init apne_probe(int unit)
>>   {
>>   	struct net_device *dev;
>> @@ -139,6 +145,11 @@ struct net_device * __init apne_probe(int unit)
>>   	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
>>   		return ERR_PTR(-ENODEV);
>>   
>> +#ifdef CONFIG_APNE100MBIT
>> +	if (apne_100_mbit)
>> +		isa_type = ISA_TYPE_AG16;
>> +#endif
>> +
> I think isa_type has to be assigned unconditionally otherwise it can't be
> reset for 10 mbit cards. Therefore, the AMIGAHW_PRESENT(PCMCIA) logic in
> arch/m68k/kernel/setup_mm.c probably should move here.

Good catch! I am uncertain though as to whether replacing a 100 Mbit 
card by a 10 Mbit one at run time is a common use case (or even 
possible, given constraints of the Amiga PCMCIA interface?), but it 
ought to work even if rarely used.

The comment there says isa_type must be set as early as possible, so I'd 
rather leave that alone, and add an 'else' clause here.

This of course raise the question whether we ought to move the entire 
isa_type handling into arch code instead - make it a generic 
amiga_pcmcia_16bit option settable via sysfs. There may be other 16 bit 
cards that require the same treatment, and duplicating PCMCIA mode 
switching all over the place could be avoided. Opinions?

>
>>   	pr_info("Looking for PCMCIA ethernet card : ");
>>   
>>   	/* check if a card is inserted */
>> @@ -590,6 +601,16 @@ static int init_pcmcia(void)
>>   #endif
>>   	u_long offset;
>>   
>> +#ifdef CONFIG_APNE100MBIT
>> +	/* reset card (idea taken from CardReset by Artur Pogoda) */
>> +	{
>> +		u_char  tmp = gayle.intreq;
>> +
>> +		gayle.intreq = 0xff;    mdelay(1);
>> +		gayle.intreq = tmp;     mdelay(300);
>> +	}
>> +#endif
>> +
> The indentation/alignment here doesn't conform to the kernel coding style.

Good one. Checkpatch missed that for some reason...

I'll respin ...

Cheers,

     Michael


