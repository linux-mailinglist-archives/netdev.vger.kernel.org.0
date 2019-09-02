Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B010A53EC
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbfIBKXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:23:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42690 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbfIBKXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:23:21 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D5BBD1A0135;
        Mon,  2 Sep 2019 12:23:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CA3C61A0022;
        Mon,  2 Sep 2019 12:23:19 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 87D63205EC;
        Mon,  2 Sep 2019 12:23:19 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 0/3]  dpaa2-eth: Add new statistics counters
Date:   Mon,  2 Sep 2019 13:23:16 +0300
Message-Id: <1567419799-28179-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent firmware versions offer access to more DPNI statistics
counters. Add the relevant ones to ethtool interface stats.

Also we can now make use of a new counter for in flight egress frames
to avoid sleeping an arbitrary amount of time in the ndo_stop routine.

v2: in patch 2/3, treat separately the error case for unsupported
statistics pages

Ioana Radulescu (3):
  dpaa2-eth: Minor refactoring in ethtool stats
  dpaa2-eth: Add new DPNI statistics counters
  dpaa2-eth: Poll Tx pending frames counter on if down

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 31 +++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 37 +++++++++++++-------
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h        | 40 ++++++++++++++++++++++
 4 files changed, 93 insertions(+), 17 deletions(-)

-- 
2.7.4

