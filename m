Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACC91D9F77
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgESS2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:28:34 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:33373 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgESS2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:28:34 -0400
Received: by mail-il1-f194.google.com with SMTP id o67so416366ila.0;
        Tue, 19 May 2020 11:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J9uhOTh98EU4qKAMLm9nufM4MlbPiYXtLFkDWwncKGI=;
        b=A4sRrNhMVonc0sqFOnlJWimpo4Dy4yYOxmUAMu+3rEaprYvf6p4LKuuY+jQUHYvhIb
         ci2V46zDDEb1eAGXvf+PxxPKHquOu7xG4H0Ybjg8H3yyfTfEmbRfwvkY7v8VJtbuf+g3
         MGxygAf4KkuipsdwOHGondlKkzuo02KA1wHowHlHCX8gWqlsyB2la3OqayAWzwt0q9ho
         wLpiwigvt4wZXPfU2LOO3tymCxB5fmvYpgf9BXs0yqcZoec8aFDUrCz+BO4EhV1enCvZ
         DJl7XETj5cOuw+eJF83jxtJH6AeemxQz69VdQWxlZSsKktNbp1NQLAX2gmp7B+Q04t8A
         tpaQ==
X-Gm-Message-State: AOAM533fQCZFuC+Wb6N9EU7mGVtgbuVrtesbaAjWfBTYLixS4vZtpucd
        CQMPL62A+dkLgwf7ZVrNUHN7aGQ=
X-Google-Smtp-Source: ABdhPJyzGMuEyVNB7e4uRuuhX+smoH/YHIHeUureMb4VVb62KfaPIvAZVXuVI5Ucz4yOw91ZAaFLjg==
X-Received: by 2002:a05:6e02:cc1:: with SMTP id c1mr341461ilj.260.1589912913424;
        Tue, 19 May 2020 11:28:33 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id h9sm168552ioa.6.2020.05.19.11.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 11:28:32 -0700 (PDT)
Received: (nullmailer pid 424602 invoked by uid 1000);
        Tue, 19 May 2020 18:28:31 -0000
Date:   Tue, 19 May 2020 12:28:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH v2 01/14] dt-bindings: arm: add a binding document for
 MediaTek PERICFG controller
Message-ID: <20200519182831.GA418402@bogus>
References: <20200511150759.18766-1-brgl@bgdev.pl>
 <20200511150759.18766-2-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511150759.18766-2-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:07:46PM +0200, Bartosz Golaszewski wrote:
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

Don't need oneOf here.

> +      - items:
> +        - enum:
> +          - mediatek,pericfg

Doesn't match the example (which is correct).

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
> +    };
> -- 
> 2.25.0
> 
