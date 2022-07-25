Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815285804BF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbiGYTue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbiGYTuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:50:32 -0400
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE642AFA;
        Mon, 25 Jul 2022 12:50:30 -0700 (PDT)
Received: by mail-il1-f171.google.com with SMTP id i5so6251769ila.6;
        Mon, 25 Jul 2022 12:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=CxwSt/xsUal4gT/5TyFDB0G+m1WCf7FRK90E3LMUQrc=;
        b=TcNU9f4t8rhOjiRGNXyBRuwpG3PO8NZopee/tOI2/7cEQRMcQeza26+C/nDszOTk2H
         jrqOl12yy4KCnjS5PUkt+RBwW0uG2T0m7WvPk0bVPPyhms3iz9PFEa8Zgb/k9Zey3uxS
         7jNV27QzyAkNOGdzAE8rcW2HbaWEgPgrCmGFjLAO0n4RHY66Xa40x2im12y4faA8JQuF
         8G+zpGyYbSGQokVzPAvhL6qoDEOjEXzaw7Y/zJESk9WZ7cYyXVJR31k+pzdaQP7P8AuY
         3AvtexYfMUVi9IFkuQpxcNl4BtA6OZQW/j68bwhgSmvegLuURe8wpTPNS8MjayPp4/yJ
         ZQuw==
X-Gm-Message-State: AJIora/8wModCwovc1o+RoEK1ZNZtqbMb63rvkWiWelvz0AGUFZmjV+i
        +MQmS0gtcPoPrrhyTQfhOA==
X-Google-Smtp-Source: AGRyM1vmtBQdIBAxkjaAqdiWHoapUP/p7td5ykwiu9kZGXUt1pqG4VV9eyZVrkCOFw9YL4f3a3ZuRA==
X-Received: by 2002:a05:6e02:152a:b0:2dc:3984:196e with SMTP id i10-20020a056e02152a00b002dc3984196emr5260393ilu.228.1658778630035;
        Mon, 25 Jul 2022 12:50:30 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q15-20020a0566022f0f00b0067b85bb05besm6208684iow.17.2022.07.25.12.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 12:50:29 -0700 (PDT)
Received: (nullmailer pid 2597631 invoked by uid 1000);
        Mon, 25 Jul 2022 19:50:27 -0000
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gerhard@engleder-embedded.com, edumazet@google.com, joel@jms.id.au,
        geert@linux-m68k.org, stephen@networkplumber.org,
        wellslutw@gmail.com, davem@davemloft.net,
        d.michailidis@fungible.com, l.stelmach@samsung.com,
        devicetree@vger.kernel.org, kuba@kernel.org,
        geert+renesas@glider.be, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan.wahren@i2se.com
In-Reply-To: <20220725165312.59471-4-alexandru.tachici@analog.com>
References: <20220725165312.59471-1-alexandru.tachici@analog.com> <20220725165312.59471-4-alexandru.tachici@analog.com>
Subject: Re: [net-next v2 3/3] dt-bindings: net: adin1110: Add docs
Date:   Mon, 25 Jul 2022 13:50:27 -0600
Message-Id: <1658778627.754213.2597630.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 19:53:12 +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 81 +++++++++++++++++++
>  1 file changed, 81 insertions(+)
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
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: ethernet@0: Unevaluated properties are not allowed ('spi-max-frequency' was unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1110.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

