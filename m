Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F4557B5C7
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbiGTLp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiGTLp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:45:56 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9549DBC14
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:45:52 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id p6so20797251ljc.8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eZ2kEpkAO/dETR4Wy7CCjrZXNARvjTeBgYU6liP6gG0=;
        b=jvt7cSzP6DrqTcuMjUJ8hdYrwfyoClybuQCzTe1vo1J9FO+ePAc07+aMzsid+k42Km
         oNF+jf/MXQaLMxQt3ZvD6jfgldLkWTOIwSLG4VJmC+Q25M/UGplFPgiyJ7ALJxU1n//4
         D4OAkA0Qvt8t+h8BV8QZ7n9DYtPkvx1pvUguZ7wLVJA45Pdqx/HTw+z2hKoIW+W8sFf0
         BdA9lZgIPUj8c4dsjWU57z/pgHO/Pw8WAGMpHEU4R23bXk/dIeEgBAT5XQU8uzZFxuOe
         RX69qQv1vw85qsegqQ77I63qg+g3llA6ra7V4UR3VWe2U18WE6Nnoqi8ETcd/A3OjGxA
         jjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eZ2kEpkAO/dETR4Wy7CCjrZXNARvjTeBgYU6liP6gG0=;
        b=1p9C2OKKAuL4IJqiaV0LRxB194FXeY4QjbgZLpFaLFFJVrAWBci/sF7NyKE+YaYRjx
         jfIhVVyjPxc0mrso+ZLmEMY39/JdBPSv5ZsDV2EC+llR7q4kIxi4Cwz+hgkEYkW3ZTSF
         wOwREkNtm5xZYRY2xLU0vJfOOIahgmmC+gB5WM+hxbx0KcPTSQIjff/GEiHSukW/rQzt
         JqE2ByWDBMf6bkH3rSn0VU+yovv8dZugY36gXZ+6VHYisHHPw/XOrA6CVShkCirK5C0v
         IKcFf08itHh80Y2TkXSChSL2zzPoVQd+pGfJ6hMX1vJB8rf3hdMsECVNbeAHcgqL60Ea
         uA+A==
X-Gm-Message-State: AJIora+YLBqbJsaXGhAcoXioAzqea1UZRrJ+XAv2nPYlabOyaNJ+KDFw
        q/UcNh+PAHhGGjjeinRw7FoqrQ==
X-Google-Smtp-Source: AGRyM1vbCziSqVuzLbAke27w5ETvWlWJ8TsLgRuSfdYTX4aObXcSBf8ZFeKAA8eFHMRexvgstVSqCQ==
X-Received: by 2002:a2e:b74e:0:b0:25d:d62a:9033 with SMTP id k14-20020a2eb74e000000b0025dd62a9033mr1269948ljo.105.1658317551036;
        Wed, 20 Jul 2022 04:45:51 -0700 (PDT)
Received: from [192.168.115.193] (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id e4-20020a05651c038400b0025d33e9353esm3151405ljp.129.2022.07.20.04.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 04:45:50 -0700 (PDT)
Message-ID: <823ae0f4-b7c5-a301-0f2d-66f0e0a36aba@linaro.org>
Date:   Wed, 20 Jul 2022 13:45:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] dt-bindings: net: cdns,macb: Add versal compatible
 string
Content-Language: en-US
To:     "Katakam, Harini" <harini.katakam@amd.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
References: <20220720112924.1096-1-harini.katakam@xilinx.com>
 <20220720112924.1096-2-harini.katakam@xilinx.com>
 <d836f94c-4e87-31f6-5c3a-341e802a23a6@linaro.org>
 <BYAPR12MB477363E846E5EB15D7AA2ABF9E8E9@BYAPR12MB4773.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <BYAPR12MB477363E846E5EB15D7AA2ABF9E8E9@BYAPR12MB4773.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/07/2022 13:36, Katakam, Harini wrote:
>>> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml
>> b/Documentation/devicetree/bindings/net/cdns,macb.yaml
>>> index 9c92156869b2..1e9f49bb8249 100644
>>> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
>>> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
>>> @@ -22,6 +22,7 @@ properties:
>>>            - enum:
>>>                - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
>>>                - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
>>> +              - cdns,versal-gem       # Xilinx Versal
>>
>> Not really ordered by name. Why adding to the end?
> 
> Thanks for the review. It is just based on the order in which device
> families from Xilinx were released. I can alphabetize if that's preferred.

Yes, it's the easiest way to avoid conflicts.

Best regards,
Krzysztof
