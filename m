Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8DD562138
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbiF3R1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiF3R1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:27:19 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3582A3EA9A;
        Thu, 30 Jun 2022 10:27:18 -0700 (PDT)
Received: by mail-io1-f48.google.com with SMTP id r133so19821246iod.3;
        Thu, 30 Jun 2022 10:27:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gAIq4Rl9pd6TxPRv3sr3GJgtDudvjHKIBCMW/VUrpdE=;
        b=oE8p0anwU9KdLpAzwLKYsBB/NV98tbTkO2WIaqSuJoRe+fzwOKa+aM0xLfm1vHVitl
         ch62Wzq7ug6bsUreKkr/SvflnQFDnPB77VEfZtU059kbMG8oi1cPVGa6OVcwJfwCHO+4
         EqOx8gJ7D3pWIoIxxgWrhTHmpUNr0AzVygdrmPwnoVr9QdEPod73rAAc80wIaabFmh6W
         u/T8GokxM5oAs2w2DMQKPtixYpe+hZqF3YJYLkEDch2w+llharZeXCKAGPgzddIGljrH
         asQlffBtl31Ofh7WxSB6gmsJeVx6vJNJaTlZwaeIM3pn94Mp8a2zNwhU0n/SAc3k9HcU
         20vQ==
X-Gm-Message-State: AJIora/OlzILBud/RLpckBpuz8sro0snH5vjXD8QoFapPbPT0FIf14fW
        nEfywTqYoioG+EV7D+sJ5Q==
X-Google-Smtp-Source: AGRyM1uTqecJG4oLM0Hqt1nbSkcVzYR2SuSmzltnPom8Dgg7oWRL1d/WE3gL0+M9bu23yw3WQc4lpg==
X-Received: by 2002:a05:6638:1686:b0:33e:9977:2e1f with SMTP id f6-20020a056638168600b0033e99772e1fmr160037jat.7.1656610035981;
        Thu, 30 Jun 2022 10:27:15 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id p192-20020a0229c9000000b0033cd5a2b231sm1818537jap.47.2022.06.30.10.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 10:27:15 -0700 (PDT)
Received: (nullmailer pid 2943107 invoked by uid 1000);
        Thu, 30 Jun 2022 17:27:13 -0000
Date:   Thu, 30 Jun 2022 11:27:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH net-next v2 01/35] dt-bindings: phy: Add QorIQ SerDes
 binding
Message-ID: <20220630172713.GA2921749-robh@kernel.org>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628221404.1444200-2-sean.anderson@seco.com>
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

On Tue, Jun 28, 2022 at 06:13:30PM -0400, Sean Anderson wrote:
> This adds a binding for the SerDes module found on QorIQ processors. The
> phy reference has two cells, one for the first lane and one for the
> last. This should allow for good support of multi-lane protocols when
> (if) they are added. There is no protocol option, because the driver is
> designed to be able to completely reconfigure lanes at runtime.
> Generally, the phy consumer can select the appropriate protocol using
> set_mode. For the most part there is only one protocol controller
> (consumer) per lane/protocol combination. The exception to this is the
> B4860 processor, which has some lanes which can be connected to
> multiple MACs. For that processor, I anticipate the easiest way to
> resolve this will be to add an additional cell with a "protocol
> controller instance" property.
> 
> Each serdes has a unique set of supported protocols (and lanes). The
> support matrix is stored in the driver and is selected based on the
> compatible string. It is anticipated that a new compatible string will
> need to be added for each serdes on each SoC that drivers support is
> added for. There is no "generic" compatible string for this reason.
> 
> There are two PLLs, each of which can be used as the master clock for
> each lane. Each PLL has its own reference. For the moment they are
> required, because it simplifies the driver implementation. Absent
> reference clocks can be modeled by a fixed-clock with a rate of 0.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - Add #clock-cells. This will allow using assigned-clocks* to configure
>   the PLLs.
> - Allow a value of 1 for phy-cells. This allows for compatibility with
>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>   binding.
> - Document phy cells in the description
> - Document the structure of the compatible strings
> - Fix example binding having too many cells in regs
> - Move compatible first
> - Refer to the device in the documentation, rather than the binding
> - Remove minItems
> - Rename to fsl,lynx-10g.yaml
> - Use list for clock-names
> 
>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 93 +++++++++++++++++++
>  1 file changed, 93 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> new file mode 100644
> index 000000000000..b5a6f631df9f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> @@ -0,0 +1,93 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/fsl,lynx-10g.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Lynx 10G SerDes
> +
> +maintainers:
> +  - Sean Anderson <sean.anderson@seco.com>
> +
> +description: |
> +  These Lynx "SerDes" devices are found in NXP's QorIQ line of processors. The
> +  SerDes provides up to eight lanes. Each lane may be configured individually,
> +  or may be combined with adjacent lanes for a multi-lane protocol. The SerDes
> +  supports a variety of protocols, including up to 10G Ethernet, PCIe, SATA, and
> +  others. The specific protocols supported for each lane depend on the
> +  particular SoC.
> +
> +properties:
> +  compatible:
> +    description: |
> +      Each compatible is of the form "fsl,<soc-name>-serdes-<instance>".
> +      Although many registers are compatible between different SoCs, the
> +      supported protocols and lane assignments tend to be unique to each SerDes.
> +      Additionally, the method of activating protocols may also be unique.

We typically have properties for handling these variables. Numbering 
instances is something we avoid.

> +      Because of this, each SerDes instance will need its own compatible string.

> +      In cases where two SoCs share the same SerDes implementation (such as the
> +      LS1046A and LS1026A), both SoCs should share the same compatible strings.

No, not unless the 2 parts are just fuse or package pinout differences. 
Otherwise, there's always the chance they are not 'the same' and have 
different bugs.

You could have "fsl,ls1046a-serdes", "fsl,ls1026a-serdes" (whichever SoC 
is older last) if you think they are 'the same'.


> +    enum:
> +      - fsl,ls1046a-serdes-1
> +      - fsl,ls1046a-serdes-2
> +
> +  "#clock-cells":
> +    const: 1
> +    description: |
> +      The cell contains the index of the PLL, starting from 0. Note that when
> +      assigning a rate to a PLL, the PLLs' rates are divided by 1000 to avoid
> +      overflow. A rate of 5000000 corresponds to 5GHz.
> +
> +  "#phy-cells":
> +    minimum: 1
> +    maximum: 2
> +    description: |
> +      The cells contain the following arguments:
> +      - The first lane in the group. Lanes are numbered based on the register
> +        offsets, not the I/O ports. This corresponds to the letter-based ("Lane
> +        A") naming scheme, and not the number-based ("Lane 0") naming scheme. On
> +        most SoCs, "Lane A" is "Lane 0", but not always.
> +      - Last lane. For single-lane protocols, this should be the same as the
> +        first lane.
> +      If no lanes in a SerDes can be grouped, then #phy-cells may be 1, and the
> +      first cell will specify the only lane in the group.

Usually when we have per lane phys, the consumer side will have a 'phys' 
entry per lane.

Having a variable number of cells isn't great either. We usually only do 
that when we have to extend an existing binding.

> +
> +  clocks:
> +    maxItems: 2
> +    description: |
> +      Clock for each PLL reference clock input.
> +
> +  clock-names:
> +    items:
> +      - enum: &clocks
> +          - ref0
> +          - ref1
> +      - enum: *clocks

Whoa, there's a first. Don't use YAML anchors and references. We only 
support JSON subset of YAML.

> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - "#clock-cells"
> +  - "#phy-cells"
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    serdes1: phy@1ea0000 {
> +      #clock-cells = <1>;
> +      #phy-cells = <2>;
> +      compatible = "fsl,ls1046a-serdes-1";
> +      reg = <0x1ea0000 0x2000>;
> +      clocks = <&clk_100mhz>, <&clk_156mhz>;
> +      clock-names = "ref0", "ref1";
> +      assigned-clocks = <&serdes1 0>;
> +      assigned-clock-rates = <5000000>;
> +    };
> +
> +...
> -- 
> 2.35.1.1320.gc452695387.dirty
> 
> 
