Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5144DB18
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFTUYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34037 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfFTUYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so2309275pfc.1
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id;
        bh=+Tswyip86KzEvgXYLEuKg7xqXSR0Gt/6G5Gl4ekk9gc=;
        b=ZJPJ8o9YUyQIguxq3psw6YIMbuj7QpLrKTE1KRh2+GCpm2qUc0xdwxEbEUiK4BmrjQ
         sp7BuWMcfrcJzbNVX6nLW4cW6aQibAemaAsF+f7cTUb3m5WnDXTD+POocFRaCnkqWVjt
         CzEBAWjwi7skFRxJIA2vpmd4JUAaB7PoO6FrKXlgwF+0BEqPf7jjCEpFKEQNuR1s68Im
         I2u9FpfBmcNwcXElAZ6z1uzurJtVoxuXB1DBMGipn3jU65ONgoXV5l9cv2PBY8ZdcY7A
         VhJ1Eurs2xafzgzbiABJBtc3p2/EGKq6H5RBsV47wPTI76mJgdeLnn2HHhmATfM7ogjU
         hlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=+Tswyip86KzEvgXYLEuKg7xqXSR0Gt/6G5Gl4ekk9gc=;
        b=Z0E8liq6Qx/gUOl+UZgn78RVwjGypo5UnPCzepknsuE9tp3xfmu5DSCKgoKzse6Gd9
         YBbq5Hibw9zm5/yago+EenhT+h9TAaJqcn9ve2UroM3hgKxypcSIvYUSsuAb5q1eox+W
         H6C12JcFJOrA4XVkQV2OnO0bO/dhnW4uTrzfks3yYI+MkRdLHUG4AA5qjWOJTf6qSjYv
         CW4pwwGnH8vSI9TGQlW2Tau8efPxdt2wzZ0psBTgRkn0JaoIeteEqkEN8iCYYqyO8va5
         pMA2vCj3/OrxBLY+XFWJyGCZfHZxuRPvys4TVO1YjDbuC9T9a4T0LLLb7ozBnTpF7zlF
         rpdg==
X-Gm-Message-State: APjAAAWe2Da4qy48SEMXdTnTD1Eoowb8eNWWEge7QTBA944O1+XYOo7k
        AEkXqqICfnfsXEoXPA0tfz4UgQ==
X-Google-Smtp-Source: APXvYqznyNT9cwQoIH9dV66I3EZz973LlAO2mEAD85QYWvVNEMXAC7hCFMFqy/Wd7lHu0vXaomuJ3Q==
X-Received: by 2002:a63:2c43:: with SMTP id s64mr14387152pgs.50.1561062269395;
        Thu, 20 Jun 2019 13:24:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 00/18] Add ionic driver
Date:   Thu, 20 Jun 2019 13:24:06 -0700
Message-Id: <20190620202424.23215-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first version of a patch series that adds the ionic driver,
supporting the Pensando ethernet devices.

In this first patchset we implement basic network driver functionality.
Later patchsets will add more advanced features.


Shannon Nelson (18):
  ionic: Add basic framework for IONIC Network device driver
  ionic: Add hardware init and device commands
  ionic: Add port management commands
  ionic: Add basic lif support
  ionic: Add interrupts and doorbells
  ionic: Add basic adminq support
  ionic: Add adminq action
  ionic: Add notifyq support
  ionic: Add the basic NDO callbacks for netdev support
  ionic: Add management of rx filters
  ionic: Add Rx filter and rx_mode nod support
  ionic: Add async link status check and basic stats
  ionic: Add initial ethtool support
  ionic: Add Tx and Rx handling
  ionic: Add netdev-event handling
  ionic: Add driver stats
  ionic: Add RSS support
  ionic: Add coalesce and other features

 .../networking/device_drivers/index.rst       |    1 +
 .../device_drivers/pensando/ionic.rst         |   75 +
 MAINTAINERS                                   |    8 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/pensando/Kconfig         |   32 +
 drivers/net/ethernet/pensando/Makefile        |    6 +
 drivers/net/ethernet/pensando/ionic/Makefile  |    8 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |   74 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   16 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  295 ++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  499 ++++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   38 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  535 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  284 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  820 ++++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |    9 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 2553 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 2304 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  276 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  556 ++++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  133 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  139 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   34 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  325 +++
 .../net/ethernet/pensando/ionic/ionic_stats.h |   53 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  880 ++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   15 +
 28 files changed, 9970 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/pensando/ionic.rst
 create mode 100644 drivers/net/ethernet/pensando/Kconfig
 create mode 100644 drivers/net/ethernet/pensando/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_if.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_main.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_regs.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.h

-- 
2.17.1

