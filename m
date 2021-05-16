Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491CE381DE8
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 12:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhEPKT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 06:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhEPKTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 06:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79394611CC;
        Sun, 16 May 2021 10:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621160317;
        bh=SMT4rzTFUsUUFwX28Tw+35D0iDjQAGtKW8R9r//yWxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQsKL4o4vRQLmhkHRO1w4TTbVFhi1nTLa4JrJnUyGAQWAiS17ACBTrhK058a6KRc/
         wml5C011SoSeXxdIyjaPHR53aSl+SgUEIs+FArB43+sbDqGWz8Fg/jrn//dB9x7lCR
         eW14ypC01j46CBTfxClsIs36GqHTsMFvrxyelSPXetjFuR65+4At3pknCtEDcdyB36
         5UE8X9BxIuI6p3VN5Q2cOQZc9To3tXSkOPKKFJdUr7aQUfynS07S12YAErBALwGyzZ
         g7XoQBkE4JDWxznPXCtJQNblgrfDnXBgqCJqHMd1UxQ7qx1TNw/AccTZFTKBGjFoG7
         avKFMR0GXZTTg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1liDr1-003o8q-JL; Sun, 16 May 2021 12:18:35 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 11/16] docs: networking: device_drivers: replace some characters
Date:   Sun, 16 May 2021 12:18:28 +0200
Message-Id: <23247f10ab58ae1b54ac368f8a2d2769562adcf4.1621159997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621159997.git.mchehab+huawei@kernel.org>
References: <cover.1621159997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion tools used during DocBook/LaTeX/html/Markdown->ReST
conversion and some cut-and-pasted text contain some characters that
aren't easily reachable on standard keyboards and/or could cause
troubles when parsed by the documentation build system.

Replace the occurences of the following characters:

	- U+00a0 (' '): NO-BREAK SPACE
	  as it can cause lines being truncated on PDF output

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/ethernet/intel/i40e.rst       | 6 +++---
 .../networking/device_drivers/ethernet/intel/iavf.rst       | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index 2d3f6bd969a2..ac35bd472bdc 100644
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
 
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 25330b7b5168..151af0a8da9c 100644
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
-- 
2.31.1

