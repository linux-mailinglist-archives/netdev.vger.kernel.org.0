Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308B0464FD8
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350366AbhLAOhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:37:51 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:37663 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350332AbhLAOgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:36:52 -0500
Received: by mail-ot1-f53.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so35407972otg.4;
        Wed, 01 Dec 2021 06:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=H6m7rkj8DPoqTZFqopgze2pKI1kgM/G/Mrby5ukjdGE=;
        b=0kClOwpJ5hCDdaCKtdi8kJDr9xT9fknvp0kXF2l01J/JWJsUv7jaAKUrxivNddNhJ9
         A3blMP8jwBDI96hfrYHkNzdJqgiSR/kwBC/+/ZlMDBB3hznJrGNCOlD/13BPIYGlYjx+
         CAP5Sg4Jx/s08jU5DduokpOVr3Q8z0K/M6XrUMYJFxcITibI/Cc8GFJuXJgnyK9PgMpk
         Oq5h8Tu6SKEtnRtn8o+RfjgvsjIrhAzMXd2lJ7rZReNRAYOGWJe1cJfHSRRW1hYlu7m3
         AL+RpBcETFcpVNQU9g/An9sC/94QtJyfLJLBXy9nJ9tq24uzx5K3tptJ2ysYx0e//BsU
         oNRg==
X-Gm-Message-State: AOAM532ro/ziShjOdhqE+GGgrmOO2+p2S/z0yWHCbezPnmFBWAOLYbZb
        rsYyPRDKxT/B31eqthVnnNHF1bxSgA==
X-Google-Smtp-Source: ABdhPJzBwSLT8YLHWoK6yMQSNpniPp0mVIv+o85r1M9hWK0ych8mx/NRnEfsorSNB2DyXxIC0PryPg==
X-Received: by 2002:a9d:709a:: with SMTP id l26mr6022358otj.287.1638369204591;
        Wed, 01 Dec 2021 06:33:24 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g61sm3685059otg.43.2021.12.01.06.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 06:33:23 -0800 (PST)
Received: (nullmailer pid 1684342 invoked by uid 1000);
        Wed, 01 Dec 2021 14:33:22 -0000
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org
In-Reply-To: <20211201041228.32444-5-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com> <20211201041228.32444-5-f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/7] dt-bindings: net: Convert GENET binding to YAML
Date:   Wed, 01 Dec 2021 08:33:22 -0600
Message-Id: <1638369202.185942.1684341.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 20:12:25 -0800, Florian Fainelli wrote:
> Convert the GENET binding to YAML, leveraging brcm,unimac-mdio.yaml and
> the standard ethernet-controller.yaml files.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,bcmgenet.txt | 125 ---------------
>  .../bindings/net/brcm,bcmgenet.yaml           | 146 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 147 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml: properties:interrupts: {'minItems': 2, 'maxItems': 3, 'items': [{'description': 'general purpose interrupt line'}, {'description': 'RX and TX rings interrupt line'}, {'description': 'Wake-on-LAN interrupt line'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml: properties:clocks: {'minItems': 1, 'maxItems': 3, 'items': [{'description': 'main clock'}, {'description': 'EEE clock'}, {'description': 'Wake-on-LAN clock'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml: properties:clock-names: {'minItems': 1, 'maxItems': 3, 'items': [{'const': 'enet'}, {'const': 'enet-eee'}, {'const': 'enet-wol'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml: ignoring, error in schema: properties: interrupts
warning: no schema found in file: ./Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
Documentation/devicetree/bindings/net/brcm,bcmgenet.example.dt.yaml:0:0: /example-0/ethernet@f0b60000: failed to match any schema with compatible: ['brcm,genet-v4']
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.example.dt.yaml: mdio@e14: 'reg-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
Documentation/devicetree/bindings/net/brcm,bcmgenet.example.dt.yaml:0:0: /example-1/ethernet@f0b80000: failed to match any schema with compatible: ['brcm,genet-v4']
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.example.dt.yaml: mdio@e14: 'reg-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
Documentation/devicetree/bindings/net/brcm,bcmgenet.example.dt.yaml:0:0: /example-2/ethernet@f0ba0000: failed to match any schema with compatible: ['brcm,genet-v4']
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,bcmgenet.example.dt.yaml: mdio@e14: 'reg-names' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1561997

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

