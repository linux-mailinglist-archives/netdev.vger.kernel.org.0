Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D5C3A9352
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhFPG5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhFPG5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 02:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471CB613E4;
        Wed, 16 Jun 2021 06:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623826518;
        bh=pQZ1uyy+ChPtD1nPHLcJgg7YLiFjFABFv8mQ81IQUZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0YcY+jxitDoxq99H34jzUAXuE04SwwQajGs2MzXNOIwNuUy/Pr8KvoJJgyiPRUkC
         iLktbjp+pIcLmUwG8rIZD9SKGqVsAxeipQtrmyeqzvZL1h9lmMoNowXcvQTlpM5PE8
         1MqVcsWjV787PA4lRFhEHtN+objgoDkjhKpQjvOLLLnb7mFWKh5MRXVIiPFWuzaGCQ
         IF7D5yQeh3/9hCWz3j1XXBBa9QPITvqYsEbsFTSXIqPeSmqvWFXDRjepJKlFJ21ajJ
         If3hOQlig0oTuLn5TOwtzyK+S2JcknyoyqxhGnjyHZfxPHfnX1uquYhwRVzsD9k2xO
         VqqBF/G5whQ3g==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1ltPSG-004lCf-Hg; Wed, 16 Jun 2021 08:55:16 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 7/8] docs: networking: device_drivers: replace some characters
Date:   Wed, 16 Jun 2021 08:55:13 +0200
Message-Id: <9bd9f5c067c4b068a974730a14fe8d68e1be0c9a.1623826294.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623826294.git.mchehab+huawei@kernel.org>
References: <cover.1623826294.git.mchehab+huawei@kernel.org>
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

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
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

