Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0743133BD1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfFCXSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:18:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46395 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCXSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:18:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id v9so9123830pgr.13
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 16:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EUXhgTEYtGABT/45PYDr+36gG4MeHzs4BYxMsQ4kJbo=;
        b=pu7fe05uneoe3G/NPQClfZM0d626ET/Vktv3UKmgzIZUXEbWQks1CizuG9I8nQql1D
         03doDCBmSmM/yPuWyyHrBmnMu04BIRIHWEDECkfAgA0yZXng+BDYgRYG6Tq52gIa9JSl
         8XIuoKz6jvGHkRyyMteyg+M/Ra6rm16XrSuKw4BmSIWEAGPiC2oZCjLCsOmXxOKpZs9D
         2UwAyE/j32uuMm787NKaoavI7VjJuuDH54ENKmDVfAlTMWdvKjVqTJAX++viqaMsBazl
         62M/SbZWYsk86HIVcfg1SdTbKX4QSSrxxg68kWVZYz1AqXAaKNR3tRUjLAPMBcIfwXlo
         VWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EUXhgTEYtGABT/45PYDr+36gG4MeHzs4BYxMsQ4kJbo=;
        b=hOV8EmWIAMpwuUJWoy/kue7uxvQpOEWxtQshETKO+xc+Nbw3kX5QKYXp8Xq8RU7kt0
         qn+Dl8maSmqskPb+xn7UgdPoCBo+mvbDh/yI8fbSAXj+t7CWNjxiP0jZXYq4b7Goo6NZ
         8rJ57owC6ty0P7ZTNLDGUPwhf0ieKxyEP6K1I69F5barYCTmUhpricGHEi17t4Kuqi9s
         ndwqW+o5vcL4LXPBqtklYYeWqivyrB13RMv+Gh4n60azYglCIVn/ZusF2BusBbUoMB3A
         Zm9PYd/R3e8NiJmP7ZLQOcRvZShlXHY2t/X7GaNxPReiM53ye8P+08zjkwNm1JNBemwY
         7N3Q==
X-Gm-Message-State: APjAAAUhoIQ0uErHmTE3ug1nKXbWEWHOuP2+n75jgxNbnM2RXCOEToDi
        QHfyMxXfC7CHGUbqoh9WKlc=
X-Google-Smtp-Source: APXvYqwKMwQErsTGmJba+xqGC668fbOvoGXho6EieQ/hdXA+wJpDoe1FdW1euKo3YnnkonCbGupY1Q==
X-Received: by 2002:aa7:8b49:: with SMTP id i9mr6844153pfd.74.1559603896315;
        Mon, 03 Jun 2019 16:18:16 -0700 (PDT)
Received: from [172.27.227.197] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j72sm17067482pje.12.2019.06.03.16.18.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 16:18:15 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     Wei Wang <weiwan@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
Date:   Mon, 3 Jun 2019 17:18:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 5:05 PM, Wei Wang wrote:
> On Mon, Jun 3, 2019 at 3:35 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 6/3/19 3:58 PM, Wei Wang wrote:
>>> Hmm... I am still a bit concerned with the ip6_create_rt_rcu() call.
>>> If we have a blackholed nexthop, the lookup code here always tries to
>>> create an rt cache entry for every lookup.
>>> Maybe we could reuse the pcpu cache logic for this? So we only create
>>> new dst cache on the CPU if there is no cache created before.
>>
>> I'll take a look.
>>

BTW, I am only updating ip6_pol_route to use pcpu routes for blackhole
nexthops.

ip6_pol_route_lookup will continue as is. That function does not use
pcpu routes and will stay as is.

