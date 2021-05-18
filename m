Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70756387B26
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 16:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhEROcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 10:32:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51687 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhEROcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 10:32:07 -0400
Received: from mail-qk1-f200.google.com ([209.85.222.200])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lj0kB-0003b1-Le
        for netdev@vger.kernel.org; Tue, 18 May 2021 14:30:47 +0000
Received: by mail-qk1-f200.google.com with SMTP id s68-20020a372c470000b0290305f75a7cecso7273062qkh.8
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 07:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zIep+mDf5u2lcxAQ599gQS4SQzw/nWv5n3LYaeTIvWc=;
        b=Obj5EzVwLuQRGit/WPfneYP8IumAKvJ1KWiKgUSzefRjrXGJJy0IBOQt8oclUVd8HV
         B82XSlRAu798mDCYgYyzV89yzboy0qctEk739kaZiSnk6eW6b7enob9Cum1v/9MyScdM
         UCXNNseOqAEu04NuhjL1zzmLkgfB+kByCnwYITeCukxPacvZzHVs9sJC29+mfDs+l2v1
         MgOJA6HzXyBkbLl+wvH1M6/mFVxguESMRmIs9Maz6wab1ZgcU1cJkRa1n7u277Qyu3p6
         +ZC+DgryOcW0+DrbAmxQ9ewGxLtKBPFcSeqbVq0CMLokKIgmD0am8pXzaYKFnBdr/vBM
         O98w==
X-Gm-Message-State: AOAM5338UkBzwqLi6AaNZ42pfOsRak6VMFZX0cVFQHKQphIiLmVA4Gt8
        umrnEkgz0V2LsXTO3Tt5tJKjmFPeg5MTYs+4IqJ7//AOq0rH6H/t1cSc7RmtU/0K4VwO+Lqk9Ns
        mleywSjqZnUDZODA17iJ4D3gbKsXbAgLxpw==
X-Received: by 2002:a05:622a:210:: with SMTP id b16mr5044997qtx.51.1621348246227;
        Tue, 18 May 2021 07:30:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpyWpzh/kiWyRW2rwQmit2HXqGLgcp+uEU++c6YSGJ4CJjKAvVgy4lKK8lBiy0QbkQAnCnZA==
X-Received: by 2002:a05:622a:210:: with SMTP id b16mr5044978qtx.51.1621348246015;
        Tue, 18 May 2021 07:30:46 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id h14sm3811162qto.58.2021.05.18.07.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 07:30:45 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional clock
 from device tree
To:     Stephan Gerhold <stephan@gerhold.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
Date:   Tue, 18 May 2021 10:30:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518133935.571298-2-stephan@gerhold.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Thanks for the patch.

On 18/05/2021 09:39, Stephan Gerhold wrote:
> s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
> the clock is needed for the current operation. This GPIO can be either
> connected directly to the clock provider, or must be monitored by
> this driver.
> 
> As an example for the first case, on many Qualcomm devices the
> NFC clock is provided by the main PMIC. The clock can be either
> permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
> only when requested through a special input pin on the PMIC
> (clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).
> 
> On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
> is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
> only when necessary. However, to make that work the s3fwrn5 driver
> must keep the RPM_SMD_BB_CLK2_PIN clock enabled.

This contradicts the code. You wrote that pin should be kept enabled
(somehow... by driver? by it's firmware?) but your code requests the
clock from provider.

> 
> This commit adds support for this by requesting an optional clock

Don't write "This commit".
https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L89

> and keeping it permanently enabled. Note that the actual (physical)
> clock won't be permanently enabled since this will depend on the
> output of NFC_CLK_REQ from S3FWRN5.

What pin is that "NFC_CLK_REQ"? I cannot find such name. Is it GPIO2?
What clock are you talking here? The one going to the modem part?

I also don't see here how this clock is going to be automatically
on-off... driver does not perform such. Unless you speak about your
particular HW configuration where the GPIO is somehow connected with AND
(but then it is not relevant to the code).

> 
> In the future (when needed by some other device) this could be
> extended to work for the second case (monitoring the NFC_CLK_REQ
> GPIO and enabling the clock from the kernel when needed).
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 


Best regards,
Krzysztof
