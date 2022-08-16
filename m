Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97B059648A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiHPVVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbiHPVVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:21:40 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0D8A7FA;
        Tue, 16 Aug 2022 14:21:39 -0700 (PDT)
Received: by mail-io1-f48.google.com with SMTP id i77so5759986ioa.7;
        Tue, 16 Aug 2022 14:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=tuSisoMkl6+60tdPaffN493peiy7o2wWR1+PZsK1WiE=;
        b=RxD83V9DmSk55jw9KQ3wJkm7sOXYE1JYuu4W7TaV5s/jLDNWdsoBpAl6BI0gPzWttC
         nA4pD/xThlb65n0Vn/2bHMYl/XI+gTmy9Kd8+xaw1QpGOz4JkdwLskXAmEf+AAWF/vXQ
         P3b+x4rtLjTngRBiQL43j+8ady4kpasu4Db0NQm2m89BC5wOOTLDfysCtTAqPOLRiU9X
         wHRh72AJNydud5VGN+7X5i4WOPfvMx8iydevPj59Vv8IYJvZdjqpXLEzHKhJgfOM4S8R
         zDMWv2OP6yZpsvP2jeB+OooDV7Miv628bNTcA34mgbJkAEl0zZr4ttysrIEZYRmFMeSW
         ny6g==
X-Gm-Message-State: ACgBeo1AQMDFgq9qGVocCbzNfiqCJZ9ZEo9iLEzLtf4TB2oYiv02iq6p
        fzDgNc24UyD6GK9aQoneJA==
X-Google-Smtp-Source: AA6agR44tAdtZC5+EJ1JbGySmbewN0vjdw3exH0tsi8qEIiGjppZgzRv1p3JPHSpnXbJNvAZX/sl8A==
X-Received: by 2002:a02:a144:0:b0:343:5da5:f424 with SMTP id m4-20020a02a144000000b003435da5f424mr10161530jah.150.1660684898739;
        Tue, 16 Aug 2022 14:21:38 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id h12-20020a056e021d8c00b002e127d59f63sm5198039ila.74.2022.08.16.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:21:38 -0700 (PDT)
Received: (nullmailer pid 2754798 invoked by uid 1000);
        Tue, 16 Aug 2022 21:21:35 -0000
Date:   Tue, 16 Aug 2022 15:21:35 -0600
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
Subject: Re: [PATCH v2 6/7] dt-bindings: net: dsa: mediatek,mt7530: define
 phy-mode for each compatible
Message-ID: <20220816212135.GA2747439-robh@kernel.org>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-7-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813154415.349091-7-arinc.unal@arinc9.com>
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

On Sat, Aug 13, 2022 at 06:44:14PM +0300, Arınç ÜNAL wrote:
> Define acceptable phy-mode values for CPU port of each compatible device.
> Remove relevant information from the description of the binding.

I'm not really sure this is worth the complexity just to check 
'phy-mode'...

> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 103 ++++++++++++++++--
>  1 file changed, 92 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index a27cb4fa490f..530ef5a75a2f 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -49,17 +49,6 @@ description: |
>    * mt7621: phy-mode = "rgmii-txid";
>    * mt7623: phy-mode = "rgmii";
>  
> -  CPU-Ports need a phy-mode property:
> -    Allowed values on mt7530 and mt7621:
> -      - "rgmii"
> -      - "trgmii"
> -    On mt7531:
> -      - "1000base-x"
> -      - "2500base-x"
> -      - "rgmii"
> -      - "sgmii"
> -
> -
>  properties:
>    compatible:
>      oneOf:
> @@ -177,6 +166,36 @@ allOf:
>                          items:
>                            - const: cpu
>                    then:
> +                    allOf:
> +                      - if:
> +                          properties:
> +                            reg:
> +                              const: 5
> +                        then:
> +                          properties:
> +                            phy-mode:
> +                              enum:
> +                                - gmii
> +                                - mii
> +                                - rgmii
> +
> +                      - if:
> +                          properties:
> +                            reg:
> +                              const: 6
> +                        then:

You've restricted this to ports 5 or 6 already, so you just need an 
'else' here. And you can then drop the 'allOf'.

> +                          properties:
> +                            phy-mode:
> +                              enum:
> +                                - rgmii
> +                                - trgmii
> +
> +                    properties:
> +                      reg:
> +                        enum:
> +                          - 5
> +                          - 6
> +
>                      required:
>                        - phy-mode
>  
> @@ -206,6 +225,38 @@ allOf:
>                          items:
>                            - const: cpu
>                    then:
> +                    allOf:
> +                      - if:
> +                          properties:
> +                            reg:
> +                              const: 5
> +                        then:
> +                          properties:
> +                            phy-mode:
> +                              enum:
> +                                - 1000base-x
> +                                - 2500base-x
> +                                - rgmii
> +                                - sgmii
> +
> +                      - if:
> +                          properties:
> +                            reg:
> +                              const: 6
> +                        then:
> +                          properties:
> +                            phy-mode:
> +                              enum:
> +                                - 1000base-x
> +                                - 2500base-x
> +                                - sgmii
> +
> +                    properties:
> +                      reg:
> +                        enum:
> +                          - 5
> +                          - 6
> +
>                      required:
>                        - phy-mode
>  
> @@ -235,6 +286,36 @@ allOf:
>                          items:
>                            - const: cpu
>                    then:
> +                    allOf:
> +                      - if:
> +                          properties:
> +                            reg:
> +                              const: 5
> +                        then:
> +                          properties:
> +                            phy-mode:
> +                              enum:
> +                                - gmii
> +                                - mii
> +                                - rgmii
> +
> +                      - if:
> +                          properties:
> +                            reg:
> +                              const: 6
> +                        then:
> +                          properties:
> +                            phy-mode:
> +                              enum:
> +                                - rgmii
> +                                - trgmii
> +
> +                    properties:
> +                      reg:
> +                        enum:
> +                          - 5
> +                          - 6
> +

Looks like the same schema duplicated. You can put it under a '$defs' 
and reference it twice.

>                      required:
>                        - phy-mode
>  
> -- 
> 2.34.1
> 
> 
