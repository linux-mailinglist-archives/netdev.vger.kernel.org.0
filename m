Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACAB6D934A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbjDFJvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbjDFJvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:51:16 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843EC10E7;
        Thu,  6 Apr 2023 02:49:48 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pkMF0-0000Cf-1R;
        Thu, 06 Apr 2023 11:49:14 +0200
Date:   Thu, 6 Apr 2023 10:49:11 +0100
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
Subject: Re: [PATCH 6/7] dt-bindings: net: dsa: mediatek,mt7530: disallow
 core-supply and io-supply
Message-ID: <ZC6Vl90k5CyeLhVE@makrotopia.org>
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-6-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406080141.22924-6-arinc.unal@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 11:01:40AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The core-supply and io-supply properties are used only on hardware that
> uses the mediatek,mt7530 compatible string. Set them to false if the
> compatible string is not mediatek,mt7530.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml          | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 3fd953b1453e..0095b7fcef72 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -299,6 +299,10 @@ allOf:
>        required:
>          - core-supply
>          - io-supply
> +    else:
> +      properties:
> +        core-supply: false
> +        io-supply: false
>  
>    - if:
>        properties:
> -- 
> 2.37.2
> 
