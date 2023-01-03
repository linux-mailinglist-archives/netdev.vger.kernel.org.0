Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1486465CA3A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjACXKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjACXKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:10:03 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Jan 2023 15:10:03 PST
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F66C1403F;
        Tue,  3 Jan 2023 15:10:03 -0800 (PST)
Received: from [128.177.82.146] (helo=srivatsa-dev.eng.vmware.com)
        by outgoing2021.csail.mit.edu with esmtpa (Exim 4.95)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1pCpTq-00Akfa-Au;
        Tue, 03 Jan 2023 17:09:58 -0500
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, pv-drivers@vmware.com,
        srivatsa@csail.mit.edu, davem@davemloft.net, srivatsab@vmware.com,
        Vivek Thampi <vivek@vivekthampi.com>,
        Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>
Subject: [PATCH] MAINTAINERS: Update maintainers for ptp_vmw driver
Date:   Tue,  3 Jan 2023 14:09:41 -0800
Message-Id: <20230103220941.118498-1-srivatsa@csail.mit.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>

Vivek has decided to transfer the maintainership of the VMware virtual
PTP clock driver (ptp_vmw) to Srivatsa and Deep. Update the
MAINTAINERS file to reflect this change, and also add Alexey as a
reviewer for the driver.

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Acked-by: Vivek Thampi <vivek@vivekthampi.com>
Acked-by: Deep Shah <sdeep@vmware.com>
Acked-by: Alexey Makhalov <amakhalov@vmware.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f86d02cb427..ea941dc469fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22246,7 +22246,9 @@ F:	drivers/scsi/vmw_pvscsi.c
 F:	drivers/scsi/vmw_pvscsi.h
 
 VMWARE VIRTUAL PTP CLOCK DRIVER
-M:	Vivek Thampi <vithampi@vmware.com>
+M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
+M:	Deep Shah <sdeep@vmware.com>
+R:	Alexey Makhalov <amakhalov@vmware.com>
 R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.25.1

