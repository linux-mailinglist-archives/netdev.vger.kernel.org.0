Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C45DE155A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403754AbfJWJIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:08:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55340 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732361AbfJWJIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 05:08:52 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9BC30200137;
        Wed, 23 Oct 2019 11:08:50 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8E7C22000DF;
        Wed, 23 Oct 2019 11:08:50 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 48A39205FE;
        Wed, 23 Oct 2019 11:08:50 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        jakub.kicinski@netronome.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v3 0/7] DPAA Ethernet changes
Date:   Wed, 23 Oct 2019 12:08:39 +0300
Message-Id: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3: add newline at the end of error messages
v2: resending with From: field matching signed-off-by

Here's a series of changes for the DPAA Ethernet, addressing minor
or unapparent issues in the codebase, adding probe ordering based on
a recently added DPAA QMan API, removing some redundant code.

Laurentiu Tudor (3):
  fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
  dpaa_eth: defer probing after qbman
  fsl/fman: add API to get the device behind a fman port

Madalin Bucur (4):
  dpaa_eth: remove redundant code
  dpaa_eth: change DMA device
  fsl/fman: remove unused struct member
  dpaa_eth: add newline in dev_err() msg

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c  | 130 +++++++++++++++---------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h  |   8 +-
 drivers/net/ethernet/freescale/fman/fman.c      |   6 +-
 drivers/net/ethernet/freescale/fman/fman_port.c |  17 +++-
 drivers/net/ethernet/freescale/fman/fman_port.h |   2 +
 5 files changed, 109 insertions(+), 54 deletions(-)

-- 
2.1.0

