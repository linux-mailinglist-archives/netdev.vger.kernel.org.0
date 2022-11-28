Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6C363A300
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 09:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiK1I3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 03:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiK1I3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 03:29:45 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD5813CC5;
        Mon, 28 Nov 2022 00:29:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1669624122; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=SlruZNjijJZzyYkvFL6OElHpvJ5NcnjnDm7tGquBFAJmCmXXZ7xyEIdvDkQNKukAaVmlVi9Bc3+T1BoMHqR4WMPHWfitmKcMQV9Qj1Z0RpcsXmHFVX1okyuAaL25m94+FDZ1/45k0UH9DWRCBCIZN2m+OW5eV4U6+fKAV6njUKw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1669624122; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=AS/14WaE2LN43smbHuSpmejZfg+JalHV2YhgqWmQEAE=; 
        b=bIFBF87ok3heWqT6Z4w322m6ip6W7S6qKVz4ihZKSzxbjoH2NheiWIRQf32n7ELZm2Vq4IubEexB1TCaDl8wy/4B5zClr8J6End6YIxYT0Y2H67doigDBMLbzLKl2UlubFKSOiQ62YMWZZZ0RB3eSViz+aWppC9gr/3t0rlMZAI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1669624122;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=AS/14WaE2LN43smbHuSpmejZfg+JalHV2YhgqWmQEAE=;
        b=JyGzTO7/cV3Df/8rep2Kwe+HTHBxB6ASQWVOwe3f4YCQRiaxNNvQEndBCMwcYe5k
        1aua5HNDimYl5QcSpfwqtl1Hw4ilAqL50Uwa9FKyisQG2QyEKCeOG0XJ0pzEb3v/dgJ
        +dE3f36wwKkyE/vzjVCX1quNzRai5Ua82TU22g74=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1669624120094627.872459276059; Mon, 28 Nov 2022 00:28:40 -0800 (PST)
Message-ID: <08784493-7e85-9224-acfa-9a87cbd325e7@arinc9.com>
Date:   Mon, 28 Nov 2022 11:28:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 06/10] dt-bindings: net: dsa: mediatek,mt7530:
 fix port description location
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-7-colin.foster@in-advantage.com>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20221127224734.885526-7-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.11.2022 01:47, Colin Foster wrote:
> The description property was located where it applies to every port, not
> just ports 5 or 6 (CPU ports). Fix this description.

I'm not sure I understand. The description for reg does apply to every 
port. Both CPU ports and user ports are described. This patch moves the 
description to under CPU ports only.

> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v2 -> v3
>    * New patch.
> 
> ---
>   .../bindings/net/dsa/mediatek,mt7530.yaml          | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 7df4ea1901ce..415e6c40787e 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -156,17 +156,6 @@ patternProperties:
>   
>       patternProperties:
>         "^(ethernet-)?port@[0-9]+$":
> -        type: object
> -        description: Ethernet switch ports
> -
> -        unevaluatedProperties: false
> -

Would be nice to mention these being removed on the patch log. Or remove 
them while doing ("dt-bindings: net: dsa: utilize base definitions for 
standard dsa switches").

> -        properties:
> -          reg:
> -            description:
> -              Port address described must be 5 or 6 for CPU port and from 0 to 5
> -              for user ports.
> -
>           allOf:
>             - $ref: dsa-port.yaml#
>             - if:
> @@ -174,6 +163,9 @@ patternProperties:
>               then:
>                 properties:
>                   reg:
> +                  description:
> +                    Port address described must be 5 or 6 for CPU port and from
> +                    0 to 5 for user ports
>                     enum:
>                       - 5
>                       - 6

Thank you for your efforts.

Arınç
