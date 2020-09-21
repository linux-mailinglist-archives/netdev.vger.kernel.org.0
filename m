Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A77272AF4
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgIUQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgIUQEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:04:14 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1602C061755;
        Mon, 21 Sep 2020 09:04:13 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y15so59080wmi.0;
        Mon, 21 Sep 2020 09:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sdIgHQT1sjFsE6Sp3c24zrA/x7Tss24f6B4/9TuIjO0=;
        b=E9qxaKspPy4ac31AQqZlhWvJ8ossufkaQnqOtY9G9VklJERhT1VY6YqBH20NcXFukY
         if22BZjssjObVyVnYmfWRGY2OwI2/WHnV2/eY4zZpR1oNKa2aQbEg+quxu2Ak+ZxfYM0
         RlV5gjjtBl2RLc6vsXJMKCkvtE6m4cNNtLIM8fkINRkhRaQH0a58K8fQFgNMeKoIFXPT
         nkQ94emyzpfZEUx4DdOvelpy1wIbhDmJN+TPy1Z7Qf8pNtFdOCRPdUaEHDbanFqcRMES
         EQmArypqyfhOuAnhZ7hCsjJ4KGhnHkeiX/9Xf9z+SnbFmazWLFO7kJ+ppZEbEBlvqt2h
         Bs+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sdIgHQT1sjFsE6Sp3c24zrA/x7Tss24f6B4/9TuIjO0=;
        b=AcbLMsUy1KU4uQ31lnThcy55HarLRmv6xw+PKXgm0ZjYr5afH7ShZ964/EOKCfO/TQ
         jDv0jXNJtWtS3RC1aDG7YQQOUgOwS9f5GHadL3XUmipUBmzOvjf25zhBTObWuoK8Aowi
         oT4nfkH+zCsjFBBCd7XZwmVeOLZwWWgOAgFZHG/A4F76kjaVtX+fDcRYliBVKf1WObsc
         88qBrCop3QCxkd1DGAR+gyWUHqP/PHTBltNGW1Gc2KwqUtnNYveOh/t8pb9qFsbI4QQw
         UNMPGeNDbX/Jpm5IUzNwmQ8aYMjVmeQOFpV7a00DO9kJGdlFWPBJ7fyNyukvH0Z7SM33
         wc4g==
X-Gm-Message-State: AOAM530GoPqamQPzaHByNeXaYwn/Ro4zV15jjlnKg/DGqGWl8G1rN9Kb
        N51pBwJfuO+PoolTRJoOENf7vMPf2OI=
X-Google-Smtp-Source: ABdhPJwN7HPXY4B4rctAl0JJS0LiMM+FiEhFd89w3+RV1QQUijGyD9FuLnpl0u8obloB9/oPvlHIIQ==
X-Received: by 2002:a1c:23c8:: with SMTP id j191mr121403wmj.64.1600704252097;
        Mon, 21 Sep 2020 09:04:12 -0700 (PDT)
Received: from [192.168.43.240] ([5.100.192.97])
        by smtp.gmail.com with ESMTPSA id d83sm56754wmf.23.2020.09.21.09.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 09:04:11 -0700 (PDT)
Subject: Re: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
To:     David Laight <David.Laight@ACULAB.COM>,
        'Christoph Hellwig' <hch@infradead.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
 <20200921141456.GD24515@infradead.org>
 <4b204a3e4db74cb2bd8c81e31f6b359b@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <47e7d21b-28ae-80d7-8e1a-403f180b0e70@gmail.com>
Date:   Mon, 21 Sep 2020 19:01:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4b204a3e4db74cb2bd8c81e31f6b359b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2020 17:38, David Laight wrote:
> From: Christoph Hellwig
>> Sent: 21 September 2020 15:15
>>
>> On Tue, Sep 15, 2020 at 02:55:20PM +0000, David Laight wrote:
>>>
>>> This is the only code that relies on import_iovec() returning
>>> iter.count on success.
>>> This allows a better interface to import_iovec().

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

>>
>> This looks generall sane, but a comment below:
>>
>>> @@ -3123,7 +3123,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>>  	if (ret < 0)
>>>  		return ret;
>>>  	iov_count = iov_iter_count(iter);
>>> -	io_size = ret;
>>> +	io_size = iov_count;
>>>  	req->result = io_size;
>>>  	ret = 0;
>>>
>>> @@ -3246,7 +3246,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>>>  	if (ret < 0)
>>>  		return ret;
>>>  	iov_count = iov_iter_count(iter);
>>> -	io_size = ret;
>>> +	io_size = iov_count;
>>>  	req->result = io_size;
>>
>> I tink the local iov_count variable can go away in both functions,
>> as io_size only changes after the last use of iov_count (io_read) or
>> not at all (io_write).

Yes, iov_count should be killed, now or later.

> 
> Yes, the compiler will probably make that optimisation.
> I did a minimal change because my head hurts whenever I look at io_uring.c.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
Pavel Begunkov
