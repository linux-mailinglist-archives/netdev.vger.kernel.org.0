Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0205B0BE7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiIGR6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIGR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:58:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAE4B08A4;
        Wed,  7 Sep 2022 10:58:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gb36so32084501ejc.10;
        Wed, 07 Sep 2022 10:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4xioiLOgMPJ3We5Y6cKXMDxGgXtE1ROJYDQy7bUxt0k=;
        b=gRZDPxf9542mvq2AOJyw0mKjn0nwQuapLL9CLPaGoG4dXGYoR20/koUZF2Nl/u/7vF
         VQwKbQC4UVmdMQeRPgaLQul9bvTCRb4r0dvpdfD5vHFmH5eqoN9NBuCtRCAKA6E8nMuB
         wniOChaRvndh/YjqBI67ZAB2RSCjLuzXdrwDV7YOb4jI8WmnSTGiLmgyiDi7QEVV+mBL
         9+h/gINllJY+RdsKCySU+1SbZQ06+9ehlv6dx81eZ4hOfChnJUpuOBZw11ZCdvwoKPcW
         OXw2IfvRFu/Rj5cFTpqXbzHKdaOnUPrHhXNPZWbqDgsP1cGvkgQyr7caEHgQ4xTl6XvS
         8RFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4xioiLOgMPJ3We5Y6cKXMDxGgXtE1ROJYDQy7bUxt0k=;
        b=N9+Xyvl4Dagjd7S9Z1SebrIX/Yg03YsPyy4/o+gPbnCpDWwAcYIh9rnL7LHVibqrv+
         oLD4NyBJVH5j8GV4ClxFTcrsIyVzli2LeXR42ehNe9tC09hvu+AyGtieT1mASm9FfJfP
         Pq8gYaKnCp84Ul2s0WOPoWA5FSZn11CQDzD2bPEguiMo0XgJNxvIgbHn2mY4f5Zc1l2a
         vtSqCSgj1eRrPkQgLbnaJOivpo9QTwRYQ5e+QrRDfCCAED8vTH/CRpq/o6rhlzt6+7kp
         Bn+gkr6yUVEPfq2x7eXwfjLNldjeJ9q9AFNnKixa5uBvTgLCpQy9eVGFS8mNlj7YlE8h
         gmMg==
X-Gm-Message-State: ACgBeo33rmDgkyD7C/kA7Dqlb+MVjmKwdCySlJamfb6G1uIOM+Tcro7V
        MVp/8VDay98l217lqy1gsZQ=
X-Google-Smtp-Source: AA6agR4udnAIlquIOSv1uLg6eHLVGBwFPQhwCyn4HjSavBmbgemILYWwhQajMrrFoSTdVmM/JpjokA==
X-Received: by 2002:a17:906:4795:b0:73d:d6e8:52a7 with SMTP id cw21-20020a170906479500b0073dd6e852a7mr3018739ejc.59.1662573509821;
        Wed, 07 Sep 2022 10:58:29 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:cbe0:7b37:373:7410? ([2a04:241e:502:a09c:cbe0:7b37:373:7410])
        by smtp.gmail.com with ESMTPSA id f10-20020aa7d84a000000b0043d1eff72b3sm5385254eds.74.2022.09.07.10.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 10:58:29 -0700 (PDT)
Message-ID: <3a38fda6-eeae-8d6c-3eac-112abfc63015@gmail.com>
Date:   Wed, 7 Sep 2022 20:58:27 +0300
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
 <b951b8fb-f2b3-bcbb-8b7f-868b1f78f9bb@gmail.com>
 <CANn89iJ9XGKHV1F1uhKmWqyOdDjiBebo0FOb6SfCxcvE5XzJPQ@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <CANn89iJ9XGKHV1F1uhKmWqyOdDjiBebo0FOb6SfCxcvE5XzJPQ@mail.gmail.com>
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

On 9/7/22 20:04, Eric Dumazet wrote:
> On Wed, Sep 7, 2022 at 9:53 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>> On 9/7/22 02:11, Eric Dumazet wrote:
>>> On Mon, Sep 5, 2022 at 12:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>>>
>>>> This is mainly intended to protect against local privilege escalations
>>>> through a rarely used feature so it is deliberately not namespaced.
>>>>
>>>> Enforcement is only at the setsockopt level, this should be enough to
>>>> ensure that the tcp_authopt_needed static key never turns on.
>>>>
>>>> No effort is made to handle disabling when the feature is already in
>>>> use.
>>>>
>>>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>>>> ---
>>>>    Documentation/networking/ip-sysctl.rst |  6 ++++
>>>>    include/net/tcp_authopt.h              |  1 +
>>>>    net/ipv4/sysctl_net_ipv4.c             | 39 ++++++++++++++++++++++++++
>>>>    net/ipv4/tcp_authopt.c                 | 25 +++++++++++++++++
>>>>    4 files changed, 71 insertions(+)
>>>>
>>>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>>>> index a759872a2883..41be0e69d767 100644
>>>> --- a/Documentation/networking/ip-sysctl.rst
>>>> +++ b/Documentation/networking/ip-sysctl.rst
>>>> @@ -1038,10 +1038,16 @@ tcp_challenge_ack_limit - INTEGER
>>>>           Note that this per netns rate limit can allow some side channel
>>>>           attacks and probably should not be enabled.
>>>>           TCP stack implements per TCP socket limits anyway.
>>>>           Default: INT_MAX (unlimited)
>>>>
>>>> +tcp_authopt - BOOLEAN
>>>> +       Enable the TCP Authentication Option (RFC5925), a replacement for TCP
>>>> +       MD5 Signatures (RFC2835).
>>>> +
>>>> +       Default: 0
>>>> +
>>
>> ...
>>
>>>> +#ifdef CONFIG_TCP_AUTHOPT
>>>> +static int proc_tcp_authopt(struct ctl_table *ctl,
>>>> +                           int write, void *buffer, size_t *lenp,
>>>> +                           loff_t *ppos)
>>>> +{
>>>> +       int val = sysctl_tcp_authopt;
>>>
>>> val = READ_ONCE(sysctl_tcp_authopt);
>>>
>>>> +       struct ctl_table tmp = {
>>>> +               .data = &val,
>>>> +               .mode = ctl->mode,
>>>> +               .maxlen = sizeof(val),
>>>> +               .extra1 = SYSCTL_ZERO,
>>>> +               .extra2 = SYSCTL_ONE,
>>>> +       };
>>>> +       int err;
>>>> +
>>>> +       err = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
>>>> +       if (err)
>>>> +               return err;
>>>> +       if (sysctl_tcp_authopt && !val) {
>>>
>>> READ_ONCE(sysctl_tcp_authopt)
>>>
>>> Note that this test would still be racy, because another cpu might
>>> change sysctl_tcp_authopt right after the read.
>>
>> What meaningful races are possible here? This is a variable that changes
>> from 0 to 1 at most once.
> 
> Two cpus can issue writes of 0 and 1 values at the same time.
> 
> Depending on scheduling writing the 0 can 'win' the race and overwrite
> the value back to 0.
> 
> This is in clear violation of the claim you are making (that the
> sysctl can only go once from 0 to 1)

Not clear why anyone would attempt to write 0, maybe to ensure that it's 
still disabled?

But you're right that userspace CAN do that and the kernel CAN misbehave 
in this scenario so it would be better to just make the changes you 
suggested.

>> In theory if two processes attempt to assign "non-zero" at the same time
>> then one will "win" and the other will get an error but races between
>> userspace writing different values are possible for any sysctl. The
>> solution seems to be "write sysctls from a single place".
>>
>> All the checks are in sockopts - in theory if the sysctl is written on
>> one CPU then a sockopt can still fail on another CPU until caches are
>> flushed. Is this what you're worried about?
>>
>> In theory doing READ_ONCE might incur a slight penalty on sockopt but
>> not noticeable.
> 
> Not at all. There is _no_ penalty using READ_ONCE(). Unless it is done
> in a loop and this prevents some compiler optimization.
> 
> Please use WRITE_ONCE() and READ_ONCE() for all sysctl values used in
> TCP stack (and elsewhere)
> 
> See all the silly patches we had recently.

OK
