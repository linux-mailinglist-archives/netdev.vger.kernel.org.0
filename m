Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA32509DF6
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380136AbiDUKuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiDUKuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:50:03 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76F8B2BC9;
        Thu, 21 Apr 2022 03:47:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 31C8B8106;
        Thu, 21 Apr 2022 10:44:22 +0000 (UTC)
Date:   Thu, 21 Apr 2022 13:47:12 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 7/9] ARM: dts: omap3/4/5: fix ethernet node name for
 different OMAP boards
Message-ID: <YmE2MJfvMHH7BKCD@atomide.com>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216074927.3619425-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Oleksij Rempel <o.rempel@pengutronix.de> [220216 09:49]:
> The node name of Ethernet controller should be "ethernet" instead of
> "usbether" as required by Ethernet controller devicetree schema:
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml
> 
> This patch can potentially affect boot loaders patching against full
> node path instead of using device aliases.

Picking up this patch into omap-for-v5.19/dt branch.

Thanks,

Tony
