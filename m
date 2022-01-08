Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C664883AE
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 14:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiAHNLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 08:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiAHNLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 08:11:36 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C929CC061574;
        Sat,  8 Jan 2022 05:11:35 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id k21so26067226lfu.0;
        Sat, 08 Jan 2022 05:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=kCLvlZOKOeqEWjawtn0rwOu30fJZTfsrbsPV7XPblGc=;
        b=ZXKGT4befzoPiAFj+ki30NGTZ9HZ0ndd+gFAYWJzKIlUMjFI9ZARuqtt0XhqaTCLW+
         wmPEDxDLvGLVBreFICSrJrtGEKd5hf155gWaPRYUytijzmX0qcUB69G6Ds8Im1L/rVPs
         ku1dETta0u8bU2zmGJ1Vgyhq3W+yj76fn/J7y5z0AbjQ5/qqka6Df3/bC64ZWUbSr5pZ
         XYP5SfGNraiy6fPyDL9fsuLu5iurIuH+BJIB/1q21PxIba+vHVniAkBLZzYkyC/vlHaw
         ZxVwQb2+uOUy7emcyT3aqtvQNpCVxp3gJJEj0BJAxboKumyIPvqT/FcKEfvaHNo9OkdR
         t7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kCLvlZOKOeqEWjawtn0rwOu30fJZTfsrbsPV7XPblGc=;
        b=PDqOV0iavNmVV7/GJkV9LclH2Qc8TJpmotGFdKqB4BNZJcl4hKCO/SaR6M0rDr31XB
         Vcv1pOmEe+GJ8ysxQer2vYhsOAZMfr0xoErPj8Q37bPLbkv/AmC23sQtvllq3HHwTEVu
         s30TPQ7yTjLxD++Id1FPgFDJLF7G3vJ/i3aGeX27HUsYgPRrBWdxMxCYONUYcyq+yuCd
         C1GkmlXhcxq+afolRRBchT3b/2/zQlxIIN/MgljQhWoVXyHwB/Xm9ASbky62Tz64zqAs
         IPN87PZPeHIgZGSODwhOLzMVUuQiH5kSBImuZyVXi7RRunoiJ4uFAjCZTR/+o8X6f3k/
         9wHg==
X-Gm-Message-State: AOAM530VfKH08BWD5Wz6uRYn8JaRhpUFNUgrEdTjwKoQxl7+Y7tGiwMy
        YECUOKNgl+apPXjV0+fPGbEsgkff6Ro7VA==
X-Google-Smtp-Source: ABdhPJwNMcW+2eCOjWULKMq8QQHMHzk+AZsTEsUZC71PqfU3s59nopCfaoVos3EqzuuQRoTFa5ho7w==
X-Received: by 2002:ac2:4a78:: with SMTP id q24mr58789421lfp.464.1641647493858;
        Sat, 08 Jan 2022 05:11:33 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.67])
        by smtp.gmail.com with ESMTPSA id x14sm212524ljd.76.2022.01.08.05.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 05:11:33 -0800 (PST)
Message-ID: <3b9356e7-2eb9-8a86-cfb8-8667c1996b54@gmail.com>
Date:   Sat, 8 Jan 2022 16:11:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH -next] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Stefan Schmidt <stefan@datenfreihafen.org>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220105144947.12540-1-paskripkin@gmail.com>
 <2439d9ab-133f-0338-24f9-a9a5cd2065a3@datenfreihafen.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <2439d9ab-133f-0338-24f9-a9a5cd2065a3@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On 1/7/22 16:46, Stefan Schmidt wrote:
> 
> Hello.
> 
> On 05.01.22 15:49, Pavel Skripkin wrote:
>> @@ -176,9 +105,13 @@ static int atusb_read_subreg(struct atusb *lp,
>>   			     unsigned int addr, unsigned int mask,
>>   			     unsigned int shift)
>>   {
>> -	int rc;
>> +	int rc, ret;
>> +
>> +	ret = usb_control_msg_recv(lp->usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
> 
> You are changing the meaning of the rc variable away from a return code.
> Its the register value now. I would prefer if we change the name to
> something like reg to reflect this new meaning.
> 

Ack. Will fix in v2.

>> +				   0, addr, &rc, 1, 1000, GFP_KERNEL);
>> +	if (ret < 0)
>> +		return ret;
>>   
>> -	rc = atusb_read_reg(lp, addr);
>>   	rc = (rc & mask) >> shift;
>>   
>>   	return rc;
> 
> The change above and the bug fix I reported the other day is all that is
> missing for this to be applied. You want to send a v2 with this changes
> or do you prefer me doing them here locally and apply?
> 

I am going to send v2 soon. Thank you for review!




With regards,
Pavel Skripkin
