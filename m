Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3938E284D34
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgJFOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgJFODz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:03:55 -0400
Received: from mail.kernel.org (ip5f5ad5bd.dynamic.kabel-deutschland.de [95.90.213.189])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FAC121D90;
        Tue,  6 Oct 2020 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601993034;
        bh=ReWeQAdsRgO/jyvpQynk0BfIa0k5iD1zUW77cmoS650=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH15nm1H2hTNHQ44WMU8kdnM2cK4NnKRye3tazK3eTeRjCddaLbeyyElRtOLKfNp3
         nQltGLXvQGDSHgBLrXTETLycLRIZklUoPwEqrDDlsyQ3fD0Cby1locLm9RcT9+Jx7n
         KpT/+M3HryrSJ3jvzpJMjEjSm6kxJbG2nhpTl8Pg=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kPnZI-0019Fx-Eg; Tue, 06 Oct 2020 16:03:52 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v5 33/52] docs: net: statistics.rst: remove a duplicated kernel-doc
Date:   Tue,  6 Oct 2020 16:03:30 +0200
Message-Id: <ce6c2b865d3aef018845ab85ae6e0802dfdc3a21.1601992016.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601992016.git.mchehab+huawei@kernel.org>
References: <cover.1601992016.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

include/linux/ethtool.h is included twice with kernel-doc,
both to document ethtool_pause_stats(). The first one is
at statistics.rst, and the second one at ethtool-netlink.rst.

Replace one of the references to use the name of the
function. The automarkup.py extension should create the
cross-references.

Solves this warning:

	../Documentation/networking/ethtool-netlink.rst: WARNING: Duplicate C declaration, also defined in 'networking/statistics'.
	Declaration is 'ethtool_pause_stats'.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/statistics.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index 8e15bc98830b..234abedc29b2 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -175,5 +175,4 @@ The following structures are internal to the kernel, their members are
 translated to netlink attributes when dumped. Drivers must not overwrite
 the statistics they don't report with 0.
 
-.. kernel-doc:: include/linux/ethtool.h
-    :identifiers: ethtool_pause_stats
+- ethtool_pause_stats()
-- 
2.26.2

