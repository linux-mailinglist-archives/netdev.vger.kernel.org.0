Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540475B0AAD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiIGQx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiIGQx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:53:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6149F9E8BD;
        Wed,  7 Sep 2022 09:53:57 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s11so20600507edd.13;
        Wed, 07 Sep 2022 09:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3V610gm1iZkrdK8uKspH6SMBZfFujb6vTdaNM/04z9U=;
        b=DqacqtCEw7hTxw9ztRd6mGynnYENhTEh06ufgdb0GYspl7kkA6omBVIJwpKn7biMCq
         UrFNIO0FP1U31xm/t0JUOUEmrsLuGjm9rWgI/HtibMOfcj532Wxpw/KBJBy9aIox6m6C
         wF5+4bFMCurKZoOuqizALHJDEV8x3V0OywNvYgcpUGg1ykuCtabp/cB5MTsqsqFwzdO+
         IOdKdIIsj/lF+EX/aQkFAqdlsUwuIouLRmCmJdXy27+QAZlenw40aCUNT5pOa2s4CojH
         tWCF63DuEFj5PiJ3qvFAbNa/yDxclIcG/ouj/OZxfhPuWcS0BpTmnKqS3MIY8fx6qrCO
         dQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3V610gm1iZkrdK8uKspH6SMBZfFujb6vTdaNM/04z9U=;
        b=W5/0L86aMBHH3YUZ6vuDbzpaJUhR6V2zvKcXciRMYbqGzlu1Kw2jL+9t8YTUXQ8C/A
         s06ly4waBR2Z+HS5vQOlF6YC31wd3dpglCPkJQVFsqRPEWk2ISJWkSV1s38R9OIDQnT9
         yxGKoB9+hs4EByHwIChJi5sMixATz0LTqvTfFC3XPNILvPhpfSb6BS0gnBHqf7DHtQ9L
         FDShTct+Jy6a2qLQj4tM3ABhJCDX8emNSGg1BWLteSpzGK+l/OBumkQgPTP61FFjfUs/
         fCvfyNADVXZjxuljtQgfh9MdSk5ChsxXUNx/1fRPDOS56npyNi5VvosQ2mT4E2Sv/YDy
         4+EQ==
X-Gm-Message-State: ACgBeo2ooTHil934d7v/UZ/GPUiu7geWZk442utUfdWV1Xi5PDIP1P0H
        v5a+p6P0p6MmOZcGaZngk6w=
X-Google-Smtp-Source: AA6agR5U1IrZcU6zVO6V7lUoD5UDzUOoTKDQpgIHOwxzIfHHcJsrkr2CHpViphCwQTHUoSg3QrSZ8g==
X-Received: by 2002:a05:6402:c45:b0:442:c549:8e6b with SMTP id cs5-20020a0564020c4500b00442c5498e6bmr3910306edb.123.1662569635971;
        Wed, 07 Sep 2022 09:53:55 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:3df:1c49:9ca5:8ba3? ([2a04:241e:502:a09c:3df:1c49:9ca5:8ba3])
        by smtp.gmail.com with ESMTPSA id ff23-20020a1709069c1700b0073d645e6dd8sm434391ejc.223.2022.09.07.09.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 09:53:55 -0700 (PDT)
Message-ID: <b951b8fb-f2b3-bcbb-8b7f-868b1f78f9bb@gmail.com>
Date:   Wed, 7 Sep 2022 19:53:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 08/26] tcp: authopt: Disable via sysctl by default
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1662361354.git.cdleonard@gmail.com>
 <298e4e87ce3a822b4217b309438483959082e6bb.1662361354.git.cdleonard@gmail.com>
 <CANn89iKq4rUkCwSSD-35u+Lb8s9u-8t5bj1=aZuQ8+oYwuC-Eg@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <CANn89iKq4rUkCwSSD-35u+Lb8s9u-8t5bj1=aZuQ8+oYwuC-Eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 02:11, Eric Dumazet wrote:
> On Mon, Sep 5, 2022 at 12:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> This is mainly intended to protect against local privilege escalations
>> through a rarely used feature so it is deliberately not namespaced.
>>
>> Enforcement is only at the setsockopt level, this should be enough to
>> ensure that the tcp_authopt_needed static key never turns on.
>>
>> No effort is made to handle disabling when the feature is already in
>> use.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   Documentation/networking/ip-sysctl.rst |  6 ++++
>>   include/net/tcp_authopt.h              |  1 +
>>   net/ipv4/sysctl_net_ipv4.c             | 39 ++++++++++++++++++++++++++
>>   net/ipv4/tcp_authopt.c                 | 25 +++++++++++++++++
>>   4 files changed, 71 insertions(+)
>>
>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index a759872a2883..41be0e69d767 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -1038,10 +1038,16 @@ tcp_challenge_ack_limit - INTEGER
>>          Note that this per netns rate limit can allow some side channel
>>          attacks and probably should not be enabled.
>>          TCP stack implements per TCP socket limits anyway.
>>          Default: INT_MAX (unlimited)
>>
>> +tcp_authopt - BOOLEAN
>> +       Enable the TCP Authentication Option (RFC5925), a replacement for TCP
>> +       MD5 Signatures (RFC2835).
>> +
>> +       Default: 0
>> +

...

>> +#ifdef CONFIG_TCP_AUTHOPT
>> +static int proc_tcp_authopt(struct ctl_table *ctl,
>> +                           int write, void *buffer, size_t *lenp,
>> +                           loff_t *ppos)
>> +{
>> +       int val = sysctl_tcp_authopt;
> 
> val = READ_ONCE(sysctl_tcp_authopt);
> 
>> +       struct ctl_table tmp = {
>> +               .data = &val,
>> +               .mode = ctl->mode,
>> +               .maxlen = sizeof(val),
>> +               .extra1 = SYSCTL_ZERO,
>> +               .extra2 = SYSCTL_ONE,
>> +       };
>> +       int err;
>> +
>> +       err = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
>> +       if (err)
>> +               return err;
>> +       if (sysctl_tcp_authopt && !val) {
> 
> READ_ONCE(sysctl_tcp_authopt)
> 
> Note that this test would still be racy, because another cpu might
> change sysctl_tcp_authopt right after the read.

What meaningful races are possible here? This is a variable that changes 
from 0 to 1 at most once.

In theory if two processes attempt to assign "non-zero" at the same time 
then one will "win" and the other will get an error but races between 
userspace writing different values are possible for any sysctl. The 
solution seems to be "write sysctls from a single place".

All the checks are in sockopts - in theory if the sysctl is written on 
one CPU then a sockopt can still fail on another CPU until caches are 
flushed. Is this what you're worried about?

In theory doing READ_ONCE might incur a slight penalty on sockopt but 
not noticeable.

> 
>> +               net_warn_ratelimited("Enabling TCP Authentication Option is permanent\n");
>> +               return -EINVAL;
>> +       }
>> +       sysctl_tcp_authopt = val;
> 
> WRITE_ONCE(sysctl_tcp_authopt, val),  or even better:
> 
> if (val)
>       cmpxchg(&sysctl_tcp_authopt, 0, val);
> 
>> +       return 0;
>> +}
>> +#endif
>> +

This would be useful if we did any sort of initialization here but we 
don't. Crypto is initialized somewhere completely different.
