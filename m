Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD42D286782
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgJGSjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbgJGSjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:39:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2757C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 11:39:35 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l126so1831019pfd.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Aeu4XnUWo5a9Lyi0KDv1sY5uf0vSSrrLI/ufir8Fw9M=;
        b=uHwHexZf5yaDqKpuq7Zm1JILxGR9lk7CvpVnNgDcmUKS83/5hPTbAmsDVAoHT4L9vI
         bRmGlmBkjMB1gmSRfIpVWNSSfzAThP02JZpgcKGJORuqO912kgDvpoYfdS2uLLmlKq8E
         x9hPlP9DZvD2qWsRahbjt6zj6ZpMxl5l3GQD5cUEnm5gATfV+JOqkDQloLYWBKAD4iyV
         V3T9tjF/080JaNKhN/4EmQf/IE2bOiX512LWb8PgEhmpJpQjhhyhJ6zs5GHbD+xGLBnn
         9njVOVreqxtXMPvNP+FqL2IfhbIfDHQnZwCGD5r+lJcsM3aOEK+nRDdI4cbDdun6eCId
         TKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Aeu4XnUWo5a9Lyi0KDv1sY5uf0vSSrrLI/ufir8Fw9M=;
        b=AiMdBzM7S82lza16v3evnSLNh04o1bKehbawf4DqFxHiCRPm2hmIc341AERQ2HtoBn
         UZSZ/RPk+gKvZsEdk9XZlK+ukBAZJZ9qP+M1Z/sphXZCjZuW22r0B20m1ls7qErEDQvX
         ibXmHy0zyPsChdH7ZTx8H5Ft8QXYYvnjlaiLqavPZ7/3kimx2rygHQeLr67FAT1BVQb2
         ao8V8WKP3gVZulR03DBkR5s7/tYJKwy2kbHMps3v96UU8i+sG2hhuqqCh9cUOpyAxmQp
         PWtTdaKkjkovZpyM4CZ7j3GCrtDMOXb3EozYb3SyMBTlKSnNCMsfjJ4yXq34GdKfkYdE
         NVLg==
X-Gm-Message-State: AOAM531mQLxtwTCcFfT1XcMeXX7ZzZ+e30KCk34olzbGGI2HsRW4rDNR
        ydRg+nGb1IXIKtlbyCW4/o24cy7YXME+Rg==
X-Google-Smtp-Source: ABdhPJyJ4auNddQU1auPk9aWIYz9OtuBMCHHCqtXuSTEUBREIMhPjkFI1bnMPni4YkqITe32I8QpVg==
X-Received: by 2002:a62:158c:0:b029:152:6669:ac75 with SMTP id 134-20020a62158c0000b02901526669ac75mr4040818pfv.5.1602095974867;
        Wed, 07 Oct 2020 11:39:34 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.184.170])
        by smtp.gmail.com with ESMTPSA id z28sm4254698pfq.81.2020.10.07.11.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 11:39:34 -0700 (PDT)
Subject: Re: net: Initialize return value in gro_cells_receive
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Netdev <netdev@vger.kernel.org>
References: <e595fd44-cf8a-ce14-8cc8-e3ecd4e8922a@gmail.com>
 <9c6415e4-9d3b-2ba9-494a-c24316ec60c4@gmail.com>
 <03e2fd9c-e4c9-cff4-90c9-99ea9d3a5713@gmail.com>
 <d1e206e5-7049-82bb-3507-6f0436e47fa8@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <00d334dd-6b48-e0e0-bb8d-b643890f4de1@gmail.com>
Date:   Wed, 7 Oct 2020 11:39:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <d1e206e5-7049-82bb-3507-6f0436e47fa8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/2020 9:37 AM, Eric Dumazet wrote:
> 
> 
> On 10/7/20 5:50 PM, Gregory Rose wrote:
>>
>>
>> On 10/7/2020 1:21 AM, Eric Dumazet wrote:
>>>
>>>
>>> On 10/6/20 8:53 PM, Gregory Rose wrote:
>>>> The 'res' return value is uninitalized and may be returned with
>>>> some random value.  Initialize to NET_RX_DROP as the default
>>>> return value.
>>>>
>>>> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
>>>>
>>>> diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
>>>> index e095fb871d91..4e835960db07 100644
>>>> --- a/net/core/gro_cells.c
>>>> +++ b/net/core/gro_cells.c
>>>> @@ -13,7 +13,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
>>>>    {
>>>>           struct net_device *dev = skb->dev;
>>>>           struct gro_cell *cell;
>>>> -       int res;
>>>> +       int res = NET_RX_DROP;
>>>>
>>>>           rcu_read_lock();
>>>>           if (unlikely(!(dev->flags & IFF_UP)))
>>>
>>> I do not think this is needed.
>>>
>>> Also, when/if sending a patch fixing a bug, we require a Fixes: tag.
>>>
>>> Thanks.
>>>
>> If it's not needed then feel free to ignore it.  It just looked like
>> the unlikely case returns without setting the return value.
> 
> Can you elaborate ? I do not see this problem in current upstream code.
> 
> If a compiler gave you a warning, please give its version, thanks.
> 

No, it's my misreading of the code - it jumps to the drop that is in the
middle of an if statement, sets res to NET_RX_DROP there and then jumps 
to the unlock label.

My apologies.

- Greg
