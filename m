Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCCE1D0515
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgEMCi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:38:58 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42682 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEMCi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:38:58 -0400
Received: by mail-oi1-f193.google.com with SMTP id i13so20161213oie.9;
        Tue, 12 May 2020 19:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mB48QmwP9BiyH2LbdU0ZoxXeDi5pgn5seQ5bqpzznwg=;
        b=D4JJlQDUaJd6f5n/AImjGpiK0Z/iR3yI0tUia87kuUaqkuEc2m7rlndasXIcb9V8S3
         1RSVrTMQ+TABEJj1HByOXhcUUB9EWXrCioh6EojeAJclVt061esLikInvf5eqQ+ISGUb
         N3M1DWUIZDVGTLch4y4kugA8qnG22/2GNDth0JDtfwVNx4rMWsVdbDwo3sb3fOMWNYzu
         3BCvS7jdCcOV8KajVHnZYUP3NziMd9j++lXVxapQ+3bBQF+WZKMdgl1tHYQBPmJtcnHf
         /zoDu/uMq/H2HeRFZgK/2ms/FJ5btUECd2bpc5oxOi3L7kmxYccY0iYcm8wyNK2lVPPt
         /tXg==
X-Gm-Message-State: AGi0Pua7/GGyRQjlkxa9GeQyafQQUkuUklpFVoao/FgeXP06/JQDaI0i
        Q3cBRAuKAX7gVd6mBoCI2g==
X-Google-Smtp-Source: APiQypI/fAJkeunIrrooBsca9jm5OufxdvNcX6Hy9olT8g0z8O/+ezwT5ubQzkvo5BteCx+UsEg1kA==
X-Received: by 2002:a05:6808:a93:: with SMTP id q19mr26255041oij.6.1589337537668;
        Tue, 12 May 2020 19:38:57 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y22sm5733356oih.57.2020.05.12.19.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:38:56 -0700 (PDT)
Received: (nullmailer pid 29317 invoked by uid 1000);
        Wed, 13 May 2020 02:38:55 -0000
Date:   Tue, 12 May 2020 21:38:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 01/11] dt-bindings: add a binding document for MediaTek
 PERICFG controller
Message-ID: <20200513023855.GA23714@bogus>
References: <20200505140231.16600-1-brgl@bgdev.pl>
 <20200505140231.16600-2-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505140231.16600-2-brgl@bgdev.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:02:21PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This adds a binding document for the PERICFG controller present on
> MediaTek SoCs. For now the only variant supported is 'mt8516-pericfg'.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  .../arm/mediatek/mediatek,pericfg.yaml        | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> new file mode 100644
> index 000000000000..74b2a6173ffb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
> @@ -0,0 +1,34 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,pericfg.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: MediaTek Peripheral Configuration Controller
> +
> +maintainers:
> +  - Bartosz Golaszewski <bgolaszewski@baylibre.com>
> +
> +properties:
> +  compatible:
> +    oneOf:

Don't need oneOf.

> +      - items:
> +        - enum:
> +          - mediatek,pericfg

PERICFG is exactly the same register set and functions on all Mediatek 
SoCs? Needs to be more specific.

> +        - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    pericfg: pericfg@10003050 {
> +        compatible = "mediatek,mt8516-pericfg", "syscon";
> +        reg = <0 0x10003050 0 0x1000>;

Default for examples is 1 cell for addr and size.

> +    };
> -- 
> 2.25.0
> 
