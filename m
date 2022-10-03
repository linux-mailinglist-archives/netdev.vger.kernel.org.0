Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECBC5F2E53
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJCJn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiJCJnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:43:25 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651345F7D2
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:38:04 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 25so5450835lft.9
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8nV0XrY8LZwpXKpS4srGP447Rz/X7Xn90y9nTiydLdc=;
        b=XwqTitDaS7EOxqP2oFBSsCw/UYztR/Ok4NhYrMv/PXJpDxBSKCfOoAC1yF5MH4ayqx
         bBXdYQVXTzyCzwo7Tw3maWoqXJCGatYGHWCB0XewyXzsyATJtvq+NT7xlz9/TqJqOdRa
         SbNkAaavG9yoxdm51YftNldYVbUKBKEogb109Xdcdlf4TF/lvs485wGTz9MpO6WnrIhB
         ZhKOyQ2COtEjB17EofmtSpHCwg5VBAZnPYivmYWIkiAGmYxCWLFTCPauuo/uS1qoHZ09
         Zn6yIDwxjk6j1M5bIEpyIQc+M0UP9jrsPbU7Xd5kKIRsEkCsJLcymTFRMi6ty0/KB4C+
         yaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8nV0XrY8LZwpXKpS4srGP447Rz/X7Xn90y9nTiydLdc=;
        b=5+1lLySVgZLtLUFHvOVY1RXICPuw0AuOnbzsc1777Z86vTztCOCWppj4kfj6y8dSq+
         39n6e30IPIj4Cm3LkoAzhRmfPG6TG+bR3Kiq6hhS+RrNq7pyFdHpc2yUdSAJBHp6P8Qp
         Ac4C7ggMV8xDIgua+mqJ+bzy+eRG8whZNAlWnAvjbWx4Qup/ldFrcqS1g3jUOUc53YdK
         i2T4JW65eSTzAnAj3c2bmJc0YMV+PbYqiKrtqsYQLz1BS0JLSGosp9AQx9q4+ervnkdc
         O/znPbB0fR26TumU75SnBBEaz4CJRq/shoYx3irpnpmLI8+RjOV0431sev/c+NaB63Rp
         cI0w==
X-Gm-Message-State: ACrzQf1Ps997nhd1lwKT6PBz+p7UjUwQg3DRe2nYeuTdFahlnNu3cy7G
        nL0SBvmCOWbaeptgHU/qWcS80A==
X-Google-Smtp-Source: AMsMyM5pTl0qUUUrQmICcRfAVFgObBRocvyvNf1nO9MIfn8wkSwOtyrbuiWQdIfrfDViIIdeS2Vw+g==
X-Received: by 2002:ac2:558b:0:b0:4a2:2706:43f6 with SMTP id v11-20020ac2558b000000b004a2270643f6mr2874558lfg.601.1664789579388;
        Mon, 03 Oct 2022 02:32:59 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id i2-20020a2ea362000000b0026c2fec2f8esm841555ljn.84.2022.10.03.02.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 02:32:58 -0700 (PDT)
Message-ID: <2e68d64f-766c-0a52-9df8-74f0681a5973@linaro.org>
Date:   Mon, 3 Oct 2022 11:32:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to
 yaml
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
 <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
 <1163e862-d36a-9b5e-2019-c69be41cc220@linaro.org>
 <9999a1a3-cda0-2759-f6f4-9bc7414f9ee4@linaro.org>
 <0aeb2c5e-9a5e-90c6-a974-f2a0b866d64f@linaro.org>
 <ca62fc03-8acc-73fc-3b15-bd95fe8e05a4@linaro.org>
 <CAH=2Nty1BfaTWbE-PZQPiRtAco=5xhvJT3QbpqYsABxZxBzF3w@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAH=2Nty1BfaTWbE-PZQPiRtAco=5xhvJT3QbpqYsABxZxBzF3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2022 10:29, Bhupesh Sharma wrote:
> On Sun, 2 Oct 2022 at 13:24, Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 01/10/2022 14:51, Bhupesh Sharma wrote:
>>>>> Right, most of them are to avoid the make dtbs_check errors / warnings
>>>>> like the one mentioned above.
>>>>
>>>> All of them should not be here.
>>>
>>> I guess only 'snps,reset-gpio' need not be replicated here, as for
>>> others I still see 'dtbs_check' error, if they are not replicated here:
>>>
>>>
>>> arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated
>>> properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth',
>>> 'tx-fifo-depth' were unexpected)
>>>       From schema: /Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>>
>>> Am I missing something here?
>>
>> Probably the snps,dwmac schema failed. It is then considered
>> unevaluated, so such properties are unknown for qcom,ethqos schema. Run
>> check with snps,dwmac and fix all errors first.
> 
> Running dt_binding_check DT_SCHEMA_FILES=net/snps,dwmac.yaml
> reports no error currently.

Then it's something in your commits. I don't know what you wrote, as you
did not sent a commit. I cannot reproduce your errors after removing
unneeded power-domains.

Just to clarify - I am testing only the dt_binding_check (so only the
examples - I assume they are meaningful).

Best regards,
Krzysztof

