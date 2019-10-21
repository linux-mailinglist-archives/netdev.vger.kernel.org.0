Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB34DDE15E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfJUAIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:08:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41812 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:08:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so11343534ljg.8
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ig3ZNykuinul+2zeSyraVG12jmxt3iv0bplNEVzpPMM=;
        b=VRlq5aJCTnSEqJGmfutt5MjdShiUB3SA4yQ9iVPBV/7hYo454fRI9PRtRyYHab1zS4
         paLlO4CewaooGulLfVvrSaNDczieAcmTkcw3pnC15zWXiQSSQcQEZI3z3VnUCyfg/6YR
         8tJsNXUTEyIeNHu5iRG4S/Ic/t7YCpyQrU5SUqntfaQZjCcAQSrp4eIlUzQPl+jbXFhn
         mg7zvAEB742Sf2vdHZnik54AAiEJ87VPmUbgAac5nCAt/00tnFG5SeC7EH9tAYtoUoQB
         PVI6ctS3uXj2T1LK8t7XIxFFQVwIVpzPRSyJFgiCBKyqPVXG3W40SHCoL++/4lV70Yjb
         K4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ig3ZNykuinul+2zeSyraVG12jmxt3iv0bplNEVzpPMM=;
        b=e4IWGE5eruTNpN2l/XIDSGTxXdx/vZF/EUJRc61uD9ON5izMIDb5pR29yvKv/lhCBV
         qIT9RJ1N3f5rCIexCuM9Ews4OITurmZ+wPyCAWoBirhvnDZUPjMXscs8fKMx1SIL9xZN
         V0vN2wBaGvEcNfOQv+RWHaT5aTadswyaQ4iIhdyAqlt2U0yw082+1vd+pADu3z6Tyti0
         Z+owOTNTcEti0yO3AlwTdvcHfYFHHXdhggkaGC5XnkZ8c/R5iotHV+WIdFNSQESC/9Po
         TANI35j9OiEG/0UE3/rTgc6e/sNjXmsGi1mKp/Ue03OLORs3zGFUy16yE+ClOANGPXR+
         a2pA==
X-Gm-Message-State: APjAAAXXsAcbLd+ioAVqC3A55Iu4VnxkLJMUfAkdg0TS/uSWdEIcVzFT
        ta66vMINmJql7hlyO5zguAmVYEQMDtw=
X-Google-Smtp-Source: APXvYqwp2uXNWZ486uw8n8rCkU/CjuzPSvZR9FKSPAZk0gI5jDUGvnJBrPTZdhlsc3yUWJu9IpiRGw==
X-Received: by 2002:a2e:9759:: with SMTP id f25mr13140292ljj.173.1571616532566;
        Sun, 20 Oct 2019 17:08:52 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:08:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 00/10] IXP4xx networking cleanups
Date:   Mon, 21 Oct 2019 02:08:14 +0200
Message-Id: <20191021000824.531-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series which jams together Arnds and mine
cleanups for the IXP4xx networking.

I also have patches for device tree support but that
requires more elaborate work, this series is some of
mine and some of Arnds patches that is a good foundation
for his multiplatform work and my device tree work.

These are for application to the networking tree so
that can be taken in one separate sweep.

I have tested the patches for a bit using zeroday builds
and some boots on misc IXP4xx devices and haven't run
into any major problems. We might find some new stuff
as a result from the new compiler coverage.

The patch set also hits in the ARM tree but Arnd is
a ARM SoC maintainer and is hereby informed :)

Arnd Bergmann (4):
  wan: ixp4xx_hss: fix compile-testing on 64-bit
  wan: ixp4xx_hss: enable compile testing
  ptp: ixp46x: move next to ethernet driver
  ixp4xx_eth: move platform_data definition

Linus Walleij (6):
  net: ethernet: ixp4xx: Standard module init
  net: ethernet: ixp4xx: Use distinct local variable
  net: ehernet: ixp4xx: Use devm_alloc_etherdev()
  ARM/net: ixp4xx: Pass ethernet physical base as resource
  net: ethernet: ixp4xx: Get port ID from base address
  net: ethernet: ixp4xx: Use parent dev for DMA pool

 arch/arm/mach-ixp4xx/fsg-setup.c              |  20 ++
 arch/arm/mach-ixp4xx/goramo_mlr.c             |  24 +++
 arch/arm/mach-ixp4xx/include/mach/platform.h  |  22 +--
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |  20 ++
 arch/arm/mach-ixp4xx/nas100d-setup.c          |  10 +
 arch/arm/mach-ixp4xx/nslu2-setup.c            |  10 +
 arch/arm/mach-ixp4xx/omixp-setup.c            |  20 ++
 arch/arm/mach-ixp4xx/vulcan-setup.c           |  20 ++
 drivers/net/ethernet/xscale/Kconfig           |  14 ++
 drivers/net/ethernet/xscale/Makefile          |   3 +-
 .../net/ethernet/xscale}/ixp46x_ts.h          |   0
 drivers/net/ethernet/xscale/ixp4xx_eth.c      | 177 +++++++++---------
 .../{ptp => net/ethernet/xscale}/ptp_ixp46x.c |   3 +-
 drivers/net/wan/Kconfig                       |   3 +-
 drivers/net/wan/ixp4xx_hss.c                  |  39 ++--
 drivers/ptp/Kconfig                           |  14 --
 drivers/ptp/Makefile                          |   1 -
 include/linux/platform_data/eth_ixp4xx.h      |  19 ++
 include/linux/platform_data/wan_ixp4xx_hss.h  |  17 ++
 19 files changed, 292 insertions(+), 144 deletions(-)
 rename {arch/arm/mach-ixp4xx/include/mach => drivers/net/ethernet/xscale}/ixp46x_ts.h (100%)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

-- 
2.21.0

