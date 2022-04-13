Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB344FECE4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiDMC3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiDMC3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:29:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4020F275E3
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:27:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso4887642pju.1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1s1HFgg8QVHrb/Hccp9XF+cDeXDwelcz+AFMbhk+H1o=;
        b=wOIFJqDOrkkePx4onSw0xPy3YwoU1JSwIqXRHblOGf4p1jjbtDqRHMkTosEUv0ScVV
         9Snfn34MxY3Y05AL/Oe4P6hY3WmD9/rFocyZxzvQI7nH/SOcGsqk02Kp6OosUwTtYqKq
         Cug+E0KRzuBRZ25cEalvaXWolsCrlPuBfRNVHi4LOmVAZk6eCmkcwC0WS8BGezhRx9Cw
         05z7C15ET7KHa1eNqhlpCzDxQJZOZ/VIzgfOpB0hvHmaP0NfF2ea4+EyDDoFxfuQEYg2
         /ABJAjHJMlWX4kK+NF1MJD7hd5mu5S2gWHSSU+UGhULG0BHsyYjjvhr8wQCp9gXAyOcH
         LONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1s1HFgg8QVHrb/Hccp9XF+cDeXDwelcz+AFMbhk+H1o=;
        b=JMWTk7bNZ+xI0tWedA03bmMFW4PRh5n4xaobBiMGCAoW7jGoJ/G17TRuHgPMWAB+so
         3IM/FcF3JrsgUxIc+yxOB/iMgU3QAh5QFjAETZ8LNKkWMPp6U7t/WKTh30NRGkvBR5ip
         LWBqRgULaOOOUtUgNZUqeD1w8FgDG3V8LZ8KQeoRoBPLRmiRcai775bhE+VjncIZIU4n
         rQZ+kIcfVu+dK9RcLl3K+kcs403Sl+U444m9YI/WoRo1l90irUQ0hUXdINCbCci89hxR
         sn8y0JSWVL/nNfMFbtABTpzMj/fnEvCblwMttxenpofUEtC/few5pKqPnYVxt6wY1y7q
         8fmA==
X-Gm-Message-State: AOAM530PPyr2UTufdUXjuSENcX3M0BhA5ml2LuyszDmpfJzIvrSYpHpe
        XZkv9GN2uzc6hP+KQUzgcSdrGw==
X-Google-Smtp-Source: ABdhPJyQ+e3nQdKz+4Vbbt5iD/W3X2KJLz78vuiAHa+46SzhO0ehlzzJ+0e/tzJbV1nknFtqS+jFtQ==
X-Received: by 2002:a17:902:c951:b0:154:38b8:aa30 with SMTP id i17-20020a170902c95100b0015438b8aa30mr40363011pla.145.1649816835678;
        Tue, 12 Apr 2022 19:27:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm45178942pfk.8.2022.04.12.19.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 19:27:15 -0700 (PDT)
Message-ID: <d39a2713-9172-3dd6-4a37-dad178a5bb57@kernel.dk>
Date:   Tue, 12 Apr 2022 20:27:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
References: <20220412202613.234896-1-axboe@kernel.dk>
 <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
 <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
 <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
 <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk>
 <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 8:19 PM, Eric Dumazet wrote:
> On Tue, Apr 12, 2022 at 7:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/12/22 8:05 PM, Eric Dumazet wrote:
>>> On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/12/22 7:54 PM, Eric Dumazet wrote:
>>>>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
>>>>>>>
>>>>>>> On 4/12/22 13:26, Jens Axboe wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> If we accept a connection directly, eg without installing a file
>>>>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
>>>>>>>> we have a socket for recv/send that we can fully serialize access to.
>>>>>>>>
>>>>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
>>>>>>>> in that case. Some of the testing I've done has shown as much as 15%
>>>>>>>> of overhead in the lock_sock/release_sock part, with this change then
>>>>>>>> we see none.
>>>>>>>>
>>>>>>>> Comments welcome!
>>>>>>>>
>>>>>>> How BH handlers (including TCP timers) and io_uring are going to run
>>>>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
>>>>>>> non multi-threaded program), we would still to use the spinlock.
>>>>>>
>>>>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
>>>>>> just the mutex. And we do check for running eg the backlog on release,
>>>>>> which I believe is done safely and similarly in other places too.
>>>>>
>>>>> So lets say TCP stack receives a packet in BH handler... it proceeds
>>>>> using many tcp sock fields.
>>>>>
>>>>> Then io_uring wants to read/write stuff from another cpu, while BH
>>>>> handler(s) is(are) not done yet,
>>>>> and will happily read/change many of the same fields
>>>>
>>>> But how is that currently protected?
>>>
>>> It is protected by current code.
>>>
>>> What you wrote would break TCP stack quite badly.
>>
>> No offense, but your explanations are severely lacking. By "current
>> code"? So what you're saying is that it's protected by how the code
>> currently works? From how that it currently is? Yeah, that surely
>> explains it.
>>
>>> I suggest you setup/run a syzbot server/farm, then you will have a
>>> hundred reports quite easily.
>>
>> Nowhere am I claiming this is currently perfect, and it should have had
>> an RFC on it. Was hoping for some constructive criticism on how to move
>> this forward, as high frequency TCP currently _sucks_ in the stack.
>> Instead I get useless replies, not very encouraging.
>>
>> I've run this quite extensively on just basic send/receive over sockets,
>> so it's not like it hasn't been run at all. And it's been fine so far,
>> no ill effects observed. If we need to tighten down the locking, perhaps
>> a valid use would be to simply skip the mutex and retain the bh lock for
>> setting owner. As far as I can tell, should still be safe to skip on
>> release, except if we need to process the backlog. And it'd serialize
>> the owner setting with the BH, which seems to be your main objection in.
>> Mostly guessing here, based on the in-depth replies.
>>
>> But it'd be nice if we could have a more constructive dialogue about
>> this, rather than the weird dismisiveness.
>>
>>
> 
> Sure. It would be nice that I have not received such a patch series
> the day I am sick.

I'm sorry that you are sick - but if you are not in a state to reply,
then please just don't. It sets a bad example. It was sent to the list,
not to you personally.

Don't check email then, putting the blame on ME for posting a patchset
while you are sick is uncalled for and rude. If I had a crystal ball, I
would not be spending my time working on the kernel. You know what
would've been a better idea? Replying that you are sick and that you are
sorry for being an ass on the mailing list.

> Jakub, David, Paolo, please provide details to Jens, thanks.

There's no rush here fwiw - I'm heading out on PTO rest of the week,
so we can pick this back up when I get back. I'll check in on emails,
but activity will be sparse.

-- 
Jens Axboe

