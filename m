Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722F32A7A34
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgKEJNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbgKEJNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:13:53 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFA3C0613CF;
        Thu,  5 Nov 2020 01:13:53 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id s25so1555785ejy.6;
        Thu, 05 Nov 2020 01:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rZem6M7kfdgn2HJ62ywv5fOVwjJZX0jQzLoLxZvw77E=;
        b=XRsT+odDqa5mogK9zHucsu7GKd/EU7n5hxrFej556ON666sYKOTav1XKkQX414lDAz
         1fYB0ajgqP0SjouzlZaFi5z/XcGEiEx07oUPu2+UzJqciGDH0e7/s+l9fBe0Q5bHmmw+
         xDn/r5HKaS1ik0fKpa4LdZahJ/0NUJ7ueGGTATS0rLu/m0Lf//t4njblJBh96vJ3634i
         47PTZuqTz3IgT/OvRXXFHQM/G/qiHHcECjsKgseUGOF7mz2hU5WQjX2+JQfmaFg2WzTE
         +wssk3hzFQ5czZIlm41BpkusNzTVVTkE+NAEdTbuLNoHNJ41t9VU5llJwoXp1n6Cn53P
         gbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZem6M7kfdgn2HJ62ywv5fOVwjJZX0jQzLoLxZvw77E=;
        b=S+HX4oIQI8J0tVvHhInyn++3nJxKh1l5zZZpsRKWmutQuX1rWWuzVjrLjVdeu5dnWX
         pq2JApxGw2wZu9ErAuM+kTQrSFNlcvfqbPEnSS+JiZsqrCzcOWBjTLjBazc4y4tTgESr
         DAO0k/N+KA1SAzuoxhvh7Z5n2qtLhkvJP1tkDTFCMN2dkLyTxPBQlgPW2j7CsL9Rtlwl
         yLJ7QCtrgkQkwfH67jtTnKxQ5iwfEkNbV7hZ6mBRA4oRztw2baEiI6+M9scNzyctgYSl
         a+vcTrj98oY1raktjWfMvD6S0srYaWAydJhaOuOtMuHONAohwz1YOkqj1J9i1W82GG8E
         X7rQ==
X-Gm-Message-State: AOAM53273dqNZ37Ltx3dDrp0PefGnJRiasrd15BGEKNozCFwq5CbhnV1
        47HIm3VW4uM6uaBQ8sBehQNC1eFIgMJGxw==
X-Google-Smtp-Source: ABdhPJyEQixflPnVC0H356lcPyekQcJlLzeLprG9bspk73oJT2zh8+GYW2nDeV1e1fqy8TFQZ4ewlQ==
X-Received: by 2002:a17:906:1a0c:: with SMTP id i12mr1358095ejf.176.1604567632043;
        Thu, 05 Nov 2020 01:13:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id 64sm520076eda.63.2020.11.05.01.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 01:13:51 -0800 (PST)
Subject: Re: Very slow realtek 8169 ethernet performance, but only one
 interface, on ThinkPad T14.
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
References: <57f16fe7-2052-72cc-6628-bbb04f146ce0@gmx.com>
 <7ee6a86c-5aca-3931-73cc-2ab72d8dd8a7@gmail.com>
 <c4c063eb-d20b-8bc7-bbd7-b8df70c69a11@gmx.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9f8785d2-76b2-f0ad-7fa1-a8a38d7df3af@gmail.com>
Date:   Thu, 5 Nov 2020 10:13:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <c4c063eb-d20b-8bc7-bbd7-b8df70c69a11@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2020 08:42, Qu Wenruo wrote:
> 
> 
> On 2020/11/5 下午3:01, Heiner Kallweit wrote:
>> On 05.11.2020 03:48, Qu Wenruo wrote:
>>> Hi,
>>>
>>> Not sure if this is a regression or not, but just find out that after upgrading to v5.9 kernel, one of my ethernet port on my ThinkPad T14 (ryzen version) becomes very slow.
>>>
>>> Only *2~3* Mbps.
>>>
>>> The laptop has two ethernet interfaces, one needs a passive adapter, the other one is a standard RJ45.
>>>
>>> The offending one is the one which needs the adapter (eth0).
>>> While the RJ45 one is completely fine.
>>>
>>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0e)
>>> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
>>>
>>> The 02:00.0 one is the affected one.
>>>
>>> The related dmesgs are:
>>> [   38.110293] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
>>> [   38.126069] libphy: r8169: probed
>>> [   38.126250] r8169 0000:02:00.0 eth0: RTL8168ep/8111ep, 00:2b:67:b3:d9:20, XID 502, IRQ 105
>>> [   38.126252] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
>>> [   38.126294] r8169 0000:05:00.0: can't disable ASPM; OS doesn't have ASPM control
>>> [   38.126300] r8169 0000:05:00.0: enabling device (0000 -> 0003)
>>> [   38.139355] libphy: r8169: probed
>>> [   38.139523] r8169 0000:05:00.0 eth1: RTL8168h/8111h, 00:2b:67:b3:d9:1f, XID 541, IRQ 107
>>> [   38.139525] r8169 0000:05:00.0 eth1: jumbo features [frames: 9194 bytes, tx checksumming: ko]
>>> [   42.120935] Generic FE-GE Realtek PHY r8169-200:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
>>> [   42.247646] r8169 0000:02:00.0 eth0: Link is Down
>>> [   42.280799] Generic FE-GE Realtek PHY r8169-500:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-500:00, irq=IGNORE)
>>> [   42.477616] r8169 0000:05:00.0 eth1: Link is Down
>>> [   76.479569] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [   91.271894] r8169 0000:02:00.0 eth0: Link is Down
>>> [   99.873390] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [   99.878938] r8169 0000:02:00.0 eth0: Link is Down
>>> [  102.579290] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [  185.086002] r8169 0000:02:00.0 eth0: Link is Down
>>> [  392.884584] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [  392.891208] r8169 0000:02:00.0 eth0: Link is Down
>>> [  395.889047] r8169 0000:02:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [  406.670738] r8169 0000:02:00.0 eth0: Link is Down
>>>
>>> Really nothing strange, even it negotiates to 1Gbps.
>>>
>>> But during iperf3, it only goes up to miserable 3Mbps.
>>>
>>> Is this some known bug or something special related to the passive adapter?
>>>
>>> Since the adapter is passive, and hasn't experience anything wrong for a long time, I really doubt that.
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>> Thanks for the report. From which kernel version did you upgrade?
> 
> Tested back to v5.7, which still shows the miserable performance.
> 
> So I guess it could be a faulty adapter?
> 
>> Please test
>> with the prior kernel version and report behavior (link stability and speed).
>> Under 5.9, does ethtool -S eth0 report packet errors?
>>
> Nope, no tx/rx_errors, no missed/aborted/underrun.
> 
> Adding that the adapter is completely passive (no chip, just converting
> RJ45 pins to the I shaped pins), I'm not sure that the adapter itself
> can fail.
> 
Each additional mechanical connection may cause reflections or other signal
disturbance. You could try to restrict the speed to 100Mbps via ethtool,
and see what the effective speed is then. 100Mbps uses two wire pairs only.

> THanks,
> Qu
> 

