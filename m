Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F692464FDB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350402AbhLAOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:38:01 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:38551 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243839AbhLAOgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:36:52 -0500
Received: by mail-oi1-f179.google.com with SMTP id r26so48833304oiw.5;
        Wed, 01 Dec 2021 06:33:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=5fVGwlF4XI4uZVCUusLE8Z4mnkW9gp/8l+SisQ75zHc=;
        b=YzlBdy2J4LnVeQUIiCfhrFHC7HYPdqJid8HpSq3qIrhs86qjUI0zH0+RQu3O+cfr8f
         AjjzipL9Wh3u0kq/8RDz+x39IQOXeG1+IrKdKLtY0gybEv06BGILOSa0HsFDZ8wzM4BF
         OIfbvKHayqJOVp9T2dEgcXoMFEP44mB8QaAqminIk+BK6QQcCj7D6BCJYl43JTdt+obz
         rQ/u51NMxoytqLxfjNYaTlfOvRRaKvisye2rUqzu6Sw8Q8W3gJpU5EQvKpkiJcdh2Vr7
         btCroIwC+oeZgB2nSWws0unCtCqbBvw1eNUxXAUaPrKq5ARDTnHScrCEKqJHv2YF9kgh
         LT+w==
X-Gm-Message-State: AOAM533qnbIrB201Nq/ddvJcAVkWHsd0wA661nX1VyrlTiTx8arE17Us
        4ZTwORrYDzGhEKc7cz8PqA==
X-Google-Smtp-Source: ABdhPJxwjiVMzMNb9BCilS0QJ051dI8LxsS3oZu3csQ+DJh5CIcJ66oIimU3M7fRpnBeFuI5uMlEuQ==
X-Received: by 2002:a05:6808:1408:: with SMTP id w8mr6502351oiv.54.1638369209303;
        Wed, 01 Dec 2021 06:33:29 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w5sm3529054otk.70.2021.12.01.06.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 06:33:28 -0800 (PST)
Received: (nullmailer pid 1684355 invoked by uid 1000);
        Wed, 01 Dec 2021 14:33:22 -0000
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com
In-Reply-To: <20211201041228.32444-4-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com> <20211201041228.32444-4-f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 3/7] dt-bindings: net: Document moca PHY interface
Date:   Wed, 01 Dec 2021 08:33:22 -0600
Message-Id: <1638369202.233948.1684354.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 20:12:24 -0800, Florian Fainelli wrote:
> MoCA (Multimedia over Coaxial) is used by the internal GENET/MOCA cores
> and will be needed in order to convert GENET to YAML in subsequent
> changes.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1561996


ethernet@0,2: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var3-ads2.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dt.yaml
	arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dt.yaml

ethernet@17020000: phy-handle: [[36], [37]] is too long
	arch/arm64/boot/dts/apm/apm-mustang.dt.yaml

ethernet@30000: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
	arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dt.yaml
	arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dt.yaml

