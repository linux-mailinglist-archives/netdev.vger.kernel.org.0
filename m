Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A6839698C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhEaWJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEaWJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:09:41 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57817C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 15:08:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i9so18603639lfe.13
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 15:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=JSDg/DWbVqp5V+nAv4bOZ4UcuYEDQKCua4dnlQY0tRo=;
        b=OSV5OqRMmfFU6Ac+d/dM7TmoKKGFVjq7nXJfg82DKzufH0hdQrXmEEhs/8em/SrWjm
         vcq4kI0BdfQzVhoMFMwzEL9OFZGiMYHguszTGEhU0s7Qj7i2FtiPO7xNrAN4PSMYFGMG
         /JO/VTyvwa1O3zsNLz5zC4g0Wzs4UcHdldmy7powxvR5wtjR8RTmYMcY5eLhiViSc+K5
         12Q+06Mv+GBHH4q5FN2c5WWGO1KSApI46hn6AaLLo+m1oZxkys9lRhIbBmkwzfm2DEiM
         QDabCPHKfG6j1d+MGyn70jKoEP3807eYCFKg7THuHkqRlEnmjUQYjgds7xz1omM6wnY9
         njVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=JSDg/DWbVqp5V+nAv4bOZ4UcuYEDQKCua4dnlQY0tRo=;
        b=uJHpEJwFysQBvlklxbg7HKhQ9o1oK/cfFWn+fcXQIp3EOmnRWclAkkMGYJ3jFHAIZ2
         bxWo96maDF5JSwD7+vhsVkjxNsQFls78MHz+/O5S4bGlw6FUn0k0IJDHF92URDm4ei2j
         ENXp50mdDtX2avMiob9Jhz+qTucEss1NXsexMTXSRRlL1AnsYe3fisGtJTb/dIqlf1IS
         NvOkHCPqM8d4EEafnp0MlrDfJ2VySCKDddoxO+FXjb2dpEXOAGJOtD6/HZIguojXSUqs
         ji7R5lD/nj6H5AbVF3eigstoL+aVbRfavyVbgwFlC2AoFRYpY3dJdfy+QZNpA7ABMAqz
         Q4RQ==
X-Gm-Message-State: AOAM5320/Du2fZeuZW3Y4D+8Ey42NKLlKfRxQW0dV9DbniAa3z9giN4p
        Xuv+YIV6+W5YawS2KhVFp9AaxvceVr7olA==
X-Google-Smtp-Source: ABdhPJz+YG34SeqYRl9vI69uR+wYfUg7JtbbAISBMw4hoxGC3225O9OOnupaBiYboe6k41k/EK0Rug==
X-Received: by 2002:a05:6512:acd:: with SMTP id n13mr16295116lfu.485.1622498878709;
        Mon, 31 May 2021 15:07:58 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id b14sm1013321ljf.4.2021.05.31.15.07.57
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 31 May 2021 15:07:58 -0700 (PDT)
Message-ID: <60B560A8.8000800@gmail.com>
Date:   Tue, 01 Jun 2021 01:18:16 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
In-Reply-To: <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Some more results follow. I'll report on all suggestions here in one go 
for brevity.

> One possible issue is that the "RTL_W16 (IntrStatus, TxErr)" can
> leak out of the spinlock unless it is changed to RTL_W16_F(), but
> I don't see how that would cause your problem. This is probably
> not the issue here, but it can't hurt to change that. Similarly,
> the "RTL_W16 (IntrStatus, ackstat)" would need the same _F
> to ensure that a  normal TX-only interrupt gets acked before the
> spinlock.

Just tested with "_F" added to all of them, did not help.

> Another observation I have is that the loop used to be around
> "RTL_R16(IntrStatus); rtl8139_rx(); rtl8139_tx_interrupt()", so
> removing the loop also means that the tx handler is only called
> once when it used to be called for every loop iteration.
> If this is what triggers the problem, you should be able to break
> it the same way by moving the rtl8139_tx_interrupt() ahead of the
> loop, and adjusting the RTL_W16 (IntrStatus, ackstat) accordingly
> so you only Ack the TX before calling rtl8139_tx_interrupt().

I get the idea in general, but not sure how exactly you proposed to move 
rtl8139_tx_interrupt() and adjust the RTL_W16 (IntrStatus, ackstat).
But meanwhile, I tried a dumb thing instead, and it worked!
I've put back The Loop:
---------------------------
+       int boguscnt = 20;

         spin_lock (&tp->lock);
+       do {
         status = RTL_R16 (IntrStatus);

         /* shared irq? */
@@ -2181,6 +2183,8 @@
                 if (status & TxErr)
                         RTL_W16 (IntrStatus, TxErr);
         }
+       boguscnt--;
+       } while (boguscnt > 0);
   out:
---------------------------
With this added, connection works fine again. Of course it is silly, but 
hopefully it gives a path for a real fix.

> What's your qdisc? Recently there was a bug related to the lockless
> pfifo_fast qdisc

If I understand correctly this means packet scheduler type. In more 
recent kernels I typically have CONFIG_DEFAULT_NET_SCH="fq_codel", now 
in 2.6.3 no explicite scheduler is enabled, so it must be some fast 
fifo. But as the sympthoms were basically identical in e.g. 2.6.3 and 
4.14, I suppose it is unlikely to be the cause.

> Issue could be related to rx and tx processing now potentially running in parallel.
> I only have access to the current 8139too source code, hopefully the following
> works on the old version:
>
> In the end of rtl8139_start_xmit() there's
> if ((tp->cur_tx - NUM_TX_DESC) == tp->dirty_tx)
> 		netif_stop_queue (dev);
>
> Try changing this to

Ok, the changes compiled fine, but unfortunately made no noticable 
difference.


Thank you,

Regards,
Nikolai


