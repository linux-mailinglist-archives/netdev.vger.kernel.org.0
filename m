Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06382BAC7
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfE0Tgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:36:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39754 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0Tgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:36:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id e2so9028289wrv.6
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YRfybiLuNWy+LCCa7lYBwtjsUft50y9lXzXnaCJu5Go=;
        b=nGjs29OA9I6OoRlhxzmEBRtRka1FYGfLgAF44EE31CkCiVPZJ9C5yVMikrrmZmaxkB
         6aF4lwclSyy2c5SYMRsOb7k9NP4QB8gXXUi2MoCNm8DH8qcrNCDKWGgMp8bTk0vuvz/a
         RBu1BLqKhrNHa1FjO/gzofif+FKK0wYsgt6NO4oy97gWOSE4vZjwI5z9JQUeamJ11+JU
         8HCo53HOfSOmhT/H42ubuU6NFLOZuWUx1Cnejh94/HjAXqK82SF4G97dvpn+ppgSNhQg
         YqpqUoEJx7F3ZUvYWPFAUmjOReufZcqUVqIXxuNNn+2m1XzL+X3lp7yK7zrKZg/TGOsj
         mjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YRfybiLuNWy+LCCa7lYBwtjsUft50y9lXzXnaCJu5Go=;
        b=Ry9CXL+EUCUERJzBFzvgqFIQ0PmjOvhJzkSLj9SidLAsIFK5N0R04hdQxvg2ULqffW
         5dGTMqr6ry5928Q6SS5017uYeBJ6HFve2GZ766PGirWsCA31KAC7TRQ9FChUUIemF8K/
         8fA+Z/xQlCW9+aNdysPkhGPdzQv3ieV6uX3T1AjeKMQ7XMt6e/qF3b2bkH80pDHopaFJ
         VXEehPOPnobAnAbRmwoKwf4yEkZkRy0xZaO7aRj1iLF/hwVrhQBr48rBUZkjGCZtlvjv
         8p+aOj+0BxSMniG7QpbAiRhUbAOe86fv3m0s+xNUM4w4Yt2ua+vL+SQOWpiKaO+NXwh1
         gT7g==
X-Gm-Message-State: APjAAAVHMM+kdpeXcweNksNE6hPyiP7h1ZkdDuwi9T8VRZpT0nkRvG+G
        aWs+2/HW5+eP6EGK9BuGTsIEeLRn
X-Google-Smtp-Source: APXvYqx57rKTt05UfshR4xyUiplL/6tXZ4K8OjdJ1MrkcF9EjJ0F3lbjEs+1fMSAqnspzF7OxozCiw==
X-Received: by 2002:adf:b6a5:: with SMTP id j37mr71917758wre.4.1558985796543;
        Mon, 27 May 2019 12:36:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:485f:6c34:28a2:1d35? (p200300EA8BE97A00485F6C3428A21D35.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:485f:6c34:28a2:1d35])
        by smtp.googlemail.com with ESMTPSA id t6sm748881wmt.34.2019.05.27.12.36.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:36:36 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: phy: add callback for custom interrupt
 handler to struct phy_driver
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <9929ba89-5ca0-97bf-7547-72c193866051@gmail.com>
 <64456292-42c8-c322-93bc-ab88d1f18329@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <861ebfca-08a2-f60f-2f7a-a2fad4c2f77c@gmail.com>
Date:   Mon, 27 May 2019 21:36:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <64456292-42c8-c322-93bc-ab88d1f18329@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.05.2019 21:25, Florian Fainelli wrote:
> 
> 
> On 5/27/2019 11:28 AM, Heiner Kallweit wrote:
>> The phylib interrupt handler handles link change events only currently.
>> However PHY drivers may want to use other interrupt sources too,
>> e.g. to report temperature monitoring events. Therefore add a callback
>> to struct phy_driver allowing PHY drivers to implement a custom
>> interrupt handler.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>> ---
>>  drivers/net/phy/phy.c | 9 +++++++--
>>  include/linux/phy.h   | 3 +++
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index 20955836c..8030d0a97 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -774,8 +774,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>>  	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
>>  		return IRQ_NONE;
>>  
>> -	/* reschedule state queue work to run as soon as possible */
>> -	phy_trigger_machine(phydev);
>> +	if (phydev->drv->handle_interrupt) {
>> +		if (phydev->drv->handle_interrupt(phydev))
> 
> If Russell is okay with such a model where the PHY state machine still
> manages the interrupts at large, and only calls a specific callback for
> specific even handling, that's fine. We might have to allow PHY drivers
> to let them specify what they want to get passed to
> request_threaded_irq(), or leave it to them to do it.
> 
This proposed easy model should be able to cover quite some use cases.
One constraint may be that interrupts are disabled if phylib state
machine isn't in a started state. Means most likely it's not able to
cover e.g. the requirement to allow temperature warning interrupts if
PHY is in state HALTED.
