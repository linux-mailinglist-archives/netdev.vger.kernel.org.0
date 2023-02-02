Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68737688B30
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 00:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjBBX4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 18:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBBX4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 18:56:02 -0500
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BD66B000;
        Thu,  2 Feb 2023 15:56:01 -0800 (PST)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-169b190e1fdso4774575fac.4;
        Thu, 02 Feb 2023 15:56:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqDDQUprkp1RMVEhPX4Z2c/ZbDmiqbbtu00RKbuLR3E=;
        b=w0mohhn6AaIy7f9nsVlIRUToba7NUWRSRoThUm97JR15cIX9j0xcAx/b6nJehEZSk1
         Dpa/VwM/moOvXUE34UDRq34NF0eVqrWmKiNQkXu5qzN7UdsAKbRQCJxelBq6KWAfuyD/
         Q5BypEgA23fCBykFnjn7nWrV66wa7W5BVAi8kNxrkpapT1Bbebv1TGwcpSF2nIQ+0KjP
         aHrEF2vBUOYiQsMp/LYoyNhe+U8ClyeDS8ZtO1e1V5zTkYcEhx/Z2G48sivznYItLlVW
         QCxp32SbLKrY9O9X78eyTkttG7a2yK75Q68kvnSPTTPaXsJ1jTEQaX28DLVb379iHzLD
         ud4w==
X-Gm-Message-State: AO0yUKUrim3AjLValUXsm30TK4lyUiEHu65ME8CZvl7EQhvXYaSyeXYk
        iO2aP/fW16Df9f32HGbimQ==
X-Google-Smtp-Source: AK7set+dbGbrNIcluar5fAocvaRBcFMmz7IVlvibjKaNo3DwlgCzLj/Y5YIaUqblHgecoFoJRxRGpg==
X-Received: by 2002:a05:6870:c69f:b0:163:a45a:9fe1 with SMTP id cv31-20020a056870c69f00b00163a45a9fe1mr4315971oab.2.1675382160774;
        Thu, 02 Feb 2023 15:56:00 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r6-20020a4ae5c6000000b005177543fafdsm371957oov.40.2023.02.02.15.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 15:56:00 -0800 (PST)
Received: (nullmailer pid 2928953 invoked by uid 1000);
        Thu, 02 Feb 2023 23:55:59 -0000
Date:   Thu, 2 Feb 2023 17:55:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Peter Geis <pgwipeout@gmail.com>, xiaogang.fan@motor-comm.com,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        yanhong.wang@starfivetech.com, Rob Herring <robh+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>, fei.zhang@motor-comm.com,
        devicetree@vger.kernel.org, hua.sun@motor-comm.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
Message-ID: <167538215850.2928914.15833109785194194912.robh@kernel.org>
References: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
 <20230202030037.9075-2-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202030037.9075-2-Frank.Sae@motor-comm.com>
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


On Thu, 02 Feb 2023 11:00:33 +0800, Frank Sae wrote:
>  Add a YAML binding document for the Motorcomm yt8xxx Ethernet phy.
> 
> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
> ---
>  .../bindings/net/motorcomm,yt8xxx.yaml        | 117 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   1 +
>  3 files changed, 120 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>

