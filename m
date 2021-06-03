Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8239A437
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhFCPRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhFCPRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:17:22 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCAEC061756;
        Thu,  3 Jun 2021 08:15:29 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id x196so6196813oif.10;
        Thu, 03 Jun 2021 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7v66XhuZWrG8DKs0DmAQ+sD7453YhN/0jRM3VEpgNbs=;
        b=A5XNHd1U5uUtlenn3okEPwadIdqiAJJh/q97lMxU1ChLK0BMpzpkFdSkWYcxbhGpc0
         +A0DAQgt9VXmWI+/9ww2qR/h20TePwKRir1H/qOKvSyRBMkd7b7UDPnhSSLVVMBZ+FU3
         q8F1h2kj20SYVgqBIUOPjIkyt0fbcMQIEL6KEo2jTbLfLJX3v4pEnIZyPiZFFqR/qN+a
         dGx+lob6cB30Homjl1PT38IKCGtJkNeW4knOXwHqiJvk+6NVQVUeP76FBM/d5lkvqa64
         eQp9c47SZmRwkFXup3Wv8Hra7Ih6ZyO8xfl9UOVUEuaGG3iHVxwBT5HEairg+BQntstw
         +Uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7v66XhuZWrG8DKs0DmAQ+sD7453YhN/0jRM3VEpgNbs=;
        b=Q+uOgjfjjcRPPa8Ya5FQtwwmqZnx1Wpzg4WerdG5twlyXyJsqCdgtOS+C6f/EO9b1K
         eIY3BRhamSxH0hMvNYnMR4Nagwnk/Sb0FEn8fJF0YWCqJknvHbsT5eUAYcwPCii7u12s
         E2RZw3i5K0DM0DIj7bx6eEOjaquMLVpyAqngctFYL1Ehd/H0XMnQMd+ovLeUsi/RZawk
         NDKzEjQAUc4O9qrnDyJzegLx46WBmnnssMNYx0FUGT7194jai1cnwNolTTHOXh0uzSU6
         K6fwrMwOAMbC2hAUZp0564EDm/uKh+ThhrD/utjD+aszg62L29ndg3G1Kk2gWlac2nFw
         1NXA==
X-Gm-Message-State: AOAM532QMDpskQwUcMQqfCYG5UeblrhxrkHaIq0NxIkUoDR5qKh6ZdVF
        iRRXkVknLb7TLFVV15kXRet1rZvzqIs=
X-Google-Smtp-Source: ABdhPJy/g8zxRTE76lf8ZruWGdj5WOhFV6iZ8Y2xowCRo7rddjKqgwh1Ejrdn5IU++fVbCrXyAeUkQ==
X-Received: by 2002:aca:b107:: with SMTP id a7mr7601143oif.170.1622733328983;
        Thu, 03 Jun 2021 08:15:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id p5sm748043oip.35.2021.06.03.08.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 08:15:28 -0700 (PDT)
Subject: Re: [PATCH] ipv6: parameter p.name is empty
To:     nicolas.dichtel@6wind.com, zhang kai <zhangkaiheb@126.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210603095030.2920-1-zhangkaiheb@126.com>
 <d1085905-215f-fb78-4d68-324bd6e48fdd@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd5b5a62-841c-5a21-7571-78d75e2f2482@gmail.com>
Date:   Thu, 3 Jun 2021 09:15:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <d1085905-215f-fb78-4d68-324bd6e48fdd@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/21 7:33 AM, Nicolas Dichtel wrote:
> Le 03/06/2021 à 11:50, zhang kai a écrit :
>> so do not check it.
>>
>> Signed-off-by: zhang kai <zhangkaiheb@126.com>
>> ---
>>  net/ipv6/addrconf.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index b0ef65eb9..4c6b3fc7e 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -2833,9 +2833,6 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
>>  	if (err)
>>  		return err;
>>  
>> -	dev = __dev_get_by_name(net, p.name);
>> -	if (!dev)
>> -		return -ENOBUFS;
>>  	return dev_open(dev, NULL);
>>  }
>>  
>>
> This bug seems to exist since the beginning of the SIT driver (24 years!):
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=e5afd356a411a
> Search addrconf_set_dstaddr()
> 
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 

A patch was sent yesterday, "sit: set name of device back to struct
parms", to set the name field in params.
