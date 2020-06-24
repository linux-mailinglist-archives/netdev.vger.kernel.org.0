Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8128120722B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390608AbgFXLex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:34:53 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48476 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388919AbgFXLew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 07:34:52 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 102B81A0217;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 046931A020F;
        Wed, 24 Jun 2020 13:34:51 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C24BE2047A;
        Wed, 24 Jun 2020 13:34:50 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/5] dpaa2-eth: small updates
Date:   Wed, 24 Jun 2020 14:34:16 +0300
Message-Id: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds some updates to the dpaa2-eth driver: trimming of
the frame queue debugfs counters, cleanup of the remaining sparse
warnings and some other small fixes such as a recursive header include.

Ioana Ciornei (4):
  dpaa2-eth: check the result of skb_to_sgvec()
  dpaa2-eth: fix condition for number of buffer acquire retries
  dpaa2-eth: fix recursive header include
  dpaa2-eth: fix misspelled function parameters in
    dpni_[set/get]_taildrop

Ioana Radulescu (1):
  dpaa2-eth: trim debugfs FQ stats

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 4 ++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h   | 1 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c         | 6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.c              | 8 ++++----
 4 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.25.1

