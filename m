Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDBE34064D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhCRNFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhCRNE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:04:56 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33C2C06174A;
        Thu, 18 Mar 2021 06:04:55 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v11so5447777wro.7;
        Thu, 18 Mar 2021 06:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kD9f7EJt967Vs8rvZeiLRZRkcXEY63wSRXxQmqx7JMY=;
        b=cLGnyis23lh/4pwMCbAc8zud9/N+0C9SLBSUfgitJnWkglsOHiUXoS6ucJmgf/gyNe
         7rnfRWDTP4alx0QJwQ7PfLRyl4Uz+aaZhBzeGuiLv7p7bun66l88lo7ULWsrBy7Hj4F3
         X4z5w4IkujG2Lf7ujGXz1PMG/jxpLfme4MrQgkqvb2v2sZ0ZP1/u3Bj3/eZ5h3zd92bB
         gECbnLW6gi4Lp6BhnPqI76/yu/0iGZsE9onjjB3I66klax7kLdbY5h/sHuTX3KL5k8bu
         Alx+Z3e1gf5OFSZxiKJrPTdJ//bu4J5j8dZoroa40oaZiHSykIq0sVBM7R64P7l2k3xm
         nCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kD9f7EJt967Vs8rvZeiLRZRkcXEY63wSRXxQmqx7JMY=;
        b=FdgVbcPjwKJKSPH3HdsabIRHAQjRFPvujUHZNL9+E+t5dBjmofcu78Bn9Wq2ccXpvz
         LwsPz9rRn1FrybbLnHae99Tnbu3p49tE92f6DfrbDIqpDezVl30SqBXS88UMyqfiDW5e
         U59azuLHqr3luAwew3ncavKR79ZMkt+yrs68cUP/xAOUKAeU7g0YtnsbJdR0QTZSbR+V
         5J2OyIS0xh1C6amlkwzcm5E8TrEo8P7SOTitsXmE8gXnqS3u9HDV1Btgyqvh0YvDRbvt
         ws3zKotxvLXphOhhb70+Bf7nWHGaV+Jr8OW6EtxJE4df9z4poQaITJZGG5NowRkcIu/m
         koUg==
X-Gm-Message-State: AOAM533cim2o5LX9hSsgxMdUX9HLFNNiTakSdvpkkfHbMrKODBvrryfg
        nqrzPl5CllHPOkSRTPOwZhMLeGVoGm/RtA==
X-Google-Smtp-Source: ABdhPJziErOl3aFhOHWHP+3pL/XJYHyxahHnPIAY3vhZsc357wuBlNALQu1n4bW7RiwejIZ83qITiA==
X-Received: by 2002:adf:f303:: with SMTP id i3mr9454427wro.67.1616072694007;
        Thu, 18 Mar 2021 06:04:54 -0700 (PDT)
Received: from [192.168.8.170] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id c11sm2957837wrm.67.2021.03.18.06.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 06:04:52 -0700 (PDT)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cover.1615908477.git.metze@samba.org>
 <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
 <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
 <e15f23a2-4efc-c12a-9a4f-b4e3c347ae63@samba.org>
 <c5b26bbe-7d95-ec86-5ddb-c2bd2b6c79a7@gmail.com>
 <903c17f5-4339-7ee8-40fb-34a6974ce597@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
Message-ID: <0aabb09c-4f53-c581-1996-153072779108@gmail.com>
Date:   Thu, 18 Mar 2021 13:00:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <903c17f5-4339-7ee8-40fb-34a6974ce597@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2021 00:15, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>>>>> here're patches which fix linking of send[msg]()/recv[msg]() calls
>>>>>> and make sure io_uring_enter() never generate a SIGPIPE.
>>>>
>>>> 1/2 breaks userspace.
>>>
>>> Can you explain that a bit please, how could some application ever
>>> have a useful use of IOSQE_IO_LINK with these socket calls?
>>
>> Packet delivery of variable size, i.e. recv(max_size). Byte stream
>> that consumes whatever you've got and links something (e.g. notification
>> delivery, or poll). Not sure about netlink, but maybe. Or some
>> "create a file via send" crap, or some made-up custom protocols
> 
> Ok, then we need a flag or a new opcode to provide that behavior?
> 
> For recv() and recvmsg() MSG_WAITALL might be usable.

Hmm, unrelated, but there is a good chance MSG_WAITALL with io_uring
is broken because of our first MSG_DONTWAIT attempt. 

> It's not defined in 'man 2 sendmsg', but should we use it anyway
> for IORING_OP_SEND[MSG] in order to activate the short send check
> as the low level sock_sendmsg() call seem to ignore unused flags,
> which seems to be the reason for the following logic in tcp_sendmsg_locked:
> 
> if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {

Yep, it maintains compatibility because of unchecked unsupported flags.
Alleviating an old design problem, IIRC.

> 
> You need to set SOCK_ZEROCOPY in the socket in order to give a meaning
> to MSG_ZEROCOPY.
> 
> Should I prepare an add-on patch to make the short send/recv logic depend
> on MSG_WAITALL?

IMHO, conceptually it would make much more sense with MSG_WAITALL.

> 
> I'm cc'ing netdev@vger.kernel.org in order to more feedback of
> MSG_WAITALL can be passed to sendmsg without fear to trigger
> -EINVAL.
> 
> The example for io_sendmsg() would look like this:
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4383,7 +4383,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>         struct io_async_msghdr iomsg, *kmsg;
>         struct socket *sock;
>         unsigned flags;
> -       int expected_ret;
> +       int min_ret = 0;
>         int ret;
> 
>         sock = sock_from_file(req->file);
> @@ -4404,9 +4404,11 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>         else if (issue_flags & IO_URING_F_NONBLOCK)
>                 flags |= MSG_DONTWAIT;
> 
> -       expected_ret = iov_iter_count(&kmsg->msg.msg_iter);
> -       if (unlikely(expected_ret == MAX_RW_COUNT))
> -               expected_ret += 1;
> +       if (flags & MSG_WAITALL) {
> +               min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> +               if (unlikely(min_ret == MAX_RW_COUNT))
> +                       min_ret += 1;
> +       }
>         ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
>         if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
>                 return io_setup_async_msg(req, kmsg);
> @@ -4417,7 +4419,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>         if (kmsg->free_iov)
>                 kfree(kmsg->free_iov);
>         req->flags &= ~REQ_F_NEED_CLEANUP;
> -       if (ret != expected_ret)
> +       if (ret < min_ret)
>                 req_set_fail_links(req);
>         __io_req_complete(req, issue_flags, ret, 0);
>         return 0;
> 
> Which means the default of min_ret = 0 would result in:
> 
>         if (ret < 0)
>                 req_set_fail_links(req);
> 
> again...
> 
>>>> Sounds like 2/2 might too, does it?
>>>
>>> Do you think any application really expects to get a SIGPIPE
>>> when calling io_uring_enter()?
>>
>> If it was about what I think I would remove lots of old garbage :)
>> I doubt it wasn't working well before, e.g. because of iowq, but
>> who knows
> 
> Yes, it was inconsistent before and now it's reliable.

-- 
Pavel Begunkov
