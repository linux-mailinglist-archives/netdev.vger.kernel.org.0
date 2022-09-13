Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C235B6962
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiIMIU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiIMIUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:20:25 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A638BE008;
        Tue, 13 Sep 2022 01:20:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663057171; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ND3H3RZS/MPuMrzk1w/QgPwGKSB4cE0JBpwBGWJ27LMJY9v/lKBW9O4H6ym2rwNaZalVPVqKK2QMud7LDWDuZDq9vlH2CsBpSAxoIeLKZrnWQHFquBKIzFVab8K4WbcUmJ3mbiJYK20qOFcTO3Co8o1bwWvDSSdXJJXhGhQByBI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663057171; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=KpT3Z+vTyRUI5wW7rWc8V4IlD/xU6jCCdxfp77xS5Ok=; 
        b=QXGOz+SmBvwJ46WQ7hEe3Wuq3fgUlJM+fXlt/TFt2VyvdZ3uSPq9Xo2V08fdp9NpObZh3fvNibo2TbsBs+8a3ugj2eN2VVeeZXtWqdkjtR3CqCYpK1Kj67JU5Y5TkFzmva/sXt6qjF/ELfEXQltTqkxpiO/idR7vrhhzcz3ud0Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663057171;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=KpT3Z+vTyRUI5wW7rWc8V4IlD/xU6jCCdxfp77xS5Ok=;
        b=BzFPuY4aS3bEKuiBKizrvEGkCNKwWyPX1BHI2Oprq+9M91PVK6CerXO67UMCjMz6
        S16B3yS0ww902y+8YmBhh/e8P8qBJ5weGhDd4xSgAb/EW5foDV1vlI4FI+BMHpBRlHD
        PfjM1DZl9nLgZD1znbjGjH8mm8beJSFBzZ4lK/5Q=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663057169472870.4451352402363; Tue, 13 Sep 2022 01:19:29 -0700 (PDT)
Message-ID: <f7d5d961-8f66-e744-ab59-0077445d5873@arinc9.com>
Date:   Tue, 13 Sep 2022 11:19:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: dsa: mt7530: stop
 requiring phy-mode on CPU ports
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-3-vladimir.oltean@nxp.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220912175058.280386-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.09.2022 20:50, Vladimir Oltean wrote:
> The common dsa-port.yaml does this (and more) since commit 2ec2fb8331af
> ("dt-bindings: net: dsa: make phylink bindings required for CPU/DSA
> ports").
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç

> ---
>   Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index fa271ee16b5e..84bb36cab518 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -165,9 +165,6 @@ patternProperties:
>             - if:
>                 required: [ ethernet ]
>               then:
> -              required:
> -                - phy-mode
> -
>                 properties:
>                   reg:
>                     enum:
