Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3F5640175
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiLBIB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiLBIBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:01:24 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FD39E457
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:01:23 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b3so6240041lfv.2
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=myxyATfyN+1auJfJuG3H5dbd93oQNnjh+ve1JpPtApU=;
        b=jY7HCGbEyRP9FdG8tKLmzbtJXZI8Axu41H2Vys9oMDnirag9oo7VWLM4TwWa9iI9dM
         lVb+H7GoEdDbnTqp/nILHCyel8iTyJ88R0P5t8KkFda0CFrc4knMHL7/4hTe6OZ85OCE
         8MERBbP3ttRPfE3YXR48lY8XR/E21hCyyHRJJuCEUjo/Lwglp7Jc95d8sJc60fWqEDra
         dJnnmoYYkBGxGGbbM5OPL+gcLn0o1X6d6GhfHtxlXDnMJwo5SACyWEkcejWhihkb3fUr
         FpbS97VBffF5cZR5YK6sa0xrZetZbPAfkeAvNpRhWxWg5gGD2gSQyz51HM0Uv0gDrL03
         /ULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=myxyATfyN+1auJfJuG3H5dbd93oQNnjh+ve1JpPtApU=;
        b=S54Z+pBNYen68QPdsrg81bONJPPungM/8g/oA7A+0v53E/58o5t/z5wf1BPuknlQjD
         G0ax8/yrU0+figoN9oQRuSWemhh9rvLXCc8+Z/XCt2yXSSXe2/cbD32p3H88uVztZbca
         QXf09IH5a8BVCqYBvbrmtjRyOtM2OKlAtvq/AOR7JhD3//Mw3Mwz8aTa9GvHiHeJXwAi
         IBYPqogCAiDtr2SohAhZZdapUPdlSVe2DXV0N2lDWHRNiMfvzIR4q7FGX8Nq1vYxl6Bh
         fTfTdEj1P8goeutBeGIEqSdCuElXqBlz6tfVHVeoO/YJJC9EcvYjifBTx7m0oNFoKMje
         m0mg==
X-Gm-Message-State: ANoB5pkqH6Tn8ILUPlT33oSOzCHu702nx1yClWQ1ym9qZlsd4DSTQ1bC
        qwXe89RSrsJ3AU9mcGl+c1Gt7w==
X-Google-Smtp-Source: AA0mqf6kG9n38g0CPH5KhVFXIHW7Ha126mJzbmxKhe6FZ82LqLmbRbd47TptGcuSA0OZG9yXslUBSQ==
X-Received: by 2002:a05:6512:3e0c:b0:4a9:bdb3:9db8 with SMTP id i12-20020a0565123e0c00b004a9bdb39db8mr27055157lfv.643.1669968081531;
        Fri, 02 Dec 2022 00:01:21 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id b13-20020a0565120b8d00b004b373f61a60sm940253lfv.96.2022.12.02.00.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 00:01:19 -0800 (PST)
Message-ID: <3a9ef360-73c3-cf26-3eca-4903b9a04ea3@linaro.org>
Date:   Fri, 2 Dec 2022 09:01:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 1/7] dt-bindings: net: snps,dwmac: Add compatible
 string for dwmac-5.20 version.
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-2-yanhong.wang@starfivetech.com>
 <277f9665-e691-b0ad-e6ef-e11acddc2006@linaro.org>
 <22123903-ee95-a82e-d792-01417ceb63b1@starfivetech.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <22123903-ee95-a82e-d792-01417ceb63b1@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2022 03:53, yanhong wang wrote:
> 
> 
> On 2022/12/2 0:18, Krzysztof Kozlowski wrote:
>> On 01/12/2022 10:02, Yanhong Wang wrote:
>>> Add dwmac-5.20 version to snps.dwmac.yaml
>>
>> Drop full stop from subject and add it here instead.
>>
> 
> Will update in the next version.
> 
>>>
>>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>
>> Two people contributed this one single line?
>>
> 
> Emil made this patch and I submitted it.

If Emil made this patch, then your From field is incorrect.

Best regards,
Krzysztof

