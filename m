Return-Path: <netdev+bounces-9082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2514E72719C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CC3D1C20A0C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1483B8D3;
	Wed,  7 Jun 2023 22:26:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25C23B8B2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 22:26:22 +0000 (UTC)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F772738;
	Wed,  7 Jun 2023 15:25:48 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-33b3cfb9495so9836205ab.2;
        Wed, 07 Jun 2023 15:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686176656; x=1688768656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AxfRqxa7wvCqUms2E38nnMVQFutEDvjD8qThmFlsqqQ=;
        b=DdNuy2ECmX8fcc3dWWMvEN+x+yuh74aV8LlPQoQoFf+jAWgWkpCAMhfrGcFQliUo9i
         /sfIWyGNf5EBZs7tIqhHFRpz0MSJmQFpoBi+7b7kElGODNBLBmqS4iBea2ceWD9oDGbp
         lSGYhFmUBHMAElcUICRVfvKULgfZmz7guAk3Zq4WU++d1a/0epChoPn8t1BqTdsT3RTN
         mvZPzWlzSM5peyp3zGLAu0bL+voDfse625EwFM5BH5a0i4zCR4pJqVh+Fnnw+GCGb7tr
         3rSocUTRoDUwaYsoAdqEMeBt3Uo5CcobaGOMdoOIhuF31dRb+1cGoG9d8t+8n9EKXFto
         UtDg==
X-Gm-Message-State: AC+VfDwgolyEeecx5zicXtEoSkg050d0+9rum7KUv/Glc7kgnjbBBNVX
	FqienDwolmJDACHFUGIQEA==
X-Google-Smtp-Source: ACHHUZ6g3hXuPC4eptqJpM9Vm8vqGL9XoBgHJL+4Z05vG5yQgGzwgK5jP92Mg64iLxbMmF/99uNaQg==
X-Received: by 2002:a92:d341:0:b0:331:1834:7494 with SMTP id a1-20020a92d341000000b0033118347494mr9400434ilh.20.1686176656039;
        Wed, 07 Jun 2023 15:24:16 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id dq31-20020a0566384d1f00b0041f5061884asm2602719jab.29.2023.06.07.15.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 15:24:15 -0700 (PDT)
Received: (nullmailer pid 88530 invoked by uid 1000);
	Wed, 07 Jun 2023 22:24:13 -0000
Date: Wed, 7 Jun 2023 16:24:13 -0600
From: Rob Herring <robh@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org, christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v6 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Message-ID: <20230607222413.GA84415-robh@kernel.org>
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
 <1685657551-38291-3-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685657551-38291-3-git-send-email-justin.chen@broadcom.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 03:12:27PM -0700, Justin Chen wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> Add a binding document for the Broadcom ASP 2.0 Ethernet
> controller.
> 
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> ---
> v6
> 	- Moved compatible to the top
> 	- Changed quotes to be consistent
> 	- Elaborated on brcm,channel description
> 
> v5
> 	- Fix compatible string yaml format to properly capture what we want
> 
> v4
>         - Adjust compatible string example to reference SoC and HW ver
> 
> v3
>         - Minor formatting issues
>         - Change channel prop to brcm,channel for vendor specific format
>         - Removed redundant v2.0 from compat string
>         - Fix ranges field
> 
> v2
>         - Minor formatting issues
> 
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 153 +++++++++++++++++++++
>  1 file changed, 153 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> new file mode 100644
> index 000000000000..3f2bf64b65c0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> @@ -0,0 +1,153 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom ASP 2.0 Ethernet controller
> +
> +maintainers:
> +  - Justin Chen <justin.chen@broadcom.com>
> +  - Florian Fainelli <florian.fainelli@broadcom.com>
> +
> +description: Broadcom Ethernet controller first introduced with 72165
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - brcm,bcm74165-asp
> +          - const: brcm,asp-v2.1
> +      - items:
> +          - enum:
> +              - brcm,bcm72165-asp
> +          - const: brcm,asp-v2.0
> +
> +  "#address-cells":
> +    const: 1
> +  "#size-cells":
> +    const: 1
> +
> +  reg:
> +    maxItems: 1
> +
> +  ranges: true
> +
> +  interrupts:
> +    minItems: 1
> +    items:
> +      - description: RX/TX interrupt
> +      - description: Port 0 Wake-on-LAN
> +      - description: Port 1 Wake-on-LAN
> +
> +  clocks:
> +    maxItems: 1
> +
> +  ethernet-ports:
> +    type: object
> +    properties:
> +      "#address-cells":
> +        const: 1
> +      "#size-cells":
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9]+$":
> +        type: object
> +
> +        $ref: ethernet-controller.yaml#

           unevaluatedProperties: false

> +
> +        properties:
> +          reg:
> +            maxItems: 1
> +            description: Port number
> +
> +          brcm,channel:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description: |
> +              ASP Channel Number
> +
> +              The depacketizer channel that consumes packets from
> +              the unimac/port.
> +
> +        required:
> +          - reg
> +          - brcm,channel
> +
> +    additionalProperties: false

