Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CAB1A3BDA
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgDIVWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 17:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbgDIVWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 17:22:04 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 249932087E;
        Thu,  9 Apr 2020 21:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586467324;
        bh=u60WH+x0e0iq4HTVQItM5Z+hGRW7Itf6Qjmd2opgtgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKbY4FBsQ6Hvjh5j0D7ztzlLwb2JH9zCq0yA3DsF5yU0hjB0sbAAl/CjnWpZrhCba
         J4OH2MFggONrL3hIVjbUoG8Aq9IuvMu+7F+wkrWG9Wa2GX5aT7PF1AA4LFvpBWvCiG
         S1XGKXuOv3bQLAE1q7sJQ/D79COYdI3AKn38bwCM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@infradead.org, talgi@mellanox.com, leon@kernel.org,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 2/2] docs: networking: add full DIM API
Date:   Thu,  9 Apr 2020 14:21:59 -0700
Message-Id: <20200409212159.322775-2-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409212159.322775-1-kuba@kernel.org>
References: <20200409212159.322775-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add the full net DIM API to the net_dim.rst file.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/net_dim.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/networking/net_dim.rst b/Documentation/networking/net_dim.rst
index 1de1e3ec774b..3bed9fd95336 100644
--- a/Documentation/networking/net_dim.rst
+++ b/Documentation/networking/net_dim.rst
@@ -168,3 +168,9 @@ usage is not complete but it should make the outline of the usage clear.
 	INIT_WORK(&my_entity->dim.work, my_driver_do_dim_work);
 	...
   }
+
+Dynamic Interrupt Moderation (DIM) library API
+==============================================
+
+.. kernel-doc:: include/linux/dim.h
+    :internal:
-- 
2.25.1

