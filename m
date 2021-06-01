Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBD3971BD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhFAKpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhFAKpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 06:45:24 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5BDC061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 03:43:41 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id i10so9003468lfj.2
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 03:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=T6mQSvWzxu7YzknZEJ5Te3X0ifxaxkG8iVYDDLXgUy0=;
        b=u8QmaS5wGFma9SnI+ecqbfb8IACKMqM26iciZ1j0E9xDYA6LbajINiAY5kYspkOAsU
         ji+dPJHjNjaEntbcHFH+xeA7cMfbl0A5lDnDV3oRGT74tPYM5+hk1ATSiUvZ8GdsRIec
         +3KzqQQjH8Hk6+R4EoJMcHCCR/V67kLzQzLezb5AkEjihb7guj/6Oh1+sOyPT0UL/Nu8
         yWTD7mj0sJj9JztoSu/5jpdB35uFluALmNTh4k23kJg41n2JEPVHUgcin7UoH6xcnZfE
         w3mm1NVHkoHmQzP0UQgUNDlgLKQjXIiZRg/eBmtqBVQoUB3AHegjVjmWpHys8QJZOZvU
         LU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=T6mQSvWzxu7YzknZEJ5Te3X0ifxaxkG8iVYDDLXgUy0=;
        b=l1JN6EAO80UzyD73JLlTzJsTWwjZNZaa8OSGoUi/1vMPt1mhmaAOEZmbUKEpCSZnqH
         pTV3wVQja0vbrPFvxEHNeC0NFDagg7iouAIAJNO00IFXYuFkOlVON2SnirWNokwcvkK1
         h+mCpkBojq0cSK4SAU6BvtvRCG5GgXGEKbKvNj45e/i3S712geXgJHH+WGPBfPsGaj+e
         7UsAdvFj8Kmxt1eAhVvrEiXJ8Leimop1qcVH7EdTj1TBcFGf/E3ZHbqPir6bSThRrf2s
         YV2CI8tr5GYP6y71VYN9s4Gj6IztinVzCkrdlbmdPnQ0mZGAAFMTgMKePDeaXKiY482C
         Vj0g==
X-Gm-Message-State: AOAM533qiOTPxoHnqzzdsCPGJ7NpxbnEp25hRqcLOTQaSAsfc/jHpBez
        gDv94w8Fk4/WCR3wx+DBVWY=
X-Google-Smtp-Source: ABdhPJy/FnBm2jmDKGDzpd7tH/P91NuQriOy45SlIq1AR2GmRV5QknlTX7kdW+hfbr2f3ONZlI86xA==
X-Received: by 2002:a05:6512:21c:: with SMTP id a28mr18348015lfo.298.1622544219672;
        Tue, 01 Jun 2021 03:43:39 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id g28sm288719lfv.142.2021.06.01.03.43.38
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 01 Jun 2021 03:43:39 -0700 (PDT)
Message-ID: <60B611C6.2000801@gmail.com>
Date:   Tue, 01 Jun 2021 13:53:58 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
In-Reply-To: <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

01.06.2021 10:20, Arnd Bergmann:
[...]
>> What was discussed here 16 yrs ago should sound familiar to you.
>> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg92234.html
>> "It was an option in my BIOS PCI level/edge settings as I posted."
>> You could check whether you have same/similar option in your BIOS
>> and play with it.

Yes indeed, this motherboard does have such an option, and it defaulted 
to "Edge", which apparently is not what PCI device normally expects.
Changing it to "Level" made unmodified kernel 2.6.4 work fine.
And 8259A.pl comfirms this, too.

Before:
# ./8259A.pl
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

After:
# ./8259A.pl
irq 0: 00, edge
irq 1: 00, edge
irq 2: 00, edge
irq 3: 00, edge
irq 4: 00, edge
irq 5: 00, edge
irq 6: 00, edge
irq 7: 00, edge
irq 8: 06, edge
irq 9: 06, level
irq 10: 06, level
irq 11: 06, edge
irq 12: 06, edge
irq 13: 06, edge
irq 14: 06, edge
irq 15: 06, edge

> So it appears that the interrupt is lost if new TX events come in after the
> status register is read, and that checking it again manages to make that
> race harder to hit, but maybe not reliably.

It looks like incorrect IRQ triggering mode makes 2 or more IRQs merge 
into one, kind of. However, if I understand this 8139 operation logic 
correctly, the possible max number of signaled events in one go is 
limited by the number of tx/rx descriptors and can not grow beyond it 
while inside the interrupt handler in any case. If so, using the loop 
would seem not that bad, and the limit would be certainly not 20 but 
max(NUM_TX_DESC, CONFIG_8139_RXBUF_IDX) == 4.

> The best idea I have for a proper fix would be to move the TX processing
> into the poll function as well, making sure that by the end of that function
> the driver is either still in napi polling mode, or both RX and TX interrupts
> are enabled and acked.

This one is too complicated for me to implement myself, so I'll have to 
wait if someone does this.

Alternatively, maybe it is possible to explicitely request level mode 
from 8259 at the driver startup?


Thank you,

Regards,
Nikolai

>
>           Arnd
>

