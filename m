Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0733B42267D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhJEM2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:28:55 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:44637 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbhJEM2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 08:28:46 -0400
Received: by mail-ot1-f42.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso25595864otb.11;
        Tue, 05 Oct 2021 05:26:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=TOadmaZADYOC0ybRj6l7qb8U5jTl328RS0X/LcbFx4w=;
        b=cL3GOE0aGjFEZwYn9wypqnLnFwfD/VmlBnoprxq6SEAGBH3Ys9eoqUSOCwZ6SRVlM3
         riF86dsgZCO5LWSV/DyPS8d5XrygII/AJ+XXK0uBachkSZx+d4ruuglLm/ka5gQpd/c2
         IRG4EXyjmb8s9nW2Wu9KPSanAuDdmWzztRHh/VucgiH4YsU5E36AdzLD+QWyGRXMnoCX
         FtIaIVrlR3BEcYc6+t++NmiIzglkZOJ55pMxhJYMP4fI7XIsMwo7W5RzmDZbMh0sAzxI
         lg1wVD5++V5Uc93s2NbKBjFIyAiw4vk7BvTq37RZV8PGARs5F1rZXM+H9OE6whDMjwm2
         ltmg==
X-Gm-Message-State: AOAM533FuhA0cs8wSKzPFE8D6awDAyvPSl6/vmI1ldfZ4TDKNp66mIGc
        6py+lOWogMukKsQHWjI/0g==
X-Google-Smtp-Source: ABdhPJzckPj7NT01ADc6LB6dFM+WwHwMGdM5cLn46F8PK9A+owlZeq8wwUc/UyeSGE7FPc6mrpatRQ==
X-Received: by 2002:a9d:7257:: with SMTP id a23mr14495329otk.311.1633436815163;
        Tue, 05 Oct 2021 05:26:55 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t17sm3516145otl.56.2021.10.05.05.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 05:26:54 -0700 (PDT)
Received: (nullmailer pid 3226796 invoked by uid 1000);
        Tue, 05 Oct 2021 12:26:38 -0000
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
In-Reply-To: <20211004191527.1610759-3-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com> <20211004191527.1610759-3-sean.anderson@seco.com>
Subject: Re: [RFC net-next PATCH 02/16] dt-bindings: net: Add binding for Xilinx PCS
Date:   Tue, 05 Oct 2021 07:26:38 -0500
Message-Id: <1633436798.527798.3226795.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 04 Oct 2021 15:15:13 -0400, Sean Anderson wrote:
> This adds a binding for the Xilinx 1G/2.5G Ethernet PCS/PMA or SGMII
> LogiCORE IP. This device is a soft device typically used to adapt between
> GMII and SGMII or 1000BASE-X (in combination with a suitable SERDES). The
> standard property is roughly analogous to the interface property of
> ethernet controllers, except that it has an additional value used to
> indicate that dynamic switching is supported. Note that switching is
> supported only between SGMII and 1000BASE-X, and only if the appropriate
> parameter is set when the device is synthesized. The property name was
> chosen to align with the terminology in the datasheet. I also considered
> "mdi", but that is a bit of a misnomer in the case of SGMII.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  .../devicetree/bindings/net/xilinx,pcs.yaml   | 83 +++++++++++++++++++
>  1 file changed, 83 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/xilinx,pcs.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx,pcs.yaml: properties:compatible:contains:const: ['xilinx,pcs-16.2'] is not of type 'string'
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx,pcs.yaml: properties:clocks: {'maxItems': 1, 'items': [{'description': 'The reference clock for the PMD, which is typically a SERDES but may be a direct interface to LVDS I/Os. Depending on your setup, this may be the gtrefclk, refclk, or clk125m signal.'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx,pcs.yaml: properties:clocks: 'oneOf' conditional failed, one must be fixed:
	/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx,pcs.yaml: properties:clocks: 'anyOf' conditional failed, one must be fixed:
		'items' is not one of ['maxItems', 'description', 'deprecated']
			hint: Only "maxItems" is required for a single entry if there are no constraints defined for the values.
		'maxItems' is not one of ['description', 'deprecated', 'const', 'enum', 'minimum', 'maximum', 'multipleOf', 'default', '$ref']
		'items' is not one of ['description', 'deprecated', 'const', 'enum', 'minimum', 'maximum', 'multipleOf', 'default', '$ref']
		1 is less than the minimum of 2
			hint: Arrays must be described with a combination of minItems/maxItems/items
		hint: cell array properties must define how many entries and what the entries are when there is more than one entry.
		from schema $id: http://devicetree.org/meta-schemas/clocks.yaml#
	'maxItems' is not one of ['type', 'description', 'dependencies', 'properties', 'patternProperties', 'additionalProperties', 'unevaluatedProperties', 'deprecated', 'required', 'allOf', 'anyOf', 'oneOf', '$ref']
	'items' is not one of ['type', 'description', 'dependencies', 'properties', 'patternProperties', 'additionalProperties', 'unevaluatedProperties', 'deprecated', 'required', 'allOf', 'anyOf', 'oneOf', '$ref']
	'type' is a required property
		hint: DT nodes ("object" type in schemas) can only use a subset of json-schema keywords
	from schema $id: http://devicetree.org/meta-schemas/clocks.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/xilinx,pcs.yaml: ignoring, error in schema: properties: compatible: contains: const
warning: no schema found in file: ./Documentation/devicetree/bindings/net/xilinx,pcs.yaml
Documentation/devicetree/bindings/net/xilinx,pcs.example.dt.yaml:0:0: /example-0/mdio/ethernet-pcs@0: failed to match any schema with compatible: ['xlnx,pcs-16.2']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1536331

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

