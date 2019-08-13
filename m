Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD68ACD7
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfHMCti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:49:38 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60968 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfHMCti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 22:49:38 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 98BB5200735;
        Tue, 13 Aug 2019 04:49:36 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 887B62000FA;
        Tue, 13 Aug 2019 04:49:33 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 60AC1402A2;
        Tue, 13 Aug 2019 10:49:29 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v2, 0/4] ocelot: support PTP Ethernet frames trapping
Date:   Tue, 13 Aug 2019 10:52:10 +0800
Message-Id: <20190813025214.18601-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to support PTP Ethernet frames trapping.
Before that, fix some issues and improve the ocelot_ace driver
for using.

---
Changes for v2:
	- Added PTP Ethernet frames trapping support patch.

Yangbo Lu (4):
  ocelot_ace: drop member port from ocelot_ace_rule structure
  ocelot_ace: fix ingress ports setting for rule
  ocelot_ace: fix action of trap
  ocelot: add VCAP IS2 rule to trap PTP Ethernet frames

 drivers/net/ethernet/mscc/ocelot.c        | 28 ++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_ace.c    | 20 ++++++++++----------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c |  8 ++++----
 4 files changed, 44 insertions(+), 16 deletions(-)

-- 
2.7.4

