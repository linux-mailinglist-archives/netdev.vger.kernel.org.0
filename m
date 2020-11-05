Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A292A77A9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgKEHB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgKEHB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 02:01:58 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DEBC0613CF;
        Wed,  4 Nov 2020 23:01:57 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w1so382718edv.11;
        Wed, 04 Nov 2020 23:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j0cItyzXnN05PEymUiVPpxa/gRPBRWPOMzuhzGbrfhs=;
        b=mGMRHmoakWbpA8XNBnhpRjgaRsK+Cypk5WrDGfifG4aBbuHcSaKJKDSLIUkT4VlkOO
         f2KaBrW097DjB9qDZ0qD7Vob1ElCRyHyUBdsrqt9lTEBvMw6FHGKB4jUkFNiTSsVRS21
         6PmJ8lbrjlnAQpiwNiU/JW9Gh7g2NuU4pq+TD/uSzW8Si17RuiqdZuqBEIOYpm+nNLhj
         xuFoWGiMWRL0Xxvui2Q0t0VoMAGJHuiBCkzlj6w76tp05kEhIVH5lvKgjAWMif++Hqhw
         0Q7PDgZHqW39Etu6DY8UPniSHdRnE5dMA5tBvvSBHBtFFayaV7tEKqW4VhdHi8i/iokX
         WJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j0cItyzXnN05PEymUiVPpxa/gRPBRWPOMzuhzGbrfhs=;
        b=brn3utoRVgzmYh7Jpfn60Dm8QjFHQwHYN0XWzlASPqGvFLrD6dMxNb5QvIdBXLS4wR
         l3OnEIfYBgrHS3hDUmAIaQJpGNjuci9kM9zpTxFqWuOrnQYWbzqOHgK7yKCGZIvoF8zW
         gmqlKMt0ZF5BYzXxyC6FZhbcuju4F4S6awb9GuwbKoj6Mb/1G7iRaNiMxAScfA7JBcYI
         RGhYlcjYfnZzsQ6I7F3UP9SU3QG7Gozk7Eo5q0h2BiBsr39XKtg0xDHUyTEnXTRuyZLU
         0SF2E38IHUYhSc8Nfyt0PTVm6hE+mofkG9GcjjjAWOF51/E0NRkSJzeItHMFw9q4ycxE
         ZYIQ==
X-Gm-Message-State: AOAM530venIQoxH/YO5yzhQIR8UIkSN1+jbU2YbbT/a+ywWEJ06HKHbY
        FPw2/QMU7daaTR4vgwTAmrxEu90gu525Bg==
X-Google-Smtp-Source: ABdhPJyQUE3RG6WaUUqXf8jbzaWEha3q0KZsE7n8WJ3SFoeXOLGOk6hNri8lt/3zVMmXBsu1w3Sd9w==
X-Received: by 2002:a50:e789:: with SMTP id b9mr1153052edn.272.1604559715778;
        Wed, 04 Nov 2020 23:01:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id a17sm330462eda.45.2020.11.04.23.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 23:01:55 -0800 (PST)
Subject: Re: Very slow realtek 8169 ethernet performance, but only one
 interface, on ThinkPad T14.
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
References: <57f16fe7-2052-72cc-6628-bbb04f146ce0@gmx.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7ee6a86c-5aca-3931-73cc-2ab72d8dd8a7@gmail.com>
Date:   Thu, 5 Nov 2020 08:01:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <57f16fe7-2052-72cc-6628-bbb04f146ce0@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2020 03:48, Qu Wenruo wrote:
> Hi,
> 
> Not sure if this is a regression or not, but just find out that after upgrading to v5.9 kernel, one of my ethernet port on my ThinkPad T14 (ryzen version) becomes very slow.
> 
> Only *2~3* Mbps.
> 
> The laptop has two ethernet interfaces, one needs a passive adapter, the other one is a standard RJ45.
> 
> The offending one is the one which needs the adapter (eth0).
> While the RJ45 one is completely fine.
> 
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0e)
> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
> 
> The 02:00.0 one is the affected one.
> 
> The related dmesgs are:
> [   38.110293] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
> [   38.126069] libphy: r8169: probed
> [   38.126250] r8169 0000:02:00.0 eth0: RTL8168ep/8111ep, 00:2b:67:b3:d9:20, XID 502, IRQ 105
> [   38.126252] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
> [   38.126294] r8169 0000:05:00.0: can't disable ASPM; OS doesn't have ASPM control
> [   38.126300] r8169 0000:05:00.0: enabling device (0000 -> 0003)
> [   38.139355] libphy: r8169: probed
> [   38.139523] r8169 0000:05:00.0 eth1: RTL8168h/8111h, 00:2b:67:b3:d9:1f, XID 541, IRQ 107
> [   38.139525] r8169 0000:05:00.0 eth1: jumbo features [frames: 9194 bytes, tx checksumming: ko]
> [   42.120935] Generic FE-GE Realtek PHY r8169-200:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
> [   42.247646] r8169 0000:02:00.0 eth0: Link is Down
> [   42.280799] Generic FE-GE Realtek PHY r8169-500:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-500:00, irq=IGNORE)
> [   42.477616] r8169 0000:05:00.0 eth1: Link is Down
> [   76.479569] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   91.271894] r8169 0000:02:00.0 eth0: Link is Down
> [   99.873390] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   99.878938] r8169 0000:02:00.0 eth0: Link is Down
> [  102.579290] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [  185.086002] r8169 0000:02:00.0 eth0: Link is Down
> [  392.884584] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [  392.891208] r8169 0000:02:00.0 eth0: Link is Down
> [  395.889047] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [  406.670738] r8169 0000:02:00.0 eth0: Link is Down
> 
> Really nothing strange, even it negotiates to 1Gbps.
> 
> But during iperf3, it only goes up to miserable 3Mbps.
> 
> Is this some known bug or something special related to the passive adapter?
> 
> Since the adapter is passive, and hasn't experience anything wrong for a long time, I really doubt that.
> 
> Thanks,
> Qu
> 
> 
Thanks for the report. From which kernel version did you upgrade? Please test
with the prior kernel version and report behavior (link stability and speed).
Under 5.9, does ethtool -S eth0 report packet errors?
