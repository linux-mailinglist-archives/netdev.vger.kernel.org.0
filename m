Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1666605578
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiJTCZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJTCZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:25:28 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE79210CFB5;
        Wed, 19 Oct 2022 19:25:27 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so1304459wme.5;
        Wed, 19 Oct 2022 19:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lhSC6rFfgkPq0fs2z88hSez5K7IyZJVYndqeAxDCxN8=;
        b=XZDZfTuWKp7piCfNBsvxsyrIBkxEPfTiV7RUo0+QlCxkCIFcIlfDG6DTzPo/TOnHJp
         csGXbFs6Nt4XuFryCtLAtq78TPst3TTAfEx87ia1FCyJeiIHXgjlBFI4DNtMPocEuEtH
         AMYhY2rgcNZoftPqHlWHFQSLafCCja5dZmmaFr6D+6/m3J6Y9PMRh+t+deSngHSwD61T
         Lx7WgJJ/2DlqfX0NOyh8ZMudxkyMEDizehQMa8YpM48SxZmMvnw8r5VB2JDwlCHwHpCo
         +tMkL2lY4+Q+UOLxUFf/DvLgQC4KGabPPjaLGXnI6VEwvHo9kwByCpbRxaZZnLDHkNqn
         Ys1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lhSC6rFfgkPq0fs2z88hSez5K7IyZJVYndqeAxDCxN8=;
        b=tBN2+LjU23mLJHKPNhvNaAjjj7ttJlZuQoneK/vHoyrvcfhkpUtQlN+SpHuhOmlAng
         UpIeU5tJupxMOGZ0PuQsAmp25pmU87aGOhHWXX3Sxz4fBpRQIWQjf37XQd/SCEsa2QGd
         wpTunrrVaZ4800U7njzgaUtl/CK6GtJ5eCfuxLDB7vL0cs+O7iWw979sZEgUgJt4K28F
         xGCnUPPZmNNIKWL9e6WiYo+EIEmeq+ra+/hCGTdgt6v6FXq+kfe2ZKJ3DXzT+NFOn+Hw
         fQjNwK4OUjSONDkgP5Jc2Gyqvt5tWhCz6HBYTtPtsTlGimfoEgBe99j+5caYhDyWNteq
         Uobw==
X-Gm-Message-State: ACrzQf0KTIW79WwLop5XLbESoWkKJVcxNuIRR87YlnfkioE5SMXpFQaK
        ulT1Pe5r2hZTSyaMEzsKxKg=
X-Google-Smtp-Source: AMsMyM5PNQOWP7WuGkV/RnzwBcipYb+HamcMIV1dsB3rhF/xcbwjMEPjyFrBk6iLmW52k83kKE0amQ==
X-Received: by 2002:a05:600c:1906:b0:3c6:f154:d4b5 with SMTP id j6-20020a05600c190600b003c6f154d4b5mr7582780wmq.94.1666232726354;
        Wed, 19 Oct 2022 19:25:26 -0700 (PDT)
Received: from [192.168.8.100] (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b003c6b7f5567csm4543158wms.0.2022.10.19.19.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 19:25:25 -0700 (PDT)
Message-ID: <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
Date:   Thu, 20 Oct 2022 03:24:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_CQE_F_COPIED
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
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

On 10/19/22 17:12, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>> As I basically use the same logic that's used to generate SO_EE_CODE_ZEROCOPY_COPIED
>>> for the native MSG_ZEROCOPY, I don't see the problem with IORING_CQE_F_COPIED.
>>> Can you be more verbose why you're thinking about something different?
>>
>> Because it feels like something that should be done roughly once and in
>> advance. Performance wise, I agree that a bunch of extra instructions in
>> the (io_uring) IO path won't make difference as the net overhead is
>> already high, but I still prefer to keep it thin. The complexity is a
>> good point though, if only we could piggy back it onto MSG_PROBE.
>> Ok, let's do IORING_CQE_F_COPIED and aim 6.2 + possibly backport.
> 
> Thanks!
> 
> Experimenting with this stuff lets me wish to have a way to
> have a different 'user_data' field for the notif cqe,
> maybe based on a IORING_RECVSEND_ flag, it may make my life
> easier and would avoid some complexity in userspace...
> As I need to handle retry on short writes even with MSG_WAITALL
> as EINTR and other errors could cause them.
> 
> What do you think?
> 
>> First, there is no more ubuf_info::zerocopy, see for-next, but you can
>> grab space in io_kiocb, io_kiocb::iopoll_completed is a good candidate.
> 
> Ok I found your "net: introduce struct ubuf_info_msgzc" and
> "net: shrink struct ubuf_info" commits.
> 
> I think the change would be trivial, the zerocopy field would just move
> to struct io_notif_data..., maybe as 'bool copied'.
> 
>> You would want to take one io_uring patch I'm going to send (will CC
>> you), with that you won't need to change anything in net/.
> 
> The problem is that e.g. tcp_sendmsg_locked() won't ever call
> the callback at all if 'zc' is false.
> 
> That's why there's the:
> 
>                          if (!zc)
>                                  uarg->zerocopy = 0;
> 
> Maybe I can inverse the logic and use two variables 'zero_copied'
> and 'copied'.
> 
> We'd start with both being false and this logic in the callback:> 
> if (success) {
>      if (unlikely(!nd->zero_copied && !nd->copied))
>         nd->zero_copied = true;
> } else {
>      if (unlikely(!nd->copied)) {
>         nd->copied = true;
>         nd->zero_copied = false;
>      }
> }

Yep, sth like that should do, but let's guard against
spurious net_zcopy_put() just in case.

used = false;
copied = false;

callback(skb, success, ubuf) {
	if (skb)
		used = true;
	if (!success)
		copied = true;
}
complete() {
	if (!used || copied)
		set_flag(IORING_CQE_F_COPIED);
}

> And __io_notif_complete_tw still needs:
> 
>          if (!nd->zero_copied)
>                  notif->cqe.flags |= IORING_CQE_F_COPIED;

Which can be shoved in a custom callback


>> And the last bit, let's make the zc probing conditional under IORING_RECVSEND_* flag,
>> I'll make it zero overhead when not set later by replacing the callback.
> 
> And the if statement to select a highspeed callback based on
> a IORING_RECVSEND_ flag is less overhead than
> the if statements in the slow callback version?

I'm more concerned about future changes around it, but there won't
be extra ifs.

#define COMMON_FLAGS (RECVSEND_FIRST_POLL|...)
#define ALL_FLAGS (COMMON_FLAGS|RECVSEND_PROBE)

if (flags & ~COMMON_FLAGS) {
	if (flags & ~ALL_FLAGS)
		return err;
	if (flags & RECVSEND_PROBE)
		set_callback(notif);
}

-- 
Pavel Begunkov
