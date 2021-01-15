Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F8E2F8519
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbhAOTHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733257AbhAOTHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:07:09 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCEDC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 11:06:27 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id h1so4453616qvy.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 11:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2oTqSZWmGFn4uIF4dTo2Qt3JtJ91jTFvQ59iuEPUHHI=;
        b=SSuqwRfLPHGC1TlMCVY8VQkfVimi7W6CXtR99MoJhJoPINoEEVIn+TJAdfNJX+H2OZ
         b6nI7AkDzgi3kmHkGh2LaH7LAXoemq6q9645Ybibs113+CFkgpOLXbW7Ht+RAThVES+5
         Q4CRJDqGvCz0VTqZe3eu6NY0mz1iLURiKSjUtspePXA8nTCNqN7EpqCcAfsDZ70lzZRd
         NnAZ3a+l0siAAgP4o4PMm97X90RVzCPAXhNlz+SrgcpTq8GVuIUDysl6iDtg9vpf3P0w
         a2U03o1Or5cLa5wEtLIVJZppbL/DUWFmcP1pMQiJnCtE+l+bVbW3iFZKjMGY8loNi+hM
         tqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2oTqSZWmGFn4uIF4dTo2Qt3JtJ91jTFvQ59iuEPUHHI=;
        b=V5gZpJjd/kMMc669su5Kp6Nlo9mFXu2FNotH5pJiT4HcS6PN8xGRYMq0LHTM0UkpCa
         qOzF6nVUeXrg224Ael1J0nU/nTgypGiPIeb3VqeN/3SDcYKHnFSX26VfArlr0A090DQp
         B8Q375HaW+2n3oQmCcNFzZQfaGkZAbRvsg85S4PtDiIQFNM6r6tWDvzTSEzOm03NbYfd
         1vWMGDwvVjiZP9C7LHQMEi5zUwh9Y6W6Ues5IKyN4HFbBTocGI4potdJuuFXzGfoo2f3
         01HDEE5GC+A2BY3BSPCKL86K6LIZrYBu2fNoWsKDyt2bxxAaswDiDPAHddCW07LwM2yz
         2Z9g==
X-Gm-Message-State: AOAM532miGqFh2/cQW5dfJwydUI9SsTpEGJITn2Vkkw+XA4lSz2VLshQ
        6S3HeyZ7lmD8qdJmnaduxk4+7A==
X-Google-Smtp-Source: ABdhPJxvlKMuAk6M6Tn0B9g6JBLSuEH6yxTEv2lhYs5U6DY59LPBruSyV35z9t5VbuDKu7R+eG8l5g==
X-Received: by 2002:a0c:ebc2:: with SMTP id k2mr13586529qvq.24.1610737586499;
        Fri, 15 Jan 2021 11:06:26 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w33sm5522728qth.34.2021.01.15.11.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 11:06:25 -0800 (PST)
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI interrupt updates
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>, davem@davemloft.net,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210113171532.19248-1-elder@linaro.org>
 <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
 <20210114180837.793879ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7cce0055-3fd3-693b-b663-c8cf5c8b4982@linaro.org>
 <20210115105908.64cfabeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <0e714128-c47f-72ab-7e88-f706c642a4dd@linaro.org>
Date:   Fri, 15 Jan 2021 13:06:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210115105908.64cfabeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 12:59 PM, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 04:42:14 -0600 Alex Elder wrote:
>> On 1/14/21 8:08 PM, Jakub Kicinski wrote:
>>> Dropped the fixes tags (since its not a series of fixes) and applied.
>>
>> Thanks for applying these.
>>
>> Do you only want "Fixes" tags on patches posted for the net
>> branch (and not net-next)?
>>
>> I think I might have debated sending these as bug fixes but
>> decided they weren't serious enough to warrant that.  Anyway
>> if I know it's important to *not* use that tag I can avoid
>> including it.
> 
> The point of the tag is to facilitate backporting. If something is
> important enough to back port is should also be important enough
> to go to net, no?

Yes, agreed and understood.	-Alex

