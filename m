Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1680F53937B
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345428AbiEaPBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiEaPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:01:05 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013355BD38;
        Tue, 31 May 2022 08:01:02 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id k187so13570195oif.1;
        Tue, 31 May 2022 08:01:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xut3EUzOWaallyGiLaq5YwI8FEiuwGHhPLk1PFTsGCw=;
        b=s/KqAg5WRr5rOrf9t46WxfeSjnsMPX3bOEKKlkk5GUqKWBVFfVzzMjLd0QPkCqS74y
         EvbhsMVht3LZ4wSU+TnwEkiliWCRGmhFxlU7uPo9/NKnuEF0cLbXJb4DS9LwF7XtzNQL
         sSq+slbxxKwQidboEQfE2FixtzMRA8rwEk34teV286l2wOGv7smsEMRK1FhLn+ul3WqI
         03WJcsyRckpOUn3a7WUNB3YQ6CW/AuMKpkhV3lDfpvVJ5dyRMWHheCBlgnBRECZbuv7G
         qkUu6hteG+gbZCO8Tm9vy0Es3vyaJ29UKs11vAn8PER6CoDlV6NzyEFg6nZtsNuEirDR
         zLEg==
X-Gm-Message-State: AOAM5316/wA9FCQXL4Jql9LPNWsOhilOtm/O7sNySNhjEHmiRiPRjcx6
        s5SuT1fVxun9iExLKLF4EQ==
X-Google-Smtp-Source: ABdhPJwSjgbLtDvlMIgEbd/14EO8tIgNGbqSDQWqqsx3KFH9ampHeHe4nDRvpCz7PczMPaXOpvITjQ==
X-Received: by 2002:a05:6808:ecc:b0:2fa:7d95:8dec with SMTP id q12-20020a0568080ecc00b002fa7d958decmr12183479oiv.34.1654009262254;
        Tue, 31 May 2022 08:01:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r7-20020a544887000000b00325cda1ff99sm5754199oic.24.2022.05.31.08.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:01:01 -0700 (PDT)
Received: (nullmailer pid 1755878 invoked by uid 1000);
        Tue, 31 May 2022 15:01:01 -0000
Date:   Tue, 31 May 2022 10:01:01 -0500
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
Message-ID: <20220531150101.GA1742958-robh@kernel.org>
References: <20220525205752.2484423-1-robh@kernel.org>
 <20220526003216.7jxopjckccugh3ft@skbuf>
 <20220526220450.GB315754-robh@kernel.org>
 <20220526231859.qstxkxqdetiawozv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526231859.qstxkxqdetiawozv@skbuf>
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

On Fri, May 27, 2022 at 02:18:59AM +0300, Vladimir Oltean wrote:
> On Thu, May 26, 2022 at 05:04:50PM -0500, Rob Herring wrote:
> > On Thu, May 26, 2022 at 03:32:16AM +0300, Vladimir Oltean wrote:
> > > Also needed by nxp,sja1105.yaml and the following from brcm,b53.yaml:
> > > 	brcm,bcm5325
> > > 	brcm,bcm5365
> > > 	brcm,bcm5395
> > > 	brcm,bcm5397
> > > 	brcm,bcm5398
> > > 	brcm,bcm53115
> > > 	brcm,bcm53125
> > > 	brcm,bcm53128
> > 
> > Okay. Looks like you missed bcm5389?
> 
> I went to the end of drivers/net/dsa/b53/b53_spi.c and copied the
> compatible strings. "brcm,bcm5389" is marked in b53_mdio.c, so I would
> guess not.

The datasheet I found says it is SPI interface, but I guess someone that 
cares about this h/w can sort that out if needed.

Rob

