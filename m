Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966B91BE969
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgD2U7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:59:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:13947 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgD2U7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 16:59:52 -0400
IronPort-SDR: 6hA7OZ3o9cGY8yHtlr+G5zl4yJUD6vWH2O+SsOXMYs59Hdgm/ZYDbtHk/0Uuk/Np2NxjtgGx/3
 Kl2aHgLYBuSg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 13:59:52 -0700
IronPort-SDR: i6SYghSyDRGVKGVEXgH2YLKT/7kMVQM8Zcq+iH3Wd2ey6iiIpp+wNX7IR5qT6WZ3ugiQCCMpje
 7yDCGKCemXiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="276292524"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga002.jf.intel.com with ESMTP; 29 Apr 2020 13:59:51 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Benjamin Fisher <benjamin.l.fisher@intel.com>
Subject: [net] ice: cleanup language in ice.rst for fw.app
Date:   Wed, 29 Apr 2020 13:59:50 -0700
Message-Id: <20200429205950.1906223-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation for the ice driver around "fw.app" has a spelling
mistake in variation. Additionally, the language of "shall have a unique
name" sounds like a requirement. Reword this to read more like
a description or property.

Reported-by: Benjamin Fisher <benjamin.l.fisher@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 5b58fc4e1268..4574352d6ff4 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -61,8 +61,8 @@ The ``ice`` driver reports the following versions
       - running
       - ICE OS Default Package
       - The name of the DDP package that is active in the device. The DDP
-        package is loaded by the driver during initialization. Each varation
-        of DDP package shall have a unique name.
+        package is loaded by the driver during initialization. Each
+        variation of the DDP package has a unique name.
     * - ``fw.app``
       - running
       - 1.3.1.0
-- 
2.25.2

