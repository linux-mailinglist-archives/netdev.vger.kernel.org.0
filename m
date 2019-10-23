Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8773CE1E01
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389727AbfJWOV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:21:59 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:39491 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfJWOV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:21:58 -0400
Received: by mail-il1-f195.google.com with SMTP id i12so8540565ils.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 07:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YaG6oZO7D1x+lYzRQQFeA/hHV1zln7giQYUkA/ta9i4=;
        b=UxWCxJrTYW/bMCScTVpj6ZsCM4ugePGqlNUsT6oi6Bh6GCxnbmvHIRd/Zu5FVGn0CZ
         Z/aLZvwlVdpU+D+ydPceF+EXn0L2GaxEAF+0o5D/voaSUHBM5Amdx8+Zebb4G8qpDDIy
         Pn27FKBnbM9HWhKNUGme7X3KYZ0Y6NDq/AedEoGmHldTd61khr9fmhAaR2aJobtpx61a
         +sCjnMewVG33MQdOP4jIlci716yA+wDJdfDP+Csxgn4c+gXEylsBz9yjvVfxGjSVtA1T
         4im1l90T/zyJHn7itkox/ZYNG9iz5mY/+11L7tQK7vNV72jeRImcmOLzHkyRyAwhh8jf
         ajCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YaG6oZO7D1x+lYzRQQFeA/hHV1zln7giQYUkA/ta9i4=;
        b=P5StTDHEaO3P/+HRbZaVZ0e1hb9ayNn0R7wxR68/vPgfW3c2lfrMdRGVju4UOK6z7I
         dYpIYvoYZ+GxSYoNuhiGz4AnchA0Wq4kGzjVUL143cNuxKPNT1QkQ1+43pQe1inUrsdH
         Dak1tHO9BfOY/HSA8rDt6bI//tfMt+aCzr0ki2PihV9R6yWQyi00gRKeFxpAGRxpR/cY
         ti0pDS4rh0lViRMFDHtFesJGNGtLHkQdd2eHVgwRTBIUzgGHfFlbSlV7/TK347j0gweS
         xONfTTkHtpIL608hk903mrs5e06DqxSmmSFC6M0jXRjPeiQo5ZGpo8YJInzxZH7hYO9x
         CUpA==
X-Gm-Message-State: APjAAAVkeoRfeTTFgFNhtsAYExcIryWJROyGorP4fL+tMtA0oNVot6eS
        7398kwP6KhsI2pTEtVvPNdkp9A==
X-Google-Smtp-Source: APXvYqxTdIX7+YdBH0zKp16AgAY8urpotkx/RGjsEFrJuGSs1p3sozprY4mHzeYEgIbMYdITvtHUpA==
X-Received: by 2002:a92:d38b:: with SMTP id o11mr23460626ilo.20.1571840514384;
        Wed, 23 Oct 2019 07:21:54 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id w75sm4629201ill.78.2019.10.23.07.21.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 07:21:52 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
Date:   Wed, 23 Oct 2019 10:21:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbf7e4vy5nq.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-23 9:04 a.m., Vlad Buslov wrote:
> 
> On Wed 23 Oct 2019 at 15:49, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> Hi Vlad,
>>

>> I understand your use case being different since it is for h/w
>> offload. If you have time can you test with batching many actions
>> and seeing the before/after improvement?
> 
> Will do.

Thanks.

I think you may have published number before, but would be interesting
to see the before and after of adding the action first and measuring the
filter improvement without caring about the allocator.

> 
>>
>> Note: even for h/w offload it makes sense to first create the actions
>> then bind to filters (in my world thats what we end up doing).
>> If we can improve the first phase it is a win for both s/w and hw use
>> cases.
>>
>> Question:
>> Given TCA_ACT_FLAGS_FAST_INIT is common to all actions would it make
>> sense to use Could you have used a TLV in the namespace of TCA_ACT_MAX
>> (outer TLV)? You will have to pass a param to ->init().
> 
> It is not common for all actions. I omitted modifying actions that are
> not offloaded and some actions don't user percpu allocator at all
> (pedit, for example) and have no use for this flag at the moment.

pedit just never got updated (its simple to update). There is
value in the software to have _all_ the actions use per cpu stats.
It improves fast path performance.

Jiri complains constantly about all these new per-action TLVs
which are generic. He promised to "fix it all" someday. Jiri i notice
your ack here, what happened? ;->

cheers,
jamal
