Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D386E9121
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbjDTKyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbjDTKyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:54:32 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2D73AA8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:52:12 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id w19so1848646uad.7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681987923; x=1684579923;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bD6SfECQ2ADOvv3hp+b+Hh0rcGbyto+SEbR60lrY1dY=;
        b=G7bYMg0O1BCstKbdpADc8/oJ1/2A4VRecLc565KFfTzpscmWiEkfXnzHnvIadofIFh
         OjMoY4hElAUDLJfC5I2BDJj0x4JWRKJl5zxihU7sPH+99KSCFiiAf/YKkk/n7ktRfHOF
         5HnSgFVrcZuMpyHv8qgvchQ9ggGaS2yu6IeZKRKC5vQeS43iqeGN2iMpy9/PIMMPpNXa
         w3ZV4S5e5vSdzQOwWA0FhyV7W9lN7YCUtHCL2WzIVQi4mSWWlUzJgcr+nAVzXtM2/TCS
         6LYvyWq2gjAJyZHwxRJmUqTsJ/9Atr5wLeamrewfCk5M1xIotLjmotwiqcTZzSYY0uq4
         6Y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681987923; x=1684579923;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bD6SfECQ2ADOvv3hp+b+Hh0rcGbyto+SEbR60lrY1dY=;
        b=K2kmTdt0/hT5wRuTqUjiR1XgPiD2/nxiS7EQc+kBKu8bdmPwhfgiqhkZga+1WlWmCX
         IyYltMObuH/oBfyek3Qq8uNMTIwqFf4QGhgFKBKGvsGU9IBtdvehG7kVLckjNXpFAbVw
         X4O32jx8xusuyYWzcxJJvaoyOklo9O/KLQdTCQhQRMZRzxKC9f2ERjJL+KStCe4igEGS
         uEWJmw/D3y8tUER+vjkdDySY4CHqqlPheA/KF9BH184niZ325hpIWEuRrX8+pReNGnjW
         SPnoMtPaoHSBJaDn85QcQIsIiNWdqLBPv9Q93ovdDZLkqkVUgC2XC1w/EKB8rTuCIkza
         gn5w==
X-Gm-Message-State: AAQBX9dm6sYx6nGogSO8dY9TBNumuYu2CGpj/nBA7DCst+pJQA3/3xHv
        kwQKj/C5/zsoS/59ZR1rxMcAwlEjCS6QdE0hpG2bKRim5AiyGNXPK9U=
X-Google-Smtp-Source: AKy350Y55UZ8B68XNljcnA3b3qT2rounlfBKD+bGk83+L3xVWuciribECtEXexgCfK0NMqXchyhX8hjTQd13EK9qZjo=
X-Received: by 2002:a1f:a407:0:b0:446:b903:d76c with SMTP id
 n7-20020a1fa407000000b00446b903d76cmr1199528vke.5.1681987922927; Thu, 20 Apr
 2023 03:52:02 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Apr 2023 16:21:51 +0530
Message-ID: <CA+G9fYuMEEzTUyF-pCVuZYd+BU53_8MRyXoOmbYEo1O1v=9teg@mail.gmail.com>
Subject: next: arm: drivers/net/phy/phy_device.o: in function `phy_probe':
 drivers/net/phy/phy_device.c:3053: undefined reference to
To:     Netdev <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Please ignore this email if it is already reported ]

Following build failures noticed on Linux next-20230419.

Regressions found on arm:
 - build/clang-16-omap2plus_defconfig
 - build/clang-16-davinci_all_defconfig
 - build/gcc-8-davinci_all_defconfig
 - build/clang-nightly-omap2plus_defconfig
 - build/gcc-12-omap2plus_defconfig
 - build/gcc-12-davinci_all_defconfig
 - build/clang-nightly-davinci_all_defconfig
 - build/gcc-8-omap2plus_defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
------------

 arm-linux-gnueabihf-ld: drivers/net/phy/phy_device.o: in function `phy_probe':
drivers/net/phy/phy_device.c:3053: undefined reference to
`devm_led_classdev_register_ext'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.o: in
function `davinci_emac_of_get_pdata':
drivers/net/ethernet/ti/davinci_emac.c:1770: undefined reference to
`of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.c:1772:
undefined reference to `of_phy_register_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.o: in
function `davinci_emac_probe':
drivers/net/ethernet/ti/davinci_emac.c:1990: undefined reference to
`of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.c:1990:
undefined reference to `of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.c:1991:
undefined reference to `of_phy_deregister_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.o: in
function `emac_dev_open':
drivers/net/ethernet/ti/davinci_emac.c:1497: undefined reference to
`of_phy_connect'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.o: in
function `davinci_emac_remove':
drivers/net/ethernet/ti/davinci_emac.c:2022: undefined reference to
`of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_emac.c:2023:
undefined reference to `of_phy_deregister_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_mdio.o: in
function `davinci_mdio_probe':
include/linux/of_mdio.h:23: undefined reference to `__of_mdiobus_register'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/davinci_mdio.o: in
function `davinci_mdio_probe':
include/linux/phy.h:458: undefined reference to `devm_mdiobus_alloc_size'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_remove_dt':
drivers/net/ethernet/ti/cpsw.c:1410: undefined reference to
`of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.c:1411: undefined
reference to `of_phy_deregister_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_probe':
drivers/net/ethernet/ti/cpsw.c:1318: undefined reference to
`of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.c:1322: undefined
reference to `of_phy_register_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw.o: in function
`cpsw_slave_open':
drivers/net/ethernet/ti/cpsw.c:614: undefined reference to `of_phy_connect'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in
function `cpsw_remove':
drivers/net/ethernet/ti/cpsw_new.c:1354: undefined reference to
`of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.c:1355:
undefined reference to `of_phy_deregister_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in
function `cpsw_probe':
drivers/net/ethernet/ti/cpsw_new.c:1290: undefined reference to
`of_phy_register_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.c:1289:
undefined reference to `of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.c:1354:
undefined reference to `of_phy_is_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.c:1355:
undefined reference to `of_phy_deregister_fixed_link'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in
function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw_new.c:768: undefined reference to `of_phy_connect'
make[2]: *** [scripts/Makefile.vmlinux:35: vmlinux] Error 1


Details:
-------
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230419/testrun/16368708/suite/build/test/gcc-12-omap2plus_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230419/testrun/16368708/suite/build/test/gcc-12-omap2plus_defconfig/details/

Steps to reproduce:
---------
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.

tuxmake --runtime podman --target-arch arm --toolchain gcc-12
--kconfig omap2plus_defconfig


--
Linaro LKFT
https://lkft.linaro.org
