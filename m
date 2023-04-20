Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762366E8B8A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbjDTHlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbjDTHlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:41:12 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBA6448D;
        Thu, 20 Apr 2023 00:41:04 -0700 (PDT)
Received: from [IPV6:2001:b07:2ed:14ed:c5f8:7372:f042:90a2] (unknown [IPv6:2001:b07:2ed:14ed:c5f8:7372:f042:90a2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 08AA76603247;
        Thu, 20 Apr 2023 08:41:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1681976462;
        bh=ljXoAdBmIUPdNXHRwFIbmt6dA6QYtvMs1UZA2w/MBog=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=WuZeRsf3VfimvtYBQmzvqpDoQNfE0Dh+yJF34mJhdpjP1x2/BKApTThdGKmcmWhUE
         AcV6NliCbr6+zmXqT+Qjjdf4V468C3/EZIZa5Y7rSiiwg6e3jlx7zyJv3eeTXQ+h9e
         g8+TE4aWnm3Q2vphxrvRFfoqW47Wd0BazCoOn/Juai+f+p0pYumNik5TGICGlBTDR9
         HZFMUF68llVAj3/Fgn66LlQwjN84f6/1gJiOtfkaBXhezRNAaGFKOvQAgJxBZ3W0wD
         76Z0WT4fAYuG7I7n7GYyQSmCobOsKBlAEX8S/AxedsOqghZAwK4YGc7TOiJM2bXHLA
         XR8SSSqV3FMUg==
Message-ID: <f2cea4f4-121b-2c8e-3cc9-fbe524d95749@collabora.com>
Date:   Thu, 20 Apr 2023 09:40:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: mediatek: add WED RX
 binding for MT7981 eth driver
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <cover.1681930898.git.daniel@makrotopia.org>
 <e970078a937c39067d5733ddafb64d0eb56ac474.1681930898.git.daniel@makrotopia.org>
Content-Language: en-US
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <e970078a937c39067d5733ddafb64d0eb56ac474.1681930898.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 19/04/23 21:04, Daniel Golle ha scritto:
> Add compatible string for mediatek,mt7981-wed as MT7981 also supports
> RX WED just like MT7986, but needs a different firmware file.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>   .../devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml    | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> index 5c223cb063d48..2c5e04c9adcc8 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> @@ -21,6 +21,7 @@ properties:
>         - enum:
>             - mediatek,mt7622-wed
>             - mediatek,mt7986-wed
> +          - mediatek,mt7981-wed

Please, keep entries ordered. 7891 goes before 7986.

Cheers,
Angelo

