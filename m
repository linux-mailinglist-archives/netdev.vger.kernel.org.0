Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862CB394EAB
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 02:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhE3Aka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 20:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhE3Ak3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 20:40:29 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217DBC061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 17:38:51 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id e11so10050722ljn.13
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 17:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=G9M9wV+4Q875raBTYjRMZpTpZfdLKMhR3ewCC1peMjo=;
        b=KStkUOti9qSWavaaX0Yt1mRDsdJQ3G/3COERb+wb+HTM0HtRIXtTK9jVGySAQOylqw
         iexad0RGe8Y1XkS93vuAqMvbZT0uzjL7xvJwep4kBsGrtPhk7Q9LouRVmEAbLcN8q8gW
         r+ko5DvQEkd2OFOXhtJkNIIBr2IsFOjzudQ/dOcBkNSFBKZlTN3b2XHLz3sADhVk1TVx
         zfnW7pkk2u/oO+/iwg7oTFdrEjorzxLyNqCAf7C+xLJiiEleGtUvuPX+UZZOsx5FkHxC
         zZRqjVgoDEDzOaUoF0hABJwAwCZdOBvnEss+qw2lnr4iDCnvdd+S7XwZKeDtp46hcROh
         8Wpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=G9M9wV+4Q875raBTYjRMZpTpZfdLKMhR3ewCC1peMjo=;
        b=EMoZDK3ZCC6oHjiXurd8Fqj99UtXf31XltM20q51X1eLsXz1RLOc3DcHIxks6oxOkh
         mlDUK6K5votXefTfQWeGFGsJ9qCUwIQfJ12fxi/oLbx+Lpa6174I6zpJdLw8L3CM1uuy
         WZLxyQqYBWN1G1WQAqSOKpbRG/chjXdLXLI0aT5ZAFIUxokWc/pQ4H1ICmoHHYGo3R6L
         KTOdtf/pU+hQskjKji0czlhN+6NQveSZLdXyWt77UQp+rF5ld5WeHkCPHV+lKXfeuep4
         w+/2h5UthJu5+RQYDBJLiuTu+4GaC57f1ctk1u2tl0+I4o1K1J4SGWoyUOLSis8+1nEV
         N+KQ==
X-Gm-Message-State: AOAM532Fz2wUaKYwUcGRUnlcpD/CjEzzrp/cdZ/AngAHuPEhdfyXkrfl
        K2xW66LHIWe/n6dEGLA2/AUnNZTFh+p0bDcb
X-Google-Smtp-Source: ABdhPJwT9xbb/xVkC1b2G2UnIn/aK2sBSgp8dhfsvKNKrSOwfcDgrBPbeKozX5pOt4cH+fgRM2BStw==
X-Received: by 2002:a2e:9ec4:: with SMTP id h4mr11414098ljk.442.1622335129058;
        Sat, 29 May 2021 17:38:49 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id m9sm1018585ljh.6.2021.05.29.17.38.48
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 29 May 2021 17:38:48 -0700 (PDT)
Message-ID: <60B2E0FF.4030705@gmail.com>
Date:   Sun, 30 May 2021 03:49:03 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     netdev <netdev@vger.kernel.org>
CC:     tedheadster <tedheadster@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, whiteheadm@acm.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
In-Reply-To: <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

30.05.2021 0:44, tedheadster:
>> This driver hasn't seen functional changes for ages. Any previous kernel
>> version that works fine so that you could bisect? It will be hard to
>> find any developer who has test hw, especially as your issue seems to be
>> system-dependent.
>> Please provide a full dmesg log, maybe it provides a hint.
>
> I have a few active 80486 test systems (the 5.12.7 kernel works fine
> on 80486) that I might be able to help test with too.

Unfortunately I don't have any proven-to-work-well previous kernel for 
this specific hardware config, and dmesg does not show anything even 
slightly usefull.

However, I've just installed Debian Woody (kernel 2.2.20, gcc 2.95) and 
got something interesting. There are two interfaces shown in ifconfig:

eth0      Link encap:Ethernet  HWaddr 00:11:6B:32:85:74
           inet addr:192.168.0.3  Bcast:192.168.0.255  Mask:255.255.255.0
           ......
           Interrupt:9 Base address:0x6000

eth1      Link encap:Ethernet  HWaddr 00:11:6B:32:85:74
           inet addr:192.168.0.4  Bcast:192.168.0.255  Mask:255.255.255.0
           ......
           Interrupt:9 Base address:0x8000

whereas actually only one physical network card present. One can notice 
HWaddr and Irq is the same, although base addr is not.

lspci says:
00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139 
(rev 10)

Now as soon as ip configuration is done preperly, I can ifup any of them 
successfully.
And, eth0 shows some familiar misbehaviour: I can do ssh, but scp large 
file fails with subsequent communication breakdown. On the other hand, 
eth1 works fine, scp and iperf3 (both as a client and as a server) show 
quite regular operation. I'm puzzled a bit. But at least it looks like a 
possible starting point.


Thank you,

Regards,
Nikolai

>
> - Matthew
>

