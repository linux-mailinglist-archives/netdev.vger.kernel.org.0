Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46296792A6
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfG2RxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:53:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44989 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbfG2RxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:53:17 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45y6jl3chcz1rfQK;
        Mon, 29 Jul 2019 19:53:12 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45y6jg6ZhTz1qqkK;
        Mon, 29 Jul 2019 19:53:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id kj7em6_naNMZ; Mon, 29 Jul 2019 19:53:10 +0200 (CEST)
X-Auth-Info: yuG3urWoBbtFn1rX9bXHBPsIB9hQg955XIJ3Cc2JBAc=
Received: from kurokawa.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 29 Jul 2019 19:53:10 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH V4 0/3] net: dsa: ksz: Add Microchip KSZ87xx support
Date:   Mon, 29 Jul 2019 19:49:44 +0200
Message-Id: <20190729174947.10103-1-marex@denx.de>
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
 drivers/net/dsa/microchip/Kconfig             |   17 +
 drivers/net/dsa/microchip/Makefile            |    2 +
 drivers/net/dsa/microchip/ksz8795.c           | 1311 +++++++++++++++++
 drivers/net/dsa/microchip/ksz8795_reg.h       | 1004 +++++++++++++
 drivers/net/dsa/microchip/ksz8795_spi.c       |  104 ++
 drivers/net/dsa/microchip/ksz_common.c        |    3 +-
 drivers/net/dsa/microchip/ksz_common.h        |   28 +
 drivers/net/dsa/microchip/ksz_priv.h          |    1 +
 include/net/dsa.h                             |    2 +
 net/dsa/tag_ksz.c                             |   62 +
 11 files changed, 2536 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8795.c
 create mode 100644 drivers/net/dsa/microchip/ksz8795_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8795_spi.c

-- 
2.20.1

