Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DBD5B2F5B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiIIG5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiIIG5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:57:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D13913B54D;
        Thu,  8 Sep 2022 23:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3632F61EBF;
        Fri,  9 Sep 2022 06:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CB5C433D6;
        Fri,  9 Sep 2022 06:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662706640;
        bh=wkk/fFoxmeTUUDQytAXw1XkL0eqdbPeYJOpSRALOx+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lbz+Q8WVa2jAUz8IZxPbN8EucIOUk+tGOanl/J8Hlhs8FGgzAE84WBvFo7K+mcbj0
         EN01LnSlxC03jEEAE0+vCaN5mrU0nydt7PwHsGdVa2DMvbMIoir4BxZBpUDYESvCPd
         6WFxzCNh3QRY2V/v7vaY7fuskU5qI7TRWMDroLn0cO5CeP8VnTxobg2wYtIc1MhHV2
         sxiX/ThX5iKHAJ+Ca7qbo/W4zEmKSsQsd9l86J36WjYM0ZvH4zofs7EiVEtmb6vwlD
         6sWKrcRHI1b6IauyZOPh9gglbqGOnbh7nrZkwYVBfUG4oC3Q9Wr13Ab5mIhNv5d9Ii
         HwwanO1l8ef/w==
Date:   Fri, 9 Sep 2022 07:57:12 +0100
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, katie.morris@in-advantage.com
Subject: [GIT PULL] Immutable branch between MFD, Net and Pinctrl due for the
 v6.0 merge window
Message-ID: <YxrjyHcceLOFlT/c@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enjoy!

[ Well done Colin !! ]

The following changes since commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868:

  Linux 6.0-rc1 (2022-08-14 15:50:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-net-pinctrl-v6.0

for you to fetch changes up to f3e893626abeac3cdd9ba41d3395dc6c1b7d5ad6:

  mfd: ocelot: Add support for the vsc7512 chip via spi (2022-09-09 07:54:47 +0100)

----------------------------------------------------------------
Immutable branch between MFD Net and Pinctrl due for the v6.0 merge window

----------------------------------------------------------------
Colin Foster (8):
      mfd: ocelot: Add helper to get regmap from a resource
      net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
      pinctrl: ocelot: add ability to be used in a non-mmio configuration
      pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
      pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
      resource: add define macro for register address resources
      dt-bindings: mfd: ocelot: Add bindings for VSC7512
      mfd: ocelot: Add support for the vsc7512 chip via spi

 .../devicetree/bindings/mfd/mscc,ocelot.yaml       | 160 +++++++++++
 MAINTAINERS                                        |   7 +
 drivers/mfd/Kconfig                                |  21 ++
 drivers/mfd/Makefile                               |   3 +
 drivers/mfd/ocelot-core.c                          | 161 +++++++++++
 drivers/mfd/ocelot-spi.c                           | 299 +++++++++++++++++++++
 drivers/mfd/ocelot.h                               |  49 ++++
 drivers/net/mdio/mdio-mscc-miim.c                  |  42 +--
 drivers/pinctrl/Kconfig                            |   5 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c          |  14 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |  16 +-
 include/linux/ioport.h                             |   5 +
 include/linux/mfd/ocelot.h                         |  62 +++++
 13 files changed, 795 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 include/linux/mfd/ocelot.h

-- 
Lee Jones [李琼斯]
