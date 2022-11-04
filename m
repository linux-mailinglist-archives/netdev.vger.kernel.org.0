Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C379061A053
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKDSxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKDSxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:53:44 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE3243AF6;
        Fri,  4 Nov 2022 11:53:43 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-13b23e29e36so6471766fac.8;
        Fri, 04 Nov 2022 11:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5fmOKByI3KZe2A+MbL7heqgNPSfdsbAmN+AppMoJZ00=;
        b=peqruPVsiV3zFegg4kUY8ZkQdFRUe6+LI/k2DVlFrZSVAhM4LZYnpJszsrc3JE6ZRe
         bLwrlNsxyU2RmQ8OYg8S5DGCF9OtbLMFE8tYEb8MKhJUSNx8YS8WOM75ViyUYaKNvH9o
         LOrl1ZoDN2bcA5fVpe5GbtokB9HomtPT2mBFserf5eQTlRcHKAlE5eIb6A0I2Tn25OHE
         mFGz7Dfx1V2inEf/7J/6tGqs4oXCPcOLL0uUAz49GyWKf9nbGXZWT0WThMIL5IbZQ/ZJ
         /DiSWuyA3cPyet6gHCiDJcJwBE7gl9GfVIki84zhhB+lv8ZXC8AJ1c8PEBjOPWf5Inox
         oQ5Q==
X-Gm-Message-State: ACrzQf1wcPaVR/mXL9n69S4o63zotFE+aTM/wRSbmNImFOerOb8oBcWg
        OLHsjPxegEF9CcLYiazAFw==
X-Google-Smtp-Source: AMsMyM7H12TuDK4Qcc7Lp3VgFO0eqWpI/aipb/7bHwsocq/OaNXhxdKmKwIjE8/ecQst2AvBtkN/qw==
X-Received: by 2002:a05:6870:42c3:b0:136:4251:1642 with SMTP id z3-20020a05687042c300b0013642511642mr22945908oah.210.1667588022771;
        Fri, 04 Nov 2022 11:53:42 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i9-20020a4ac509000000b0049e9fbf1615sm1328008ooq.48.2022.11.04.11.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 11:53:42 -0700 (PDT)
Received: (nullmailer pid 2245794 invoked by uid 1000);
        Fri, 04 Nov 2022 18:53:43 -0000
Date:   Fri, 4 Nov 2022 13:53:43 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v2 net-next 3/6] dt-bindings: net: dsa: mediatek,mt7530:
 remove unnecessary dsa-port reference
Message-ID: <20221104185343.GC2133300-robh@kernel.org>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221104045204.746124-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:52:01PM -0700, Colin Foster wrote:
> dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> the binding isn't necessary. Remove this unnecessary reference.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
> 
> v1 -> v2
>   * Add Reviewed-by
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index f2e9ff3f580b..81f291105660 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -159,8 +159,6 @@ patternProperties:
>          type: object
>          description: Ethernet switch ports
>  
> -        unevaluatedProperties: false
> -

You just allowed this node to have any property.

>          properties:
>            reg:
>              description:
> @@ -168,7 +166,6 @@ patternProperties:
>                for user ports.
>  
>          allOf:
> -          - $ref: dsa-port.yaml#
>            - if:
>                required: [ ethernet ]
>              then:
> -- 
> 2.25.1
> 
> 
