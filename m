Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDE5456333
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhKRTMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbhKRTMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 14:12:38 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1CC061574;
        Thu, 18 Nov 2021 11:09:38 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p17so6293446pgj.2;
        Thu, 18 Nov 2021 11:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=3sTFa3aRRPn62N5+j4gw0otSNv6R+NbFTPZY8A8Oadk=;
        b=fK95MnHN66/1ZN4S8MyplspWF3ZazPwgJTQEzVwrBHqhbBKAtOyNtl09JeGCIypcSw
         TLKFP5At+mytAenFQKS+g6ZNKjj370D30jlk1ZmwHDOWTtdS83esBrgRHKuIBpdghuti
         ogbZEHrfgQOIkH8bVUJh/OcRhUVVIJaoWIetkBAIZOOFQ4Zklc7lBWWW2AzX6McJpuPB
         GM7AnBKzOObh421PzYksxe5Fq4zzB4qWEJnXvS/N++oZ1BGq8BTkLRemiF/xedMBy1VU
         4NcjgSt9B1As4X8oFqp7O7c9SLc/ThC3+7Rjo5UnV5rxPS99ZjInPBHStiNTdC8nJ84e
         0S+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=3sTFa3aRRPn62N5+j4gw0otSNv6R+NbFTPZY8A8Oadk=;
        b=LHary5n5niB1nEK+/MdLqMnizuSBZgqGF9qBJleSknWisqjwrdnEWI3St7/hABiGuV
         6LY8wnFd4Mf+09PfJJZifs22nArNtMEay7TaXQot6w13F/Yl3N1tRLch8vji9RBkEt/P
         FNiusUv/JMM7arYAMmEILy5yOITKEP+R1iPESZvttvEFl6qqdOZJyjcB3YelGLVGTCbm
         2RpYw1OtcPbtzAFpiGPvqJ071tAFpjPBEg+Axfrzo4ZXWexeTcxCXa1pddTY/s/0kogL
         0KO9PhjT++lD2Vtyx6FcGCK5IVWKXA3EtzmilAfiplv0Ya4a+1KgS8OCq3b5jVEh1vEZ
         PHqA==
X-Gm-Message-State: AOAM5335z9u4woMbN6MlGomINyiAJ+eKXFHvZTso4rHCO/8C1Ju7ecl0
        7M9cQFBXIHZO8hBjdKdXEXmbkGh/UUw=
X-Google-Smtp-Source: ABdhPJydrkkGNLC5G1SaU77sSfupwfDcpBTJ2zM3XRs+EseiKlKkUvraMeHsHmf7QEIVJyTL1QuDSQ==
X-Received: by 2002:a62:1d09:0:b0:4a2:82d7:17a5 with SMTP id d9-20020a621d09000000b004a282d717a5mr46411509pfd.64.1637262577699;
        Thu, 18 Nov 2021 11:09:37 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id p14sm330103pjl.32.2021.11.18.11.09.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 11:09:36 -0800 (PST)
Subject: Re: [PATCH net v11 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20211114234005.335-1-schmitzmic@gmail.com>
 <20211114234005.335-4-schmitzmic@gmail.com>
 <CAMuHMdXj4-D9R_QAgj+vr1j79pPYmoU3uokKHBZFUv5J5jvpaA@mail.gmail.com>
 <ceacbd6b-8151-fc94-58c4-3a24d3308705@gmail.com>
 <CAMuHMdV5EJB-5F057sAdhAK-jFgyXT9j0UA8trKf+Lsj89K0wQ@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <1198287e-82b1-aed9-a1e5-13b9317d173d@gmail.com>
Date:   Fri, 19 Nov 2021 08:09:31 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV5EJB-5F057sAdhAK-jFgyXT9j0UA8trKf+Lsj89K0wQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 18/11/21 21:01, Geert Uytterhoeven wrote:
>>>> --- a/drivers/net/ethernet/8390/apne.c
>>>> +++ b/drivers/net/ethernet/8390/apne.c
>>>> @@ -119,6 +119,48 @@ static u32 apne_msg_enable;
>>>>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>>>>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>>>>
>>>> +static int apne_100_mbit = -1;
>>>> +module_param_named(100_mbit, apne_100_mbit, int, 0444);
>>>> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
>>>> +
>>>> +#if IS_ENABLED(CONFIG_PCMCIA)
>>>
>>> What if CONFIG_PCMIA=m, and CONFIG_APNE=y?
>>
>> Fails to build (undefined reference to `pcmcia_parse_tuple').
>>
>> That's what 'select PCMCIA' was avoiding before, but got vetoed. I can
>> add a dependency on PCMCIA in the APNE Kconfig entry which does force
>> APNE the same as what's selected for PCMCIA, but that means we can't
>> build APNE without PCMCIA anymore. Is there a way to express 'constrain
>> build type if PCMCIA is enabled, else leave choice to user' ??
>
> #if IS_REACHABLE(CONFIG_PCMIA)

Thanks, I'll use that then.

>>>> @@ -140,6 +182,13 @@ static struct net_device * __init apne_probe(void)
>>>>
>>>>         pr_info("Looking for PCMCIA ethernet card : ");
>>>>
>>>> +       if (apne_100_mbit == 1)
>>>> +               isa_type = ISA_TYPE_AG16;
>>>> +       else if (apne_100_mbit == 0)
>>>> +               isa_type = ISA_TYPE_AG;
>>>> +       else
>>>> +               pr_cont(" (autoprobing 16 bit mode) ");
>>>> +
>>>>         /* check if a card is inserted */
>>>>         if (!(PCMCIA_INSERTED)) {
>>>>                 pr_cont("NO PCMCIA card inserted\n");
>>>> @@ -167,6 +216,14 @@ static struct net_device * __init apne_probe(void)
>>>>
>>>>         pr_cont("ethernet PCMCIA card inserted\n");
>>>>
>>>> +#if IS_ENABLED(CONFIG_PCMCIA)
>>>> +       if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
>>>> +               pr_info("16-bit PCMCIA card detected!\n");
>>>> +               isa_type = ISA_TYPE_AG16;
>>>> +               apne_100_mbit = 1;
>>>> +       }
>>>
>>> I think you should reset apne_100_mbit to zero if apne_100_mbit < 0
>>> && !pcmcia_is_16bit(), so rmmod + switching card + modprobe
>>> has a chance to work.
>>
>> Good catch - though when switching to another card using this same
>> driver, the module parameter can be used again to select IO mode or
>> force autoprobe.
>
> The autoprobe won't work if the new card is 8-bit.

I see now - adding code to set isa_type to 8 bit if the autoprobe fails, 
and reset isa_type and apne_100_mbit to defaults in module exit and the 
probe error return path ...

Cheers,

	Michael

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
