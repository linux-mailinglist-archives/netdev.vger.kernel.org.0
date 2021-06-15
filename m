Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64333A7EB6
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFONL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:11:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:63349 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhFONL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:11:26 -0400
IronPort-SDR: erRDZN8MYfk3uG9XivIh/eIZnXVNfzkq5iekejT3RgUT1S1xGKnbXxP1EA5AcNbxGH/DRRNskV
 omK0JQXLGDPQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="185679189"
X-IronPort-AV: E=Sophos;i="5.83,275,1616482800"; 
   d="scan'208";a="185679189"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 06:09:22 -0700
IronPort-SDR: ORs764e8WIwQ2ablXuOMllesumRC5/77hQnw1N1bMP6QcbdACEmDJNNHTGPkv0KEpEXVKoNqhR
 ds5yOGAqut8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,275,1616482800"; 
   d="scan'208";a="554441589"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jun 2021 06:09:20 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] net: wwan: iosm: Fix htmldocs warnings
Date:   Tue, 15 Jun 2021 18:38:22 +0530
Message-Id: <20210615130822.26441-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes .rst file warnings seen on linux-next build.

Fixes: f7af616c632e ("net: iosm: infrastructure")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 Documentation/networking/device_drivers/wwan/iosm.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/device_drivers/wwan/iosm.rst b/Documentation/networking/device_drivers/wwan/iosm.rst
index cd12f57d980a..aceb0223eb46 100644
--- a/Documentation/networking/device_drivers/wwan/iosm.rst
+++ b/Documentation/networking/device_drivers/wwan/iosm.rst
@@ -40,7 +40,7 @@ MBIM control channel userspace ABI
 ----------------------------------
 
 /dev/wwan0mbim0 character device
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 The driver exposes an MBIM interface to the MBIM function by implementing
 MBIM WWAN Port. The userspace end of the control channel pipe is a
 /dev/wwan0mbim0 character device. Application shall use this interface for
@@ -52,12 +52,12 @@ The userspace application is responsible for all control message fragmentation
 and defragmentation as per MBIM specification.
 
 /dev/wwan0mbim0 write()
-~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~
 The MBIM control messages from the management application must not exceed the
 negotiated control message size.
 
 /dev/wwan0mbim0 read()
-~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~
 The management application must accept control messages of up the negotiated
 control message size.
 
@@ -65,7 +65,7 @@ MBIM data channel userspace ABI
 -------------------------------
 
 wwan0-X network device
-~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~
 The IOSM driver exposes IP link interface "wwan0-X" of type "wwan" for IP
 traffic. Iproute network utility is used for creating "wwan0-X" network
 interface and for associating it with MBIM IP session. The Driver supports
-- 
2.30.2

