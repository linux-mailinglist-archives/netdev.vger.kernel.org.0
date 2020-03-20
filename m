Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EA118D273
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgCTPLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbgCTPLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 11:11:07 -0400
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A622076E;
        Fri, 20 Mar 2020 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584717066;
        bh=wPIgZHlHXIpvX7rbWR9bBXdthfipdOWJrHs3flWe2dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdeBs9eHiGwMvjF82a2CVzT9xi8PtrAbwc5pkRONZ3Z5ptdlWgjU1n4VkU7m49VX0
         r2w+CcJcrLX2XFku9R2PhaMoyhuCFiy/QlcAdojG9ypNIBN+s0jJ0YQ9Ta9uoPRRuC
         zthMoq13v0KsDaQDfceTTfODcKCAHBeB+I/WUKKM=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jFJIe-000ukg-JM; Fri, 20 Mar 2020 16:11:04 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vinod Koul <vkoul@kernel.org>, Tyler Hicks <code@tyhicks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        Matthias Maennich <maennich@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>, dmaengine@vger.kernel.org,
        ecryptfs@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v2 1/2] docs: prevent warnings due to autosectionlabel
Date:   Fri, 20 Mar 2020 16:11:02 +0100
Message-Id: <2bffb91e4a63d41bf5fae1c23e1e8b3bba0b8806.1584716446.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1584716446.git.mchehab+huawei@kernel.org>
References: <cover.1584716446.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset 58ad30cf91f0 ("docs: fix reference to core-api/namespaces.rst")
enabled a new feature at Sphinx: it will now generate index for each
document title, plus to each chapter inside it.

There's a drawback, though: one document cannot have two sections
with the same name anymore.

A followup patch will change the logic of autosectionlabel to
avoid most creating references for every single section title,
but still we need to be able to reference the chapters inside
a document.

There are a few places where there are two chapters with the
same name. This patch renames one of the chapters, in order to
avoid symbol conflict within the same document.

PS.: as I don't speach Chinese, I had some help from a friend
(Wen Liu) at the Chinese translation for "publishing patches"
for this document:

	Documentation/translations/zh_CN/process/5.Posting.rst

Fixes: 58ad30cf91f0 ("docs: fix reference to core-api/namespaces.rst")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/driver-api/80211/mac80211-advanced.rst  |  8 ++++----
 Documentation/driver-api/dmaengine/index.rst          |  4 ++--
 Documentation/filesystems/ecryptfs.rst                | 11 +++++------
 Documentation/kernel-hacking/hacking.rst              |  4 ++--
 Documentation/media/kapi/v4l2-controls.rst            |  8 ++++----
 Documentation/networking/snmp_counter.rst             |  4 ++--
 Documentation/powerpc/ultravisor.rst                  |  4 ++--
 Documentation/security/siphash.rst                    |  8 ++++----
 Documentation/target/tcmu-design.rst                  |  6 +++---
 .../translations/zh_CN/process/5.Posting.rst          |  2 +-
 Documentation/x86/intel-iommu.rst                     |  3 ++-
 11 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/Documentation/driver-api/80211/mac80211-advanced.rst b/Documentation/driver-api/80211/mac80211-advanced.rst
index 9f1c5bb7ac35..24cb64b3b715 100644
--- a/Documentation/driver-api/80211/mac80211-advanced.rst
+++ b/Documentation/driver-api/80211/mac80211-advanced.rst
@@ -272,8 +272,8 @@ STA information lifetime rules
 .. kernel-doc:: net/mac80211/sta_info.c
    :doc: STA information lifetime rules
 
-Aggregation
-===========
+Aggregation Functions
+=====================
 
 .. kernel-doc:: net/mac80211/sta_info.h
    :functions: sta_ampdu_mlme
@@ -284,8 +284,8 @@ Aggregation
 .. kernel-doc:: net/mac80211/sta_info.h
    :functions: tid_ampdu_rx
 
-Synchronisation
-===============
+Synchronisation Functions
+=========================
 
 TBD
 
diff --git a/Documentation/driver-api/dmaengine/index.rst b/Documentation/driver-api/dmaengine/index.rst
index b9df904d0a79..bdc45d8b4cfb 100644
--- a/Documentation/driver-api/dmaengine/index.rst
+++ b/Documentation/driver-api/dmaengine/index.rst
@@ -5,8 +5,8 @@ DMAEngine documentation
 DMAEngine documentation provides documents for various aspects of DMAEngine
 framework.
 
-DMAEngine documentation
------------------------
+DMAEngine development documentation
+-----------------------------------
 
 This book helps with DMAengine internal APIs and guide for DMAEngine device
 driver writers.
diff --git a/Documentation/filesystems/ecryptfs.rst b/Documentation/filesystems/ecryptfs.rst
index 7236172300ef..1f2edef4c57a 100644
--- a/Documentation/filesystems/ecryptfs.rst
+++ b/Documentation/filesystems/ecryptfs.rst
@@ -30,13 +30,12 @@ Userspace requirements include:
 - Libgcrypt
 
 
-Notes
-=====
+.. note::
 
-In the beta/experimental releases of eCryptfs, when you upgrade
-eCryptfs, you should copy the files to an unencrypted location and
-then copy the files back into the new eCryptfs mount to migrate the
-files.
+   In the beta/experimental releases of eCryptfs, when you upgrade
+   eCryptfs, you should copy the files to an unencrypted location and
+   then copy the files back into the new eCryptfs mount to migrate the
+   files.
 
 
 Mount-wide Passphrase
diff --git a/Documentation/kernel-hacking/hacking.rst b/Documentation/kernel-hacking/hacking.rst
index d707a0a61cc9..eed2136d847f 100644
--- a/Documentation/kernel-hacking/hacking.rst
+++ b/Documentation/kernel-hacking/hacking.rst
@@ -601,7 +601,7 @@ Defined in ``include/linux/export.h``
 
 This is the variant of `EXPORT_SYMBOL()` that allows specifying a symbol
 namespace. Symbol Namespaces are documented in
-:ref:`Documentation/core-api/symbol-namespaces.rst <Symbol Namespaces>`
+:doc:`../core-api/symbol-namespaces`
 
 :c:func:`EXPORT_SYMBOL_NS_GPL()`
 --------------------------------
@@ -610,7 +610,7 @@ Defined in ``include/linux/export.h``
 
 This is the variant of `EXPORT_SYMBOL_GPL()` that allows specifying a symbol
 namespace. Symbol Namespaces are documented in
-:ref:`Documentation/core-api/symbol-namespaces.rst <Symbol Namespaces>`
+:doc:`../core-api/symbol-namespaces`
 
 Routines and Conventions
 ========================
diff --git a/Documentation/media/kapi/v4l2-controls.rst b/Documentation/media/kapi/v4l2-controls.rst
index b20800cae3f2..5129019afb49 100644
--- a/Documentation/media/kapi/v4l2-controls.rst
+++ b/Documentation/media/kapi/v4l2-controls.rst
@@ -291,8 +291,8 @@ and QUERYMENU. And G/S_CTRL as well as G/TRY/S_EXT_CTRLS are automatically suppo
    In practice the basic usage as described above is sufficient for most drivers.
 
 
-Inheriting Controls
--------------------
+Inheriting Sub-device Controls
+------------------------------
 
 When a sub-device is registered with a V4L2 driver by calling
 v4l2_device_register_subdev() and the ctrl_handler fields of both v4l2_subdev
@@ -757,8 +757,8 @@ attempting to find another control from the same handler will deadlock.
 It is recommended not to use this function from inside the control ops.
 
 
-Inheriting Controls
--------------------
+Preventing Controls inheritance
+-------------------------------
 
 When one control handler is added to another using v4l2_ctrl_add_handler, then
 by default all controls from one are merged to the other. But a subdev might
diff --git a/Documentation/networking/snmp_counter.rst b/Documentation/networking/snmp_counter.rst
index 38a4edc4522b..10e11099e74a 100644
--- a/Documentation/networking/snmp_counter.rst
+++ b/Documentation/networking/snmp_counter.rst
@@ -908,8 +908,8 @@ A TLP probe packet is sent.
 
 A packet loss is detected and recovered by TLP.
 
-TCP Fast Open
-=============
+TCP Fast Open description
+=========================
 TCP Fast Open is a technology which allows data transfer before the
 3-way handshake complete. Please refer the `TCP Fast Open wiki`_ for a
 general description.
diff --git a/Documentation/powerpc/ultravisor.rst b/Documentation/powerpc/ultravisor.rst
index 363736d7fd36..df136c8f91fa 100644
--- a/Documentation/powerpc/ultravisor.rst
+++ b/Documentation/powerpc/ultravisor.rst
@@ -8,8 +8,8 @@ Protected Execution Facility
 .. contents::
     :depth: 3
 
-Protected Execution Facility
-############################
+Introduction
+############
 
     Protected Execution Facility (PEF) is an architectural change for
     POWER 9 that enables Secure Virtual Machines (SVMs). DD2.3 chips
diff --git a/Documentation/security/siphash.rst b/Documentation/security/siphash.rst
index 9965821ab333..4eba68cdf0a1 100644
--- a/Documentation/security/siphash.rst
+++ b/Documentation/security/siphash.rst
@@ -128,8 +128,8 @@ then when you can be absolutely certain that the outputs will never be
 transmitted out of the kernel. This is only remotely useful over `jhash` as a
 means of mitigating hashtable flooding denial of service attacks.
 
-Generating a key
-================
+Generating a HalfSipHash key
+============================
 
 Keys should always be generated from a cryptographically secure source of
 random numbers, either using get_random_bytes or get_random_once:
@@ -139,8 +139,8 @@ get_random_bytes(&key, sizeof(key));
 
 If you're not deriving your key from here, you're doing it wrong.
 
-Using the functions
-===================
+Using the HalfSipHash functions
+===============================
 
 There are two variants of the function, one that takes a list of integers, and
 one that takes a buffer::
diff --git a/Documentation/target/tcmu-design.rst b/Documentation/target/tcmu-design.rst
index a7b426707bf6..e47047e32e27 100644
--- a/Documentation/target/tcmu-design.rst
+++ b/Documentation/target/tcmu-design.rst
@@ -5,7 +5,7 @@ TCM Userspace Design
 
 .. Contents:
 
-   1) TCM Userspace Design
+   1) Design
      a) Background
      b) Benefits
      c) Design constraints
@@ -23,8 +23,8 @@ TCM Userspace Design
    3) A final note
 
 
-TCM Userspace Design
-====================
+Design
+======
 
 TCM is another name for LIO, an in-kernel iSCSI target (server).
 Existing TCM targets run in the kernel.  TCMU (TCM in Userspace)
diff --git a/Documentation/translations/zh_CN/process/5.Posting.rst b/Documentation/translations/zh_CN/process/5.Posting.rst
index 41aba21ff050..9ff9945f918c 100644
--- a/Documentation/translations/zh_CN/process/5.Posting.rst
+++ b/Documentation/translations/zh_CN/process/5.Posting.rst
@@ -5,7 +5,7 @@
 
 .. _cn_development_posting:
 
-发送补丁
+发布补丁
 ========
 
 迟早，当您的工作准备好提交给社区进行审查，并最终包含到主线内核中时。不出所料，
diff --git a/Documentation/x86/intel-iommu.rst b/Documentation/x86/intel-iommu.rst
index 9dae6b47e398..099f13d51d5f 100644
--- a/Documentation/x86/intel-iommu.rst
+++ b/Documentation/x86/intel-iommu.rst
@@ -95,9 +95,10 @@ and any RMRR's processed::
 When DMAR is enabled for use, you will notice..
 
 PCI-DMA: Using DMAR IOMMU
+-------------------------
 
 Fault reporting
----------------
+^^^^^^^^^^^^^^^
 
 ::
 
-- 
2.24.1

