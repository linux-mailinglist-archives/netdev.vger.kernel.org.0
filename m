Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F60D582266
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiG0ItT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiG0ItS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:49:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3405220CD;
        Wed, 27 Jul 2022 01:49:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id oy13so30310033ejb.1;
        Wed, 27 Jul 2022 01:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d1lY+SbefORY1alUO5Ruoz9a82JcM7Nf8lJvnE9N4/c=;
        b=OsRc2rKX4EZLzYrOOOwTb9hpk8Nplbpn5nOxGy5pzMQ7lLi/uDWWL3/IN3NB7JVlco
         g/31tT6WzBZ/zZx5r3wO+xvUzuoiQkJFzEh2aLPIFjPQ8P24dHTPrGhpiIwvMIviola2
         ZRWfYY4tQtlc2rvmjFHknsn0lnznuRl74ZeJ28EX59ssAwg+1G3eJUSkyeHp8wuwrKUL
         BQMleBAJfNn6HH4e6GaOOzHLn3FYyvS319+/aVqCYpmWOQRgX4VBk6mneFHw0/qAMUnp
         NuINY19JKHnEJMAFEilsKWrAvRLSl7litgjIvPlpk1Nba/8APkdwjhdQ22GOjhwIRgxX
         ojew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d1lY+SbefORY1alUO5Ruoz9a82JcM7Nf8lJvnE9N4/c=;
        b=2JidxEgHiuejVl0nLBdhePtrH6zM7yh2d013Gmj4csAeqCbfSx86/UwOdYBoMXMLXb
         qjL/reYMCKdGF0Ya90s0RVLbZP2FIoodi3ER2u+dVf1qFZp9cI4JZ+qtYZe28jnPZr7y
         JnPkJIJF2WVzkgDJyEjGjLX/5g3v5TcauYQRvZKMHddcU9cz+f79KvzbHMGg8J1/aY20
         vcI6LzVsdeyOQxGNHnOJYFL3/ytTMzPmeFPG09iuBy9kjhIZVu/HEeZsDFrq6lZTHXKu
         NZOXghyIip+Ksl/JAwhFdh890i2+daPwnwuh5WJRuFDeIXnSj7ZipmNg6oDivhI0h3sH
         bzPg==
X-Gm-Message-State: AJIora8lX/efq4BUqQF9L5KgReSvQmUrpcsZ2llX/wBPSIIeEbOBPSIN
        uAnFjGblLnzZz6Lse3o03N0=
X-Google-Smtp-Source: AGRyM1uWpUx1FgjuBQNIMqcaqrzHL/wqJikJ3HOaiWwuoYUf1yR2fbDipYNhXfnD7h1UUVwuqv/XIw==
X-Received: by 2002:a17:907:948e:b0:72f:b536:57 with SMTP id dm14-20020a170907948e00b0072fb5360057mr16005650ejc.491.1658911756389;
        Wed, 27 Jul 2022 01:49:16 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:994d:5eac:a62d:7a76? ([2a04:241e:502:a09c:994d:5eac:a62d:7a76])
        by smtp.gmail.com with ESMTPSA id kz22-20020a17090777d600b0072b16a57cdcsm7327975ejc.118.2022.07.27.01.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 01:49:15 -0700 (PDT)
Message-ID: <4a8ddb5b-e7bf-5a7d-48dc-72f62771c79e@gmail.com>
Date:   Wed, 27 Jul 2022 11:49:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v6 02/26] tcp: authopt: Remove more unused noops
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philip Paeps <philip@trouble.is>
References: <cover.1658815925.git.cdleonard@gmail.com>
 <2e9007e2f536ef2b8e3dfdaa1dd44dcc6bfc125f.1658815925.git.cdleonard@gmail.com>
 <40928cfc-150c-8714-bb83-21d325ce93e5@kernel.org>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <40928cfc-150c-8714-bb83-21d325ce93e5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:17, David Ahern wrote:
> On 7/26/22 12:15 AM, Leonard Crestez wrote:
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   include/net/tcp_authopt.h | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
>> index adf325c260d5..bc2cff82830d 100644
>> --- a/include/net/tcp_authopt.h
>> +++ b/include/net/tcp_authopt.h
>> @@ -60,14 +60,10 @@ DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
>>   void tcp_authopt_clear(struct sock *sk);
>>   int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
>>   int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
>>   int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
>>   #else
>> -static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
>> -{
>> -	return -ENOPROTOOPT;
>> -}
>>   static inline void tcp_authopt_clear(struct sock *sk)
>>   {
>>   }
>>   #endif
>>   
> added in the previous patch, so this one should be folded into patch 1
Yes this was intended for squashing but missed somehow; sorry!

--
Regards,
Leonard
