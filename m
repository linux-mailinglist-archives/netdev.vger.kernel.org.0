Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42FF344DA2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhCVRmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhCVRlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:41:39 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FB9C061762
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:41:39 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z136so14822353iof.10
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cFGfgA15yCvg5nxOaSdeBAMBjRJ6Sj1F+vc4dD4Jyeo=;
        b=gU9aJk+/fYJ32a0U+/JmRp/NAxFYPbmwcBLoJM6tOTylt9Y55pYiW+s1dTL45j/vtM
         PnaB50jmUmSieTtZyLhsrERXgTkSFYTOT9ifTil4c6k0X1qyIWOi6KeKIWpwQVaxA2zO
         l4NayK/Iwea4TCCHxFDZDaP+HzrYurxStF7TY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cFGfgA15yCvg5nxOaSdeBAMBjRJ6Sj1F+vc4dD4Jyeo=;
        b=lTam4CQxKEcsV+K6MjTrqlS+OMEdRi3JzlY10GQ5XU0YeIFd8DBkpI0VaYIP7QTNu7
         2JdPAosLEJigjcrjn6Oa1pzz5XO+MThjiienIn4RWE2KL6fz9fZXI4+AhfnTz8a9kS0M
         LUMRPTWXZEt7odaRE2HCEXZgM3JBQJRuSY7vSzBiw16XiEH+kQLXp13Iw3WRlM13qm2m
         KdtUhLnkfWJVDswWg1mJLPo0tgjlKrAjvddhPxQ+K+A0/gmy8NjeekmJzHIC8/1dx3WH
         3yxPjDazDHSfEKM+RNm9795x0Z21uHzSotp5ZKO0GqpyjDt3wvXfQxufnsfWqnRkOmG/
         Naag==
X-Gm-Message-State: AOAM5327Zar1k+UdoPIXJIQns038xhu7lk9Rk4NiHwkJ0v2FV3VASzts
        oE7fQTZJ4FmEAU3a0gx+2+J0tg==
X-Google-Smtp-Source: ABdhPJxYA11jm5sybKyGQkMfmu5eOiUXZhrvlZGwOE0hePOcH4C7qiYfFe/bFNKAqe83ZLNk38kiHw==
X-Received: by 2002:a05:6602:82:: with SMTP id h2mr762438iob.20.1616434898772;
        Mon, 22 Mar 2021 10:41:38 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id o15sm8281983ils.87.2021.03.22.10.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 10:41:38 -0700 (PDT)
Subject: Re: linux-next: Tree for Mar 22 (net/ipa)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Elder <elder@kernel.org>
References: <20210322185251.66566cfd@canb.auug.org.au>
 <83366bbc-af28-4ffd-2a25-f688a52f9239@infradead.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <33380a70-c594-cefe-14b8-c1fbf2dd90af@ieee.org>
Date:   Mon, 22 Mar 2021 12:41:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <83366bbc-af28-4ffd-2a25-f688a52f9239@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 12:16 PM, Randy Dunlap wrote:
> On 3/22/21 12:52 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Warning: Some of the branches in linux-next may still based on v5.12-rc1,
>> so please be careful if you are trying to bisect a bug.
>>
>> News: if your -next included tree is based on Linus' tree tag
>> v5.12-rc1{,-dontuse} (or somewhere between v5.11 and that tag), please
>> consider rebasing it onto v5.12-rc2. Also, please check any branches
>> merged into your branch.
>>
>> Changes since 20210319:
>>
> 
> 
> on i386:
> 
> ld: drivers/net/ipa/gsi.o: in function `gsi_ring_alloc':
> gsi.c:(.text+0x926): undefined reference to `__umoddi3'

This code assumes a 32-bit kernel implies a 32-bit dma_addr_t.
But it seems that's not the case for i386...

Let me try to reproduce this.  The fix should be easy.

Sorry about that.

					-Alex

