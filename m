Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522AF3969AE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhEaWcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhEaWcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:32:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5182FC061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 15:30:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g17so12147770wrs.13
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 15:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QWQ3HJpojAIAwhP6+oIquQD3batjcwAGJA0iJGC6z84=;
        b=Dm8LA5GseM7AGL/KYuEi0YeV61jQVbDOeKBuIAu04Tog90dccgNzNC6sCrJqgAIwCy
         Ev/Y53DmmVpMQiTvLln3JEW0Pr0HmhNS4AMp0IiSjF7pvol/vOLT1SmLy2UugcJMMA9z
         ufZMq8mbsbXbZ96xtUIlmutlOzOtZsgG9rCZ3mahSFKeaqcCTrPgnB6RVDAkatNQKVHT
         jDwTcVSe4brc/K+mEnYBM2W4rM0/TM2/UC3Y/25wdnKwXSoGbYPkqtYySg3zA7y8JFok
         QYp/o3ER3ky0rsYdYRLJACvnengv7hrcvoigZzYEXJR5HwSZ8Cv3ROLR7d+ll8nuKUm2
         bHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QWQ3HJpojAIAwhP6+oIquQD3batjcwAGJA0iJGC6z84=;
        b=KR99742sZOr4JoI6tKZSO+yHpOsjD2+l0aHk3E1kY4rZE5FRJg+RPL52HqbHGFGFNN
         GkBUCFkqYTr3tEk3vlpjjfJ5k18yorA58P/txtrq6MaOsep3vUunXEP32ZS13b2YTtyu
         q8CiObjwTEdJs8cUZRSuiMgRTUkS1V6m1Y91PWlTa7o3VM+F2eDmG8JvBz/Lm12A/Ixq
         0atMZbhv5l7ZNhYpZO1ahP8ZTGuZXSz7DuUrx337yQyu8IOF0SgyBhgFZlbIZLeTIDQd
         r/RNhHGKCX4+bxv2re6hiLSQwjRw6rDdaB/uEbPcNCuEROaU7E0IpZFiY15uPegA4O+u
         +Wbw==
X-Gm-Message-State: AOAM530I3WE2rT4TrZyZzJE6D16N7bZVgGLo2DrH5zfi5cKSBwxU1+tP
        s4bTvhaMoP1cuAXAfca3u+g=
X-Google-Smtp-Source: ABdhPJwIT6v33dVYY7ocoOjBWnAPFdSjfOxmV19xhzF4ZTBNVumkTcZr9PAEiLfHpdQVXFiHcFNe6g==
X-Received: by 2002:adf:d4cc:: with SMTP id w12mr2417179wrk.216.1622500225819;
        Mon, 31 May 2021 15:30:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:fca7:2d8d:9b75:3e89? (p200300ea8f2f0c00fca72d8d9b753e89.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:fca7:2d8d:9b75:3e89])
        by smtp.googlemail.com with ESMTPSA id v7sm1258617wrf.82.2021.05.31.15.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 15:30:25 -0700 (PDT)
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
 <60B560A8.8000800@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
Date:   Tue, 1 Jun 2021 00:30:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <60B560A8.8000800@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.06.2021 00:18, Nikolai Zhubr wrote:
> Hi all,
> 
> Some more results follow. I'll report on all suggestions here in one go for brevity.
> 
>> One possible issue is that the "RTL_W16 (IntrStatus, TxErr)" can
>> leak out of the spinlock unless it is changed to RTL_W16_F(), but
>> I don't see how that would cause your problem. This is probably
>> not the issue here, but it can't hurt to change that. Similarly,
>> the "RTL_W16 (IntrStatus, ackstat)" would need the same _F
>> to ensure that a  normal TX-only interrupt gets acked before the
>> spinlock.
> 
> Just tested with "_F" added to all of them, did not help.
> 
>> Another observation I have is that the loop used to be around
>> "RTL_R16(IntrStatus); rtl8139_rx(); rtl8139_tx_interrupt()", so
>> removing the loop also means that the tx handler is only called
>> once when it used to be called for every loop iteration.
>> If this is what triggers the problem, you should be able to break
>> it the same way by moving the rtl8139_tx_interrupt() ahead of the
>> loop, and adjusting the RTL_W16 (IntrStatus, ackstat) accordingly
>> so you only Ack the TX before calling rtl8139_tx_interrupt().
> 
> I get the idea in general, but not sure how exactly you proposed to move rtl8139_tx_interrupt() and adjust the RTL_W16 (IntrStatus, ackstat).
> But meanwhile, I tried a dumb thing instead, and it worked!
> I've put back The Loop:
> ---------------------------
> +       int boguscnt = 20;
> 
>         spin_lock (&tp->lock);
> +       do {
>         status = RTL_R16 (IntrStatus);
> 
>         /* shared irq? */
> @@ -2181,6 +2183,8 @@
>                 if (status & TxErr)
>                         RTL_W16 (IntrStatus, TxErr);
>         }
> +       boguscnt--;
> +       } while (boguscnt > 0);
>   out:
> ---------------------------
> With this added, connection works fine again. Of course it is silly, but hopefully it gives a path for a real fix.
> 

What was discussed here 16 yrs ago should sound familiar to you.
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg92234.html
"It was an option in my BIOS PCI level/edge settings as I posted."
You could check whether you have same/similar option in your BIOS
and play with it.


>> What's your qdisc? Recently there was a bug related to the lockless
>> pfifo_fast qdisc
> 
> If I understand correctly this means packet scheduler type. In more recent kernels I typically have CONFIG_DEFAULT_NET_SCH="fq_codel", now in 2.6.3 no explicite scheduler is enabled, so it must be some fast fifo. But as the sympthoms were basically identical in e.g. 2.6.3 and 4.14, I suppose it is unlikely to be the cause.
> 
>> Issue could be related to rx and tx processing now potentially running in parallel.
>> I only have access to the current 8139too source code, hopefully the following
>> works on the old version:
>>
>> In the end of rtl8139_start_xmit() there's
>> if ((tp->cur_tx - NUM_TX_DESC) == tp->dirty_tx)
>>         netif_stop_queue (dev);
>>
>> Try changing this to
> 
> Ok, the changes compiled fine, but unfortunately made no noticable difference.
> 
> 
> Thank you,
> 
> Regards,
> Nikolai
> 
> 

