Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833756F3331
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjEAPwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjEAPwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:52:53 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A73B9B;
        Mon,  1 May 2023 08:52:50 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341Fq7ZB098108;
        Mon, 1 May 2023 10:52:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682956327;
        bh=6EjnIrBgvBvk+pa76IOx41MwfQwlx5vMpLNr5Mj6YHY=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=EbD3NMBtpsEZlzicOQRtTmRENxPnjYgH4PBGZPtOAxP8s08aixYPCo//V6wLpbDPy
         xN9/HUKxCPbB+fk39XHiyak11BUhQYGinJp6d3Y2dLDvQXF2W7gfsvP5v8SvdQGRfX
         YpQYnaxw7w+S5JN3X2GYafL4kpIqtNFCVe/muPLg=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341Fq7ME087252
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 10:52:07 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 10:52:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 10:52:06 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341Fq6XZ114062;
        Mon, 1 May 2023 10:52:06 -0500
Message-ID: <cc88529c-cf01-aed7-ace9-c9d7fe379984@ti.com>
Date:   Mon, 1 May 2023 10:52:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 2/4] dt-bindings: net: can: Add poll-interval for MCAN
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Nishanth Menon <nm@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        <linux-can@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Tero Kristo <kristo@kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230424195402.516-1-jm@ti.com> <20230424195402.516-3-jm@ti.com>
 <168238155801.4123790.14706903991436332296.robh@kernel.org>
 <4ca0c282-35ea-c8c3-06f4-59d0de3b18f5@ti.com>
 <62a0c7f6-be34-903a-14ba-21324292c5ec@linaro.org>
Content-Language: en-US
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <62a0c7f6-be34-903a-14ba-21324292c5ec@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 5/1/2023 2:16 AM, Krzysztof Kozlowski wrote:
> On 28/04/2023 18:17, Mendez, Judith wrote:
>> Hello Rob,
>>
>> On 4/24/2023 7:13 PM, Rob Herring wrote:
>>>
>>> On Mon, 24 Apr 2023 14:54:00 -0500, Judith Mendez wrote:
>>>> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
>>>> routed to A53 Linux, instead they will use software interrupt by
>>>> hrtimer. To enable timer method, interrupts should be optional so
>>>> remove interrupts property from required section and introduce
>>>> poll-interval property.
>>>>
>>>> Signed-off-by: Judith Mendez <jm@ti.com>
>>>> ---
>>>> Changelog:
>>>> v2:
>>>>     1. Add poll-interval property to enable timer polling method
>>>>     2. Add example using poll-interval property
>>>>
>>>>    .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++++++++++---
>>>>    1 file changed, 23 insertions(+), 3 deletions(-)
>>>>
>>>
>>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>>
>>> yamllint warnings/errors:
>>>
>>> dtschema/dtc warnings/errors:
>>> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with interrupts' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
>>> 	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
>>> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with timer polling' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
>>> 	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
>>>
>>> doc reference errors (make refcheckdocs):
>>>
>>> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230424195402.516-3-jm@ti.com
>>>
>>> The base for the series is generally the latest rc1. A different dependency
>>> should be noted in *this* patch.
>>>
>>> If you already ran 'make dt_binding_check' and didn't see the above
>>> error(s), then make sure 'yamllint' is installed and dt-schema is up to
>>> date:
>>>
>>> pip3 install dtschema --upgrade
>>>
>>> Please check and re-submit after running the above command yourself. Note
>>> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
>>> your schema. However, it must be unset to test all examples with your schema.
>>
>> Thanks Rob, I was not getting the errors, but I have fixed now. Thanks.
> 
> There is no way your code have worked, so either you did not test it or
> your setup misses something. In both cases you would see errors, so
> please check what went wrong.

Will do, thanks for taking the time to check the patch for errors.

regards,
Judith
