Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0B4C3928
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 23:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiBXWuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 17:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiBXWug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 17:50:36 -0500
X-Greylist: delayed 1803 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 14:50:05 PST
Received: from outgoing-stata.csail.mit.edu (outgoing-stata.csail.mit.edu [128.30.2.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3B51120F7D;
        Thu, 24 Feb 2022 14:50:05 -0800 (PST)
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1nNMTe-000HJc-Fb; Thu, 24 Feb 2022 17:20:46 -0500
Subject: [PATCH v5 3/3] MAINTAINERS: Mark VMware mailing list entries as email
 aliases
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        tglx@linutronix.de, bp@alien8.de
Cc:     Joe Perches <joe@perches.com>, Zack Rusin <zackr@vmware.com>,
        Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, sdeep@vmware.com, vithampi@vmware.com,
        amakhalov@vmware.com, keerthanak@vmware.com, srivatsab@vmware.com,
        anishs@vmware.com, linux-kernel@vger.kernel.org, namit@vmware.com,
        joe@perches.com, kuba@kernel.org, rostedt@goodmis.org,
        srivatsa@csail.mit.edu
Date:   Thu, 24 Feb 2022 14:24:49 -0800
Message-ID: <164574148378.654750.15832494349474144706.stgit@csail.mit.edu>
In-Reply-To: <164574138686.654750.10250173565414769119.stgit@csail.mit.edu>
References: <164574138686.654750.10250173565414769119.stgit@csail.mit.edu>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

VMware mailing lists in the MAINTAINERS file are private lists meant
for VMware-internal review/notification for patches to the respective
subsystems. Anyone can post to these addresses, but there is no public
read access like open mailing lists, which makes them more like email
aliases instead (to reach out to reviewers).

So update all the VMware mailing list references in the MAINTAINERS
file to mark them as such, using "R: email-alias@vmware.com".

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Acked-by: Juergen Gross <jgross@suse.com>
Acked-by: Joe Perches <joe@perches.com>
Acked-by: Zack Rusin <zackr@vmware.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Vivek Thampi <vithampi@vmware.com>
Cc: Vishal Bhakta <vbhakta@vmware.com>
Cc: Ronak Doshi <doshir@vmware.com>
Cc: pv-drivers@vmware.com
Cc: linux-graphics-maintainer@vmware.com
Cc: dri-devel@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-input@vger.kernel.org
---

 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 72771881f159..4041edba891d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6307,8 +6307,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
 F:	drivers/gpu/drm/vboxvideo/
 
 DRM DRIVER FOR VMWARE VIRTUAL GPU
-M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
 M:	Zack Rusin <zackr@vmware.com>
+R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
 L:	dri-devel@lists.freedesktop.org
 S:	Supported
 T:	git git://anongit.freedesktop.org/drm/drm-misc
@@ -14611,7 +14611,7 @@ PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
 M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
 R:	Alexey Makhalov <amakhalov@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	virtualization@lists.linux-foundation.org
 L:	x86@kernel.org
 S:	Supported
@@ -20642,7 +20642,7 @@ F:	tools/testing/vsock/
 
 VMWARE BALLOON DRIVER
 M:	Nadav Amit <namit@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/vmw_balloon.c
@@ -20650,7 +20650,7 @@ F:	drivers/misc/vmw_balloon.c
 VMWARE HYPERVISOR INTERFACE
 M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
 M:	Alexey Makhalov <amakhalov@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	virtualization@lists.linux-foundation.org
 L:	x86@kernel.org
 S:	Supported
@@ -20661,14 +20661,14 @@ F:	arch/x86/kernel/cpu/vmware.c
 VMWARE PVRDMA DRIVER
 M:	Bryan Tan <bryantan@vmware.com>
 M:	Vishnu Dasa <vdasa@vmware.com>
-M:	VMware PV-Drivers <pv-drivers@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	linux-rdma@vger.kernel.org
 S:	Maintained
 F:	drivers/infiniband/hw/vmw_pvrdma/
 
 VMware PVSCSI driver
 M:	Vishal Bhakta <vbhakta@vmware.com>
-M:	VMware PV-Drivers <pv-drivers@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/vmw_pvscsi.c
@@ -20676,7 +20676,7 @@ F:	drivers/scsi/vmw_pvscsi.h
 
 VMWARE VIRTUAL PTP CLOCK DRIVER
 M:	Vivek Thampi <vithampi@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/ptp/ptp_vmw.c
@@ -20684,15 +20684,15 @@ F:	drivers/ptp/ptp_vmw.c
 VMWARE VMCI DRIVER
 M:	Jorgen Hansen <jhansen@vmware.com>
 M:	Vishnu Dasa <vdasa@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	linux-kernel@vger.kernel.org
-L:	pv-drivers@vmware.com (private)
 S:	Maintained
 F:	drivers/misc/vmw_vmci/
 
 VMWARE VMMOUSE SUBDRIVER
 M:	Zack Rusin <zackr@vmware.com>
-M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/mouse/vmmouse.c
@@ -20700,7 +20700,7 @@ F:	drivers/input/mouse/vmmouse.h
 
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Ronak Doshi <doshir@vmware.com>
-M:	pv-drivers@vmware.com
+R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/vmxnet3/


