Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6F39535B
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 01:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhE3XIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 19:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhE3XIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 19:08:51 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA715C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 16:07:05 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so13983940lfc.9
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 16:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=wKdqP3siAavLqN9eF024T/2AMtd3S4fvI+WJf6lroUs=;
        b=HNBfVoA2uH9+k7DzwxascQjMUTlgg/duSGdiSzGxXrYQnCu8IkEoWenClf8rCbIu1C
         1YqQCwDrlhCxIX9wf0ssTT3qU+E8DRf+rtLMHJe9gK5llmnmdTUGDThV463dvj3bY/zo
         Qj8iMs0O88KZXCcpPx6C0fJ2iWF8ybYT5q7j2jlPMkkbNznLfHWsiNGnY0Pl6RknzEc2
         6NnU5n+GizUEb1EdhiCkICqpFtT+VdYvuEMyTzQaoeSyN5MFvBn/uTqMktoExZHdLIlY
         zchwKtDPJQVw66tAJQK0EQGjyyAzY3oKyyhZm7Mf//Sq6QaC8tsLwGWyvU30uhukl3PI
         d7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=wKdqP3siAavLqN9eF024T/2AMtd3S4fvI+WJf6lroUs=;
        b=ksusrJ3TUeGC4a6ZnCpxrfXldzOsxBky70TAXMY7pCdhOfaw0FZK9uXVjjzMgxRTdd
         gYFhiubCvWW+51j0N5LtupzGFLGOSyJQTRT1vGAQYBfd4zkWzfYB0y+HrwcPyQ2IEUmN
         2eQRs8a06iSOqRQeQf1hnpOmLzjQepush5mWpphq7nCcTpfj7ZljESRDtDQu11M+kVTr
         LlRsrosoZsfN/2ZDh20Po3QqlKfzZEpLOmCMNdg8b1TmkBwG3/8OZCY3wHTrWdVWgjjY
         4so20fndI8guCePlL0o2N09Xrm3xin+Qeq6sngLnJLk9GZ1qudAnlwChQw1r5vrd0aw3
         HvUA==
X-Gm-Message-State: AOAM532dWo9/lhn8LYs+/O9pkogCxVhQPEI5XiOYwwIGY+NdqUuT9C0s
        0NwzQpUCozQrc/hLJd7CjqEp8393iJJIT3fU
X-Google-Smtp-Source: ABdhPJynF7sma/rtUsz3uK+P7xlt9Gn/h01AY3ulA4aG+l6bEMjRI/JrGQclWry7N0fBY6UAz4U2dw==
X-Received: by 2002:ac2:5e66:: with SMTP id a6mr13075419lfr.579.1622416024270;
        Sun, 30 May 2021 16:07:04 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id n15sm1146019lfq.274.2021.05.30.16.07.03
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 30 May 2021 16:07:03 -0700 (PDT)
Message-ID: <60B41D00.8050801@gmail.com>
Date:   Mon, 31 May 2021 02:17:20 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        tedheadster <tedheadster@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, whiteheadm@acm.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
In-Reply-To: <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

30.05.2021 23:54, Arnd Bergmann:
[...]
>> Unmodified kernel 2.6.2 works fine, unmodified kernel 2.6.3 shows
>> reproducable connectivity issues.
>>
>> The diff is not small, I'm not sure I can dig through.
>> Any hints/ideas greatly appreciated.
>
> This is apparently when NAPI was introduced into the driver.
>
> One thing I noticed here was the handling for shared IRQs changing in
> the process. Do you happen to have shared IRQs, and if so, can you

I think this IRQ is not shared:

# cat /proc/interrupts
            CPU0
   0:     322570          XT-PIC  timer
   1:          8          XT-PIC  i8042
   2:          0          XT-PIC  cascade
   9:        896          XT-PIC  eth0
  14:      18000          XT-PIC  ide0
NMI:          0
ERR:          0

# dmesg | grep -i irq
eth0: RealTek RTL8139 at 0xc4800000, 00:11:6b:32:85:74, IRQ 9
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1

However indeed, it seems a problem was introduced with a rework of 
interrupt handling (rtl8139_interrupt) in 2.6.3, because I have already 
pushed all other differences from 2.6.3 to 2.6.2 and it still keeps 
working fine.
My resulting minimized diff is still ~300 lines, it is too big and 
complicated to be usefull to post here as is.


Thank you,

Regards,
Nikolai


> change it so this card has an IRQ that is not shared with any other
> device?
>
>          Arnd
>

