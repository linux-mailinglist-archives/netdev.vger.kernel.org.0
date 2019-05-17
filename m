Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A5621CAB
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfEQRke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:40:34 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:40030 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQRke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:40:34 -0400
Received: by mail-pg1-f170.google.com with SMTP id d30so3616281pgm.7
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 10:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f+h7KtrjUufXIT7Cjc42Rx1nLj7O8oysy2iGaOZIGMg=;
        b=qVGAzCf0ZUMIkAPP9VRXdV8lrEjRBCq/3saBnaPiRhA5u3cr7RLTYG/m85Aesd6xTc
         llNoeaRpZFwuLzK5Gejf9K3a6tVeZUiWUnJ7awoi7uHbJWX5EMqYVY3xrkVmwJVuBBbL
         L3RDlFpMGvJeCM7qvhFEfncNatCmYm5L7zlJnvbEZsOgsWAltHc4MG/I6DeGpdUMPGCF
         wGujmgJJ4YrvwRFrxcIEAq/QwnC8FyrV6fAkyG7aWTR89irUCXR1b5IvaB+pyRj9ETe4
         pchyHXRSfypJIijHL1ISA+jYy+9v4Yz+hil1t/c+5CPpKdJWEwGNZoeExhVX+JVC9J40
         VqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f+h7KtrjUufXIT7Cjc42Rx1nLj7O8oysy2iGaOZIGMg=;
        b=KTry0EE6SJVciuFXIfRifa9de5/JBso4Lv8TRi2/edZO3x6wurR++m58AQkfWM/YRZ
         fqW0jUJ0r4Zj881CP6jrxfUPOMVRodHZJtxX+n3v0tb/CgmorvJtIepbz7qBPGau3pk1
         W5/bEvvDncIH9kQ1OMhKPRZiteNr3tapKGRlg0ItA61B8AY3iRgJFHkIHwOOdc9galcm
         Rs5HZLRDJYbV2Vlk27cuQ6EL6QeYiCGXtIbdFnjFu4jhQuxjlnsYMXQbvbOC2L3ybJd1
         govaQJWxCyaIme6JMBoKd9pAgKdbPEk57T7mtUYxu7OTMXw6nhq2V52wXRa5PRbTq9OH
         r3VA==
X-Gm-Message-State: APjAAAVRU4Z/IxypIVtCJIQ675Np3hAMwCUz+qy3+PynJ4dwHjROfGw9
        nD1tozKRFi4b8lqqorGvxK0=
X-Google-Smtp-Source: APXvYqzscOqvEBSqUZyjROqV8TdA5n3vhhDljDwNz+VcIBR3eUOM//q0UKBhbv+bGaK7X5VYo92ncQ==
X-Received: by 2002:a63:8b4b:: with SMTP id j72mr58006853pge.318.1558114833607;
        Fri, 17 May 2019 10:40:33 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:743c:f418:8a94:7ec7? ([2601:282:800:fd80:743c:f418:8a94:7ec7])
        by smtp.googlemail.com with ESMTPSA id j10sm11036111pfa.37.2019.05.17.10.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 10:40:32 -0700 (PDT)
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
Message-ID: <36bbeecd-3df5-bc90-696f-7f03bceda36c@gmail.com>
Date:   Fri, 17 May 2019 11:40:31 -0600
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

oh, and I think changing iproute2 to ignore the /24 and always set to 32
is better than changing the kernel to allow a prefix length that is ignored.

