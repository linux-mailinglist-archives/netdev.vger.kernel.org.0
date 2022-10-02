Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD85F21D1
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 09:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJBHyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 03:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJBHyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 03:54:22 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862F92DA9F
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 00:54:20 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bu25so12652122lfb.3
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 00:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=rtcq/qlXKJH+v6P/2nTYU7baMtJecz/cU+zasR4za6s=;
        b=EhxhpiTumRFsa6t4yIig4o6Vf5b9of7ZEww4NuLAyDGa6NERccHmyXuontN/R8QQ8z
         fWbtJUfT4IUD9y0GU7njcM08USWsDLCyNggkzqvcizDkGn08BjtRM+PIPpGCWe86lTuJ
         MNXSSVWRkdMuZusU33Mv4erg3KNTWRBSkfs5bncOsan1wp5Zqtywq0C54rmHOuyw8nxp
         RneD4MyA8KtRiPegWjNPPzXiElmZ7xThM+ET4GCetXawBhxmyI3ugbSjRREwHc63iBeg
         prmbtE37PefoL1HOfDWZgyEGO3eyj/2Wq9fqjfkgQanWcmypswRntT++18dzEnQishru
         PJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rtcq/qlXKJH+v6P/2nTYU7baMtJecz/cU+zasR4za6s=;
        b=KB+4N4i3Qni3owd6pCC3WfostLMvMFLSZHSKVgKinmpfEhHmx/E0SOu4lG/UAdzPpb
         iaWuVEQwqN/vF05kCxAbdNvcj6h1Mv/AZDrvP2l3W1B+oLchvJ1qa6La/oCco3zVcP2j
         Nx/VSX9uutqUVaXteU1hylJpHJDQa+nfWsLgoIvNX9yjnTT63YooRynAHIVnYBJMJ73l
         7gCnnM4Cdqco9aRztHa/f7BflBNMR4UvvcHZN9BEHfCJP+/6Qely+f1EFmab0i5ZAd6B
         ml4qIfdiqZerYuNKA0rlH3rbCi5WkD3ld8PW/xqtEfYcLHCRGqz3DUxGleBSXb6yIq/D
         9lbg==
X-Gm-Message-State: ACrzQf3ZfCyDubD/rP2DzA4+SMeob5uzgZgHH2QdoqFIEv4QKTTfeyxz
        txsSfyOJ5FEDjWmSTNkdHnb0jw==
X-Google-Smtp-Source: AMsMyM41AAHBJep1yHbytcog6byyR+D1LltUWyZvGYSi4KfYmqM1CzISjteGtcbOq37l36YuE1oZMA==
X-Received: by 2002:a05:6512:39cd:b0:4a2:ff7:12ef with SMTP id k13-20020a05651239cd00b004a20ff712efmr4329597lfu.643.1664697258930;
        Sun, 02 Oct 2022 00:54:18 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z3-20020a056512370300b004a2386b8cf4sm133604lfr.258.2022.10.02.00.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Oct 2022 00:54:18 -0700 (PDT)
Message-ID: <ca62fc03-8acc-73fc-3b15-bd95fe8e05a4@linaro.org>
Date:   Sun, 2 Oct 2022 09:54:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to
 yaml
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
 <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
 <1163e862-d36a-9b5e-2019-c69be41cc220@linaro.org>
 <9999a1a3-cda0-2759-f6f4-9bc7414f9ee4@linaro.org>
 <0aeb2c5e-9a5e-90c6-a974-f2a0b866d64f@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <0aeb2c5e-9a5e-90c6-a974-f2a0b866d64f@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/10/2022 14:51, Bhupesh Sharma wrote:
>>> Right, most of them are to avoid the make dtbs_check errors / warnings
>>> like the one mentioned above.
>>
>> All of them should not be here.
> 
> I guess only 'snps,reset-gpio' need not be replicated here, as for 
> others I still see 'dtbs_check' error, if they are not replicated here:
> 
> 
> arch/arm64/boot/dts/qcom/sm8150-hdk.dtb: ethernet@20000: Unevaluated 
> properties are not allowed ('power-domains', 'resets', 'rx-fifo-depth', 
> 'tx-fifo-depth' were unexpected)
> 	From schema: /Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> 
> Am I missing something here?

Probably the snps,dwmac schema failed. It is then considered
unevaluated, so such properties are unknown for qcom,ethqos schema. Run
check with snps,dwmac and fix all errors first.


Best regards,
Krzysztof

