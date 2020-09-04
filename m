Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888925DD03
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgIDPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730727AbgIDPPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:15:11 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE85C061244;
        Fri,  4 Sep 2020 08:15:11 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b17so6664868ilh.4;
        Fri, 04 Sep 2020 08:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Qa8fhc7JYJpC9lwMaaW4xA5K2UzS0TV73tMcjhZtCs=;
        b=S9i3O95rePrpmaPLkcBFOXSi5iPZLI9WNOCAgO2DHStDf/Do/RF1f+Ern5MeQUeFoQ
         ssMXmQmtcsqQLTUspcXKt97H438pQPTjmjcpWR0Ixc66RldWFU2L2Te+pZM2Mlay891Y
         89iMH3dVqyJKSeii9XiRDHokMgFocnz6JgvmdNJGo6ZnkmskMGbX4EZlDMNM9v0WCdW2
         pyKuMBX1Z7UJBrCkI4gjHVTKU6A0ZZfWsbFG03lZl8holxYqUIhdQPaE3xCEUnHHGOf4
         a4MsRKZusmvZhaNSDx3CBFelGuPPOl9sioa2SdRnH+SIN+cLpPCsLJN33xgj7CQ7rGsd
         brQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Qa8fhc7JYJpC9lwMaaW4xA5K2UzS0TV73tMcjhZtCs=;
        b=lH8TXlShukvqABCpfqRX7JnNsi88xyqehPg5RJHS4tpWAkBKtSdOFhLqo2vrPURBHn
         u37ZlA1JBX5IiB2V1HvYYHl8xCNbnWUayh2D4VZp4qLlnuejnqX0ZjI/ZxI+iBF3cb79
         s06KdYue6WPfpw69yj8ZIjo4K259fV/hinP+TVjC6xRUfN3fkBl7TTL8+ryMMuGjWdYH
         0C7MJ6lO2bwU38PxW/C7ZZ/GvWsTIg4NA2d5K7Sc0M3aPu66Wq9LdEw4r3fIXvYak73R
         uoyn6nsRWsw3KoEkS70bSFO7dT7oxtVWNtQvCHJ+EAcBu5IPZM/rnhTYriXirLxUtGBS
         g24w==
X-Gm-Message-State: AOAM530QkZoszIokxA4yg7NtvtJHf9Jw/IHrrz8v5qMgknIN7Xi78P9X
        6DYKxJkDD5FlTcbyUC2iPTI=
X-Google-Smtp-Source: ABdhPJxlThJea46SCuuurcn+15CuwfdbIJxQSquibYLRfx/GtvZI809KLZHt+vd2k47FuYUVD1rR5w==
X-Received: by 2002:a05:6e02:cd4:: with SMTP id c20mr8878530ilj.0.1599232510015;
        Fri, 04 Sep 2020 08:15:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c464:3333:84b2:9eff])
        by smtp.googlemail.com with ESMTPSA id 2sm3196562ilj.24.2020.09.04.08.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:15:09 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
 <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
 <20200904091939.069592e4@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1c3e478c-5000-1726-6ce9-9b0a3ccfe1e5@gmail.com>
Date:   Fri, 4 Sep 2020 09:15:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904091939.069592e4@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 1:19 AM, Jesper Dangaard Brouer wrote:
> On Thu, 3 Sep 2020 18:07:05 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
>> On Thu, Sep 03, 2020 at 10:58:45PM +0200, Lorenzo Bianconi wrote:
>>> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
>>> if shared_info area has been properly initialized for non-linear
>>> xdp buffers
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>  include/net/xdp.h | 8 ++++++--
>>>  net/core/xdp.c    | 1 +
>>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>>> index 3814fb631d52..42f439f9fcda 100644
>>> --- a/include/net/xdp.h
>>> +++ b/include/net/xdp.h
>>> @@ -72,7 +72,8 @@ struct xdp_buff {
>>>  	void *data_hard_start;
>>>  	struct xdp_rxq_info *rxq;
>>>  	struct xdp_txq_info *txq;
>>> -	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
>>> +	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
>>> +	u32 mb:1; /* xdp non-linear buffer */
>>>  };
>>>  
>>>  /* Reserve memory area at end-of data area.
>>> @@ -96,7 +97,8 @@ struct xdp_frame {
>>>  	u16 len;
>>>  	u16 headroom;
>>>  	u32 metasize:8;
>>> -	u32 frame_sz:24;
>>> +	u32 frame_sz:23;
>>> +	u32 mb:1; /* xdp non-linear frame */  
>>
>> Hmm. Last time I checked compilers were generating ugly code with bitfields.
>> Not performant and not efficient.
>> frame_sz is used in the fast path.
>> I suspect the first hunk alone will cause performance degradation.
>> Could you use normal u8 or u32 flag field?
> 
> For struct xdp_buff sure we can do this.  For struct xdp_frame, I'm not
> sure, as it is a state compressed version of xdp_buff + extra
> information.  The xdp_frame have been called skb-light, and I know
> people (e.g Ahern) wants to add more info to this, vlan, RX-hash, csum,
> and we must keep this to 1-cache-line, for performance reasons.
> 
> You do make a good point, that these bit-fields might hurt performance
> more.  I guess, we need to test this.  As I constantly worry that we
> will slowly kill XDP performance with a 1000 paper-cuts.
> 

That struct is tight on space, and we have to be very smart about
additions. dev_rx for example seems like it could just be the netdev
index rather than a pointer or perhaps can be removed completely. I
believe it is only used for 1 use case (redirects to CPUMAP); maybe that
code can be refactored to handle the dev outside of xdp_frame.

xdp_mem_info is 2 u32's; the type in that struct really could be a u8.
In this case it means removing struct in favor of 2 elements to reclaim
the space, but as we reach the 64B limit this is a place to change.
e.g., make it a single u32 with the id only 24 bits though the
rhashtable key can stay u32 but now with the combined type + id.

As for frame_sz, why does it need to be larger than a u16?

If it really needs to be larger than u16, there are several examples of
using a bit (or bits) in the data path. dst metrics for examples uses
lowest 4 bits of the dst pointer as a bitfield. It does so using a mask
with accessors vs a bitfield. Perhaps that is the way to go here.

