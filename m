Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE38607607
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJULWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiJULWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:22:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EBE261429;
        Fri, 21 Oct 2022 04:22:04 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bp11so4026035wrb.9;
        Fri, 21 Oct 2022 04:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H7R3Me6hwrctNsT3YD93NqotZPBZa2fhmCWp5NtHQaA=;
        b=GoyN4FgL4+UdBb8NraWG4aetcfcnB8Tczy/Nv9UZgb4yqyWZZUXQWSsqhYq31kwwD5
         +UGaOOLmvS7J6YzJ5ftGTcRCn5vwtEeXlgSpWBqM7dCxWhfjyjlEo5TVp7+kcxU94/K3
         M8hSvEVmjsptYR0XN7urRtT6qWHkAiNDVsgmbo+oh3wpxoza6IeUIsN2h5Irt0jdjkxW
         ayqZoPATtyhb0lrRS0ZTENMLlUZNZF6SCJQ9MReJYNM0SrltnaqVEpUV6EjwwOnISdjH
         JvQDWCfDtBUxl/xQ40qH2RLHfHmWedFOMNKLrvVlUNVEWWjEenYoCjky4rX+vZWcZOLs
         QicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7R3Me6hwrctNsT3YD93NqotZPBZa2fhmCWp5NtHQaA=;
        b=o9kLTIyMN3h+9dROAndlDnYtK6RwOBkpW/u4sZQ4J8EIwrqKooeaJBRj/V/HonnUdf
         t9vtzmVjSqvyNKHdjx9TPWZAUTHYUlK2GKYGG533EpNbzaGh8LW+fPuuXUKSWFwo++qg
         ILQVjNiij1Wd44mGjV2cUbrtdiiEygFq6xeVbk4tOGVi45fP/1kmyHcM8ZbZCQ2kKhF1
         zSVuTe7kgz0TFlS6VXDHqdo6mF65yGhO2vZzw0zFUI6jZ9xYSVvyqyhcpI0j/IsYPY0n
         H8Oh9SIv74fh49pwY4jmd3sQ9mhEA42HOj5YNoy7mLGwmx9SdXODJeDpwfudRlSVO5Ja
         qRFQ==
X-Gm-Message-State: ACrzQf2OHfNZLsXMugbrHDqsdbAJimCktQH90j2Al0slpPCJFgZ92UeI
        5dcahluHHiylK4Gx+bGLEc0=
X-Google-Smtp-Source: AMsMyM7Y4CV/b8X5RSfdJrS7ckTnOmU0Iq7G4+8Jp4vsF5b+uD/wvHB32X9NqnFgPhUCVe6ouKxBkQ==
X-Received: by 2002:adf:f2c1:0:b0:231:3f1c:2fb with SMTP id d1-20020adff2c1000000b002313f1c02fbmr11512851wrp.602.1666351322247;
        Fri, 21 Oct 2022 04:22:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id z23-20020a1cf417000000b003c6b874a0dfsm2744358wma.14.2022.10.21.04.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 04:22:01 -0700 (PDT)
Message-ID: <2092f2db-d847-dd78-1690-359ed9bb7f14@gmail.com>
Date:   Fri, 21 Oct 2022 12:20:57 +0100
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
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
 <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
 <a5bf4d77-0fad-1d3f-159f-b97128f58af2@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a5bf4d77-0fad-1d3f-159f-b97128f58af2@samba.org>
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

On 10/21/22 10:45, Stefan Metzmacher wrote:
> Am 21.10.22 um 11:27 schrieb Pavel Begunkov:
>> On 10/21/22 09:32, Stefan Metzmacher wrote:
>>> Hi Pavel,
>>>
>>>>>>> Experimenting with this stuff lets me wish to have a way to
>>>>>>> have a different 'user_data' field for the notif cqe,
>>>>>>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>>>>>>> easier and would avoid some complexity in userspace...
>>>>>>> As I need to handle retry on short writes even with MSG_WAITALL
>>>>>>> as EINTR and other errors could cause them.
>>>>>>>
>>>>>>> What do you think?
>>>>>
>>>>> Any comment on this?
>>>>>
>>>>> IORING_SEND_NOTIF_USER_DATA could let us use
>>>>> notif->cqe.user_data = sqe->addr3;
>>>>
>>>> I'd rather not use the last available u64, tbh, that was the
>>>> reason for not adding a second user_data in the first place.
>>>
>>> As far as I can see io_send_zc_prep has this:
>>>
>>>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>>>                  return -EINVAL;
>>>
>>> both are u64...
>>
>> Hah, true, completely forgot about that one
> 
> So would a commit like below be fine for you?
> 
> Do you have anything in mind for SEND[MSG]_ZC that could possibly use
> another u64 in future?

It'll most likely be taken in the future, some features are planned
some I can imagine. The question is how necessary this one is and/or
how much simpler it would make it considering that CQEs are ordered
and apps still need to check for F_MORE. It shouldn't even require
refcounting. Can you elaborate on the simplifying userspace part?

-- 
Pavel Begunkov
