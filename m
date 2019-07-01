Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9965C338
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGASvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:51:37 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37413 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGASvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:51:37 -0400
Received: by mail-wm1-f42.google.com with SMTP id f17so610184wme.2
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 11:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gSqzIGHj1/iqrsOyEH70cNPX0m66sSkLSGw4B+4zb7Q=;
        b=DKVCZCSkxjFezZoCCedGHAVz9etK0Sfg+5jc3GK4DzahorSWac3+opEhTMPMD7oJJK
         1uYl5kq5OmLr4aJQQU7/HkK9SpiHn4t3NpdOwJ/9rWnKW1narYIDz4TFaQGoVx7yAlPj
         44j+XlvENeQUAQK2OrEXP6N9DVaScjFPtQLxJz2CBUBuBi4SqMoPKCny9YeqoK3q4+nM
         n/es+xYjz2UR5+gkjx8ENCl9icBWLK3bK33CVEbDqIXHnvuURMuZJ7sqLcf/avzEIhl8
         YfIN09QxP8tvuAqA9rUwagqlUVfeI1mAo9IHiBU7kI21VCDCJR9v0mLUYl+pKLc1rHNU
         E20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gSqzIGHj1/iqrsOyEH70cNPX0m66sSkLSGw4B+4zb7Q=;
        b=D4xdL2LpqT5z+2TlpDCSvu2c7GQpIC5ecqOaYxgR67wtiALecHX1vhUqMNV7QoTCof
         UOE1bzIaSSK5QcVmXDm+gGr89YQ1yjPnZaRVHbmSrZxg+SAtWoqHijEn2Wb1BsE975EY
         0Ydz3VLYU1kgxvD//LCWcfnVKvUU0ao/BqzaEZVEvKOlafO3FFR//L7JEigTeYh2bvbl
         Holsd7ifuNuayPUZCTbpT4n908Ug9F5YpmoEA6Lw/0MA39lY2T+h+nHtwlMgkDmMjwez
         O2QMAYKOMR+uhztj7/gZTuu+RQslaPzKHKtpEPC4oqRBHxTzmgHmWL21z3ZDeSk3ciyA
         Ot3Q==
X-Gm-Message-State: APjAAAXppritmo2NCIDecCmtWVdtRo7ze3+DGusNXOUtvny/H1WogPl8
        di4+NxZAYkNDy48mpknF2VQGCToI
X-Google-Smtp-Source: APXvYqxCGhhYAlgpq+2MiT4D39DzO5Ao5dVRxtEjGhJMDRCfvVG4SI3fYO9HGXz69++3uVTogp5X0w==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr403639wmd.54.1562007095032;
        Mon, 01 Jul 2019 11:51:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc? (p200300EA8BD60C008DAC9AD2A34C33BC.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc])
        by smtp.googlemail.com with ESMTPSA id 32sm23990533wra.35.2019.07.01.11.51.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:51:34 -0700 (PDT)
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Karsten Wiborg <karsten.wiborg@web.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
 <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
 <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
 <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
 <116e4be6-e710-eb2d-0992-a132f62a8727@web.de>
 <94b0f05e-2521-7251-ab92-b099a3cf99c9@gmail.com>
 <20190701133507.GB25795@lunn.ch>
 <672d3b3f-e55d-e2bb-1d8c-a83d0a0c057a@web.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d48eb3dd-be07-1422-4649-91f3461676c4@gmail.com>
Date:   Mon, 1 Jul 2019 20:51:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <672d3b3f-e55d-e2bb-1d8c-a83d0a0c057a@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2019 20:15, Karsten Wiborg wrote:
> Hi Andrew, Heiner,
> 
> the device is a really small notebook. So detaching mains still leaves
> the battery which is delicately built in. So can't currently remove
> power completely.
> 
> Anyway can I deliver more debugging data to you guys which might add
> support for the r8169 for this device?
> 
The information is sufficient now. Still, using a random MAC address
is an emergency fallback. The device is simply broken.
I contacted GPD, let's see whether they respond something.

In parallel I'll add a random MAC address as fallback to the
mainline driver.

> Regards,
> Karsten
> 
Heiner

> On 01/07/2019 15:35, Andrew Lunn wrote:
>>> When the vendor driver assigns a random MAC address, it writes it to the
>>> chip. The related registers may be persistent (can't say exactly due to
>>> missing documentation).
>>
>> If the device supports WOL, it could be it is powered using the
>> standby supply, not the main supply. Try pulling the plug from the
>> wall to really remove all power.
>>
>>      Andrew
>>
> 

