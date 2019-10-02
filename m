Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E40EC473B
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 07:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfJBFy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 01:54:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38120 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJBFy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 01:54:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so5511780wmi.3
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 22:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BJ5XkARjrsctTr6v4jjomtgn5oAoTYjYzSRS5j9aZeU=;
        b=NGYuqHtNro6mqKkqOgwfqIdNk7O9vaJQfgCQArHg1Y6Iyp+qRjQHXUu/OhZqQ2jhyd
         BmVHdVtXlCTZzs1UX9ywtXDJGKcMzkkvbdFvjP4MEUwW8xZ3q9jz8Dor34ArCQxrbMOa
         Q+uAQ9iWrcGRTMm2R9S3NXJPlSmqDjr0cZXdogGL6xbOOU/1do0pHqbu5OhdiKhsTIkp
         sRpNTauxSHZJiQ5gW6CLj/YTDpPsiPsV9nPCuVpR6pzUdMmkcAj+huAlx8mhfHJ+Ncpy
         +cFlGJdiFtfoJJoCDd5Ydx9goZ2CgYSPDrVOJJaNDoJqeqb6C4RVA8U3vfJLOXFSqlWC
         e/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJ5XkARjrsctTr6v4jjomtgn5oAoTYjYzSRS5j9aZeU=;
        b=syYDM5jaoInM6Gkaex6rrvyFZWKSvcWzqosUbQJGYVG7g7gI0EK/ZT27YMMuUW2CsB
         uDimT/FjZJlcm41YRpb10R7nUdA4GmZ4Gulx85+NCBNH9ROfym4csXfU4KlV6lWpzZvI
         oUI77frDSxGwZmA9fPesRM/tzrTzbtt7wtqO4rg8Oz3muembZT4A60AZTY8JUDTryqtS
         Nbk5pNi7z9e60EYZFqwFp/rOsD8Lh/EC2u+IWBXoXFdiludqZF9ftsH+on/i9tbUmV5d
         fYmHnt/DY7WO1jBvDZwKDIZqSlLJ5vMokAUt0v4iflfcU02fZttbakQNfUvcHZPRkjol
         VTdw==
X-Gm-Message-State: APjAAAVkx99k+l1AicPG5JKdSi7BY3o/au01pobHWTVjQCCuJEN10VhH
        u39P7Bp5KCPN0fVUbqWB6IY=
X-Google-Smtp-Source: APXvYqyWTKAkl6QWIjp6OWJCYH0BEpKLfuBZYoX7iTbJS4pIHHHVRejebd8lB6muLeiaoizuF4Gkrg==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr1360477wmo.142.1569995665637;
        Tue, 01 Oct 2019 22:54:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:5848:5aae:a901:904c? (p200300EA8F26640058485AAEA901904C.dip0.t-ipconnect.de. [2003:ea:8f26:6400:5848:5aae:a901:904c])
        by smtp.googlemail.com with ESMTPSA id z1sm35866369wre.40.2019.10.01.22.54.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 22:54:24 -0700 (PDT)
Subject: Re: Driver support for Realtek RTL8125 2.5GB Ethernet
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     Linux Upstreaming Team <linux@endlessm.com>
References: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
 <e178221e-4f48-b9b9-2451-048e8f4a0f9f@gmail.com>
 <a3066098-9fba-c2f4-f2d3-b95b08ef5637@gmail.com>
Message-ID: <71ccd182-beec-31f4-5a25-a81a7457ca55@gmail.com>
Date:   Wed, 2 Oct 2019 07:54:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a3066098-9fba-c2f4-f2d3-b95b08ef5637@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.07.2019 21:05, Heiner Kallweit wrote:
> On 24.07.2019 22:02, Heiner Kallweit wrote:
>> On 24.07.2019 10:19, Jian-Hong Pan wrote:
>>> Hi all,
>>>
>>> We have got a consumer desktop equipped with Realtek RTL8125 2.5GB
>>> Ethernet [1] recently.  But, there is no related driver in mainline
>>> kernel yet.  So, we can only use the vendor driver [2] and customize
>>> it [3] right now.
>>>
>>> Is anyone working on an upstream driver for this hardware?
>>>
>> At least I'm not aware of any such work. Issue with Realtek is that
>> they answer individual questions very quickly but company policy is
>> to not release any datasheets or errata documentation.
>> RTL8169 inherited a lot from RTL8139, so I would expect that the
>> r8169 driver could be a good basis for a RTL8125 mainline driver.
>>
> Meanwhile I had a look at the RTL8125 vendor driver. Most parts are
> quite similar to RTL8168. However the PHY handling is quite weird.
> 2.5Gbps isn't covered by Clause 22, but instead of switching to
> Clause 45 Realtek uses Clause 22 plus a proprietary chip register
> (for controlling the 2.5Gbps mode) that doesn't seem to be accessible
> via MDIO bus. This may make using phylib tricky.
> 
In case you haven't seen it yet: Meanwhile I added RTL8125 support to
phylib and r8169, it's included in 5.4-rc1. I tested it on a
RTL8125-based PCIe add-on card, feedback from your system would be
appreciated. Note that you also need latest linux-firmware package
from Sep 23rd.

>>> [1] https://www.realtek.com/en/press-room/news-releases/item/realtek-launches-world-s-first-single-chip-2-5g-ethernet-controller-for-multiple-applications-including-gaming-solution
>>> [2] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
>>> [3] https://github.com/endlessm/linux/commit/da1e43f58850d272eb72f571524ed71fd237d32b
>>>
>>> Jian-Hong Pan
>>>
>> Heiner
>>
> Heiner
> 
Heiner
