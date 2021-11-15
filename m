Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F75D45164A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346670AbhKOVSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243801AbhKOU4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:56:44 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5A8C043199
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:17 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so751419wmd.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jnv8npXCv54N1DuEN+HFku6Ylz9+k6G6ihrJJWo+LcA=;
        b=tf63usdoGDd+SNg4hQPl5UeU1HJhBTI0k66aENThSKM8j+khkfkCqVqkfYenRBMVOT
         d40Em5bPl88hAHZoJ9UFBlqgo/cuK6rr4avcGqPCNJEXqVnxFl8EhGkQcR9MZC349C0/
         gNq2SkHQpOiCzCM4cm5WM27DXo8Tro8HjSd+sdWwB5RG93vD1wB2q1CKdGSHTon6df8V
         Rfm/P1gc/fL65gtTdDjCMFC2A9JUqmBIDMvkjdio3bBHda9w7YqQ4bg9GyAKQtdjUGWp
         aT1drm8BB5PMFE8OaRa8Dw/Ogy5tK7UUY6Psemaarcl1LpfFQmKDBXnSmEQmw559wQn1
         xsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jnv8npXCv54N1DuEN+HFku6Ylz9+k6G6ihrJJWo+LcA=;
        b=UFlE1RoCO1X19EPKBwl8+Ej2CZdszSKB535djBDWoZXC3dblCdKWw5BucSllLYrjwK
         a4A8jXJGsESCTO5Qa5oknkmKxAySXItrIQg+xhIbj7FXEeX9wa/OkFJsskzV4DocMKtE
         aIKdEkVMkvYILpbvBBMxl7I2QQL6EZRbQ8v0OaX5eK6UfquYIvh30LCSOtpgCikw2/tP
         8pKgQnDKSP1UdGfJNiFGGy0nZtuoXBUzEwmSO+WdsCRScC+P0skkp8e5b2fTa+QmsXTg
         KNM+7NMAxjQT7pd/2vAA5NhIaeqrwmeHbX9sHeWXLlLVRCgSrvr+OSL0abyxq9Qy31qj
         YqXg==
X-Gm-Message-State: AOAM5337xrVusgfurdyVjFH5lauLh6sK2epHuvgW1UHCpjdHYpGnau2q
        aNKyUIxvfqs8hsLE6ybIkYYhrw==
X-Google-Smtp-Source: ABdhPJxIa/svCwFSuNiQM/6EEwnSuyztpcpLILOuSu2pRKUudNlMdm9xumt+GyHL5xXplhBpTNjghA==
X-Received: by 2002:a1c:287:: with SMTP id 129mr49345846wmc.49.1637009416566;
        Mon, 15 Nov 2021 12:50:16 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z6sm15763704wrm.93.2021.11.15.12.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:50:16 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 0/3] TSN endpoint Ethernet MAC driver
Date:   Mon, 15 Nov 2021 21:50:02 +0100
Message-Id: <20211115205005.6132-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5:
 - rebase net-next/master

v4:
 - fix sparse __iomem warnings (Jakub Kicinski, Andrew Lunn)
 - fix sparse endian warnings (Jakub Kicinski, Andrew Lunn)

v3:
 - set MAC mode based on PHY information (Andrew Lunn)
 - remove/postpone loopback mode interface (Andrew Lunn)
 - add suppress_preamble node support (Andrew Lunn)
 - add mdio timeout (Andrew Lunn)
 - no need to call phy_start_aneg (Andrew Lunn)
 - remove unreachable code (Andrew Lunn)
 - move 'struct napi_struct' closer to queues (Vinicius Costa Gomes)
 - remove unused variable (kernel test robot)
 - switch from mdio interrupt to polling
 - mdio register without PHY address flag
 - thread safe interrupt enable register
 - add PTP_1588_CLOCK_OPTIONAL dependency to Kconfig
 - introduce dmadev for DMA allocation
 - mdiobus for platforms without device tree
 - prepare MAC address support for platforms without device tree
 - add missing interrupt disable to probe error path

v2:
 - add C45 check (Andrew Lunn)
 - forward phy_connect_direct() return value (Andrew Lunn)
 - use phy_remove_link_mode() (Andrew Lunn)
 - do not touch PHY directly, use PHY subsystem (Andrew Lunn)
 - remove management data lock (Andrew Lunn)
 - use phy_loopback (Andrew Lunn)
 - remove GMII2RGMII handling, use xgmiitorgmii (Andrew Lunn)
 - remove char device for direct TX/RX queue access (Andrew Lunn)
 - mdio node for mdiobus (Rob Herring)
 - simplify compatible node (Rob Herring)
 - limit number of items of reg and interrupts nodes (Rob Herring)
 - restrict phy-connection-type node (Rob Herring)
 - reference to mdio.yaml under mdio node (Rob Herring)
 - remove device tree (Michal Simek)
 - fix %llx warning (kernel test robot)
 - fix unused tmp variable warning (kernel test robot)
 - add missing of_node_put() for of_parse_phandle()
 - use devm_mdiobus_alloc()
 - simplify mdiobus read/write
 - reduce required nodes
 - ethtool priv flags interface for loopback
 - add missing static for some functions
 - remove obsolete hardware defines

Gerhard Engleder (3):
  dt-bindings: Add vendor prefix for Engleder
  dt-bindings: net: Add tsnep Ethernet controller
  tsnep: Add TSN endpoint Ethernet MAC driver

 .../bindings/net/engleder,tsnep.yaml          |   79 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/engleder/Kconfig         |   29 +
 drivers/net/ethernet/engleder/Makefile        |    9 +
 drivers/net/ethernet/engleder/tsnep.h         |  171 +++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  288 ++++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  230 +++
 drivers/net/ethernet/engleder/tsnep_main.c    | 1255 +++++++++++++++++
 drivers/net/ethernet/engleder/tsnep_ptp.c     |  221 +++
 drivers/net/ethernet/engleder/tsnep_tc.c      |  443 ++++++
 drivers/net/ethernet/engleder/tsnep_test.c    |  811 +++++++++++
 13 files changed, 3540 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_test.c

-- 
2.20.1

