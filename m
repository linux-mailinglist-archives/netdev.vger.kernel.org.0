Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4C3211E75
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgGBIYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:24:34 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59768 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbgGBIYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:24:05 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628Nt6b082238;
        Thu, 2 Jul 2020 03:23:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678235;
        bh=2Ps3sR9VF/LqByb34nV2fM7x0C723HV4lrdTJSaPtuA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=iCY0E9W7YtWImyjACut0NGZBKOpaf22G78SdPYYg8vG5CI0IfbPCrAZ/V5/Wqr0ek
         8lX40jte/wRY2JN8ardU2oSSftFNtSPIesQSJizfY8pkyhecWg5VidgZWPsuJ9vn10
         7CU7+V1dA0D5K+DoWGKlSxkziCwP9B9jOImc4hIc=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628NtLg087605;
        Thu, 2 Jul 2020 03:23:55 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:23:54 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:23:54 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYY006145;
        Thu, 2 Jul 2020 03:23:49 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 22/22] NTB: Describe ntb_virtio and ntb_vhost client in the documentation
Date:   Thu, 2 Jul 2020 13:51:43 +0530
Message-ID: <20200702082143.25259-23-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a blurb in Documentation/ntb.txt to describe the ntb_virtio and
ntb_vhost client

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/driver-api/ntb.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/driver-api/ntb.rst b/Documentation/driver-api/ntb.rst
index 87d1372da879..f84b81625397 100644
--- a/Documentation/driver-api/ntb.rst
+++ b/Documentation/driver-api/ntb.rst
@@ -227,6 +227,17 @@ test client is interacted with through the debugfs filesystem:
 	specified peer. That peer's interrupt's occurrence file
 	should be incremented.
 
+NTB Vhost Client (ntb\_vhost) and NTB Virtio Client (ntb\_virtio)
+------------------------------------------------------------------
+
+When two hosts are connected via NTB, one of the hosts should use NTB Vhost
+Client and the other host should use NTB Virtio Client. The NTB Vhost client
+interfaces with the Linux Vhost Framework and lets it to be used with any
+vhost client driver. The NTB Virtio client interfaces with the Linux Virtio
+Framework and lets it to be used with any virtio client driver. The Vhost
+client driver and Virtio client driver creates a logic cink to exchange data
+with each other.
+
 NTB Hardware Drivers
 ====================
 
-- 
2.17.1

