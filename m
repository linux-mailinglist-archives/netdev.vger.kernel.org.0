Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EF9399526
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFBVGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:06:03 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:47098 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBVGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 17:06:02 -0400
Received: by mail-oi1-f177.google.com with SMTP id x15so4010212oic.13;
        Wed, 02 Jun 2021 14:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oVR3AvDB5YuftfnirDS6S655YqBrktVMLOvolfq9ZGQ=;
        b=k8V2KqFQ8/l8Fvs0pOqGB2YZbdiFtQz3PDNwTIr6Jidpuz280VRboaF47Vr8GYrP6A
         TMrQecDqv7L1D1Qu8KQEe9/N6C7yK12JLMNQj3EP+N+UnAZ8QvIw4vRFRsPxqM9pb82O
         oK+aEbUFG/EqMEFevYlc7a1xb8Kfaxmi/C045AiuthVINKAjb5ANqRQEXb+bet/2D1kq
         +ZN9gjUQKZrhGD34c1OT1Ji02tdx868bTryCCNvtRqPMoU/9Qldj2Vg+cswuAxmEnlE2
         ZqK0qPfzTGbOnYVf8w/ul6T7gbEn73hr6lmM6Mx9Y3eR2J4X0hGZhHmcKEMBwZ+VUIwj
         Em/Q==
X-Gm-Message-State: AOAM530pox7+TffCzNKEdx1l87TimqmGEAEuZE8SHQtA8J1TDOOqjkrS
        6fnYj5i5f0bw4oyXrySAug==
X-Google-Smtp-Source: ABdhPJzyeoycgDbLMad+zV8zeFpz+fpMbATJOAz+M+rhuXu7mrVC5TLXcW3DEdGSxZh8+Iy2RdiLxg==
X-Received: by 2002:a05:6808:1c9:: with SMTP id x9mr23365339oic.109.1622667843191;
        Wed, 02 Jun 2021 14:04:03 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x14sm241146oic.3.2021.06.02.14.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 14:04:02 -0700 (PDT)
Received: (nullmailer pid 4038638 invoked by uid 1000);
        Wed, 02 Jun 2021 21:04:00 -0000
Date:   Wed, 2 Jun 2021 16:04:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Sekhar Nori <nsekhar@ti.com>, Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-spi@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-i2c@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 04/12] dt-bindings: clock: update ti,sci-clk.yaml
 references
Message-ID: <20210602210400.GA4038575@robh.at.kernel.org>
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
 <0fae687366c09dfb510425b3c88316a727b27d6d.1622648507.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fae687366c09dfb510425b3c88316a727b27d6d.1622648507.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Jun 2021 17:43:10 +0200, Mauro Carvalho Chehab wrote:
> Changeset a7dbfa6f3877 ("dt-bindings: clock: Convert ti,sci-clk to json schema")
> renamed: Documentation/devicetree/bindings/clock/ti,sci-clk.txt
> to: Documentation/devicetree/bindings/clock/ti,sci-clk.yaml.
> 
> Update the cross-references accordingly.
> 
> Fixes: a7dbfa6f3877 ("dt-bindings: clock: Convert ti,sci-clk to json schema")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/devicetree/bindings/gpio/gpio-davinci.txt | 2 +-
>  Documentation/devicetree/bindings/i2c/i2c-davinci.txt   | 2 +-
>  Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt | 2 +-
>  Documentation/devicetree/bindings/net/can/c_can.txt     | 2 +-
>  Documentation/devicetree/bindings/spi/spi-davinci.txt   | 2 +-
>  MAINTAINERS                                             | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 

Applied, thanks!
