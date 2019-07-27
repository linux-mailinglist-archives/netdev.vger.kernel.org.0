Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC11775C3
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 03:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfG0B4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 21:56:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38209 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0B4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 21:56:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id f5so16738293pgu.5;
        Fri, 26 Jul 2019 18:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+r1Jf7HsWqkg8FYa7uesUzkrZtCjbPloOA40dzxmdY=;
        b=BobiB+JMpw3YdHN52pVs0y3Hk9me5OUP4b82DV70BjHEpdsIHOovWHeSspUI7/ZdDZ
         fZ7xsxp532TuA919s8emfLW/yH7A1PkH2nxsZiKJACvctSPpWRYs139NDCiSwrbP9bLv
         x1y5PcogIVpfPYiy+UuE29bcoh1v6Mz3WdOTYVl27rVI9WJavGnvGlzQbX878Oub9qrh
         A1SiQUxkteLZPJrxGJuWajnQ+iUeeDUCm/leIWbcZLhpJeuY/hiv7hcZaxM/t2a3WYXR
         Zt/rhY9hdAX18Cq5ygOXdyA347be3Tukg2N8nsx2vWNqOlErGPvYspqhuS4K6Yhaunch
         iNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+r1Jf7HsWqkg8FYa7uesUzkrZtCjbPloOA40dzxmdY=;
        b=diEzI3tPaT8HF3JgZSwVDzkmsNXwm3EaCof5X2Ud44mAt/nxwcwTVnO9i0DKRm7jcZ
         N90OVBNxp7rjTLSuWK/lVFdHDJ+tIw3K0avqf6PxBqEMqCsH6gcFCFkCDPwdQY/S5tUJ
         vJdJ5mgkzb2Pq8uUJ+C9gKilwh23KPKo7YPkII7V19ohF5HI1xbii0v22sPY4TC/Urqw
         RjncxF2xBHHRJPyyg2T+EyH6MEzBCdW2owDS83vs1kp/B5jeyGYM8SKckMfs1rMUA+lJ
         3al8M7FhnbkekeAES+BcBdh5/i4U7iUcVG/pp2Seo0QhlNOilhALWiMBrRn60uI7euTe
         +46g==
X-Gm-Message-State: APjAAAUvvwGjHQ2nRlogOyMX781EUCxA81EpGwY66NXBgeVzk3IuuaU3
        nXgr1uTTcVb7Dw14m39C1gA=
X-Google-Smtp-Source: APXvYqzOMyF8QtzM5EplAjtJU3IAbE80dKRh1AoIyzIrau7BIlUroDO8t0md3cGFsArlQ6DUzuSJOA==
X-Received: by 2002:aa7:8b11:: with SMTP id f17mr25338093pfd.19.1564192567759;
        Fri, 26 Jul 2019 18:56:07 -0700 (PDT)
Received: from ?IPv6:2405:4800:58f7:1782:e03a:f6b:ecba:b51? ([2405:4800:58f7:1782:e03a:f6b:ecba:b51])
        by smtp.gmail.com with ESMTPSA id u16sm51302148pjb.2.2019.07.26.18.56.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 18:56:06 -0700 (PDT)
Cc:     tranmanphong@gmail.com, gigaset307x-common@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Subject: Re: [PATCH] isdn/gigaset: check endpoint null in gigaset_probe
To:     Paul Bolle <pebolle@tiscali.nl>, isdn@linux-pingi.de,
        gregkh@linuxfoundation.org
References: <20190726133528.11063-1-tranmanphong@gmail.com>
 <1876196a0e7fc665f0f50d5e9c0e2641f713e089.camel@tiscali.nl>
From:   Phong Tran <tranmanphong@gmail.com>
Message-ID: <24cd0b70-45e6-ea98-fc8f-b25fbf6e817f@gmail.com>
Date:   Sat, 27 Jul 2019 08:56:02 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1876196a0e7fc665f0f50d5e9c0e2641f713e089.camel@tiscali.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/19 9:22 PM, Paul Bolle wrote:
> Phong Tran schreef op vr 26-07-2019 om 20:35 [+0700]:
>> This fixed the potential reference NULL pointer while using variable
>> endpoint.
>>
>> Reported-by: syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
>> Tested by syzbot:
>> https://groups.google.com/d/msg/syzkaller-bugs/wnHG8eRNWEA/Qn2HhjNdBgAJ
>>
>> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
>> ---
>>   drivers/isdn/gigaset/usb-gigaset.c | 9 +++++++++
> 
> This is now drivers/staging/isdn/gigaset/usb-gigaset.c.

this patch was created base on branch 
kasan/usb-fuzzer-usb-testing-2019.07.11 [1]
I did not notice about the driver was moved to staging.

> 
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
>> index 1b9b43659bdf..2e011f3db59e 100644
>> --- a/drivers/isdn/gigaset/usb-gigaset.c
>> +++ b/drivers/isdn/gigaset/usb-gigaset.c
>> @@ -703,6 +703,10 @@ static int gigaset_probe(struct usb_interface *interface,
>>   	usb_set_intfdata(interface, cs);
>>   
>>   	endpoint = &hostif->endpoint[0].desc;
>> +        if (!endpoint) {
>> +		dev_err(cs->dev, "Couldn't get control endpoint\n");
>> +		return -ENODEV;
>> +	}
> 
> When can this happen? Is this one of those bugs that one can only trigger with
> a specially crafted (evil) usb device?
> 

Yes, in my understanding, this only happens with random test of syzbot.

>>   	buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
>>   	ucs->bulk_out_size = buffer_size;
>> @@ -722,6 +726,11 @@ static int gigaset_probe(struct usb_interface *interface,
>>   	}
>>   
>>   	endpoint = &hostif->endpoint[1].desc;
>> +        if (!endpoint) {
>> +		dev_err(cs->dev, "Endpoint not available\n");
>> +		retval = -ENODEV;
>> +		goto error;
>> +	}
>>   
>>   	ucs->busy = 0;
>>   
> 
> Please note that I'm very close to getting cut off from the ISDN network, so
> the chances of being able to testi this on a live system are getting small.
> 

This bug can be invalid now. Do you agree?
There is an instruction to report invalid bug to syzbot [2].

> Thanks,
> 
> 
> Paul Bolle
> 


[1] 
https://github.com/google/kasan/commits/usb-fuzzer-usb-testing-2019.07.11
[2] 
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#communication-with-syzbot

Thanks,
Phong
