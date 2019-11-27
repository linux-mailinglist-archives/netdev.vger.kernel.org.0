Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D4710AFA7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfK0MkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:40:06 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:50428 "EHLO
        faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbfK0MkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:40:04 -0500
Received: from faui04s.informatik.uni-erlangen.de (faui04s.informatik.uni-erlangen.de [131.188.30.149])
        by faui03.informatik.uni-erlangen.de (Postfix) with ESMTP id 74A252416A6;
        Wed, 27 Nov 2019 13:31:02 +0100 (CET)
Received: by faui04s.informatik.uni-erlangen.de (Postfix, from userid 66121)
        id 5873F15E0A86; Wed, 27 Nov 2019 13:31:02 +0100 (CET)
From:   Dorothea Ehrl <dorothea.ehrl@fau.de>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     linux-kernel@i4.cs.fau.de, Dorothea Ehrl <dorothea.ehrl@fau.de>,
        Vanessa Hack <vanessa.hack@fau.de>
Subject: [PATCH 1/5] staging/qlge: remove initialising of static local variable
Date:   Wed, 27 Nov 2019 13:30:48 +0100
Message-Id: <20191127123052.16424-1-dorothea.ehrl@fau.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "ERROR: do not initialise statics to 0" by checkpatch.pl.

Signed-off-by: Dorothea Ehrl <dorothea.ehrl@fau.de>
Co-developed-by: Vanessa Hack <vanessa.hack@fau.de>
Signed-off-by: Vanessa Hack <vanessa.hack@fau.de>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 6ad4515311f7..587102aa7fbf 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4578,7 +4578,7 @@ static int qlge_probe(struct pci_dev *pdev,
 {
 	struct net_device *ndev = NULL;
 	struct ql_adapter *qdev = NULL;
-	static int cards_found = 0;
+	static int cards_found;
 	int err = 0;

 	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
--
2.20.1

