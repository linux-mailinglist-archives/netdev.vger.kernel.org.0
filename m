Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCE237EE79
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhELVu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:50:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40351 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386909AbhELUWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 16:22:39 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgvMH-0005cM-LM
        for netdev@vger.kernel.org; Wed, 12 May 2021 20:21:29 +0000
Received: by mail-ua1-f72.google.com with SMTP id x11-20020a9f2f0b0000b029020331a0ba74so3059475uaj.15
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 13:21:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GPSchaWIh9W0a/KWJptAdzH4Ia11x5AtL0JuQZVu/NU=;
        b=HWnF3CxU0SvY13IVULY4a3zmYgKXlTIl6IlN6QFSopmuCXzzWR3TUrHXvtlDoqXOdi
         tOrUUpbcGJwR3iniRznyGvkJDeLMlP9OaOtV1aGi7t18olqbej2qPmfsHbWO36YfOa2+
         zBMyq+LifNzJV4/n+5+1AhfUKFy3QULBBk22pRyHuSBG04lXI5mvWCQwFoaUcGyI5k5i
         AaSbIIviSCZS7meRBx6Rrj9j2lT2KN/dnjg6RFbqK1RKX8DrgC/vpkHRt9s/RLJ57Xoc
         J4g5UilqsXmd7pPahZAAnt4UnBmtty/tkIHZAODjNMbRwCFo/suxrWaeG5Wg6Jtm9PbZ
         jKXw==
X-Gm-Message-State: AOAM532yOTVLxGNJVys9t72BdHKuep97H1zpTxbVF+N493tU341XrZWn
        7dKYZm+mpe03mvdGpDN2lBnVc3zgPvKd0paEPswm/8qv/LUdeueey7kEvlIqwX3wb+HmBeyelSZ
        Me2JgYJeKfz5CGLgWVtMUBUkMG1cf87hncw==
X-Received: by 2002:a1f:784c:: with SMTP id t73mr30125695vkc.14.1620850888139;
        Wed, 12 May 2021 13:21:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrJdbPgvpiXdpX3wOjnLuu0MgeYwXqYZEYdNJ2scWsTdKyud/94qx2Zr8Ha9rIIBePrSKTbw==
X-Received: by 2002:a1f:784c:: with SMTP id t73mr30125683vkc.14.1620850887959;
        Wed, 12 May 2021 13:21:27 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id b197sm120811vke.24.2021.05.12.13.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 13:21:27 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski
 as maintainer
To:     Mark Greer <mgreer@animalcreek.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Alex Blasche <alexander.blasche@qt.io>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
 <20210512170135.GB222094@animalcreek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <cd7a0110-702a-6e14-527e-fb4b53705870@canonical.com>
Date:   Wed, 12 May 2021 16:21:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512170135.GB222094@animalcreek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2021 13:01, Mark Greer wrote:
> On Wed, May 12, 2021 at 05:32:35PM +0200, Frieder Schrempf wrote:
>> On 12.05.21 16:43, Krzysztof Kozlowski wrote:
>>> The NFC subsystem is orphaned.  I am happy to spend some cycles to
>>> review the patches, send pull requests and in general keep the NFC
>>> subsystem running.
>>
>> That's great, thanks!
>>
>> Maybe you also want to have a look at the userspace side and talk to Mark Greer (on cc). He recently said, that he is supposed to be taking over maintenance for the neard daemon (see this thread: [1]) which currently looks like it's close to being dead (no release for several years, etc.).
>>
>> I don't know much about the NFC stack and if/how people use it, but without reliable and maintained userspace tooling, the whole thing seems of little use in the long run. Qt has already dropped their neard support for Qt 6 [2], which basically means the mainline NFC stack won't be supported anymore in one of the most common application frameworks for IoT/embedded.
>>
>> [1] https://lists.01.org/hyperkitty/list/linux-nfc@lists.01.org/thread/OHD5IQHYPFUPUFYWDMNSVCBNO24M45VK/
>> [2] https://bugreports.qt.io/browse/QTBUG-81824
> 
> Re: QT - I've already talked to Alex Blasche from QT (CC'd).  With some
> work we can get Linux NFC/neard back into their good graces.  I/we need
> to find time to put in the work, though.
> 
> An example of the issues they have seen is:
> 
> 	https://bugreports.qt.io/browse/QTBUG-43802
> 
> Another issue I have--and I suspect you, Krzysztof, have as well--is
> lack of hardware.  If anyone reading this wants to volunteer to be a
> tester, please speak up.

Yes, testing would be very appreciated. I don't know how many unit tests
neard has, but maybe some mockups with unit testing would solve some of
problems?



Best regards,
Krzysztof
