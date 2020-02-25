Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB19A16EF5E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgBYTrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:47:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36545 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYTrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:47:40 -0500
Received: by mail-pf1-f195.google.com with SMTP id 185so100386pfv.3
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 11:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZHkrDNj1JB328mngXJs9m5plBJgIuEUbW676f8YF4hA=;
        b=aWS/iXZFtWmpXIf05/0BMcSR0szmufDEYXTGGY0G1pIm2iIZTnqWQxTfQQbWMu2rm0
         opR/paEeHnpoiPvHsrBmynIpj9ucYlC5/EBfHx2qJpAsLCJEo5wmJqEVpmrZgwTZrTus
         yhwNovRZEz209dzalX3RqEJfQYdhEfi9GCLjNEHLwGHrHhtWzzQSfWw9FV1tblmxf6yG
         kp3ha0X2j/Lbf6H1QM35YC0Wsujt3TZlBM1xzkUpGGepwF5qnJ0stcBCzd9d0TFACefO
         FbrC2ke+lUeC47rhgKMYbkGwhg68MENdX1O4lh6szKoIcqeHbmJDhRsA41FROzTvy0M4
         Mu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHkrDNj1JB328mngXJs9m5plBJgIuEUbW676f8YF4hA=;
        b=j0eyEEUkxhE0oGvMxafQA+rdBnTxPQ3QRxi6BcDasDpquZUNZQ7GblLmiLHsznCfQx
         mftf/OySKwvVuH2GQh7RTjoqJ9WcIMjAc/rPdlHxFBKJqHso14X0qT3NSW/QDC/7B2g+
         R2GtzcYZ4gcKrQr3wwcGCVIDrxLrmEV8D4tmmlnKapunBD0lqdlw614A6jA93JMPH0ua
         Hlq9UAb97tO681aZGdconR1He0VhlFHEa351TWNWNjecxQaSxGuegoDKR9rr5nMPvSbn
         EgI6r4r9M0zj7w6fOVRe7Hakwo6Y7SK/P0JlNkMu8JM2A/4gkgoK92YJG42dqG/Gv8rx
         7EjA==
X-Gm-Message-State: APjAAAXiINKUxr4sVmCrFjn+aKFoqNijI2iXl28bvrsyESiC1h53sUTO
        0MBdsLr+41ks/PgeCIbgGWo=
X-Google-Smtp-Source: APXvYqxfIZpXhsoFeIkxSUktYBYUfPuXRYzbr95bOZS5YXUOS8L17AS7/c5V0AAZ69J943bxpi93Fg==
X-Received: by 2002:aa7:8bcd:: with SMTP id s13mr342015pfd.234.1582660059828;
        Tue, 25 Feb 2020 11:47:39 -0800 (PST)
Received: from [10.67.50.18] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f8sm17945901pfn.2.2020.02.25.11.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 11:47:39 -0800 (PST)
Subject: Re: Fwd: Kernel crash due to conflict between legacy and current DSA
 mv88e6xxx drivers ?
To:     Sriram Chadalavada <sriram.chadalavada@mindleap.ca>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <CAOK2joHUDyZvGx6rkMS4D6-Rw0yznc2Q68JXdnUK1e=xN2X9Hw@mail.gmail.com>
 <CAOK2joG_XixQ5EKUcxOph_gECBqfZGuW8=7dwpdskHpgUO5qug@mail.gmail.com>
 <CAOK2joEyyQHmsKz1L6WV_5XmDmP5ZGhucLwFY_CT+U=AiySeNA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <e0e2cc71-70b5-d3be-32c4-27d8dace00cf@gmail.com>
Date:   Tue, 25 Feb 2020 11:47:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOK2joEyyQHmsKz1L6WV_5XmDmP5ZGhucLwFY_CT+U=AiySeNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 11:44 AM, Sriram Chadalavada wrote:
> The following error occurred using 4.19.101 kernel and NOT with our
> last stable 4.1.16 kernel on enabling CONFIG_NET_DSA_LEGACY.
> 
> [    1.505428] libphy: mdiobus_find: mii bus [igb_enet_mii_bus] found
> [    1.505515] sysfs: cannot create duplicate filename '/kernel/marvell/access'
> [    1.505529] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.19.101 #0
> [    1.505534] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [    1.505539] Backtrace:
> [    1.505549] Function entered at [<80013a28>] from [<80013d60>]
> [    1.505561]  r7:00000000 r6:60000013 r5:00000000 r4:806437b4
> [    1.505565] Function entered at [<80013d48>] from [<804e94b4>]
> [    1.505570] Function entered at [<804e941c>] from [<8013fffc>]
> [    1.505579]  r7:00000000 r6:80575d54 r5:e931a000 r4:eee2d000
> [    1.505585] Function entered at [<8013ff9c>] from [<8013fcbc>]
> [    1.505593]  r7:00000000 r6:e931a000 r5:ffffffef r4:8063860c
> [    1.505599] Function entered at [<8013fb50>] from [<8013fd68>]
> [    1.505606]  r6:e932f880 r5:8063860c r4:00000000
> [    1.505612] Function entered at [<8013fcf4>] from [<802f3190>]
> [    1.505620]  r7:80673f0c r6:00000000 r5:e91df078 r4:00000000
> [    1.505626] Function entered at [<802f30f4>] from [<804df104>]
> [    1.505638]  r10:e932b940 r9:8052c8e8 r8:00000000 r7:e91df078
> r6:00000000 r5:802f30f4
> [    1.505644]  r4:80638598
> [    1.505649] Function entered at [<804deb8c>] from [<80271310>]
> [    1.505661]  r10:00000000 r9:8064366c r8:00000000 r7:80672acc
> r6:8064366c r5:eef36410
> [    1.505665]  r4:00000000
> [    1.505670] Function entered at [<802712c0>] from [<8026f7b0>]
> [    1.505679]  r7:80672acc r6:00000000 r5:80672ac8 r4:eef36410
> [    1.505684] Function entered at [<8026f65c>] from [<8026fb90>]
> 
> On disabling the option CONFIG_NET_DSA_LEGACY,  the crash goes away
> but the ethernet interfaces are NOT enumerated.
> 
> https://www.spinics.net/lists/netdev/msg556413.html seems to suggest
> that legacy DSA is still being used for Marvell 88e6xxx drivers. If
> the kernel community intends to move away from that, we would want to
> adopt that approach. Please advise on what we might have to
> investigate/change that will also enable resolving this kernel crash.
> As I understand, one of the things I would need to change is that the
> relevant device tree needs to use the "current binding" as opposed to
> the "deprecated binding" which is what is being used now.

Correct, and also it looks like you have out of tree changes applied, as
nothing in the vanialla kernel will try to create a
/kernel/marvell/access hierarchy under /sys.
-- 
Florian
