Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFD517FDB9
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgCJN3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:29:49 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54808 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgCJMv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:27 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5EB131A050F;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 509101A0541;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0EFF62036B;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/4] Support extended BD rings at runtime,
Date:   Tue, 10 Mar 2020 14:51:20 +0200
Message-Id: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First two patches are just misc code cleanup.
The 3rd patch prepares the Rx BD processing code to be extended
to processing both normal and extended BDs.
The last one adds extended Rx BD support for timestamping
without the need of a static config. Finally, the config option
FSL_ENETC_HW_TIMESTAMPING can be dropped.
Care was taken not to impact non-timestamping usecases.


Claudiu Manoil (4):
  enetc: Drop redundant device node check
  enetc: Clean up of ehtool stats len
  enetc: Clean up Rx BD iteration
  enetc: Add dynamic allocation of extended Rx BD rings

 drivers/net/ethernet/freescale/enetc/Kconfig  | 10 ---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 70 +++++++++++--------
 drivers/net/ethernet/freescale/enetc/enetc.h  | 33 ++++++++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 22 +++---
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  9 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  5 --
 6 files changed, 88 insertions(+), 61 deletions(-)

-- 
2.17.1

