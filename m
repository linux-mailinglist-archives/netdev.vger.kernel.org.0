Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5E389362
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhESQOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 12:14:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35916 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354967AbhESQOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 12:14:34 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1ljOor-0008P3-Tv
        for netdev@vger.kernel.org; Wed, 19 May 2021 16:13:14 +0000
Received: by mail-qk1-f199.google.com with SMTP id r25-20020a05620a03d9b02903a58bfe037cso4321027qkm.15
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 09:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eS+z7fWf9ik7UiPFy0EbImNsC/jTSa8AjK2vvxy5tQE=;
        b=KXpeRqwMeoIwAOzEviplkxl6y3nTtn9vbYVCLga9m34+RbEUo/EReZ2/0vVwyNDTzA
         +P+e7tR/KeaYg13kz6Y7aC1u+2xukL8vbZym9jZP0Tfyb/yDW0OdF8F9J5zmZQBt8tQn
         MafvRNgpdG+adgReDWkeRs+gA0loR0e+Ke32Ejx43uerHrmfwgZdSs7FCq2ZXdcdVi+8
         kQX1kiX4277aAaryGo34j1I36IdeIUEromrVDi10VvT6JgsrObl6m6YbQLFnIxItzVpI
         7+cOkqCHsOJbww0ujEDO+wH+sFVC793z/2gQ/QC/8/JY+lORCP8xsMqr/bM2TJtSjTwo
         uprQ==
X-Gm-Message-State: AOAM533dGX0PKGRO854apyWxqqPseNFl0f6GsOCo+LUiQ+newICs59BE
        6AhlnrwTuMgY0P6FYX85wlhcy0dqcatNLGrAqpbEmAoADseF6J2DdHpinfzhBTfiBDEnjq79D0G
        +D60KMsHovD76q7LfyvS7HXu9KJFYcQgn2A==
X-Received: by 2002:a05:620a:13a6:: with SMTP id m6mr77873qki.370.1621440793084;
        Wed, 19 May 2021 09:13:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUghUkKBDIuGvqx1Nu07luWzepugYJj1I5VtklAhOR9KibnL6Cutz0I3Szhxs1G5QJhQj6OA==
X-Received: by 2002:a05:620a:13a6:: with SMTP id m6mr77852qki.370.1621440792900;
        Wed, 19 May 2021 09:13:12 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id f1sm83218qkl.93.2021.05.19.09.13.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 09:13:12 -0700 (PDT)
Subject: Re: [linux-nfc] [PATCH v2 2/2] nfc: s3fwrn5: i2c: Enable optional
 clock from device tree
To:     Stephan Gerhold <stephan@gerhold.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
References: <20210519091613.7343-1-stephan@gerhold.net>
 <20210519091613.7343-2-stephan@gerhold.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <86461091-617b-62ec-a9e5-2aec337d69ce@canonical.com>
Date:   Wed, 19 May 2021 12:13:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519091613.7343-2-stephan@gerhold.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2021 05:16, Stephan Gerhold wrote:
> S3FWRN5 depends on a clock input ("XI" pin) to function properly.
> Depending on the hardware configuration this could be an always-on
> oscillator or some external clock that must be explicitly enabled.
> 
> So far we assumed that the clock is always-on.
> Make the driver request an (optional) clock from the device tree
> and make sure the clock is running before starting S3FWRN5.
> 
> Note: S3FWRN5 asserts "GPIO2" whenever it needs the clock input to
> function correctly. On some hardware configurations, GPIO2 is
> connected directly to an input pin of the external clock provider
> (e.g. the main PMIC of the SoC). In that case, it can automatically
> AND the clock enable bit and clock request from S3FWRN5 so that
> the clock is actually only enabled when needed.
> 
> It is also conceivable that on some other hardware configuration
> S3FWRN5's GPIO2 might be connected as a regular GPIO input
> of the SoC. In that case, follow-up patches could extend the
> driver to request the GPIO, set up an interrupt and only enable
> the clock when requested by S3FWRN5.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> This allows NFC to work properly on the Samsung Galaxy A3/A5 (2015).
> 
> Changes in v2: Rewrite commit message and comment based on discussion
> 
>   Note: I tried to explain the setup a bit better but dropped most of
>         the explanations about the exact configuration on the Samsung
>         Galaxy A5. I think the HW-specific details were more confusing
>         than helping. :)
> 
> v1: https://lore.kernel.org/netdev/20210518133935.571298-2-stephan@gerhold.net/
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
