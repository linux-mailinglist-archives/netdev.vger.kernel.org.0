Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1296A35309E
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbhDBVMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBVMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 17:12:42 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B6C0613E6;
        Fri,  2 Apr 2021 14:12:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r14-20020a05600c35ceb029010fe0f81519so1359997wmq.0;
        Fri, 02 Apr 2021 14:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tTUez4RwARNAYAsQH55/64iDQIBL79zgC/RBPHPmQlo=;
        b=hZssZsyWk2JzvamYPDFdjRAwzhT+5YhUsi5MUM8C3MwtR/dhwC4WEXT1RHxbmAtuDB
         yOk8O05m6uwJ1Ekut7sAKveZlRs0Lh3oaA94X7gYQ8APkPDYhp2RqJsOH+T99s5IMfP7
         CUO7rU90F7REvV6NtXi7/ZcW2KdZrzpxRRcO2/doGLlOEQiLx0TlMyrTr+OMrV8fJjsN
         YflQz5MPkKKawkq5WxNVQEtbfUt7l7p9ab1rxWdeBP3LyzWbC/4HUeCiPaS3BmP+6byE
         JcnMSVFYleTiP9pSX46bL8daiSjEnyw8rOAPNQo9Uq2T5B5a2c8A6mbCQ2BLDv1yHqoa
         q4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tTUez4RwARNAYAsQH55/64iDQIBL79zgC/RBPHPmQlo=;
        b=YRPBDFz2C+V8PijLJHR+WNr01tYG7ao3EqhasS4shLhmHomQTlnXtvO0gxPzE3aCQ8
         s3Xd3HaOEwQXQsVVWKjvKmbZsGpfKLxg/Y4wfbrbCrtdcfxvjewUwjhHB4wWjPbUVTY+
         i+5BagPJ/2qBuyk6RvXFi9pAYMenulVBHdNQxFy35ml66+losel8/Bb45q8AdGWd/ySp
         MxCC6I6YQ8v6vXd6JXJu+8uv3TtOXr93rFFPqxxRvRFBP1HIjFlTxKDJgGYgXAsDFFhO
         rTZkI2t7tpfI9Gf2rjM21esV4CRxOXHF0YqQM8CpK+xUTqAg4+oSAeZsNTkHBqqpkASh
         Yp6Q==
X-Gm-Message-State: AOAM530/OM3x9M5KCobL9OcASDQWRiCOQILwQJPVqRnMRv0YHTkdZieg
        V71IWWOiMxcjcU7Et2J1k353v8iV6h0=
X-Google-Smtp-Source: ABdhPJzdJM2Tac4u5/0S9qhkA6wOn1mc7qh9xbqvJxcaIxo5rzWpTzm9fAWL2dAg/megGPfx8K3sEQ==
X-Received: by 2002:a1c:750d:: with SMTP id o13mr14416272wmc.76.1617397958718;
        Fri, 02 Apr 2021 14:12:38 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.24.151])
        by smtp.gmail.com with ESMTPSA id y18sm16332476wrq.61.2021.04.02.14.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 14:12:38 -0700 (PDT)
Subject: Re: [PATCH] net: initialize local variables in net/ipv6/mcast.c and
 net/ipv4/igmp.c
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210402173617.895-1-phil@philpotter.co.uk>
 <d2334631-4b3a-48e5-5305-7320adc50909@gmail.com> <YGdeAK3BwWSnDwRX@equinox>
 <37f4c845-e63b-87b8-29ec-b28d895326cd@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <05c984b6-140d-112e-9151-4aea6e8e5a80@gmail.com>
Date:   Fri, 2 Apr 2021 23:12:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <37f4c845-e63b-87b8-29ec-b28d895326cd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/21 10:53 PM, Eric Dumazet wrote:
> 
> 
> On 4/2/21 8:10 PM, Phillip Potter wrote:
>> On Fri, Apr 02, 2021 at 07:49:44PM +0200, Eric Dumazet wrote:
>>>
>>>
>>> On 4/2/21 7:36 PM, Phillip Potter wrote:
>>>> Use memset to initialize two local buffers in net/ipv6/mcast.c,
>>>> and another in net/ipv4/igmp.c. Fixes a KMSAN found uninit-value
>>>> bug reported by syzbot at:
>>>> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
>>>
>>>
>>> According to this link, the bug no longer triggers.
>>>
>>> Please explain why you think it is still there.
>>>
>>
>> Dear Eric,
>>
>> It definitely still triggers, tested it on the master branch of
>> https://github.com/google/kmsan last night. The patch which fixes the
>> crash on that page is the same patch I've sent in.
> 
> Please send the full report (stack trace)

I think your patch just silences the real problem.

The issue at hand is that TUNSETLINK changes dev->type without making
any change to dev->addr_len

This is the real issue.

If you care about this, please fix tun driver.

