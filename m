Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4642654541A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbiFIS0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiFIS0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:26:11 -0400
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820B929C9E;
        Thu,  9 Jun 2022 11:26:10 -0700 (PDT)
Received: by mail-il1-f176.google.com with SMTP id z11so536574ilq.6;
        Thu, 09 Jun 2022 11:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cLDZQJzvsDyJ7h1hdWbqNlQ6ycdzzAeH1ZyNfeeZj5w=;
        b=JvREQPrh5CiWz/7Vx5u7gyi/QNOn+Rd8L1EqQkD0sf9h8fR5UoJ4jgREFjBvsPNxif
         78HPdaQE+vux1Mc5OA8D5Ui8F7n1e4BIkJgbiBbCKq/cvs4fXtUL60EnVE1AbaJQAQPK
         D7Y4KirqCb/hHO1IOzeIcl3rSTLP91YIzTflIj/oFMQHsC2ztGWfo/Tm8wJXiLqBSmNt
         XAYESOEd+wNNcyXT1WRjVuor5Enxxn3qeZmJZwvcnioAuSiPiQTfWS3vxejY8lVyO2rY
         ETNwPkLXHtaDfivP2VOi9JKB/lisZbsL5l3liFx+dfb10s9HV3TzYF5EVeIPwCDWJiOw
         Oirg==
X-Gm-Message-State: AOAM532e2nFPP7Takj/DgkJ5AvMaIvSNiyzDvQTSeihpefn7NymYad5B
        X1uEofeVLslARR/U7mRusQ==
X-Google-Smtp-Source: ABdhPJyPAu/3NduG0na4VoyumB38tDz2ZNatdC2Ocl+vXixAxmw3qxr/QGPsvo5KIxlV4ZGOwDdRNw==
X-Received: by 2002:a92:dc88:0:b0:2d5:118c:a3f6 with SMTP id c8-20020a92dc88000000b002d5118ca3f6mr16497974iln.204.1654799169714;
        Thu, 09 Jun 2022 11:26:09 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id a2-20020a029102000000b0033202bb9829sm1013998jag.49.2022.06.09.11.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 11:26:09 -0700 (PDT)
Received: (nullmailer pid 4072745 invoked by uid 1000);
        Thu, 09 Jun 2022 18:26:06 -0000
Date:   Thu, 9 Jun 2022 12:26:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH v3 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Message-ID: <20220609182606.GA4024580-robh@kernel.org>
References: <20220606110443.30362-1-s-vadapalli@ti.com>
 <20220606110443.30362-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606110443.30362-2-s-vadapalli@ti.com>
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

On Mon, Jun 06, 2022 at 04:34:41PM +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J7200 SoC which contains 5 ports (4 external
> ports) CPSW5G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j7200-cpswxg-nuss for CPSW5G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 4 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 135 ++++++++++++------
>  1 file changed, 93 insertions(+), 42 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index b8281d8be940..49f63aaf5a08 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -57,6 +57,7 @@ properties:
>        - ti,am654-cpsw-nuss
>        - ti,j721e-cpsw-nuss
>        - ti,am642-cpsw-nuss
> +      - ti,j7200-cpswxg-nuss
>  
>    reg:
>      maxItems: 1
> @@ -108,48 +109,98 @@ properties:
>          const: 1
>        '#size-cells':
>          const: 0
> -
> -    patternProperties:
> -      port@[1-2]:

Just change this to 'port@[1-4]'.

> -        type: object
> -        description: CPSWxG NUSS external ports
> -
> -        $ref: ethernet-controller.yaml#
> -
> -        properties:
> -          reg:
> -            minimum: 1
> -            maximum: 2

And this to 4.

Then, you just need this to disallow the additional ports:

if:
  not:
    properties:
      compatible:
        contains:
          const: ti,j7200-cpswxg-nuss
then:
  patternProperties:
    '^port@[3-4]$': false


Rob
