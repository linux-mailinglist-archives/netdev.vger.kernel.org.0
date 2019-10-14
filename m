Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93A7D5ECB
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 11:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbfJNJZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 05:25:32 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58326 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbfJNJZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 05:25:32 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EEEDC1A01BB;
        Mon, 14 Oct 2019 11:25:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E27381A0185;
        Mon, 14 Oct 2019 11:25:30 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AA8EB20621;
        Mon, 14 Oct 2019 11:25:30 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net 0/2] dpaa2-eth: misc fixes
Date:   Mon, 14 Oct 2019 12:25:15 +0300
Message-Id: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
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

Florin Chiculita (1):
  dpaa2-eth: add irq for the dpmac connect/disconnect event

Ioana Radulescu (1):
  dpaa2-eth: Fix TX FQID values

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 48 +++++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h      |  5 ++-
 2 files changed, 51 insertions(+), 2 deletions(-)

-- 
1.9.1

