Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93459646A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbiHPVPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiHPVPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:15:01 -0400
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F0A7E805;
        Tue, 16 Aug 2022 14:15:00 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id b142so6345783iof.10;
        Tue, 16 Aug 2022 14:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=+IOZgKwOUJ0yyXI/vD5VmeYlLJhpEL4ag2WpyQni1K8=;
        b=mPZKmh6XwLy/LRLGGeF9hNHBhOxfe/wYc6vAnPLmc4E7k9waDDxLQ9+bucM9KXsBzC
         +dzaRW9uniY1rjM4icZ0GqAkM6avJJqimfaNu3VOKRkcMDiH15zPRs+xI+seClREwYiV
         BvG+Wx/hayJPRhuxtWDAAdYfgOEsMNFuN8K5nnMw32R2i/dOPOva5s1BAj1cryuPwdac
         C6HnAhCEIH0Kb9sCUPwhNvze+pImowJB+WmwYCJErXF0FzoMpNzU7eUYd9ZcRNR1xG56
         gKOEeR3YLaD99UOiVoivUnNPr/KiraB5tnTEcyjGo+KquYzmlfMf5FmzgB0oIz4Q0iaz
         Sjuw==
X-Gm-Message-State: ACgBeo3P1OchT96Ly8F6s/sWF49gK8eakJF1nYhWctmIgVA6Ubm8ChSU
        ipHGb1aalwXBqM2Nbh8Ipw==
X-Google-Smtp-Source: AA6agR6EQ8bauAwsr4ENQXhnGEColpXLl7hTdDigEdxvjsKeYgVLQhBqtACdoLlYH97bXvEZuHHIgQ==
X-Received: by 2002:a05:6602:2b14:b0:67b:8976:2945 with SMTP id p20-20020a0566022b1400b0067b89762945mr9685592iov.82.1660684499157;
        Tue, 16 Aug 2022 14:14:59 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id o130-20020a022288000000b00343429c9cb6sm4841082jao.139.2022.08.16.14.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:14:58 -0700 (PDT)
Received: (nullmailer pid 2744716 invoked by uid 1000);
        Tue, 16 Aug 2022 21:14:54 -0000
Date:   Tue, 16 Aug 2022 15:14:54 -0600
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
Subject: Re: [PATCH v2 5/7] dt-bindings: net: dsa: mediatek,mt7530: remove
 unnecesary lines
Message-ID: <20220816211454.GA2734299-robh@kernel.org>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-6-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813154415.349091-6-arinc.unal@arinc9.com>
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

On Sat, Aug 13, 2022 at 06:44:13PM +0300, Arınç ÜNAL wrote:
> Remove unnecessary lines as they are already included from the referred
> dsa.yaml.

You are duplicating the schema and then removing parts twice. I would 
combine patches 4 and 5 or reverse the order.

> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 27 -------------------
>  1 file changed, 27 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index ff51a2f6875f..a27cb4fa490f 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -162,15 +162,8 @@ allOf:
>  
>        patternProperties:
>          "^(ethernet-)?ports$":
> -          type: object
> -
>            patternProperties:
>              "^(ethernet-)?port@[0-9]+$":
> -              type: object
> -              description: Ethernet switch ports
> -
> -              unevaluatedProperties: false
> -
>                properties:
>                  reg:
>                    description:
> @@ -178,7 +171,6 @@ allOf:
>                      0 to 5 for user ports.
>  
>                allOf:
> -                - $ref: dsa-port.yaml#
>                  - if:

This 'if' schema is the only part you need actually (though you have to 
create the node structure).

>                      properties:
>                        label:
> @@ -186,7 +178,6 @@ allOf:
>                            - const: cpu
>                    then:
>                      required:
> -                      - reg
>                        - phy-mode
>  
>    - if:
> @@ -200,15 +191,8 @@ allOf:
>  
>        patternProperties:
>          "^(ethernet-)?ports$":
> -          type: object
> -
>            patternProperties:
>              "^(ethernet-)?port@[0-9]+$":
> -              type: object
> -              description: Ethernet switch ports
> -
> -              unevaluatedProperties: false
> -
>                properties:
>                  reg:
>                    description:
> @@ -216,7 +200,6 @@ allOf:
>                      0 to 5 for user ports.
>  
>                allOf:
> -                - $ref: dsa-port.yaml#
>                  - if:
>                      properties:
>                        label:
> @@ -224,7 +207,6 @@ allOf:
>                            - const: cpu
>                    then:
>                      required:
> -                      - reg
>                        - phy-mode
>  
>    - if:
> @@ -238,15 +220,8 @@ allOf:
>  
>        patternProperties:
>          "^(ethernet-)?ports$":
> -          type: object
> -
>            patternProperties:
>              "^(ethernet-)?port@[0-9]+$":
> -              type: object
> -              description: Ethernet switch ports
> -
> -              unevaluatedProperties: false
> -
>                properties:
>                  reg:
>                    description:
> @@ -254,7 +229,6 @@ allOf:
>                      0 to 5 for user ports.
>  
>                allOf:
> -                - $ref: dsa-port.yaml#
>                  - if:
>                      properties:
>                        label:
> @@ -262,7 +236,6 @@ allOf:
>                            - const: cpu
>                    then:
>                      required:
> -                      - reg
>                        - phy-mode
>  
>  unevaluatedProperties: false
> -- 
> 2.34.1
> 
> 
