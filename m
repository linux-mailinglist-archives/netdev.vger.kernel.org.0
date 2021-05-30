Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704C139506C
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhE3K1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 06:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3K1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 06:27:36 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA84C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 03:25:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f30so12363568lfj.1
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 03:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=YS2wZ1WtNT06sAe7VwzyZRfz47f6YxKQfZ3mKGpVoAc=;
        b=sQBjaQneW6uUVHwnFaAAN3e16WXE2Gu/NtM6q88Zqtay5MkNhYMM4UTcOPTAkI6pld
         Wt3P7BfUAC+5hBu1zBcvB26Fy+xuWlCxeTal+I1y34BwLGyoTJ0/4KewAt+pOKiIPMeh
         4PHjOh4sx8hk/IgFcql/3ryJJgkE1XOTRFA766tV0Yp/9emxWnvIULkagJZdrherO26U
         IcFbOIjboS0B07rWdEqN7siMz1C4YYhjBREQd5wUV8AcK7jchgK1N0NCkbHpMuL6MSsC
         tSpegHztr7JRltUiiINq9n7YqFM8tm8bJs72joiVKf9471lSnNjyG3dVdFbbsPxn4aBd
         B6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=YS2wZ1WtNT06sAe7VwzyZRfz47f6YxKQfZ3mKGpVoAc=;
        b=Gka9YtdXT50us8TcwffBa/uxIOkOZKI7/WL6XL554mrp3a2yX1YD6Wlz53fx+lrmYz
         /To+0F7w9rad+fA1phcqYR0zYKnC0i/rMViSNrKF4F4Ih36YgNfU+xAicYnHNWaf3qaW
         bOWEpcmhi1Aj1GtCntoGomW5AFh7D6WkQlgc/pd7jwVK0rIdACTYKkNM/UDy7BZC0nej
         Oq/v13ACNubhGycbvfT1VbEr2DWkyiXQ9N5hFlLg0/hN6ZH2n0Klcnsqu5LJzEgdB0iX
         8xFwbXDqW5ehi6tF4PsIQG/aUB+2btj8QzjMqSQmBto4lMedqmVgd0kjCpXJC92AtpjO
         sOOg==
X-Gm-Message-State: AOAM530g9pdMjgTV61j/dxveGxXRst9DXs6WuOyZOJ3GIksEQY/G5lKK
        intU/JKFfRPI3ptpA/GKodQYwtelWtRtnq24
X-Google-Smtp-Source: ABdhPJxG4/riH++7xzV757EumRfDStS1geAH6V4cUjqORH9SgeDYLosaLz2MgAwjOo9QJYKB3OvWaA==
X-Received: by 2002:a19:5209:: with SMTP id m9mr739065lfb.24.1622370355500;
        Sun, 30 May 2021 03:25:55 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id u11sm977803lff.33.2021.05.30.03.25.54
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 30 May 2021 03:25:54 -0700 (PDT)
Message-ID: <60B36A9A.4010806@gmail.com>
Date:   Sun, 30 May 2021 13:36:10 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     netdev <netdev@vger.kernel.org>
CC:     tedheadster <tedheadster@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, whiteheadm@acm.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com>
In-Reply-To: <60B2E0FF.4030705@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

30.05.2021 3:49, Nikolai Zhubr:
[...]
> eth0 Link encap:Ethernet HWaddr 00:11:6B:32:85:74
> inet addr:192.168.0.3 Bcast:192.168.0.255 Mask:255.255.255.0
> ......
> Interrupt:9 Base address:0x6000
>
> eth1 Link encap:Ethernet HWaddr 00:11:6B:32:85:74
> inet addr:192.168.0.4 Bcast:192.168.0.255 Mask:255.255.255.0
> ......
> Interrupt:9 Base address:0x8000
>
> whereas actually only one physical network card present. One can notice
> HWaddr and Irq is the same, although base addr is not.
>
> lspci says:
> 00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139
> (rev 10)

Ok, sorted out this.
eth0 == rtl8139.c:v1.07 5/6/99
eth1 == 8139too Fast Ethernet driver 0.9.18-pre4

So, 8139too 0.9.18-pre4 as of kernel 2.2.20 is the one that apparently 
works correctly here. I feel the bisect is going to be massive.


Thank you,

Regards,
Nikolai

> Now as soon as ip configuration is done preperly, I can ifup any of them
> successfully.
> And, eth0 shows some familiar misbehaviour: I can do ssh, but scp large
> file fails with subsequent communication breakdown. On the other hand,
> eth1 works fine, scp and iperf3 (both as a client and as a server) show
> quite regular operation. I'm puzzled a bit. But at least it looks like a
> possible starting point.
>
>
> Thank you,
>
> Regards,
> Nikolai
>
>>
>> - Matthew
>>
>

