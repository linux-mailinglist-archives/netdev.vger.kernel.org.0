Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E55517AB34
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgCERJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:09:02 -0500
Received: from inva021.nxp.com ([92.121.34.21]:34126 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgCERJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:09:02 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D6B052007B1;
        Thu,  5 Mar 2020 18:09:00 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C97422007AC;
        Thu,  5 Mar 2020 18:09:00 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B8972059E;
        Thu,  5 Mar 2020 18:09:00 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, s.hauer@pengutronix.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v3 0/3] QorIQ DPAA: Use random MAC address when none is given
Date:   Thu,  5 Mar 2020 19:08:55 +0200
Message-Id: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Use random MAC addresses when they are not provided in the device tree.
Tested on LS1046ARDB.

Changes in v3:
 addressed all MAC types, removed some redundant code in dtsec in
 the process

Madalin Bucur (3):
  fsl/fman: reuse set_mac_address() in dtsec init()
  fsl/fman: tolerate missing MAC address in device tree
  dpaa_eth: Use random MAC address when none is given

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 16 +++++++-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 50 ++++++++++--------------
 drivers/net/ethernet/freescale/fman/fman_memac.c | 10 ++---
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 10 ++---
 drivers/net/ethernet/freescale/fman/mac.c        | 13 +++---
 5 files changed, 49 insertions(+), 50 deletions(-)

-- 
2.1.0

