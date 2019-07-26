Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CF576F02
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfGZQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:26:28 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53011 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfGZQ02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:26:28 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45wDwx4gTPz1rJhH;
        Fri, 26 Jul 2019 18:26:25 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45wDwx13yDz1qqkH;
        Fri, 26 Jul 2019 18:26:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id g8dsEv3k8BOC; Fri, 26 Jul 2019 18:26:23 +0200 (CEST)
X-Auth-Info: +hA/8H37NjRA8sKf9+1YSPyXTj95atRgL/RMR6BLUOQ=
Received: from kurokawa.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 26 Jul 2019 18:26:23 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH V3 0/3] net: dsa: ksz: Add Microchip KSZ87xx support
Date:   Fri, 26 Jul 2019 18:23:05 +0200
Message-Id: <20190726162308.16764-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for Microchip KSZ87xx switches, which are
slightly simpler compared to KSZ9xxx .

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>

Marek Vasut (1):
  dt-bindings: net: dsa: ksz: document Microchip KSZ87xx family switches

Tristram Ha (2):
  net: dsa: ksz: Add KSZ8795 tag code
  net: dsa: ksz: Add Microchip KSZ8795 DSA driver

 .../devicetree/bindings/net/dsa/ksz.txt       |    3 +
 drivers/net/dsa/microchip/Kconfig             |   18 +
 drivers/net/dsa/microchip/Makefile            |    2 +
 drivers/net/dsa/microchip/ksz8795.c           | 1311 +++++++++++++++++
 drivers/net/dsa/microchip/ksz8795_reg.h       | 1004 +++++++++++++
 drivers/net/dsa/microchip/ksz8795_spi.c       |  104 ++
 drivers/net/dsa/microchip/ksz_common.c        |    3 +-
 drivers/net/dsa/microchip/ksz_common.h        |   28 +
 drivers/net/dsa/microchip/ksz_priv.h          |    1 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    7 +
 net/dsa/tag_ksz.c                             |   62 +
 12 files changed, 2544 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8795.c
 create mode 100644 drivers/net/dsa/microchip/ksz8795_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8795_spi.c

-- 
2.20.1

