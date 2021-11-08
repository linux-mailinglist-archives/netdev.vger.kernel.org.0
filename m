Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D957449D34
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhKHUrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:47:52 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:51205 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237467AbhKHUrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 15:47:51 -0500
X-Greylist: delayed 1086 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2021 15:47:49 EST
Received: from [128.177.79.46] (helo=[10.118.101.22])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mkBEE-000DLY-2j; Mon, 08 Nov 2021 15:26:54 -0500
Subject: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as private
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com
Cc:     Nadav Amit <namit@vmware.com>, Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        srivatsa@csail.mit.edu, sdeep@vmware.com, amakhalov@vmware.com,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Nov 2021 12:30:07 -0800
Message-ID: <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
In-Reply-To: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

VMware mailing lists in the MAINTAINERS file are private lists meant
for VMware-internal review/notification for patches to the respective
subsystems. So, in an earlier discussion [1][2], it was recommended to
mark them as such. Update all the remaining VMware mailing list
references to use that format -- "L: list@address (private)".

[1]. https://lore.kernel.org/r/YPfp0Ff6KuyPlyrc@kroah.com
[2]. https://lore.kernel.org/r/1626861766-11115-1-git-send-email-jhansen@vmware.com

Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
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
Acked-by: Zack Rusin <zackr@vmware.com>
---

 MAINTAINERS |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 118cf8170d02..3e92176e68fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6134,8 +6134,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
 F:	drivers/gpu/drm/vboxvideo/
 
 DRM DRIVER FOR VMWARE VIRTUAL GPU
-M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
 M:	Zack Rusin <zackr@vmware.com>
+L:	linux-graphics-maintainer@vmware.com (private)
 L:	dri-devel@lists.freedesktop.org
 S:	Supported
 T:	git git://anongit.freedesktop.org/drm/drm-misc
@@ -20032,7 +20032,7 @@ F:	tools/testing/vsock/
 
 VMWARE BALLOON DRIVER
 M:	Nadav Amit <namit@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	pv-drivers@vmware.com (private)
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/vmw_balloon.c
@@ -20050,14 +20050,14 @@ F:	arch/x86/kernel/cpu/vmware.c
 
 VMWARE PVRDMA DRIVER
 M:	Adit Ranadive <aditr@vmware.com>
-M:	VMware PV-Drivers <pv-drivers@vmware.com>
+L:	pv-drivers@vmware.com (private)
 L:	linux-rdma@vger.kernel.org
 S:	Maintained
 F:	drivers/infiniband/hw/vmw_pvrdma/
 
 VMware PVSCSI driver
 M:	Vishal Bhakta <vbhakta@vmware.com>
-M:	VMware PV-Drivers <pv-drivers@vmware.com>
+L:	pv-drivers@vmware.com (private)
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/vmw_pvscsi.c
@@ -20065,7 +20065,7 @@ F:	drivers/scsi/vmw_pvscsi.h
 
 VMWARE VIRTUAL PTP CLOCK DRIVER
 M:	Vivek Thampi <vithampi@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	pv-drivers@vmware.com (private)
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/ptp/ptp_vmw.c
@@ -20079,8 +20079,8 @@ S:	Maintained
 F:	drivers/misc/vmw_vmci/
 
 VMWARE VMMOUSE SUBDRIVER
-M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
-M:	"VMware, Inc." <pv-drivers@vmware.com>
+L:	linux-graphics-maintainer@vmware.com (private)
+L:	pv-drivers@vmware.com (private)
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/mouse/vmmouse.c
@@ -20088,7 +20088,7 @@ F:	drivers/input/mouse/vmmouse.h
 
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Ronak Doshi <doshir@vmware.com>
-M:	pv-drivers@vmware.com
+L:	pv-drivers@vmware.com (private)
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/vmxnet3/

