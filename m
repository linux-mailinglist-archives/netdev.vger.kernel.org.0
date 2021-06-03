Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB99D39A5BB
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFCQba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhFCQb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:31:29 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A09C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 09:29:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a11so4601615wrt.13
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 09:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K+QHPJyxgFtSkUCGSgJqOFgm6FpUIz56+9nBPBUsUEg=;
        b=jrxb2FlwDG/i8AKw6RpFmaEfeOx9YUTwfUFSiQ4iWtld/eleR/4kNImnbY6u4az9eN
         w4S2jedBZmVtCZZUS/H8UI3FKIlp03DaIKsrUCHezoPZ+R2L+DF5N4BSnZ5bTCSaUjHm
         vHdjoKo8Vqb7j+9des44Xc7Fk6gQyuE+6tWpaSdzzGLFxX8Kmd4BA+gSbxEfKCe7ZXbl
         YIxUgU1f/s+scWtXGq78MTvVn85+vbmgGhdNsMr5tWFR6QAAYE1wB8S77Z0kzWM06QY9
         Z3JnZquMxLDM5EPxTUTSqWds9+8u4fyL3O51kUtchfBijn+DQHibXLcCI3PTl7gy3IDj
         6l3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=K+QHPJyxgFtSkUCGSgJqOFgm6FpUIz56+9nBPBUsUEg=;
        b=inr89ouA06WYXQGug51wCJiE7IXCNzaa27Lc0gxv76YJtnmyx71Ua9uOAI1ODh5t1w
         64+f+PIoST+bFzwChIRTvNNnIBh2gdF+EGoRRii+TwMBfshLnDJHq5JR2Q0izKSnKyGV
         jHgrbjwWJGwgBNFH6HMYnpF8Z95F0mT1Passx7rCLJ02BfCF9mlrnk7XFHDnNUs8WBJ3
         7m55RKnh4SuTJydHUQA+JVGqptP4zsO6VyILdDHOceXnAGBJMCa5ptdE3AVtWZEUQQpg
         mn530ZGoOhUMwKlXpylDF0POdE3U2IglysmOoTuU6SN1GzNtB24WSqODZrHn2MAxXsGG
         VQbw==
X-Gm-Message-State: AOAM531xeQzdvXpvIKo+zw1IjxZAZS+7LiIegOkKR3AfPiErWzmE1QJd
        O8ASM0Rhx6HZgBEfHLDP7KE8DKe9qw7I4A==
X-Google-Smtp-Source: ABdhPJykYa2Y4bt1Toern5/jC3uH/816oweS2/xMvzt6oR95Dnctt5ePG2a5RtHx9YrjGceak28Vmg==
X-Received: by 2002:a5d:5049:: with SMTP id h9mr764620wrt.221.1622737782147;
        Thu, 03 Jun 2021 09:29:42 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:104d:bd76:408:a323? ([2a01:e0a:410:bb00:104d:bd76:408:a323])
        by smtp.gmail.com with ESMTPSA id n9sm4512223wrt.81.2021.06.03.09.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 09:29:41 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] ipv6: parameter p.name is empty
To:     David Ahern <dsahern@gmail.com>, zhang kai <zhangkaiheb@126.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210603095030.2920-1-zhangkaiheb@126.com>
 <d1085905-215f-fb78-4d68-324bd6e48fdd@6wind.com>
 <dd5b5a62-841c-5a21-7571-78d75e2f2482@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <3c9bcc89-0ec7-0588-719e-d63b36bef132@6wind.com>
Date:   Thu, 3 Jun 2021 18:29:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <dd5b5a62-841c-5a21-7571-78d75e2f2482@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/06/2021 à 17:15, David Ahern a écrit :
> On 6/3/21 7:33 AM, Nicolas Dichtel wrote:
>> Le 03/06/2021 à 11:50, zhang kai a écrit :
>>> so do not check it.
>>>
>>> Signed-off-by: zhang kai <zhangkaiheb@126.com>
>>> ---
>>>  net/ipv6/addrconf.c | 3 ---
>>>  1 file changed, 3 deletions(-)
>>>
>>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>>> index b0ef65eb9..4c6b3fc7e 100644
>>> --- a/net/ipv6/addrconf.c
>>> +++ b/net/ipv6/addrconf.c
>>> @@ -2833,9 +2833,6 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
>>>  	if (err)
>>>  		return err;
>>>  
>>> -	dev = __dev_get_by_name(net, p.name);
>>> -	if (!dev)
>>> -		return -ENOBUFS;
>>>  	return dev_open(dev, NULL);
>>>  }
>>>  
>>>
>> This bug seems to exist since the beginning of the SIT driver (24 years!):
>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=e5afd356a411a
>> Search addrconf_set_dstaddr()
>>
>> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
> 
> A patch was sent yesterday, "sit: set name of device back to struct
> parms", to set the name field in params.
> 
Oh yes, it was in my spam folder ...
