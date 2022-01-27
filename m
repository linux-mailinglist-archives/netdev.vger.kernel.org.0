Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CBF49E418
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiA0ODO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:03:14 -0500
Received: from mail-oo1-f52.google.com ([209.85.161.52]:38626 "EHLO
        mail-oo1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242066AbiA0ODM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:03:12 -0500
Received: by mail-oo1-f52.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so702127ooj.5;
        Thu, 27 Jan 2022 06:03:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=bobbe8x/hcY1c/ieWxV92ycgrrHLjEYjiuQwW0caLlE=;
        b=LAr8zwZFmOIvhbs4jj85rLR/BVbkg0uhVcDJRQ0PhcUIxGqZ9KyfLhUeJ/3CtvgjZB
         jm2Sxa8buY7arH+3VGrxuZFT8vTa6Vj9ll47cNusyQgzm0pIto1i8EVH86LFiu3rlKqF
         5Hpubn54aJE2GG3Ou6akc+kqv0EMXil/sDniSbEtgPiGe0T3udh0BN/bm1Vb2nOADqq9
         grKOin9LLeRJF6ki25g7h+VQAjT9nbFvKoNLbFqwLEdgioslhOmWXfrIG2Jxt1gNgjHF
         YCUtbERORgoIJjrHlr+qoANwIIpiHR1WYUGSsPjWCVRjLs1INhU+TLpZ99sxOz6vnpzu
         yY7Q==
X-Gm-Message-State: AOAM533rkebOgt6WxeAUPhNRx2mUMoCRhQvnUkyDffeIsJxOpp6S9Lac
        bqwz0iq+rwRqqbPupAm8bQ+AnuyXiw==
X-Google-Smtp-Source: ABdhPJzmSkJYmmXYCpGDjtsaTgBbmLckXim21PKeey0oV4qc8OdnduV3mUAerOcoGm5iB1JeTE7wfw==
X-Received: by 2002:a4a:e582:: with SMTP id o2mr1915457oov.65.1643292191895;
        Thu, 27 Jan 2022 06:03:11 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s3sm6366414otg.67.2022.01.27.06.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 06:03:11 -0800 (PST)
Received: (nullmailer pid 3149363 invoked by uid 1000);
        Thu, 27 Jan 2022 14:03:05 -0000
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20220127104905.899341-3-o.rempel@pengutronix.de>
References: <20220127104905.899341-1-o.rempel@pengutronix.de> <20220127104905.899341-3-o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next v1 2/4] dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet controllers
Date:   Thu, 27 Jan 2022 08:03:05 -0600
Message-Id: <1643292185.240581.3149362.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 11:49:03 +0100, Oleksij Rempel wrote:
> Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/microchip,lan95xx.yaml       | 82 +++++++++++++++++++
>  1 file changed, 82 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1584951


smsc@2: $nodename:0: 'smsc@2' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/tegra30-ouya.dt.yaml

usbether@1: $nodename:0: 'usbether@1' does not match '^ethernet(@.*)?$'
	arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml
	arch/arm/boot/dts/bcm2835-rpi-b.dt.yaml
	arch/arm/boot/dts/bcm2835-rpi-b-plus.dt.yaml
	arch/arm/boot/dts/bcm2835-rpi-b-rev2.dt.yaml
	arch/arm/boot/dts/bcm2836-rpi-2-b.dt.yaml
	arch/arm/boot/dts/bcm2837-rpi-3-b.dt.yaml
	arch/arm/boot/dts/omap3-beagle-xm-ab.dt.yaml
	arch/arm/boot/dts/omap3-beagle-xm.dt.yaml
	arch/arm/boot/dts/omap4-panda-a4.dt.yaml
	arch/arm/boot/dts/omap4-panda.dt.yaml
	arch/arm/boot/dts/omap4-panda-es.dt.yaml

usbether@3: $nodename:0: 'usbether@3' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/omap5-uevm.dt.yaml

