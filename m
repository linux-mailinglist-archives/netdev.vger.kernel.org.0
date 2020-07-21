Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E762285E5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgGUQig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:38:36 -0400
Received: from inva021.nxp.com ([92.121.34.21]:38952 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730373AbgGUQid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:38:33 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1C2B0201634;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 03E9020162D;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BF638202A9;
        Tue, 21 Jul 2020 18:38:31 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: add support for TBF offload
Date:   Tue, 21 Jul 2020 19:38:22 +0300
Message-Id: <20200721163825.9462-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for TBF offload in dpaa2-eth.
The first patch restructures how the .ndo_setup_tc() callback is
implemented (each Qdisc is treated in a separate function), the second
patch just adds the necessary APIs for configuring the Tx shaper and the
last one is handling TC_SETUP_QDISC_TBF and configures as requested the
shaper.

Ioana Ciornei (3):
  dpaa2-eth: move the mqprio setup into a separate function
  dpaa2-eth: add API for Tx shaping
  dpaa2-eth: add support for TBF offload

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 65 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  3 +
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   | 13 ++++
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 36 ++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   | 16 +++++
 5 files changed, 126 insertions(+), 7 deletions(-)

-- 
2.25.1

