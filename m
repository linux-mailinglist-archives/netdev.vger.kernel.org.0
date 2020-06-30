Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E64120F07A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 10:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgF3I1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 04:27:55 -0400
Received: from simonwunderlich.de ([79.140.42.25]:44310 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731425AbgF3I1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 04:27:54 -0400
Received: from kero.packetmixer.de (p4fd575ab.dip0.t-ipconnect.de [79.213.117.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 68E366205E;
        Tue, 30 Jun 2020 10:27:52 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/4] batman-adv: Switch mailing list subscription page
Date:   Tue, 30 Jun 2020 10:27:29 +0200
Message-Id: <20200630082731.2397-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200630082731.2397-1-sw@simonwunderlich.de>
References: <20200630082731.2397-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The mailman installation on lists.open-mesh.org was switched from mailman2
to mailman3. The URL to the subscription webpage changed in this process.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 Documentation/networking/batman-adv.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/batman-adv.rst b/Documentation/networking/batman-adv.rst
index 18020943ba25..02af49b08635 100644
--- a/Documentation/networking/batman-adv.rst
+++ b/Documentation/networking/batman-adv.rst
@@ -160,7 +160,7 @@ IRC:
   #batman on irc.freenode.org
 Mailing-list:
   b.a.t.m.a.n@open-mesh.org (optional subscription at
-  https://lists.open-mesh.org/mm/listinfo/b.a.t.m.a.n)
+  https://lists.open-mesh.org/mailman3/postorius/lists/b.a.t.m.a.n.lists.open-mesh.org/)
 
 You can also contact the Authors:
 
-- 
2.20.1

