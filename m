Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83CF59CA1B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiHVUgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiHVUgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:36:00 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD78550B1
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:35:57 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m10-20020a05600c3b0a00b003a603fc3f81so6655330wms.0
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=oe+hCVRY8mVdSXGlr7AoccAGj15sOYXUCL367Mdx7zM=;
        b=N9tHgb9q4+h1OvK/4VnJP3ueGjoRHIMuU0TlRrYHLsngrgSS63UvxMitocg12caVG4
         CmRWPFkwCss4QJF7uUKoqOHwV78qe0Rr3Zx2orVJYR2xt/uR6cJhVDL94RXaM++4uSjC
         IXx43Y3QL8ZK0JDqAXc9pCoNzadxE6lCE/bWACDuvSlQd5VS6GwZQ1QNHF6x1tQpo9xW
         +OQih2eZpz8veAfONgoU/gvPOaacAbWX4NeDBMkXS3iL6q9Mijto1xjxZNqVkEZ7LbVs
         rzZCIN5g8+215DoNCtyQINv8qvTN07P4TsHjH195Ed2RlvQTo2oxNiNZah4UQWyygdI7
         NSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=oe+hCVRY8mVdSXGlr7AoccAGj15sOYXUCL367Mdx7zM=;
        b=Y7vBoHF6LFVUblwWPFPtXA21SPBjPFmPaJU+q9lqHVBa1sWgWvjQw8Ipo+NOCFlCoA
         J+UWxzUR7JpK7xnLerCfLc2yWYDpEHa1VQw7kPOhq798A58LkXF/fmSPuEXqwb6DH44v
         ittH9OwXPF0yJiC/Wq3GxaSeUtuujnx8EGUY0mAO7dcATA9Ic3sCQ5uTxzJHWH0S9kH0
         0FidAE8Wg5o9f6ci/CSw/C+YjK6u5xQVJHGo1ntpaiRn0kLsIWGQViGHC3gClRkoNHDG
         TyEEjN27Z9UDo++pTOGNHCuaEtv6HJs2Q3E0USUoBVt660fdaiHhL2qRywwIG2zVjoaP
         ZdoA==
X-Gm-Message-State: ACgBeo1XopwLIda2GwSzxGOW++6hI8aQSETtx6XK4KQGykCo5YMEYrD2
        k0nbGk3C/3gI90omXEaeuAT5nA==
X-Google-Smtp-Source: AA6agR6F0YoOsnuMT7wA77t8oFLfSs88P9gGeFvJarx2oWNydFKsSLoaLRQDp03Wm9Oi+0YueGBfEw==
X-Received: by 2002:a05:600c:4ec9:b0:3a5:a567:137f with SMTP id g9-20020a05600c4ec900b003a5a567137fmr79715wmq.46.1661200555727;
        Mon, 22 Aug 2022 13:35:55 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm15521971wmb.34.2022.08.22.13.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 13:35:55 -0700 (PDT)
Message-ID: <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
Date:   Mon, 22 Aug 2022 21:35:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
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
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
 <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
 <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leonard, David,

On 8/22/22 00:51, David Ahern wrote:
> On 8/21/22 2:34 PM, Leonard Crestez wrote:
>> On 8/18/22 19:59, Dmitry Safonov wrote:
>>> This patchset implements the TCP-AO option as described in RFC5925. There
>>> is a request from industry to move away from TCP-MD5SIG and it seems
>>> the time
>>> is right to have a TCP-AO upstreamed. This TCP option is meant to replace
>>> the TCP MD5 option and address its shortcomings. Specifically, it
>>> provides
>>> more secure hashing, key rotation and support for long-lived connections
>>> (see the summary of TCP-AO advantages over TCP-MD5 in (1.3) of RFC5925).
>>> The patch series starts with six patches that are not specific to TCP-AO
>>> but implement a general crypto facility that we thought is useful
>>> to eliminate code duplication between TCP-MD5SIG and TCP-AO as well as
>>> other
>>> crypto users. These six patches are being submitted separately in
>>> a different patchset [1]. Including them here will show better the gain
>>> in code sharing. Next are 18 patches that implement the actual TCP-AO
>>> option,
>>> followed by patches implementing selftests.
>>>
>>> The patch set was written as a collaboration of three authors (in
>>> alphabetical
>>> order): Dmitry Safonov, Francesco Ruggeri and Salam Noureddine.
>>> Additional
>>> credits should be given to Prasad Koya, who was involved in early
>>> prototyping
>>> a few years back. There is also a separate submission done by Leonard
>>> Crestez
>>> whom we thank for his efforts getting an implementation of RFC5925
>>> submitted
>>> for review upstream [2]. This is an independent implementation that makes
>>> different design decisions.
>>
>> Is this based on something that Arista has had running for a while now
>> or is a recent new development?
>>
> 
> ...
> 
>> Seeing an entirely distinct unrelated implementation is very unexpected.
>> What made you do this?
>>
> 
> I am curious as well. You are well aware of Leonard's efforts which go
> back a long time, why go off and do a separate implementation?

When I started working on this, there was a prototype that was neither
good for upstream, nor for customers. At the moment Leonard submitted
his RFC, I was already giving feedback/reviews to local code and
patches. So, as I was aware of the details of TCP-AO, I started giving
Leonard feedback and reviews, based on what I've learned from RFC/code.
I thought whatever code will make it upstream, it can benefit from my
reviews. Some of my comments were based on a better code I saw locally,
or a way of improving it that I've suggested to both sides.

I'm quite happy that Leonard addressed some of my comments (i.e.
extendable syscalls), I see that it improved his patches.
On the other hand, some of the comments I've left moved to "known
limitations" with no foreseeable plan to fix them, while they were
addressed in local/Arista code.

And now a little bit more than a year later, it seems that the quality
of local patches has reached a point where they can be submitted for
an upstream review. So, please don't misunderstand me, it's not that
"drop your implementation, take ours" and it's not that we've
intentionally hidden that we're working on TCP-AO. It's that it is the
first moment we can make upstream aware of an alternative implementation.

Personally, I think it's best for opensource community:
- Arista's implementation is now public
- there are now at least 4 people that understand RFC5925 and the
  code/details
- in a discussion, it will be possible to find what will be the best
  from both implementations for Linux and come up with better code

At this particular moment, it seems neither of patch sets is ready to be
merged "as-is". But it seems that there's enough interest from both
sides and likely it guarantees that there will be enough effort to make
something merge-able, that will work for all interested parties.

As for my part, I'm interested in the best code upstream, regardless who
is the author. This includes:
- reusing the existing TCP-MD5 code, rather than copying'n'pasting for
  TCP-AO with intent to refactor it some day later
- making setsockopt()s and other syscalls extendable
- cover functionality with selftests
- following RFC5925 in implementation, especially "required" and "must"
  parts

I hope that clarifies how and why now there are two patch sets that
implement the same RFC/functionality.

Thanks,
          Dmitry
