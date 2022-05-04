Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F794519783
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiEDGog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240187AbiEDGof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9409818B13;
        Tue,  3 May 2022 23:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38CF46153E;
        Wed,  4 May 2022 06:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929DBC385A4;
        Wed,  4 May 2022 06:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651646459;
        bh=ZGMwwfSt9WgGcP9EzHW/QosFc70Yb/XaCBfaIMon8lM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hCMa156AuRtjnImdRRFb6sjNT7gi2K+aKH0x8uKbL7AEODCLcmpA+AldqhNahLoMc
         Jjbn4PU2sZC0QO3tUog7PiYYrqIfJDpXhjQPR0ah9UBAo6hM2LqRyEviiRxk8BR/Z/
         PswEhJLlhaaJETbJ+cDB+HgHVFfdIRtcQWjx3W6kmEYtvsvtdX1D61teQWllRNYd4Y
         4rq0yVjTAy3gemypN42SU8Wvxydjxbsf9n9Yu7PohyC0omGj3kKtLN8XGs6TxWmKd5
         RbuiHnFactE1ob6Dd26hg53PXFe++MOjqEkVBKu+OdQv2rpx3HjFyo1wUYQL3DAF3f
         4Lj9rl6MCVe6w==
Date:   Wed, 4 May 2022 12:10:55 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>, Stephen Boyd <sboyd@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Anson Huang <Anson.Huang@nxp.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Han Xu <han.xu@nxp.com>, Dario Binacchi <dariobin@libero.it>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-iio@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Drop redundant 'maxItems/minItems' in
 if/then schemas
Message-ID: <YnIf95FnuC01qxIp@matsya>
References: <20220503162738.3827041-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503162738.3827041-1-robh@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03-05-22, 11:27, Rob Herring wrote:
> Another round of removing redundant minItems/maxItems when 'items' list is
> specified. This time it is in if/then schemas as the meta-schema was
> failing to check this case.
> 
> If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
> same size as the list is redundant and can be dropped. Note that is DT
> schema specific behavior and not standard json-schema behavior. The tooling
> will fixup the final schema adding any unspecified minItems/maxItems.

For phy:

Acked-By: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
