Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6B65B22B
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 23:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfF3Vzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 17:55:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37335 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfF3Vzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 17:55:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14so11619368wrr.4
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 14:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jb88g57YQ1DTezwVFKC5cok7dTv6JD42n/07WJNUEZg=;
        b=TEG02qbiV1Qk6jVTvFvdPgTbAyIcPFzBU1dwFIRZFqHtB+WFeJeV9z5dY9kLxU3yAS
         598ZAvrZkx5cXM+/gHX5xNt49jwaCMBmGEKSFTGfWfCmuItVdXEmU9i+EIbqPhBXEAj1
         GbDl/XuxuyI2+bT1BS79fh3tADWBd9eigmvA50pmOilRFDx/sDDdbfTQo2FXAKZ6bm7M
         aGNfEn9bIj3dIg8Dy2SmnVi/thWRIxn98/81HHw1sAEQzNfzxFR9/vL6UH0WDJ4uLqzf
         Xv9wZERAA2RNO8tpO1t/FSAunxLU8IWE3qRaM1zu73VvORvBRIURWobSB4slwRcoUfnL
         8+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jb88g57YQ1DTezwVFKC5cok7dTv6JD42n/07WJNUEZg=;
        b=iS+K423kaDuPAb3GZYuk9rGJQ2DT3ST8ADW9YRkINNKxcdLngo1j3dQW28+y3ZOJYk
         xDqnupnZDweJ04ilEtNmQ58Iu4lgFSzAAg6qUFPvHLjx6gWzJiKogLchXGVtBQmFcwzD
         Yf7A4SvcVV6VSXmFDicULoZwi0VyisRrtKWSr9QM7svP6cw/pcVi5T+7Moa/DQnu9TA2
         BmohyvNCg7oX5oN6wpjR8KsXLntcvNaQ3h1s7gkLk5n1J2YwmhpiSSDdZSU5yUDumdNT
         BLYcdCvGDxaEocfA1e+BIR26WeODRW89wwt7JH2HLXKci1F5erBHHmbE9OL3zAJxij9a
         /CsQ==
X-Gm-Message-State: APjAAAWy0uSRuztnjGodWiCCA7AYVSVfbdLqq3YU5t1emEvpvlwfPGDs
        /SdwH7zCHIerholJAvoBxHq+uf9H
X-Google-Smtp-Source: APXvYqx+IRgT6C8+e4ljUWcY9Upy3tE63NQPqW8ibcmQXS/WsrbvA4BV874YLflg4FFRjPJ7RE5b1Q==
X-Received: by 2002:a5d:514e:: with SMTP id u14mr3197833wrt.97.1561931738694;
        Sun, 30 Jun 2019 14:55:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:7d07:14b4:53c2:77e1? (p200300EA8BD60C007D0714B453C277E1.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:7d07:14b4:53c2:77e1])
        by smtp.googlemail.com with ESMTPSA id l8sm21859734wrg.40.2019.06.30.14.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 14:55:38 -0700 (PDT)
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Karsten Wiborg <karsten.wiborg@web.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
 <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
 <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
Date:   Sun, 30 Jun 2019 23:55:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.06.2019 23:29, Karsten Wiborg wrote:
> Hi Heiner,
> 
> On 30/06/2019 19:42, Heiner Kallweit wrote:
>> Vendor driver uses this code, do you see the related messages in syslog?
>>
>>         if (!is_valid_ether_addr(mac_addr)) {
>>                 netif_err(tp, probe, dev, "Invalid ether addr %pM\n",
>>                           mac_addr);
>>                 eth_hw_addr_random(dev);
>>                 ether_addr_copy(mac_addr, dev->dev_addr);
>>                 netif_info(tp, probe, dev, "Random ether addr %pM\n",
>>                            mac_addr);
>>                 tp->random_mac = 1;
>>         }
>>
> 
> did the following:
> 
> # cat /var/log/messages |grep -i Invalid
> Jun 30 08:54:00 praktifix kernel: [    0.229213] DMAR-IR: Queued
> invalidation will be enabled to support x2apic and Intr-remapping.
> Jun 30 08:54:00 praktifix kernel: [   23.864072] Invalid pltconfig,
> ensure IPC1 device is enabled in BIOS
> Jun 30 10:17:30 praktifix kernel: [    0.228662] DMAR-IR: Queued
> invalidation will be enabled to support x2apic and Intr-remapping.
> Jun 30 10:17:30 praktifix kernel: [   24.198033] Invalid pltconfig,
> ensure IPC1 device is enabled in BIOS
> 
> But that does not relate to your error.
> 
> # cat /var/log/messages |grep -i random
> Jun 30 08:54:00 praktifix kernel: [    0.228092] random: crng done
> (trusting CPU's manufacturer)
> Jun 30 10:17:30 praktifix kernel: [    0.227534] random: crng done
> (trusting CPU's manufacturer)
> Jun 30 10:25:53 praktifix kernel: [  527.540354] r8168 0000:02:00.0
> (unnamed net_device) (uninitialized): Random ether addr 82:c2:81:10:6b:c2
> 
This one shows that the vendor driver (r8168) uses a random MAC address.
Means the driver can't read a valid MAC address from the chip, maybe due
to a broken BIOS.
Alternatively you could use r8169 and set a MAC address manually with
ifconfig <if> hw ether <MAC address>

> The last one probably results from my testing with r8169. The compiled
> r8168 went online later. That also is the only message I found.
> 
> Thank you for your help in debugging.
> 
> Regards and greetings from Hamburg,
> Karsten
> 
Heiner

