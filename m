Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797D5247188
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391032AbgHQS3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391020AbgHQS3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:29:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF05C061389;
        Mon, 17 Aug 2020 11:29:35 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m20so13119783eds.2;
        Mon, 17 Aug 2020 11:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AnbulxYHbbnMaTcW3IL3aMkMxlNLTYvtJz6E5z89MZ0=;
        b=d9WWd1dnBCzwRF16kWp9hvc0xJxGTyz5ckoCLK1aKlfQrYg0xfdeK+baSKaLkKxKNt
         M5QNPYjgAi/qZJ7P217XJtkMZy0cpksNysozDoqyh+YUVtc2vHgZtHAc4gcdyxCh5FOS
         ltyuafyKBdUoCXfJ5blqRYqX6RMjE+dOphK5+3uoCM6UCvjtoB0gZKUrkb0GyN1z4I1H
         RUPvnnlLCpLTidoQBrn1gynd0p88bap8mSGzZsmhd+LlHcHHvsA72bu8OYI4gdbVZHmF
         F5VxFI25xTMPHrfaJjhozsctZafPdAAW/yTRb5utTNYn9f27gwVVNK57rlK7i4ukBv07
         wRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AnbulxYHbbnMaTcW3IL3aMkMxlNLTYvtJz6E5z89MZ0=;
        b=TA2C9X1cp3R9EtOdhUx3dPagETSiVhFY/NfwBxBqFtpAy680krYQY8J8BcrBj9PhCe
         uZvWftUas0fWXfRftBOLBum9Hcjf5NVpR1/OJBRqvAnAAKvujYY+7/3F3O9v5aQYEOAt
         vqF0rnKV+gAkVUVF7yQldsTJA7q+mXB5PaLBULptlmShFy8CHfE6g8pvW4awKN24j78c
         Yf5G+zQ/ckCSROWuDxgXJakd2ipnusprcxmIbXqRbx5GYaCl8EZu+c3o9Fh4xFOsitlQ
         i1RwaKkZ5njSJZ7IMAOAVPWkxzipEHdNGVVE7RdYcjyzojjOR6cPCYnmatv0g2aDwPXO
         gKig==
X-Gm-Message-State: AOAM530SLE8A40IYAU7goPjdNHZhNG17r8gk6TyLVxXzjMGV+uD5HYrn
        MxcfGFF3QMVUu/KeQ/6wJwk=
X-Google-Smtp-Source: ABdhPJzFzb63fUdObGH/qtpvjMmN+Iv1iPl1V6Q0IhdEjbKmrBVKjHonhlux1Rp5RaDQnaTfU0I5JQ==
X-Received: by 2002:a05:6402:7c7:: with SMTP id u7mr14042288edy.283.1597688974574;
        Mon, 17 Aug 2020 11:29:34 -0700 (PDT)
Received: from debian64.daheim (pd9e293c0.dip0.t-ipconnect.de. [217.226.147.192])
        by smtp.gmail.com with ESMTPSA id 1sm14758452ejn.50.2020.08.17.11.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 11:29:33 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k7jsz-000522-3Y; Mon, 17 Aug 2020 20:29:33 +0200
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as
 __maybe_unused
To:     Kalle Valo <kvalo@codeaurora.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
 <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
 <9776eb47-6b83-a891-f057-dd34d14ea16e@rasmusvillemoes.dk>
 <87eeo5mnr0.fsf@codeaurora.org>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <b1a92cf5-3178-c845-17ee-c9947b192cc4@gmail.com>
Date:   Mon, 17 Aug 2020 20:29:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87eeo5mnr0.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-17 14:59, Kalle Valo wrote:
> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> 
>> On 14/08/2020 17.14, Christian Lamparter wrote:
>>> On 2020-08-14 13:39, Lee Jones wrote:
>>>> 'ar9170_qmap' is used in some source files which include carl9170.h,
>>>> but not all of them.  Mark it as __maybe_unused to show that this is
>>>> not only okay, it's expected.
>>>>
>>>> Fixes the following W=1 kernel build warning(s)
>>>
>>> Is this W=1 really a "must" requirement? I find it strange having
>>> __maybe_unused in header files as this "suggests" that the
>>> definition is redundant.
>>
>> In this case it seems one could replace the table lookup with a
>>
>> static inline u8 ar9170_qmap(u8 idx) { return 3 - idx; }
>>
>> gcc doesn't warn about unused static inline functions (or one would have
>> a million warnings to deal with). Just my $0.02.
> 
> Yeah, this is much better.

Yes, this is much better than just adding __maybe_unused :).

To be on the safe side (and to get rid of a & in tx.c:666), the "3 - 
idx" should be something like "return (3 - idx) & 
CARL9170_TX_STATUS_QUEUE". I think its also possible to just use clamp_t
(or min_t since the u8 has no negative values) or make use of a switch 
statement [analogues what was done in ath10k commit: 91493e8e10 "ath10k: 
fix recent bandwidth conversion bug" (just to be clear. Yes this ath10k 
commit has nothing to do with queues, but it is a nice, atomic 
switch-case static inline function example).]

> And I think that static variables should not even be in the header
> files. Doesn't it mean that there's a local copy of the variable
> everytime the .h file is included? Sure, in this case the overhead is
> small (4 bytes per include) but still it's wrong.
Seems to be "sort of". I compiled both, the current vanilla carl9170 and
with Lee Jones' patch on Debian's current gcc 10.2.0 (Debian 10.2.0-5)
and gnu ld 2.35.

The ar9170_qmap symbol is only present in the object file if ar9170_qmap 
is used by the source. In the final module file (carl9170.ko), there are 
two ar9170_qmap symboles in the module's .rodata section (one is coming 
from main.o code and the other from tx.o).

(The use of __maybe_unused didn't make any difference. Same overall 
section and file sizes).

Cheers,
Christian
