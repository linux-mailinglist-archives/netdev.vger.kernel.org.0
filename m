Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FCF37BD32
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhELMxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhELMxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1144561439;
        Wed, 12 May 2021 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823903;
        bh=WJnZZbvp/3S4+mp/P3c374P9sXWpRT/tkUrjwqlxuBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpmPUvze122Z88MbxyJ83KfRXPlS2//fnIasq9quewJJDo/CrzSl4AS78cU/EnY6Q
         7Zu3BewUGA5I8YJeVnP1kc1yq1neWzk3aigdwcY8TojJt/zmg0jmaz3GEBZPe9rhh4
         dWjjJqbfsYmFOQDY4EhuJRv60WP2o+wxGMI5t10Zo7fZ1RUV5qIemUuWOCb7Tw+siZ
         jABs8/7Wow/b+7XoBX81eTatEJxanmlokwbYLZvUO0IQ5SMKJAOI+SIjWxj7GPgJaq
         9spMdsMvSJ0msgdG2kBmOu0hrps8lZt5WxithYsEUDMoTDsVsvkFUovZfO01q0KA/m
         3/sfVaScsThuQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lgoKz-0018iU-6a; Wed, 12 May 2021 14:51:41 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 26/40] docs: networking: device_drivers: Use ASCII subset instead of UTF-8 alternate symbols
Date:   Wed, 12 May 2021 14:50:30 +0200
Message-Id: <aa49206f65b7302f6d579d3be726242dedebdb79.1620823573.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620823573.git.mchehab+huawei@kernel.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion tools used during DocBook/LaTeX/Markdown->ReST conversion
and some automatic rules which exists on certain text editors like
LibreOffice turned ASCII characters into some UTF-8 alternatives that
are better displayed on html and PDF.

While it is OK to use UTF-8 characters in Linux, it is better to
use the ASCII subset instead of using an UTF-8 equivalent character
as it makes life easier for tools like grep, and are easier to edit
with the some commonly used text/source code editors.

Also, Sphinx already do such conversion automatically outside literal blocks:
   https://docutils.sourceforge.io/docs/user/smartquotes.html

So, replace the occurences of the following UTF-8 characters:

	- U+00a0 (' '): NO-BREAK SPACE
	- U+2018 ('‘'): LEFT SINGLE QUOTATION MARK
	- U+2019 ('’'): RIGHT SINGLE QUOTATION MARK

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../device_drivers/ethernet/intel/i40e.rst           |  8 ++++----
 .../device_drivers/ethernet/intel/iavf.rst           |  4 ++--
 .../device_drivers/ethernet/netronome/nfp.rst        | 12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index 2d3f6bd969a2..d0e9b783a224 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
@@ -466,7 +466,7 @@ network. PTP support varies among Intel devices that support this driver. Use
 "ethtool -T <netdev name>" to get a definitive list of PTP capabilities
 supported by the device.
 
-IEEE 802.1ad (QinQ) Support
+IEEE 802.1ad (QinQ) Support
 ---------------------------
 The IEEE 802.1ad standard, informally known as QinQ, allows for multiple VLAN
 IDs within a single Ethernet frame. VLAN IDs are sometimes referred to as
@@ -523,8 +523,8 @@ of a port's bandwidth (should it be available). The sum of all the values for
 Maximum Bandwidth is not restricted, because no more than 100% of a port's
 bandwidth can ever be used.
 
-NOTE: X710/XXV710 devices fail to enable Max VFs (64) when Multiple Functions
-per Port (MFP) and SR-IOV are enabled. An error from i40e is logged that says
+NOTE: X710/XXV710 devices fail to enable Max VFs (64) when Multiple Functions
+per Port (MFP) and SR-IOV are enabled. An error from i40e is logged that says
 "add vsi failed for VF N, aq_err 16". To workaround the issue, enable less than
 64 virtual functions (VFs).
 
@@ -680,7 +680,7 @@ queues: for each tc, <num queues>@<offset> (e.g. queues 16@0 16@16 assigns
 16 queues to tc0 at offset 0 and 16 queues to tc1 at offset 16. Max total
 number of queues for all tcs is 64 or number of cores, whichever is lower.)
 
-hw 1 mode channel: ‘channel’ with ‘hw’ set to 1 is a new new hardware
+hw 1 mode channel: 'channel' with 'hw' set to 1 is a new new hardware
 offload mode in mqprio that makes full use of the mqprio options, the
 TCs, the queue configurations, and the QoS parameters.
 
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 25330b7b5168..b70eea67c3d9 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
@@ -113,7 +113,7 @@ which the AVF is associated. The following are base mode features:
 - AVF device ID
 - HW mailbox is used for VF to PF communications (including on Windows)
 
-IEEE 802.1ad (QinQ) Support
+IEEE 802.1ad (QinQ) Support
 ---------------------------
 The IEEE 802.1ad standard, informally known as QinQ, allows for multiple VLAN
 IDs within a single Ethernet frame. VLAN IDs are sometimes referred to as
@@ -171,7 +171,7 @@ queues: for each tc, <num queues>@<offset> (e.g. queues 16@0 16@16 assigns
 16 queues to tc0 at offset 0 and 16 queues to tc1 at offset 16. Max total
 number of queues for all tcs is 64 or number of cores, whichever is lower.)
 
-hw 1 mode channel: ‘channel’ with ‘hw’ set to 1 is a new new hardware
+hw 1 mode channel: 'channel' with 'hw' set to 1 is a new new hardware
 offload mode in mqprio that makes full use of the mqprio options, the
 TCs, the queue configurations, and the QoS parameters.
 
diff --git a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
index ada611fb427c..949c036e8667 100644
--- a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
+++ b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
@@ -62,14 +62,14 @@ actual firmware files in application-named subdirectories in
     $ tree /lib/firmware/netronome/
     /lib/firmware/netronome/
     ├── bpf
-    │   ├── nic_AMDA0081-0001_1x40.nffw
-    │   └── nic_AMDA0081-0001_4x10.nffw
+    │   ├── nic_AMDA0081-0001_1x40.nffw
+    │   └── nic_AMDA0081-0001_4x10.nffw
     ├── flower
-    │   ├── nic_AMDA0081-0001_1x40.nffw
-    │   └── nic_AMDA0081-0001_4x10.nffw
+    │   ├── nic_AMDA0081-0001_1x40.nffw
+    │   └── nic_AMDA0081-0001_4x10.nffw
     ├── nic
-    │   ├── nic_AMDA0081-0001_1x40.nffw
-    │   └── nic_AMDA0081-0001_4x10.nffw
+    │   ├── nic_AMDA0081-0001_1x40.nffw
+    │   └── nic_AMDA0081-0001_4x10.nffw
     ├── nic_AMDA0081-0001_1x40.nffw -> bpf/nic_AMDA0081-0001_1x40.nffw
     └── nic_AMDA0081-0001_4x10.nffw -> bpf/nic_AMDA0081-0001_4x10.nffw
 
-- 
2.30.2

