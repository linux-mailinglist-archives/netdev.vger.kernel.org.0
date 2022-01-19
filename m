Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B50493A19
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 13:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354297AbiASMJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 07:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiASMJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 07:09:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A51C061574;
        Wed, 19 Jan 2022 04:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C30661659;
        Wed, 19 Jan 2022 12:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C899C004E1;
        Wed, 19 Jan 2022 12:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642594158;
        bh=jTL1kOllWwNpAyRghJtzBJcKTv5b3vqCwXM1meqTpw0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=EAM3BRW+CbiGfMCjMaveMIE0YyZKBv4YGXrhRLSxa7sz3YBI0QQEuz2LrLupXBm6Y
         R889FqqDBLJRbmysGVMQsKr1+BPa+yDJxTjvvCiMdGOmw3WRnNeHLu+nDQzZ0VrcIg
         537D4y6llCDYE69wujlX8OZOzzDzuUv4TZj1s79d9eFb+RXQG9+f7bhJe+cQ9hqXOs
         UzplFSvX38xneJW3n6U2ZW+ZGtGaC4rD9CUZ5eJbXp53b/2qOgmJO8dTGx52wnNROz
         mMWxGEVBV5Zu24UiKq2KQXFZoJvf1AB0QizfrxdUr/IZ5hnV98uHFEwvu8cGlN1QiB
         De5JfwgYpTzOg==
Message-ID: <07adcd47-79c9-ae37-80c6-d1204c6cfea4@kernel.org>
Date:   Wed, 19 Jan 2022 14:09:01 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
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
        Ulf Hansson <ulf.hansson@linaro.org>,
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
References: <20220119015038.2433585-1-robh@kernel.org>
From:   Georgi Djakov <djakov@kernel.org>
In-Reply-To: <20220119015038.2433585-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19.01.22 3:50, Rob Herring wrote:
> The 'phandle-array' type is a bit ambiguous. It can be either just an
> array of phandles or an array of phandles plus args. Many schemas for
> phandle-array properties aren't clear in the schema which case applies
> though the description usually describes it.
> 
> The array of phandles case boils down to needing:
> 
> items:
>    maxItems: 1
> 
> The phandle plus args cases should typically take this form:
> 
> items:
>    - items:
>        - description: A phandle
>        - description: 1st arg cell
>        - description: 2nd arg cell
> 
> With this change, some examples need updating so that the bracketing of
> property values matches the schema.
> 
[..]
>   .../bindings/interconnect/qcom,rpmh.yaml      |  2 +

Acked-by: Georgi Djakov <djakov@kernel.org>
