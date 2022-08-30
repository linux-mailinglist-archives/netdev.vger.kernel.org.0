Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7645A6E58
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiH3UT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiH3UTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:19:23 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9087761B05;
        Tue, 30 Aug 2022 13:19:22 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-11f34610d4aso8695666fac.9;
        Tue, 30 Aug 2022 13:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Ybe6ruyjvPQK8gqfA76hafN5u49toJijAfoGF0avc0Q=;
        b=awYn26viP1sWCllNHIdvwXKBW4ur9fQQ39GnJ3SogDGmVR1JhXoaxdm8xtXA+Q+/iL
         ol9KYKYKrKC6ReSFvt35whidBVmnllF0sBmjV4Y7fx6fkgfelbs2toQz96oP6UVwYdiW
         mnKuXNvJQFyHuE+nHaM+dsy+qnu4AB6Se6jbJferhxe5n26mCXmBFsh612bkMuHVAK9i
         0sRSJAOI4xgM3fyCKZPHSZSszka1/liW5U3SI6MlZ9gA06e5XvcnN62ADUiYpTkeKm/Q
         k2F0CUD3AQ10nOVrdLalSgOIPDi4mUQCIqlEbh/KbSKK10cN7AVND+BDOKhvaU22qL2h
         2/jA==
X-Gm-Message-State: ACgBeo0Mzh030WmfMcOPNXLvemExTN+6pmXAMtLEjdJExY29c+3G9cy5
        +keDf5zN4I0iRIRHYgwC5A==
X-Google-Smtp-Source: AA6agR5I3kVZCYvHupGcZNpsWqJuNU2x0SqozhVbdqcVAv9R3OtZ4JPvzwIb99dJtnuUxzpYULAp0g==
X-Received: by 2002:a05:6870:b148:b0:112:cfe1:5062 with SMTP id a8-20020a056870b14800b00112cfe15062mr11114153oal.297.1661890761738;
        Tue, 30 Aug 2022 13:19:21 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h7-20020a9d2f07000000b0063736db0ae9sm5608884otb.15.2022.08.30.13.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 13:19:21 -0700 (PDT)
Received: (nullmailer pid 1992523 invoked by uid 1000);
        Tue, 30 Aug 2022 20:19:20 -0000
Date:   Tue, 30 Aug 2022 15:19:20 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 1/7] dt-bindings: net: phy: add PoDL PSE
 property
Message-ID: <20220830201920.GB1874385-robh@kernel.org>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
 <20220828063021.3963761-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828063021.3963761-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 08:30:15AM +0200, Oleksij Rempel wrote:
> Add property to reference node representing a PoDL Power Sourcing Equipment.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index ed1415a4381f2..0b7b9dc69d454 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -144,6 +144,11 @@ properties:
>        Mark the corresponding energy efficient ethernet mode as
>        broken and request the ethernet to stop advertising it.
>  
> +  ieee802.3-pse:
> +    $ref: /schemas/types.yaml#/definitions/phandle

If you are saying this is the only location we'll ever find 
'ieee802.3-pse', then defining it here is okay. Otherwise, it 
needs to be it's own file so there's exactly 1 type definition. As 
you've said it might have cells by defining #pse-cells, 'phandle' is 
the wrong type. 'phandle-array' is what you want, but then actual users 
need to define how many entries (i.e. maxItems). Just like all the 
other provider/consumer bindings are structured.

Rob
