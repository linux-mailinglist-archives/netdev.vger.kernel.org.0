Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC0A3B048B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhFVMeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhFVMeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 08:34:03 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F85C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 05:31:45 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id d25so1810738lji.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 05:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=W0hXPKIk3PjPkNBedPC9hMFOiJArWgRGnFOkENQq8LI=;
        b=Z8lB3ftVVphL2C/NF9yGwZ3zenKH5ScCVakXoqt7yqCeHGDN2SOpaHVi2tegyKAW/4
         ABHE+82HS1/h72DgbtvEOPOT8vJZFw2GKUFLPxfmLcMe3k/UDBWXjaXkWHw/wtk/Tg99
         2iICDeak9WIwEx+z5wqzIUiiCtdCQN8NdsLMzV+hMPrI1dUoaEm830Ob3wHT9TVsM38E
         TnIJJWHYuBXWsvdOCHO/v18TyiKW93UvswTyxD+RXA/m7RTI4Lx6urVPSL0/ci8IshBG
         C7wRNb77p0+UxXW0vAbFiC86cij+LheoZN9sqvSLn4URfshTAG8UOhjzl2v+QRWR4/Z5
         aDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=W0hXPKIk3PjPkNBedPC9hMFOiJArWgRGnFOkENQq8LI=;
        b=W+q610MOGWSTTrV3TvpDrkJuryicJ3FPC9B8BdfhD2yP50isbtLCvjM2tri93Zjn4f
         kxK0faS4RBUfa8+KqyuPWcFfoFGRo9G0xOC9xR7vAPKVv6WQjPgriKvNzvUyh5ZFHDpQ
         VopWwVSKVTPPpR5hWA9nJHrAykZ5hKexm5x4TSqAAVqXcQOQEtdFQCXYOQ2lDpbm/ah3
         XpgDJxub94nGFADp5EH2QnIS1B322wfJRiutA08hdelu2BZVRo51yMxMzYqP3dMKMsG0
         tfcu55IfzA6NuQnwpuDsEnJQ7QhhgQMPa4QCEDGhrqFZu4970oUIUZt7uighhWAw4/0j
         xZGw==
X-Gm-Message-State: AOAM533GdEWYKt3Gmd6Vba61oV6/7cgewf4cYoJYQJr5pxVjOaaZNp0o
        uudU+9kod+19PYbk9IWd3zc=
X-Google-Smtp-Source: ABdhPJwuKO4+zrrIE1fAONnRm+cDZ4Ps/Z9tddGv8VWr0HzSCk9XVoz4jTCH6X+fwoTNuz4WwOqevw==
X-Received: by 2002:a2e:7a1a:: with SMTP id v26mr3098363ljc.362.1624365104297;
        Tue, 22 Jun 2021 05:31:44 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id f6sm2201740lfm.28.2021.06.22.05.31.43
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 22 Jun 2021 05:31:43 -0700 (PDT)
Message-ID: <60D1DAC1.9060200@gmail.com>
Date:   Tue, 22 Jun 2021 15:42:41 +0300
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
References: <60B24AC2.9050505@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
In-Reply-To: <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

21.06.2021 14:22, Arnd Bergmann:
[...]
> I looked some more through the git history and found at least one time
> that the per-chipset ELCR fixup came up for discussion[1], and this
> appears to have resulted in generalizing an ALI specific fixup into
> common code into common code[2], so we should already be doing
> exactly this in many cases. If Nikolai can boot the system with debugging
> enabled for arch/x86/pci/irq.c, we should be able to see exactly
> which code path is his in his case, and why it doesn't go through
> setting that register at the moment.

Here is my dmesg with debugging (hopefully) added to irq.c:

https://pastebin.com/tnC2rRDM

This is unmodified kernel, except for 8139too.c.
I've now realized maybe some usefull config option(s) related to pci irq 
handling are not enabled because due to size considerations it was 
initially configured as very minimalistic with just some really 
necessary features enabled (although ACPI, PCI_BIOS, PCI, EISA, ISA are 
enabled)

Just rechecked it again with the 8259A.pl script:

# 8259A.pl
irq 0: 00, edge
irq 1: 00, edge
irq 2: 00, edge
irq 3: 00, edge
irq 4: 00, edge
irq 5: 00, edge
irq 6: 00, edge
irq 7: 00, edge
irq 8: 00, edge
irq 9: 00, edge
irq 10: 00, edge
irq 11: 00, edge
irq 12: 00, edge
irq 13: 00, edge
irq 14: 00, edge
irq 15: 00, edge


Thank you,

Regards,
Nikolai

> I also found an slightly more recent discussion, from where it seems
> that the authoritative decision when it came up in the past was that edge
> triggered interrupts are supposed to work as long as they are not
> shared [3][4].
>
>         Arnd
>
> [1] https://lore.kernel.org/lkml/Pine.LNX.4.10.10011230901580.7992-100000@penguin.transmeta.com/
> [2] https://repo.or.cz/davej-history.git/commitdiff/e3576079d9e2#patch63
> [3] https://yarchive.net/comp/linux/edge_triggered_interrupts.html
> [4] https://lore.kernel.org/lkml/Pine.LNX.4.64.0604241156340.3701@g5.osdl.org/
>

