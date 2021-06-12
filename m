Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0AF3A4FED
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhFLRco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 13:32:44 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:40959 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhFLRco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 13:32:44 -0400
Received: by mail-lj1-f175.google.com with SMTP id x14so13998930ljp.7
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 10:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=F/Udi4tRS9vofhgrne9Z4C0ZRXUPrTwQY6OHF6FlN5w=;
        b=TEfv3ArTKAEm6hzw+egRqZ3uC97OYhYRnkd+GqOnqogSsiexlVMqVRAG+/ijrx8dst
         zH+0jY9PtN+AUU5Hwp6IQQPYKprGZcldKV/O0n1LcvDiyZVbYXkvkYjZR4tUd5RQPlsm
         rLC/YxQb5FGOh/4HhROaIVhfU/JOQliwAs44YVKdGQkTot1rEQsmoOH+ggMV2k8fBgOW
         RQTB8m4TDLZzx4VaRubfFppfSOto5T8S9lDG4yxUCoNlVbPUjM1AGTEAHEbM0uuNGsZ2
         7UgpJ67vcw5YxalXP4eOr7zOUQXl7pyfSnui4v8bJk8n9S8pXPBrHcwLFfd5R4S74Aox
         Oapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=F/Udi4tRS9vofhgrne9Z4C0ZRXUPrTwQY6OHF6FlN5w=;
        b=nSRVgq6Edz7NteIOPzaG+zH+Oqk3pVAQ0AzZO9MYtCeJ1oskXpH8xAb3S3P2S+pZEZ
         BtlLSgmvWZbw9wIQWKepR2prneW1j70ffijkFKpfBFWHlE7wr+e0gpgu4BGdrq4XNJPQ
         2tVyY8MiGESIO05xclKDX/eeHJBR+YjZzw9/XliQCw6AYvqd8kCvskPsAEIQofQdU1ux
         g0EycqmsnD2TB9abLkU56jgkkUsoAPFB95QeNfvrnhCShj+RcfPPjoGWa6+HdJafWuv3
         XS2fU4NnGnWHuVffqjXufF8mirN39mfl5JH5YGqexCnE7Qlz5s4ExnzxhLpbhOBoIMeZ
         CxWg==
X-Gm-Message-State: AOAM533AjM0IozorDvqPDRBCCf/bNAXtmlmwBBdSMuKr89cwBFDT2QDZ
        x1eU6lPmYTDauEFjRDv6QJ5jMwo8umuBXg==
X-Google-Smtp-Source: ABdhPJwJEGD/jy1Ggq12dMq46tKUR6J3RSLsGI6lbtooGRbb4m+u8/Crga/jD1bO2ZxWWH17k+aH+Q==
X-Received: by 2002:a05:651c:1254:: with SMTP id h20mr7511414ljh.430.1623518983448;
        Sat, 12 Jun 2021 10:29:43 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id u5sm502082lfs.196.2021.06.12.10.29.42
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 12 Jun 2021 10:29:42 -0700 (PDT)
Message-ID: <60C4F187.3050808@gmail.com>
Date:   Sat, 12 Jun 2021 20:40:23 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     netdev <netdev@vger.kernel.org>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com> <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com> <60BFD3D9.4000107@gmail.com> <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com> <60BFEA2D.2060003@gmail.com> <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

09.06.2021 10:09, Arnd Bergmann:
[...]
> If it's only a bit slower, that is not surprising, I'd expect it to
> use fewer CPU
> cycles though, as it avoids the expensive polling.
>
> There are a couple of things you could do to make it faster without reducing
> reliability, but I wouldn't recommend major surgery on this driver, I was just
> going for the simplest change that would make it work right with broken
> IRQ settings.
>
> You could play around a little with the order in which you process events:
> doing RX first would help free up buffer space in the card earlier, possibly
> alternating between TX and RX one buffer at a time, or processing both
> in a loop until the budget runs out would also help.

I've modified your patch so as to quickly test several approaches within 
a single file by just switching some conditional defines.
My diff against 4.14 is here:
https://pastebin.com/mgpLPciE

The tests were performed using a simple shell script:
https://pastebin.com/Vfr8JC3X

Each cell in the resulting table shows:
- tcp sender/receiver (Mbit/s) as reported by iperf3 (total)
- udp sender/receiver (Mbit/s) as reported by iperf3 (total)
- accumulated cpu utilization during tcp+upd test.

The first line in the table essentially corresponds to a standard 
unmodified kernel. The second line corresponds to your initially 
proposed approach.

All tests run with the same physical instance of 8139D card against the 
same server.

(The table best viewed in monospace font)
+-------------------+-------------+-----------+-----------+
| #Defines          ; i486dx2/66  ; Pentium3/ ; PentiumE/ |
|                   ; (Edge IRQ)  ;  1200     ; Dual 2600 |
+-------------------+-------------+-----------+-----------+
| TX_WORK_IN_IRQ 1  ;             ; tcp 86/86 ; tcp 94/94 |
| TX_WORK_IN_POLL 0 ;  (fails)    ; udp 96/96 ; udp 96/96 |
| LOOP_IN_IRQ 0     ;             ; cpu 59%   ; cpu 15%   |
| LOOP_IN_POLL 0    ;             ;           ;           |
+-------------------+-------------+-----------+-----------+
| TX_WORK_IN_IRQ 0  ; tcp 9.4/9.1 ; tcp 88/88 ; tcp 95/94 |
| TX_WORK_IN_POLL 1 ; udp 5.5/5.5 ; udp 96/96 ; udp 96/96 |
| LOOP_IN_IRQ 0     ; cpu 98%     ; cpu 55%   ; cpu 19%   |
| LOOP_IN_POLL 0    ;             ;           ;           |
+-------------------+-------------+-----------+-----------+
| TX_WORK_IN_IRQ 0  ; tcp 9.0/8.7 ; tcp 87/87 ; tcp 95/94 |
| TX_WORK_IN_POLL 1 ; udp 5.8/5.8 ; udp 96/96 ; udp 96/96 |
| LOOP_IN_IRQ 0     ; cpu 98%     ; cpu 58%   ; cpu 20%   |
| LOOP_IN_POLL 1    ;             ;           ;           |
+-------------------+-------------+-----------+-----------+
| TX_WORK_IN_IRQ 1  ; tcp 7.3/7.3 ; tcp 87/86 ; tcp 94/94 |
| TX_WORK_IN_POLL 0 ; udp 6.2/6.2 ; udp 96/96 ; udp 96/96 |
| LOOP_IN_IRQ 1     ; cpu 99%     ; cpu 57%   ; cpu 17%   |
| LOOP_IN_POLL 0    ;             ;           ;           |
+-------------------+-------------+-----------+-----------+
| TX_WORK_IN_IRQ 1  ; tcp 6.5/6.5 ; tcp 88/88 ; tcp 94/94 |
| TX_WORK_IN_POLL 1 ; udp 6.1/6.1 ; udp 96/96 ; udp 96/96 |
| LOOP_IN_IRQ 1     ; cpu 99%     ; cpu 55%   ; cpu 16%   |
| LOOP_IN_POLL 1    ;             ;           ;           |
+-------------------+-------------+-----------+-----------+
| TX_WORK_IN_IRQ 1  ; tcp 5.7/5.7 ; tcp 87/87 ; tcp 95/94 |
| TX_WORK_IN_POLL 1 ; udp 6.1/6.1 ; udp 96/96 ; udp 96/96 |
| LOOP_IN_IRQ 1     ; cpu 98%     ; cpu 56%   ; cpu 15%   |
| LOOP_IN_POLL 0    ;             ;           ;           |
+-------------------+-------------+-----------+-----------+

Hopefully this helps to choose the most benefical approach.


Thank you,

Regards,
Nikolai


>
>           Arnd
>

