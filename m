Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6C29EFD2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgJ2P2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:28:30 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37354 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgJ2P22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:28:28 -0400
Received: by mail-oi1-f193.google.com with SMTP id f7so3588572oib.4;
        Thu, 29 Oct 2020 08:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EpRKWgX1tPOOvzmn3qMlRpzmaxwhzdwSpqqJXsX7saU=;
        b=gvOiDzL9AfOG6VcKyx7xIZRMlccaUDxNYveTVQIMaktHYdPzTfaIP530GdklMnUYNb
         /BpMc7Cdgv4DdO+6HFRJZy0CeDluJTdGDukFbvQeYeqzyqRp1fMl87B4q4nVGCVh/Rdj
         HOMUjm6XWLg8EcTrYGwJOAzYrQ6cpKOQwNBxpDjeTLznRnMKwtNqOJV0rsqpklgoKV2X
         CB4WVQhGQHRFQVRL0LMRu733tDdnzeQ1/IseFeVLr6CpL+X74W1hMFdHgiCnVcYyGkH7
         s1UO4V4nQ7QiW9fd6XMouJfaaXq0NCCfEAB1QhLFTRIRkb3Xc9pGHKY9z8eZePyQtFKg
         KgYA==
X-Gm-Message-State: AOAM533hkyCdEBtkd69ia7VvcAWjjvqN7crrWocRWtDP7OFrBwsoF2kv
        dyUdDoyqV8ii9gZwLUm/JQ==
X-Google-Smtp-Source: ABdhPJyk1aNQXOVSM1uS2UpdouLov1vtwAA30qKLYcMgCoUsjd3aWByTnY0EbbvtHB5FB5sPRZ/Hrg==
X-Received: by 2002:aca:39d6:: with SMTP id g205mr199978oia.14.1603985307084;
        Thu, 29 Oct 2020 08:28:27 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v19sm637184ota.61.2020.10.29.08.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:28:26 -0700 (PDT)
Received: (nullmailer pid 1904453 invoked by uid 1000);
        Thu, 29 Oct 2020 15:28:25 -0000
Date:   Thu, 29 Oct 2020 10:28:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, jim.cromie@gmail.com,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201029152825.GA1904089@bogus>
References: <20201028214012.9712-1-l.stelmach@samsung.com>
 <CGME20201028214017eucas1p251d5bd9f5f9db68da4ccefe8ee5e7c13@eucas1p2.samsung.com>
 <20201028214012.9712-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028214012.9712-3-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 22:40:09 +0100, Łukasz Stelmach wrote:
> Add bindings for AX88796C SPI Ethernet Adapter.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/net/asix,ax88796c.yaml           | 69 +++++++++++++++++++
>  1 file changed, 69 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/net/asix,ax88796c.example.dts:23.13-25: Warning (reg_format): /example-0/ethernet@0:reg: property has invalid length (4 bytes) (#address-cells == 1, #size-cells == 1)
Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: Warning (pci_device_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: Warning (pci_device_bus_num): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: Warning (simple_bus_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: Warning (i2c_bus_reg): Failed prerequisite 'reg_format'
Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: Warning (spi_bus_reg): Failed prerequisite 'reg_format'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: example-0: ethernet@0:reg:0: [0] is too short
	From schema: /usr/local/lib/python3.8/dist-packages/dtschema/schemas/reg.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml: ethernet@0: 'interrupt-parrent' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/asix,ax88796c.yaml


See https://patchwork.ozlabs.org/patch/1389785

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

