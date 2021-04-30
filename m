Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FC037014C
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhD3Tdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhD3Tdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:33:46 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9272BC06138B;
        Fri, 30 Apr 2021 12:32:56 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z6so10498718wrm.4;
        Fri, 30 Apr 2021 12:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YGxJur6BpkCaw3OzABXrg+qG7M6lysHFEiPjPM8O8jM=;
        b=XbBK4VfeB5HSc9VnsPbCGaLMOUGma5aINBFJEeaHajUizyf/o35ykT8yudbK0WOGRs
         7EbWBY9Y0f16Et0zoxlGpoDFxWbUapu0El35CKgPAXRHwtRVvkQLgtar//qiWYhxKNz4
         39l2EMmUMRIhPnK9jjQxB1YPA/YgzjHRe5QMBCLNeLk4460d1NOwtPiLTAQqObmdSUxq
         uB/wFVzfVbRAxW84BGVd/NwRSCgz8TWy7JVXgvNKDeNFh/yWZVMIk6vcuUVD3jsM6fMT
         QPjev0ngvs7RqRqiNU61+km8kxYP9M2ieCHzn5mOmlUJAq3znWycBeDb46OJgDuuUPU5
         MmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YGxJur6BpkCaw3OzABXrg+qG7M6lysHFEiPjPM8O8jM=;
        b=REfJ54hxvYNUc9owpfZV+eDSiPuO+08p/owZc3c4H0KYY/SD3qFjUUk0S5Jfs8OuB7
         L6mJ4Qv/1+vFEBLvS4/NJCxirqloo4m3z6aMjwDvA1lpgAwNno79rw/flPaSGYkqBTMw
         6aMg/CFgtQxk2Cub/8244esZN4mdrHaOiyeC9F6T/Uxnz3v1wExEc+lt3kK/ZfVlSQMB
         EnTZHCLlxd6zzGOaizy55F79y7ctD3VqHsvPiTPDmdvAI7rrbcNBntacYo0umvF56NJ4
         KPSezAb9EYM3NP7zhqVHwXpOenU2YATfkfsvxrtBcmg32eCtmgM5If5TgRVMVovJbgIU
         yKfQ==
X-Gm-Message-State: AOAM53294UVyAjo48N0zwni7soHi4gTfSOJf0J4rBs3MCoEyCmdjKViv
        mGkVjdwoefW9QwVp+vyuq1871vO4YqEYXQ==
X-Google-Smtp-Source: ABdhPJyhTths+KvVLUS8knCdFfcch3pczopIQyF+cUUbjW4A7vhF++ZfvubKihT1guzh9Wvy0oBFMw==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr9248597wrn.363.1619811174183;
        Fri, 30 Apr 2021 12:32:54 -0700 (PDT)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id m2sm13348394wmq.15.2021.04.30.12.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 12:32:53 -0700 (PDT)
Subject: Re: netdevice.7 SIOCGIFFLAGS/SIOCSIFFLAGS
To:     Erik Flodin <erik@flodin.me>, mtk.manpages@gmail.com
Cc:     linux-man@vger.kernel.org, Stefan Rompf <stefan@loplof.de>,
        "David S. Miller" <davem@davemloft.net>,
        John Dykstra <john.dykstra1@gmail.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAAMKmof+Y+qrro7Ohd9FSw1bf+-tLMPzaTba-tVniAMY0zwTOQ@mail.gmail.com>
 <b0a534b3-9bdf-868e-1f28-8e32d31013a2@gmail.com>
 <CAAMKmodhSsckMxH9jLKKwXN_B76RoLmDttbq5X9apE-eCo0hag@mail.gmail.com>
 <1cde5a72-033e-05e7-be58-b1b2ef95c80f@gmail.com>
 <CAAMKmoe8rUuoxFK2gKZL4um79gmtn-__-1ZDWuBgGTqfqPjZdw@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <ec0d0a2d-235c-a71f-92bc-45e1156bff9e@gmail.com>
Date:   Fri, 30 Apr 2021 21:32:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAAMKmoe8rUuoxFK2gKZL4um79gmtn-__-1ZDWuBgGTqfqPjZdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[PING mtk, netdev@]
[CC += linux-kernel]

Hi Erik,

On 4/29/21 9:45 PM, Erik Flodin wrote:
> On Wed, 14 Apr 2021 at 21:56, Alejandro Colomar (man-pages)
> <alx.manpages@gmail.com> wrote:
>>
>> [CC += netdev]
>>
>> Hi Erik,
>>
>> On 4/14/21 8:52 PM, Erik Flodin wrote:
>>> Hi,
>>>
>>> On Fri, 19 Mar 2021 at 20:53, Alejandro Colomar (man-pages)
>>> <alx.manpages@gmail.com> wrote:
>>>> On 3/17/21 3:12 PM, Erik Flodin wrote:
>>>>> The documentation for SIOCGIFFLAGS/SIOCSIFFLAGS in netdevice.7 lists
>>>>> IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO, but those can't be set in
>>>>> ifr_flags as it is only a short and the flags start at 1<<16.
>>>>>
>>>>> See also https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c
>>>>>
>>>>
>>>> I don't know what's the history of that.
>>>
>>> Judging from commit message in the commit linked above it was added by
>>> mistake. As noted the flags are accessible via netlink, just not via
>>> SIOCGIFFLAGS.
>>>
>>> // Erik
>>>
>>
>> I should have CCd netdev@ before.  Thanks for the update.  Let's see if
>> anyone there can comment.
>>
>> Thanks,
>>
>> Alex
>>

> Hi again,
> 
> Have there been any updates on this one?

No, Noone from the kernel answered.  And I'm sorry, but I'm not sure
what is going on in the code, so I don't want to close this here by just
removing those flags from the manual page, because I worry that the
actual code may be wrong or something.  So I prefer that when Michael
has some time he can maybe review this and say something.  Ideally,
someone from the kernel would also respond, but they haven't.  I've CCd
the LKML; let's see if someone reads this and can help.

Thanks,

Alex

P.S.:  Please, if we haven't responded in a month from now, ping us
again.  Thanks again.

> 
> // Erik
> 
>>
>> --
>> Alejandro Colomar
>> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
>> http://www.alejandro-colomar.es/

-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
