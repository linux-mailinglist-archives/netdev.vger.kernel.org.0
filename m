Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD4E3448A1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCVPFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhCVPFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:05:38 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6CAC061574;
        Mon, 22 Mar 2021 08:05:37 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id m13so13355732oiw.13;
        Mon, 22 Mar 2021 08:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lShD8u5RQT8H+Y6RG8aS0wLbKOJnqql+9+ssZYKSHZY=;
        b=fryP2xTLp8DERYKTu1qa5pcV4K0T6zrHUmv0FX2EDfndgrrXe6DjUoE0m5vO4C7Ja6
         olwI0hXmAFLsVyXzyi00A1O4EafXif5D9Gk12lx33eCfV7ydo1xrrn/sKV8s2VO7/Cln
         u/fcFDDbd9nQa2QlHh9aMpQcG/T40/wBi0EQ1pl91v6lO30JQoj7NfiaIY5pyxnRJ7BI
         /KA/SdZJF348Mg/fvbe9VvGLL+JmdNS44ttvJSGdH/jfjtdbjEjidDwE+zTXcYodA7gz
         c2EXYwMUWWUcDr6hQvUVE2AEEhFOBiaYRNSjeUMxKDK+snm8GgPd3lc/9QV+6POdxqAF
         foLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lShD8u5RQT8H+Y6RG8aS0wLbKOJnqql+9+ssZYKSHZY=;
        b=Oz1OeYtbs5/pJYTgET+0RUbOLVdKREdyEQTb1IcdZcydlB+t46IoYC+IoHS2AGCAcM
         aiarNZ0B3B/9WXYq9MUGYETfurjsSyrumOkryeZeYnMkrnsB2qK9CCTFW89/dZmI0O1u
         dWHNsLJfuqGd2+aEAIDtah64WpqLRlqWT5XEfalt9P0zwi72BpX+Uuk1YI7XbTxb3gDW
         7CWgsR+41UP2rUKyQltJrpDePSLQ0jAUHFXnEzsuWwnxPowrR+rkCIWsNY/g8bVldNa8
         i2Nuv5IrY8OSsK6TAJDJUBs9LMSx6uHRhwgTHGZIhseYLuiqNdATbFVzpX7vCBPKd5QK
         vWNw==
X-Gm-Message-State: AOAM532Ef8Rjb55HbpbyW7z8bqwrgjwoZfSucc9hNwirxNCjgci1I9jy
        kSsUhfXfwQM3rimJXF2GE1A=
X-Google-Smtp-Source: ABdhPJwSJ5TnnKypCu3tUqqa5UjDiKC+45xkNcijxJsvJw3XghjhwPjy2O9ucDZsKZHGszPPrI1k4w==
X-Received: by 2002:aca:c4cb:: with SMTP id u194mr125332oif.74.1616425537381;
        Mon, 22 Mar 2021 08:05:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a6sm3371171otq.79.2021.03.22.08.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 08:05:37 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 10/14] bpf: add new frame_length field to the
 XDP ctx
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
References: <cover.1616179034.git.lorenzo@kernel.org>
 <a31b2599948c8d8679c6454b9191e70c1c732c32.1616179034.git.lorenzo@kernel.org>
 <a5ff68f0-00a1-2933-f863-7e861e78cd60@gmail.com>
 <E467B3B1-4BDD-4366-A218-A60EC45C2C67@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e829b776-f6a6-5b5d-8625-8913986c8036@gmail.com>
Date:   Mon, 22 Mar 2021 09:05:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <E467B3B1-4BDD-4366-A218-A60EC45C2C67@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 3:29 AM, Eelco Chaudron wrote:
> 
> 
> On 20 Mar 2021, at 4:42, David Ahern wrote:
> 
>> On 3/19/21 3:47 PM, Lorenzo Bianconi wrote:
>>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>>> index 19cd6642e087..e47d9e8da547 100644
>>> --- a/include/net/xdp.h
>>> +++ b/include/net/xdp.h
>>> @@ -75,6 +75,10 @@ struct xdp_buff {
>>>      struct xdp_txq_info *txq;
>>>      u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved
>>> tailroom*/
>>>      u32 mb:1; /* xdp non-linear buffer */
>>> +    u32 frame_length; /* Total frame length across all buffers. Only
>>> needs
>>> +               * to be updated by helper functions, as it will be
>>> +               * initialized at XDP program start.
>>> +               */
>>>  };
>>>
>>>  static __always_inline void
>>
>> If you do another version of this set ...
>>
>> I think you only need 17-bits for the frame length (size is always <=
>> 128kB). It would be helpful for extensions to xdp if you annotated how
>> many bits are really needed here.
> 
> Guess this can be done, but I did not too avoid the use of constants to
> do the BPF extraction.
> Here is an example of what might need to be added, as adding them before
> made people unhappy ;)
> 
> https://elixir.bootlin.com/linux/v5.12-rc4/source/include/linux/skbuff.h#L801
> 
> 

I was just referring to a code comment that bits can be taken from
frame_length for extensions - just like the mb bit takes from frame_sz
(and it too has bits available since 2GB is way larger than actually
needed).
