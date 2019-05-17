Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A728E21C9F
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfEQRjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:39:09 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:42064 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfEQRjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:39:09 -0400
Received: by mail-pg1-f172.google.com with SMTP id 145so3608006pgg.9
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 10:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D+aN70SgzRALpJpl2VsJZKK09FAd3fwSCUoNgjkW5ao=;
        b=jOeMx09IaIGEKN/kLh3DAAY2p8NaqE8Ou4nfVhewXWtQ3gB2kVwu7i992EaFjxcrUz
         MB+kxEKSRtpfPlM8vq/eO+oos9lKKYEvgiekJV65XZYjUZkB1NdwEPoowWBFRQr3FyVD
         Hzl37tA9wo8nrjHl/a1CAHWohxM5EygireytqJ/a2VZ2RreAD6DSipcVjinS5ocHSv2+
         LpFXBmXCgX8dzE0NMhRdbnkrQVjcGNCitU4tmzCai4etaowTNxq9Vz6WBIn0pYQ2tBsh
         nroUu0Ju2aC9VZHxA54JWystPKTFtvcOl0lF7Bby0iJVZXy85pI/LCBNHbkcePNZK9J4
         zL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D+aN70SgzRALpJpl2VsJZKK09FAd3fwSCUoNgjkW5ao=;
        b=F+pHyeoz0CKMYuiL1DGAYPW2vWUQc5vHJl5Z5+R8zalG10UDh9CfrjpfWAglKoMm7a
         vjDdbwWRqB2s8dZSzRXmfCp96FRBkncfxuumaIFhkE64S0P053XMqo1uPrhE4Ye3DsG8
         b3LkahogY5ImDzGzQhAe9fgOZxI0msGvbzbNmnGMEyIypZSog9DMPqgg7stq44ZXnr56
         Q0/b43pXoeuuIvFeXsMy0s49o4414BHglcoqMK7NQjnWpaxnVQyUZBWRmHP0lg6XUi+h
         Fcj6iYuNrHM1PDxz1V20bH5ohUTyLT/WDCc2HQIHB5MsUDFneYvflvWqW/SuUqJIQegg
         vkAg==
X-Gm-Message-State: APjAAAV+uIt+WJ6rpZO20BBi0wZF8lXwsSzKAXEavbSFQIlpvu+S17YH
        pU09hwFyisXv645Cf3q+SDs=
X-Google-Smtp-Source: APXvYqyoQ9Pq8vzIPQ2jlNYROySCvQn0MCvFl+/O5K1lOZtolr5glQKUSjthDWlixtRlAlwCRpQrMw==
X-Received: by 2002:a62:470e:: with SMTP id u14mr62823663pfa.31.1558114748781;
        Fri, 17 May 2019 10:39:08 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:743c:f418:8a94:7ec7? ([2601:282:800:fd80:743c:f418:8a94:7ec7])
        by smtp.googlemail.com with ESMTPSA id x18sm13509126pfj.17.2019.05.17.10.39.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 10:39:07 -0700 (PDT)
Subject: Re: 5.1 `ip route get addr/cidr` regression
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        emersonbernier@tutanota.com, Netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
References: <LaeckvP--3-1@tutanota.com>
 <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
 <2e6749cb-3a7a-242a-bd60-5fa7a8e724db@gmail.com>
 <20190517103543.149e9c6c@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5c899e85-ab00-f13b-7651-e157d9837505@gmail.com>
Date:   Fri, 17 May 2019 11:39:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190517103543.149e9c6c@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/19 11:35 AM, Stephen Hemminger wrote:
> On Fri, 17 May 2019 09:17:51 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 5/17/19 4:22 AM, Jason A. Donenfeld wrote:
>>> Hi,
>>>
>>> I'm back now and catching up with a lot of things. A few people have
>>> mentioned to me that wg-quick(8), a bash script that makes a bunch of
>>> iproute2 invocations, appears to be broken on 5.1. I've distilled the
>>> behavior change down to the following.
>>>
>>> Behavior on 5.0:
>>>
>>> + ip link add wg0 type dummy
>>> + ip address add 192.168.50.2/24 dev wg0
>>> + ip link set mtu 1420 up dev wg0
>>> + ip route get 192.168.50.0/24
>>> broadcast 192.168.50.0 dev wg0 src 192.168.50.2 uid 0
>>>    cache <local,brd>
>>>
>>> Behavior on 5.1:
>>>
>>> + ip link add wg0 type dummy
>>> + ip address add 192.168.50.2/24 dev wg0
>>> + ip link set mtu 1420 up dev wg0
>>> + ip route get 192.168.50.0/24
>>> RTNETLINK answers: Invalid argument  
>>
>> This is a 5.1 change.
>> a00302b607770 ("net: ipv4: route: perform strict checks also for doit
>> handlers")
>>
>> Basically, the /24 is unexpected. I'll send a patch.
>>
>>>
>>> Upon investigating, I'm not sure that `ip route get` was ever suitable
>>> for getting details on a particular route. So I'll adjust the  
>>
>> 'ip route get <prefix> fibmatch' will show the fib entry.
>>
> 
> If you want to keep the error, the kernel should send additional
> extack as to reason. EINVAL is not user friendly...
> 

The kernel does set an extack for all EINVAL in this code path.

Not sure why Jason is not seeing that. Really odd that he hits the error
AND does not get a message back since it requires an updated ip command
to set the strict checking flag and that command understands extack.
Perhaps no libmnl?
