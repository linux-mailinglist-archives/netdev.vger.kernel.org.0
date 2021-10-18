Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E4C432861
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhJRUYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:24:40 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:37668 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJRUYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:24:39 -0400
Received: by mail-oi1-f182.google.com with SMTP id o83so1456867oif.4;
        Mon, 18 Oct 2021 13:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Q1GESrNzI0X9p3dbyTYede0NsPh2RkVpjoyNwEn14I=;
        b=x4Z13bWpVwvH+YZ/BOFlsi8iNmaSA8px8mUadz+CAyraTMjxuCefwSH8tDqSEB82ih
         uG4dVmj/WRJIKwV90NP7uxV/Dv2H16SZmbc6VRd3ws2o0VzLgDtOVP4sMSnRwux2QDIP
         3kFAec6Deo9Cwm3Jls6PXrYg2aqqzF+jFSWKBQqWkIAbRVCbcC+6L5lBk9yA0Y6hG03V
         35g9RvUWnak/vpr9QyyeHcYxL1Jj44wNRw0vlTyaWMbn2T34c7tZHNZ//dGZE0ihvzf5
         ETZ//65x7KIGiTEe4I5IoKwnpc3As/lHxdaUAxyqfuI9nRz0Zo1kuQdgpzXsPDN7z2nN
         EphQ==
X-Gm-Message-State: AOAM533xErNttb6dQAEb0J+GoL7Fq1yRALytPrpOXIx5s+viZcd4+ZXS
        BCM32eTelmfJjEFLRLyoGg==
X-Google-Smtp-Source: ABdhPJz2TgiPYPSZQfHCvzrzeimiszDamV/kXPLPJ7Dawc4pZ9Fig2c8c62WwLuBZK9znvtdyAAo0g==
X-Received: by 2002:a05:6808:2106:: with SMTP id r6mr880818oiw.72.1634588547022;
        Mon, 18 Oct 2021 13:22:27 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l19sm3273136otr.22.2021.10.18.13.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:22:26 -0700 (PDT)
Received: (nullmailer pid 2892359 invoked by uid 1000);
        Mon, 18 Oct 2021 20:22:25 -0000
Date:   Mon, 18 Oct 2021 15:22:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add schema for
 Qualcomm BAM-DMUX
Message-ID: <YW3XgaiT2jBv4D+L@robh.at.kernel.org>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-4-stephan@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011141733.3999-4-stephan@gerhold.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 04:17:35PM +0200, Stephan Gerhold wrote:
> The BAM Data Multiplexer provides access to the network data channels of
> modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
> MSM8974. It is built using a simple protocol layer on top of a DMA engine
> (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
> 
> The device tree node combines the incoming interrupt with the outgoing
> interrupts (smem-states) as well as the two DMA channels, which allows
> the BAM-DMUX driver to request all necessary resources.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Changes since RFC: None.
> ---
>  .../bindings/net/qcom,bam-dmux.yaml           | 87 +++++++++++++++++++
>  1 file changed, 87 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> new file mode 100644
> index 000000000000..33e125e70cb4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> @@ -0,0 +1,87 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,bam-dmux.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm BAM Data Multiplexer
> +
> +maintainers:
> +  - Stephan Gerhold <stephan@gerhold.net>
> +
> +description: |
> +  The BAM Data Multiplexer provides access to the network data channels
> +  of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
> +  or MSM8974. It is built using a simple protocol layer on top of a DMA engine
> +  (Qualcomm BAM DMA) and bidirectional interrupts to coordinate power control.
> +
> +properties:
> +  compatible:
> +    const: qcom,bam-dmux

Is this block the same on every SoC? It needs to be SoC specific.

> +
> +  interrupts:
> +    description:
> +      Interrupts used by the modem to signal the AP.
> +      Both interrupts must be declared as IRQ_TYPE_EDGE_BOTH.
> +    items:
> +      - description: Power control
> +      - description: Power control acknowledgment
> +
> +  interrupt-names:
> +    items:
> +      - const: pc
> +      - const: pc-ack
> +
> +  qcom,smem-states:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    description: State bits used by the AP to signal the modem.
> +    items:
> +      - description: Power control
> +      - description: Power control acknowledgment
> +
> +  qcom,smem-state-names:
> +    description: Names for the state bits used by the AP to signal the modem.
> +    items:
> +      - const: pc
> +      - const: pc-ack
> +
> +  dmas:
> +    items:
> +      - description: TX DMA channel phandle
> +      - description: RX DMA channel phandle
> +
> +  dma-names:
> +    items:
> +      - const: tx
> +      - const: rx
> +
> +required:
> +  - compatible
> +  - interrupts
> +  - interrupt-names
> +  - qcom,smem-states
> +  - qcom,smem-state-names
> +  - dmas
> +  - dma-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    mpss: remoteproc {
> +        bam-dmux {
> +            compatible = "qcom,bam-dmux";
> +
> +            interrupt-parent = <&modem_smsm>;
> +            interrupts = <1 IRQ_TYPE_EDGE_BOTH>, <11 IRQ_TYPE_EDGE_BOTH>;
> +            interrupt-names = "pc", "pc-ack";
> +
> +            qcom,smem-states = <&apps_smsm 1>, <&apps_smsm 11>;
> +            qcom,smem-state-names = "pc", "pc-ack";
> +
> +            dmas = <&bam_dmux_dma 4>, <&bam_dmux_dma 5>;
> +            dma-names = "tx", "rx";
> +        };
> +    };
> -- 
> 2.33.0
> 
> 
