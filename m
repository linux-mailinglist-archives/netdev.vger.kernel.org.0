Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D641C3EC2D3
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 15:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhHNNTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 09:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbhHNNTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 09:19:31 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B4DC061764;
        Sat, 14 Aug 2021 06:19:01 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id n6so19896669ljp.9;
        Sat, 14 Aug 2021 06:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cr8HVeHd12HLdO05fgAd9qzil9aAvneqAPuVADXCz+s=;
        b=Ir6VbEE8D+BMdy/dwWslbPOHaadgd5AtkG34R4WbL9h+QlVSITnwLPADVSEvAD6ZM5
         w18seqNcss0OkHdk0tiYzTdcxugHit8o0WUbGtB7alv+pWlFCRKlhCOwtOaV0ZJt21+b
         iZMpau+Z7HDME1C5keyoRapiYzPK9Inp8xvrdu+CSX9qG6VLVtogFFrO9+uEfFRw+fOF
         Y/zjei6hspHQPOWeOn+YBi+yhC6vx6q1EPsOI1ABpw2Cs2XHlnCycAlR8EUhCbMzkOp0
         hF85HliqJZUIisBk6HyRLJqvE6rchL1wcaNgTLeCMa7S/7wZB075UDfki2+R/mcbLAwP
         h2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cr8HVeHd12HLdO05fgAd9qzil9aAvneqAPuVADXCz+s=;
        b=HNvDZ4pNpOevcpUquhzW9rdbm66TswCi36xQgK3EOq2g3pB5AnAOMapyMq4vCRdwjG
         t+Vo8Pc7VVPwweSP6NoIFHNQvSilXbiXs2SG1sjM7PCdkQbiXbCoyPC5LLbKpHKA0FEP
         R6JKb2N4fLygf9afuGPojy0+jjzy+/9chFC85hs5317zn85IOvzdwQabzMsJK6ssnT3q
         mzZ+UhdazS1eyD1bcusCMXt6DlP+E9mRjGlre8yeBUc3JW/WcM12sDgkdrQ1/KEe2gQi
         MVb1VY3O6unyezxXLTOs8Y/mcs/cDa6ZeBn3k+/Lm8xriQNuGeRTFm7DATkq2Do54T6u
         IO+A==
X-Gm-Message-State: AOAM533ntvU7wdAFM3sCzAX6aiNUQLe9DAIwIKoPiTkn05CoUKEF5//1
        9oBbOtIfuK0LAAVc1T6Gjfijw9p7lp/qLh5a
X-Google-Smtp-Source: ABdhPJwTk6ewrNbWZcok8gU6/Xcfk8pw07gonhRWx0gU7USSrI9j6n7RMCiLkjAVadqDallh2KhUSw==
X-Received: by 2002:a2e:9585:: with SMTP id w5mr5471976ljh.124.1628947140172;
        Sat, 14 Aug 2021 06:19:00 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.122])
        by smtp.gmail.com with ESMTPSA id f23sm537455ljn.45.2021.08.14.06.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 06:18:59 -0700 (PDT)
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
To:     Jakub Kicinski <kuba@kernel.org>,
        Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org, davem@davemloft.net
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
 <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <9688d41f-a9f0-47f3-5f51-5c7981f5337e@gmail.com>
Date:   Sat, 14 Aug 2021 16:18:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 2:24 AM, Jakub Kicinski wrote:
> On Thu, 12 Aug 2021 11:23:51 +0300 Petko Manolov wrote:
>> The return value need to be either ignored or acted upon, otherwise 'deadstore'
>> clang check would yell at us.  I think it's better to just ignore what this
>> particular call of set_registers() returns.  The adapter defaults are sane and
>> it would be operational even if the register write fail.
>> 
>> Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
>> ---
>>  drivers/net/usb/pegasus.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
>> index 652e9fcf0b77..49cfc720d78f 100644
>> --- a/drivers/net/usb/pegasus.c
>> +++ b/drivers/net/usb/pegasus.c
>> @@ -433,7 +433,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>>  	data[2] = loopback ? 0x09 : 0x01;
>>  
>>  	memcpy(pegasus->eth_regs, data, sizeof(data));
>> -	ret = set_registers(pegasus, EthCtrl0, 3, data);
>> +	set_registers(pegasus, EthCtrl0, 3, data);
>>  
>>  	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
>>  	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
> 
> This one is not added by the recent changes as I initially thought,
> the driver has always checked this return value. The recent changes
> did this:
> 
>          ret = set_registers(pegasus, EthCtrl0, 3, data);
>   
>          if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
>              usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
>              usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
>                  u16 auxmode;
> -               read_mii_word(pegasus, 0, 0x1b, &auxmode);
> +               ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
> +               if (ret < 0)
> +                       goto fail;
>                  auxmode |= 4;
>                  write_mii_word(pegasus, 0, 0x1b, &auxmode);
>          }
>   
> +       return 0;
> +fail:
> +       netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>          return ret;
> }
> 
> now the return value of set_registeres() is ignored.
> 
> Seems like  a better fix would be to bring back the error checking,
> why not?
> 
> Please remember to add a fixes tag.
> 

Hi, Jakub!

I've suggested to handle this error, but Petko said that device won't 
stop working, it will just get in non-optimal state.

https://lore.kernel.org/lkml/YRF1t5kx6hTrv5LC@carbon/


With regards,
Pavel Skripkin
