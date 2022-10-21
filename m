Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6D608156
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 00:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJUWLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 18:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJUWLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 18:11:19 -0400
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5B52A3889;
        Fri, 21 Oct 2022 15:11:18 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1364357a691so5257956fac.7;
        Fri, 21 Oct 2022 15:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1d03R2gh3hl/xO9WOLEN9gR8gcna+J0ECVhPoWLCujQ=;
        b=HBaq7dOySJoyOKHKh8pnhjVeugaeYgNZf0kehKim++JM8VazCDKRHILwYLk+RmVO8F
         HgEbqABsJGwJgAijSKD4y3pB81ptS4Bv7OXwKAGxjIxEQdngBohFKMB1whyCKzo7YT2e
         PYtEp+a9J2dcaxFLYD4Ox5F1owlGOkc2OoEDecb3DCvXLmncZXYGT+z8wgd83ZVstjdH
         y7SqHm1UuaIr/tKRD2N6bXyd5+A6ko/L0dUFMliuyqEYv6Vnr4ZqJS7VzZOvVzlRWAKs
         5I7GkqFf0G5gxuVivEfpN3fEE5UKCqzW1ytG+yNBc4uh6DrnnpvUv2FmLUBnUgOWLCwy
         JcDw==
X-Gm-Message-State: ACrzQf0vPkflOLVjHUx5xQfCbrgbvH7iBbK3TqZrYw4idqbV5iYI5HsC
        /p2DF1rSdmbYRXzZxOLSFw==
X-Google-Smtp-Source: AMsMyM4EBvzAiqsGZu0+lov+2xIbDKV9MkdPdOmTwGS7aN6HgJdvds2DcmpK4yLpTrdGFTBwNuhMng==
X-Received: by 2002:a05:6870:e242:b0:137:2c18:681e with SMTP id d2-20020a056870e24200b001372c18681emr13453287oac.161.1666390277395;
        Fri, 21 Oct 2022 15:11:17 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x5-20020a4a8d45000000b0047f94999318sm9150164ook.29.2022.10.21.15.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 15:11:16 -0700 (PDT)
Received: (nullmailer pid 506658 invoked by uid 1000);
        Fri, 21 Oct 2022 22:11:17 -0000
Date:   Fri, 21 Oct 2022 17:11:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
Message-ID: <166639027533.506121.6671080607533222008.robh@kernel.org>
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
 <E1olteU-00Fwwi-PT@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1olteU-00Fwwi-PT@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 16:09:38 +0100, Russell King (Oracle) wrote:
> Add a minimum and default for the maximum-power-milliwatt option;
> module power levels were originally up to 1W, so this is the default
> and the minimum power level we can have for a functional SFP cage.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  Documentation/devicetree/bindings/net/sff,sfp.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
