Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961AA29C06E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782280AbgJ0O47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 10:56:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46692 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782239AbgJ0O44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:56 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6094C1A0175;
        Tue, 27 Oct 2020 15:56:54 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 541171A0165;
        Tue, 27 Oct 2020 15:56:54 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E346202AE;
        Tue, 27 Oct 2020 15:56:54 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     madalin.bucur@oss.nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net 0/2] dpaa_eth: buffer layout fixes
Date:   Tue, 27 Oct 2020 16:56:28 +0200
Message-Id: <cover.1603804282.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patches are related to the software workaround for the A050385 erratum.
The first patch ensures optimal buffer usage for non-erratum scenarios. The
second patch fixes a currently inconsequential discrepancy between the
FMan and Ethernet drivers.

Camelia Groza (2):
  dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
  dpaa_eth: fix the RX headroom size alignment

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--
1.9.1

