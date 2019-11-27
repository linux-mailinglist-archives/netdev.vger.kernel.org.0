Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F0A10ABD9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 09:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfK0IdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 03:33:24 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:46324 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfK0IdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 03:33:24 -0500
Received: by mail-wr1-f49.google.com with SMTP id z7so22155828wrl.13
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 00:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MDOu8C9EhOORy8aSKVxpr8WiKo/sC5zdKCYKyS5LaP8=;
        b=TprLwZWEinADaUKb4wK5FfA6aZ3uBW3jphh/AEmRP0oRcO6epmgOWVxKtDnS7b4LHC
         rkNfhhrUNBYXpJHLrLv4Wqie9TufXRm+n4aFx1k0ZgMFwBH42OMGSjdRBRaK/PHPzdk+
         V5uXyN+xiCSsnewBoyDGxlXMoTrRzj5NHTHRHVBW1uTDlsC1lpVaqWPqKoKoVDHpxBQz
         pWiqfMnVebdNnVHa4TEKBenubxj72UlmvPsaHTlAh29uGAAH/v1Ieigbmyqn6OOBuK37
         EXmOsgs3bXZmUr8VXudkSPtYUqY8EazteHni3y4dxAssIXgkuACPZN9SWwLZQxasMKr2
         BEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MDOu8C9EhOORy8aSKVxpr8WiKo/sC5zdKCYKyS5LaP8=;
        b=OkjuX+cBu7WRtvuj4SgMLH1c6SBpsynRgXoW/uHyu9ATuohImseJYDTUNQzdMu3+q5
         T/lKGf06tPxTC+6HyN6b/r7qiWglniGXarh865Zo0WUD7lhbdQ++YayKGqd1yrZaXFx2
         kQxbnL8ayuWRDTnKpc5e9fZsQqLB/iClh+yBzuUaGBIhgjK4FpXJcdAUBXdXPCQdMZVK
         GrjPe+ZK8HMBFHTXDJzO5FFQ9hz2PE5Cu6idYu8Ie/JNA2LikZ+xQa/n3P2TzHMS9Qab
         P7LGWpOSW8uEknEPOm1WsthwRKQ4yLNDSowFAcz0R3mcHuV0enD0mNLvNFc2IsJvyQ2W
         akXQ==
X-Gm-Message-State: APjAAAXnrjtD8bsOTmLzn9qAWw5R+2Zzp1Hdr4XL9g+GgKDVtNEq1x23
        ul4xRW3kXB5H7zHKZDdfO3nOhxfwSMk=
X-Google-Smtp-Source: APXvYqxslEInMCE2mXojYFIq+FU6lX5nubBZMcGFnfVuF4fyLh3Yh1CDwce0Fk2/HHjmSZqukkEFkQ==
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr33455666wrr.324.1574843601717;
        Wed, 27 Nov 2019 00:33:21 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:b4f0:78b2:530e:92a? ([2a01:e0a:410:bb00:b4f0:78b2:530e:92a])
        by smtp.gmail.com with ESMTPSA id r2sm6208604wma.44.2019.11.27.00.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 00:33:21 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: xfrmi: request for stable trees
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
References: <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
 <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
 <20191124100746.GD14361@gauss3.secunet.de>
 <20191124.190249.1262907259702322148.davem@davemloft.net>
 <20191126081221.GA13225@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <cf265f64-ad9a-b47f-a1ff-5f7634c2cec5@6wind.com>
Date:   Wed, 27 Nov 2019 09:33:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191126081221.GA13225@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/11/2019 à 09:12, Steffen Klassert a écrit :
> On Sun, Nov 24, 2019 at 07:02:49PM -0800, David Miller wrote:
>> From: Steffen Klassert <steffen.klassert@secunet.com>
>> Date: Sun, 24 Nov 2019 11:07:46 +0100
>>
>>> On Mon, Nov 18, 2019 at 04:31:14PM +0100, Nicolas Dichtel wrote:
>>>> Le 14/10/2019 à 11:31, Nicolas Dichtel a écrit :
>>>>> Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
>>>>>> 1) Several xfrm interface fixes from Nicolas Dichtel:
>>>>>>    - Avoid an interface ID corruption on changelink.
>>>>>>    - Fix wrong intterface names in the logs.
>>>>>>    - Fix a list corruption when changing network namespaces.
>>>>>>    - Fix unregistation of the underying phydev.
>>>>> Is it possible to queue those patches for the stable trees?
>>>>
>>>> Is there a chance to get them in the 4.19 stable tree?
>>>>
>>>> Here are the sha1:
>>>> e9e7e85d75f3 ("xfrm interface: avoid corruption on changelink")
>>>> e0aaa332e6a9 ("xfrm interface: ifname may be wrong in logs")
>>>> c5d1030f2300 ("xfrm interface: fix list corruption for x-netns")
>>>> 22d6552f827e ("xfrm interface: fix management of phydev")
>>>
>>> I'm ok with this. David does the stable submitting for
>>> networking patches usually. So I guess he will pick them
>>> into his stable queue after the patches are mainline some
>>> time.
>>
>> Steffen you can submit things directly to -stable for IPSEC if you
>> wish, and it would help me in this case.
> 
> Ok, can do that, no problem.
> I'll submit these and do all the future IPSEC -stable submits directly.
> 
Thank you Steffen!
