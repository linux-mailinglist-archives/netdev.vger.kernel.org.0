Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7991047F982
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 00:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhLZXeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 18:34:16 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:43986 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbhLZXeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 18:34:15 -0500
Received: by mail-qt1-f176.google.com with SMTP id q14so12232934qtx.10;
        Sun, 26 Dec 2021 15:34:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=NETpgQreEkE0gE9DQPwpFwXA1UStvlAU8ygbD7hK0Xk=;
        b=sSJF8U6ipR58Rj9cbyqf+uzLiI7il0x8Mi6pVFPkYqfGK5HPb4ThoFp3xLAIglmDGV
         L4r3lTtzlwt7QSVxKsg9VwBzDGYQ+vNzmSE7Lu6cpjjQ3LbMPH6qOzKZQgch8jZLSc6r
         HEk1IVy2Ck3JCXto7C9yLe4j5/SLseDqDQWiPg9GV3ILbCzcKE4AcPJvMRMw3cbW36AG
         +CrHB1GE2ebK5E8KghCZ3LQm8hsxidSoWi5HnIyx+5U2UmXxl9GjrTOG5FZCflpxhToC
         baAjp16XF9Fpx8/hYOUQuN0IwoJsUUUBjnBUsP93Uk9ytBFEoq515ktnfhBsNXBg0Cuj
         m6kw==
X-Gm-Message-State: AOAM532X0Z3vz+sSqAZfJq8eIlmaBiCdBJDc/IWTwgkO8XN7omQqjFVK
        T83I38JojqipMbbSqeV1rg==
X-Google-Smtp-Source: ABdhPJwmB8l3yVdPMaOhVjqp2R1FQK7EFPIjxgr6FKQwo2ucLUotMAZlPjmh25e/mpIixU+4R6wxYQ==
X-Received: by 2002:a05:622a:194:: with SMTP id s20mr13118002qtw.617.1640561654156;
        Sun, 26 Dec 2021 15:34:14 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id y124sm11455493qkd.105.2021.12.26.15.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 15:34:13 -0800 (PST)
Received: (nullmailer pid 393573 invoked by uid 1000);
        Sun, 26 Dec 2021 23:34:07 -0000
From:   Rob Herring <robh@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Wright Feng <wright.feng@infineon.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Sven Peter <sven@svenpeter.dev>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-acpi@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Mark Kettenis <kettenis@openbsd.org>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-wireless@vger.kernel.org, SHA-cyfmac-dev-list@infineon.com,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
In-Reply-To: <20211226153624.162281-2-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-2-marcan@marcan.st>
Subject: Re: [PATCH 01/34] dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
Date:   Sun, 26 Dec 2021 19:34:07 -0400
Message-Id: <1640561647.363614.393572.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Dec 2021 00:35:51 +0900, Hector Martin wrote:
> This binding is currently used for SDIO devices, but these chips are
> also used as PCIe devices on DT platforms and may be represented in the
> DT. Re-use the existing binding and add chip compatibles used by Apple
> T2 and M1 platforms (the T2 ones are not known to be used in DT
> platforms, but we might as well document them).
> 
> Then, add properties required for firmware selection and calibration on
> M1 machines.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 32 +++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml: properties:apple,antenna-sku: '$def' is not one of ['$ref', 'additionalItems', 'additionalProperties', 'allOf', 'anyOf', 'const', 'contains', 'default', 'dependencies', 'dependentRequired', 'dependentSchemas', 'deprecated', 'description', 'else', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'items', 'if', 'minItems', 'minimum', 'maxItems', 'maximum', 'multipleOf', 'not', 'oneOf', 'pattern', 'patternProperties', 'properties', 'required', 'then', 'type', 'typeSize', 'unevaluatedProperties', 'uniqueItems']
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml: properties:apple,antenna-sku: 'oneOf' conditional failed, one must be fixed:
	'type' is a required property
		hint: A vendor boolean property can use "type: boolean"
	Additional properties are not allowed ('$def' was unexpected)
		hint: A vendor boolean property can use "type: boolean"
	/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml: properties:apple,antenna-sku: 'oneOf' conditional failed, one must be fixed:
		'enum' is a required property
		'const' is a required property
		hint: A vendor string property with exact values has an implicit type
		from schema $id: http://devicetree.org/meta-schemas/vendor-props.yaml#
	/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml: properties:apple,antenna-sku: 'oneOf' conditional failed, one must be fixed:
		'$ref' is a required property
		'allOf' is a required property
		hint: A vendor property needs a $ref to types.yaml
		from schema $id: http://devicetree.org/meta-schemas/vendor-props.yaml#
	hint: Vendor specific properties must have a type and description unless they have a defined, common suffix.
	from schema $id: http://devicetree.org/meta-schemas/vendor-props.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml: ignoring, error in schema: properties: apple,antenna-sku
Documentation/devicetree/bindings/mmc/mmc-controller.example.dt.yaml:0:0: /example-0/mmc@1c12000/wifi@1: failed to match any schema with compatible: ['brcm,bcm4329-fmac']
Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.example.dt.yaml:0:0: /example-0/mmc@80118000/wifi@1: failed to match any schema with compatible: ['brcm,bcm4334-fmac', 'brcm,bcm4329-fmac']
Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.example.dt.yaml:0:0: /example-0/mmc@80118000/wifi@1: failed to match any schema with compatible: ['brcm,bcm4334-fmac', 'brcm,bcm4329-fmac']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1573232

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

