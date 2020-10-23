Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDA297329
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751278AbgJWQF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:05:26 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42999 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S464923AbgJWQFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:05:25 -0400
Received: by mail-oi1-f195.google.com with SMTP id 16so2379573oix.9;
        Fri, 23 Oct 2020 09:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=h6B3ArzgJc6nb5Dbz5j9h3mdHnTGENi7PWXB7JDiTKo=;
        b=EEI0xQSmQHM6LCzyj7ZyYGVvo/J+sMKPQzYqEIKnJ+7FfUq4M0T0j6lUoUOzKCCGhi
         YzXUwjNm631HpMcSRfDAqwQIY+Gz3m0a1IknqKfYtQTYYorM5VEVCE8TtNUPdnFu8WE3
         xukRRowtNw1Y/DQ90xoNTpk9HDxHgLI260WBwYuYQGIW9s8Fwj6kBRcE2RILEj/EgiYp
         joyGNkzpPaW6+2NQC+qAiOP6R8WzNBG40/42j++5FsLUrFwhFAJq9f5jGVx4PtWGnwqO
         FGo+Es/RME8AxOYWkLY2wxgDcKL+i8qc9qTrBQp1cK1sn5T1sTWZ9/C0nx24jTVAfFV8
         GE/g==
X-Gm-Message-State: AOAM532RQrR0/76OyaD01P9b3e8oOQ2ATgEzZfiymUea+0L6mz3DTXL0
        NyuEau57rmQ8mpp1qONHAQ==
X-Google-Smtp-Source: ABdhPJz/oj1Dait+J4MMKuriXSbJFTaMopbNOZBh7cC4eghJwyShiDdQX1HalEkF9Ga+qSNgl1Vi7A==
X-Received: by 2002:aca:ea42:: with SMTP id i63mr2105586oih.130.1603469123415;
        Fri, 23 Oct 2020 09:05:23 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u186sm270282oia.30.2020.10.23.09.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 09:05:22 -0700 (PDT)
Received: (nullmailer pid 2788355 invoked by uid 1000);
        Fri, 23 Oct 2020 16:05:21 -0000
Date:   Fri, 23 Oct 2020 11:05:21 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     devicetree@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>, linux-samsung-soc@vger.kernel.org,
        jim.cromie@gmail.com, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201023160521.GA2787938@bogus>
References: <20201021214910.20001-1-l.stelmach@samsung.com>
 <CGME20201021214933eucas1p152c8fc594793aca56a1cbf008f8415a4@eucas1p1.samsung.com>
 <20201021214910.20001-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201021214910.20001-3-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 23:49:07 +0200, Łukasz Stelmach wrote:
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
./Documentation/devicetree/bindings/net/asix,ax88796c.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/asix,ax88796c.yaml#
Documentation/devicetree/bindings/net/asix,ax88796c.example.dts:20:18: fatal error: dt-bindings/interrupt-controller/gpio.h: No such file or directory
   20 |         #include <dt-bindings/interrupt-controller/gpio.h>
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[1]: *** [scripts/Makefile.lib:342: Documentation/devicetree/bindings/net/asix,ax88796c.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1366: dt_binding_check] Error 2


See https://patchwork.ozlabs.org/patch/1385812

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

