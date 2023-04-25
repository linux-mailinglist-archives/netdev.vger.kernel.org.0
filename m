Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95A06EE1E5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbjDYMcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjDYMci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:32:38 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517294EC0;
        Tue, 25 Apr 2023 05:32:37 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33PCWAhk066095;
        Tue, 25 Apr 2023 07:32:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682425930;
        bh=CFPzwDmySEzg1N62RTR8ZiaR751KuV8ALtFldAAMJJ4=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=NWqJp9FsU8dhh+M/g5toTnXg1tkP8GLMCqgpCmGsz45eoV8Eq9q4uGB6l1IvYYW5F
         I/iBa4mX73qoV55kDZODjK5hNl2AiQORw6xikm6ZTnKiwMTkIYsgFWp3+6+y3EhMpu
         sChzTE1lqOYOyPzlS/c4Atkdq5Yd7V07dGgJq0Z4=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33PCW9ce065338
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Apr 2023 07:32:10 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 25
 Apr 2023 07:32:09 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 25 Apr 2023 07:32:09 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33PCW9SC021943;
        Tue, 25 Apr 2023 07:32:09 -0500
Date:   Tue, 25 Apr 2023 07:32:09 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Judith Mendez <jm@ti.com>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/4] dt-bindings: net: can: Add poll-interval for MCAN
Message-ID: <20230425123209.g3jocqvnnpkv4jk5@stingy>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-3-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230424195402.516-3-jm@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14:54-20230424, Judith Mendez wrote:
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt by
> hrtimer. To enable timer method, interrupts should be optional so
> remove interrupts property from required section and introduce
> poll-interval property.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v2:
>   1. Add poll-interval property to enable timer polling method
>   2. Add example using poll-interval property
>   
>  .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 67879aab623b..1c64c7a0c3df 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -40,6 +40,10 @@ properties:
>        - const: int1
>      minItems: 1
>  
> +  poll-interval:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description: Poll interval time in milliseconds.
> +
>    clocks:
>      items:
>        - description: peripheral clock
> @@ -122,15 +126,13 @@ required:
>    - compatible
>    - reg
>    - reg-names
> -  - interrupts
> -  - interrupt-names
>    - clocks
>    - clock-names
>    - bosch,mram-cfg
>  
>  additionalProperties: false
>  
> -examples:
> +example with interrupts:
>    - |
>      #include <dt-bindings/clock/imx6sx-clock.h>
>      can@20e8000 {
> @@ -149,4 +151,22 @@ examples:
>        };
>      };
>  
> +example with timer polling:

did you run dt_binding_check?
make -j`nproc` ARCH=arm64 LLVM=1 dt_binding_check DT_CHECKER_FLAGS=-m DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/can/bosch,m_can.yaml

tells me:

  LINT    Documentation/devicetree/bindings
  DTEX    Documentation/devicetree/bindings/net/can/bosch,m_can.example.dts
  CHKDT   Documentation/devicetree/bindings/processed-schema.json
/workdir/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with interrupts' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
/workdir/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with timer polling' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#

> +  - |
> +    #include <dt-bindings/clock/imx6sx-clock.h>
> +    can@20e8000 {
> +      compatible = "bosch,m_can";
> +      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
> +      reg-names = "m_can", "message_ram";
> +      poll-interval;
> +      clocks = <&clks IMX6SX_CLK_CANFD>,
> +               <&clks IMX6SX_CLK_CANFD>;
> +      clock-names = "hclk", "cclk";
> +      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
> +
> +      can-transceiver {
> +        max-bitrate = <5000000>;
> +      };
> +    };
> +
>  ...
> -- 
> 2.17.1
> 

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
