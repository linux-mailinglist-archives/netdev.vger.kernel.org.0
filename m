Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37C2D89D5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391055AbfJPHgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:36:32 -0400
Received: from inva020.nxp.com ([92.121.34.13]:40810 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391032AbfJPHgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:36:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F2DF11A0507;
        Wed, 16 Oct 2019 09:36:29 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E6D051A04F8;
        Wed, 16 Oct 2019 09:36:29 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9F9D9205D2;
        Wed, 16 Oct 2019 09:36:29 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v3 net 0/2] dpaa2-eth: misc fixes
Date:   Wed, 16 Oct 2019 10:36:21 +0300
Message-Id: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a couple of fixes around updating configuration on MAC
change.  Depending on when MC connects the DPNI to a MAC, both the MAC
address and TX FQIDs should be updated everytime there is a change in
configuration.

Changes in v2:
 - used reverse christmas tree ordering in patch 2/2
Changes in v3:
 - add a missing new line
 - go back to FQ based enqueueing after a transient error

Florin Chiculita (1):
  dpaa2-eth: add irq for the dpmac connect/disconnect event

Ioana Radulescu (1):
  dpaa2-eth: Fix TX FQID values

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 50 +++++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h      |  5 ++-
 2 files changed, 53 insertions(+), 2 deletions(-)

-- 
1.9.1

