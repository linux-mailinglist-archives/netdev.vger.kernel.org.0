Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF481C043D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgD3R6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgD3R6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:58:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0486521775;
        Thu, 30 Apr 2020 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588269487;
        bh=cS8WZ1PkdgZTZriWGQbCR5J5KUjuu6VHvNnIPNVO7Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1omNjIt++OvpDYK1EGLebSBOD8FCTE8r9K3VD2wcnYBBZgSRAgm/eDnKRrCqwPni
         kMc/QxfRs0GUC6h1KoBIMJ1fIl7vzPxSVooj8b5j9PY1z4KRpoBRR2CCwP7BLFzqTE
         wAbID5FhaIU8shxtG+92nb5kTRj6QT4Vn/vycM8I=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 3/3] docs: devlink: clarify the scope of snapshot id
Date:   Thu, 30 Apr 2020 10:57:58 -0700
Message-Id: <20200430175759.1301789-4-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430175759.1301789-1-kuba@kernel.org>
References: <20200430175759.1301789-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In past discussions Jiri explained snapshot ids are cross-region.
Explain this in the docs.

v3: new patch

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/devlink/devlink-region.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index daf35427fce1..3654c3e9658f 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -14,6 +14,10 @@ Region snapshots are collected by the driver, and can be accessed via read
 or dump commands. This allows future analysis on the created snapshots.
 Regions may optionally support triggering snapshots on demand.
 
+Snapshot identifiers are scoped to the devlink instance, not a region.
+All snapshots with the same snapshot id within a devlink instance
+correspond to the same event.
+
 The major benefit to creating a region is to provide access to internal
 address regions that are otherwise inaccessible to the user.
 
-- 
2.25.4

