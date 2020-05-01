Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395D51C1AB8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 18:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgEAQkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 12:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729041AbgEAQkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 12:40:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0A72495A;
        Fri,  1 May 2020 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588351246;
        bh=LFn3dtbOe0jk+YHBbSrQoB4GRlEzGSt+CJYcJT6hfFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBN44vS4UOpx6qIeSBN18+S+GBwTzUYpgM5zi0slFHIm/mNg+KvJqIKg19fWHrz7+
         PX/+4eJbilXVqmxiUFFv4Z5NEMxw8brPhQrO6+cVussQSikiCRgKHEoKpcQXo88OFA
         NMUbbtPae7MjMBZmR1pUixvH4WdBY4Fjjz9Q3Zbs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v4 3/3] docs: devlink: clarify the scope of snapshot id
Date:   Fri,  1 May 2020 09:40:42 -0700
Message-Id: <20200501164042.1430604-4-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200501164042.1430604-1-kuba@kernel.org>
References: <20200501164042.1430604-1-kuba@kernel.org>
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
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
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

