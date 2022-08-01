Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAF586DAA
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiHAPXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiHAPXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:23:43 -0400
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4979EE9B;
        Mon,  1 Aug 2022 08:23:42 -0700 (PDT)
Received: by mail-io1-f53.google.com with SMTP id l24so8600949ion.13;
        Mon, 01 Aug 2022 08:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=h+EaozKCPOAR4Pt7H3+DF41E8A2I4TARDu5JctlsAKc=;
        b=pmOW9D78wmSGO/Ps/4wHQeVt9vI+q/9UYZ5/LOQcDQE3e+RsTkjGwePqElsrKXTQtj
         /ZMD10tX4ZjU5xzXS5NWTgix903r9wrTFoVDfJbd5+ZBjPESWc/uBuVbQEcxMFHrQOLE
         TJglyduHatXf5xf8e7UADdUo9eP3wVbqDZy2mgMOk5zKdNDbFDyRmyq/ucVd+FACoJtk
         FFTn/Lk+C7uygcgssyXVcilTXambbaOe8wKi8uX4F7FEd8C52Nk+xYmqaIeO8hJ2PAIC
         qud5jMxpo9oDmuS8znG7Ik46jMzzZadFKYHsD+dR1BfLHl7SJVTFUSKq0pS15tElpVNz
         zmcQ==
X-Gm-Message-State: AJIora/PWArCDxNrSoD7EsGon3wRHVuxV5c8J9qmsbEEHJZlrLE5HcYm
        nl7P/7RcJb9uqP60sTHOJQ==
X-Google-Smtp-Source: AGRyM1sbtEtvoAfQUhoXHdTBPOIKR4FoungfLRb+EiLPBcmuQIEkA8rGIIDK77b+f14A5MTJsKzOXQ==
X-Received: by 2002:a02:cbcd:0:b0:33f:6f8c:f4a6 with SMTP id u13-20020a02cbcd000000b0033f6f8cf4a6mr6450682jaq.300.1659367421281;
        Mon, 01 Aug 2022 08:23:41 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y8-20020a027308000000b00339c4e447e2sm5384819jab.151.2022.08.01.08.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 08:23:40 -0700 (PDT)
Received: (nullmailer pid 1045598 invoked by uid 1000);
        Mon, 01 Aug 2022 15:23:38 -0000
Date:   Mon, 1 Aug 2022 09:23:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sven Peter <sven@svenpeter.dev>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dt-bindings: net: Add generic Bluetooth controller
Message-ID: <20220801152338.GB1031441-robh@kernel.org>
References: <20220801103633.27772-1-sven@svenpeter.dev>
 <20220801103633.27772-2-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801103633.27772-2-sven@svenpeter.dev>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 12:36:29PM +0200, Sven Peter wrote:
> Bluetooth controllers share the common local-bd-address property.
> Add a generic YAML schema to replace bluetooth.txt for those.
> 
> Signed-off-by: Sven Peter <sven@svenpeter.dev>
> ---
> I hope it's fine to list the current Bluetooth maintainers in here
> as well.
> 
>  .../bindings/net/bluetooth-controller.yaml    | 30 +++++++++++++++++++
>  .../devicetree/bindings/net/bluetooth.txt     |  6 +---
>  2 files changed, 31 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth-controller.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth-controller.yaml b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
> new file mode 100644
> index 000000000000..0ea8a20e30f9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/bluetooth-controller.yaml
> @@ -0,0 +1,30 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/bluetooth-controller.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Bluetooth Controller Generic Binding
> +
> +maintainers:
> +  - Marcel Holtmann <marcel@holtmann.org>
> +  - Johan Hedberg <johan.hedberg@gmail.com>
> +  - Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> +
> +properties:
> +  $nodename:
> +    pattern: "^bluetooth(@.*)?$"
> +
> +  local-bd-address:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    minItems: 6
> +    maxItems: 6
> +    description:
> +      Specifies the BD address that was uniquely assigned to the Bluetooth
> +      device. Formatted with least significant byte first (little-endian), e.g.
> +      in order to assign the address 00:11:22:33:44:55 this property must have
> +      the value [55 44 33 22 11 00].
> +
> +additionalProperties: true
> +
> +...
> diff --git a/Documentation/devicetree/bindings/net/bluetooth.txt b/Documentation/devicetree/bindings/net/bluetooth.txt
> index 94797df751b8..3cb5a7b8e5ad 100644
> --- a/Documentation/devicetree/bindings/net/bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/bluetooth.txt
> @@ -1,5 +1 @@
> -The following properties are common to the Bluetooth controllers:
> -
> -- local-bd-address: array of 6 bytes, specifies the BD address that was
> -  uniquely assigned to the Bluetooth device, formatted with least significant
> -  byte first (little-endian).
> +This file has been moved to bluetooth-controller.yaml.

There's one reference to bluetooth.txt. Update it and remove this file.

Rob
