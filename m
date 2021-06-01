Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760973972A3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhFALon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhFALom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:44:42 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F142C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 04:43:00 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o2-20020a05600c4fc2b029019a0a8f959dso1721113wmq.1
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 04:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n63Q6mr5fRqA3BCadKXwD2/n1K1EdQXoIo0D+XKXpys=;
        b=Pkb+z47Ga/gBav6436NMeWGiqty2MsQimsia28qpx+hkSlgpJIvk8xLWS+VUXiGwF3
         twfZeX8pHsVgrk84zmLvls2BJR1fYGjhnlQMgttGCiOMQfWSHeCSfO8NkIlG6ZXyakoG
         DgMAHT04qyAydgf/3LGsJlewpQ1gS3ci5Y+8+Fxt+0OravktC2MRwMipnlWzx+JqEqCI
         4ax/eE51ak6Oa+YtYHS8V0bspLa3VAPt6qRm7P7qkC9B9PXrKpoPIxAHAZoQl80hBLfw
         xZGnZVqzY5Wb3mK8aDf+HzRL1+Evd3l33KraGB89vGkHe9ec7DgDuL+1OHREzdrvcJ0c
         SGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n63Q6mr5fRqA3BCadKXwD2/n1K1EdQXoIo0D+XKXpys=;
        b=kTdOANfgTuBVZVo6zN1JD2OCmIL9LFDGXtA4F//NwOc9oS+BoqGWK0oIyIlV53itPa
         lSt6NqYw1wUzgAbkC3wFfX8zeztmJfJ8jpRgK6e0gJwemAdkgt2uaEMhZrROPMVBDcQ2
         fWJB8IOXbvjYjO4YTK5JlBlFkLIxDJ4AX04Mu7WwFNDqTiQk0FK8VCPZrtkWVklq5sib
         3Aq9I7Y30I/YXeL+2bj9XmJkWhAlZxMsCs+h1RA3qV8GX8slvW5rGyHDMbab6NpBtVO6
         ihDke4izdPVXupy824ehxzwOjq/J4nO4QYr4HUw0/6Sf45nbH0w7CU367U6GusVFbvg7
         M4Sw==
X-Gm-Message-State: AOAM530ZFLEAE2/e84j94r1Fhixjs0dktgKA9cDN+mGAbv2iEm16sqQo
        liSHnrOX0MQODmcmP6znzKM=
X-Google-Smtp-Source: ABdhPJxuj/B+KqWBCdKxpGXwCaS603CUQ7FnZH/XoYgnksBBUJJX3Iod7eXvqoJeJxvaQ6yRwR81ig==
X-Received: by 2002:a1c:2cc3:: with SMTP id s186mr4329878wms.150.1622547778903;
        Tue, 01 Jun 2021 04:42:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:7413:c444:b8f3:1878? (p200300ea8f2f0c007413c444b8f31878.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:7413:c444:b8f3:1878])
        by smtp.googlemail.com with ESMTPSA id a16sm2829492wrw.62.2021.06.01.04.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 04:42:58 -0700 (PDT)
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>, Arnd Bergmann <arnd@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <60B24AC2.9050505@gmail.com>
 <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com>
 <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com>
 <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
Date:   Tue, 1 Jun 2021 13:42:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <60B611C6.2000801@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.06.2021 12:53, Nikolai Zhubr wrote:
> Hi all,
> 
> 01.06.2021 10:20, Arnd Bergmann:
> [...]
>>> What was discussed here 16 yrs ago should sound familiar to you.
>>> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg92234.html
>>> "It was an option in my BIOS PCI level/edge settings as I posted."
>>> You could check whether you have same/similar option in your BIOS
>>> and play with it.
> 
> Yes indeed, this motherboard does have such an option, and it defaulted to "Edge", which apparently is not what PCI device normally expects.
> Changing it to "Level" made unmodified kernel 2.6.4 work fine.

Great, so you have a solution for your problem, as i would expect that this
setting also makes 8139too in newer kernels usable for you.

> And 8259A.pl comfirms this, too.
> 
> Before:
> # ./8259A.pl
> irq 0: 00, edge
> irq 1: 00, edge
> irq 2: 00, edge
> irq 3: 00, edge
> irq 4: 00, edge
> irq 5: 00, edge
> irq 6: 00, edge
> irq 7: 00, edge
> irq 8: 00, edge
> irq 9: 00, edge
> irq 10: 00, edge
> irq 11: 00, edge
> irq 12: 00, edge
> irq 13: 00, edge
> irq 14: 00, edge
> irq 15: 00, edge
> 
> After:
> # ./8259A.pl
> irq 0: 00, edge
> irq 1: 00, edge
> irq 2: 00, edge
> irq 3: 00, edge
> irq 4: 00, edge
> irq 5: 00, edge
> irq 6: 00, edge
> irq 7: 00, edge
> irq 8: 06, edge
> irq 9: 06, level
> irq 10: 06, level
> irq 11: 06, edge
> irq 12: 06, edge
> irq 13: 06, edge
> irq 14: 06, edge
> irq 15: 06, edge
> 
>> So it appears that the interrupt is lost if new TX events come in after the
>> status register is read, and that checking it again manages to make that
>> race harder to hit, but maybe not reliably.
> 
> It looks like incorrect IRQ triggering mode makes 2 or more IRQs merge into one, kind of. However, if I understand this 8139 operation logic correctly, the possible max number of signaled events in one go is limited by the number of tx/rx descriptors and can not grow beyond it while inside the interrupt handler in any case. If so, using the loop would seem not that bad, and the limit would be certainly not 20 but max(NUM_TX_DESC, CONFIG_8139_RXBUF_IDX) == 4.
> 
>> The best idea I have for a proper fix would be to move the TX processing
>> into the poll function as well, making sure that by the end of that function
>> the driver is either still in napi polling mode, or both RX and TX interrupts
>> are enabled and acked.
> 
> This one is too complicated for me to implement myself, so I'll have to wait if someone does this.
> 
This hardware is so old that it's not very likely someone spends effort on this.

> Alternatively, maybe it is possible to explicitely request level mode from 8259 at the driver startup?
> 
I have doubts that it is possible to overrule what the BIOS/ACPI communicate
to the kernel.

> 
> Thank you,
> 
> Regards,
> Nikolai
> 
>>
>>           Arnd
>>
> 

