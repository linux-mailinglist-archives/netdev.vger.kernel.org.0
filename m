Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCE3CB742
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfJDJV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:21:58 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47310 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDJV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 05:21:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 056721A03B6;
        Fri,  4 Oct 2019 11:21:56 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EC4491A018B;
        Fri,  4 Oct 2019 11:21:55 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B4B27205EF;
        Fri,  4 Oct 2019 11:21:55 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 0/3] dpaa2-eth: misc cleanup
Date:   Fri,  4 Oct 2019 12:21:30 +0300
Message-Id: <1570180893-9538-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set consists of some cleanup patches ranging from removing dead
code to fixing a minor issue in ethtool stats. Also, unbounded while loops
are removed from the driver by adding a maximum number of retries for DPIO
portal commands.

Ioana Radulescu (3):
  dpaa2-eth: Cleanup dead code
  dpaa2-eth: Fix minor bug in ethtool stats reporting
  dpaa2-eth: Avoid unbounded while loops

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 37 +++++++++++++++-------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  8 +++++
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  2 +-
 3 files changed, 34 insertions(+), 13 deletions(-)

-- 
1.9.1

