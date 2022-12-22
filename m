Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3584E653E2C
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiLVKUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 05:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbiLVKUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 05:20:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CDEB497;
        Thu, 22 Dec 2022 02:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09D2561A33;
        Thu, 22 Dec 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06AEC433EF;
        Thu, 22 Dec 2022 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671704412;
        bh=glWNTP6znXHeUyUwsytdDg1PRwphKPH3sNGK4sk45qc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jDTiXDKYKIsXwssxnw9wcyZWbxPNGa/fsIdaBoU08ceMSVzNDzynU8qT8qdJarQyi
         JmwHa5dcdKHXPjnPQ3E6Cr0IHvJoOz3udKtA48xt7ADmt7nJxaAJi5XrFTD7iPvmUp
         bex2YQ4/Nn56k7vw+HDT/pvjbnkNWfO0nXdfg1oNcik8xLYvknoPW4m3wKiBMvRiWH
         W62VTtAKlI69EtACgdf933PRwAIX2vFgyasfs8fqOhE8jmfHO9mZmwN2PMcvLEqi3i
         AWK2V+RvKdmSLr19NkfL9Tt7Qwd2p6GqEyaWuVtR7C3+SjyiOUuUk0JVTT2X6tVPDZ
         9JKbCr/O8kPrQ==
Message-ID: <e99d6756-e275-7dd6-a57f-1c9a120b4ef3@kernel.org>
Date:   Thu, 22 Dec 2022 11:20:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] dt-bindings: net: Add rfkill-gpio binding
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de
References: <20221221104803.1693874-1-p.zabel@pengutronix.de>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20221221104803.1693874-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/12/2022 11:48, Philipp Zabel wrote:
> Add a device tree binding document for GPIO controlled rfkill switches.
> The name, type, shutdown-gpios and reset-gpios properties are the same
> as defined for ACPI.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

You missed several maintainers. Resend.

> ---
>  .../devicetree/bindings/net/rfkill-gpio.yaml  | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/rfkill-gpio.yaml b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> new file mode 100644
> index 000000000000..6e62e6c96456
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/rfkill-gpio.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

Drop quotes.

> +
> +title: GPIO controlled rfkill switch
> +
> +maintainers:
> +  - Johannes Berg <johannes@sipsolutions.net>
> +  - Philipp Zabel <p.zabel@pengutronix.de>
> +
> +properties:
> +  compatible:
> +    const: rfkill-gpio
> +
> +  name:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: rfkill switch name, defaults to node name

There is a generic label property.

> +
> +  type:
> +    description: rfkill radio type
> +    enum:
> +      - wlan
> +      - bluetooth
> +      - ultrawideband
> +      - wimax
> +      - wwan
> +      - gps
> +      - fm
> +      - nfc

Order the list.

> +
> +  shutdown-gpios:
> +    maxItems: 1
> +
> +  reset-gpios:
> +    maxItems: 1

Reset of rfkill? It seems entire binding is a workaround of missing
reset in your device. I don't think this is suitable for binding.

> +
> +required:
> +  - compatible
> +  - type
> +
> +oneOf:
> +  - required:
> +      - shutdown-gpios
> +  - required:
> +      - reset-gpios
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    rfkill-pcie-wlan {

Generic node names, so: rfkill
> +        compatible = "rfkill-gpio";
> +        name = "rfkill-pcie-wlan";
> +        type = "wlan";
> +        shutdown-gpios = <&gpio2 25 GPIO_ACTIVE_HIGH>;
> +    };

Best regards,
Krzysztof

