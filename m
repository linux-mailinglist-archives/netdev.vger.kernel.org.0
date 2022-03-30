Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3284EC9E9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348961AbiC3Qqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348977AbiC3Qqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:46:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42311E3E29
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:44:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bg10so42695515ejb.4
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yHBfMl6iM7258r0O2Jco9pafktxB1pt6+1WqgBzk+vg=;
        b=KLyLdtoSrb3fmaMJiq0IipYP8LMdhy6mILKXf36PQRWK5lDC7m6Tb2FhMsjzrPHtJt
         UvI8C8XDTcE5qrh1h1bncRLDNRnYOso8de8xGpuuhnsXE13LDOZjgPaVJJNQj84fiGXI
         5dQFIk8CLxRRJjk7ngUuZPx13i9vpUcixttW3CzcnvlwrLZRS2SLTXTSfpZKWJ8Cw4vL
         +9uubnbTntHsZIBPRPNpMmsNbguw6kcswbWpc6KNZ9UmrBXIBJDMgiZFiMWnEgQy5Qx/
         pReB7fiyXYmWm6yGOoy1lCCtUJ79qTZd4pwWOL6C0RR29CiKxOYy5Y+Ye3AKycvTbBIN
         iOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yHBfMl6iM7258r0O2Jco9pafktxB1pt6+1WqgBzk+vg=;
        b=F2y4VrKZ4Opl37XN6qxePb0LfrdZaMo7R7REN9mL6z+48LM15NK1yL26nb1ehGVzmp
         k/3tbqoPlfgAlOk0JZlR9q9uU1wnh5ExY144NrQxB/1GAjs1dceVoo8POMtzkdSc5oLx
         meV+oeU6ZwerQb0DMzIcZaovYV9cqZgIfQONTpUSj74L3FZ5rtw+xI81s+KYel2ctwKw
         I0UmpSWJA9P1RW4YOwpzMiFIb+HAz6OqReyYA+ZlMOJUH88RNlYiOl14iI3/5gzSQrJz
         gKGzJYDl+AtjmHv+1f+4956LMyg+Ol6pDbsxH1QmWOQ8N4hYrbdEWAyCIHUF05Os0Gqr
         Nqqw==
X-Gm-Message-State: AOAM533TXA7kZ8Igo+dVaR9SZ56VLMC/16ZYllNM9JJakhm0N6JkPIDG
        Hc0LlwgAbmjRn0BImQgSYa9PAA==
X-Google-Smtp-Source: ABdhPJywV3uexnsqSnhWXlwW2C6kDd0vY5WPPQ+rsQ3XzeorjnRj1l22TFs3ki+OTaR+h4z7XUNuKw==
X-Received: by 2002:a17:906:32d0:b0:6ce:e1cf:3f2e with SMTP id k16-20020a17090632d000b006cee1cf3f2emr449876ejk.214.1648658683796;
        Wed, 30 Mar 2022 09:44:43 -0700 (PDT)
Received: from [192.168.0.164] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709060cc200b006d3d91e88c7sm8492441ejh.214.2022.03.30.09.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 09:44:43 -0700 (PDT)
Message-ID: <064271f4-d775-279c-0aa2-c9e23194bc61@linaro.org>
Date:   Wed, 30 Mar 2022 18:44:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
 <20220316101854.imevzoqk6oashrgg@skbuf>
 <b45dabe9-e8b6-4061-1356-4e5e6406591b@canonical.com>
 <YkR9NKec1YR7VGOy@shell.armlinux.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YkR9NKec1YR7VGOy@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2022 17:54, Russell King (Oracle) wrote:
>>
>> These are different. This is an example how to model the input clock to
>> the device being described in the bindings. This is not an example how
>> to use the clock provider, like you created here. The input clock
>> sometimes is defined in Exynos clock controller, sometimes outside. The
>> example there shows the second case - when it has to come outside. It's
>> not showing the usage of clocks provided by this device, but I agree
>> that it also might be trivial and obvious. If you think it is obvious,
>> feel free to comment/send a patch.
> 
> Why is whether something is an input or output relevant? One can quite
> rightly argue that SFPs are both input and output. :)
> 

I don't mind removing that example. Input - in the case of these
bindings - is quite specific. Output is opposite, not specific and can
vary, you can enable/disable, change frequency.

Discussion was two weeks ago, so all emails will bounce. :)

Best regards,
Krzysztof
