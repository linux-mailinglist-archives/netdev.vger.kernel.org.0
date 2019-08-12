Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118CD89BCE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfHLKpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:45:49 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58582 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfHLKpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:45:49 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9AC381A011B;
        Mon, 12 Aug 2019 12:45:47 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id ED4EC1A0038;
        Mon, 12 Aug 2019 12:45:44 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 47260402EC;
        Mon, 12 Aug 2019 18:45:41 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 0/3] ocelot_ace: fix and improve the driver
Date:   Mon, 12 Aug 2019 18:48:24 +0800
Message-Id: <20190812104827.5935-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set is to fix some issues and improve the ocelot_ace driver
for using.

Yangbo Lu (3):
  ocelot_ace: drop member port from ocelot_ace_rule structure
  ocelot_ace: fix ingress ports setting for rule
  ocelot_ace: fix action of trap

 drivers/net/ethernet/mscc/ocelot_ace.c    | 20 ++++++++++----------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c |  8 ++++----
 3 files changed, 16 insertions(+), 16 deletions(-)

-- 
2.7.4

