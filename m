Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5563F2306E0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgG1Js3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:48:29 -0400
Received: from inva020.nxp.com ([92.121.34.13]:59422 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgG1Js3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:48:29 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E92CC1A00C7;
        Tue, 28 Jul 2020 11:48:27 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DDABF1A0054;
        Tue, 28 Jul 2020 11:48:27 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A7DAA20328;
        Tue, 28 Jul 2020 11:48:27 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs stats
Date:   Tue, 28 Jul 2020 12:48:10 +0300
Message-Id: <20200728094812.29002-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds debugfs controls for clearing the software and
hardware kept counters.  This is especially useful in the context of
debugging when there is a need for statistics per a run of the test.

Ioana Ciornei (2):
  dpaa2-eth: add API for stats clear
  dpaa2-eth: add reset control for debugfs statistics

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 64 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  1 +
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 23 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  4 ++
 4 files changed, 92 insertions(+)

-- 
2.25.1

