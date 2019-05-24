Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453B029AC4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389831AbfEXPPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:15:20 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43718 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389314AbfEXPPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 11:15:19 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4169C20048D;
        Fri, 24 May 2019 17:15:18 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 34E3B20009E;
        Fri, 24 May 2019 17:15:18 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CF819205EF;
        Fri, 24 May 2019 17:15:17 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net 0/3] dpaa2-eth: Fix smatch warnings
Date:   Fri, 24 May 2019 18:15:14 +0300
Message-Id: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a couple of warnings reported by smatch.

Ioana Radulescu (3):
  dpaa2-eth: Fix potential spectre issue
  dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate
  dpaa2-eth: Make constant 64-bit long

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     | 4 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.7.4

