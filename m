Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050512B93CB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgKSNma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:42:30 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41101 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgKSNm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:42:29 -0500
Received: by mail-ot1-f65.google.com with SMTP id o3so5275414ota.8;
        Thu, 19 Nov 2020 05:42:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rxhiq8Rx55AIfcCW+VAFmRXl0cPftVGnDOpb5M/kFl8=;
        b=CdnjqKKuDDWe+X3SyLWQCbCrRQaAMXd6keOwljFr2onE1tnFXaya2gNZ+iAonjyb8f
         R+et2zOUAvwxTnuWoq1WnMneZZY/hc3thRSuLWGdOQhLnEQ8E6T+cuMzkZA5fYPzlE8L
         Ec6JnQZeb+WKEUydde9Dozq09Lx57zRg+paSpYz+VJ16JcFePVD1cou4ZXyvx2cj/M+N
         Gh5o1r7g+qj8VH6Botx3mdauUhyDGpr0UY3EbdJl9Qj3az93QykdTp6Z0CK/7jUTczao
         6FLy3CYxaPYAO5pjk2O8x7tAxHkn+nruAzzZ6lXygOjQ+cCAfbmUdJ6r5ORseZIdntzV
         P6Ug==
X-Gm-Message-State: AOAM530Gl9lA191hlbdUPaPWA3uSBl0O2WDqW3soHjkYJxTuNzvsGoYW
        kI1oaZJVjYRF3mLiQlWsjg==
X-Google-Smtp-Source: ABdhPJwFzRW+ps56V9mMeuHSGz8jvgDFbF25FONzO67zBmbfikaLFkWFOUYUSfeF/oS5J1z1WU+MvA==
X-Received: by 2002:a9d:65c7:: with SMTP id z7mr10510540oth.25.1605793346882;
        Thu, 19 Nov 2020 05:42:26 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y15sm8885030otq.79.2020.11.19.05.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 05:42:26 -0800 (PST)
Received: (nullmailer pid 3150292 invoked by uid 1000);
        Thu, 19 Nov 2020 13:42:25 -0000
Date:   Thu, 19 Nov 2020 07:42:25 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Paul Barker <pbarker@konsulko.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        George McCollister <george.mccollister@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        devicetree@vger.kernel.org,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 01/12] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201119134225.GA3149565@bogus>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 21:30:02 +0100, Christian Eggers wrote:
> Convert the bindings document for Microchip KSZ Series Ethernet switches
> from txt to yaml.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  .../devicetree/bindings/net/dsa/ksz.txt       | 125 --------------
>  .../bindings/net/dsa/microchip,ksz.yaml       | 152 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 153 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dt.yaml: switch@0: 'ethernet-ports', 'reg', 'spi-cpha', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dt.yaml: switch@1: 'ethernet-ports', 'reg', 'spi-cpha', 'spi-cpol', 'spi-max-frequency' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml


See https://patchwork.ozlabs.org/patch/1402525

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

