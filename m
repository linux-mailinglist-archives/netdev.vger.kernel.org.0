Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089F33C1B2E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhGHVrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhGHVrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 17:47:41 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77506C061574;
        Thu,  8 Jul 2021 14:44:59 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id p8so9361327wrr.1;
        Thu, 08 Jul 2021 14:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e3c06khZqPC3XSHVb3ebER1HzNExLJ3z79mEUxG26Aw=;
        b=O5TNAOv8t7QOVuHEkg6vBhuHRiYMUtWe+gsyIHnDRlZwDEYTNtSkQ+jeOam02hpBH1
         FR/2BfUmb/w7c6Jd7wCZ1swRl1zZLCgBKHVKE+VHxKoVTF1+5p8e3FS+aY5a3ubXF5OL
         uUWUZ1CXMY0hdTzNEUSFjK+0zSsHJhCnQ6WmdeMMuahWdeFRdZQSQgl7U73jCtHaGryT
         9xIESHSAnSEPR1+T2fAP6zsTDA0Kx/PS/aKeiT+778LsuB7brlb0yB+3ITr1roTy0WMe
         XdjXNQg+OL4y8KaRN5JIfCRlgfg/uIvn9TdZY+CJIH+T7l6rcCisi0WwEGSRBi1OoNOf
         b30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e3c06khZqPC3XSHVb3ebER1HzNExLJ3z79mEUxG26Aw=;
        b=ByYzcVfTvV6plrxxkPrknaRD00/MfrqBqkT11YzERTrICguQGnN4nftimhh96tDTPQ
         wUEOOg6o+sb7jHVMhL6c7Kpdfc6yA1F6i/YNJWUp0CVlCGgF1zBV6PzrXb/hR4GTtSgl
         CNTOZqf7yuY5c8kiOh/06lBjne/QFPwhXgC4W3WOJ99enxAHTSnERce4swUTZrEBueKv
         /skNJsyofA2lLgY8lOAcUrHPKE8ZBEYNdcRE2Z24IQx8d/4u9EWkyGC7MLU/ERt/i/GH
         qZWzcaY59OMWS9PyZ71hoBWGMDm1b0JZbOzIw0vtnfDo+Z0BECGtEpa5OQEO7fpOEph3
         OIWw==
X-Gm-Message-State: AOAM531Om16Dib/z68Atg1Ixp0EE6dcHSXuUYRzD49Nq8UnxYIVBV26f
        dQ0U0uJL0URy6AwvdDdoYLoIXqD0yJk=
X-Google-Smtp-Source: ABdhPJzkNWHTEYW2Lzfj6t8TyywuwZGPF0tx8xHCePCyJL+4l97KRP+rWT6M7f+E0X+tFuu59OAyrA==
X-Received: by 2002:adf:e689:: with SMTP id r9mr18449919wrm.416.1625780697917;
        Thu, 08 Jul 2021 14:44:57 -0700 (PDT)
Received: from [10.0.0.3] ([37.165.255.126])
        by smtp.gmail.com with ESMTPSA id u18sm3014424wmj.15.2021.07.08.14.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 14:44:57 -0700 (PDT)
Subject: Re: linux-next: Fixes tag needs some work in the net tree
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210709073104.7cd2da52@canb.auug.org.au>
 <30e28b44-b618-bdf5-cf4a-dc676185372d@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6e95b490-47d0-a5d0-b729-db2581e73e3c@gmail.com>
Date:   Thu, 8 Jul 2021 23:44:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <30e28b44-b618-bdf5-cf4a-dc676185372d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 11:38 PM, Florian Fainelli wrote:
> On 7/8/21 2:31 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> In commit
>>
>>   9615fe36b31d ("skbuff: Fix build with SKB extensions disabled")
>>
>> Fixes tag
>>
>>   Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
>>
>> has these problem(s):
>>
>>   - No SHA1 recognised
>>
>> Not worth rebasing for, just more care next time.
> 
> It is there though:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984
> 
> and has the proper format AFAICT, what am I missing?
> 

This commit was the first commit, adding the bug.

Your commit changelog had :

    Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Reviewed-by: Roi Dayan <roid@nvidia.com>
    Reviewed-by: Eric Dumazet <edumazet@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

See the extra Fixes: word ?

