Return-Path: <netdev+bounces-2233-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DA7700DAC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EE71281A06
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580AE200C0;
	Fri, 12 May 2023 17:10:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E56200A4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:10:06 +0000 (UTC)
X-Greylist: delayed 1170 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 May 2023 10:10:04 PDT
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EBA2719;
	Fri, 12 May 2023 10:10:04 -0700 (PDT)
Received: from [64.186.27.43] (helo=srivatsa-dev.eng.vmware.com)
	by outgoing2021.csail.mit.edu with esmtpa (Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1pxVyH-001Zzx-IH;
	Fri, 12 May 2023 12:50:21 -0400
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
Subject: [PATCH 2/3] MAINTAINERS: Update maintainers for VMware hypervisor interface
Date: Fri, 12 May 2023 09:49:57 -0700
Message-Id: <20230512164958.575174-2-srivatsa@csail.mit.edu>
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

Remove Srivatsa from the maintainers entry for VMware hypervisor
interface and add Ajay Kaher as a co-maintainer. Also, update CREDITS
for Srivatsa.

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Acked-by: Ajay Kaher <akaher@vmware.com>
Acked-by: Alexey Makhalov <amakhalov@vmware.com>
---
 CREDITS     | 1 +
 MAINTAINERS | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 5d48f1a201f2..313435c93e2c 100644
--- a/CREDITS
+++ b/CREDITS
@@ -386,6 +386,7 @@ D: dsp56k device driver
 N: Srivatsa S. Bhat
 E: srivatsa@csail.mit.edu
 D: Maintainer of Generic Paravirt-Ops subsystem
+D: Maintainer of VMware hypervisor interface
 
 N: Ross Biro
 E: ross.biro@gmail.com
diff --git a/MAINTAINERS b/MAINTAINERS
index 2d8d000353b5..309d4cc325f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22493,7 +22493,7 @@ S:	Supported
 F:	drivers/misc/vmw_balloon.c
 
 VMWARE HYPERVISOR INTERFACE
-M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
+M:	Ajay Kaher <akaher@vmware.com>
 M:	Alexey Makhalov <amakhalov@vmware.com>
 R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	virtualization@lists.linux-foundation.org
-- 
2.25.1


