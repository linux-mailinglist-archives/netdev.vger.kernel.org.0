Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B03176592
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 22:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCBVIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 16:08:32 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33775 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCBVIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 16:08:32 -0500
Received: by mail-ed1-f66.google.com with SMTP id c62so1618374edf.0
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 13:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UNT/ktbPElMM+tNE7xLAeyoSzj4JGiQ9pRREUZ5uQOk=;
        b=Mrr8gMaZ/FstwW3RrpS1u24eisB7WCLPcYczmIfJThm29usNdQLHTSjZN447oRa4g3
         GBGbVrm10YBCzxDY44IBDGxVdW482/0b1Whbn5Zz8h7EERWjBp5qN6CCj5KodXAqM5Iq
         yFU4xf1KvxxP2FQbZSurDGhOzSoyTWeahi0eHdBZ6j18bYHNoYK3i45IcSW/KNSj6zJd
         Jow7i2fTbuPFWBypiBmBL+Xh+vi8OBBch4pbiSxndTPw6vzvUPvflV4kPrae439AQ9c3
         PQEolT4NIzvMYTut1aNPU3cc1nS9ZmVZBW1NdDM5g3xj1kBq0fcQGuoWBtWbA3xEG1ss
         G1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UNT/ktbPElMM+tNE7xLAeyoSzj4JGiQ9pRREUZ5uQOk=;
        b=ALX4WrzAR0GIVjOBRIt+5stBrrJq999f62VESO+gLurhgqKApfdIIi/f6pwwJ2bdHm
         k4UbtZ83wqByGZfeyse+xyCeOxMuLmk23vjJtXi9R5iTYSItqY7lztyegrQ1PGunxiVX
         Y3prUF4bLbR50TQU39R6f0lgJg4yR2dEjti7rY2GyT4vBZ9GxpwHfIYuvjqQegwUXRy3
         d6yHMTombDbAFtS5HAG6rUITJj2KUq0A/5F/4Lug76YvMeZ8UDlJaMzE1kIs/VL/BYLp
         hSgjvcKHCEf5IQsQMpnjKG9jiEKd8qQMAo1tmRPEZVRfiX7iHBA/lo7pWunUHyDJ6jw9
         Z6Ug==
X-Gm-Message-State: ANhLgQ2e7WqxWGczyqZkbypDW3+ZOAOgpnwzaPcjaF8aRQ55E1YtLY0X
        SOTSkNbvplpEHFeETAinIwg=
X-Google-Smtp-Source: ADFU+vu6XS4ZV2MEMajnyc9E8MfSl9kUmE0kdGNpuuoSQELRsx8srASw9asB1ieK9oAo2yfOS6/76Q==
X-Received: by 2002:a05:6402:b18:: with SMTP id bm24mr1114307edb.349.1583183309397;
        Mon, 02 Mar 2020 13:08:29 -0800 (PST)
Received: from [10.67.48.239] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l4sm559821eds.3.2020.03.02.13.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 13:08:28 -0800 (PST)
Subject: Re: [PATCH] net: phy: bcm63xx: fix OOPS due to missing driver name
To:     Jonas Gorski <jonas.gorski@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <20200302194657.14356-1-jonas.gorski@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <744c7757-1e11-b042-b144-430a2a6eb9d1@gmail.com>
Date:   Mon, 2 Mar 2020 13:08:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302194657.14356-1-jonas.gorski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 11:46 AM, Jonas Gorski wrote:
> 719655a14971 ("net: phy: Replace phy driver features u32 with link_mode
> bitmap") was a bit over-eager and also removed the second phy driver's
> name, resulting in a nasty OOPS on registration:
> 
> [    1.319854] CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 804dd50c, ra == 804dd4f0
> [    1.330859] Oops[#1]:
> [    1.333138] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.22 #0
> [    1.339217] $ 0   : 00000000 00000001 87ca7f00 805c1874
> [    1.344590] $ 4   : 00000000 00000047 00585000 8701f800
> [    1.349965] $ 8   : 8701f800 804f4a5c 00000003 64726976
> [    1.355341] $12   : 00000001 00000000 00000000 00000114
> [    1.360718] $16   : 87ca7f80 00000000 00000000 80639fe4
> [    1.366093] $20   : 00000002 00000000 806441d0 80b90000
> [    1.371470] $24   : 00000000 00000000
> [    1.376847] $28   : 87c1e000 87c1fda0 80b90000 804dd4f0
> [    1.382224] Hi    : d1c8f8da
> [    1.385180] Lo    : 5518a480
> [    1.388182] epc   : 804dd50c kset_find_obj+0x3c/0x114
> [    1.393345] ra    : 804dd4f0 kset_find_obj+0x20/0x114
> [    1.398530] Status: 10008703 KERNEL EXL IE
> [    1.402833] Cause : 00800008 (ExcCode 02)
> [    1.406952] BadVA : 00000000
> [    1.409913] PrId  : 0002a075 (Broadcom BMIPS4350)
> [    1.414745] Modules linked in:
> [    1.417895] Process swapper/0 (pid: 1, threadinfo=(ptrval), task=(ptrval), tls=00000000)
> [    1.426214] Stack : 87cec000 80630000 80639370 80640658 80640000 80049af4 80639fe4 8063a0d8
> [    1.434816]         8063a0d8 802ef078 00000002 00000000 806441d0 80b90000 8063a0d8 802ef114
> [    1.443417]         87cea0de 87c1fde0 00000000 804de488 87cea000 8063a0d8 8063a0d8 80334e48
> [    1.452018]         80640000 8063984c 80639bf4 00000000 8065de48 00000001 8063a0d8 80334ed0
> [    1.460620]         806441d0 80b90000 80b90000 802ef164 8065dd70 80620000 80b90000 8065de58
> [    1.469222]         ...
> [    1.471734] Call Trace:
> [    1.474255] [<804dd50c>] kset_find_obj+0x3c/0x114
> [    1.479141] [<802ef078>] driver_find+0x1c/0x44
> [    1.483665] [<802ef114>] driver_register+0x74/0x148
> [    1.488719] [<80334e48>] phy_driver_register+0x9c/0xd0
> [    1.493968] [<80334ed0>] phy_drivers_register+0x54/0xe8
> [    1.499345] [<8001061c>] do_one_initcall+0x7c/0x1f4
> [    1.504374] [<80644ed8>] kernel_init_freeable+0x1d4/0x2b4
> [    1.509940] [<804f4e24>] kernel_init+0x10/0xf8
> [    1.514502] [<80018e68>] ret_from_kernel_thread+0x14/0x1c
> [    1.520040] Code: 1060000c  02202025  90650000 <90810000> 24630001  14250004  24840001  14a0fffb  90650000
> [    1.530061]
> [    1.531698] ---[ end trace d52f1717cd29bdc8 ]---
> 
> Fix it by readding the name.
> 
> Fixes: 719655a14971 ("net: phy: Replace phy driver features u32 with link_mode bitmap")
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
