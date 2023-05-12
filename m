Return-Path: <netdev+bounces-2235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 050F3700DB4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A69F1281B3F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47EC6200CC;
	Fri, 12 May 2023 17:10:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF6F14265
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:10:10 +0000 (UTC)
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D5830EB;
	Fri, 12 May 2023 10:10:08 -0700 (PDT)
Received: from [64.186.27.43] (helo=srivatsa-dev.eng.vmware.com)
	by outgoing2021.csail.mit.edu with esmtpa (Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1pxVyN-001Zzx-6w;
	Fri, 12 May 2023 12:50:27 -0400
From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To: jgross@suse.com,
	bp@suse.de,
	tglx@linutronix.de,
	kuba@kernel.org,
	davem@davemloft.net,
	richardcochran@gmail.com
Cc: sdeep@vmware.com,
	amakhalov@vmware.com,
	akaher@vmware.com,
	vsirnapalli@vmware.com,
	srivatsa@csail.mit.edu,
	pv-drivers@vmware.com,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] MAINTAINERS: Update maintainers for VMware virtual PTP clock driver
Date: Fri, 12 May 2023 09:49:58 -0700
Message-Id: <20230512164958.575174-3-srivatsa@csail.mit.edu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230512164958.575174-1-srivatsa@csail.mit.edu>
References: <20230512164958.575174-1-srivatsa@csail.mit.edu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>

I have decided to change employers, so I would like to remove myself
from the maintainer role for VMware-supported subsystems.

Remove Srivatsa from the maintainers entry for VMware virtual PTP
clock driver (ptp_vmw) and add Ajay Kaher as an additional reviewer.
Also, update CREDITS for Srivatsa.

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Acked-by: Ajay Kaher <akaher@vmware.com>
Acked-by: Alexey Makhalov <amakhalov@vmware.com>
Acked-by: Deep Shah <sdeep@vmware.com>
---
 CREDITS     | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 313435c93e2c..670c256aff5d 100644
--- a/CREDITS
+++ b/CREDITS
@@ -387,6 +387,7 @@ N: Srivatsa S. Bhat
 E: srivatsa@csail.mit.edu
 D: Maintainer of Generic Paravirt-Ops subsystem
 D: Maintainer of VMware hypervisor interface
+D: Maintainer of VMware virtual PTP clock driver (ptp_vmw)
 
 N: Ross Biro
 E: ross.biro@gmail.com
diff --git a/MAINTAINERS b/MAINTAINERS
index 309d4cc325f9..a00bea4d7438 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22520,8 +22520,8 @@ F:	drivers/scsi/vmw_pvscsi.c
 F:	drivers/scsi/vmw_pvscsi.h
 
 VMWARE VIRTUAL PTP CLOCK DRIVER
-M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
 M:	Deep Shah <sdeep@vmware.com>
+R:	Ajay Kaher <akaher@vmware.com>
 R:	Alexey Makhalov <amakhalov@vmware.com>
 R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	netdev@vger.kernel.org
-- 
2.25.1


