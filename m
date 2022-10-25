Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4284160CEF4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiJYO2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiJYO15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:27:57 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043A6BC7B1
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:27:54 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id d13so8136000qko.5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MkOv4t1Tr+2m88Yj/LhSqe7IoeT5GjbtqmdRAIP6OEk=;
        b=wz1/lM1BcJqHxJ/Koec1Kk/14Kobm8MXoSYbeA5Pwen8/OUMGUYwd+7HTX6ePq9ipA
         8sNTEFGTkcKUMfoPiIAANQTt0VTAxX/4n8edwscf8V0xYz4kbxM4TG1BhPMJMtBH99M5
         k0Qy7rLJBmkPODWH8+QqdtTti7QA8rfetdpk8DstzIi9JLaVLAR1iFNC7PXdSODjuyc3
         9Q8P/A5aNuKxXZS9Li8SqQXaez0WLi+WPNbU84oIXLIu25X/5avG6x6nU9tqlRo0P3Mz
         f9y+mJb31hxm+1M7QZyPAQuy0LrecT0K5WjPD+MpIfur5Hggn1SsjfOxkEmM1W8R5IHO
         6jXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkOv4t1Tr+2m88Yj/LhSqe7IoeT5GjbtqmdRAIP6OEk=;
        b=7PbQUE7Hiu+zw2Ibj+Y5eYoctOITOoef0GHzekKdfMxp33OHxli5o9IqkexvynUei+
         +mdVq7JBdia80UwQ9gb28h1eruoCV9L00gaMgEsoonigI5X9oEPTdofFxpQP+7TTSPi9
         pEuwXMlau7dGDxL5fC6/2y41j+fZIsyYFGRExrh84rLFv/JBq8mADygAKm3sTFZO9HzB
         U7hn2TfMzCWSqpOOMS4jC+dhU3OLaw7CvezQ1t8U8hjFNXo7Ht9fFiVQ+lOAMgg/GQUh
         mHz3lgVSxtXWwHhsnPUdUVwfKIsSDZLOKWyBS8pno7im0p5J401SfyordKp6VCV3K5Rv
         dCeg==
X-Gm-Message-State: ACrzQf3VxPaz9qBGTuoiDjQbNcg8wWaLTC+178ZNd1+MMlfpKy9YcB/b
        AIA1JDStoX5/4/bsgooi5GlKsA==
X-Google-Smtp-Source: AMsMyM4ttW6oz+y+rCvmkcWe3ZBLOYUgO9lwtgxilDy1Bv7GGaqR6Qz38ugPzHeOeWZxNRrxQX7MdQ==
X-Received: by 2002:a05:620a:c4f:b0:6cf:33cd:2bc9 with SMTP id u15-20020a05620a0c4f00b006cf33cd2bc9mr27425389qki.99.1666708073614;
        Tue, 25 Oct 2022 07:27:53 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id o11-20020ac85a4b000000b0039cc944ebdasm1692899qta.54.2022.10.25.07.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 07:27:52 -0700 (PDT)
Message-ID: <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
Date:   Tue, 25 Oct 2022 10:27:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Content-Language: en-US
To:     Camel Guo <camel.guo@axis.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221025135243.4038706-2-camel.guo@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2022 09:52, Camel Guo wrote:
> Add documentation and an example for Maxlinear's GSW Series Ethernet
> switches.
> 
> Signed-off-by: Camel Guo <camel.guo@axis.com>
> ---
>  .../devicetree/bindings/net/dsa/mxl,gsw.yaml  | 140 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   6 +
>  3 files changed, 148 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml b/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
> new file mode 100644
> index 000000000000..8e124b7ec58c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml

Filename based on compatible, so mxl,gsw145-mdio.yaml. But see below.

> @@ -0,0 +1,140 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/mxl,gsw.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Maxlinear GSW Series Switch Device Tree Bindings

Drop "Device Tree Bindings"

> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - Camel Guo <camel.guo@axis.com>
> +
> +description:
> +  The Maxlinear's GSW Series Ethernet Switch is a highly integrated, low-power,
> +  non-blocking Gigabit Ethernet Switch.
> +
> +properties:
> +  compatible:
> +    oneOf:

You do not have multiple choices, so no need for oneOf

> +      - enum:
> +          - mxl,gsw145-mdio

Why "mdio" suffix?

> +
> +  reg:
> +    maxItems: 1
> +
> +  mdio:
> +    type: object
> +
> +    description:
> +      Container of ethernet phy devices on the MDIO bus of GSW switch
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    allOf:

No need for allOf

> +      - $ref: "http://devicetree.org/schemas/net/ethernet-phy.yaml#"

That's not an URL. Open other schemas using ethernet-phy and check how
they are doing.

You miss:

    unevaluatedProperties: false

> +
> +required:
> +  - compatible
> +  - reg
> +  - mdio
> +
> +additionalProperties: true

This cannot be true. Again - open existing bindings and do like they are
doing, not differently.

You wanted here unevaluatedProperties: false.

> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    mdio {

Hmmm... switch with MDIO is part of MDIO?

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        switch@0 {
> +            compatible = "mxl,gsw145-mdio";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            reg = <0x0>;

reg is a second property

> +
> +            ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +

Best regards,
Krzysztof

