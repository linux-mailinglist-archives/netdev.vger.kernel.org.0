Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D2563E888
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLADqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiLADqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:46:01 -0500
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2E29F498;
        Wed, 30 Nov 2022 19:45:59 -0800 (PST)
Received: by mail-oi1-f173.google.com with SMTP id l127so768035oia.8;
        Wed, 30 Nov 2022 19:45:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykrUdgnpt//KI390EfyviTWw7fKUM7t8IqT8KivZw44=;
        b=d7d1fhXmxRIyCrTBjsXpsvifIfXqCp7u2LbIp5mq4y0mD6jxfHBH8EUWEAIUGHcB2q
         Uo6KGjocTogxt554sT2wSquUdL8v6GjmsDyRYA37cMTrHZK/TKR5gKf5zNiSjr5a7QQd
         dH69Hcu68RR4D/+yBP9No7LA0RiW2sbbdBJ7B3eKZQSyo1TcfTbNB7ETcNRacMtgCWU+
         vr+JKNhqiPzznMDJrJimPMZ4tGXV2R5XgV6kqnCwvYr6FZJgJkbzj84LMhct6MMSUHUc
         Ib40gD9WmP41GnTfXldnPHkcQS5quT6yy6N1+Cu/mY9VSlpMvfRCFD+zbCFTAA0oJbMg
         3Uzw==
X-Gm-Message-State: ANoB5pnNZYNbzyB0OIOFeaejzfTkLD/hoZftyxUHnx5B5lKghAL/85kE
        sRnYuXMwa4CgrF8sZ4KPtA==
X-Google-Smtp-Source: AA0mqf5WCmFLREdSlYC9qzJRKrm7hw0V931v+JMD58V5b6VI64AQhK6aDD8+l29/3c1aTaLsQwxYJg==
X-Received: by 2002:aca:2201:0:b0:354:fe21:a47c with SMTP id b1-20020aca2201000000b00354fe21a47cmr32279869oic.10.1669866358423;
        Wed, 30 Nov 2022 19:45:58 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 17-20020a9d0611000000b006605883eae6sm1630945otn.63.2022.11.30.19.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 19:45:58 -0800 (PST)
Received: (nullmailer pid 3605657 invoked by uid 1000);
        Thu, 01 Dec 2022 03:45:57 -0000
Date:   Wed, 30 Nov 2022 21:45:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml
 inheritance
Message-ID: <20221201034557.GA2998157-robh@kernel.org>
References: <20221125202008.64595-1-samuel@sholland.org>
 <20221125202008.64595-3-samuel@sholland.org>
 <5b05317d-28cc-bfc8-f415-e6acf453dc7c@linaro.org>
 <20221126142735.47dcca6d@slackpad.lan>
 <99c3e666-ec26-07a0-be40-0177dd449d84@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99c3e666-ec26-07a0-be40-0177dd449d84@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 26, 2022 at 03:48:33PM +0100, Krzysztof Kozlowski wrote:
> On 26/11/2022 15:28, Andre Przywara wrote:
> > On Sat, 26 Nov 2022 14:26:25 +0100
> > Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:
> > 
> > Hi,
> > 
> >> On 25/11/2022 21:20, Samuel Holland wrote:
> >>> The sun8i-emac binding extends snps,dwmac.yaml, and should accept all
> >>> properties defined there, including "mdio", "resets", and "reset-names".
> >>> However, validation currently fails for these properties because the  
> >>
> >> validation does not fail:
> >> make dt_binding_check -> no problems
> >>
> >> Maybe you meant that DTS do not pass dtbs_check?
> > 
> > Yes, that's what he meant: If a board actually doesn't have Ethernet
> > configured, dt-validate complains. I saw this before, but didn't find
> > any solution.
> > An example is: $ dt-validate ... sun50i-a64-pinephone-1.2.dtb
> > arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-1.2.dtb:
> >   ethernet@1c30000: Unevaluated properties are not allowed ('resets', 'reset-names', 'mdio' were unexpected)
> >   From schema: Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > 
> > Why exactly is beyond me, but this patch removes this message.
> 
> I don't think this should be fixed like this. That's the problem of
> dtschema (not ignoring fully disabled nodes) and such patch only moves
> from one correct syntax to another correct syntax, which fixes dtschema
> problem, but changes nothing here.

Humm, it looks to me like the 'phy-mode' required in snps,dwmac.yaml 
causes the problem, but I can't get a minimized example to fail. 
Something in 'required' shouldn't matter. Definitely seems like an issue 
in the jsonschema package. I'll keep looking at it.

Rob
