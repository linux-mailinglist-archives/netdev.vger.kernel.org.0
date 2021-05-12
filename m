Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055E437EE7A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhELVvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:51:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40399 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344934AbhELUYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 16:24:24 -0400
Received: from mail-vs1-f69.google.com ([209.85.217.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgvNk-0005kz-Pr
        for netdev@vger.kernel.org; Wed, 12 May 2021 20:23:00 +0000
Received: by mail-vs1-f69.google.com with SMTP id k8-20020a67c2880000b029022833ef2244so11598443vsj.18
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 13:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9gJsXnEr4ZIoyQYIBIzO2lxuT2xnUGyt9hpWeVeGi8I=;
        b=YAUOTfIlZMWghMI+V/Cvobm241KmCbXD7qifHmjAcwN7lla7rbWixBo1pvQE9XB0Pn
         MRdC6Wt4QztD4Huq3EovFNSvNEEa72dUDnZBtiPo/+yFuz248yAgXLglgBt2eGlyfzmF
         YNpxgDKJZE/hBKTntGK7T31n3thWpxXIlvQKRLWFhI9e1+Dbh3T+VyFYPEXtrbgVUkDk
         3GE5KCNPFC2zZKdtSUVFuTO2tNz27J6GWBKkLahWRCn0c1cwdc88K9CfeBvvNVifmVB6
         cW6Xjc4igBiJfu3EcB9/yh6ArWxh1mxGRiCWamUcnN4hjGdHpTZMVFirgswECz31lEBG
         uKmA==
X-Gm-Message-State: AOAM533kySV0FKHHila7llywJ+Ge/z+yN2Up3eseRQcJna8Oc/5H90Yz
        M7G98V8yTjVI0A9/dOhFF7Iuz7PPoHFVJ8wcugquMoAnCMx5xtGIElH7DfBTvLRp/gAi35dPSTY
        ZvQJDFM/n2tQvzDhubFTkdatnm0KWnPzLlg==
X-Received: by 2002:a67:ee4e:: with SMTP id g14mr35358345vsp.37.1620850979958;
        Wed, 12 May 2021 13:22:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzo1HcgGvTIwADZqFT4FFfzTBlNKsqR3dNu8u/ryzDxJLZoeNXUQ5nAD8NmfVFGhoZFuAnWMw==
X-Received: by 2002:a67:ee4e:: with SMTP id g14mr35358331vsp.37.1620850979717;
        Wed, 12 May 2021 13:22:59 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id y4sm122078vsq.27.2021.05.12.13.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 13:22:59 -0700 (PDT)
Subject: Re: [linux-nfc] Re: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof
 Kozlowski as maintainer
To:     Mark Greer <mgreer@animalcreek.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <961dc9c5-0eb0-586c-5e70-b21ca2f8e6f3@linaro.org>
 <d498c949-3b1e-edaa-81ed-60573cfb6ee9@canonical.com>
 <20210512164952.GA222094@animalcreek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <06892f2b-e4af-66d4-f033-aff49039d1a9@canonical.com>
Date:   Wed, 12 May 2021 16:22:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512164952.GA222094@animalcreek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2021 12:49, Mark Greer wrote:
> On Wed, May 12, 2021 at 11:43:13AM -0400, Krzysztof Kozlowski wrote:
>> On 12/05/2021 11:11, Daniel Lezcano wrote:
>>> On 12/05/2021 16:43, Krzysztof Kozlowski wrote:
>>>> The NFC subsystem is orphaned.  I am happy to spend some cycles to
>>>> review the patches, send pull requests and in general keep the NFC
>>>> subsystem running.
>>>>
>>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>>>
>>>> ---
>>>>
>>>> I admit I don't have big experience in NFC part but this will be nice
>>>> opportunity to learn something new. 
>>>
>>> NFC has been lost in the limbos since a while. Good to see someone
>>> volunteering to take care of it.
>>>
>>> May I suggest to create a simple nfc reading program in the 'tools'
>>> directory (could be a training exercise ;)
>>>
>>
>> Noted, thanks. I also need to get a simple hardware dongle for this....
> 
> Krzysztof, the NFC portion of the kernel has a counterpart in userspace
> called neard.  I'm supposed to be maintaining it but I have next to no
> time to do so.  If you have spare cycles, any help would be appreciated.
> 
> Anyway, in neard, there are some simple test scripts (python2 - I/we need
> to update to python3).  The current home of neard is:
> 
> git://git.kernel.org/pub/scm/network/nfc/neard.git

Thanks for sharing this. Let me take a look at it first, before
committing to something too big.

Best regards,
Krzysztof
