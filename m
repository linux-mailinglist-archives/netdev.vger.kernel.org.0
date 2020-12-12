Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F362D8A34
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408024AbgLLVor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLLVor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 16:44:47 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98559C0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 13:44:06 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id f14so4137139pju.4
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 13:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KVcXZU7ZwVfc4FqSutE2u2K/Z0c65rWjg1GbHG1SB7M=;
        b=CON5Nm11G8MC/3/OXa+4sSM+CX14Tzk3Yop/OuGX6Rt4Rx5GgYlvAQvRijWKP0Xw8e
         OYvi7MJoQ2Ndh1d9jHLxBUH6pJP2nF9VpoQTrYvj7W+SyVtpoSrh5T6bFu9nfxAYVEcu
         lrBdyoV3jmWV6elT1pma/7jGDOu7rpHqq8sBuhnqLWEVsU11u2UndeZqoGBP7c+C+BVy
         fB2hA+66NwaA2O6v+a7N3zI0kfBdfLFMAXA8hz7tA+g6Uq4MdrZfQj1kRe4RcsSNIRcJ
         OFde/LiNccySwceIVTN5rd/UiZu9xNkuurvryTaEtHuKX7hmwTdANa6YY0Z8V+SmqC4r
         Uwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KVcXZU7ZwVfc4FqSutE2u2K/Z0c65rWjg1GbHG1SB7M=;
        b=kQH9UupEuwVbNRHnIw0W5904nueXRR9qW+pIKJz2u24b0uwiw6NC5aSufQQcbPqE3+
         lWq1XPDqYyzsrvPhiJyh91X1E5Stm8jsS6YLiT4rVxNOUljK/+PcnOkodK57l52NzkKw
         IEW8m/ji4vf6hcxWkOpIGEHJvB0vozlhtJ3XgExNRnJo5/y4lGDp4qMyxFhk8Nmer7+I
         FUl/aEJRzqDStJYywP7HuyDFsMe2ETzsTVtykIT+iknBdjPAhwMpnZT5o/9gCieixQpA
         M/LF+px+SWFWH31ugk3o+yi7L7vyaccRcZqtS/dCAZkW1+ncTSeK0l5QafIy6YifrOpu
         QMVQ==
X-Gm-Message-State: AOAM5338g90Xc6cemUSC/oMESOGC1/N+c0IUtaXVL+e8Fcww2W31+nQX
        IZAPDCu47bg0CUPx0k5N25P9Aw==
X-Google-Smtp-Source: ABdhPJwCG07PGrGRSAu5lE0IYuMFHq844P7X+pE6pqwJUf/KaH5FhCEHyCNsque+g+YeotW/AEBu8Q==
X-Received: by 2002:a17:902:a9c7:b029:d6:da66:253c with SMTP id b7-20020a170902a9c7b02900d6da66253cmr16635521plr.19.1607809446053;
        Sat, 12 Dec 2020 13:44:06 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id na6sm13218454pjb.12.2020.12.12.13.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 13:44:05 -0800 (PST)
Subject: Re: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jann Horn <jannh@google.com>
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
 <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk>
 <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
 <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk>
 <CAM1kxwgX5MsOoJfnCFMnkAqCJr8m34XC2Pw1bpGmrdnUFPhY9Q@mail.gmail.com>
 <bfc41aef-d09b-7e94-ed50-34ec3de6163d@kernel.dk>
 <CAM1kxwi-P1aVrO9PKj87osvsS4a9PH=hSM+ZJ2mLKJckNeHOWQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <37ccec74-8a7c-b5c6-c11f-aaa9e7113461@kernel.dk>
Date:   Sat, 12 Dec 2020 14:44:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwi-P1aVrO9PKj87osvsS4a9PH=hSM+ZJ2mLKJckNeHOWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/20 2:42 PM, Victor Stewart wrote:
> On Sat, Dec 12, 2020 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 12/12/20 10:58 AM, Victor Stewart wrote:
>>> On Sat, Dec 12, 2020 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 12/12/20 10:25 AM, Victor Stewart wrote:
>>>>> On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 12/12/20 8:31 AM, Victor Stewart wrote:
>>>>>>> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
>>>>>>> cmsgs" thread...
>>>>>>>
>>>>>>> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
>>>>>>>
>>>>>>> here are the patches we discussed.
>>>>>>>
>>>>>>> Victor Stewart (3):
>>>>>>>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
>>>>>>>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
>>>>>>>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
>>>>>>>
>>>>>>>    net/ipv4/af_inet.c
>>>>>>>      |   1 +
>>>>>>>    net/ipv6/af_inet6.c
>>>>>>>     |   1 +
>>>>>>>    net/socket.c
>>>>>>>        |   8 +-
>>>>>>>    3 files changed, 7 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> Changes look fine to me, but a few comments:
>>>>>>
>>>>>> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
>>>>>>   could actually be used.
>>>>>
>>>>> right that makes sense.
>>>>>
>>>>>>
>>>>>> - For adding it to af_inet/af_inet6, you should write a better commit message
>>>>>>   on the reasoning for the change. Right now it just describes what the
>>>>>>   patch does (which is obvious from the change), not WHY it's done. Really
>>>>>>   goes for current 1/3 as well, commit messages need to be better in
>>>>>>   general.
>>>>>>
>>>>>
>>>>> okay thanks Jens. i would have reiterated the intention but assumed it
>>>>> were implicit given I linked the initial conversation about enabling
>>>>> UDP_SEGMENT (GSO) and UDP_GRO through io_uring.
>>>>>
>>>>>> I'd also CC Jann Horn on the series, he's the one that found an issue there
>>>>>> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.
>>>>>
>>>>> I CCed him on this reply. Soheil at the end of the first exchange
>>>>> thread said he audited the UDP paths and believed this to be safe.
>>>>>
>>>>> how/should I resubmit the patch with a proper intention explanation in
>>>>> the meta and reorder the patches? my first patch and all lol.
>>>>
>>>> Just post is as a v2 with the change noted in the cover letter. I'd also
>>>> ensure that it threads properly, right now it's just coming through as 4
>>>> separate emails at my end. If you're using git send-email, make sure you
>>>> add --thread to the arguments.
>>>
>>> oh i didn't know about git send-email. i was manually constructing /
>>> sending them lol. thanks!
>>
>> I'd recommend it, makes sure your mailer doesn't mangle anything either. FWIW,
>> this is what I do:
>>
>> git format-patch sha1..sha2
>> mv 00*.patch /tmp/x
>>
>> git send-email --no-signed-off-by-cc --thread --compose  --to linux-fsdevel@vger.kernel.org --cc torvalds@linux-foundation.org --cc viro@zeniv.linux.org.uk /tmp/x
>>
>> (from a series I just sent out). And then I have the following section in
>> ~/.gitconfig:
>>
>> [sendemail]
>> from = Jens Axboe <axboe@kernel.dk>
>> smtpserver = smtp.gmail.com
>> smtpuser = axboe@kernel.dk
>> smtpencryption = tls
>> smtppass = hunter2
>> smtpserverport = 587
>>
>> for using gmail to send them out.
>>
>> --compose will fire up your editor to construct the cover letter, and
>> when you're happy with it, save+exit and git send-email will ask whether
>> to proceed or abort.
>>
>> That's about all there is to it, and provides a consistent way to send out
>> patch series.
> 
> awesome thanks! i'll be using this workflow from now on.
> 
> P.S. hope thats not your real password LOL

Haha it's not, google hunter2 and password and you'll see :-)

-- 
Jens Axboe

