Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB215A3DFC
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 16:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiH1OVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 10:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiH1OVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 10:21:20 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC01C1928D;
        Sun, 28 Aug 2022 07:21:19 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id p187so7717462oia.9;
        Sun, 28 Aug 2022 07:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=sibDZma8SNC/1fdSULSJhZLiuhIbQTJjp2sPIcXm9F0=;
        b=tpmfSrXkOh/lB/uPbLfzk1/QvyQ4FFA4KWqozCU3AbDQv8gbS/K2UpTX2BZfhEBujU
         Wjk0Q4G992UZUjnAK+mHRkekML7svESNzZ0HcX/S59/7xRMiIxZgxLzsOct3H/JM0E5E
         MlYQlpjf1NM+uEvQXw1ha9juiOdyVSK4FHqDOBCCTXkKPN/H4BcqqCoxMOByIUYsENrJ
         NzFsKGXz42LAp9BKYD0CqS5ovYoxkgN5YffLMMFBfVJdeHupEB64tnjpS50t1WB8gwrL
         0o+djr/9IIONQAt5b4oSFH6/eR6tb29sKOLJMJ1VqIT8LGYXFWMJqyN0MQUhZDaCnZnB
         iM8Q==
X-Gm-Message-State: ACgBeo0yft2VjS/voBlF9qFNp1v/PpishtfdisGaOvOuEf26J68uwIMb
        PUKoEVZ0rllOO9kKgZQilw==
X-Google-Smtp-Source: AA6agR6BEiMKL2SlsQk0aVmQ0dN6+2z35akCIfyts949Lp8DmwKEBIdcRy/TMS8pFCS2MEZvN2bb8w==
X-Received: by 2002:a05:6808:7dd:b0:344:997f:32c3 with SMTP id f29-20020a05680807dd00b00344997f32c3mr4981010oij.11.1661696478999;
        Sun, 28 Aug 2022 07:21:18 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x26-20020a4a2a5a000000b0041ba884d42csm3867442oox.42.2022.08.28.07.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 07:21:17 -0700 (PDT)
Received: (nullmailer pid 3159699 invoked by uid 1000);
        Sun, 28 Aug 2022 14:21:16 -0000
From:   Rob Herring <robh@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20220826135451.526756-2-maxime.chevallier@bootlin.com>
References: <20220826135451.526756-1-maxime.chevallier@bootlin.com> <20220826135451.526756-2-maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: Convert Altera TSE bindings to yaml
Date:   Sun, 28 Aug 2022 09:21:16 -0500
Message-Id: <1661696476.844936.3159698.nullmailer@robh.at.kernel.org>
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

On Fri, 26 Aug 2022 15:54:47 +0200, Maxime Chevallier wrote:
> This converts the bindings for the Altera Triple-Speed Ethernet to yaml.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  .../devicetree/bindings/net/altera_tse.txt    | 113 ---------------
>  .../devicetree/bindings/net/altr,tse.yaml     | 134 ++++++++++++++++++
>  2 files changed, 134 insertions(+), 113 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
>  create mode 100644 Documentation/devicetree/bindings/net/altr,tse.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/altr,tse.yaml: allOf:1:then:properties:reg-names: {'maxItems': 4, 'items': [{'const': 'control_port'}, {'const': 'rx_csr'}, {'const': 'tx_csr'}, {'const': 's1'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/altr,tse.yaml: allOf:2:then:properties:reg-names: 'oneOf' conditional failed, one must be fixed:
	[{'const': 'control_port'}, {'const': 'rx_csr'}, {'const': 'rx_desc'}, {'const': 'rx_resp'}, {'const': 'tx_csr'}, {'const': 'tx_desc'}] is too long
	[{'const': 'control_port'}, {'const': 'rx_csr'}, {'const': 'rx_desc'}, {'const': 'rx_resp'}, {'const': 'tx_csr'}, {'const': 'tx_desc'}] is too short
	False schema does not allow 6
	1 was expected
	6 is greater than the maximum of 2
	6 is greater than the maximum of 3
	6 is greater than the maximum of 4
	6 is greater than the maximum of 5
	hint: "minItems" is only needed if less than the "items" list length
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/altr,tse.yaml: ignoring, error in schema: allOf: 1: then: properties: reg-names
Documentation/devicetree/bindings/net/altr,tse.example.dtb:0:0: /example-0/ethernet@1,00001000: failed to match any schema with compatible: ['altr,tse-msgdma-1.0']
Documentation/devicetree/bindings/net/altr,tse.example.dtb:0:0: /example-0/ethernet@1,00001000/mdio: failed to match any schema with compatible: ['altr,tse-mdio']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

