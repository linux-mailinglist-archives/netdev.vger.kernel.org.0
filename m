Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA22D005
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfE1UI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:08:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34473 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfE1UI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:08:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id f8so63830wrt.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 13:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UbPMbl9cPoFWGmecjZW7Z6HETP2TxRNM4wONMBlAACg=;
        b=JWOUXqkjlIRpW605eHp9UFOyEJEiDRrucMG34PDSy2jb/aAngz7/fZkR9XF08q7+xw
         cQuP6CKrMcchBy6k9mJDSUhGkrJ5/R7KCv2lC+tx5XPKT7uPeN7h+clCVYNziRygx3NF
         FYniF8iNtIIkbwNYaNsWGhX9b8GtAFZ7NmT8Pnkhax39aaG3uPTUzqVcUU+dyGv/w4UV
         kp3LjYHql7tXIx42tcmcvc3qTAuplH+Ve2G5gWNplOBnmParcuF76fsmCuOBhV/jBQb8
         7ORMPwenSw8Umwl53zGZDfaW+74WTI4KhSH7aETEiw0/S8dUkSgxeFGLmmxANeNjMQUa
         nTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UbPMbl9cPoFWGmecjZW7Z6HETP2TxRNM4wONMBlAACg=;
        b=t1eKUj4Q5ecTJLBcKgB3rsRbQlKnecdahQbRmK1/6+LrnpRwXpvJS8hlcxA0oT3d5e
         jYanOXDUdsHkkbi+KSUPMkQGnW39XcCS4fvx8dzwlRpM97wvsPPE9JyNez8fJvCVQU0J
         7Sijkcjw8U19v5VffUHvasdsIOr8T+fYXkoT5AYfn2KO/gDBHWDXJiiwV/kfkE4lvRc+
         8fB1q8XMmnUP9AKSv9aQCe+S9rgDVI4aa7RC3pDSWFgtTCbz+FXP+QSV0uOGsFOXWQuB
         374iCo36uGn71OpOdmfi/s2EYwagv1Awm+p6oJtOuOU24Vd+Az5YOe1ChKt7+HmNK3w4
         gnoQ==
X-Gm-Message-State: APjAAAVtysxjLNQfbUlvGa2Ildda2GuQmLiBmShzqnghXN9a5ZWv4k7y
        MzUU/wUgXpx9UhfK2zP5/4kF4nZ/
X-Google-Smtp-Source: APXvYqzbEtS1U8sZaJi3hKKI3svQp4tNcMDKOCvLOAfWIpa3l1JTqPGvZ5uBi+7qRfNXbxivNJw1cQ==
X-Received: by 2002:adf:f946:: with SMTP id q6mr4284062wrr.109.1559074106106;
        Tue, 28 May 2019 13:08:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id c131sm4420090wma.31.2019.05.28.13.08.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 13:08:25 -0700 (PDT)
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
 <861ebfca-08a2-f60f-2f7a-a2fad4c2f77c@gmail.com>
 <4a8eb515-472e-785e-619d-88ed1b2f8aa7@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c774df61-a80a-9170-ad3a-87526e2e038b@gmail.com>
Date:   Tue, 28 May 2019 22:08:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4a8eb515-472e-785e-619d-88ed1b2f8aa7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2019 21:37, Florian Fainelli wrote:
> On 5/27/19 12:36 PM, Heiner Kallweit wrote:
>> On 27.05.2019 21:25, Florian Fainelli wrote:
>>>
>>>
>>> On 5/27/2019 11:28 AM, Heiner Kallweit wrote:
>>>> The phylib interrupt handler handles link change events only currently.
>>>> However PHY drivers may want to use other interrupt sources too,
>>>> e.g. to report temperature monitoring events. Therefore add a callback
>>>> to struct phy_driver allowing PHY drivers to implement a custom
>>>> interrupt handler.
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>>>> ---
>>>>  drivers/net/phy/phy.c | 9 +++++++--
>>>>  include/linux/phy.h   | 3 +++
>>>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>>> index 20955836c..8030d0a97 100644
>>>> --- a/drivers/net/phy/phy.c
>>>> +++ b/drivers/net/phy/phy.c
>>>> @@ -774,8 +774,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>>>>  	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
>>>>  		return IRQ_NONE;
>>>>  
>>>> -	/* reschedule state queue work to run as soon as possible */
>>>> -	phy_trigger_machine(phydev);
>>>> +	if (phydev->drv->handle_interrupt) {
>>>> +		if (phydev->drv->handle_interrupt(phydev))
>>>
>>> If Russell is okay with such a model where the PHY state machine still
>>> manages the interrupts at large, and only calls a specific callback for
>>> specific even handling, that's fine. We might have to allow PHY drivers
>>> to let them specify what they want to get passed to
>>> request_threaded_irq(), or leave it to them to do it.
>>>
>> This proposed easy model should be able to cover quite some use cases.
>> One constraint may be that interrupts are disabled if phylib state
>> machine isn't in a started state. Means most likely it's not able to
>> cover e.g. the requirement to allow temperature warning interrupts if
>> PHY is in state HALTED.
>>
> 
> There is possibly an user case where having interrupts might be useful,
> imagine your system overheated and you brought down the PHY into
> PHY_HALTED stated, you might want to be able to receive thermal trip
> point crossing indicating that the low threshold has been crossed, which
> means you could resume operating the link again.
> 
To be prepared for all use cases we would need to request and enable
interrupts as early as in phy_probe(). This would be before phy_init_hw()
has been called. Not sure whether that's safe. phy_init_hw() calls the
config_init callback that may use the interface mode. Therefore we
can't simply move phy_init_hw().



