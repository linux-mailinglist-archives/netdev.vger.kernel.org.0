Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C693159C7
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhBIW5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:57:20 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:41956 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhBIWdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:33:43 -0500
Received: by mail-oi1-f181.google.com with SMTP id v193so15755639oie.8;
        Tue, 09 Feb 2021 14:33:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/iX2s3bt8uDNQWgU3hcnj4j+Eer2ggS9c+8mDGZZ1Nw=;
        b=tjHNF6p5vfnalvE0U5qtTkNTdMSzjrAPKVheYh69D7hBtkrLiYB5O8as8XW1gc3vGn
         NmRz2lrVorNLl/qDDoB+CWhbrN6B3vfQkrDNrCOsHN88GEmjZsK+5SpOj9gWfh/cCC+Z
         sd1vbiVHUnHTA/Au1rZSn5ckSUcZmJTScvXUSepV1uI2CemkVNmG7sefidaYoaGPDphP
         yDIvDgF2KN3O2y3mPweV3Wmx8vc/nPNCL0Rp9keUPq+BKZrHhT7ZXq5DFUdGdAI2sBiE
         c9WvifS6+QTjJ4A02p6EM/fELXQC4OlN44WTeOB+9yPjmWpoq4pHF1jjWUxnF7IYlL+K
         tQcw==
X-Gm-Message-State: AOAM530Ur7IJ/fJMV6qjlFzJgvo3U6mjpnpDudeePpe8xLakz7m/ZBpZ
        SD7u3V8Ss7EBoRoGQvPT2Q==
X-Google-Smtp-Source: ABdhPJxAL4tl4M1dFOxdOSzVRHF28JqawikqUrbVHLugDyPi6f3KKRBBrFMRaXoAD21fp7uKiOdlUQ==
X-Received: by 2002:aca:5f44:: with SMTP id t65mr13529oib.46.1612909981279;
        Tue, 09 Feb 2021 14:33:01 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p16sm26592oic.6.2021.02.09.14.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 14:33:00 -0800 (PST)
Received: (nullmailer pid 337022 invoked by uid 1000);
        Tue, 09 Feb 2021 22:32:58 -0000
Date:   Tue, 9 Feb 2021 16:32:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/24] dt-bindings: net: dwmac: Detach Generic DW MAC
 bindings
Message-ID: <20210209223258.GA328873@robh.at.kernel.org>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
 <20210208135609.7685-8-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208135609.7685-8-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 04:55:51PM +0300, Serge Semin wrote:
> Currently the snps,dwmac.yaml DT bindings file is used for both DT nodes
> describing generic DW MAC devices and as DT schema with common properties
> to be evaluated against a vendor-specific DW MAC IP-cores. Due to such
> dual-purpose design the "compatible" property of the common DW MAC schema
> needs to contain the vendor-specific strings to successfully pass the
> schema evaluation in case if it's referenced from the vendor-specific DT
> bindings. That's a bad design from maintainability point of view, since
> adding/removing any DW MAC-based device bindings requires the common
> schema modification. In order to fix that let's detach the schema which
> provides the generic DW MAC DT nodes evaluation into a dedicated DT
> bindings file preserving the common DW MAC properties declaration in the
> snps,dwmac.yaml file. By doing so we'll still provide a common properties
> evaluation for each vendor-specific MAC bindings which refer to the
> common bindings file, while the generic DW MAC DT nodes will be checked
> against the new snps,dwmac-generic.yaml DT schema.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> ---
> 
> Changelog v2:
> - Add a note to the snps,dwmac-generic.yaml bindings file description of
>   a requirement to create a new DT bindings file for the vendor-specific
>   versions of the DW MAC.
> ---
>  .../bindings/net/snps,dwmac-generic.yaml      | 154 ++++++++++++++++++
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 139 +---------------
>  2 files changed, 155 insertions(+), 138 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> new file mode 100644
> index 000000000000..6c3bf5b2f890
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml
> @@ -0,0 +1,154 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/snps,dwmac-generic.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Synopsys DesignWare Generic MAC Device Tree Bindings
> +
> +maintainers:
> +  - Alexandre Torgue <alexandre.torgue@st.com>
> +  - Giuseppe Cavallaro <peppe.cavallaro@st.com>
> +  - Jose Abreu <joabreu@synopsys.com>
> +
> +description:
> +  The primary purpose of this bindings file is to validate the Generic
> +  Synopsys Desginware MAC DT nodes defined in accordance with the select
> +  schema. All new vendor-specific versions of the DW *MAC IP-cores must
> +  be described in a dedicated DT bindings file.
> +
> +# Select the DT nodes, which have got compatible strings either as just a
> +# single string with IP-core name optionally followed by the IP version or
> +# two strings: one with IP-core name plus the IP version, another as just
> +# the IP-core name.
> +select:
> +  properties:
> +    compatible:
> +      oneOf:
> +        - items:
> +            - pattern: "^snps,dw(xg)+mac(-[0-9]+\\.[0-9]+a?)?$"

Use '' instead of "" and you can skip the double \.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +        - items:
> +            - pattern: "^snps,dwmac-[0-9]+\\.[0-9]+a?$"
> +            - const: snps,dwmac
> +        - items:
> +            - pattern: "^snps,dwxgmac-[0-9]+\\.[0-9]+a?$"
> +            - const: snps,dwxgmac
