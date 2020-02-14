Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C38415F78E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgBNUPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:15:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41486 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgBNUPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:15:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so12373296wrw.8
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 12:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g/Z1gd6b0PaHDB7tLv0R+0PuV33gE28iYDHqCqFdyts=;
        b=H3PNKYixp3xB1uziRtphVr/kZwj/j1R3SMQB1VVNR6HYFzoqlqZhZH5cqAsGweRvmF
         xNH88R280ja3VT34WFRJTrVRRuCU5jRJnYu/3eP3VOHY1YiXox4baVSGCS60vn5hjfrb
         cIoEJAf1w4Fzx7+It+Mvbht8TNPpfcGRE61xLOPVMd+aEpYsnsdH5+BUb7FqvFeJeA6o
         1iCkaLKqW9Yq4/CPznsRzG+RhNokrlZfEDTCngQNYHi8f05iZO7fh9dJpnSy4IKyB6Rm
         n2F8APKcWdyjAAJRzaNN4dhQagYWOfAQ40+3vWpkVICwuzk/V6+uBvS72cVPJUEOod5L
         Ix5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g/Z1gd6b0PaHDB7tLv0R+0PuV33gE28iYDHqCqFdyts=;
        b=ukz3uwFRb6lMlmuSaYwhxFElDAQbTB3KxfTYoM+g2YPwJmmvboIsZogXZRs4SpMymA
         0g1FC36K58tbAqYRTov2zY3IZtiXFGey8I7PkA86NvvIZROnBs0ZIo6ER134c26uUsg6
         EzC4SkdV0idfBKSSh9lQ6deSUuOxTF126sItiP04XTMYWoWcesynQojqq6nc9GkZ1z1A
         /8W+XAji1927Yy3IaOkMq8hVHE2kOXbXwOY72FadmCteJZOAsct+Efc5h93cLw5Z0JAi
         B4MzfGMKub5Rj2a3y9q2Vba8TfwCS9nbDB9OIQ0vomNi8exqdCkon0bka23Z/xTfm1br
         b7vw==
X-Gm-Message-State: APjAAAXd22J0Hq3NGMJVx+2VwwFou/cOZaNprgCv/J0lzYFf2AJJtmw3
        hsVMGBUxJILBJM2NTj4DKyriUFxV
X-Google-Smtp-Source: APXvYqw1qvhxngSdzQQkWiuHflSUMLFSrARG2xiiatFF40R787BsoCmqYOjD+3+wh8LkFz1JbUo3zw==
X-Received: by 2002:adf:e5c6:: with SMTP id a6mr5792331wrn.185.1581711297798;
        Fri, 14 Feb 2020 12:14:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6182:d527:7ef1:e772? (p200300EA8F2960006182D5277EF1E772.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6182:d527:7ef1:e772])
        by smtp.googlemail.com with ESMTPSA id j5sm8662610wrw.24.2020.02.14.12.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 12:14:57 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Vincas Dargis <vindrg@gmail.com>
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
Cc:     netdev@vger.kernel.org
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
Date:   Fri, 14 Feb 2020 21:14:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.02.2020 18:21, Vincas Dargis wrote:
> Hi,
> 
> I've found similar issue I have myself since 5.4 on mailing list archive [0], for this device:
> 
Thanks for reporting. As you refer to [0], do you use jumbo packets?


> 05:00.1 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 12)
>         Subsystem: ASUSTeK Computer Inc. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
> 
> 
> It works fine as long as I select 5.3 in Grub (it seems no longer maintained in Debian Sid though...)
> 
> I see number of commits in net/etherenet/realtek tree, not sure if fix is there, or do we need another fix for this particular device? I've keep testing latest Debian kernel updates (latest is 5.4.19-1), and no good news yet.
> 
Best of course would be a bisect between 5.3 and 5.4. Can you do this?
I have no test hardware with this chip version (RTL8411B).

You could also try to revert a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
and check whether this fixes your issue.
In addition you could test latest 5.5-rc, or linux-next.

> There's Debian bug report [1] which might contain more information.
> 
> Some extra info:
> 
> $ sudo ethtool -i enp5s0f1
> driver: r8169
> version:
> firmware-version: rtl8411-2_0.0.1 07/08/13
> expansion-rom-version:
> bus-info: 0000:05:00.1
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: yes
> supports-priv-flags: no
> 
> 
> $ sudo mii-tool -v enp5s0f1
> enp5s0f1: negotiated 1000baseT-FD flow-control, link ok
>   product info: vendor 00:07:32, model 0 rev 0
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
>   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
> 
> 
> [0] https://lkml.org/lkml/2019/11/30/119
> [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=947685

Heiner
