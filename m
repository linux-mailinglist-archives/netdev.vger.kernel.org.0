Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5484B13B36E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgANUJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:09:31 -0500
Received: from mga14.intel.com ([192.55.52.115]:16888 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbgANUJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 15:09:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 12:09:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,320,1574150400"; 
   d="scan'208";a="219703920"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2020 12:09:30 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: [PATCH] devlink: fix typos in qed documentation
Date:   Tue, 14 Jan 2020 12:09:18 -0800
Message-Id: <20200114200918.2753721-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Review of the recently added documentation file for the qed driver
noticed a couple of typos. Fix them now.

Noticed-by: Michal Kalderon <mkalderon@marvell.com>
Fixes: 0f261c3ca09e ("devlink: add a driver-specific file for the qed driver")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/qed.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/qed.rst b/Documentation/networking/devlink/qed.rst
index e7e17acf1eca..805c6f63621a 100644
--- a/Documentation/networking/devlink/qed.rst
+++ b/Documentation/networking/devlink/qed.rst
@@ -22,5 +22,5 @@ The ``qed`` driver implements the following driver-specific parameters.
    * - ``iwarp_cmt``
      - Boolean
      - runtime
-     - Enable iWARP functionality for 100g devices. Notee that this impacts
-       L2 performance, and is therefor not enabled by default.
+     - Enable iWARP functionality for 100g devices. Note that this impacts
+       L2 performance, and is therefore not enabled by default.
-- 
2.25.0.rc1

