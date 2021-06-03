Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2DB39A7D6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhFCRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:52 -0400
Received: from mail-oo1-f50.google.com ([209.85.161.50]:36535 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhFCRMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:12:01 -0400
Received: by mail-oo1-f50.google.com with SMTP id v13-20020a4aa40d0000b02902052145a469so1558044ool.3;
        Thu, 03 Jun 2021 10:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4gDgXCW9PF87cQlj+S2sGArtOzZHua0Ef4NWBjZfBp8=;
        b=PHMbhwUoUlIdd90uzOSD3a9MmwVSTBccB6t6eNzK5FqxtlhbV7oEw8pXloamCZochI
         0iVQTMAymKEJS8nd1P6HbW/UxY5tc8pBJC38RFVNxRl3l5mgyozV4ZKUh+zC1CkkHWLE
         UGR88XxpDckyBlxFoCguQIIzEo8Q1n6ECqHUw5j+RaRWHsKRu3J+pVb+3MqhuG8gx3kP
         tdYf9zWNl28O4V1cDmBrkCVsSbcrHb6JiE7Ptv993RP90m/5aqcE6FYHVSQVm46I9qUi
         7v3LOIaHPoqGromEv3HBf9XkdpIoLQ24GF8T223jeD7qwVs/OO235hS+Ql2y9TQSet6c
         kH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4gDgXCW9PF87cQlj+S2sGArtOzZHua0Ef4NWBjZfBp8=;
        b=oBnXoJEjDDZWfbE6LCM+OYaRHGVxvYvwNwgJrb4nMLWyj0yhlqlR8E8c/8wVcD37Oq
         1+G6ESb8wY1d3SPRXOvbzDMU4t47HoCloDHia4Gi1kNMHSVShNACMOEaOBSVKMAXlP4I
         UWDahrTdEkL0YgH/7fecxSaIojBoXQQQTcJGVJr569WRDb/8p/GWv07iQKcplkFgj/BF
         8au0d8WShRvU+BiGPZKDO2RxxEIALvENL7H54si4R3cAPrTg4v0JjPf3IrVOnR3kGXUB
         jNO3zAO7mmVVdiNL3LI/tZubUWcdry0SCwnrrlcP9veR+7zTxHLMUWhLZUofIjgfYi4u
         PZmw==
X-Gm-Message-State: AOAM531XQUsP+JNy9BJR65aCpABbUhZhJ97Y6a5z7LHesLOVENYyupf6
        biGhYaB9Prj+60gj2Muv3tIh+Xhb9aQ=
X-Google-Smtp-Source: ABdhPJwf3nYbBJkdRP0sibKcsjpPuJiE3tgPoPIsvW5B2riKbI6LBlzzLcMuYvJU9ttk1bozwStfOA==
X-Received: by 2002:a4a:3011:: with SMTP id q17mr212965oof.35.1622740156401;
        Thu, 03 Jun 2021 10:09:16 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id b81sm819676oia.19.2021.06.03.10.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 10:09:15 -0700 (PDT)
Subject: Re: [PATCH] ipv6: parameter p.name is empty
To:     nicolas.dichtel@6wind.com, zhang kai <zhangkaiheb@126.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210603095030.2920-1-zhangkaiheb@126.com>
 <d1085905-215f-fb78-4d68-324bd6e48fdd@6wind.com>
 <dd5b5a62-841c-5a21-7571-78d75e2f2482@gmail.com>
 <3c9bcc89-0ec7-0588-719e-d63b36bef132@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d4d669fa-f876-7395-16a0-5ab4d45fb61e@gmail.com>
Date:   Thu, 3 Jun 2021 11:09:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <3c9bcc89-0ec7-0588-719e-d63b36bef132@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/21 10:29 AM, Nicolas Dichtel wrote:
> Le 03/06/2021 à 17:15, David Ahern a écrit :
>> On 6/3/21 7:33 AM, Nicolas Dichtel wrote:
>>> Le 03/06/2021 à 11:50, zhang kai a écrit :
>>>> so do not check it.
>>>>
>>>> Signed-off-by: zhang kai <zhangkaiheb@126.com>
>>>> ---
>>>>  net/ipv6/addrconf.c | 3 ---
>>>>  1 file changed, 3 deletions(-)
>>>>
>>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>>> index b0ef65eb9..4c6b3fc7e 100644
>>>> --- a/net/ipv6/addrconf.c
>>>> +++ b/net/ipv6/addrconf.c
>>>> @@ -2833,9 +2833,6 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
>>>>  	if (err)
>>>>  		return err;
>>>>  
>>>> -	dev = __dev_get_by_name(net, p.name);
>>>> -	if (!dev)
>>>> -		return -ENOBUFS;
>>>>  	return dev_open(dev, NULL);
>>>>  }
>>>>  
>>>>
>>> This bug seems to exist since the beginning of the SIT driver (24 years!):
>>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=e5afd356a411a
>>> Search addrconf_set_dstaddr()
>>>
>>> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>>
>>
>> A patch was sent yesterday, "sit: set name of device back to struct
>> parms", to set the name field in params.
>>
> Oh yes, it was in my spam folder ...
> 

Really a question for zhang kai about the patches - why both of these.

And from there how did this ever work? addrconf_set_sit_dstaddr should
have been failing for the last 24 years so why fix it vs just ripping it
out.

