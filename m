Return-Path: <netdev+bounces-2234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07678700DB3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0701C212D7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1912F200C6;
	Fri, 12 May 2023 17:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E14114265
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:10:07 +0000 (UTC)
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863202D47;
	Fri, 12 May 2023 10:10:06 -0700 (PDT)
Received: from [64.186.27.43] (helo=srivatsa-dev.eng.vmware.com)
	by outgoing2021.csail.mit.edu with esmtpa (Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1pxVyD-001Zzx-3Z;
	Fri, 12 May 2023 12:50:17 -0400
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
Subject: [PATCH 1/3] MAINTAINERS: Update maintainers for paravirt-ops
Date: Fri, 12 May 2023 09:49:56 -0700
Message-Id: <20230512164958.575174-1-srivatsa@csail.mit.edu>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>

I have decided to change employers and I'm not sure if I'll be able to
spend as much time on the paravirt-ops subsystem going forward. So, I
would like to remove myself from the maintainer role for paravirt-ops.

Remove Srivatsa from the maintainers entry and add Ajay Kaher as an
additional reviewer for paravirt-ops. Also, add an entry to CREDITS
for Srivatsa.

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Acked-by: Alexey Makhalov <amakhalov@vmware.com>
Acked-by: Ajay Kaher <akaher@vmware.com>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 2d9da9a7defa..5d48f1a201f2 100644
--- a/CREDITS
+++ b/CREDITS
@@ -383,6 +383,10 @@ E: tomas@nocrew.org
 W: http://tomas.nocrew.org/
 D: dsp56k device driver
 
+N: Srivatsa S. Bhat
+E: srivatsa@csail.mit.edu
+D: Maintainer of Generic Paravirt-Ops subsystem
+
 N: Ross Biro
 E: ross.biro@gmail.com
 D: Original author of the Linux networking code
diff --git a/MAINTAINERS b/MAINTAINERS
index e0ad886d3163..2d8d000353b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15929,7 +15929,7 @@ F:	include/uapi/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
-M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
+R:	Ajay Kaher <akaher@vmware.com>
 R:	Alexey Makhalov <amakhalov@vmware.com>
 R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	virtualization@lists.linux-foundation.org
-- 
2.25.1


