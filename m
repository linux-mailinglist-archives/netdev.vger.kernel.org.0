Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31907600629
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 07:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJQFON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 01:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJQFOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 01:14:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989DF52458;
        Sun, 16 Oct 2022 22:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 566C3B80E48;
        Mon, 17 Oct 2022 05:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F411EC433C1;
        Mon, 17 Oct 2022 05:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665983648;
        bh=CvDPdY6BUqMC/ABP5UUSw2rawQa77XBKRxF8x1A0uEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a13SnGLbSkTnOHsyGECGNvQZ/G+mOGRjTXK6moIXVTQt8MgJZ+SdHKOn8XpVjIsuN
         ytWILzgsYKN08Z2LPfNs/Ar0fLuNxLSCJTD721GFU++Hl6XbaSqnolfr3Ftylf/jE0
         eNSJkavpxhuK2j6XbzAnmzBoOnhickL0LyYHLIy+Y+4/AndmaNnDIA7iN+tNvQMgtY
         stt3Br/L6GLXc0M5I5DcLqoh9msUifJ2tTuFN6pI5QiP7NhazWqm8kVI1oOJStcd2W
         fhc9MIWoIYa3afmE+nt3OvzB3BOdXF6WkkX0IKxMPiLzVAZSjbH4LQZFn5GNcT6a7t
         yoPJwMMpjHF5A==
Date:   Mon, 17 Oct 2022 10:44:03 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Nandhini Srikandan <nandhini.srikandan@intel.com>,
        Rashmi A <rashmi.a@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sumit Gupta <sumitg@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-iio@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples, again
Message-ID: <Y0zkmww1B974VhdO@matsya>
References: <20221014205104.2822159-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014205104.2822159-1-robh@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14-10-22, 15:51, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
> 
> A meta-schema check for this is pending, so hopefully the last time to
> fix these.
> 
> Fix the indentation in intel,phy-thunderbay-emmc while we're here.

Acked-By: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
