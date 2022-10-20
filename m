Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C215A606491
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJTPcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJTPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:32:09 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B7319898D;
        Thu, 20 Oct 2022 08:32:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so2685344wms.0;
        Thu, 20 Oct 2022 08:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qBorEfylstwRhFWftE0kg965ecXkFYeeE+CinEcosTs=;
        b=SpPe6xHRIcCrne/hB6tik6nEPmHkvN4iq9onOrxJN/r8/1meztIrUV/tWevI8XODYm
         rA4s+umfqhO5u1tizkcLiywV9O/4FDNRUZoCg9QTTOSVjMj05PM1TS7LNKzeJX1Do+Ez
         s5Tj4ch5UxEx4WG4w9OKVVPWhU0c0prhiYRR3CJqlMEQ+Luo4MMa4TjDg8QuGvpgVpuh
         Rd2NaIQRC/tBAQxoe22tdq5VJmjcTykIRzmconToD4eF2LRYQxuA8SDe3B2hJrKHkTQO
         bTx9ihWnYzdk3wA7p7rEY7wnVB/SrcNGWoMFqgEtWhr6Un0dlxmXgwS3gv1Kg+twZlWl
         5lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBorEfylstwRhFWftE0kg965ecXkFYeeE+CinEcosTs=;
        b=kJ5jvS9yQah13K9IyXXZre4tQTwAOUR28m2tq+tPR910MOr3EMQWsixJJKIx7ldSZR
         sEFi5FytJCblAjDIcAcV4hG/Zigi3krbQBu3Uy30azymuhIvJ8bcqpe4nvPQOKwufJrT
         dChDP1meIzYNd6L+vmthOr/QXxttouZ0IkRqOYEpDTpjWwswIPV2EgLmBsIFMPandQjU
         ifib2SClifjeR2bmVPzAcAe1r0o8DugYkzjdNhXxPQyygNdnBoEoKhil04aTW4ljFInd
         4iWzc/ergYYoZe9Akkq3KOu0/uV7Pei51pNOPn/wvarRBqYABeYKxzIdpUvir926vzUG
         Z5kg==
X-Gm-Message-State: ACrzQf0DV+AUacAlHYeyoOCZ732CuelhHSt5qRNnhcQpn0Sq30av92Qz
        yKpmV/Yib/Tdn8WDhZxfCjXXCIduY2Q=
X-Google-Smtp-Source: AMsMyM55ad3WQaHxmARvoFMIlWCMCRy4uKgNdxBmle2zIqqKvBelhKORcT/JMjp1yzXNZNy/U99L6g==
X-Received: by 2002:a1c:ed11:0:b0:3b4:d3e1:bec with SMTP id l17-20020a1ced11000000b003b4d3e10becmr9766887wmh.196.1666279925520;
        Thu, 20 Oct 2022 08:32:05 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id l22-20020a7bc356000000b003c6cd82596esm71289wmj.43.2022.10.20.08.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 08:32:04 -0700 (PDT)
Message-ID: <c7505b91-16c3-8f83-9782-a520e8b0f484@gmail.com>
Date:   Thu, 20 Oct 2022 16:31:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
 <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
 <e87610a6-27a6-6175-1c66-a8dcdc4c14cb@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e87610a6-27a6-6175-1c66-a8dcdc4c14cb@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 15:51, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>> So far I came up with a IORING_SEND_NOTIF_REPORT_USAGE opt-in flag
>>> and the reporting is done in cqe.res with IORING_NOTIF_USAGE_ZC_USED (0x00000001)
>>> and/or IORING_NOTIF_USAGE_ZC_COPIED (0x8000000). So the caller is also
>>> able to notice that some parts were able to use zero copy, while other
>>> fragments were copied.
>>
>> Are we really interested in multihoming and probably some very edge cases?
>> I'd argue we're not and it should be a single bool hint indicating whether
>> zc is viable or not. It can do more complex calculations _if_ needed, e.g.
>> looking inside skb's and figure out how many bytes were copied but as for me
>> it should better be turned into a single bool in the end. Could also be the
>> number of bytes copied, but I don't think we can't have the accuracy for
>> that (e.g. what we're going to return if some protocol duplicates an skb
>> and sends to 2 different devices or is processing it in a pipeline?)
>>
>> So the question is what is the use case for having 2 flags?
> 
> It's mostly for debugging.

Ok, than it sounds like we don't need it.


>> btw, now we've got another example why the report flag is a good idea,
> 
> I don't understand that line...

I'm just telling that IORING_SEND_NOTIF_* instead of unconditional reporting
is more flexible and extendible from the uapi perspective.


>> we can't use cqe.res unconditionally because we want to have a "one CQE
>> per request" mode, but it's fine if we make it and the report flag
>> mutually exclusive.
> 
> You mean we can add an optimized case where SEND[MSG]_ZC would not
> generate F_MORE and skips F_NOTIF, because we copied or the transmission
> path was really fast?

It is rather about optionally omitting the first (aka completion) cqe and
posting only the notification cqe, which makes a lot of sense for UDP and
some TCP use cases.


> Then I'd move to IORING_CQE_F_COPIED again...
[...]
>>> -struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>> +static void __io_notif_complete_tw_report_usage(struct io_kiocb *notif, bool *locked)
>>
>> Just shove all that into __io_notif_complete_tw().
> 
> Ok, and then optimze later?

Right, I'm just tired of back porting patches by hand :)


> Otherwise we could have IORING_CQE_F_COPIED by default without opt-in
> flag...
> 
>>> +static void io_uring_tx_zerocopy_callback_report_usage(struct sk_buff *skb,
>>> +                            struct ubuf_info *uarg,
>>> +                            bool success)
>>> +{
>>> +    struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>>> +
>>> +    if (success && !nd->zc_used && skb)
>>> +        nd->zc_used = true;
>>> +    else if (unlikely(!success && !nd->zc_copied))
>>> +        nd->zc_copied = true;
>>
>> It's fine but racy, so let's WRITE_ONCE() to indicate it.
> 
> I don't see how this could be a problem, but I can add it.

It's not a problem, but better to be a little be more explicit
about parallel writes.


>>> diff --git a/io_uring/notif.h b/io_uring/notif.h
>>> index 5b4d710c8ca5..5ac7a2745e52 100644
>>> --- a/io_uring/notif.h
>>> +++ b/io_uring/notif.h
>>> @@ -13,10 +13,12 @@ struct io_notif_data {
>>>       struct file        *file;
>>>       struct ubuf_info    uarg;
>>>       unsigned long        account_pages;
>>> +    bool            zc_used;
>>> +    bool            zc_copied;
>>
>> IIRC io_notif_data is fully packed in 6.1, so placing zc_{used,copied}
>> there might complicate backporting (if any). We can place them in io_kiocb
>> directly and move in 6.2. Alternatively account_pages doesn't have to be
>> long.
> 
> As far as I can see kernel-dk-block/io_uring-6.1 alread has your
> shrink patches included...

Sorry, I mean 6.0

-- 
Pavel Begunkov
