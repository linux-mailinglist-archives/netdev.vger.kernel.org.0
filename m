Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FF52DD207
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 14:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgLQNS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 08:18:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgLQNSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 08:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608211049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocVbXd5tOfDrxGvrA5+6ey5fuQhbI9fTf7NbBH/g/Pc=;
        b=FXCld0sZb7HQQxh8YRNkV0KAs5ZQTXGWlzVyCLx6YEzcX/GWdnecCj+RjVuSDN7J5qV1HY
        h1MfAzpNbgn68rcykSSZFhEkxJJ+ElhHVmydPHOcT8W6DNxZxf+6u+qOhnd+ulcxRkKRHt
        k1tz83ZSlaqSgRqq7ccXeuFXGJfHgE8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-dlLoSIlIMLauYByutImpqA-1; Thu, 17 Dec 2020 08:17:27 -0500
X-MC-Unique: dlLoSIlIMLauYByutImpqA-1
Received: by mail-qt1-f197.google.com with SMTP id v9so20688627qtw.12
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 05:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ocVbXd5tOfDrxGvrA5+6ey5fuQhbI9fTf7NbBH/g/Pc=;
        b=KZ6dhF0vj8jM3ZaIPc8+ezdiEJmEzdQz2txNwmiua4X96v5jCM+voN2fYxHjxjwEla
         V4vo8lEYozjKjqMb3E1zAjNWBTSx/aeJiUQQyE2nms5FQml6QmmcVpdHlgccK4To1Qmx
         55EvtxdPfHNKJYRzOvLp2VbRzaxOELP/qZCI8WoZWsw82WK7JhQXplLRGWC0F3t/o+BJ
         p8Hhgf8O2ARS7gN8OdiHyxcY5tH8SRqvVCxhPnFx8xEXnzhEwkeKlYp54da+OHTkUuSP
         On/8MZNtpeC1m7I8u0LDbpnMrvE6DxjoYioIOaTIFR0Nn+9qifgPiXhi5OEJ8n+E9ndC
         xfiw==
X-Gm-Message-State: AOAM5315fhk7GX7ILVqY3dgEyMDZ+7JN5lR0Ew+/OyQjjbBP909EP04o
        Z+Esg2Fu5UDrqFDrl3OgMhJ1jdpW8fgV9ekaNoRw0ZDSTNUeI1rQgQ1U2g2cpMV4N2SV4vFuyQ7
        179PxRZjE2J5OBCSC
X-Received: by 2002:aed:3144:: with SMTP id 62mr48589776qtg.342.1608211046915;
        Thu, 17 Dec 2020 05:17:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhFwVGG8Kkax7v/eyJISK93npWC3VG3nlu8liesJbrGCip5EwprgQTQF6BcwFvzS1O4uZAiQ==
X-Received: by 2002:aed:3144:: with SMTP id 62mr48589755qtg.342.1608211046674;
        Thu, 17 Dec 2020 05:17:26 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w192sm3351417qka.68.2020.12.17.05.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 05:17:26 -0800 (PST)
Subject: Re: [PATCH] atm: ambassador: remove h from printk format specifier
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201215142228.1847161-1-trix@redhat.com>
 <20201216164510.770454d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <6ada03ed-1ecb-493b-96f8-5f9548a46a5e@redhat.com>
Date:   Thu, 17 Dec 2020 05:17:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201216164510.770454d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/16/20 4:45 PM, Jakub Kicinski wrote:
> On Tue, 15 Dec 2020 06:22:28 -0800 trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> See Documentation/core-api/printk-formats.rst.
>> h should no longer be used in the format specifier for printk.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
> That's for new code I assume?
>
> What's the harm in leaving this ancient code be?

This change is part of a tree wide cleanup.

drivers/atm status is listed as Maintained in MAINTAINERS so changes like this should be ok.

Should drivers/atm status be changed?

Tom

>
>> diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
>> index c039b8a4fefe..6b0fff8c0141 100644
>> --- a/drivers/atm/ambassador.c
>> +++ b/drivers/atm/ambassador.c
>> @@ -2169,7 +2169,7 @@ static void setup_pci_dev(struct pci_dev *pci_dev)
>>  		pci_lat = (lat < MIN_PCI_LATENCY) ? MIN_PCI_LATENCY : lat;
>>  
>>  	if (lat != pci_lat) {
>> -		PRINTK (KERN_INFO, "Changing PCI latency timer from %hu to %hu",
>> +		PRINTK (KERN_INFO, "Changing PCI latency timer from %u to %u",
>>  			lat, pci_lat);
>>  		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, pci_lat);
>>  	}
>> @@ -2300,7 +2300,7 @@ static void __init amb_check_args (void) {
>>    unsigned int max_rx_size;
>>    
>>  #ifdef DEBUG_AMBASSADOR
>> -  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &= DBG_MASK);
>> +  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &= DBG_MASK);
>>  #else
>>    if (debug)
>>      PRINTK (KERN_NOTICE, "no debugging support");

