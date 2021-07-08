Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00063C1B34
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhGHVsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhGHVse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 17:48:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B50BC061574;
        Thu,  8 Jul 2021 14:45:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p17so3390508plf.12;
        Thu, 08 Jul 2021 14:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=unimzu0XAveKj8zrSg6I5RmfEQpBWzpdBUGIusVQD/M=;
        b=nFh8ab2Z9FF1OogJgAaHxaLArJCU2nLYJSEoAaLaX1fHoUwTrveWuGqaEcb9t19Fuk
         2TvGciPLKkLRow61/02Q/yzn58rKdVqD13ULDsgJhQUmCze8z8TPqo9meSQ/fZjIBmCp
         Kr+IZ0wmelriRvZPh805NTipBTuMWFGTcqMRKcjRTSqR9Lrkq5oFjJqK1JfbBiQAgAG0
         yhqWS0ZlO7E+Ll7XSvmQ9dYRwtwOAxB1+cORCGUm7WcjQZJOmLUghi55UvTXfdB0S9OA
         E2iN1ewn771J5QEvoh73TlLpT3CGTjEAagSbXlpW71tUfD7Nfg14g70I+BblJeyL2H5C
         XLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=unimzu0XAveKj8zrSg6I5RmfEQpBWzpdBUGIusVQD/M=;
        b=l0+WKlugUCWhuR9nJC92TXqok3iLk5K08R+SvQ+Bvk/u1WKUk5242TWQcMBMjeiddw
         zw8DMAwhH90TZZOVL2aAbEHXlXhtGaG7qOdxvqk1ivQxNOp01l1HNP2OuTvyfD4H0JdD
         UHwXQMpc+iewvujUWJ0T4Rgw80oVV8RsDJKdrtNFzWjdE+zNFc+wfyw2ZZuLVkBTaR6M
         hs3sbEdU75Nu5W4t6Zld5AbyWEdOp+vSd7+9p5YhRF0NBOgxWh2LXJabv9IJWuFfTRqH
         CU2LRfrZ+J2i6fkGxaVG2hW7eMI3Jmc/X30TLgxADSI9dvYZeCe3m0ESQDGzX8He/ZtR
         dONw==
X-Gm-Message-State: AOAM5314Ziyv4bjRhCGarVndhHV4Vk0z7bzwikSEykI2xmUYcrruWTb9
        bVUFQEE3t2ye+aP1UrRBBpdOaKk36r/qtg==
X-Google-Smtp-Source: ABdhPJxsCk3wl/+j5QEwUngwfZUBYABgijhZXbMcdWaFEkg19qeByjqFR1a7peE4Xgkmguo2LiJXuQ==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr31249525pjq.58.1625780751478;
        Thu, 08 Jul 2021 14:45:51 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w14sm3360432pjb.3.2021.07.08.14.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 14:45:50 -0700 (PDT)
Subject: Re: linux-next: Fixes tag needs some work in the net tree
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210709073104.7cd2da52@canb.auug.org.au>
 <30e28b44-b618-bdf5-cf4a-dc676185372d@gmail.com>
 <6e95b490-47d0-a5d0-b729-db2581e73e3c@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <aa475f3f-339a-59b1-d92d-aa0748838c45@gmail.com>
Date:   Thu, 8 Jul 2021 14:45:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6e95b490-47d0-a5d0-b729-db2581e73e3c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 2:44 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/21 11:38 PM, Florian Fainelli wrote:
>> On 7/8/21 2:31 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> In commit
>>>
>>>   9615fe36b31d ("skbuff: Fix build with SKB extensions disabled")
>>>
>>> Fixes tag
>>>
>>>   Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
>>>
>>> has these problem(s):
>>>
>>>   - No SHA1 recognised
>>>
>>> Not worth rebasing for, just more care next time.
>>
>> It is there though:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=8550ff8d8c75416e984d9c4b082845e57e560984
>>
>> and has the proper format AFAICT, what am I missing?
>>
> 
> This commit was the first commit, adding the bug.
> 
> Your commit changelog had :
> 
>     Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
>     Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>     Reviewed-by: Roi Dayan <roid@nvidia.com>
>     Reviewed-by: Eric Dumazet <edumazet@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> See the extra Fixes: word ?

Doh! yes, sorry about that.
-- 
Florian
