Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735A46F1C75
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346014AbjD1QR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjD1QRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:17:54 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49BC135;
        Fri, 28 Apr 2023 09:17:52 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33SGHL5Q058563;
        Fri, 28 Apr 2023 11:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682698641;
        bh=NDNmB15csVq52QGrJG43+4WY3PAWdHduZDfYDdEr4QE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=ur94zBU+mZwP7FosfA9NyBcqgznXlFhjNiNZZ9cY9R5s887mWbf5fEhMzqp+e20Ep
         AQ8vu9k0XL8UdhThYdRPGCHaHaJIMxef9Rm6o51/QokXkfpEshDMgo8aDU8Kodpf7P
         eUztAKHQpyTwMU//Ty/K5fwPROsYpU5Vem1ucjak=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33SGHK7Z024029
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Apr 2023 11:17:20 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 28
 Apr 2023 11:17:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 28 Apr 2023 11:17:20 -0500
Received: from [128.247.81.102] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33SGHKRI074613;
        Fri, 28 Apr 2023 11:17:20 -0500
Message-ID: <4ca0c282-35ea-c8c3-06f4-59d0de3b18f5@ti.com>
Date:   Fri, 28 Apr 2023 11:17:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/4] dt-bindings: net: can: Add poll-interval for MCAN
To:     Rob Herring <robh@kernel.org>
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
Content-Language: en-US
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <168238155801.4123790.14706903991436332296.robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 4/24/2023 7:13 PM, Rob Herring wrote:
> 
> On Mon, 24 Apr 2023 14:54:00 -0500, Judith Mendez wrote:
>> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
>> routed to A53 Linux, instead they will use software interrupt by
>> hrtimer. To enable timer method, interrupts should be optional so
>> remove interrupts property from required section and introduce
>> poll-interval property.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> ---
>> Changelog:
>> v2:
>>    1. Add poll-interval property to enable timer polling method
>>    2. Add example using poll-interval property
>>
>>   .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++++++++++---
>>   1 file changed, 23 insertions(+), 3 deletions(-)
>>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with interrupts' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
> 	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with timer polling' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
> 	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230424195402.516-3-jm@ti.com
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.

Thanks Rob, I was not getting the errors, but I have fixed now. Thanks.

regards,
Judith


