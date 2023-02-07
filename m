Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560BE68DF0E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjBGRgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjBGRgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:36:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16AF3A846;
        Tue,  7 Feb 2023 09:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E96160F93;
        Tue,  7 Feb 2023 17:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72A4C433D2;
        Tue,  7 Feb 2023 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675791399;
        bh=/z7E9+35HF++GNK97Y2nz1PXW/7n1/9S1ZZ+qdWSl5M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=op88XA2u9kBjOqI/P+2tNgnm2OgpAsP4GWrYl4rwmnUDErHrls4fRQ8NjWuFids58
         aPeQv06oV4MxXSkbybNQc5od6f2lKjb/Pj3kuoh9+RA3NHUbKSzwHM03W7F8bVqHJh
         PTAv4UkW7VHxVysMGwPGM+7w5BUi88ErEbQCCtziiZBw0kczOyFlzuPUmoeByWclTo
         CBI6H/Yed6MbNHKDAkWTqxtRMXU56SuqNhVy/Um/wRTmDC9b2IMEbhSb6ShnVJyb1c
         ico9DdtpcJQJfJMCDdqvT4PL/ZdPJRMwsEf/T4sZbexTGnGgcGOA2ESm0EPhJ9O8Sn
         fdTLf3QQIaDaQ==
Message-ID: <fbc306c1-8eef-3e71-c98d-3eb6d93879f0@kernel.org>
Date:   Tue, 7 Feb 2023 18:36:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 02/11] dt-bindings: net: mediatek,net: add mt7981-eth
 binding
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <a48462893e76fc04dbb814b5ec6e79222ff90a78.1675779094.git.daniel@makrotopia.org>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <a48462893e76fc04dbb814b5ec6e79222ff90a78.1675779094.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2023 15:19, Daniel Golle wrote:
> Introduce DT bindings for the MT7981 SoC to mediatek,net.yaml.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

Since this skipped also lists, there are no automated checks running on
it, thus no point to review it.

Resend with proper address list, please.

> ---
>  .../devicetree/bindings/net/mediatek,net.yaml | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> index 7ef696204c5a..d17e2eb46118 100644
> --- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> @@ -21,6 +21,7 @@ properties:
>        - mediatek,mt7623-eth
>        - mediatek,mt7622-eth
>        - mediatek,mt7629-eth
> +      - mediatek,mt7981-eth
>        - mediatek,mt7986-eth
>        - ralink,rt5350-eth
>  
> @@ -206,6 +207,47 @@ allOf:
>  
>          mediatek,wed: false
>  
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt7981-eth
> +    then:
> +      properties:
> +        interrupts:
> +          minItems: 4
> +
> +        clocks:
> +          minItems: 15
> +          maxItems: 15
> +
> +        clock-names:
> +          items:
> +            - const: fe
> +            - const: gp2
> +            - const: gp1
> +            - const: wocpu0
> +            - const: sgmii_ck
> +            - const: sgmii_tx250m
> +            - const: sgmii_rx250m
> +            - const: sgmii_cdr_ref
> +            - const: sgmii_cdr_fb
> +            - const: sgmii2_tx250m
> +            - const: sgmii2_rx250m
> +            - const: sgmii2_cdr_ref
> +            - const: sgmii2_cdr_fb
> +            - const: netsys0
> +            - const: netsys1
> +
> +        mediatek,sgmiisys:
> +          minItems: 2
> +          maxItems: 2
> +
> +        mediatek,wed-pcie:
> +          $ref: /schemas/types.yaml#/definitions/phandle
> +          description:
> +            Phandle to the mediatek wed-pcie controller.

Do not define properties in each variant.

Best regards,
Krzysztof

