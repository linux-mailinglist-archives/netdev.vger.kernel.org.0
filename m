Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CBB1368F8
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgAJI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:29:26 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41735 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgAJI30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:29:26 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so1219006ljc.8
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xf/yJPuQVmyfW77FZwZ/ArcoBvlEix+TheYnmgPC3/Y=;
        b=YpIkmN7ebpn5RbbHFS6F8dxelm2gH+XRDpqF9AheWhecn7HVY1dkePAW4WA0jbCtem
         G0Tu1S50a1phM5nkVA0rM0jlHvTjQYyCsicTfvkjpwl+MRJk5Ams+DGswE5NPXv5aaEe
         ck3qt/gqYeeYyXX4W8WniU3AMqT9RhSRCdnMRLUt++aofvyq2xWKkpi56kY5vtGJGISQ
         fZoQ4SUCpcN0egT887VBGkoEKTBIEVjSehQ0aM7JbmI4q66rTzCSUbCOaYtjjAmyuSle
         6B63v07jToVSGblJLcymwMQN1PnEs5LYRwnxbiEqx97+m0muOEa8wFiMn6CAwsXv5ajg
         IvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xf/yJPuQVmyfW77FZwZ/ArcoBvlEix+TheYnmgPC3/Y=;
        b=bTFVIg4rhYO/1NUNfa0wJmoWCgKy3GJM2cfbZY8EM4UyDEWN9ctdtGHBJpERBgGsDy
         XJlAyWA7hvDqu01uyUWoRX8EzzHjCm2exkYAdKJaSH2imqaY93IB2lmxGlKPOvcFflIL
         cFYIaMyTO7wUehYhkopujgGa2wAtLyaniMgPVvAjTLjeiUJYQWnYCMxQ2oQwHV8jWsJH
         F9iav8wjraxYB4yK3TI5fqazhGA8DGSZDcMILo+XOS90HSHsKP8UXOgM0MEHd/XdLPSl
         8Hva066hYuOo2rthXO1AwsKIpxYk9WndzHDbsCf9W/WkJVbc0FA59ZWREYr/m/7RzhAR
         gSOw==
X-Gm-Message-State: APjAAAWOH0iGh/eVdsovTDsaEsC0WjncJ2f9YG/740OewssGwRCR3p2j
        XbiZAMxpzAEzY/I5EjaH2qs0gC9bG7KplA==
X-Google-Smtp-Source: APXvYqzLFKFDI4f3PyQmoHlPWE7qmvyP35WVoKxW4ps8L594YQc/q0Is9hbcc7bZpoug8kQULQ/WGA==
X-Received: by 2002:a2e:b017:: with SMTP id y23mr1825712ljk.229.1578644964030;
        Fri, 10 Jan 2020 00:29:24 -0800 (PST)
Received: from linux.local (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id g24sm606464lfb.85.2020.01.10.00.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:29:23 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/9 v4] IXP4xx networking cleanups
Date:   Fri, 10 Jan 2020 09:28:28 +0100
Message-Id: <20200110082837.11473-1-linus.walleij@linaro.org>
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

I had to depromote enabling compiler coverage at one
point in the v2 set because it depended on other patches
making the code more generic.

The change in v3 was simply dropping one offending
patch hardcoding base addresses into the driver.

The change in v4 drops a stable@ tag that was
unnecessary.

Arnd Bergmann (4):
  wan: ixp4xx_hss: fix compile-testing on 64-bit
  wan: ixp4xx_hss: prepare compile testing
  ptp: ixp46x: move adjacent to ethernet driver
  ixp4xx_eth: move platform_data definition

Linus Walleij (5):
  net: ethernet: ixp4xx: Standard module init
  net: ethernet: ixp4xx: Use distinct local variable
  net: ehernet: ixp4xx: Use netdev_* messages
  ARM/net: ixp4xx: Pass ethernet physical base as resource
  net: ethernet: ixp4xx: Use parent dev for DMA pool

 arch/arm/mach-ixp4xx/fsg-setup.c              |  20 ++
 arch/arm/mach-ixp4xx/goramo_mlr.c             |  24 ++
 arch/arm/mach-ixp4xx/include/mach/platform.h  |  22 +-
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |  20 ++
 arch/arm/mach-ixp4xx/nas100d-setup.c          |  10 +
 arch/arm/mach-ixp4xx/nslu2-setup.c            |  10 +
 arch/arm/mach-ixp4xx/omixp-setup.c            |  20 ++
 arch/arm/mach-ixp4xx/vulcan-setup.c           |  20 ++
 drivers/net/ethernet/xscale/Kconfig           |  14 ++
 drivers/net/ethernet/xscale/Makefile          |   3 +-
 .../net/ethernet/xscale}/ixp46x_ts.h          |   0
 drivers/net/ethernet/xscale/ixp4xx_eth.c      | 213 +++++++++---------
 .../{ptp => net/ethernet/xscale}/ptp_ixp46x.c |   3 +-
 drivers/net/wan/Kconfig                       |   3 +-
 drivers/net/wan/ixp4xx_hss.c                  |  39 ++--
 drivers/ptp/Kconfig                           |  14 --
 drivers/ptp/Makefile                          |   1 -
 include/linux/platform_data/eth_ixp4xx.h      |  19 ++
 include/linux/platform_data/wan_ixp4xx_hss.h  |  17 ++
 19 files changed, 306 insertions(+), 166 deletions(-)
 rename {arch/arm/mach-ixp4xx/include/mach => drivers/net/ethernet/xscale}/ixp46x_ts.h (100%)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

-- 
2.21.0

