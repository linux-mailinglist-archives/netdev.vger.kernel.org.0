Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B688E0291
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbfJVLPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:15:05 -0400
Received: from inva020.nxp.com ([92.121.34.13]:45518 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387460AbfJVLPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 07:15:05 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BAE171A0947;
        Tue, 22 Oct 2019 13:15:03 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AEFA71A0958;
        Tue, 22 Oct 2019 13:15:03 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4D48E2061D;
        Tue, 22 Oct 2019 13:15:03 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v2 0/6] DPAA Ethernet changes
Date:   Tue, 22 Oct 2019 14:14:55 +0300
Message-Id: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: resending with From: field matching signed-off-by

Here's a series of changes for the DPAA Ethernet, addressing minor
or unapparent issues in the codebase, adding probe ordering based on
a recently added DPAA QMan API, removing some redundant code.

Laurentiu Tudor (3):
  fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
  dpaa_eth: defer probing after qbman
  fsl/fman: add API to get the device behind a fman port

Madalin Bucur (3):
  dpaa_eth: remove redundant code
  dpaa_eth: change DMA device
  fsl/fman: remove unused struct member

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c  | 128 +++++++++++++++---------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h  |   8 +-
 drivers/net/ethernet/freescale/fman/fman.c      |   6 +-
 drivers/net/ethernet/freescale/fman/fman_port.c |  17 +++-
 drivers/net/ethernet/freescale/fman/fman_port.h |   2 +
 5 files changed, 108 insertions(+), 53 deletions(-)

-- 
2.1.0

