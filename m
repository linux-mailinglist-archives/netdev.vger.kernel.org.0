Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4D5988FA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344300AbiHRQfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344846AbiHRQfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:35:34 -0400
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F64AE9CD;
        Thu, 18 Aug 2022 09:35:33 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id l5so1069278iln.8;
        Thu, 18 Aug 2022 09:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dpUR0Pq5ULK9T1MvsmZE3raG/5ZaZH6+6FeR01xKzAM=;
        b=bZqUOfrOkhYvOhZHmmQ9UQG6om8GpjMxvXGp31zJyGPYe3C5VRtuRdYIhoyXfO3Bud
         1o03BwUiNin66KApFdoLHP3NnfTqd/BXEVKvBoJFzEyyDpNhPUpM+a+BBqBsCitxkllb
         xHrYaEiKpPq5E+ipbuvhkaLmGv0vHeGdRYnH9b0tVjf0QSEu+JmAKcdXZ5WTgzr43KfG
         08SB9FP9MJj1fVEO3l51ZCGG+nG6PyE9IooHw0V3FonoB5r5EaLAwXthc626N631L0ry
         6tZD3NBDa5RLy7ZNCWjPV4BqkRhPmIZREmvTufRTIOzvkg8rUiJQy7Y4Onqq9r+iy5k1
         mLOw==
X-Gm-Message-State: ACgBeo0ga0SMCJ4umkPfNKMmN2r2SUGZbrnINrODfCvIoXfL2CIvUTS9
        IMyDzKreWuPsIrp3GDdQiw==
X-Google-Smtp-Source: AA6agR64PPkwOMRBjTSEwEflXHP+b9rldLZWOBATVSWSzmYkuMbI4aUtc4rux4HeIUMqx5L+8QLs6g==
X-Received: by 2002:a92:ad0d:0:b0:2e6:4294:bc45 with SMTP id w13-20020a92ad0d000000b002e64294bc45mr1886899ilh.278.1660840533156;
        Thu, 18 Aug 2022 09:35:33 -0700 (PDT)
Received: from robh.at.kernel.org ([2607:fb90:647:4ff2:3529:f8cd:d6cd:ac54])
        by smtp.gmail.com with ESMTPSA id y27-20020a02731b000000b003435c6391ffsm767016jab.62.2022.08.18.09.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:35:32 -0700 (PDT)
Received: (nullmailer pid 1994770 invoked by uid 1000);
        Thu, 18 Aug 2022 16:35:27 -0000
Date:   Thu, 18 Aug 2022 10:35:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     wei.fang@nxp.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net 1/2] dt-bindings: net: ar803x: add
 disable-hibernation-mode propetry
Message-ID: <20220818163527.GB1978870-robh@kernel.org>
References: <20220818030054.1010660-1-wei.fang@nxp.com>
 <20220818030054.1010660-2-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818030054.1010660-2-wei.fang@nxp.com>
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

On Thu, Aug 18, 2022 at 11:00:53AM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The hibernation mode of Atheros AR803x PHYs defaults to be
> enabled after hardware reset. When the cable is unplugged,
> the PHY will enter hibernation mode after about 10 seconds
> and the PHY clocks will be stopped to save power.
> However, some MACs need the phy output clock for proper
> functioning of their logic. For instance, stmmac needs the
> RX_CLK of PHY for software reset to complete.
> Therefore, add a DT property to configure the PHY to disable
> this hardware hibernation mode.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> 1. Add subject prefix.
> 2. Modify the property name and description to make them clear.
> V3 change:
> According to Andrew's suggestion, remodify the description to
> make it clear.
> ---
>  Documentation/devicetree/bindings/net/qca,ar803x.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
