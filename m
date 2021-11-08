Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA46A449E05
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbhKHVZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbhKHVZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 16:25:23 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763B9C061570;
        Mon,  8 Nov 2021 13:22:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id b13so16946877plg.2;
        Mon, 08 Nov 2021 13:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Ms0gppu1WsSVlXH+1hGodjojHRTEhm9TIy1Gwk/m3tA=;
        b=DNbgesMT74V/N0bGnFXaljTx8YqYWQbZaIQhvPTFHmgG+K9sujhp+WCxzcIodt/mW5
         /nQcB9H47onlSRUkT7ShLkYQqoYzdmT6IQuNbSjV/t1HP0utFOzqXm2grNpPAv4J6mm7
         BV9Y9kY6OJRNaYyHaxIsVojiMdkBTPq8SYE0E4nbx5EUUo1mIVrw2byvrMGL48Izgn1W
         KpIulv0K476OVHP/cFzhf61uYR2vH0Pv28bR7pFAopFU2yxVJTaRh24VGMqnMAhNG3KE
         EB8MMq5IuPiqqRgCY8pnVLdTG+28vEVtSV13aD91PZQfIwipuwZ7OhIV0gJAGTd1K0oj
         Aq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Ms0gppu1WsSVlXH+1hGodjojHRTEhm9TIy1Gwk/m3tA=;
        b=MODBvKLl0XFT9xahn5SEB9z29iD/cOKK1ULp/I290dNFiOsad3GQ705cggmcwN/Qma
         eQIsZ4sREWyaZAoCuAT+FIYdvs2JhSGUz/s72XiZEgGrZvQQkKZNSBKAubvrSoRiSew3
         7pE7FJewDbjuZUSJqxRrArXFhntAzGIZO+eCD6EfaZM95aWI0E/K3XF1s/826YYdHt+/
         bcXezb32dHra5cB9NuJcaLG+WMxTIXm15uBEdMoj9kOCfvTnaIDDtaGF5shO1j5zfyxy
         VVHz/HK6ITTcHIi0C/uSFsUhmHUL0hXH6eSf+LJO4iRWy/FoLveacuLXtLlWug2TgNYZ
         wCYA==
X-Gm-Message-State: AOAM532AUFmmr5HUQMi1sLPzJDT8mI6OYQGZTw1Ke0cdxyDsHllqyDlj
        Uqi0FdG6ZBrydSuZKwkfsG4=
X-Google-Smtp-Source: ABdhPJwxykzkY6XPYGuOHzynltWyCQM19YmErsiiLAKyC997b55MB9BvD9Nf+O9o5fGmN+6Cgr59nQ==
X-Received: by 2002:a17:90b:128e:: with SMTP id fw14mr1499686pjb.173.1636406557907;
        Mon, 08 Nov 2021 13:22:37 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id t135sm13207356pgc.51.2021.11.08.13.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 13:22:37 -0800 (PST)
Subject: Re: [PATCH v8 3/3] net/8390: apne.c - add 100 Mbit support to apne.c
 driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20211104061102.30899-1-schmitzmic@gmail.com>
 <20211104061102.30899-4-schmitzmic@gmail.com>
 <CAMuHMdVMG8x-s-1_a2vGw3cqP=1OfDjePL+knsLR-=zjEDzN1g@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>,
        Denis Kirjanov <dkirjanov@suse.de>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <7f11aeef-f3f5-d00c-d220-4417bd1959d0@gmail.com>
Date:   Tue, 9 Nov 2021 10:22:24 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVMG8x-s-1_a2vGw3cqP=1OfDjePL+knsLR-=zjEDzN1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 08/11/21 21:38, Geert Uytterhoeven wrote:
>> --- a/drivers/net/ethernet/8390/apne.c
>> +++ b/drivers/net/ethernet/8390/apne.c
>
>> @@ -119,6 +121,10 @@ static u32 apne_msg_enable;
>>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>>
>> +static u32 apne_100_mbit = -1;
>
> The changelog said you changed this to int, not u32...

Yes, and I had certainly done that, for the express purpose of allowing 
the negative ...

No idea how that one snuck back in, I'll fix that.

Denis suggested this be changed to a sysfs parameter, but neither this 
driver nor the Amiga PCMCIA support have been converted to the driver 
framework. I couldn't see a way to add a sysfs parameter, so I'd rather 
keep this as kernel command line or module parameter.

Cheers,

	Michael


>> +module_param_named(100_mbit, apne_100_mbit, uint, 0444);
>> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
>> +
>>  static struct net_device * __init apne_probe(void)
>>  {
>>         struct net_device *dev;
>> @@ -140,6 +146,13 @@ static struct net_device * __init apne_probe(void)
>>
>>         pr_info("Looking for PCMCIA ethernet card : ");
>>
>> +       if (apne_100_mbit == 1)
>> +               isa_type = ISA_TYPE_AG16;
>> +       else if (apne_100_mbit == 0)
>> +               isa_type = ISA_TYPE_AG;
>> +       else
>> +               pr_cont(" (autoprobing 16 bit mode) ");
>> +
>>         /* check if a card is inserted */
>>         if (!(PCMCIA_INSERTED)) {
>>                 pr_cont("NO PCMCIA card inserted\n");
>> @@ -167,6 +180,14 @@ static struct net_device * __init apne_probe(void)
>>
>>         pr_cont("ethernet PCMCIA card inserted\n");
>>
>> +#if IS_ENABLED(CONFIG_PCMCIA)
>> +       if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
>
> apne_100_mbit is u32, hence can never be negative.
>
>> +               pr_info("16-bit PCMCIA card detected!\n");
>> +               isa_type = ISA_TYPE_AG16;
>> +               apne_100_mbit = 1;
>> +       }
>> +#endif
>> +
>>         if (!init_pcmcia()) {
>>                 /* XXX: shouldn't we re-enable irq here? */
>>                 free_netdev(dev);
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
