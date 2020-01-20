Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB621432F0
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 21:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgATUfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 15:35:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51288 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATUfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 15:35:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so691693wmd.1
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 12:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6ascpwJ6ZHVY3raviKXuVMZRcWzjHuL1BM7dNpjnioQ=;
        b=U978OSVXl6D/+WDe/xYrFvDjFPo9t5+3RE+T27QleK9nXXWU8RD/OzoUXRr+SmKPA+
         oO+N+tO+OfSSMjpQwcBqL0m/VuxeKTgXzws81e+8FUOjEQIeb/kafOOExoWSmdy28zGI
         ahv64Ysy7ymm62k+ou5W0z+/6LVNiuTlWf1Va8s5WZQj8q2qciR8V9bVUZ8X8TrjWNnN
         at8fzjK48yL36BiPTHLIaDNno8A4/2puJSCN326gknWBQymDXztkQ7+9RWhay3+/3u9B
         JII/46reixXHQfkzCngwaQXh2P5wJ0Wi3SR/T8YbCgSm8B0Mvi9pGmaFf8cbNAj4v0xE
         R0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ascpwJ6ZHVY3raviKXuVMZRcWzjHuL1BM7dNpjnioQ=;
        b=Ba0mubokxsWffnoozI5DUA4O/ObaE9dKWBVVR0ioGirR4U5tlVboF2Jhea2gpCB5EL
         6AVvsywdrJWGabR/cjSfaF8V6CiS2yOLQ6hiZ58+p8Q4fRnNlsEUz0mIE2ykW6/atBts
         6fMQeeeaavHB4ZvAB46WvNvya54IzWbDSOSk+AQFsSsNSmKyF/62guRGDkC88nPP1JNE
         f7kKp/tg4qgOL3PePqQsbflTEHHfiA39NSh4R8w+XTy3QC+Bk8eW/anoB0AR41QA+SQq
         VTbGjMd6kS/Pr+GxbrIDjnVmFgFj75wju83djouk/XR3UcrRFJKK0Ijr/6YKtvzetSAR
         Y0Mg==
X-Gm-Message-State: APjAAAVKOVjPF4tFjNCxb7M6LmIQHeMuV8lE23R5cgThX0kcsA6UsVka
        6skp+CIhfg15LLZoCWZMs+Bb9qG0
X-Google-Smtp-Source: APXvYqyNyHHTencNtjsdzcUZjTi9dbkwB63mZED5n4fvSn6j3P0ejBFAU0e79WQJCMFt8DruoKYNmA==
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr605373wmi.15.1579552522810;
        Mon, 20 Jan 2020 12:35:22 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id x10sm47822013wrv.60.2020.01.20.12.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 12:35:22 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
 <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
 <20200119175109.GB17720@lunn.ch>
 <c1f7d8ce-2bc2-5141-9f28-a659d2af4e10@gmail.com>
 <20200119185035.GC17720@lunn.ch>
 <82737a2f-b6c1-943e-42a2-d42d87212457@gmail.com>
 <20200119205059.GD17720@lunn.ch>
 <154281b8-43c5-ba18-1860-03e4b0c785fd@gmail.com>
Message-ID: <2b190b5f-5abb-3647-333c-da51d6bab593@gmail.com>
Date:   Mon, 20 Jan 2020 21:35:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <154281b8-43c5-ba18-1860-03e4b0c785fd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.01.2020 23:28, Heiner Kallweit wrote:
> On 19.01.2020 21:50, Andrew Lunn wrote:
>>> Speaking for r8169:
>>> If interface is up and cable detached, then it runtime-suspends
>>> and goes into PCI D3 (chip and MDIO bus not accessible).
>>> But ndev is "running" and PHY is attached.
>>
>> Hi Heiner
>>
> Hi Andrew,
> 
Hi Andrew

>> And how does it get out of this state? I assume the PHY interrupts
>> when the link is established. Is phylib handling this interrupt? If
>> so, when phylib accesses the MDIO bus, the bus needs to be runtime PM
>> aware. And if the bus is runtime PM aware, the IOCTL handler should
>> work, when the device is runtime suspended.  If the MAC is handling
>> this interrupt, and it is the MAC interrupt handler which is run-time
>> unsuspending, then the ioctl handler is not going to work unless it
>> also runtime unsuspends.
>>
> The chip (wherever the magic happens) generates a PCI PME if WoL
> config includes detection of physical link-up. The PCI core then
> runtime-resumes the device.
> I'd prefer the ioctl to return an error here instead of e.g.
> 0xffff for a register read.
> 
I checked a little further and indeed there's a need to check whether
net_device is present, but net core (dev_ifsioc) already does this
check before calling the ndo_do_ioctl handler. So we don't have to
do it in the handler again.

I saw that David applied my series already. So I'll send a follow-up
series that:
- renames phy_do_ioctl to phy_do_ioctl_running
- adds phy_do_ioctl (w/o check that netdev is running)
- converts users to phy_do_ioctl

>> 	Andrew
>>
> Heiner
> 
Heiner
