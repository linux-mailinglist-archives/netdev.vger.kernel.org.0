Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFC964054B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiLBKyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiLBKxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:53:38 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D6A93822
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 02:53:02 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id l8so4966740ljh.13
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 02:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ozG/UpJ3bPaswuvxlA6GlaGwfzIvrdrSod17QPiF3RU=;
        b=VnRfxu9nNzzswT8wEXi/i183yZLJRDzC4A1K/Fiw/h2bpk3Sw8aOKG7jTN62zP4qJk
         orl6/lzBhRZ9GCycb806ntQgMFusHnDXYp8YNnYu72LcScqY0/ycnzDJfmarUJA35rjd
         o+UsA3ICCh89hAioEY5k7YQ8dAQsy4Oocqs46VFNEZNBdCDtz1BDMJtte9QpYpXEScRS
         rpvuuHQ47yCpXaboEhGzSEt3xZIHgXUlhslFK1jy2sNWUiFUyOew8e0Emwq59QKG236Y
         VkNClbkGA0sP43zbSRdGjkEPyAYIv+5+N/fpuUA25N+1UaGQUGDFPDv7m2ASEymVG/Z/
         YScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozG/UpJ3bPaswuvxlA6GlaGwfzIvrdrSod17QPiF3RU=;
        b=wx/Lfpt1vtWjeNzg7xfpGAQc30TxrfQWmxqdBBseqDKeHXUAT+sEymntHHSZZ8foMy
         zKxZiwgfCk7Ic5xvY5qyrI4yKUT806MUK+DxDv2IOBPn3Y/D9VMkZF3EPEqCkaSkBANb
         1b6ebU3jh4ezNVnYnz6ec8UaE90sFIn+e/JyKrjSYqfBhyR33u8gfszxocGWiZMj25Tx
         fpx0iZa1GAvTdc6UaI4xz2Z1WrNJuGvJ9E2WVAntdPiV0eOkiRcNF5zvwBIazuyffE6d
         q/lRBTGtUQS3A7LpN/0WBy87XdjD2kt5wN5HobX4sTQ1G3s3/lYevSiRyL8eGXY+7B/Z
         Hr2Q==
X-Gm-Message-State: ANoB5pl1qDeS4gjyKKY5Gz3nu11iPBUX3aICev6gAEZ/jbtP0UT+eX8v
        LKf/liLICkwSAOl0Gp3CznBwfg==
X-Google-Smtp-Source: AA0mqf5UDZibFF2eJbCdKm3k1Hn0SM83w0I9K8FzTMHa2/oIUf03uj7BBCTGwnQAjufz6lEHSgSo5w==
X-Received: by 2002:a2e:a263:0:b0:276:be89:5616 with SMTP id k3-20020a2ea263000000b00276be895616mr15253849ljm.347.1669978380884;
        Fri, 02 Dec 2022 02:53:00 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id u8-20020a05651c130800b0026fb5525ee4sm588660lja.116.2022.12.02.02.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 02:53:00 -0800 (PST)
Message-ID: <624cba7f-1be9-7100-91d7-f9232c855d9f@linaro.org>
Date:   Fri, 2 Dec 2022 11:52:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <166990139276.476262.15116409959152660279.robh@kernel.org>
 <Y4jaQ4snp6x1oU6k@spud>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y4jaQ4snp6x1oU6k@spud>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 17:45, Conor Dooley wrote:
> Hey Yanhong,
> 
> On Thu, Dec 01, 2022 at 07:36:29AM -0600, Rob Herring wrote:
>>
>> On Thu, 01 Dec 2022 17:02:38 +0800, Yanhong Wang wrote:
>>> Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
>>>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>> ---
>>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>>  .../bindings/net/starfive,dwmac-plat.yaml     | 106 ++++++++++++++++++
>>>  MAINTAINERS                                   |   5 +
>>>  3 files changed, 112 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
>>>
>>
>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>
>> yamllint warnings/errors:
>> ./Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml:30:16: [warning] wrong indentation: expected 14 but found 15 (indentation)
>>
>> dtschema/dtc warnings/errors:
>> ./Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml: $id: relative path/filename doesn't match actual path or filename
>> 	expected: http://devicetree.org/schemas/net/starfive,dwmac-plat.yaml#
>> Documentation/devicetree/bindings/net/starfive,dwmac-plat.example.dts:21:18: fatal error: dt-bindings/clock/starfive-jh7110.h: No such file or directory
>>    21 |         #include <dt-bindings/clock/starfive-jh7110.h>
> 
> Perhaps, rather than putting a long list of "prerequisite-patch-id" in
> your cover letters etc, you drop the need for headers from your bindings
> entirely? Otherwise, you need to wait for the clock bindings to be applied
> before any of your other peripherals etc can have drivers/bindings upstream.
> 
> AFAIU, and Rob/Krzk please correct me, the example in a dt-binding
> really is an *example* and there's no requirement for it to match the
> jh7110 dts exactly. Because of that you can drop the header & just do
> something like `clocks = <&clk 7>, <&clk 77>;` etc and the example is
> still valid. Same goes for all of the other driver patchsets for new
> StarFive stuff, like the pmu or crypto, that also have dt-bindings.
> 
> The only person who has to worry then about dependencies is me when I
> apply the .dts patches :)

It's nice when example looks good and matching final DTS, but that's not
a requirement. Pretty often clocks/resets/domains are mocked for the
example.

Best regards,
Krzysztof

