Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0798596406
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbiHPUwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbiHPUwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:52:32 -0400
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61489CE3;
        Tue, 16 Aug 2022 13:52:31 -0700 (PDT)
Received: by mail-il1-f181.google.com with SMTP id w8so2717511ilj.5;
        Tue, 16 Aug 2022 13:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=EzR+Z4kxn7o2P/WW6PzrWm03607DFyihBAzL1aumsm4=;
        b=GjShtAUEc0BZSPQ9pNFMz/GraxfeASnqn1kuCqNwxLjoztR7FgLf3yeeR7ghBJyfrp
         5XT2kjcRTnWaDMektSjx1DrmqfRVXXTO/jRPV1EKMEDXq4Z1XEqEXMGCqfd92kR1p/4/
         xurHAUmPl40+FuZoT8XzL+Nt+YKhQFir05g+7XbiNkDq1PguKqh8WFWYQy1RtLl1h9rr
         hmF0JrKKFUQNnjfTYmq7YkyfU40l/KZ+/ZjfTf0RTKqi6KYD+LL+gFPNApGBfB13TO2p
         eCSKdgazRkKnSbu+1ewhj6OZCk3EcXj9CfU9OWojGItGQgNEXjDSTT4E+iDp5i8KkZLD
         koxg==
X-Gm-Message-State: ACgBeo0wirYwWXsJoahyphfgZmAvcOIC3DtYwX5EmeyyVGWfkmBiW1dA
        aQRHsyuRxbK7nmbqpJD+tg==
X-Google-Smtp-Source: AA6agR4sGyiJKaOIlOFFnF0gqYNlu2XfR46u2ykdYGuFEEDs2T7qsaoxAPvnZ50uBGOOW7Z0yR8c2A==
X-Received: by 2002:a05:6e02:18cd:b0:2de:73e8:3f0 with SMTP id s13-20020a056e0218cd00b002de73e803f0mr10622659ilu.69.1660683151102;
        Tue, 16 Aug 2022 13:52:31 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id v30-20020a02b09e000000b00339dbd4c8d7sm4780229jah.45.2022.08.16.13.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 13:52:30 -0700 (PDT)
Received: (nullmailer pid 2713686 invoked by uid 1000);
        Tue, 16 Aug 2022 20:52:28 -0000
Date:   Tue, 16 Aug 2022 14:52:28 -0600
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
Subject: Re: [PATCH v2 2/7] dt-bindings: net: dsa: mediatek,mt7530: fix reset
 lines
Message-ID: <20220816205228.GA2709277-robh@kernel.org>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-3-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813154415.349091-3-arinc.unal@arinc9.com>
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

On Sat, Aug 13, 2022 at 06:44:10PM +0300, Arınç ÜNAL wrote:
> - Fix description of mediatek,mcm. mediatek,mcm is not used on MT7623NI.
> - Add description for reset-gpios.
> - Invalidate reset-gpios if mediatek,mcm is used.
> - Invalidate mediatek,mcm if the compatible device is mediatek,mt7531.
> - Require mediatek,mcm for the described MT7621 SoCs as the compatible
> string is only used for MT7530 which is a part of the multi-chip module.

The commit message should answer 'why is this change needed/wanted?' not 
'what changed'. I can read the diff to see what changed.

d> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 31 +++++++++++++++++--
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index edf48e917173..4c99266ce82a 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -110,11 +110,15 @@ properties:
>    mediatek,mcm:
>      type: boolean
>      description:
> -      if defined, indicates that either MT7530 is the part on multi-chip
> -      module belong to MT7623A has or the remotely standalone chip as the
> -      function MT7623N reference board provided for.
> +      Used for MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs which the MT7530
> +      switch is a part of the multi-chip module.
>  
>    reset-gpios:
> +    description:
> +      GPIO to reset the switch. Use this if mediatek,mcm is not used.
> +      This property is optional because some boards share the reset line with
> +      other components which makes it impossible to probe the switch if the
> +      reset line is used.
>      maxItems: 1
>  
>    reset-names:
> @@ -165,6 +169,9 @@ allOf:
>        required:
>          - mediatek,mcm
>      then:
> +      properties:
> +        reset-gpios: false
> +
>        required:
>          - resets
>          - reset-names
> @@ -182,6 +189,24 @@ allOf:
>          - core-supply
>          - io-supply
>  
> +  - if:
> +      properties:
> +        compatible:
> +          items:
> +            - const: mediatek,mt7531
> +    then:
> +      properties:
> +        mediatek,mcm: false
> +
> +  - if:
> +      properties:
> +        compatible:
> +          items:
> +            - const: mediatek,mt7621
> +    then:
> +      required:
> +        - mediatek,mcm
> +
>  unevaluatedProperties: false
>  
>  examples:
> -- 
> 2.34.1
> 
> 
