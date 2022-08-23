Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900E759EA55
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiHWRlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiHWRku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:40:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463AC74BB4;
        Tue, 23 Aug 2022 08:30:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y3so1798484ejc.1;
        Tue, 23 Aug 2022 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=tgs5ovq6tUDagnrW7AMTAEpEJoB/IqHPngahwtFsDhU=;
        b=eOXQFqcS/0cqPsdYRKkBNKpFlI/KLRMf5DchIMSSJJZAme3NCxrj4c55APwnR7iaSm
         aacBvV2L92DGGHtTmBn/IgFmRoOdeLAqR1miHcUZJsOqlv2aNILuq5Cmg0K4RRIAD/r5
         S2qOi0r46j33lhjS0wP7oknlOnAZIwpjyTsw2xaF5aa1pYJQbcylvb10/9dXtVzKSDYe
         3Q6Sv31/ewSSekycR8cTVTFpUeSEJodjkasRuRyF57ENgwJV6o4CXhMnpyU0+0jEWf3b
         11Vbcc0b1UN2IarG57nZugX2iNK0+G8coPJW0jRzjh/8CfNsNg434F/7G1FoKVgknayt
         BAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tgs5ovq6tUDagnrW7AMTAEpEJoB/IqHPngahwtFsDhU=;
        b=EfZdhhaHEGcNtC1UA5Ly3Do4rlPb7/8ypo01BVoiZSYiQavYbBNoMSP70vGhDAMWoR
         js6UKnqRVb3U2VRi2Pn0/Fg2UovxaAdxR8hVCtzZT2oXujmKrf2VQKGmSZBNU3BsIEx6
         V4dGldve6U2jylCFHAEAJsI6YTpcZfIOOaNC9VmUrSMLQ3zfdUL+LFKVm3zrZI2jEt1g
         aHZC1iiQSzelg63C8semccQoC68qXLLJDkw5R2B7mYbbR/87LuMMbKWPG9PZ01OHh4Pd
         5iTZzKPd07Akywde1Q0+jm5o7FIfGpK+NReTeC48PXBCjkbSeKpMsOZGwNSQsAf+7IVJ
         ptOQ==
X-Gm-Message-State: ACgBeo2CORz3vHeP89bWithXcfCn5DjuVMKCOO43ZNpErm5ymI1MvHsO
        fLos+efToGE3wGQOSLGRYpM=
X-Google-Smtp-Source: AA6agR7TlRMbZ80qduKj/Uiu6DfU9OU9L/znh0nRSBRJD5hTSxlBDk7L4VyGs3zI8Y2g5EuOxYNOhw==
X-Received: by 2002:a17:907:f82:b0:73d:afe4:c89 with SMTP id kb2-20020a1709070f8200b0073dafe40c89mr96879ejc.534.1661268635724;
        Tue, 23 Aug 2022 08:30:35 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa? ([2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa])
        by smtp.gmail.com with ESMTPSA id q13-20020a17090676cd00b0073da4b623e8sm704063ejn.152.2022.08.23.08.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 08:30:35 -0700 (PDT)
Message-ID: <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com>
Date:   Tue, 23 Aug 2022 18:30:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>, David Ahern <dsahern@kernel.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220818170005.747015-1-dima@arista.com>
 <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
 <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
 <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/22 23:35, Dmitry Safonov wrote:
> Hi Leonard, David,
> 
> On 8/22/22 00:51, David Ahern wrote:
>> On 8/21/22 2:34 PM, Leonard Crestez wrote:
>>> On 8/18/22 19:59, Dmitry Safonov wrote:
>>>> This patchset implements the TCP-AO option as described in RFC5925. There
>>>> is a request from industry to move away from TCP-MD5SIG and it seems
>>>> the time
>>>> is right to have a TCP-AO upstreamed. This TCP option is meant to replace
>>>> the TCP MD5 option and address its shortcomings. Specifically, it
>>>> provides
>>>> more secure hashing, key rotation and support for long-lived connections
>>>> (see the summary of TCP-AO advantages over TCP-MD5 in (1.3) of RFC5925).
>>>> The patch series starts with six patches that are not specific to TCP-AO
>>>> but implement a general crypto facility that we thought is useful
>>>> to eliminate code duplication between TCP-MD5SIG and TCP-AO as well as
>>>> other
>>>> crypto users. These six patches are being submitted separately in
>>>> a different patchset [1]. Including them here will show better the gain
>>>> in code sharing. Next are 18 patches that implement the actual TCP-AO
>>>> option,
>>>> followed by patches implementing selftests.
>>>>
>>>> The patch set was written as a collaboration of three authors (in
>>>> alphabetical
>>>> order): Dmitry Safonov, Francesco Ruggeri and Salam Noureddine.
>>>> Additional
>>>> credits should be given to Prasad Koya, who was involved in early
>>>> prototyping
>>>> a few years back. There is also a separate submission done by Leonard
>>>> Crestez
>>>> whom we thank for his efforts getting an implementation of RFC5925
>>>> submitted
>>>> for review upstream [2]. This is an independent implementation that makes
>>>> different design decisions.
>>>
>>> Is this based on something that Arista has had running for a while now
>>> or is a recent new development?
>>>
>>
>> ...
>>
>>> Seeing an entirely distinct unrelated implementation is very unexpected.
>>> What made you do this?
>>>
>>
>> I am curious as well. You are well aware of Leonard's efforts which go
>> back a long time, why go off and do a separate implementation?
> 
> When I started working on this, there was a prototype that was neither
> good for upstream, nor for customers. At the moment Leonard submitted
> his RFC, I was already giving feedback/reviews to local code and
> patches. So, as I was aware of the details of TCP-AO, I started giving
> Leonard feedback and reviews, based on what I've learned from RFC/code.
> I thought whatever code will make it upstream, it can benefit from my
> reviews. Some of my comments were based on a better code I saw locally,
> or a way of improving it that I've suggested to both sides.
> 
> I'm quite happy that Leonard addressed some of my comments (i.e.
> extendable syscalls), I see that it improved his patches.
> On the other hand, some of the comments I've left moved to "known
> limitations" with no foreseeable plan to fix them, while they were
> addressed in local/Arista code.
> 
> And now a little bit more than a year later, it seems that the quality
> of local patches has reached a point where they can be submitted for
> an upstream review. So, please don't misunderstand me, it's not that
> "drop your implementation, take ours" and it's not that we've
> intentionally hidden that we're working on TCP-AO. It's that it is the
> first moment we can make upstream aware of an alternative implementation.
> 
> Personally, I think it's best for opensource community:
> - Arista's implementation is now public
> - there are now at least 4 people that understand RFC5925 and the
>    code/details
> - in a discussion, it will be possible to find what will be the best
>    from both implementations for Linux and come up with better code
> 
> At this particular moment, it seems neither of patch sets is ready to be
> merged "as-is". But it seems that there's enough interest from both
> sides and likely it guarantees that there will be enough effort to make
> something merge-able, that will work for all interested parties.
> 
> As for my part, I'm interested in the best code upstream, regardless who
> is the author. This includes:
> - reusing the existing TCP-MD5 code, rather than copying'n'pasting for
>    TCP-AO with intent to refactor it some day later

I had a requirement to deploy on linux 5.4 so I very deliberately 
avoided touching MD5. I'm not sure there very much duplication anyway.

> - making setsockopt()s and other syscalls extendable
> - cover functionality with selftests

My implementation is tested with a standalone python package, this is a 
design choice which doesn't particularly matter.

> - following RFC5925 in implementation, especially "required" and "must"
>    parts

I'm not convinced that "don't delete current key" needs to be literally 
interpreted as a hard requirement for the linux ABI. Most TCP RFCs don't 
specify any sort of API at all and it would be entirely valid to 
implement BGP-TCP-AO as a single executable with no internally 
documented boundaries.

> I hope that clarifies how and why now there are two patch sets that
> implement the same RFC/functionality.

As far as I can tell the biggest problem is that is quite difficult to 
implement the userspace side of TCP-AO complete with key rollover. Our 
two implementation both claim to support this but through different ABI 
and both require active management from userspace.

I think it would make sense to push key validity times and the key 
selection policy entirely in the kernel so that it can handle key 
rotation/expiration by itself. This way userspace only has to configure 
the keys and doesn't have to touch established connections at all.

My series has a "flags" field on the key struct where it can filter by 
IP, prefix, ifindex and so on. It would be possible to add additional 
flags for making the key only valid between certain times (by wall time).

The kernel could then make key selections itself:
  - send rnextkeyid based on the key with the longest recv lifetime
  - send keyid based on remote rnextkeyid.
    - If not applicable (rnextkeyid not found locally, or for SYN) pick 
based on longest send lifetime.
  - If all keys expire then return an error on write()
  - Solve other ambiguities in a predictable way: if valid times are 
equal then pick the lowest numeric send_id or recv_id.

Explicit key selection from userspace could still be supported but it 
would be optional and most apps wouldn't bother implementing their own 
policy. The biggest advantage is that it would be much easier for 
applications to adopt TCP-AO.

--
Regards,
Leonard
