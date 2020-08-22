Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD824EA3D
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgHVXNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgHVXNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:13:49 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91F4C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=clDOXbnck/TQTfZEav1cvaV06z3YPUix8kx6bmElCX4=; b=DkUvPcvlFUvJQ+YGZ5nNo2VhKL
        YnWwje2jF4Rhdn+p5MvQxLmBPp+7EmpEST1c2pDYHFYemhbjlyhEo6oh+vZOKPmj+EtNUgEk+oy7v
        pbjwlJmeNw8szvRsrX+GGvlDaxO+EVAoIgJKnscGUYJh2tZPwFiQqoj+lCEt2wAupOcVEn6gbTDKG
        qpFi5Li4dqe72wgvm4gjFMGkx3NfGZbvfudgJAy7Edcn8FsyTWahzNfUoLLmd59UNxTr0rBsCqLbS
        7v1XEb7C+qeS4j44MjgHsM3hEvigWoWL9z1hdWAnIqTVPKIy2ZbbJFSBlu0GS72DHXZkHX/YpshO3
        HjhaBV2w==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9chk-0006Nf-7S; Sat, 22 Aug 2020 23:13:44 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/8] net: batman-adv: bridge_loop_avoidance.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:13:28 -0700
Message-Id: <20200822231335.31304-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "function".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/batman-adv/bridge_loop_avoidance.c
+++ linux-next-20200731/net/batman-adv/bridge_loop_avoidance.c
@@ -1795,7 +1795,7 @@ batadv_bla_loopdetect_check(struct batad
 
 	ret = queue_work(batadv_event_workqueue, &backbone_gw->report_work);
 
-	/* backbone_gw is unreferenced in the report work function function
+	/* backbone_gw is unreferenced in the report work function
 	 * if queue_work() call was successful
 	 */
 	if (!ret)
