Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49329D8F8
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389000AbgJ1WlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:41:14 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49862 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388988AbgJ1Wjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:39:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4E5451A01C5;
        Wed, 28 Oct 2020 17:41:09 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4211E1A0160;
        Wed, 28 Oct 2020 17:41:09 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E85DA2030E;
        Wed, 28 Oct 2020 17:41:08 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     willemdebruijn.kernel@gmail.com, madalin.bucur@oss.nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net v2 0/2] dpaa_eth: buffer layout fixes
Date:   Wed, 28 Oct 2020 18:40:58 +0200
Message-Id: <cover.1603899392.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patches are related to the software workaround for the A050385 erratum.
The first patch ensures optimal buffer usage for non-erratum scenarios. The
second patch fixes a currently inconsequential discrepancy between the
FMan and Ethernet drivers.

Changes in v2:
- make the returned value for TX ports explicit in 2/2
- simplify the buf_layout reference in 2/2

Camelia Groza (2):
  dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
  dpaa_eth: fix the RX headroom size alignment

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--
1.9.1

