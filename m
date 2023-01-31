Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4DB683523
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjAaS0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjAaS0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:26:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330427D7E;
        Tue, 31 Jan 2023 10:26:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEC03B81E21;
        Tue, 31 Jan 2023 18:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245F1C433D2;
        Tue, 31 Jan 2023 18:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675189566;
        bh=lkbkiaZrD8zXRI/8NCIDbrXjxjGi9DThHe+rjAlqA5w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=euAsoBtPzn/yYx5mlQiQtm26AtDlx68REJAuTRiDW4BOSy3CBk/q9XRaDsoDtUPmp
         CoB2/Pu9xwupxGVScMGKmS2HfTGWPUl4cmiDYF/TFq8rWH7n02RJWfiYqPX6iEUYls
         VUaeInSYwlTD33ytr3rvAopR4D4YYnVPbHyJzBJgcWYwdDF0jFcfZQBPQaZLLfEv/x
         qJqxhnvgxx+Bp33hb3ivX4UxTf0Y3wVQaQkhn7wJBTpL7JtYETbMtybvOs3uT4/wSA
         NNdejM649swXEZVONGWcEBoWRcprVUo2RiXdR/O5We0o2jLRfqR2qmdEug1IDcciIn
         oFOd7GMGqMNrw==
Message-ID: <e37497f5-bca7-aa9a-6629-472cbd8072a3@kernel.org>
Date:   Tue, 31 Jan 2023 19:25:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
To:     Frank Sae <Frank.Sae@motor-comm.com>,
        Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230128031314.19752-1-Frank.Sae@motor-comm.com>
 <20230128031314.19752-2-Frank.Sae@motor-comm.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230128031314.19752-2-Frank.Sae@motor-comm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2023 04:13, Frank Sae wrote:
>  Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.
>  
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

This missed also DT list so it means it won't be tested.

> ---
>  .../bindings/net/motorcomm,yt8xxx.yaml        | 102 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   1 +
>  3 files changed, 105 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> new file mode 100644
> index 000000000000..b666584d51eb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -0,0 +1,102 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MotorComm yt8xxx Ethernet PHY
> +
> +maintainers:
> +  - frank sae <frank.sae@motor-comm.com>
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:

I think the problem of missing compatible is still not solved...

> +  rx-internal-delay-ps:
> +    description: |
> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650,
> +            1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
> +            2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
> +    default: 1900
> +
> +  tx-internal-delay-ps:
> +    description: |
> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800,
> +            1950, 2100, 2250 ]
> +    default: 150
> +
> +  motorcomm,clk-out-frequency-hz:
> +    description: clock output on clock output pin.
> +    enum: [0, 25000000, 125000000]
> +    default: 0
> +
> +  motorcomm,keep-pll-enabled:
> +    description: |
> +      If set, keep the PLL enabled even if there is no link. Useful if you
> +      want to use the clock output without an ethernet link.
> +    type: boolean
> +
> +  motorcomm,auto-sleep-disabled:
> +    description: |
> +      If set, PHY will not enter sleep mode and close AFE after unplug cable
> +      for a timer.
> +    type: boolean
> +
> +  motorcomm,tx-clk-adj-enabled:
> +    description: |
> +      This configuration is mainly to adapt to VF2 with JH7110 SoC.
> +      Useful if you want to use tx-clk-xxxx-inverted to adj the delay of tx clk.
> +    type: boolean
> +
> +  motorcomm,tx-clk-10-inverted:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 10Mbps.
> +    type: boolean
> +
> +  motorcomm,tx-clk-100-inverted:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 100Mbps.
> +    type: boolean
> +
> +  motorcomm,tx-clk-1000-inverted:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
> +    type: boolean
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    mdio0 {

mdio

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy-mode = "rgmii-id";
> +        ethernet-phy@4 {
> +            reg = <4>;
> +            rx-internal-delay-ps = <2100>;
> +            tx-internal-delay-ps = <150>;
> +            motorcomm,clk-out-frequency-hz = <0>;
> +            motorcomm,keep-pll-enabled;
> +            motorcomm,auto-sleep-disabled;
> +        };
> +    };
> +  - |
> +    mdio0 {

mdio

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phy-mode = "rgmii";
> +        ethernet-phy@5 {
> +            reg = <5>;
> +            motorcomm,clk-out-frequency-hz = <125000000>;
> +            motorcomm,keep-pll-enabled;
> +            motorcomm,auto-sleep-disabled;
> +        };
> +    };

Best regards,
Krzysztof

