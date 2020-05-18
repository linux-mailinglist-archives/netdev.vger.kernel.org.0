Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5681D7B4E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgEROcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 10:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgEROcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:32:39 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2636C061A0C;
        Mon, 18 May 2020 07:32:37 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id 18so1081738iln.9;
        Mon, 18 May 2020 07:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gTFX1DQNwBeEvhDCNe+w/mdg1eQLrgIFr7Wfxdb54bo=;
        b=gybNCSr8wur5riIJiDtO9j7Zaq5DCHwnjR7x7kpUwmWCv3nRjCQ2ztoLUMoKWaFdl9
         dbxsZ56cl+vgTpoXhifhjlu6ef+U0U3fR8/LHo/6Kcv4aEKq9cKi6hcDr3bE0XvP1Y/u
         tAti+H04McSI+3r6FgcEq5Qe2/7q/zgTs3/Mp0aCkT43lFfITPgo30ps3huDbSIqIXEe
         F0sxPAfkTI8hJgtHcA+jBVbaYzVvPCTUa1/au3PdYCUL+rVp0km/nMTa7mSa7BvsIchZ
         jvQMGCGLHvS1g59DxMr8WV1uYMN3GW2l8reIZjajxIuL+9UI0HJYwEswGdU7oB0gM2l4
         rGpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gTFX1DQNwBeEvhDCNe+w/mdg1eQLrgIFr7Wfxdb54bo=;
        b=qe1Rm6h9JhRVjTi/qVwoBex8YD69ZFOewoWvvmTINOIjWDhr8Epb1C4MLwNlO/cvq3
         HjXB35ja91Tbiw2QX4JaT9prdtdrjP6PR4qNNcQ6w1yqY1uIAuwwlyawqzEpU2P6FSWQ
         +3YEeeX/TwytrLix8kzN3IamLG8rdMRKBpy/rLsxYBfY/9bbgOLpeZHodlwEG7AesDaa
         HVS1/9HKknR6DSDCjWvTDgglYcZxgxu5Q6t8BX+ZtEx9YZ9+WpSHtD+ZfN7vxyz8A3UT
         KGdKJ8AJMt+MfjbIP0fyE5oynpZ5Pv7Fi3xWhhSFVrAUK++gOx44vxrDX7fLSo7gJ4kl
         32rg==
X-Gm-Message-State: AOAM533aEyF9tI3n0d3TTld6MrFNE+3LzD0fAjF2gh5W44YW8zmlCUYF
        DmhBNP4+kTOcMDGZWinxxgI=
X-Google-Smtp-Source: ABdhPJzP+N6VAlMslLBJq9/URUv1mJX/In/Rz7/h1fi5yhqxLZBwn8EhFBm7pL5xHxo0RFFw2Y70gw==
X-Received: by 2002:a92:8946:: with SMTP id n67mr14129948ild.215.1589812357310;
        Mon, 18 May 2020 07:32:37 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f866:b23:9405:7c31? ([2601:282:803:7700:f866:b23:9405:7c31])
        by smtp.googlemail.com with ESMTPSA id j2sm3962464ioo.8.2020.05.18.07.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 07:32:36 -0700 (PDT)
Subject: Re: "Forwarding" from TC classifier
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com>
 <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
 <5cca7bce-0052-d854-5ead-b09d43cb9eb9@gmail.com>
 <CACAyw9-TEDHdcjykuQZ8P0Q6QngEZU0z7PXgqtZRQq4Jh1_ojw@mail.gmail.com>
 <b212a92c-7684-8c47-1b63-75762c326a24@gmail.com>
 <CACAyw9_cGqTs5JW2QyqnTm-M3khieMa7XwD3vqNiXWxRepmqMg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a2a496b1-59a7-87ce-75f4-c9b43e23ff6a@gmail.com>
Date:   Mon, 18 May 2020 08:32:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CACAyw9_cGqTs5JW2QyqnTm-M3khieMa7XwD3vqNiXWxRepmqMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 3:38 AM, Lorenz Bauer wrote:
> On Fri, 15 May 2020 at 15:24, David Ahern <dsahern@gmail.com> wrote:
>>
>> On 5/15/20 3:59 AM, Lorenz Bauer wrote:
>>>
>>> Yes, but that doesn't play well with changing the source address to
>>> the local machine's, since the upper part of the stack will drop the
>>> packet due to accept_local=0.
>>
>> Can you defer the source address swap to the Tx path? Let the packet go
>> up the stack and do the fib lookup again as an skb. neighbor entry does
>> not exist, so the packet is stashed, neighbor resolution done, once
>> resolved the packet goes out. tc program on the egress device can flip
>> the source address, and then subsequent packets take the XDP fast path.
> 
> Hm, that's an interesting idea! I guess this means I have to mark the packet
> somehow, to make sure I can identify it on the TX path. Plus, in theory
> the packet could exit via any interface, so I'd have to attach classifiers to
> a bunch of places if I want to be on the safe side.

Shared blocks might save you some overhead. Create a filter block that
is shared across devices.

> 
> Upside: this seems doable in current kernels. Downside: seems more fragile
> than I'd like.
> 
> Thanks for the thought, I'll play around with it :)
> 
>>
>> If the next host is on the same LAN I believe the stack will want to
>> generate an ICMP redirect, but that can be squashed.
> 

