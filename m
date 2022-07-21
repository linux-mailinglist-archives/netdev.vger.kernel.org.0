Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70BE57CDE8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiGUOmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGUOmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:42:16 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA5884ED7
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:42:15 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id z25so3155858lfr.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=thNzHvCp6cjZHmJ/ovw3Dji38lKPQpENV9BvGaehLGw=;
        b=NEZzqSvG0pj+3+chsobD6C3nUdZDNwikBSErN2n+2h0WF2IzB2BBF8wP9rjYipkOpP
         EUirwoSfLaOlLLI1mtfNgI7zcK0bJPumnB5rzX1tPJq6KdmfWhMoAUTm4gNAhkZNzl3f
         VqvvbIGu2iy9d8y8qJlnM5MAcoKqIQE69h0W5NfEEA5VIbx5CNpKr4vLpFNdgit5SkPv
         HAcZXXHXEAyVK0r0G5JPCkjPygot2GWZ3kA3NHnKinO/gx3ePADnTbIZRujbzwLyHE4s
         61LB/wrUs18f6S7al3vk74QwWQMRAhXeHt9/dqYpXrr8m6739TmAL14/6DbG8Rv+5qi5
         0kGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=thNzHvCp6cjZHmJ/ovw3Dji38lKPQpENV9BvGaehLGw=;
        b=Ip63y5JwLtNeiv38Zz3RQH9R0itVLM+HmJjaJHHLkbbmzLfqgFQb9rrvNSthkqTy1O
         wJ6ALNzmLNz0+7Fwb8pTPeavu07OF2UzPh7jlyCNQWD66fzR9W9Gp2qk7J/V9vk54iJl
         sAXVQs0Ei9n0PA4VCKMeLbnXAcLbPOtzrN9qacvgzROqR608/khL5GgFP0B+XptpcW4P
         hK6gm0wn02/7gaHenCSL8deImJEiDAq/D42l/H5+S2LHjZXSarhYHsDbtx2sLqHBKyJl
         1qQ+GD5JiDuQptAoXunQ5+Tz82N6EwxuHwGIQgQ4E66KYPgnnHoGPK+CYIqgy0XL4SLM
         2NAA==
X-Gm-Message-State: AJIora/ru2ulDlmiNziTAsqVsaQ512pjgyhfyo7l8Qi1mcc6zxDRQ0SY
        n6By6nvMmX/NUM7l8pyOeGyCnw==
X-Google-Smtp-Source: AGRyM1uIljE0KwtqdtHRfg15leMXg4zhq3dLayvmUALbiIqC47x9oo2th7HQ2mKA6TYbjXKCJ8GXuA==
X-Received: by 2002:a05:6512:23a5:b0:489:d513:55a9 with SMTP id c37-20020a05651223a500b00489d51355a9mr21566452lfv.409.1658414533637;
        Thu, 21 Jul 2022 07:42:13 -0700 (PDT)
Received: from [192.168.115.193] (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id h24-20020a05651c125800b0025bc79181b4sm558765ljh.36.2022.07.21.07.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 07:42:12 -0700 (PDT)
Message-ID: <e1a8e417-3c4d-a11b-efce-e66bc170d92c@linaro.org>
Date:   Thu, 21 Jul 2022 16:42:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 03/47] dt-bindings: net: Convert FMan MAC
 bindings to yaml
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-4-sean.anderson@seco.com>
 <1657926388.246596.1631478.nullmailer@robh.at.kernel.org>
 <1b694d96-5ea8-e4eb-65bf-0ad7ffefa8eb@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1b694d96-5ea8-e4eb-65bf-0ad7ffefa8eb@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/07/2022 00:47, Sean Anderson wrote:
> On 7/15/22 7:06 PM, Rob Herring wrote:
>> On Fri, 15 Jul 2022 17:59:10 -0400, Sean Anderson wrote:
>>> This converts the MAC portion of the FMan MAC bindings to yaml.
>>>
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> Reviewed-by: Rob Herring <robh@kernel.org>
>>> ---
>>>
>>> Changes in v3:
>>> - Incorporate some minor changes into the first FMan binding commit
>>>
>>> Changes in v2:
>>> - New
>>>
>>>   .../bindings/net/fsl,fman-dtsec.yaml          | 145 ++++++++++++++++++
>>>   .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>>>   2 files changed, 146 insertions(+), 127 deletions(-)
>>>   create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>>>
>>
>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>
>> yamllint warnings/errors:
>>
>> dtschema/dtc warnings/errors:
>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.example.dtb: ethernet@e8000: 'phy-connection-type', 'phy-handle' do not match any of the regexes: 'pinctrl-[0-9]+'
>> 	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>>
>> doc reference errors (make refcheckdocs):
> 
> What's the correct way to do this? I have '$ref: ethernet-controller.yaml#'
> under allOf, but it doesn't seem to apply. IIRC this doesn't occur for actual dts files.

You do not allow any other properties than explicitly listed
(additionalProp:false). If you want to apply all properties from other
schema you need to use unevaluated.

https://elixir.bootlin.com/linux/v5.19-rc7/source/Documentation/devicetree/bindings/writing-bindings.rst#L75



Best regards,
Krzysztof
