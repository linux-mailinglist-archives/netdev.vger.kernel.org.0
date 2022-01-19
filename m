Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA24493892
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353870AbiASKcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353805AbiASKcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:32:24 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F66DC061749
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:32:24 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bu18so7531808lfb.5
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sr17yjVIJ3L6nqEXDMpIqK2xXImflLFzz6ALbEm9u68=;
        b=Xp8s21ftcZ0WG13DDgbdH7NIUsuYX+ghvkD5zw1hiLod5qbV+yjC9/iw3BxedgypWz
         j185xcOoN7LD6uCNH62mSJRvMAjwIi7qcbYCznd6Wd0VuvmCQ/sizMwR5aWhMScNA/rl
         hmuEc+DbVv1NqMjk5IXcy/Hk3oFXKZ0haMWzOfivc06wvoxpEiX1vitoLqGmZuk04L2x
         HC73i8VxJwVCI/4Mkmi2NET/E8BffuYg/4Zged81GUTCUySqRPVe2agczTV87+sP+2pN
         pDJV7fJq03+xTsoQaVBtN6S+RGEn7oHeifzgS2DkyqcDDGnQ9aAHk1KN9hJBM2T+WaJf
         EdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sr17yjVIJ3L6nqEXDMpIqK2xXImflLFzz6ALbEm9u68=;
        b=1NUDpMzJtQkt9xcgJIBFVdTfKJWOT1U5f6XkmXaUWyHOTLSYXQaVtGId8UGUphQmt3
         mhjfsfPpgkRpxx7tORMlStkv0fGqHmc7DT1zYp2GjEDtsyioy6VBJ4CYIBn7nf45977w
         eIvUVNU1D/7MTEXkArvpeJ/c1a2jWBWs9v1KJkTkt4pfHS0IWwb8Y+VaBX3tu/4HJJps
         LCpVOFlYB+1xM96y9UcguEYtav4rIaeql4BSCbgB0c5SS4tF0uTRRrhcsGAFTpETI4rI
         mg390fVe/z8yyYc+0GVYTApeIVXKMqEF93Mdn9V9w8ZuI9+hBtNlK2Mx1m1RloVS50q9
         eFKw==
X-Gm-Message-State: AOAM530LcNvcFPrni0d1eWazjY71xOIp1QYGfFmR0dzVJUai2BzqB77T
        haausd2vh8TSQ7isTUttlfzHQhMgcB6roCCiIsEpMw==
X-Google-Smtp-Source: ABdhPJz5t3UBuJxmMbI2E3pOLPGLQiV4ByMa0pgkUilXefnRDUK3bGbZ4bWfdB/wwOZVZ58x7DxfCbRQTc3tUAIioE8=
X-Received: by 2002:a2e:a26d:: with SMTP id k13mr10012578ljm.300.1642588342599;
 Wed, 19 Jan 2022 02:32:22 -0800 (PST)
MIME-Version: 1.0
References: <20220119015038.2433585-1-robh@kernel.org>
In-Reply-To: <20220119015038.2433585-1-robh@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 19 Jan 2022 11:31:45 +0100
Message-ID: <CAPDyKFr5uT3H8NaAvPyGajo2R6DriYC92y=RdAk=G4PMC4MxYw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dmaengine@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 at 02:50, Rob Herring <robh@kernel.org> wrote:
>
> The 'phandle-array' type is a bit ambiguous. It can be either just an
> array of phandles or an array of phandles plus args. Many schemas for
> phandle-array properties aren't clear in the schema which case applies
> though the description usually describes it.
>
> The array of phandles case boils down to needing:
>
> items:
>   maxItems: 1
>
> The phandle plus args cases should typically take this form:
>
> items:
>   - items:
>       - description: A phandle
>       - description: 1st arg cell
>       - description: 2nd arg cell
>
> With this change, some examples need updating so that the bracketing of
> property values matches the schema.
>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Georgi Djakov <djakov@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Jingoo Han <jingoohan1@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Viresh Kumar <vireshk@kernel.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Kevin Hilman <khilman@kernel.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: dmaengine@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-leds@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-phy@lists.infradead.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

For CPUs and PM domains:

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe
