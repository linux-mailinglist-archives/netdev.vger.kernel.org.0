Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D36D3166
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfJJTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:32:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:38689 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbfJJTcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 15:32:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 12:31:18 -0700
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="206205632"
Received: from jbrandeb-desk.jf.intel.com ([134.134.177.186])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 12:31:18 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next v1] documentation: correct include file reference
Date:   Thu, 10 Oct 2019 12:31:12 -0700
Message-Id: <20191010193112.15215-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation had a reference to a filename before
a rename had been completed.  Fix the name so the documentation
is correct.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 Documentation/networking/net_dim.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/net_dim.txt b/Documentation/networking/net_dim.txt
index 9cb31c5e2dcd..eef3956f91db 100644
--- a/Documentation/networking/net_dim.txt
+++ b/Documentation/networking/net_dim.txt
@@ -132,7 +132,7 @@ usage is not complete but it should make the outline of the usage clear.
 
 my_driver.c:
 
-#include <linux/net_dim.h>
+#include <linux/dim.h>
 
 /* Callback for net DIM to schedule on a decision to change moderation */
 void my_driver_do_dim_work(struct work_struct *work)
-- 
2.20.1

