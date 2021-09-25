Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC0F4184E6
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 00:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhIYWSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 18:18:16 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:33500 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhIYWSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 18:18:11 -0400
Received: by mail-ot1-f51.google.com with SMTP id s36-20020a05683043a400b0054d4c88353dso7640244otv.0;
        Sat, 25 Sep 2021 15:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=FpW3DBFCE8qk3/WrOETm+elC+ikU+jNmzXfQ4H1gg0E=;
        b=KqhKeEHoT4kQfPilmY5UdZeU/J1UQPHt6hTHsZtRycm6nmzs1hNLk6DhXvacLcODPD
         JWgdc12CPxQX4Bjehcxw4vFY9adk34g77vI1omRopMdPN3uRzrYOhxX1UptjP8mGXhzt
         mfz/OXFr7gW8QWjAY85yQPvO2oJXbeiJUWC0VCAeZwvigKcmAytyvFff3z5ysuhhoKhi
         l6MSv90PvNUqvtF7IdvPm8Y5701q/flwvrU69qeHdjH39MaEwKKKRyDeDtiTwm8MJlep
         E9iF45pkgTYFkA79b61UfYu+Nmv8Vd4uKuRaEr9DN3w8JeIP4QqJchscIE1uOsLhiVxA
         OpVQ==
X-Gm-Message-State: AOAM531hGdLYjIu0ZNfYfXl3Te8iAEvDjDFxhmNkyA5P4TVcHAZAY2+z
        S4FoG80HNosc1WyKPgowqw==
X-Google-Smtp-Source: ABdhPJxDZmLtb6AEW6lYozXpuwFp7CVefOJn9HXZ8cCR5cQl8/2w5SChodyo8ByACA4nNEmpUmtxrw==
X-Received: by 2002:a9d:6c52:: with SMTP id g18mr10068166otq.75.1632608195370;
        Sat, 25 Sep 2021 15:16:35 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 10sm587122oti.79.2021.09.25.15.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 15:16:34 -0700 (PDT)
Received: (nullmailer pid 3839366 invoked by uid 1000);
        Sat, 25 Sep 2021 22:16:30 -0000
From:   Rob Herring <robh@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Russell King <linux@armlinux.org.uk>
In-Reply-To: <1632519891-26510-3-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com> <1632519891-26510-3-git-send-email-justinpopo6@gmail.com>
Subject: Re: [PATCH net-next 2/5] dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
Date:   Sat, 25 Sep 2021 17:16:30 -0500
Message-Id: <1632608190.786543.3839365.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 14:44:48 -0700, Justin Chen wrote:
> The ASP 2.0 Ethernet controller uses a brcm unimac.
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1532529


mdio@e14: #address-cells:0:0: 1 was expected
	arch/arm64/boot/dts/broadcom/bcm2711-rpi-400.dt.yaml
	arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dt.yaml
	arch/arm/boot/dts/bcm2711-rpi-400.dt.yaml
	arch/arm/boot/dts/bcm2711-rpi-4-b.dt.yaml

mdio@e14: #size-cells:0:0: 0 was expected
	arch/arm64/boot/dts/broadcom/bcm2711-rpi-400.dt.yaml
	arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dt.yaml
	arch/arm/boot/dts/bcm2711-rpi-400.dt.yaml
	arch/arm/boot/dts/bcm2711-rpi-4-b.dt.yaml

