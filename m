Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40FC6F28E0
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 14:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjD3Mfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 08:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3Mfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 08:35:38 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C48C1989;
        Sun, 30 Apr 2023 05:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682858106; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QxJ/G6lcQHIHUkoU+FXb2mJuBpcjFgAEb+SFZmNh+CRO5UW0HNg0HBPgPt4zSyLiAtXTTIsFZbhyhCOX/W5h1j9YOloiBzy/uyEq1Kva6Ca1tuLbf9Jn5X2BOU0ZsF30L+Mcrm8ecvRgioVJGO8Xg8CSHamL2yviwX7CvBX9MCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682858106; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mbfFTTWDUHeQEy/0dmjFMlo7KdHup0xcnV5ebUwGLtw=; 
        b=mI505/mm/ghOj38A1wEdRBWB/fg8g10RWC9wImaMEGmOXVp0AkOPWJHEou0o3SsbOFTi1EtrtaEmHIMZydWxyN5F9J+iNOZuz0DarTfzzhMNj4HebUXSVhEuB+wGv5sTujFytrrLi6rx6IIxvQ2MhTy+dfolHrrjM73XeS1ECqc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682858106;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=mbfFTTWDUHeQEy/0dmjFMlo7KdHup0xcnV5ebUwGLtw=;
        b=jMQb5DXkVLFaFr5YRyU/fMivEXjFFey1+0qRzn3pdn6a76grFMcesRsbSZ1MdUXi
        uRkHnx+UgzASrDIF0Z+CfypPP8rTD5KdsWDvH1QaQ4QWJYBA8lex+hc7dsx92cilgOP
        5xuRN2Ptnrz51ZrvBWms8R+g33DiopV9gpmTqmqo=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682858104107553.5919542238181; Sun, 30 Apr 2023 05:35:04 -0700 (PDT)
Message-ID: <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
Date:   Sun, 30 Apr 2023 15:34:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
To:     David Bauer <mail@david-bauer.net>, Andrew Lunn <andrew@lunn.ch>,
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
        Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230430112834.11520-1-mail@david-bauer.net>
 <20230430112834.11520-2-mail@david-bauer.net>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230430112834.11520-2-mail@david-bauer.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.04.2023 14:28, David Bauer wrote:
> Document the ability to add nodes for the MDIO bus connecting the
> switch-internal PHYs.

This is quite interesting. Currently the PHY muxing feature for the 
MT7530 switch looks for some fake ethernet-phy definitions on the 
mdio-bus where the switch is also defined.

Looking at the binding here, there will be an mdio node under the switch 
node. This could be useful to define the ethernet-phys for PHY muxing 
here instead, so we don't waste the register addresses on the parent 
mdio-bus for fake things. It looks like this should work right out of 
the box. I will do some tests.

Are there any examples as to what to configure on the switch PHYs with 
this change?

> 
> Signed-off-by: David Bauer <mail@david-bauer.net>
> ---
>   .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index e532c6b795f4..50f8f83cc440 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -128,6 +128,12 @@ properties:
>         See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
>         details for the regulator setup on these boards.
>   
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false
> +    description:
> +      Node for the internal MDIO bus connected to the embedded ethernet-PHYs.

Please set this property as false for mediatek,mt7988-switch as it 
doesn't use MDIO.

Arınç
