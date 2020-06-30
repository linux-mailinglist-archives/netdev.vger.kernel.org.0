Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE37C20F607
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388284AbgF3Npl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:45:41 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:12907 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgF3Npk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593524740; x=1625060740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DT8RPyRP9mmuQ6a31TkFhh6MXoc72CoyHoSonfX6oCE=;
  b=xrZ0sg8i0PhCsg11vxAhZLUQE9CdRAp8Yt/9/fM+tvQ4ob32GhzdefqY
   amfZK9Xi22mS4OpcyVoBl9dcvfcbuP8qlosrItIg/8mXdUZZZqb1iSF3U
   4zGUoLv3eGixV4p3bvdYdGiuLRnmW6PGsMIxzPWrkbYkvNc89IGGibYSS
   EY1gDtZoOLT1bHBaVoBGD4Swg3ZzDXmpYW6hKAA+k/F0nJNjnlyYi8zY0
   Cqh8T+CHRtl+xgcGw/foLKHRQolGfJPOJzW0HmfkyW7NkrisIoPTA6f1d
   Iss23yQMNuJsTVaZYIngOL4EfuDnfh5lam8GQXarztX+MqEo5gMOAhPmQ
   Q==;
IronPort-SDR: k278jIGgNuSItG6ZZMWkoL5B3lvaDH1hn94M2bDyspiat0WYQmNDp7nlHxWw1NM47bGAm3nnHu
 q1rwsu8vqYenlV82/jNO6Dot6H+SdojwUHLup6McjCW48AlXmenFAOcnbUGM2yuQCR24REEuWR
 HLoJ+KIdTZIx7KTBPCsk9443DHn2aajPxyx7mWleGMu+6L/5ln7BqVqKAp8LBFTLqqqkrGDF7F
 uh3X2vyb+FyB25xMi61T/+3YVxZBZwO2qONRXZj1+PFBmYYoriIqVod/7q1ZSIDaSuCrmjNr7/
 jxc=
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="78274295"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2020 06:45:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 06:45:21 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 30 Jun 2020 06:45:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/3] bridge: mrp: Add support for getting the status
Date:   Tue, 30 Jun 2020 15:44:21 +0200
Message-ID: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends the MRP netlink interface to allow the userspace
daemon to get the status of the MRP instances in the kernel.

Horatiu Vultur (3):
  bridge: uapi: mrp: Extend MRP attributes to get the status
  bridge: mrp: Add br_mrp_fill_info
  bridge: Extend br_fill_ifinfo to return MPR status

 include/uapi/linux/if_bridge.h | 17 ++++++++++
 include/uapi/linux/rtnetlink.h |  1 +
 net/bridge/br_mrp_netlink.c    | 57 ++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        | 29 ++++++++++++++++-
 net/bridge/br_private.h        |  7 +++++
 5 files changed, 110 insertions(+), 1 deletion(-)

-- 
2.27.0

