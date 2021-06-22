Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EABB3B0CEC
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhFVSd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVSd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:33:58 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBD2C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:31:41 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j4so132249lfc.8
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=oEJ10bPYm2tKsq7koP1acFEWdcXK8lq6pl+D4aLyMEE=;
        b=e5tbGVtEfDBmUr2oipZN4Sw66WwLSpggn/UUYwhgK/YIMCyT/SfLMd/l+HP4LOg/Bx
         k436OfSAfFYd90cJ22qZvl3ba5TW0bkQ9/VDJFuYnS+nVl1Vbr5eKimf4Ge5UbJSde6o
         kNOrdRo6Ts6Y5YkeXMcXNghwRVO1GfY8yXYpXPadRJwmQ2jiGF4m6WZD1CMFdGuGSOnY
         Kt2/QO0jEVg/eZvB3O+Fdyw4fhkJnh0ydD3ZQaWt+KwnYqsJ72/K+qS9PB9OfgiZ4AYp
         rVhT51oYq6kPO37QyXmvUFWMZAJDwYjG1lI2hTJpoEr196Bj9grg6Ik41xpXj8m0lrpS
         LLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=oEJ10bPYm2tKsq7koP1acFEWdcXK8lq6pl+D4aLyMEE=;
        b=Gvv25YajOoypzB46KO8sE68CoO+a6lePNNX4Mm4p1/MoLzyztXLMbo4h7suhoXbZYw
         D3B92j0K1CfrFICVzOlQDeIxbq8rh+iJor9CC+UhfvggigCjeAzUcyrWUy2AMBpjoLfo
         nmeUbw4IClrgJkWBqVWwff5I6fT/4Tpzqi6x0lJUiBRYeg28HPumNt/NF8MlGB3Kn7Bj
         P9YQ5lHR3VcDJotD6n5Vl78m22epoxDTIEkVuBONBJNQOEINnZNlFwvAU4DLnPEp4QEw
         hldofeaaLOT2GqEIW/JzAKvxvO5RB7tiepGtkpq6KhFaw5EtxMjRsPUlhcKvNgbzbmR1
         q3xA==
X-Gm-Message-State: AOAM530gf2MCoYOAfnPlogWQ5UktQMyBZG2LObT17uyOt4eGeAAQwyE1
        Uz9QtRlg88kBqR3O39DK8VQ=
X-Google-Smtp-Source: ABdhPJz74UX8pw9WxzIJQNIQgwfuxzqqZXgMcUojTGZOt86EXxvTHY1atnxa6EB5mPVawyr0MPtiYg==
X-Received: by 2002:ac2:4281:: with SMTP id m1mr3811877lfh.164.1624386700094;
        Tue, 22 Jun 2021 11:31:40 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id 26sm1884763lfz.136.2021.06.22.11.31.39
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 22 Jun 2021 11:31:39 -0700 (PDT)
Message-ID: <60D22F1D.1000205@gmail.com>
Date:   Tue, 22 Jun 2021 21:42:37 +0300
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
References: <60B24AC2.9050505@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk> <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com> <877dipgyrb.ffs@nanos.tec.linutronix.de> <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk> <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com> <60D1DAC1.9060200@gmail.com> <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
In-Reply-To: <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

22.06.2021 16:22, Arnd Bergmann:
[...]
> In this case, the function gives up with the  "can't route interrupt\n"
> output and does not call elcr_set_level_irq(newirq). Adding the call
> to elcr_set_level_irq() in that code path as well probably makes it
> set the irq to level mode:
>
> --- a/arch/x86/pci/irq.c
> +++ b/arch/x86/pci/irq.c
> @@ -984,6 +984,7 @@ static int pcibios_lookup_irq(struct pci_dev *dev,
> int assign)
>                          irq = newirq;
>                  } else {
>                          dev_dbg(&dev->dev, "can't route interrupt\n");
> +                       elcr_set_level_irq(newirq);
>                          return 0;
>                  }
>          }

Yes, it does indeed:

[    0.765886] 8139too 0000:00:0d.0: can't route interrupt
[    0.765886] PCI: setting IRQ 9 as level-triggered
[    0.781734] 8139too 0000:00:0d.0 eth0: RealTek RTL8139 at 0xc4804000, 
00:11:6b:32:85:74, IRQ 9

And also here:

# 8259A.pl
irq 0: 00, edge
irq 1: 00, edge
irq 2: 00, edge
irq 3: 00, edge
irq 4: 00, edge
irq 5: 00, edge
irq 6: 00, edge
irq 7: 00, edge
irq 8: 02, edge
irq 9: 02, level
irq 10: 02, edge
irq 11: 02, edge
irq 12: 02, edge
irq 13: 02, edge
irq 14: 02, edge
irq 15: 02, edge

Now connection also works fine with unmodified 8139too driver.
The percentage of low-level errors stays very small:

RX packets:13953 errors:1 dropped:2 overruns:1 frame:0
TX packets:37346 errors:0 dropped:0 overruns:13 carrier:0

This fix looks really nice. Maybe it is right thing to do.


Thank you,

Regards,
Nikolai

>
> No idea if doing this is a good idea though, in particular I have no clue
> about whether this is a common scenario or not.
>
>          Arnd
>

