Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C93053AEC7
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiFAVKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiFAVKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:10:19 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A89FDF7A;
        Wed,  1 Jun 2022 14:10:18 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-e656032735so4434542fac.0;
        Wed, 01 Jun 2022 14:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zS8J0ClQ9ncsVxOr+NVUGTE71ygnVRFhlsutEE3bBag=;
        b=zxMNNN7qaLW0MN1hGUb6HRMFBBOCvbYttomcUQAtgKYUtbryKNhMuBtLS2Q+dcr7uj
         OCa7z+QHBJQN7Ze1MbGc/beJIg8z4P/aQdnXNarlTHtzT+Y1eJ70YRg9ZlaM8ryrtOn/
         +Z+3pzERwFvi2aGbWeSLwm9qpLw10TLEJSUX1rQYDCIbJXb7jwysWHfsThidwo9bs/eA
         L5Rg5SVrASRazMUOAL7FAWqRrfyD2dSgFS1OAbnjE9sD8OFPhj3N5MVCAlZobnRSdFHp
         5+wvunPAdQkMXy2UezdxuVjzC8MW21tiCw4PNG72PNZHdS2CwsgsEyZIDon66UuWmpiu
         Srww==
X-Gm-Message-State: AOAM5308QXrp1QptcQGg3APXQTST7WOF0A97b0CHLzqbvHM6kBabBKMF
        k7W6lFWfJO3pUCf+pqMcs4pNeu0whg==
X-Google-Smtp-Source: ABdhPJySTKybAFaXLV7rHHqdLw4yAznMtl7MahmiSgkE2Og1CipW7OAc/4aJ+8aSCSSEgwAvvCKleg==
X-Received: by 2002:a05:6870:1485:b0:f3:bd4:aab0 with SMTP id k5-20020a056870148500b000f30bd4aab0mr916727oab.229.1654117817386;
        Wed, 01 Jun 2022 14:10:17 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ec29-20020a0568708c1d00b000f1c2847f8csm1162395oab.32.2022.06.01.14.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 14:10:17 -0700 (PDT)
Received: (nullmailer pid 458641 invoked by uid 1000);
        Wed, 01 Jun 2022 21:10:16 -0000
Date:   Wed, 1 Jun 2022 16:10:16 -0500
From:   Rob Herring <robh@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Allan.Nielsen@microchip.com, thomas.petazzoni@bootlin.com,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Horatiu.Vultur@microchip.com,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/6] dt-bindings: net: ethernet-controller: add
 QUSGMII mode
Message-ID: <20220601211016.GA458579-robh@kernel.org>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
 <20220519135647.465653-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519135647.465653-3-maxime.chevallier@bootlin.com>
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

On Thu, 19 May 2022 15:56:43 +0200, Maxime Chevallier wrote:
> Add a new QUSGMII mode, standing for "Quad Universal Serial Gigabit
> Media Independent Interface", a derivative of USGMII which, similarly to
> QSGMII, allows to multiplex 4 1Gbps links to a Quad-PHY.
> 
> The main difference with QSGMII is that QUSGMII can include an extension
> instead of the standard 7bytes ethernet preamble, allowing to convey
> arbitrary data such as Timestamps.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
