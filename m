Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCC824EA45
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgHVXON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbgHVXOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:14:10 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A06C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=S+FPpVijMG08FT12uXFjTaQyoZqQXqUSzSZgfsXA7u8=; b=LJgTBaMvmoNXi8acOHxw7tC91L
        ykgr3Vgr5ngzxZ2Qim7bc31cFcJmbD0CLpom8NbTwN+EpUg392XK5ws2BJVoZ6Qcr5aEtIdXE0Xap
        ITgpT8xZMuHl2iJvcpx+kGSI8u/eYgfPcgbQezozDFFcSoLW5JHdI2vgIjb0J1QDYvl0yv+M2XA8F
        9IahxImuLsDS0kKh/VpufWcozrt6ul+ePmsznpZ9cAKUHdu2tC5Txo1CdzYkN0jSzLFmXDELJuxdf
        GbVCgIt9v/p446I1Oce5F1VInb/pT9jkWHoW409pYYgSjRm5G9n28B5Iv71mAg/FuOrbEghKuPt+N
        SHJsXVMg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ci7-0006Nf-72; Sat, 22 Aug 2020 23:14:07 +0000
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
Subject: [PATCH 8/8] net: batman-adv: types.h: delete duplicated words
Date:   Sat, 22 Aug 2020 16:13:35 -0700
Message-Id: <20200822231335.31304-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated words "time" and "address".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/batman-adv/types.h
+++ linux-next-20200731/net/batman-adv/types.h
@@ -1492,7 +1492,7 @@ struct batadv_tp_vars {
 	/** @unacked_lock: protect unacked_list */
 	spinlock_t unacked_lock;
 
-	/** @last_recv_time: time time (jiffies) a msg was received */
+	/** @last_recv_time: time (jiffies) a msg was received */
 	unsigned long last_recv_time;
 
 	/** @refcount: number of context where the object is used */
@@ -1996,7 +1996,7 @@ struct batadv_tt_change_node {
  */
 struct batadv_tt_req_node {
 	/**
-	 * @addr: mac address address of the originator this request was sent to
+	 * @addr: mac address of the originator this request was sent to
 	 */
 	u8 addr[ETH_ALEN];
 
