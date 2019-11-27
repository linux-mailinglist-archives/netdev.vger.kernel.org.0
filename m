Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CBA10AFAC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfK0MkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:40:05 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:50424 "EHLO
        faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbfK0MkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:40:04 -0500
Received: from faui04s.informatik.uni-erlangen.de (faui04s.informatik.uni-erlangen.de [131.188.30.149])
        by faui03.informatik.uni-erlangen.de (Postfix) with ESMTP id B65EE241837;
        Wed, 27 Nov 2019 13:31:02 +0100 (CET)
Received: by faui04s.informatik.uni-erlangen.de (Postfix, from userid 66121)
        id 9582315E0CF3; Wed, 27 Nov 2019 13:31:02 +0100 (CET)
From:   Dorothea Ehrl <dorothea.ehrl@fau.de>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     linux-kernel@i4.cs.fau.de, Dorothea Ehrl <dorothea.ehrl@fau.de>,
        Vanessa Hack <vanessa.hack@fau.de>
Subject: [PATCH 4/5] staging/qlge: remove braces in conditional statement
Date:   Wed, 27 Nov 2019 13:30:51 +0100
Message-Id: <20191127123052.16424-4-dorothea.ehrl@fau.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127123052.16424-1-dorothea.ehrl@fau.de>
References: <20191127123052.16424-1-dorothea.ehrl@fau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "WARNING: braces {} are not necessary for single
statement blocks" and "WARNING: braces {} are not necessary for any arm
of this statement" by checkpatch.pl.

Signed-off-by: Dorothea Ehrl <dorothea.ehrl@fau.de>
Co-developed-by: Vanessa Hack <vanessa.hack@fau.de>
Signed-off-by: Vanessa Hack <vanessa.hack@fau.de>
---
 drivers/staging/qlge/qlge_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index f5ab6cc7050a..d19709bcdc20 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4101,11 +4101,11 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 	struct ql_adapter *qdev = netdev_priv(ndev);
 	int status;

-	if (ndev->mtu == 1500 && new_mtu == 9000) {
+	if (ndev->mtu == 1500 && new_mtu == 9000)
 		netif_err(qdev, ifup, qdev->ndev, "Changing to jumbo MTU.\n");
-	} else if (ndev->mtu == 9000 && new_mtu == 1500) {
+	else if (ndev->mtu == 9000 && new_mtu == 1500)
 		netif_err(qdev, ifup, qdev->ndev, "Changing to normal MTU.\n");
-	} else
+	else
 		return -EINVAL;

 	queue_delayed_work(qdev->workqueue,
@@ -4113,9 +4113,8 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)

 	ndev->mtu = new_mtu;

-	if (!netif_running(qdev->ndev)) {
+	if (!netif_running(qdev->ndev))
 		return 0;
-	}

 	status = ql_change_rx_buffers(qdev);
 	if (status) {
--
2.20.1

