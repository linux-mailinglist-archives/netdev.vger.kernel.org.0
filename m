Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362D35BB2E5
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIPTlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIPTla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:41:30 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11941835C;
        Fri, 16 Sep 2022 12:41:29 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id t8-20020a9d5908000000b0063b41908168so15535397oth.8;
        Fri, 16 Sep 2022 12:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rnBpLy/J1dgd76aFhw5FRIiMycfqNVIws11h81p/NbU=;
        b=w8EJQ9HuinnqzdUivoC9wyIv4hqI+k81G9PXuOsBNfCwev8PnonvKbpq/XsLbKRzcv
         7ta5mjGADY7rGIacGTYhqWdJ9pi6ToPoCLcOSI3PXpn+lHGQutfEk3Oo11BfRNhmeW6X
         d6aV3Ipnn6zqDN2mvxlikPeZN0dQjCPEpjgtl4T7sOStGs8KZjf/O5ZztVMQ3zA9xdfV
         q2rJ8kGbWKAH0W53n/iSz7El+iUxmj4lhc6PibLuHYcGW9l3XFN4koWUL2Z2Nh7KMp5q
         2xNc7IrP2SmlVjCwORFOuwjGlSB+w7wc3HmMPO5jPW07GJyiNyZpi8Pf1EcfDjl2tXoS
         aOzw==
X-Gm-Message-State: ACrzQf2NZcTh2/KCPkGUzuxzk40VeHQVDaETS2d+s4qJs30ZznfsBZIr
        ZpXN0ISEpElaxQfHgWJL3w==
X-Google-Smtp-Source: AMsMyM5pqr2hJIPZ5Ycq9i2ddvBU0Tqj0jiQjbffC/+TCU+VgGx6xTzvHWQ4WsRCZjTtPRkCSNER1Q==
X-Received: by 2002:a05:6830:2706:b0:659:de15:2cae with SMTP id j6-20020a056830270600b00659de152caemr1661203otu.4.1663357289198;
        Fri, 16 Sep 2022 12:41:29 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p13-20020a056830130d00b006391adb6034sm10333282otq.72.2022.09.16.12.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 12:41:28 -0700 (PDT)
Received: (nullmailer pid 1149627 invoked by uid 1000);
        Fri, 16 Sep 2022 19:41:27 -0000
Date:   Fri, 16 Sep 2022 14:41:27 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/10] dt-bindings: memory: mt7621: add
 syscon as compatible string
Message-ID: <20220916194127.GA1139257-robh@kernel.org>
References: <20220915065542.13150-1-arinc.unal@arinc9.com>
 <20220915065542.13150-5-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220915065542.13150-5-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 09:55:36AM +0300, Arınç ÜNAL wrote:
> Add syscon as a constant string on the compatible property as it's required
> for the SoC to work. Update the example accordingly.

I read this and start to give you the same reply as v1. Then I remember 
saying this already...

Update the commit message such that it answers my question and I don't 
think you just ignored me and have to go find v1. The fact that this 
change makes the binding match what is already in use in dts files is an 
important detail.

> 
> Fixes: 5278e4a181ff ("dt-bindings: memory: add binding for Mediatek's MT7621 SDRAM memory controller")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
> ---
>  .../bindings/memory-controllers/mediatek,mt7621-memc.yaml | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
> index 85e02854f083..ba8cd6d81d08 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
> @@ -11,7 +11,9 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: mediatek,mt7621-memc
> +    items:
> +      - const: mediatek,mt7621-memc
> +      - const: syscon
>  
>    reg:
>      maxItems: 1
> @@ -24,7 +26,7 @@ additionalProperties: false
>  
>  examples:
>    - |
> -    memory-controller@5000 {
> -        compatible = "mediatek,mt7621-memc";
> +    syscon@5000 {
> +        compatible = "mediatek,mt7621-memc", "syscon";
>          reg = <0x5000 0x1000>;
>      };
> -- 
> 2.34.1
> 
> 
