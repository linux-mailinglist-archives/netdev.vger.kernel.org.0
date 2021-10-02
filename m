Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAAB41FD96
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 20:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhJBSMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbhJBSMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:12:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F91C0613EC;
        Sat,  2 Oct 2021 11:10:35 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id s24so9652182wmh.4;
        Sat, 02 Oct 2021 11:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=clkeClsT6IZFwtmF+F+5IU24AjU7rv5LP/5BbBwXOts=;
        b=MXLKaW9livxn7JRmENcmaCVpLpEDRKCYDtpXjx7Hha0KLDZ6+8nMw/SV2LWc1CecrN
         U7/MM0xmgYFubW6U9wKbeIoaV5DaU/wB8R5KwraHdaWRyP1qqPODdFncCt6Z73Shnv10
         2Fnjlxyw6YgvtGe4YdX8VjgYG9nGi7DKx4N/KnAMeRRCE7cSapuVerIlhjeOFBOaquqA
         FM7Faqnhv+xtwbvXlns5TYGRxCQN8VM71huQ2iy5DeRcBrCp+0xries89ZbxM8xGBcac
         c2v1I3V3kv9VQGdXdxbAOVlFA9MPYei3+8k+Fdu+gujJvme9YzQzZ9sJnkaCffc5tkLC
         2ETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=clkeClsT6IZFwtmF+F+5IU24AjU7rv5LP/5BbBwXOts=;
        b=TV2/kFeBKt0WDtkpf/XHGtIDjBFLjdh6wDEp8QWdWpa3uBlDzzdJIgh+7d4NtVh948
         vZoeemKMB6Kkz2P67DBBsT6sRDBPBVEoOm5q0tPIo0rhetvU+96MHBD4a6rNQNehZavc
         Ys3RuOrPrwZTCSsv/2FOmlbxZKvdl0LINe+ALOVRWcnM3s20hc6j2Cgt1B8J/wLhSTms
         qi94BWvYYlm7JcLD8K+9LBsOc03avjTc67Fad6HjgTWFyP8cgBRBuKIEGY0vCROyzjXw
         0b3oY7kRWtC0V/SS8BU2mqY9iu0tEpKOSKWr0j4yqVUqbwus7BWbRC7u0WLRBwgcVpQA
         5dEQ==
X-Gm-Message-State: AOAM530QWgeGTH09ZZGEa8jW3yxAQTR+Om/4fJ2qtdmuybRfQLGf5Pn9
        eElemLOnhFtbQcuzLo46hI9nYkTjT3I=
X-Google-Smtp-Source: ABdhPJwC0EzyR8BCPHEkqExvF/JR3f4XLJyhmG4e0fOArHlLDj3BaFfbJQN7Hrsh9nPpLJdtbCxG3Q==
X-Received: by 2002:a05:600c:354a:: with SMTP id i10mr10152827wmq.77.1633198233769;
        Sat, 02 Oct 2021 11:10:33 -0700 (PDT)
Received: from [10.8.0.30] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id z6sm13209596wmp.1.2021.10.02.11.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 11:10:33 -0700 (PDT)
Subject: Re: [PATCH] unix.7: Add a description for ENFILE.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     benh@amazon.com, kuni1840@gmail.com, linux-man@vger.kernel.org,
        mtk.manpages@gmail.com, netdev@vger.kernel.org
References: <206a26e5-0515-44b9-39cb-bc46013bfc6c@gmail.com>
 <20211002175653.58027-1-kuniyu@amazon.co.jp>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <e0074952-cf64-9cc5-0d0b-c31124b44166@gmail.com>
Date:   Sat, 2 Oct 2021 20:10:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211002175653.58027-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Kuniyuki!

On 10/2/21 7:56 PM, Kuniyuki Iwashima wrote:
> From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
> Date:   Sat, 2 Oct 2021 19:44:52 +0200
>> Hello Kuniyuki,
>>
>> On 9/29/21 3:38 AM, Kuniyuki Iwashima wrote:
>>> When creating UNIX domain sockets, the kernel used to return -ENOMEM on
>>> error where it should return -ENFILE.  The behaviour has been wrong since
>>> 2.2.4 and fixed in the recent commit f4bd73b5a950 ("af_unix: Return errno
>>> instead of NULL in unix_create1().").
>>>
>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>> ---
>>> Note to maintainers of man-pages, the commit is merged in the net tree [0]
>>> but not in the Linus' tree yet.
>>>
>>> [0]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f4bd73b5a950
>>
>> Thanks!
>>
>> The patch looks good to me, so could you ping back when this is merged
>> in Linus's tree?
> 
> Thanks, sure!
> Is that -stable?
> The pull-request from net-next hit the Linus' 5.14-rc4 tree few days ago.
> https://lore.kernel.org/linux-kernel/20210930163002.4159171-1-kuba@kernel.org/
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4de593fb965fc2bd11a0b767e0c65ff43540a6e4

Ahh, if it already is in Linus's tree, I'll merge your patch.

Thanks,

Alex

> 
> Best regards,
> Kuniyuki
> 
> 
>>
>> Cheers,
>>
>> Alex
>>
>>> ---
>>>    man7/unix.7 | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/man7/unix.7 b/man7/unix.7
>>> index 6d30b25cd..2dc96fea1 100644
>>> --- a/man7/unix.7
>>> +++ b/man7/unix.7
>>> @@ -721,6 +721,9 @@ invalid state for the applied operation.
>>>    called on an already connected socket or a target address was
>>>    specified on a connected socket.
>>>    .TP
>>> +.B ENFILE
>>> +The system-wide limit on the total number of open files has been reached.
>>> +.TP
>>>    .B ENOENT
>>>    The pathname in the remote address specified to
>>>    .BR connect (2)
>>>
>>
>>
>> -- 
>> Alejandro Colomar
>> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
>> http://www.alejandro-colomar.es/


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
