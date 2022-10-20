Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA2C6064C3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJTPiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiJTPiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:38:08 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63F81B7F23;
        Thu, 20 Oct 2022 08:38:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j7so35209520wrr.3;
        Thu, 20 Oct 2022 08:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2TgwTc8G/zF1ZNzGQ2tybntDeyNU3ESc4jJLheFu7VY=;
        b=DffqMPL8JpG+USUKB1YZ/ISCQeIaOYOfKQF5YGOAP3UgcJQgOjxZpvAEGZH80VCm8k
         mMiYajmhCZtjY+H80ppYI8na0OFndzHbmcc7yi1qupvYQ203kiGzaN4/fu7hGvvlw1kI
         JuJH0z5HHDtsXdbDfO7zOWP6H+Fc7uMX6zAgd4oa2dSWNms1yJU8LNXWIrM6DXjoP8OT
         T6cXGb9laARq/+tOUA5FkWCVA5blSWm+6FIY2+M9PtWQaogERhLbylzDbgH3kRLUtoAY
         K1Y3jSYqvn6G1ZW2lKoX/kFjItHs5wcU5HHpYRYenXegEh5d8V4ziS2NV+/UJ+YpnmiF
         qypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TgwTc8G/zF1ZNzGQ2tybntDeyNU3ESc4jJLheFu7VY=;
        b=QVkV6rmqZ0M0jX/SZt2LxyXRbWSb2RlVCia1ocnkdnTw/LV4BAeINvPjblqi9N811/
         JaVTAWoZJChfsGJIJb6h5bsF3C6OT/vlWu8m0yVnPFkvnz8Pw2sazDDSz92ss4TWbzLa
         DTdNpQ/oDetkrSElQvbs/5y+bCxHyo/dQY8wUjN0wzubPksUFIoOWfOr2HCIunGg/jU8
         lxWVF7W3k+d/l6UdZ23iMWL0nTFnvo0xieCet+RQQ9MovMHKmA4/e4ip8e085khxKvxT
         yHg1J0KowFwu7i0xiFi8jo6bV6VjdOR5sdhx77/vv5jxbj9FAdCo+OkmFJxjFOaCnV3n
         fDmQ==
X-Gm-Message-State: ACrzQf1Xag2NazzSAs1kMGRF2Q68keY6mtlcqMn+icJsa50oQnIDL7Cf
        JzTMWhZ0rPmRwDjn23pgrNQ=
X-Google-Smtp-Source: AMsMyM7TnCQ12rKcYHUpNhNVoPFLAec+n/VRiwZQgYBWlwGsfZe+6TP9tw0QqKwD1B3Y4uqAcdC8LQ==
X-Received: by 2002:a05:6000:1546:b0:231:a69a:6e with SMTP id 6-20020a056000154600b00231a69a006emr9679672wry.616.1666280285346;
        Thu, 20 Oct 2022 08:38:05 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id f26-20020a7bcd1a000000b003c6b70a4d69sm81108wmj.42.2022.10.20.08.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 08:38:04 -0700 (PDT)
Message-ID: <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
Date:   Thu, 20 Oct 2022 16:37:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
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
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 11:10, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>> Experimenting with this stuff lets me wish to have a way to
>>> have a different 'user_data' field for the notif cqe,
>>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>>> easier and would avoid some complexity in userspace...
>>> As I need to handle retry on short writes even with MSG_WAITALL
>>> as EINTR and other errors could cause them.
>>>
>>> What do you think?
> 
> Any comment on this?
> 
> IORING_SEND_NOTIF_USER_DATA could let us use
> notif->cqe.user_data = sqe->addr3;

I'd rather not use the last available u64, tbh, that was the
reason for not adding a second user_data in the first place.

Maybe IORING_SETUP_SQE128?

-- 
Pavel Begunkov
