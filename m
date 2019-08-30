Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96065A34D7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfH3KUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:20:46 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59040 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfH3KUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 06:20:46 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3712E1A02D4;
        Fri, 30 Aug 2019 12:20:44 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B3BD1A0198;
        Fri, 30 Aug 2019 12:20:44 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DEF11205C7;
        Fri, 30 Aug 2019 12:20:43 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next 0/3] dpaa2-eth: Add new statistics counters
Date:   Fri, 30 Aug 2019 13:20:40 +0300
Message-Id: <1567160443-31297-1-git-send-email-ruxandra.radulescu@nxp.com>
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

Ioana Radulescu (3):
  dpaa2-eth: Minor refactoring in ethtool stats
  dpaa2-eth: Add new DPNI statistics counters
  dpaa2-eth: Poll Tx pending frames counter on if down

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 31 +++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 39 +++++++++++++--------
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h        | 40 ++++++++++++++++++++++
 4 files changed, 94 insertions(+), 18 deletions(-)

-- 
2.7.4

