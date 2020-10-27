Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C404D29A8B5
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896049AbgJ0Jvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896016AbgJ0Jvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 05:51:42 -0400
Received: from mail.kernel.org (ip5f5ad5af.dynamic.kabel-deutschland.de [95.90.213.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1538222281;
        Tue, 27 Oct 2020 09:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603792301;
        bh=ReWeQAdsRgO/jyvpQynk0BfIa0k5iD1zUW77cmoS650=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/9L0f+MLYRhC0rfqKIdEb8GZj3fWf5Q/v8BXO5hb4DJyx00Ews0VN6jvCrUwbTZr
         F+3vJ0xAfK/NHNocCJkRJPzTW3lyVKl6uARYKRXClnTukxKEn02U3v+lRk6p5ONThJ
         0C4mGwmmPpCJSaemaCgkc+9y0FNqaoliqsYEPUpU=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kXLdj-003FEi-3U; Tue, 27 Oct 2020 10:51:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 06/32] docs: net: statistics.rst: remove a duplicated kernel-doc
Date:   Tue, 27 Oct 2020 10:51:10 +0100
Message-Id: <fdbf853bbdaf3bc1d38f32744b739d175c5c31f5.1603791716.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603791716.git.mchehab+huawei@kernel.org>
References: <cover.1603791716.git.mchehab+huawei@kernel.org>
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

