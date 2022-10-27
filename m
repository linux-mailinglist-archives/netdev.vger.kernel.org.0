Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7C260F5C3
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiJ0Kwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiJ0Kwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:52:43 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07509814C5;
        Thu, 27 Oct 2022 03:52:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k8so1523621wrh.1;
        Thu, 27 Oct 2022 03:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OEUN5s/udiA4AX5GKa/RV+iNbTg9pYzkC9A05vRTIGc=;
        b=TCBBnMc/aIVnT7JhBA6BY6+vY3lmkeizmPJbwIzjSy06TgeW2rApLRsQ8/WJL9JxVE
         vQPl4bdv3eNv3d07sA37QdUJUn3cBYvnSzefRlT58UZRcCi77URy80AxWd2kbjjqw7Zn
         ndBtNe038gt8QMfNO995cFb0/+BqIEzmMLTQ3O7rroEB0UX2ErhINinIJH1g+6DcyoPm
         OsRwem8KyiVTL9B6QIJr6VzGV2byeHfEKdhn4aT8mVK3YWUHYL55M41jtJUvc4qas22H
         jxXMyZ8ISztxSozTIIyeTbx3UKvShBxgaYkix179hAFxF1qvO53I2dV9tzoIBm7Q6En3
         E6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OEUN5s/udiA4AX5GKa/RV+iNbTg9pYzkC9A05vRTIGc=;
        b=dZAr4Qbrk4Gz3UWnCxoPQ+JfU2DlS+ZE0wuxiUDjCZkTL4Ay7ztLyFoc5n5YRYTcIC
         7fyko+Mzf/34K6f6S/iv4knEgONoFO0ViQGjpjMRcdfdfcSVvPvoxRGfono+j35fX5ln
         sAq7nRsv7g9vdFe/jBgB2qI6SPk43CbRiTWwq6lB35JrPbgTAWCpI1JQb1pSpqu40/tA
         FU/Vmnfl351G1k2zTKY6YIHOIdSN0bdi0mRpmabT8Es6uqsMlo+cmDgBdCmgiPTMKESZ
         TcgS4P5l6kfeEIws+svvFk9TzfgvHD28QzCvlD6fR17t7ptH+uBtW2GOvBZmnWcSoax9
         oV6A==
X-Gm-Message-State: ACrzQf0tjxJZW4PPRFdcJC7mnh50XE0iE6ZCo7JizTYJKOm3aQ09w2WZ
        jQIq52Dhdb66gGcw6n6n7yzqsDACu4Dcfw==
X-Google-Smtp-Source: AMsMyM6iXplVOUqsAFrhbeFSSa5Wj8sTH0Fbe0AZcA1ecI+UQyAJfKMoXj9i/B+ngdGbaK1YcEcccw==
X-Received: by 2002:a05:6000:810:b0:236:8a6d:e4e1 with SMTP id bt16-20020a056000081000b002368a6de4e1mr5396046wrb.661.1666867960392;
        Thu, 27 Oct 2022 03:52:40 -0700 (PDT)
Received: from [10.1.2.99] (wifi-guest-gw.tecnico.ulisboa.pt. [193.136.152.65])
        by smtp.gmail.com with ESMTPSA id d5-20020a05600c34c500b003cf568a736csm265988wmq.20.2022.10.27.03.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 03:52:39 -0700 (PDT)
Message-ID: <1f91ab66-56a2-3f9f-658d-399908afcc74@gmail.com>
Date:   Thu, 27 Oct 2022 11:51:21 +0100
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
 <273f154a-4cbd-2412-d056-a31fab5368d3@gmail.com>
 <11755fdb-4a28-0ea5-89a4-d51b2715f8c2@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <11755fdb-4a28-0ea5-89a4-d51b2715f8c2@samba.org>
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

On 10/21/22 15:03, Stefan Metzmacher wrote:
> Am 21.10.22 um 13:09 schrieb Pavel Begunkov:
>> On 10/21/22 10:36, Stefan Metzmacher wrote:
>>> Hi Pavel,
>> [...]
>>>> Right, I'm just tired of back porting patches by hand :)
>>>
>>> ok, I just assumed it would be 6.1 only.
>>
>> I'm fine with 6.1 only, it'd make things easier. I thought from
>> your first postings you wanted it 6.0. Then we don't need to care
>> about the placing of the copied/used flags.
>>
>>>>> Otherwise we could have IORING_CQE_F_COPIED by default without opt-in
>>>>> flag...
>>>
>>> Do you still want an opt-in flag to get IORING_CQE_F_COPIED?
>>> If so what name do you want it to be?
>>
>> Ala a IORING_SEND_* flag? Yes please.
>>
>> *_REPORT_USAGE was fine but I'd make it IORING_SEND_ZC_REPORT_USAGE.
>> And can be extended if there is more info needed in the future.
>>
>> And I don't mind using a bit in cqe->res, makes cflags less polluted.
> 
> So no worries about the delayed/skip sendmsg completion anymore?

I'll just make it incompatible the reporting.

> Should I define it like this, ok?
> 
> #define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
> 
> See the full patch below...

Looks good


> metze
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index d69ae7eba773..32e1f2a55b70 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -296,10 +296,24 @@ enum io_uring_op {
>    *
>    * IORING_RECVSEND_FIXED_BUF    Use registered buffers, the index is stored in
>    *                the buf_index field.
> +
> + * IORING_SEND_NOTIF_REPORT_USAGE
> + *                If SEND[MSG]_ZC should report
> + *                the zerocopy usage in cqe.res
> + *                for the IORING_CQE_F_NOTIF cqe.
> + *                IORING_NOTIF_USAGE_ZC_COPIED if data was copied
> + *                (at least partially).
>    */
>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>   #define IORING_RECV_MULTISHOT        (1U << 1)
>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
> +#define IORING_SEND_ZC_REPORT_USAGE    (1U << 3)
> +
> +/*
> + * cqe.res for IORING_CQE_F_NOTIF if
> + * IORING_SEND_ZC_REPORT_USAGE was requested
> + */
> +#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
> 
>   /*
>    * accept flags stored in sqe->ioprio
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 56078f47efe7..1aa3b50b3e82 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -939,7 +939,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> 
>       zc->flags = READ_ONCE(sqe->ioprio);
>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
> -              IORING_RECVSEND_FIXED_BUF))
> +              IORING_RECVSEND_FIXED_BUF |
> +              IORING_SEND_ZC_REPORT_USAGE))
>           return -EINVAL;
>       notif = zc->notif = io_alloc_notif(ctx);
>       if (!notif)
> @@ -957,6 +958,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>           req->imu = READ_ONCE(ctx->user_bufs[idx]);
>           io_req_set_rsrc_node(notif, ctx, 0);
>       }
> +    if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
> +        io_notif_to_data(notif)->zc_report = true;
> +    }
> 
>       if (req->opcode == IORING_OP_SEND_ZC) {
>           if (READ_ONCE(sqe->__pad3[0]))
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index e37c6569d82e..4bfef10161fa 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>           __io_unaccount_mem(ctx->user, nd->account_pages);
>           nd->account_pages = 0;
>       }
> +
> +    if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
> +        notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
> +
>       io_req_task_complete(notif, locked);
>   }
> 
> @@ -28,6 +32,13 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>       struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>       struct io_kiocb *notif = cmd_to_io_kiocb(nd);
> 
> +    if (nd->zc_report) {
> +        if (success && !nd->zc_used && skb)
> +            WRITE_ONCE(nd->zc_used, true);
> +        else if (!success && !nd->zc_copied)
> +            WRITE_ONCE(nd->zc_copied, true);
> +    }
> +
>       if (refcount_dec_and_test(&uarg->refcnt)) {
>           notif->io_task_work.func = __io_notif_complete_tw;
>           io_req_task_work_add(notif);
> @@ -55,6 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>       nd->account_pages = 0;
>       nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
>       nd->uarg.callback = io_uring_tx_zerocopy_callback;
> +    nd->zc_report = nd->zc_used = nd->zc_copied = false;
>       refcount_set(&nd->uarg.refcnt, 1);
>       return notif;
>   }
> diff --git a/io_uring/notif.h b/io_uring/notif.h
> index e4fbcae0f3fd..6be2e5ae8581 100644
> --- a/io_uring/notif.h
> +++ b/io_uring/notif.h
> @@ -15,6 +15,9 @@ struct io_notif_data {
>       struct file        *file;
>       struct ubuf_info    uarg;
>       unsigned long        account_pages;
> +    bool            zc_report;
> +    bool            zc_used;
> +    bool            zc_copied;
>   };
> 
>   void io_notif_flush(struct io_kiocb *notif);
> 

-- 
Pavel Begunkov
