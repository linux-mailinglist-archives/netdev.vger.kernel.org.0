Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821B44AF566
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiBIPfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbiBIPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:35:18 -0500
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843FAC05CB89;
        Wed,  9 Feb 2022 07:35:18 -0800 (PST)
Received: by mail-oo1-f51.google.com with SMTP id u25-20020a4ad0d9000000b002e8d4370689so2800313oor.12;
        Wed, 09 Feb 2022 07:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=1mkLFSmd4i+BBIXy7fKCIcUEt8oNd8K14KXOxmE5hKQ=;
        b=t3wnmTjM6DKx7hTDpqSrr0G9Q7jjWEIvPaqCfxBGlBUHsu9wr0OnCwXED06QdmnxWT
         oEkvojcyg1+rvXrhHtn2vSGUunWv6w5iiOyD6RnCe5NK6orPOGSb7El/8s3U5xr6imMj
         8dUOj4ncICZmRLgtffPLFqcmjS/Wobp+9onV6meorIyAz+oFswm+nQr+8tDnH7V8vnby
         edN84gvOXfqbnWsQ+rOwaiwWq7DJuHkR1NQsSzziH44ey7Pwa+mpo4NMfoqtlvAXFxmC
         stN7LVIxeNuYn5oYxVSl1hqgHDXdh3hZROHrKBkzEuLsUL71ih97vmFBH8KK24o7k0Ym
         /0LQ==
X-Gm-Message-State: AOAM532fq/RxVtqT5nNybqOdTTrXvPDr18NllLOBBg/bmjMjvaMJYIoI
        E91ZQGSW+Xhm+1d6Y1Gf8HdJQ1X+sg==
X-Google-Smtp-Source: ABdhPJze37RkXIeQyKNHdeY2KcUB29vKQ0Nr6pdDba5eg6DiwMkdQWBAnS8RHq6FbjaLmlrLCDY1sw==
X-Received: by 2002:a05:6870:f78c:: with SMTP id fs12mr892266oab.297.1644420917756;
        Wed, 09 Feb 2022 07:35:17 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id v10sm6624360oto.53.2022.02.09.07.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:35:17 -0800 (PST)
Received: (nullmailer pid 391819 invoked by uid 1000);
        Wed, 09 Feb 2022 15:35:08 -0000
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20220209081025.2178435-2-o.rempel@pengutronix.de>
References: <20220209081025.2178435-1-o.rempel@pengutronix.de> <20220209081025.2178435-2-o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: add schema for ASIX USB Ethernet controllers
Date:   Wed, 09 Feb 2022 09:35:08 -0600
Message-Id: <1644420908.420720.391818.nullmailer@robh.at.kernel.org>
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

On Wed, 09 Feb 2022 09:10:24 +0100, Oleksij Rempel wrote:
> Create initial schema for ASIX USB Ethernet controllers and import all
> currently supported USB IDs form drivers/net/usb/asix_devices.c
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/asix,ax88178.yaml | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1590224


asix@1: $nodename:0: 'asix@1' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/tegra20-colibri-eval-v3.dt.yaml
	arch/arm/boot/dts/tegra20-colibri-iris.dt.yaml
	arch/arm/boot/dts/tegra30-colibri-eval-v3.dt.yaml

