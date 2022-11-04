Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D36619FDF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiKDS27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiKDS25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:28:57 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0DFAE63;
        Fri,  4 Nov 2022 11:28:55 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so3126112oti.5;
        Fri, 04 Nov 2022 11:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Axeinl0AVOkMZkdy2C/CMY4wAszDNJkSPI4AMTzOaxM=;
        b=Fdad+D53kpCWTGqMTAicGlrtX/UoagxMbJkZWA/0mkIOiFOKRAocBL6B3iCGVNXHyT
         wHODA+uqaHXKSv5qSGYS1d1D3JjvMz+PLh8UN12QBsQf2XqIJKIyGtuD6lynMSamaRQj
         yGz3rSTNq44jkthuqJPTHLgtcCdImuKyJVkPYNOJTZ57J9Ca9BBJDNlsmtuuxYWikKcb
         5pUP1OncpLGZI4JuFnPzXDJUaffOdgynGgxwuzpmLV6OetZCdQY6xitQ/dd2/3nCHTyu
         d1i/s+sNnK0DPfpKeeXlbU7kJpRHUKhRw8oR+gwZNwuS1mc+gV1escfKTxswTjiMk2hj
         D3lg==
X-Gm-Message-State: ACrzQf07g5alO+NaiTDKkGu2D9El0nc97eb0tOlz9ONtbEjkCz6r6oaD
        C9RMfdfUtxYE3FnkgpP8wTK52t+nzQ==
X-Google-Smtp-Source: AMsMyM5MfegN84c2dxVsm4eumZQlLU3ixmJQ8iQ0yvjncow3XVIGXYi5BQgNgYk95FH3nugWlpZ/eg==
X-Received: by 2002:a9d:7dd1:0:b0:66c:54b2:7df3 with SMTP id k17-20020a9d7dd1000000b0066c54b27df3mr13767334otn.247.1667586534956;
        Fri, 04 Nov 2022 11:28:54 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 36-20020a9d0627000000b00660fe564e12sm1794otn.58.2022.11.04.11.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 11:28:54 -0700 (PDT)
Received: (nullmailer pid 2226083 invoked by uid 1000);
        Fri, 04 Nov 2022 18:28:55 -0000
Date:   Fri, 4 Nov 2022 13:28:55 -0500
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
Subject: Re: [PATCH v2 net-next 6/6] dt-bindings: net: mscc,vsc7514-switch:
 utilize generic ethernet-switch.yaml
Message-ID: <20221104182855.GA2133300-robh@kernel.org>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104045204.746124-7-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:52:04PM -0700, Colin Foster wrote:
> Several bindings for ethernet switches are available for non-dsa switches
> by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
> the common bindings for the VSC7514.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> 
> v1 -> v2:
>   * Fix "$ref: ethernet-switch.yaml" placement. Oops.
>   * Add "unevaluatedProperties: true" to ethernet-ports layer so it
>     can correctly read into ethernet-switch.yaml
>   * Add "unevaluatedProperties: true" to ethernet-port layer so it can
>     correctly read into ethernet-controller.yaml
> 
> ---
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 40 ++-----------------
>  1 file changed, 4 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> index ee0a504bdb24..3f3f9fd548cf 100644
> --- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> @@ -18,10 +18,9 @@ description: |
>    packets using CPU. Additionally, PTP is supported as well as FDMA for faster
>    packet extraction/injection.
>  
> -properties:
> -  $nodename:
> -    pattern: "^switch@[0-9a-f]+$"
> +$ref: ethernet-switch.yaml#
>  
> +properties:
>    compatible:
>      const: mscc,vsc7514-switch
>  
> @@ -88,46 +87,15 @@ properties:
>        - const: fdma
>  
>    ethernet-ports:
> -    type: object
> -
> -    properties:
> -      '#address-cells':
> -        const: 1
> -      '#size-cells':
> -        const: 0
>  
> -    additionalProperties: false
> +    unevaluatedProperties: true

Both this and ethernet-switch.yaml allow unevaluated properties. 
Therefore any extra properties will be allowed. Add some to your example 
and see.

>  
>      patternProperties:
>        "^port@[0-9a-f]+$":
> -        type: object
> -        description: Ethernet ports handled by the switch
>  
>          $ref: ethernet-controller.yaml#
>  
> -        unevaluatedProperties: false
> -
> -        properties:
> -          reg:
> -            description: Switch port number
> -
> -          phy-handle: true
> -
> -          phy-mode: true
> -
> -          fixed-link: true
> -
> -          mac-address: true
> -
> -        required:
> -          - reg
> -          - phy-mode
> -
> -        oneOf:
> -          - required:
> -              - phy-handle
> -          - required:
> -              - fixed-link
> +        unevaluatedProperties: true

Same problem here. I'll comment more about this on 
ethernet-switch-port.yaml.

Rob
