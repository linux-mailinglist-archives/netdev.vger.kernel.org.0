Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3983745770B
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhKSTfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 14:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhKSTfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 14:35:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EDAC061574;
        Fri, 19 Nov 2021 11:32:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so8657202pjr.5;
        Fri, 19 Nov 2021 11:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=d2kG+pQKvV8B6KaEnbM3pHRHAcgUV9dL/1UG79E2ndQ=;
        b=qIpTMe+gppYvN4oNtTdQcI4yUXCU2W4dPlSOdbEvY8ka4ch9MBodeJTyemK1wR1O7B
         AtcfG1gsHnZwu+JpXjqDYhlgT+jt0h8ZFh45JGBV2eMsmxphP/xRybq4vSmGlsYTn/OJ
         OINGcxfxaHNa6mlOQLEgBtN3pay0sb4jYjL9frdSbZRAj3q4/LMfyf5n1va2/p0+XFQA
         sNgVRD83kqnxZ2a5V/FvuxUWMqjvD9zroVSde/umuvNCTjiADSxUtq1zFUBNz5cnCh3U
         7ONoPH0I//ieTFc0awjqjyxLM40m8v+uhQxM0GEYqIm0RnNKnKsa2tlqHIQdhmjF+x7a
         wvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=d2kG+pQKvV8B6KaEnbM3pHRHAcgUV9dL/1UG79E2ndQ=;
        b=d/XUYLsUaJxeBFk0fRWFkh6NHzwgeQ75r0jhbI18BvQmRy6/S+pC1QuoqO5DE10+uS
         Zeu06b0r00MPl9geiBQLsKxVEbMs8gcA3RNkeG/GtZcYl+dk4xA77AiBZE3RYhXLLtqb
         iofFqdZBzimX/p2u63scbV3WZLzUMMVP5sFnH8ehlim4B+sSr1lhD4u4SElz97KLvD2n
         hA6EI8YnCXiTEB+08nXkUa+9WQkdDok+QDE8fPvFLs/jt3JK+H+8yjlxwZCM6meIxN58
         RnKQLg83e69hsQ4tAphI/ExLirwHordSakCn6p41zn7qpd2/kpl0gceBBSzjcxNSPWgK
         dWAQ==
X-Gm-Message-State: AOAM531WPpEhOq/arTeRtiixIavMzmMuZXGN2vu3XDf8OFt8KaWKAh8T
        uSx7os8gNLZA8xxWX8FQA6QikrTMJFI=
X-Google-Smtp-Source: ABdhPJz8r42RAtPyzQ9EWEgeAxcSh4SMFaASNzh5AxFd+pKrViXEmgck5txL2gsNx2h8G0rZbpXrfw==
X-Received: by 2002:a17:902:ea09:b0:141:ec88:4410 with SMTP id s9-20020a170902ea0900b00141ec884410mr81293556plg.51.1637350320569;
        Fri, 19 Nov 2021 11:32:00 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id i67sm407798pfg.189.2021.11.19.11.31.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Nov 2021 11:31:57 -0800 (PST)
Subject: Re: [PATCH net v12 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20211119060632.8583-1-schmitzmic@gmail.com>
 <20211119060632.8583-4-schmitzmic@gmail.com>
 <CAMuHMdU2fOe9E=H7k=Wt32Sg+0B1f7+2nU+dgv2eaW26aLqo=g@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <555cb10e-4613-f839-7fc8-7c23c2257f17@gmail.com>
Date:   Sat, 20 Nov 2021 08:31:26 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU2fOe9E=H7k=Wt32Sg+0B1f7+2nU+dgv2eaW26aLqo=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

thanks for your review!

On 19/11/21 20:59, Geert Uytterhoeven wrote:
> Hi Michael,
>
> On Fri, Nov 19, 2021 at 7:06 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Add module parameter, IO mode autoprobe and PCMCIA reset code
>> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>>
>> 10 Mbit and 100 Mbit mode are supported by the same module.
>> Use the core PCMCIA cftable parser to detect 16 bit cards,
>> and automatically enable 16 bit ISA IO access for those cards
>> by changing isa_type at runtime. The user must select PCCARD
>> and PCMCIA in the kernel config to make the necessary support
>> modules available.
>>
>> Code to reset the PCMCIA hardware required for 16 bit cards is
>> also added to the driver probe.
>>
>> An optional module parameter switches Amiga ISA IO accessors
>> to 8 or 16 bit access in case autoprobe fails.
>>
>> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
>> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
>> Kazik <alex@kazik.de>.
>>
>> CC: netdev@vger.kernel.org
>> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
>> Tested-by: Alex Kazik <alex@kazik.de>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>>
>> --
>>
>> Changes from v11:
>>
>> Geert Uytterhoeven:
>> - use IS_REACHABLE() for PCMCIA dependent code
>> - use container_of() instead of cast in pcmcia_parse_tuple()
>>   call
>> - set isa_type and apne_100_mbit correctly if autoprobe fails
>> - reset isa_type and apne_100_mbit on module exit
>>
>> Joe Perches:
>> - use pr_debug and co. to avoid #ifdef DEBUG
>
> Thanks for the update!
>
>> --- a/drivers/net/ethernet/8390/Kconfig
>> +++ b/drivers/net/ethernet/8390/Kconfig
>> @@ -144,6 +144,14 @@ config APNE
>>           To compile this driver as a module, choose M here: the module
>>           will be called apne.
>>
>> +         The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
>> +         CNet Singlepoint). To activate 100 Mbit support, use the kernel
>> +         option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
>> +         module parameter. The driver will attempt to autoprobe 100 Mbit
>> +         mode if the PCCARD and PCMCIA kernel configuration options are
>> +         selected, so this option may not be necessary. Use apne.100mbit=0
>> +         should autoprobe mis-detect a 100 Mbit card.
>
> 10 Mbit?

Mis-detect a 10 Mbit card as 100 Mbit would be more accurate. I'll add 
that.

>
> Sorry for reporting it only now. I had noticed in v11, but forgot to
> mention it during my review.

No matter - I'll resend with your reviewed-by added directly.

Cheers,

	Michael

> For the code:
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
