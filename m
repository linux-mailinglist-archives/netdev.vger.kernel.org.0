Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41954BDBD
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345619AbiFNWej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbiFNWei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:34:38 -0400
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38ED44D277;
        Tue, 14 Jun 2022 15:34:37 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id b138so4100507iof.13;
        Tue, 14 Jun 2022 15:34:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nfvtIdPgiXULHnvZfVP5vqYcUUa4+OVCxD93E+5pMPc=;
        b=xCQkU0PiBqeHIsmHf2eT6Co6Lym+Uso9g5MbI9LxyXueL3Pcs5eCJVSUKJmDNhRL9m
         T6d3tyslSlghnbmtETjT8yBKw+/6kum73fQXykuzTlo0PWoerlVDtfhnG+M42N4GIbA9
         ZHFE6tzI6xjq6yomIvSzJtsde72pT5r7llW/H9YcwtX0w0ANHFK59ZffuXVPtUm2luR8
         5zoA1aCkNtSLhwclqci/MS77RLnmFbX/bASo6rLatDJLLThdDeSkDZo1AnoMId9IYn3w
         x9hDn8GtmXSCuudUtGQb8A3OuqSIyuC2J5nhLR17qd8PxRCfuE76TxgVIvhzHJXMvlkH
         FGww==
X-Gm-Message-State: AOAM531US2dkqtnUGoWX4jCdY88orGBi2ly1wGy1xjaT61SANUmzqvJN
        m7oYYkRAAFvUOqR0EIK/sfA0gh57Vg==
X-Google-Smtp-Source: ABdhPJxE1abxcZlYMoUexYa+t1QhZEgC3GbKhXiUkgv+6tmPmB+hvZlvUSYMxVLNMKQy432HbWyDcg==
X-Received: by 2002:a6b:6a07:0:b0:66a:2e5f:2058 with SMTP id x7-20020a6b6a07000000b0066a2e5f2058mr1167288iog.72.1655246076467;
        Tue, 14 Jun 2022 15:34:36 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id n11-20020a02710b000000b003315c00e885sm5402674jac.0.2022.06.14.15.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 15:34:36 -0700 (PDT)
Received: (nullmailer pid 2853736 invoked by uid 1000);
        Tue, 14 Jun 2022 22:34:33 -0000
Date:   Tue, 14 Jun 2022 16:34:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     Greg Ungerer <gerg@kernel.org>, DENG Qingfang <dqfext@gmail.com>,
        netdev@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 5/6] dt-bindings: net: dsa: make reset optional and
 add rgmii-mode to mt7531
Message-ID: <20220614223433.GA2853676-robh@kernel.org>
References: <20220610170541.8643-1-linux@fw-web.de>
 <20220610170541.8643-6-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610170541.8643-6-linux@fw-web.de>
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

On Fri, 10 Jun 2022 19:05:40 +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> A board may have no independent reset-line, so reset cannot be used
> inside switch driver.
> 
> E.g. on Bananapi-R2 Pro switch and gmac are connected to same reset-line.
> 
> Resets should be acquired only to 1 device/driver. This prevents reset to
> be bound to switch-driver if reset is already used for gmac. If reset is
> only used by switch driver it resets the switch *and* the gmac after the
> mdio bus comes up resulting in mdio bus goes down. It takes some time
> until all is up again, switch driver tries to read from mdio, will fail
> and defer the probe. On next try the reset does the same again.
> 
> Make reset optional for such boards.
> 
> Allow port 5 as cpu-port and phy-mode rgmii for mt7531.
> 
> - MT7530 supports RGMII on port 5 and RGMII/TRGMII on port 6.
> - MT7531 supports on port 5 RGMII and SGMII (dual-sgmii) and
>   SGMII on port 6.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> v4:
>  - add port 5 as CPU-Port
>  - change description
> ---
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml      | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
