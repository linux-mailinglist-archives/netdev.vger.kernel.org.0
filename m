Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3389D5E5B7C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIVGiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiIVGiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:38:11 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A493B654C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:38:10 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id p5so9720892ljc.13
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qyfZU/JafD8o6/SPahDQv0jUqUXGqfaIFI7Q3Ul2auI=;
        b=kkd99uZxOdiNalyDhr8+He7hgk7NzeStc8HhuMSENnPjGg5C366/cLNg/a268b7aRY
         5FH1wAENXzz80lUMaNZ306V8yotqdPqE3YxE+wPwcPDhlDX/Zson0A40UeuKXDaEEa8F
         L7cQi8UJTDRbBnqgd8I43iHQZPLkC8E1iJvC343ZOsrcQJgik38mGMuP4nTykKe/bWc8
         MuLJQaf1ByHh9wK7CDMgHOOgCCSwedl+graYTN5ROFJPlNKdnT3ku8gDe/hJj6le1JEZ
         x3O5F/7rOwOxuRpFUxaZtGUBvdU10MfGNNDWhMvU/GmoKsV259wsEZWxn1a4tklEHtk2
         xwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qyfZU/JafD8o6/SPahDQv0jUqUXGqfaIFI7Q3Ul2auI=;
        b=5p3tQpRQNwmhzj863MKvASiBpC6Es+iGCI5FFHKUV3nPi//10hqG/dRvogaVqQoyqT
         7NdLQQxxzHqpIkcPNOFlxwipi09mXBq8vQovCi24vXj86Gl02dfHErI+A5VSejNwZV4v
         B4zVf2QUl8uUFvWAyrWwtVi8CKpoi6mqSOSsWYBXo1YdH0ra7RoRAPYd52iP8RVeO8gV
         U7r3NqZI95Lwrty4Bkvcz0bC+K0RdeILgmVCpch3viXzToFqll9yQRMBsN/6cq8JkveC
         wJF/yMJYtJUwXcZpRmT9ODx3678VQH/sG10nUIcurot4z8o06mOs9Gnd5fBOMS2UrHeQ
         gxQQ==
X-Gm-Message-State: ACrzQf3r3COc71txZgW+LsXIJwoW5LDHrbrWrVu/wpv5+UCap99uyME8
        1f0p8eBd4FTBBwYgD8PjEt2B1g==
X-Google-Smtp-Source: AMsMyM74j0aPxMSIE9NbVNKhB5RET6Vu035qf1/l0Aypj5PElvYZATE6ZCJU/M40ykreSuiv5OANYw==
X-Received: by 2002:a2e:84d6:0:b0:26b:dce5:2fe5 with SMTP id q22-20020a2e84d6000000b0026bdce52fe5mr529732ljh.12.1663828688613;
        Wed, 21 Sep 2022 23:38:08 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id b1-20020a056512070100b00493014c3d7csm767484lfs.309.2022.09.21.23.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 23:38:07 -0700 (PDT)
Message-ID: <821b3c30-6f1f-17c1-061c-8d3b3add0238@linaro.org>
Date:   Thu, 22 Sep 2022 08:38:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 2/2] dt-bindings: net: snps,dwmac: add clk_csr property
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220921070721.19516-1-jianguo.zhang@mediatek.com>
 <20220921070721.19516-3-jianguo.zhang@mediatek.com>
 <bd460cfd-7114-b200-ab99-16fa3e2cff50@linaro.org>
 <d231f64e494f4badf8bbe23130b25594376c9882.camel@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <d231f64e494f4badf8bbe23130b25594376c9882.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2022 04:15, Jianguo Zhang wrote:
> Dear Krzysztof,
> 
> 	Thanks for your comment.
> 
> On Wed, 2022-09-21 at 10:24 +0200, Krzysztof Kozlowski wrote:
>> On 21/09/2022 09:07, Jianguo Zhang wrote:
>>> Add clk_csr property for snps,dwmac
>>>
>>> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index 491597c02edf..8cff30a8125d 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -288,6 +288,11 @@ properties:
>>>        is supported. For example, this is used in case of SGMII and
>>>        MAC2MAC connection.
>>>  
>>> +  clk_csr:
>>
>> No underscores in node names. Missing vendor prefix.
>>
> We will remane the property name 'clk_csr' as 'snps,clk-csr' and
> another driver patch is needed to align the name used in driver with
> the new name. 

You did not say anything that you document existing property. Commit msg
*must* explain why you are doing stuff in commit body.

We should not be asking for this and for reason of clk_csr.

Best regards,
Krzysztof

