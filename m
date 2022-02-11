Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182E64B265F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350294AbiBKMux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:50:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347452AbiBKMuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:50:52 -0500
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276C6B6B;
        Fri, 11 Feb 2022 04:50:51 -0800 (PST)
Received: by mail-qt1-f171.google.com with SMTP id k25so8919254qtp.4;
        Fri, 11 Feb 2022 04:50:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=u6rmzGmHT/gQ3Tbc1nnAWIpxZbnc090wYLn3lrC8O20=;
        b=79gcpmMnZBaOoYFLrroyatLFFLB6t61v583z4MSuPJpVS2wE9qycGLDuKu/LvA6uyx
         T52ecjjBeP5+Dvtg9nOYB0HBRlaprnaMPpNNxdeekZjat1WFq6wAcA1qbjmh9O5iPeLu
         s+NgqCJlTb7l4WYs2BYHiYAxdaiVz/ubaiiGm8iniq1pS4M0sdnafiAQyE4sWl1foJAr
         YFtcJ77qfOm1qmVPulR4VCUA01ktkLVEz2ISQSqqbApHTPXBlcRhNvlQHFEFekubTE2w
         ThHDpT3JTwxAvTia5C1QZRodS4fvEUlXav2QIXf/dDjuse1LsxkAfLRN34XPfPPIMEOy
         zh3g==
X-Gm-Message-State: AOAM530Z2BCNHZy9VyiF5+vivo04XR5K15Ekh9lxc/dcIgrB0e9na1qC
        CihwM42YhpWQUR5ZBikLOQ==
X-Google-Smtp-Source: ABdhPJxnhE3MwVN8S27Aocl3jCWaP62tWrP7cI0vk9Yi0IoaXxKAmoQBS8EjSBot0OVZCNJT/mmHRQ==
X-Received: by 2002:ac8:5a08:: with SMTP id n8mr923470qta.332.1644583850026;
        Fri, 11 Feb 2022 04:50:50 -0800 (PST)
Received: from robh.at.kernel.org ([172.58.99.10])
        by smtp.gmail.com with ESMTPSA id k4sm12361409qta.6.2022.02.11.04.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:50:49 -0800 (PST)
Received: (nullmailer pid 200784 invoked by uid 1000);
        Fri, 11 Feb 2022 12:50:33 -0000
Date:   Fri, 11 Feb 2022 06:50:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH REBASED 1/2] dt-bindings: nvmem: extract NVMEM cell to
 separated file
Message-ID: <YgZbmT0WimUbZv97@robh.at.kernel.org>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220126070745.32305-1-zajec5@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 08:07:44AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This will allow adding binding for more specific cells and reusing
> (sharing) common code.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../devicetree/bindings/nvmem/cells/cell.yaml | 34 +++++++++++++++++++

Why the 'cells' subdir? cell.yaml is a bit generic for me as DT defines 
'cell' which is different from nvmem cell. While we have the path to 
distinguish, '$ref: cell.yaml' doesn't.


>  .../devicetree/bindings/nvmem/nvmem.yaml      | 22 +-----------
>  2 files changed, 35 insertions(+), 21 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/cells/cell.yaml
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/cells/cell.yaml b/Documentation/devicetree/bindings/nvmem/cells/cell.yaml
> new file mode 100644
> index 000000000000..adfc2e639f43
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/cells/cell.yaml
> @@ -0,0 +1,34 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/cells/cell.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NVMEM cell
> +
> +maintainers:
> +  - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> +
> +description: NVMEM cell is a data entry of NVMEM device.
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +    description:
> +      Offset and size in bytes within the storage device.
> +
> +  bits:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    items:
> +      - minimum: 0
> +        maximum: 7
> +        description:
> +          Offset in bit within the address range specified by reg.
> +      - minimum: 1
> +        description:
> +          Size in bit within the address range specified by reg.
> +
> +required:
> +  - reg
> +
> +additionalProperties: true
> diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.yaml b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
> index 43ed7e32e5ac..b79b51e98ee8 100644
> --- a/Documentation/devicetree/bindings/nvmem/nvmem.yaml
> +++ b/Documentation/devicetree/bindings/nvmem/nvmem.yaml
> @@ -41,27 +41,7 @@ properties:
>  
>  patternProperties:
>    "@[0-9a-f]+(,[0-7])?$":
> -    type: object
> -
> -    properties:
> -      reg:
> -        maxItems: 1
> -        description:
> -          Offset and size in bytes within the storage device.
> -
> -      bits:
> -        $ref: /schemas/types.yaml#/definitions/uint32-array
> -        items:
> -          - minimum: 0
> -            maximum: 7
> -            description:
> -              Offset in bit within the address range specified by reg.
> -          - minimum: 1
> -            description:
> -              Size in bit within the address range specified by reg.
> -
> -    required:
> -      - reg
> +    $ref: cells/cell.yaml#
>  
>  additionalProperties: true
>  
> -- 
> 2.31.1
> 
> 
