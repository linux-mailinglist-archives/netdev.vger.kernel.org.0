Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B1113861D
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbgALME6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:04:58 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36482 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgALME6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:04:58 -0500
Received: by mail-lf1-f66.google.com with SMTP id n12so4831976lfe.3
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2MVhT9CoFfKWNrsL6FPFLZGPfRIgjwWLVXDfnLxqnU=;
        b=xyrppyNL+9mToJ8hZQYnJgNI3YbmaOFwvADOVOgJsSfAUWcRWZ/MTHNO+wF2ihWb2w
         Q7bjs02GDMO4T/7QuJ3qfKtnAzm1qRtGJ8ds98snhcMrIo2N5X9OOtvqoDTkSsvgvqNa
         holZSOj9H/D1ddo5Tw+UsS5lgAUDQEK0DO256ngYxBfCDw0KJQvo1yCuviKP46zT4dQM
         2tUUm5PBjh2Un9fE0GmcAbFtuRFv43a9WNVyN/riv0jqvfb6a+apavqtJB7oQ61DN2TY
         A52kGm3si2Yryopi+dKzUqc/8/JzzhYTHWlm0fPbsOvUhVcXSNSq2XQ9fw+kRfxWYXrv
         CB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v2MVhT9CoFfKWNrsL6FPFLZGPfRIgjwWLVXDfnLxqnU=;
        b=bmTDN6bvugcOb8TEpy4rcCxpmWauTxkkGepyfpG0vRtSWG1Ku1CpXYIq/RdEx4CybF
         tF0IhnFe2M1ZTdjPTKIRs7XTeCzVJ8OSl7soKkDj6AREvtELw8V67RpQkVMVpLJD0ubp
         cM/+M+CdyOYZoA9Q4+M7Rn4PthbtyKpj8+AdswgJBz/nchTrByhAjbRN8ac+3qiZ9LE8
         4JwdTy1CkkK9MhzIjawNTTxpBHddYS9P3ydD+lb5u7/J9qYYY3KHSYUqDro8HJB/WJEg
         oLWOY8Evl3q+VvyFQPv8Qxa5Uziv2MXKk4widhZI/meay7Wtgsb5HMmyp/ePUgE9qLSB
         P+RQ==
X-Gm-Message-State: APjAAAU9zjNf2GpkLOQVd99S77t0FxO/LeF1LRFrOzzdQzmg5ntkt8WL
        c79+M3TuJoHoqXex8y7s18YMpj8kUhDpTA==
X-Google-Smtp-Source: APXvYqwWlQpwi+7wFvU59X18zaCqu3UWGd/ct5Tkzx5493mHdCGMMig3QbPpbpLpULWyZ3oLO/GfBA==
X-Received: by 2002:a19:c1c1:: with SMTP id r184mr7495784lff.128.1578830695963;
        Sun, 12 Jan 2020 04:04:55 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:04:55 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/9 v5] IXP4xx networking cleanups
Date:   Sun, 12 Jan 2020 13:04:41 +0100
Message-Id: <20200112120450.11874-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This v5 is a rebase of the v4 patch set on top of
net-next.

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
 drivers/ptp/Makefile                          |   3 +-
 include/linux/platform_data/eth_ixp4xx.h      |  19 ++
 include/linux/platform_data/wan_ixp4xx_hss.h  |  17 ++
 19 files changed, 307 insertions(+), 167 deletions(-)
 rename {arch/arm/mach-ixp4xx/include/mach => drivers/net/ethernet/xscale}/ixp46x_ts.h (100%)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

-- 
2.21.0

