Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE98858828B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiHBTf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiHBTf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:35:57 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067651147C;
        Tue,  2 Aug 2022 12:35:56 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id p81so11427123iod.2;
        Tue, 02 Aug 2022 12:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=je8IzPMT4x05fWjZdQbsGe6R9X7dS9v0hhBrpxg2d3A=;
        b=DNBQqehmsHO64TYXuoO/IfBeSdzAH9YJlQVg6Nj/yLH2N2YRXMnGVkIrxB+rWms3gm
         kQSRJevov9Kc7kWlqwG/LO8sBQB0ZT7P8mU5aK2IFtNWdrFB28EYP25R6A/igvg15LHv
         NbotMdfVxuX/01PRuyCzirrVBRBHFBkhLgfVJAKmdCsyloz0p4MUeRi5w/hDpmUzCqLw
         HVYQyrBVbJr8pUis3Q3hwN/z6YM4UqjfJPehLr12JpSmNVnPBFmcupJUmz88/QCzKUK5
         m+o0C+NojPUOypjqIQ7PqTIph7aJL8AHhOR/pTwmUMrjKBNMBMLrFo9Ad/N1yfe4lDec
         i/LA==
X-Gm-Message-State: AJIora+rFaHMxDetm66h5FBtjt+lQezzuNCZmuc2VWceQ5jI8xJo/fat
        Szs4GXdgjAypmSeydJIN/A==
X-Google-Smtp-Source: AGRyM1sWRCb1Hw3XjyIq16bybj1jSYaNDnLhLTVrmFNgVXfB078wWj8bRWptFCoOvzFVgO6thInA7w==
X-Received: by 2002:a6b:ba85:0:b0:67b:cd01:aef2 with SMTP id k127-20020a6bba85000000b0067bcd01aef2mr8368749iof.59.1659468955247;
        Tue, 02 Aug 2022 12:35:55 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id v18-20020a056e020f9200b002dbfcfa3233sm6090185ilo.37.2022.08.02.12.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 12:35:54 -0700 (PDT)
Received: (nullmailer pid 526062 invoked by uid 1000);
        Tue, 02 Aug 2022 19:35:52 -0000
From:   Rob Herring <robh@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        robh+dt@kernel.org, netdev@vger.kernel.org, joel@jms.id.au,
        edumazet@google.com, andrew@lunn.ch, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        l.stelmach@samsung.com, devicetree@vger.kernel.org,
        vegard.nossum@oracle.com
In-Reply-To: <20220802155947.83060-4-andrei.tachici@stud.acs.upb.ro>
References: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro> <20220802155947.83060-4-andrei.tachici@stud.acs.upb.ro>
Subject: Re: [net-next v3 3/3] dt-bindings: net: adin1110: Add docs
Date:   Tue, 02 Aug 2022 13:35:52 -0600
Message-Id: <1659468952.852417.526061.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Aug 2022 18:59:47 +0300, andrei.tachici@stud.acs.upb.ro wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 82 +++++++++++++++++++
>  1 file changed, 82 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/net/adi,adin1110.example.dts:26.17-27: Warning (reg_format): /example-0/spi/ethernet@0:reg: property has invalid length (4 bytes) (#address-cells == 2, #size-cells == 1)
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (pci_device_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (pci_device_bus_num): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (simple_bus_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (i2c_bus_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/adi,adin1110.example.dts:23.13-39.11: Warning (spi_bus_bridge): /example-0/spi: incorrect #address-cells for SPI bus
Documentation/devicetree/bindings/net/adi,adin1110.example.dts:23.13-39.11: Warning (spi_bus_bridge): /example-0/spi: incorrect #size-cells for SPI bus
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (spi_bus_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (spi_bus_reg): Failed prerequisite 'spi_bus_bridge'
Documentation/devicetree/bindings/net/adi,adin1110.example.dts:24.24-38.15: Warning (avoid_default_addr_size): /example-0/spi/ethernet@0: Relying on default #address-cells value
Documentation/devicetree/bindings/net/adi,adin1110.example.dts:24.24-38.15: Warning (avoid_default_addr_size): /example-0/spi/ethernet@0: Relying on default #size-cells value
Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: Warning (unique_unit_address_if_enabled): Failed prerequisite 'avoid_default_addr_size'

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

