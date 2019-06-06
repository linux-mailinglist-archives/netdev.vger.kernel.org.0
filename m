Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18B36F1A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfFFIuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:50:32 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50214 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFIub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:50:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 39FE11A0A7C;
        Thu,  6 Jun 2019 10:50:30 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2BDEC1A0A72;
        Thu,  6 Jun 2019 10:50:30 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DEAC6205C7;
        Thu,  6 Jun 2019 10:50:29 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 0/3] dpaa2-eth: Add support for MQPRIO offloading
Date:   Thu,  6 Jun 2019 11:50:26 +0300
Message-Id: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for adding multiple TX traffic classes with mqprio. We can have
up to one netdev queue and hardware frame queue per TC per core.

Ioana Radulescu (3):
  dpaa2-eth: Refactor xps code
  dpaa2-eth: Support multiple traffic classes on Tx
  dpaa2-eth: Add mqprio support

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 129 ++++++++++++++++++-----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |   9 +-
 2 files changed, 112 insertions(+), 26 deletions(-)

-- 
2.7.4

