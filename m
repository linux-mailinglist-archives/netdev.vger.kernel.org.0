Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11574428366
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 21:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhJJTeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 15:34:06 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:43812 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhJJTeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 15:34:03 -0400
Received: by mail-oi1-f180.google.com with SMTP id o4so21629037oia.10;
        Sun, 10 Oct 2021 12:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=MYIlTpYDJjZellyeCYKLi1pJMKeChgU18eRemNO5FCw=;
        b=Q2unpJ9RGOs/yOGuOI+2peXgXCPduNWembN00zZDvLI3jUgkx9+rJh1MyR8Uq0FTky
         ZeI9nvNqQjDAhDG0sGJ3mD8zWCpKXpm2/dZ11O2h8nf+Ctt7UwIyHMy69OSk3IDySMZO
         r7lWpNnEddBP5paTTfH2iwhN0szaPn2gqWgHBpUY5viemxzYbr2TIV00J73aL0Hkt62p
         qWlx5ual3EBjuCmeGvNlzBopnSF9+Ge/jara9oPORq035vn1l8fsX76uyFGE4Vpr1P/O
         rqqLEDaQNgw7apC6X1MiEg1P7BLsSLmE15q/q1EecPmBjP0g9y9bF4aVxGqLDHJJjRdr
         ntDQ==
X-Gm-Message-State: AOAM532ERvtl8nyacEfTBDxImqSZylTwXNqSvO9/UgvSqlbRI+zR/amc
        s0OEiz2SupOdUuh094ZjGA==
X-Google-Smtp-Source: ABdhPJxgeTMBBn9F4crT32hQ1ZZTwytZCF5LN8wu5tbtaklLYtek+u/DdAE9/w30ZxzGx0VOXGJY4w==
X-Received: by 2002:aca:b903:: with SMTP id j3mr24286138oif.24.1633894323862;
        Sun, 10 Oct 2021 12:32:03 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id i25sm1314907oto.26.2021.10.10.12.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 12:32:03 -0700 (PDT)
Received: (nullmailer pid 3158670 invoked by uid 1000);
        Sun, 10 Oct 2021 19:31:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>
In-Reply-To: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
References: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
Subject: Re: [PATCH 1/7] dt-bindings: nfc: nxp,nci: convert to dtschema
Date:   Sun, 10 Oct 2021 14:31:56 -0500
Message-Id: <1633894316.441793.3158669.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Oct 2021 16:23:11 +0200, Krzysztof Kozlowski wrote:
> Convert the NXP NCI NFC controller to DT schema format.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../devicetree/bindings/net/nfc/nxp,nci.yaml  | 61 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/nxp-nci.txt   | 33 ----------
>  MAINTAINERS                                   |  1 +
>  3 files changed, 62 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1539010


nfc@28: 'clock-frequency' is a required property
	arch/arm64/boot/dts/qcom/msm8916-huawei-g7.dt.yaml

nfc@28: compatible:0: 'nxp,nxp-nci-i2c' was expected
	arch/arm64/boot/dts/qcom/msm8916-huawei-g7.dt.yaml

nfc@28: compatible: Additional items are not allowed ('nxp,nxp-nci-i2c' was unexpected)
	arch/arm64/boot/dts/qcom/msm8916-huawei-g7.dt.yaml

nfc@28: compatible: ['nxp,pn547', 'nxp,nxp-nci-i2c'] is too long
	arch/arm64/boot/dts/qcom/msm8916-huawei-g7.dt.yaml

nfc@30: 'clock-frequency' is a required property
	arch/arm/boot/dts/ste-ux500-samsung-janice.dt.yaml

nfc@30: compatible:0: 'nxp,nxp-nci-i2c' was expected
	arch/arm/boot/dts/ste-ux500-samsung-janice.dt.yaml

nfc@30: compatible: Additional items are not allowed ('nxp,nxp-nci-i2c' was unexpected)
	arch/arm/boot/dts/ste-ux500-samsung-janice.dt.yaml

nfc@30: compatible: ['nxp,pn547', 'nxp,nxp-nci-i2c'] is too long
	arch/arm/boot/dts/ste-ux500-samsung-janice.dt.yaml

