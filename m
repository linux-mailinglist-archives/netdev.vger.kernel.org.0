Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59EC6ED236
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjDXQLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjDXQLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:11:49 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753E66587;
        Mon, 24 Apr 2023 09:11:48 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-187d9c205e9so3282121fac.3;
        Mon, 24 Apr 2023 09:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682352708; x=1684944708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBeTdq0r9iEdlrwwYxuM1keYaBFUH26+tftff9VdUPE=;
        b=R3/QF/Wg7bljo+4X6afnHRX0q+rrAtzKvQJdvs7lC+U+n61EWuZM+sVIlhiBOBj5nZ
         eJ69fI2oBAf71s6XJvbaYKKKrrWUy0TAZ51WQsyGsbaQiqM1YIKoINAf1xnUyEGX7SCM
         20qERdD0d0v8nZkL+PSIaClDXGa7mkig3iXpwEN6xH+2WkB9TJtt6x/IwvvfHOjiM4JN
         9Ow4L874hnVJXvDiDHFKQfNNcBhOjoZizSiS3o3y3Z9jDswUe5CW9eg7jwEAuZSK1yy1
         LfWnNkgrs4FX766IbupuEduyYQlHgLnDe+ATiNIWqEFR8i8w8wMRHePKxK22Y6Aq7rNb
         jweg==
X-Gm-Message-State: AAQBX9fyJy6OzYb9S7NI2O4GszFFRjSOQHhrcsu0uxu2mbrLzUqKLspT
        qM6tOfV5eVlejgKD7zQUjA==
X-Google-Smtp-Source: AKy350aaRqZGh4grXECeoV3BB+PNn9XLnbZ1CiR7PzdKDi9gzsbqnlfB98YaCTZSQCBmcgkCBAvmKQ==
X-Received: by 2002:a05:6870:32d3:b0:18b:1d1a:879d with SMTP id r19-20020a05687032d300b0018b1d1a879dmr8937297oac.3.1682352707553;
        Mon, 24 Apr 2023 09:11:47 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e5-20020a9d7305000000b0069f9203967bsm4722872otk.76.2023.04.24.09.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 09:11:47 -0700 (PDT)
Received: (nullmailer pid 2761880 invoked by uid 1000);
        Mon, 24 Apr 2023 16:11:46 -0000
Date:   Mon, 24 Apr 2023 11:11:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Nikita Shubin <nikita.shubin@maquefel.me>
Cc:     Arnd Bergmann <arnd@kernel.org>, Linus Walleij <linusw@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/43] dt-bindings: net: Add DT bindings ep93xx eth
Message-ID: <20230424161146.GE2701399-robh@kernel.org>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
 <20230424123522.18302-19-nikita.shubin@maquefel.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424123522.18302-19-nikita.shubin@maquefel.me>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:34:34PM +0300, Nikita Shubin wrote:
> Add YAML bindings for ep93xx SoC.
> 
> Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
> ---
>  .../bindings/net/cirrus,ep93xx_eth.yaml       | 51 +++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml b/Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml
> new file mode 100644
> index 000000000000..7e73cf0ddde9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml
> @@ -0,0 +1,51 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/cirrus,ep93xx_eth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: The ethernet hardware included in EP93xx CPUs module Device Tree Bindings
> +
> +maintainers:
> +  - Hartley Sweeten <hsweeten@visionengravers.com>

Should be referencing ethernet-controller.yaml.

> +
> +properties:
> +  compatible:
> +    const: cirrus,ep9301-eth
> +
> +  reg:
> +    items:
> +      - description: The physical base address and size of IO range
> +
> +  interrupts:
> +    items:
> +      - description: Combined signal for various interrupt events
> +
> +  copy_addr:
> +    type: boolean
> +    description:
> +      Flag indicating that the MAC address should be copied
> +      from the IndAd registers (as programmed by the bootloader)

The bootloader is supposed to fill in local-mac-address if it sets the 
MAC address.

> +
> +  phy_id:
> +    description: MII phy_id to use

type?

There's standard properties for dealing with phy connections. Surely 
they work for this.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    eth0: eth@80010000 {

ethernet@...

> +        compatible = "cirrus,ep9301-eth";
> +        reg = <0x80010000 0x10000>;
> +        interrupt-parent = <&vic1>;
> +        interrupts = <7>;
> +        copy_addr;
> +        phy_id = < 1 >;
> +    };
> +
> +...
> -- 
> 2.39.2
> 
