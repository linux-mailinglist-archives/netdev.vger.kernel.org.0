Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25304CE0A7
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfJGLik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:38:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58030 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfJGLij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:38:39 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 23CE91A066D;
        Mon,  7 Oct 2019 13:38:38 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 177A31A02BB;
        Mon,  7 Oct 2019 13:38:38 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CA5572060A;
        Mon,  7 Oct 2019 13:38:37 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/3] dpaa2-eth: misc cleanup
Date:   Mon,  7 Oct 2019 14:38:25 +0300
Message-Id: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
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

Changes in v2:
 - return -ETIMEDOUT where possible if the number of retries is hit

Ioana Radulescu (3):
  dpaa2-eth: Cleanup dead code
  dpaa2-eth: Fix minor bug in ethtool stats reporting
  dpaa2-eth: Avoid unbounded while loops

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 39 ++++++++++++++--------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  8 +++++
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  2 +-
 3 files changed, 35 insertions(+), 14 deletions(-)

-- 
1.9.1

