Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D478D136367
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAIWqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbgAIWqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926840"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:43 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 07/17] devlink: mention reloading in devlink-params.rst
Date:   Thu,  9 Jan 2020 14:46:15 -0800
Message-Id: <20200109224625.1470433-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mention that drivers must support devlink-reload in order for driverinit
parameters to function properly

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/devlink-params.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 7106c79e29be..da2f85c0fa21 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -34,6 +34,13 @@ Parameters may be set in different configuration modes.
      - written to the device's non-volatile memory. A hard reset is required
        for it to take effect.
 
+Reloading
+---------
+
+In order for ``driverinit`` parameters to take effect, the driver must
+support reloading via the ``devlink-reload`` command. This command will
+request a reload of the device driver.
+
 Generic configuration parameters
 ================================
 The following is a list of generic configuration parameters that drivers may
-- 
2.25.0.rc1

