Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE1B39E9D6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhFGXAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:00:32 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:39895 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFGXAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:00:31 -0400
Received: by mail-lf1-f41.google.com with SMTP id p17so28187698lfc.6
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 15:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=wbH9kPI5V48N69VkD/7UC64Zgyul29np48mGHrxJcuw=;
        b=DFYWl/XJmiqMUMWtJ4bJ1t+91tAU0kRtoDV9gHim5cdltjH4C4nAiaOxPMNNLjsmRE
         18PM8bzGAPacv74GuCGhyk409hF0BjExn3U2dmTtL3HYBpk7A36z0Ect+sLB3s6Pt7Et
         daWKzCKY0WTRqUy7PVb6k4rNjsF/AHuDktBTko27XCWrdlvVYwdeDkDDkYsMaGKY4Z9o
         Jy7+gj8KMsrwtt06IwMQuwgWqCMy4Z43Ltp6+vZEWfUwuVGwtFWWoWFP+NFCoso0Cvoy
         opqQmhnR5VSM3NihQzxAejTZWFgInUDxQ7SawwL0TTNabgJkZe0QuPBOdTffHCZIm0zn
         e0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=wbH9kPI5V48N69VkD/7UC64Zgyul29np48mGHrxJcuw=;
        b=YjHHO4rjFidMl+3EkIu9CIbCGzisO+I1fBDT2Rc0Lcb+aXm+WL86sQZ9cqAnjRtKOp
         weC00F6VtfsUMoG8ftwudVXpec6xnkey0vdAzioiWovGCl0fQPNCr/fNIx+fGV4VQ5rp
         adsHE/QUonCqnEj6Mw+vp975R+Rdv8Q7mK3e7DdPqjxLGHreEHnt+sNXaWp7wB+3u15K
         HjpESk3dwwd20MCAn+gCl0k5V7azdR7spab0gjlaqy5uUAYMXshuSUiCci8SCEdz2RWJ
         reCp5+ZKQDnAD0QDXZX2v729TeDY0+a7HF2MprLK0d/HbycH0GUz+Kvfz0CQJMHtdzWT
         XBVQ==
X-Gm-Message-State: AOAM533hRSy95GHdmiYUiynyiWwj3HaKUuyUlQyiJSxrEfGQtdjZYK+U
        YrgQAaUEvABmOHV6uG8n+8kWr/1NGOsl3w==
X-Google-Smtp-Source: ABdhPJyMYFmaQWecsoNVPWMgxzi+ZmLFc9R8lx3zRB0tE5UkX5wKH2kEQA5FZwXGpvPmONb2PEqFWQ==
X-Received: by 2002:a19:7114:: with SMTP id m20mr13014097lfc.99.1623106647901;
        Mon, 07 Jun 2021 15:57:27 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id n15sm1654683lft.169.2021.06.07.15.57.27
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 07 Jun 2021 15:57:27 -0700 (PDT)
Message-ID: <60BEA6CF.9080500@gmail.com>
Date:   Tue, 08 Jun 2021 02:07:59 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
In-Reply-To: <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

02.06.2021 12:12, Arnd Bergmann:
[...]
> I think the easiest workaround to address this reliably would be to move all
> the irq processing into the poll function. This way the interrupt is completely
> masked in the device until the poll handler finishes, and unmasking it
> while there
> are pending events would reliably trigger a new irq regardless of level or edge
> mode. Something like the untested change at https://pastebin.com/MhBJDt6Z .
> I don't know of other drivers that do it like this though, so I'm not
> sure if this causes a different set of problems.

I started applying your patch (trying to morph it a little bit so as to 
shove in a minimally invasive manner into 4.14) and then noticed that it 
probably won't work as intended. If I'm not mistaken this rx poll thing 
is only active within kind of "rx bursts", so it is not guaranteed to be 
continually running all the time when there is no or little rx input. 
I'd suppose some new additional work/thread would have to be introduced 
in order for such approach to be reliably implemented.

Meanwhile, beside the lost tx irq issue, I've apparently identified rx 
overrun issue. According to tinymembench, the raw RAM performance of 
this system is roughly around 15-30 Mbytes/s at best, so it is close to 
100Mbit wire speed. Tracing NFS over UDP operation (client side) I've 
found that of 2 full-sized incoming NFS/UDP packets the second one will 
always be lost, approved by rapid increase of iface err counter. More 
specifically, I've found that a couple of packets sized 1500+700 can 
still be successfully accepted, but no way 1500+1500. Apparently 8139 
has very little ram builtin so it needs that packets can go into main 
ram fast enough. It appeared though that just adding rsize=1024 allows 
NFS work quite well, with only ocasional small pauses. Also, apparenly 
TCP/IP somehow recovers/autotunes iteself automatically, so it just 
works fine. I suppose this overrun problem can not be fixed in a general 
form (other than forcing a downgrade of link speed to 10 Mbit), as AFAIK 
there are no provisions in ethernet to request e.g. extra delays between 
packets. What might be usefull though is dropping some line to dmesg 
suggesting to somehow limit the incoming flow. Such hint in dmesg would 
have saved me quite some time.

Anyway, for now I got it working quite well (with a re-added busy loop 
and rsize=1024). I'm going to look at the elcr_set_level_irq approach 
later, but it looks quite complicated. If there is something else I can 
test while at it, please let me know.


Thank you,

Regards,
Nikolai


>
>         Arnd
>

