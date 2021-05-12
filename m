Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5037C7CE
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhELQCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:02:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33404 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhELPo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 11:44:26 -0400
Received: from mail-ua1-f71.google.com ([209.85.222.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgr13-0001p7-1J
        for netdev@vger.kernel.org; Wed, 12 May 2021 15:43:17 +0000
Received: by mail-ua1-f71.google.com with SMTP id t19-20020ab021530000b029020bc458f62fso1318628ual.20
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 08:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9U0ez24YYqRM0bUzj0cJkOD9iTgQukzTFGowhKKRb/U=;
        b=AJhAwCZRKFSXHru+EDtK0LMvsuqTHzTfDmRaD491LSem0+DadOGXqFASsH4xG/WyUZ
         wzA738y98y6CD5aMnEK2kgIsnk6S2edXHpIB/QbaYY2rm1LBafedEN+Qrh1HV9sA2BeS
         Z62nX3JPPdrmFIvrjjzhDOJ3K5bNmo6XVYVOJBlRXRjZWkFC3OmW3YbNtQAyQRwMMmuB
         gl1ZvIqeDoalBtdxjS7wMlOXghEQorGxZb6wpqtcEuCksfIkeCLFamgzfQ8L/OjCzUNV
         ZnRqgUuwXiX5bu1VWwRubKqg14N7K9YDC5c6t56uvdUsXpNQe8zwJKfB7ANf++eiUWji
         XvOg==
X-Gm-Message-State: AOAM532behrUkzInlbkw53/NOjFi3j+Fb+nMi0xmGO8TH2zYj8mRSM2Z
        NPgwU2B+27i6s/gch3o1ICTAxlhJAsqtdfJk8vmwJNuaGemmRjAgix91Dqny6LlMYh7GCPasj0Q
        uy7Nll2DG1tjTcaKAcYm8xBVwrJoqYc3+jQ==
X-Received: by 2002:a67:ad03:: with SMTP id t3mr31669270vsl.23.1620834195895;
        Wed, 12 May 2021 08:43:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzirDmtdNmCE1i/o7cAXop5KOBGCC9s59JF+LWGQbuCR2/27ZEYoKsxnLq0Jfq3DW++gYpelg==
X-Received: by 2002:a67:ad03:: with SMTP id t3mr31669254vsl.23.1620834195759;
        Wed, 12 May 2021 08:43:15 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id d12sm31183vsc.8.2021.05.12.08.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 08:43:15 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski
 as maintainer
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-nfc@lists.01.org
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <961dc9c5-0eb0-586c-5e70-b21ca2f8e6f3@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <d498c949-3b1e-edaa-81ed-60573cfb6ee9@canonical.com>
Date:   Wed, 12 May 2021 11:43:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <961dc9c5-0eb0-586c-5e70-b21ca2f8e6f3@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2021 11:11, Daniel Lezcano wrote:
> On 12/05/2021 16:43, Krzysztof Kozlowski wrote:
>> The NFC subsystem is orphaned.  I am happy to spend some cycles to
>> review the patches, send pull requests and in general keep the NFC
>> subsystem running.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>
>> ---
>>
>> I admit I don't have big experience in NFC part but this will be nice
>> opportunity to learn something new. 
> 
> NFC has been lost in the limbos since a while. Good to see someone
> volunteering to take care of it.
> 
> May I suggest to create a simple nfc reading program in the 'tools'
> directory (could be a training exercise ;)
> 

Noted, thanks. I also need to get a simple hardware dongle for this....


Best regards,
Krzysztof
