Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F358C3CA5E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404048AbfFKLuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:50:06 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41348 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403784AbfFKLuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 07:50:05 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 11357200A11;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 05619200A0F;
        Tue, 11 Jun 2019 13:50:04 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B5FEF20600;
        Tue, 11 Jun 2019 13:50:03 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v3 0/3] dpaa2-eth: Add support for MQPRIO offloading
Date:   Tue, 11 Jun 2019 14:50:00 +0300
Message-Id: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for adding multiple TX traffic classes with mqprio. We can have
up to one netdev queue and hardware frame queue per TC per core.

Ioana Radulescu (3):
  dpaa2-eth: Refactor xps code
  dpaa2-eth: Support multiple traffic classes on Tx
  dpaa2-eth: Add mqprio support

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 129 ++++++++++++++++++-----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |   9 +-
 2 files changed, 112 insertions(+), 26 deletions(-)

-- 
2.7.4

