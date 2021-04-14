Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7688835FC12
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349604AbhDNT5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353602AbhDNT4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:56:32 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71970C061574;
        Wed, 14 Apr 2021 12:56:09 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q123-20020a1c43810000b029012c7d852459so3086428wma.0;
        Wed, 14 Apr 2021 12:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nm1RgrxkH0mrghDJXR+ujr0bhh26nh2PfPQkM5o/W4I=;
        b=mZwCAuK3BeoomTNP0b+KCEndw+VdNfYUkcSa46z0v5ZepKNiRaQeK9GsODMjLLeCLb
         rsbwl83Nnkk//3hNpTakqlN3X5j9ryloKvIHqNP7fPoI2fTPCylRKqJaAl653hA4uiR6
         47uApzliyFe1oFb6i9KUuG264qJ+hoHdf9e62a6+lT+/4bFK3JqbZ+V+9WG6OhNsGkoc
         4bQ0F2oZpXYMApnbHtSbGg43cgNCW4FI/15zPPLYXHBklyToK8XB3nCWLRCzrMGL29wY
         LswB6crEVW4fc7/Wpid9NDZMmznlXZmyMXVuwqZfvJ2qwIw+XGcFyt8+z0Ph1vbtuaz0
         Pchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nm1RgrxkH0mrghDJXR+ujr0bhh26nh2PfPQkM5o/W4I=;
        b=OqwHo7ZNOt1iWZHwTLZyC37mY9jghDD4QrFgRua9BEfWWoIjjC4yIzAjQGxbbxMPh2
         QWSLlkwSRn4ApsAbiTAfiBuiuCFokrS4RXYjvHgf8cwITLYpQD5E78B0w9DKTzQ2EaFi
         p3EKylpF7+/hQehsepFvQzjkGF49vX0gZKBXYCCFtPlmDLlLWaaQz9uEhFx/OPQciiKI
         Mz1ARQdWqxYBALoKEkYwbOTs9gIaBt/xWz+pE4Zw5toxeAIdFLdSy3ZY4m80+GBNnrdw
         gfGhH30cb1EMktjnSEPEnnyRLjVanIO/o9eHytQHoHMNKwRkHv+TZb1r/7gUkD6gR/VN
         tskQ==
X-Gm-Message-State: AOAM531kmzArOmD17P2ODwekrFnQRg7J/vqtQ+SEWFP3TLm+1BqpIpFc
        TgrwRlEUW29ChSG7IMkBbhdTabxoNAI=
X-Google-Smtp-Source: ABdhPJwTJLKx4odMHNisMu8ZhiF62rIbanegdCW3NMLMU8+mFB/pya0eMEbsMNzu6YCA8HLdvBwpxQ==
X-Received: by 2002:a05:600c:4d91:: with SMTP id v17mr4451449wmp.28.1618430168249;
        Wed, 14 Apr 2021 12:56:08 -0700 (PDT)
Received: from [10.8.0.194] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id q10sm301506wmc.31.2021.04.14.12.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 12:56:07 -0700 (PDT)
Subject: Re: netdevice.7 SIOCGIFFLAGS/SIOCSIFFLAGS
To:     Erik Flodin <erik@flodin.me>
Cc:     mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        Stefan Rompf <stefan@loplof.de>,
        "David S. Miller" <davem@davemloft.net>,
        Fredrik Arnerup <fredrik.arnerup@edgeware.tv>,
        John Dykstra <john.dykstra1@gmail.com>,
        Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
        Urs Thuermann <urs.thuermann@volkswagen.de>,
        netdev@vger.kernel.org
References: <CAAMKmof+Y+qrro7Ohd9FSw1bf+-tLMPzaTba-tVniAMY0zwTOQ@mail.gmail.com>
 <b0a534b3-9bdf-868e-1f28-8e32d31013a2@gmail.com>
 <CAAMKmodhSsckMxH9jLKKwXN_B76RoLmDttbq5X9apE-eCo0hag@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <1cde5a72-033e-05e7-be58-b1b2ef95c80f@gmail.com>
Date:   Wed, 14 Apr 2021 21:56:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAAMKmodhSsckMxH9jLKKwXN_B76RoLmDttbq5X9apE-eCo0hag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CC += netdev]

Hi Erik,

On 4/14/21 8:52 PM, Erik Flodin wrote:
> Hi,
> 
> On Fri, 19 Mar 2021 at 20:53, Alejandro Colomar (man-pages)
> <alx.manpages@gmail.com> wrote:
>> On 3/17/21 3:12 PM, Erik Flodin wrote:
>>> The documentation for SIOCGIFFLAGS/SIOCSIFFLAGS in netdevice.7 lists
>>> IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO, but those can't be set in
>>> ifr_flags as it is only a short and the flags start at 1<<16.
>>>
>>> See also https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c
>>>
>>
>> I don't know what's the history of that.
> 
> Judging from commit message in the commit linked above it was added by
> mistake. As noted the flags are accessible via netlink, just not via
> SIOCGIFFLAGS.
> 
> // Erik
> 

I should have CCd netdev@ before.  Thanks for the update.  Let's see if 
anyone there can comment.

Thanks,

Alex


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
