Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AB666D83A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbjAQIcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbjAQIb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:31:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A711ABD2;
        Tue, 17 Jan 2023 00:31:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D13E8B811E6;
        Tue, 17 Jan 2023 08:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4560CC433F0;
        Tue, 17 Jan 2023 08:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673944315;
        bh=8uUX5CbGfhfHSNhlfNoYAhVgzakXKP3QFtiVxG4xGQY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CBMC1byv8p64gKubbCku9nqX58IT5fcGTAQYVcZ299UD8F+G6shUftd6FiezC34pI
         Lmh6grgyHTvY28URYg7vKRkHPODXuzOhFaR09WM6OLrwnWptvykjgjyQIU4TU6rq7J
         bp5a918ji0C6a5+0cYYYyu7SMYca3GDK10dLmEcIHOA+JcLczFLNQlHEN0soZn4ZPe
         Qk5v99FUy4zqFBysZmL+KvLokW92AfkS3fDCMvKlX4Nk/8lVMqJc+oBtxV89yOmVZt
         4XQHei6XzfIkt5eNdXXO4O9u9xrxCu5q/QHwTDigJkrzzanmKT7tTkmxFWasot9IVj
         eo1giXE1PeGVA==
Message-ID: <4be60ea2-cb67-7695-1144-bf39453e9e1f@kernel.org>
Date:   Tue, 17 Jan 2023 09:31:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: add amlogic gxl mdio
 multiplexer
To:     Jerome Brunet <jbrunet@baylibre.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-2-jbrunet@baylibre.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230116091637.272923-2-jbrunet@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2023 10:16, Jerome Brunet wrote:
> Add documentation for the MDIO bus multiplexer found on the Amlogic GXL
> SoC family

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

> 
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
>  .../bindings/net/amlogic,gxl-mdio-mux.yaml    | 64 +++++++++++++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml b/Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
> new file mode 100644
> index 000000000000..d21bce695fa9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
> @@ -0,0 +1,64 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/amlogic,gxl-mdio-mux.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Amlogic GXL MDIO bus multiplexer
> +
> +maintainers:
> +  - Jerome Brunet <jbrunet@baylibre.com>
> +
> +description:
> +  This is a special case of a MDIO bus multiplexer. It allows to choose between
> +  the internal mdio bus leading to the embedded 10/100 PHY or the external
> +  MDIO bus on the Amlogic GXL SoC family.
> +
> +allOf:
> +  - $ref: mdio-mux.yaml#
> +
> +properties:
> +  compatible:
> +    const: amlogic,gxl-mdio-mux
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: ref
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    eth_phy_mux: mdio@558 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      compatible = "amlogic,gxl-mdio-mux";

compatible, then reg then the rest.

> +      clocks = <&refclk>;
> +      clock-names = "ref";
> +      reg = <0x558 0xc>;
> +      mdio-parent-bus = <&mdio0>;
> +
> +      external_mdio: mdio@0 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        reg = <0x0>;

reg is before other properties.

> +      };
> +
> +      internal_mdio: mdio@1 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        reg = <0x1>;

Ditto. If you resend, keep my tag and finally use get_maintainers.pl

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof

