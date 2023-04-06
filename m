Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7456D9353
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbjDFJwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbjDFJtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:49:35 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113F61FD2;
        Thu,  6 Apr 2023 02:47:58 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pkMCb-00009F-1W;
        Thu, 06 Apr 2023 11:46:45 +0200
Date:   Thu, 6 Apr 2023 10:46:42 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     arinc9.unal@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/7] dt-bindings: net: dsa: mediatek,mt7530: improve MCM
 and MT7988 information
Message-ID: <ZC6VAgweb58mfYku@makrotopia.org>
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406080141.22924-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 11:01:36AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Improve the description of the schema.
> 
> The MT7620 SoCs described are not part of the multi-chip module but rather
> built into the SoC. Mention the MT7530 MMIO driver not supporting them.
> 
> Move information for the switch on the MT7988 SoC below MT7531, and improve
> it.
> 
> List maintainers in alphabetical order by first name.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 25 ++++++++++---------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 6df995478275..7045a98d9593 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -8,29 +8,30 @@ title: MediaTek MT7530 and MT7531 Ethernet Switches
>  
>  maintainers:
>    - Arınç ÜNAL <arinc.unal@arinc9.com>
> +  - Daniel Golle <daniel@makrotopia.org>
>    - Landen Chao <Landen.Chao@mediatek.com>
>    - DENG Qingfang <dqfext@gmail.com>
>    - Sean Wang <sean.wang@mediatek.com>
> -  - Daniel Golle <daniel@makrotopia.org>
>  
>  description: |
> -  There are three versions of MT7530, standalone, in a multi-chip module and
> -  built-into a SoC.
> +  There are three versions of MT7530, standalone, in a multi-chip module, and
> +  built into an SoC.
>  
> -  MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
> -  MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
> -
> -  The MT7988 SoC comes with a built-in switch similar to MT7531 as well as four
> -  Gigabit Ethernet PHYs. The switch registers are directly mapped into the SoC's
> -  memory map rather than using MDIO. The switch got an internally connected 10G
> -  CPU port and 4 user ports connected to the built-in Gigabit Ethernet PHYs.
> +  MT7530 is a part of the multi-chip module in MT7621AT, MT7621DAT, MT7621ST and
> +  MT7623AI SoCs.
>  
>    MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs
> -  and the switch registers are directly mapped into SoC's memory map rather than
> -  using MDIO. The DSA driver currently doesn't support MT7620 variants.
> +  and the switch registers are directly mapped into the SoC's memory map rather
> +  than using MDIO. The MT7530 MMIO driver currently doesn't support these SoCs.
>  
>    There is only the standalone version of MT7531.
>  
> +  The MT7988 SoC comes with a built-in switch with four Gigabit Ethernet PHYs.
> +  The characteristics of the switch is similar to MT7531. The switch registers
> +  are directly mapped into the SoC's memory map rather than using MDIO. The
> +  switch has got an internally connected 10G CPU port and 4 user ports connected
> +  to the built-in Gigabit Ethernet PHYs.
> +
>    Port 5 on MT7530 has got various ways of configuration:
>  
>      - Port 5 can be used as a CPU port.
> -- 
> 2.37.2
> 
