Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6568DF19
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjBGRif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBGRie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:38:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665307EDD;
        Tue,  7 Feb 2023 09:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0205560F91;
        Tue,  7 Feb 2023 17:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ADFC433A1;
        Tue,  7 Feb 2023 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675791512;
        bh=bhXZevl7/ueOvYs4UE/FXGrLbw9bx+H5XCbSilyeFXk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=h7h587fTawkt2a5j+ZF8/7L5MjzroZngsgrtUL80z2fzTYNoZU3zWaycy4/LMsouK
         CXlG4MP/nER23MqJ8xmuQ/OXbleMyeeQEm9LVMGp482IgPy5ckhkoJzcyH15f/MmLW
         M3biIqT+5bk/Xd8RQ8Or3A5P7HE1ahi8d7z0MVB9NRF7l76Gf0WjYmLL9xKD45S+jm
         Ubk3npaKZmNrzHxqUnSlLxL4SJF1CPKSYlucltf3vtSrV25uiYFBsZUizp3Lme1JgN
         1Bhi98f9GQOkEURWSY2NZdfFq2lvUYdYr6BvZq7KFlzXi5M6T/vNv+q5v3W5eN9fXu
         QNlBfhx5yGDCw==
Message-ID: <ad09a065-c10d-3061-adbe-c58724cdfde0@kernel.org>
Date:   Tue, 7 Feb 2023 18:38:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 03/11] dt-bindings: arm: mediatek: add
 'mediatek,pn_swap' property
Content-Language: en-US
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
 <a8c567cf8c3ec6fef426b64fb1ab7f6e63a0cc07.1675779094.git.daniel@makrotopia.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <a8c567cf8c3ec6fef426b64fb1ab7f6e63a0cc07.1675779094.git.daniel@makrotopia.org>
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
> Add documentation for the newly introduced 'mediatek,pn_swap' property
> to mediatek,sgmiisys.txt.
> 

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt    | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> index d2c24c277514..b38dd0fde21d 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
> @@ -14,6 +14,10 @@ Required Properties:
>  	- "mediatek,mt7986-sgmiisys_1", "syscon"
>  - #clock-cells: Must be 1
>  
> +Optional Properties:
> +
> +- mediatek,pn_swap: Invert polarity of the SGMII data lanes.

No:
1. No new properties for TXT bindings,
2. Underscore is not allowed.
3. Does not look like property of this node. This is a clock controller
or system controller, not SGMII/phy etc.

Best regards,
Krzysztof

