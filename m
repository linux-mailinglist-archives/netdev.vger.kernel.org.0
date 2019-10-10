Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB7D2E75
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 18:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfJJQT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 12:19:57 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47888 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfJJQT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 12:19:57 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DAE1E2004A8;
        Thu, 10 Oct 2019 18:19:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CE89E2004A6;
        Thu, 10 Oct 2019 18:19:55 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 91EF32060B;
        Thu, 10 Oct 2019 18:19:55 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net 0/2] dpaa2-eth: misc fixes
Date:   Thu, 10 Oct 2019 19:19:45 +0300
Message-Id: <1570724387-5370-1-git-send-email-ioana.ciornei@nxp.com>
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

Florin Chiculita (1):
  dpaa2-eth: add irq for the dpmac connect/disconnect event

Ioana Radulescu (1):
  dpaa2-eth: Fix TX FQID values

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 48 +++++++++++++++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h      |  5 ++-
 2 files changed, 51 insertions(+), 2 deletions(-)

-- 
1.9.1

