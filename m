Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA93225DFD1
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgIDQaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgIDQav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:30:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E12DC061244;
        Fri,  4 Sep 2020 09:30:51 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t16so6832329ilf.13;
        Fri, 04 Sep 2020 09:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AucqkqOTnevc2PIKOu4c21DStTgschtt1uKUphcYlKE=;
        b=MFYN0XWJ+ULODIKnOj1t9aUH5WrufIKOvg/5h8CMiwjm7XwOoofhOSoi2qOp/AoPZT
         ZP/deBWdhXfhTqUBqiGyxYmhiDHl8sBksqLMYMT/l4Rq7N4MkyIt8y2mTCAKtVcUtRJt
         Vupt21q9xmeL95D67gfrCsjAyjL/ofCG4agHdxs81IEgjZ++EBPIO3R487LIMWIpuRTP
         d2Md0fqkOC8KAxdfgj71b9hJSxd6w/eCqQ1u4fEznP2YILj2Q8b5eT5I55lDgbkvTNmg
         ZwFT948OSZVBa0su9qHi8eyFE9MbZV5q4ac5W0VZkDAYKlnCgqBMChBXl3Yz0tcL+Mkl
         +lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AucqkqOTnevc2PIKOu4c21DStTgschtt1uKUphcYlKE=;
        b=CfPMM+AhK0Q0Py4hKAT18zO1qWwJoox4/dBhFQJ7uncN3u/6XqxD/dvYADaZH7B1w7
         HE7bQNbC34SGjyD0I+EI8k2m+w4qVP8aoRV4+GQrTgqKRdIlzYd3B/XMjtqCEetfkQx4
         j6EdYjZkqc3lWf/FE9OALyBjFuLCGo7kNlPk84vNynsUGb3NjDHXTxCKqnFCM6nxt3x5
         SGtnJGGmqi0OXgoj0RxTMGhbUaocnqD8D9FS6Dsz53CK/saTcp9nbmjOlPLk8Aikp+We
         9fZiFHq2jDwJ9a9ObBOdos3XIlfx1PRye9I4r61yxmSVaiJpAWlQttitohNOsWd4UIFI
         AQ5A==
X-Gm-Message-State: AOAM530nTwTnM0zgxCsvPv2YxT4u64P4ZrjP0f0R+CAsiAJoHEqKfGmi
        oPTIrAZWO4C4XYpxbkDSHMI=
X-Google-Smtp-Source: ABdhPJzzA8eSlAyBMn/5v3iWfyqD/oFQof/S134rdB6qL0SSWNSKiqvrzdSeu3LrVsWHh/Hhpt/Ggw==
X-Received: by 2002:a05:6e02:ed1:: with SMTP id i17mr8563170ilk.8.1599237050590;
        Fri, 04 Sep 2020 09:30:50 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:de4:1e22:81ff:2d93])
        by smtp.googlemail.com with ESMTPSA id z4sm2341690iol.52.2020.09.04.09.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 09:30:50 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        David Ahern <dsahern@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
 <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
 <20200904091939.069592e4@carbon>
 <1c3e478c-5000-1726-6ce9-9b0a3ccfe1e5@gmail.com>
 <20200904175946.6be0f565@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <107260d3-1fea-b582-84d3-2d092f3112b1@gmail.com>
Date:   Fri, 4 Sep 2020 10:30:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904175946.6be0f565@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 9:59 AM, Jesper Dangaard Brouer wrote:
>> dev_rx for example seems like it could just be the netdev
>> index rather than a pointer or perhaps can be removed completely. I
>> believe it is only used for 1 use case (redirects to CPUMAP); maybe that
>> code can be refactored to handle the dev outside of xdp_frame.
> 
> The dev_rx is needed when creating an SKB from a xdp_frame (basically
> skb->dev = rx_dev). Yes, that is done in cpumap, but I want to
> generalize this.  The veth also creates SKBs from xdp_frame, but use
> itself as skb->dev.
> 
> And yes, we could save some space storing the index instead, and trade
> space for cycles in a lookup.

I think this can be managed without adding a reference to the xdp_frame.
I'll start a separate thread on that.

>>
>> As for frame_sz, why does it need to be larger than a u16?
> 
> Because PAGE_SIZE can be 64KiB on some archs.
> 

ok, is there any alignment requirement? can frame_sz be number of 32-bit
words? I believe bit shifts are cheap.
