Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89575355F7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 00:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349240AbiEZWFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 18:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349991AbiEZWEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 18:04:55 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC246E64FD;
        Thu, 26 May 2022 15:04:53 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id m125so3712394oia.6;
        Thu, 26 May 2022 15:04:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vLdbpKGNLu5yk557HufBJXrdPTT5qvK3rlnfRWVqz+M=;
        b=S/yZXd38JtSpnZqP9mMghbuKx+Xp0XKkUFVHoFX9gi7foW7o/wVxCgeepq73BGG5hB
         bi9UbRT55/PlgbLBpZDhk1S3UHgvFJZfkMo15atZjGybYt+FC9qzdzA1584lsW625t3Y
         HSmAT1p8T+PCENRf5hjrznLKR8+jXs8dcA+7s3Yl2OT5+ATNmyeCS8yIaeMJBVqxIZQi
         S0Ccc6rRy92bN0rAAaSvBQVvXX7VJ6zwTOQKmtQYG3yj1RKBlpqCJIKzuRVoRaH/9Qae
         1zGBK5H63mSqdVu4t099AhnhjJfbSLLJNhiis8uuqFnWq36pdCuW73EpvRQRikhpdy4S
         6C0Q==
X-Gm-Message-State: AOAM533/XNQma477JKspuPHmvrTcDPaGu63UdKeqWJOu3EMr4pwBBDVd
        aHrO9VUF/aqJaOpT9u43Pg==
X-Google-Smtp-Source: ABdhPJz8cg4On41gsBd8ruxHfQJAb2nP9yPlOL55wyn6mRRBKLYXIjiccQunOdeUs8migoK46Yb0Hg==
X-Received: by 2002:a05:6808:144d:b0:32b:7fbc:9440 with SMTP id x13-20020a056808144d00b0032b7fbc9440mr2303610oiv.226.1653602693051;
        Thu, 26 May 2022 15:04:53 -0700 (PDT)
Received: from robh.at.kernel.org (rrcs-192-154-179-37.sw.biz.rr.com. [192.154.179.37])
        by smtp.gmail.com with ESMTPSA id r7-20020a056808210700b0032b7c4ead49sm1105154oiw.18.2022.05.26.15.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 15:04:52 -0700 (PDT)
Received: (nullmailer pid 343192 invoked by uid 1000);
        Thu, 26 May 2022 22:04:50 -0000
Date:   Thu, 26 May 2022 17:04:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net/dsa: Add spi-peripheral-props.yaml
 references
Message-ID: <20220526220450.GB315754-robh@kernel.org>
References: <20220525205752.2484423-1-robh@kernel.org>
 <20220526003216.7jxopjckccugh3ft@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526003216.7jxopjckccugh3ft@skbuf>
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

On Thu, May 26, 2022 at 03:32:16AM +0300, Vladimir Oltean wrote:
> On Wed, May 25, 2022 at 03:57:50PM -0500, Rob Herring wrote:
> > SPI peripheral device bindings need to reference spi-peripheral-props.yaml
> > in order to use various SPI controller specific properties. Otherwise,
> > the unevaluatedProperties check will reject any controller specific
> > properties.
> > 
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 1 +
> >  Documentation/devicetree/bindings/net/dsa/realtek.yaml       | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > index 184152087b60..6bbd8145b6c1 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > @@ -12,6 +12,7 @@ maintainers:
> >  
> >  allOf:
> >    - $ref: dsa.yaml#
> > +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> >  
> >  properties:
> >    # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
> > diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> > index 99ee4b5b9346..4f99aff029dc 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> > @@ -108,6 +108,7 @@ if:
> >      - reg
> >  
> >  then:
> > +  $ref: /schemas/spi/spi-peripheral-props.yaml#
> >    not:
> >      required:
> >        - mdc-gpios
> > -- 
> > 2.34.1
> > 
> 
> Also needed by nxp,sja1105.yaml and the following from brcm,b53.yaml:
> 	brcm,bcm5325
> 	brcm,bcm5365
> 	brcm,bcm5395
> 	brcm,bcm5397
> 	brcm,bcm5398
> 	brcm,bcm53115
> 	brcm,bcm53125
> 	brcm,bcm53128

Okay. Looks like you missed bcm5389?

Rob
