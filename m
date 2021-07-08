Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB83C19A2
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhGHTNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 15:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHTNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 15:13:21 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63855C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 12:10:39 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id k8so4097421lja.4
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 12:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=Q6c4RviuW5WtyT6vWUcuY3IxB30akI+oVkB+o+W3J2c=;
        b=h0XtUarjz8gYekZZc0Sriah/reYxWDRbdxILGvESch9q9F9ro3vBPgL5XijTTaKR4H
         IK8B0UNqCTc9wuXEMBBLmbwswyzgg2TN/bToVtjCxThU2IAm55k8bD52L0S8VPOpJPcZ
         mqMqLIDN4M3sxebPuRxdBVgs4eFWsyvqSRAaLpPACR6GhI/6ohRgbbvuc4vZTd5rv7RS
         DOBXnWDLSq3631tNivUUoUfoCD7+UFYY5TBeQVznyJBRvMgwwTvnNQmyJBbX6LkqsYOk
         8QhsOqCNc1sGoGozQm3tpB8k13MP5wOqDnjdSXZaasW+jJ5RP6wX4WEOWmhakuZ+IVCe
         g4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=Q6c4RviuW5WtyT6vWUcuY3IxB30akI+oVkB+o+W3J2c=;
        b=kQcc69uceL+OgwV2G/QbZW14TS4B8DFLog4w3x+0gE+rGPqHkVvYM05LhMVe0XYEt4
         x2lt/VeyUDfkJ53Yh13TgfqarY1qQ8oBUNpGAKJK5gFuxauu03c1nH8C+GOhzzdPWHtD
         8iboDNfT8ctyaRk0IQ32HsYsL2y8/Eo6HHol64mfhyE64QYU4Fxtktzmy7eKPmCKl78v
         2RHj7a5ZKX6bENXYsOEY4/SQVx6t7JZiaBxOHxp2FNpz+qS5Ot+yktJEUUk+sE+2fYrV
         fICpqNARA9urlbBfLEMtSw4//z3Nu4ey92ndFKmBMeNf9tEUbAhWOA1FJ4b6qz6kTOI2
         EqXQ==
X-Gm-Message-State: AOAM531gK6Sn5lWxFsp8utcdlpOTRUGMj/FTQM5eENFe4+xh49Gi9qSk
        NHrtNgSN5OiXmDkrsQTeQFg=
X-Google-Smtp-Source: ABdhPJxTCCgFLcmVlIb2JhajIp3SjAg/edE4ZDmLCPIckCo9Aa4y9IB/OSGpcvWYfiOTJOdPXgHoAw==
X-Received: by 2002:a2e:5756:: with SMTP id r22mr192251ljd.477.1625771437739;
        Thu, 08 Jul 2021 12:10:37 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id o6sm316956ljj.128.2021.07.08.12.10.36
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 08 Jul 2021 12:10:36 -0700 (PDT)
Message-ID: <60E75057.60706@gmail.com>
Date:   Thu, 08 Jul 2021 22:21:59 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com> <60D22F1D.1000205@gmail.com> <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com> <60D361FF.70905@gmail.com> <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk> <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com> <60DF62DA.6030508@gmail.com> <CAK8P3a2=d0wT9UWgkKDJS5Bd8dPYswah79O5tAg5tHpr4vMH4Q@mail.gmail.com>
In-Reply-To: <CAK8P3a2=d0wT9UWgkKDJS5Bd8dPYswah79O5tAg5tHpr4vMH4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arnd,

03.07.2021 12:10, Arnd Bergmann:
> The simplest workaround would be to just move the
> "spin_lock_irqsave(&tp->lock, flags);" a few lines down, below the rx
> processing. This keeps the locking rules exactly how they were before

Indeed, moving spin_lock_irqsave below rtl8139_rx eliminated the warn_on 
message apparently, here is a new log:

https://pastebin.com/dVFNVEu4

and here is my resulting diff:

https://pastebin.com/CzNzsUPu

My usual tests run fine. However I still see 2 issues:

1. I do not understand all this locking thing enough to do a good 
cleanup myself, and it looks like it needs one;
2. It looks like in case of incorrect (edge) triggering mode, the "poll 
approach" with no loop added in the poll function would still allow a 
race window, as explained in following outline (from some previous mails):

22.06.2021 14:12, David Laight:
 > Typically you need to:
 > 1) stop the chip driving IRQ low.
 > 2) process all the completed RX and TX entries.
 > 3) clear the chip's interrupt pending bits (often write to clear).
 > 4) check for completed RX/TX entries, back to 2 if found.
 > 5) enable driving IRQ.
 >
 > The loop (4) is needed because of the timing window between
 > (2) and (3).
 > You can swap (2) and (3) over - but then you get an additional
 > interrupt if packets arrive during processing - which is common.

So in terms of such outline, the "poll approach" now implements 1, 2, 3, 
5 but still misses 4, and my understanding is that it is therefore still 
not a complete solution for the broken triggering case (Although 
practically, the time window might be too small for the race effect to 
be ever observable) From my previous testing I know that such a loop 
does not affect the perfomance too much anyway, so it seems quite safe 
to add it. Maybe I've missunderstood something though.


Thank you,

Regards,
Nikolai


> your patch, and anything beyond that could be done as a follow-up
> cleanup, if someone wants to think this through more.
>
>          Arnd
>

