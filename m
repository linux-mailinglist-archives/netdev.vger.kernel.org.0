Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1944374D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhKBUbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhKBUbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 16:31:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F1AC061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 13:29:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d13so320323wrf.11
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5Aee3QY56qsT6Ag2CZhmDgBwHNcYBeZeM/3ytaWScg=;
        b=nCqHIpeRatbKf6wCv9Hu0E/IxUM2anHemn7v5wpcN7Ib1oJf/p6Kyg1NUFNqeu4KBk
         kmjt99V7NUYKv5OTmbeY4P8rbwC2Bc6UcIwS949Pwko2tCqvoW7MtESFwPFVVeC4YXnF
         9sJSjetqT4cYuTnDG38hNQlWlS1rtuH7wVxBHJbdredHuaFnGzzDXtFSBdi+aaUPXljE
         LZTRYEWXccCGnuPVR2XHHc8zkILSFFjbnybnaUvA3SYwyjdTrvR8Y29t1OiOg21zBxnZ
         3Oa8iK+HhfhDrszu7NlqlJqPIQbbU+Vv/YgFkXCyNAvmsrhspXZTt+1T4oPYtBAQOt6k
         dEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5Aee3QY56qsT6Ag2CZhmDgBwHNcYBeZeM/3ytaWScg=;
        b=70MdIZp7nff29nDTuo41gHf2v+jwDcXWJKm9+boXbequHQky9ono6nz9dMD+Erlb7A
         a8kWwPnHvS30jSsGTxdhzZWg72LjH71+quiN7QEAFHH9EGXEblnUK4ML17bBVBcCqZVW
         n3BBQYZl5NoyO/zlrNRJ3S5wsc3WlEPEFnUMG5qNjBHN+/SroNJJrT8dG/xTHNalGaNc
         /uDCCpuQbta9ybHwnAv0jEy6QAwyXgzqnSukvKbwp226XPKCJUp8tUXNafneUp+WcBAD
         qVQ8HMBTHrfpESnv+EtfquDawTn2ZyexAGUGwHIZpajJrpIbNA3u2XjKSc6eqyyA8l1Q
         IyLQ==
X-Gm-Message-State: AOAM532mJbgb14dRWwfbHCqR0wdyrs2T9RzdkforReWE5qWpi8XOqqde
        Jl69VlFaOG6axTXzSMERwGekzxaNb2U55Dt6
X-Google-Smtp-Source: ABdhPJwATkNn/PECCoDyB/72gVFAhDZa5o/ZEQRnWdznZkux6XND7zr8LoueMJY2u5Nryv/j9bTmiA==
X-Received: by 2002:a05:6000:1449:: with SMTP id v9mr50988125wrx.137.1635884942126;
        Tue, 02 Nov 2021 13:29:02 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id 6sm31914wma.48.2021.11.02.13.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 13:29:01 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 0/3] TSN endpoint Ethernet MAC driver
Date:   Tue,  2 Nov 2021 21:28:44 +0100
Message-Id: <20211102202847.6380-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a driver for my FPGA based TSN endpoint Ethernet MAC.
It also includes the device tree binding.

The device is designed as Ethernet MAC for TSN networks. It will be used
in PLCs with real-time requirements up to isochronous communication with
protocols like OPC UA Pub/Sub.

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

