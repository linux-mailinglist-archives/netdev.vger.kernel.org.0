Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD3E27E977
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 15:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgI3NZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 09:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbgI3NZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 09:25:21 -0400
Received: from mail.kernel.org (unknown [95.90.213.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F39FA2388B;
        Wed, 30 Sep 2020 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601472321;
        bh=aku/UqgSvnZLntkwVHFchuchgI6ne7BFwihXevm3wEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRvbXM29gZvbbjWLi9QF+sw/R1VV46gD7TI3UY5fvZewJDUOMeczox30v6lZlSmhH
         sVTVKmKVUHQ6dlvMrHzCol+BxC98pWiG12+HSz0FQp0e8Dzz9lSv/wpqVB6WJPODKT
         anOR4KTtjORA+EPrakngwk/2LRa80KW3Wb+/K/Ys=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kNc6h-001XKL-41; Wed, 30 Sep 2020 15:25:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 33/52] docs: net: statistics.rst: remove a duplicated kernel-doc
Date:   Wed, 30 Sep 2020 15:24:56 +0200
Message-Id: <c484b653417a3ba2c0eb7bb70331397577a71980.1601467849.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601467849.git.mchehab+huawei@kernel.org>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
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

