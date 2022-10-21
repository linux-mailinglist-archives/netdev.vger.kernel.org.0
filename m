Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B9E6075A1
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJULKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJULKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:10:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56E6C4D9F;
        Fri, 21 Oct 2022 04:10:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk15so4230482wrb.13;
        Fri, 21 Oct 2022 04:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PY74XdYjljcGRbOZaeOfZDqZDe9ADPbiIpuxa7J785Y=;
        b=RX4GG75o3OHISpYNLxUTc6SamD2wl9NCWL/XTaZgzmdeG7XuCgeQD1J89IKDESrDGB
         nLnUZW9cB+/ElI2HFtstu91+onpQZ787A8FmPgCPsRfg/m7rUwJl1l17hxMoknNT2Kq6
         h1fPy682nDZ049FbDrqH5wx0LOOztJN/m+qaqtAZ1hOKNGeRtWbblBRjkgxFPXJm+76s
         mkJ84Yf++Fe7voWXNwZcLj5b53h1kwDYIRxU9miLLS90fv9OxNzEvH9hHXNDBPxZBgMX
         9aYpnaXsVdz7sxM96DfrdhxlBI3sZMESFROoH7QigfcApoWVlUpon5c3G2BkcoZhQiAb
         59MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PY74XdYjljcGRbOZaeOfZDqZDe9ADPbiIpuxa7J785Y=;
        b=MTEVb7E9/dvSDFuXWzOQjh+imxflj789w8sK2+EJ3fBE5tJV0tWPeWBfAvnkabJ5QM
         jDnr+fmTM3xgKmmPaLashcnoZARxJCFg01/LrJF2eaiXavGCVAubXMtBEDg0DzT+SD2O
         DPAVd4n2/ozd50C8FHNrfZqbaXna+O3lMXD5U6WlHf/I9VYZu10OrMfAAe9fCCfUSzCK
         DJKndCSBVIlSxUkDrOpvCUY0H1CSsYY6tCReggFVbeRsklwKFSCzd2whNO6FesDDznhX
         QSuzArpu6VZUmLHXu6ng9pg0gtu2vjYXo7KlVM6G/Acrqti0UWVTcJwlwCbhBzvzwnff
         6ksg==
X-Gm-Message-State: ACrzQf0FI3UGzbWlDI7QOqx2TjlATp5XXYLhsK8M5OhEkVfxe0E+3IH3
        wUlK6Rz09vF4Th6PJFB7L3Q8VG9qBaw=
X-Google-Smtp-Source: AMsMyM5q8O6tu2ouESCLmn1DyifYVR7+nOwJD2ZDoG+K4K39gqITk1WieUfdB6O86lIiNdKRWds4hw==
X-Received: by 2002:a5d:4f81:0:b0:21e:2cd7:25df with SMTP id d1-20020a5d4f81000000b0021e2cd725dfmr12251781wru.439.1666350613137;
        Fri, 21 Oct 2022 04:10:13 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d6a52000000b0022af865810esm18696300wrw.75.2022.10.21.04.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 04:10:12 -0700 (PDT)
Message-ID: <273f154a-4cbd-2412-d056-a31fab5368d3@gmail.com>
Date:   Fri, 21 Oct 2022 12:09:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
Content-Language: en-US
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
 <c7505b91-16c3-8f83-9782-a520e8b0f484@gmail.com>
 <3e56c92b-567c-7bb4-2644-dc1ad1d8c3ae@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3e56c92b-567c-7bb4-2644-dc1ad1d8c3ae@samba.org>
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

On 10/21/22 10:36, Stefan Metzmacher wrote:
> Hi Pavel,
[...]
>> Right, I'm just tired of back porting patches by hand :)
> 
> ok, I just assumed it would be 6.1 only.

I'm fine with 6.1 only, it'd make things easier. I thought from
your first postings you wanted it 6.0. Then we don't need to care
about the placing of the copied/used flags.

>>> Otherwise we could have IORING_CQE_F_COPIED by default without opt-in
>>> flag...
> 
> Do you still want an opt-in flag to get IORING_CQE_F_COPIED?
> If so what name do you want it to be?

Ala a IORING_SEND_* flag? Yes please.

*_REPORT_USAGE was fine but I'd make it IORING_SEND_ZC_REPORT_USAGE.
And can be extended if there is more info needed in the future.

And I don't mind using a bit in cqe->res, makes cflags less polluted.


>>>>> +static void io_uring_tx_zerocopy_callback_report_usage(struct sk_buff *skb,
>>>>> +                            struct ubuf_info *uarg,
>>>>> +                            bool success)
>>>>> +{
>>>>> +    struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>>>>> +
>>>>> +    if (success && !nd->zc_used && skb)
>>>>> +        nd->zc_used = true;
>>>>> +    else if (unlikely(!success && !nd->zc_copied))
>>>>> +        nd->zc_copied = true;
>>>>
>>>> It's fine but racy, so let's WRITE_ONCE() to indicate it.
>>>
>>> I don't see how this could be a problem, but I can add it.
>>
>> It's not a problem, but better to be a little be more explicit
>> about parallel writes.
> 
> ok.
> 
>>>>> diff --git a/io_uring/notif.h b/io_uring/notif.h
>>>>> index 5b4d710c8ca5..5ac7a2745e52 100644
>>>>> --- a/io_uring/notif.h
>>>>> +++ b/io_uring/notif.h
>>>>> @@ -13,10 +13,12 @@ struct io_notif_data {
>>>>>       struct file        *file;
>>>>>       struct ubuf_info    uarg;
>>>>>       unsigned long        account_pages;
>>>>> +    bool            zc_used;
>>>>> +    bool            zc_copied;
>>>>
>>>> IIRC io_notif_data is fully packed in 6.1, so placing zc_{used,copied}
>>>> there might complicate backporting (if any). We can place them in io_kiocb
>>>> directly and move in 6.2. Alternatively account_pages doesn't have to be
>>>> long.
>>>
>>> As far as I can see kernel-dk-block/io_uring-6.1 alread has your
>>> shrink patches included...
>>
>> Sorry, I mean 6.0
> 
> So you want to backport to 6.0?
> 
> Find the current version below, sizeof(struct io_kiocb) will grow from
> 3*64 + 24 to 3*64 + 32 (on x64_64) to it stays within 4 cache lines.
> 
> I tried this first:
> 
> union {
>    u8 iopoll_completed;
>    struct {
>      u8 zc_used:1;
>      u8 zc_copied:1;
>    };
> };
> 
> But then WRITE_ONCE() complains about a bitfield write.

rightfully so, it can't be a bitfield as it would be racy
and not only in theory this time.


> So let me now about the opt-in flag and I'll prepare real commits
> including a patch that moves from struct io_kiocb to struct io_notif_data
> on top.

Yeah, better to be opt-in, but apart from it and comments above
looks good.


> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index f5b687a787a3..189152ad78d6 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -515,6 +515,9 @@ struct io_kiocb {
>       u8                opcode;
>       /* polled IO has completed */
>       u8                iopoll_completed;
> +    /* these will be moved to struct io_notif_data in 6.1 */
> +    bool                zc_used;
> +    bool                zc_copied;
>       /*
>        * Can be either a fixed buffer index, or used with provided buffers.
>        * For the latter, before issue it points to the buffer group ID,
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ab7458033ee3..738d6234d1d9 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -350,6 +350,7 @@ struct io_uring_cqe {
>   #define IORING_CQE_F_MORE        (1U << 1)
>   #define IORING_CQE_F_SOCK_NONEMPTY    (1U << 2)
>   #define IORING_CQE_F_NOTIF        (1U << 3)
> +#define IORING_CQE_F_COPIED        (1U << 4)
> 
>   enum {
>       IORING_CQE_BUFFER_SHIFT        = 16,
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index e37c6569d82e..033aca064b10 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>           __io_unaccount_mem(ctx->user, nd->account_pages);
>           nd->account_pages = 0;
>       }
> +
> +    if (notif->zc_copied || !notif->zc_used)
> +        notif->cqe.flags |= IORING_CQE_F_COPIED;
> +

As discussed above, should depend on IORING_SEND_ZC_REPORT_USAGE

>       io_req_task_complete(notif, locked);
>   }
> 
> @@ -28,6 +32,11 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>       struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>       struct io_kiocb *notif = cmd_to_io_kiocb(nd);
> 
> +    if (success && !notif->zc_used && skb)
> +        WRITE_ONCE(notif->zc_used, true);
> +    else if (!success && !notif->zc_copied)
> +        WRITE_ONCE(notif->zc_copied, true);
> +
>       if (refcount_dec_and_test(&uarg->refcnt)) {
>           notif->io_task_work.func = __io_notif_complete_tw;
>           io_req_task_work_add(notif);
> @@ -55,6 +64,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>       nd->account_pages = 0;
>       nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
>       nd->uarg.callback = io_uring_tx_zerocopy_callback;
> +    notif->zc_used = notif->zc_copied = false;
>       refcount_set(&nd->uarg.refcnt, 1);
>       return notif;
>   }
> 

-- 
Pavel Begunkov
