Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A91689B90
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjBCO0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjBCOZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:25:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94CE66EF4;
        Fri,  3 Feb 2023 06:25:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60C85B82AE1;
        Fri,  3 Feb 2023 14:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D886C4339E;
        Fri,  3 Feb 2023 14:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675434354;
        bh=FnFLurR6aD/mKesWSxbnPpuvd9h9JjFxABX7sLbaerw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LypUN7+vWTtApRbYwlIRwDyFFUy4NZfOQX3n4Iuc7sKfAAyX+lrYAykQjof2WQrTW
         FRndf+FaBC4flW6GXdwnFCabsdlzw0ruzcqCfo9eYXUoT25pm89haMBSj+tcZJ+Ahc
         7mCedUfjlFNh2R3b/ygk0eY0cW42Eprn0lrRNc3R2LVvN8AHa8Xrdo8rmjyTi67WdV
         G7N5EdVyS2NX9kLAWWCPiyKx86qzeUlEDH0p/yeNkZOvSeQ/tO7AYn2sow9d+SrJmg
         MK/jS54K0tyRnxC+jicY7BuKH6vSICoRU8ISslV8k95A1xryDrohtcZPM+EjEgYf4p
         2ARiXfjvlybkg==
Received: by mail-vk1-f169.google.com with SMTP id bs10so2642664vkb.3;
        Fri, 03 Feb 2023 06:25:54 -0800 (PST)
X-Gm-Message-State: AO0yUKXzVABjuCUDtqDqAy+wYbbB7mLVODbXkXfIk98iVzn4ysPzi85C
        +6D/tzZpmUDG2hDnZyevj0u5RtlKErmmwVEiiQ==
X-Google-Smtp-Source: AK7set9my47fjo1R5MeR5tTewDUSl58zHnQOe/TtN8yQK66dTbm6kplm7GEpozoTzdalO33nKv531UzRMo3cj+AIHhw=
X-Received: by 2002:a05:6122:419:b0:3e8:551c:46f with SMTP id
 e25-20020a056122041900b003e8551c046fmr1559055vkd.19.1675434352823; Fri, 03
 Feb 2023 06:25:52 -0800 (PST)
MIME-Version: 1.0
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net> <20230203-dt-bindings-network-class-v1-1-452e0375200d@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v1-1-452e0375200d@jannau.net>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 3 Feb 2023 08:25:37 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+kJA0VS-SF67mhQFg0dS9KcQ-36ctGVsD78=wkrM7GUw@mail.gmail.com>
Message-ID: <CAL_Jsq+kJA0VS-SF67mhQFg0dS9KcQ-36ctGVsD78=wkrM7GUw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] dt-bindings: net: Add network-class schema for
 mac-address properties
To:     Janne Grunau <j@jannau.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 7:56 AM Janne Grunau <j@jannau.net> wrote:
>
> The ethernet-controller schema specifies "mac-address" and
> "local-mac-address" but other network devices such as wireless network
> adapters use mac addresses as well.
> The Devicetree Specification, Release v0.3 specifies in section 4.3.1
> a generic "Network Class Binding" with "address-bits", "mac-address",
> "local-mac-address" and "max-frame-size". This schema specifies the
> "address-bits" property and moves "local-mac-address" and "mac-address"
> over from ethernet-controller.yaml.
> The schema currently does not restrict MAC address size based on
> address-bits.
>
> Signed-off-by: Janne Grunau <j@jannau.net>
> ---
>  .../bindings/net/ethernet-controller.yaml          | 18 +---------
>  .../devicetree/bindings/net/network-class.yaml     | 40 ++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 17 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 00be387984ac..a5f6a09dfdea 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -17,23 +17,6 @@ properties:
>      $ref: /schemas/types.yaml#/definitions/string
>      description: Human readable label on a port of a box.
>
> -  local-mac-address:
> -    description:
> -      Specifies the MAC address that was assigned to the network device.
> -    $ref: /schemas/types.yaml#/definitions/uint8-array
> -    minItems: 6
> -    maxItems: 6
> -
> -  mac-address:
> -    description:
> -      Specifies the MAC address that was last used by the boot
> -      program; should be used in cases where the MAC address assigned
> -      to the device by the boot program is different from the
> -      local-mac-address property.
> -    $ref: /schemas/types.yaml#/definitions/uint8-array
> -    minItems: 6
> -    maxItems: 6
> -
>    max-frame-size:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description:
> @@ -226,6 +209,7 @@ dependencies:
>    pcs-handle-names: [pcs-handle]
>
>  allOf:
> +  - $ref: /schemas/net/network-class.yaml#
>    - if:
>        properties:
>          phy-mode:
> diff --git a/Documentation/devicetree/bindings/net/network-class.yaml b/Documentation/devicetree/bindings/net/network-class.yaml
> new file mode 100644
> index 000000000000..676aec1c458e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/network-class.yaml
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/network-class.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Network Class Bindings
> +
> +maintainers:
> +  - Devicetree Specification Mailing List <devicetree-spec@vger.kernel.org>
> +
> +properties:
> +  address-bits:
> +    description:
> +      Specifies number of address bits required to address the device described
> +      by this node. This property specifies number of bits in MAC address.
> +      If unspecified, the default value is 48.

You can drop the last sentence.

> +    default: 48
> +    enum: [48, 64]

I wonder if we should just deprecate this property. I see 1 occurrence
and no consumer in the kernel tree at least. I guess one could set the
length, but not have mac addresses in the DT. Otherwise you could just
infer the length from the property length. Anyways, a conversation for
another time I guess.

Rob
