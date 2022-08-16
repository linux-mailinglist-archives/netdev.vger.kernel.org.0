Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15551596499
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbiHPV0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiHPV0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:26:03 -0400
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181AC8C034;
        Tue, 16 Aug 2022 14:26:02 -0700 (PDT)
Received: by mail-il1-f175.google.com with SMTP id m9so1269303ili.1;
        Tue, 16 Aug 2022 14:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=e+8oYnnpdIhRIEGZGcK4qOgJpnQIoppLCcEyPpOxTNw=;
        b=zk8cyVKw5/chXs2vEwNpTkeyx4uYRulcaSfHf7VMgbKgf4tDDkfb1ptCvEXvrWXFZv
         E2DXOJ7WqdAEFBTshTBQNAsqa0W/5B6JlOjDviwLyP6k7X4xOrnE+xW6SsD3/lmT5OJP
         4KDrrc1UMQRnfAmllEVuI+PcAtZCshRkOmGsMsftdyfwr/Lrv0koX1Cvt4Wp4dMSO9KD
         Kmr9Div/78ewIuh/kCrkwQXOafW7ZJCm4Ztr8dKsXM/BO1NelssMsUiSeZKIuhNgPuyf
         cTWA/hpuFZSgTgUQX+Z/+CCzdgemgBNFghT+V5/9PekmlqvMGHs1rbhFDWXdbTfm6v2m
         e/mw==
X-Gm-Message-State: ACgBeo2XMKThqJ7M+235V+Osq1tCUex24bPib0mLew3AvLLj6/SqlKzq
        9jqNCT63qiai3dRIX09avA==
X-Google-Smtp-Source: AA6agR6EOf2Li1pE1BhUBeQSyQnTZ1kOYEa6pQmULPPxxdADWpIbayo6/yuBU0FUP3tf2Muj0m+AeA==
X-Received: by 2002:a05:6e02:1645:b0:2df:1f18:3d7f with SMTP id v5-20020a056e02164500b002df1f183d7fmr10479186ilu.281.1660685160920;
        Tue, 16 Aug 2022 14:26:00 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id r27-20020a02aa1b000000b0034686e29f8dsm2821613jam.134.2022.08.16.14.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:26:00 -0700 (PDT)
Received: (nullmailer pid 2761345 invoked by uid 1000);
        Tue, 16 Aug 2022 21:25:58 -0000
Date:   Tue, 16 Aug 2022 15:25:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] dt-bindings: net: dsa: mediatek,mt7530: update
 binding description
Message-ID: <20220816212558.GA2754986-robh@kernel.org>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-8-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813154415.349091-8-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 13, 2022 at 06:44:15PM +0300, Arınç ÜNAL wrote:
> Update the description of the binding.
> 
> - Describe the switches, which SoCs they are in, or if they are standalone.
> - Explain the various ways of configuring MT7530's port 5.
> - Remove phy-mode = "rgmii-txid" from description. Same code path is
> followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 97 ++++++++++++-------
>  1 file changed, 62 insertions(+), 35 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 530ef5a75a2f..cf6340d072df 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -13,41 +13,68 @@ maintainers:
>    - Sean Wang <sean.wang@mediatek.com>
>  
>  description: |
> -  Port 5 of mt7530 and mt7621 switch is muxed between:
> -  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
> -  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
> -     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
> -     Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
> -       GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
> -       connected to external component!
> -
> -  Port 5 modes/configurations:
> -  1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
> -     GMAC of the SOC.
> -     In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
> -     GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
> -  2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
> -     It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
> -     and RGMII delay.
> -  3. Port 5 is muxed to GMAC5 and can interface to an external phy.
> -     Port 5 becomes an extra switch port.
> -     Only works on platform where external phy TX<->RX lines are swapped.
> -     Like in the Ubiquiti ER-X-SFP.
> -  4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
> -     Currently a 2nd CPU port is not supported by DSA code.
> -
> -  Depending on how the external PHY is wired:
> -  1. normal: The PHY can only connect to 2nd GMAC but not to the switch
> -  2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
> -     a ethernet port. But can't interface to the 2nd GMAC.
> -
> -    Based on the DT the port 5 mode is configured.
> -
> -  Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
> -  When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
> -  phy-mode must be set, see also example 2 below!
> -  * mt7621: phy-mode = "rgmii-txid";
> -  * mt7623: phy-mode = "rgmii";
> +  There are two versions of MT7530, standalone and in a multi-chip module.
> +
> +  MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
> +  MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
> +
> +  MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs

s/got //

> +  and the switch registers are directly mapped into SoC's memory map rather than
> +  using MDIO. There is currently no support for this.

No support in the binding or driver? Driver capabilities are relevant to 
the binding.

> +
> +  There is only the standalone version of MT7531.
> +
> +  Port 5 on MT7530 has got various ways of configuration.

s/got //

> +
> +  For standalone MT7530:
> +
> +    - Port 5 can be used as a CPU port.
> +
> +    - PHY 0 or 4 of the switch can be muxed to connect to the gmac of the SoC
> +      which port 5 is wired to. Usually used for connecting the wan port
> +      directly to the CPU to achieve 2 Gbps routing in total.
> +
> +      The driver looks up the reg on the ethernet-phy node which the phy-handle
> +      property refers to on the gmac node to mux the specified phy.
> +
> +      The driver requires the gmac of the SoC to have "mediatek,eth-mac" as the
> +      compatible string and the reg must be 1. So, for now, only gmac1 of an
> +      MediaTek SoC can benefit this. Banana Pi BPI-R2 suits this.
> +      Check out example 5 for a similar configuration.
> +
> +    - Port 5 can be wired to an external phy. Port 5 becomes a DSA slave.
> +      Check out example 7 for a similar configuration.
> +
> +  For multi-chip module MT7530:
> +
> +    - Port 5 can be used as a CPU port.
> +
> +    - PHY 0 or 4 of the switch can be muxed to connect to gmac1 of the SoC.
> +      Usually used for connecting the wan port directly to the CPU to achieve 2
> +      Gbps routing in total.
> +
> +      The driver looks up the reg on the ethernet-phy node which the phy-handle
> +      property refers to on the gmac node to mux the specified phy.
> +
> +      For the MT7621 SoCs, rgmii2 group must be claimed with rgmii2 function.
> +      Check out example 5.
> +
> +    - In case of an external phy wired to gmac1 of the SoC, port 5 must not be
> +      enabled.
> +
> +      In case of muxing PHY 0 or 4, the external phy must not be enabled.
> +
> +      For the MT7621 SoCs, rgmii2 group must be claimed with rgmii2 function.
> +      Check out example 6.
> +
> +    - Port 5 can be muxed to an external phy. Port 5 becomes a DSA slave.
> +      The external phy must be wired TX to TX to gmac1 of the SoC for this to
> +      work. Ubiquiti EdgeRouter X SFP is wired this way.
> +
> +      Muxing PHY 0 or 4 won't work when the external phy is connected TX to TX.
> +
> +      For the MT7621 SoCs, rgmii2 group must be claimed with gpio function.
> +      Check out example 7.
>  
>  properties:
>    compatible:
> -- 
> 2.34.1
> 
> 
