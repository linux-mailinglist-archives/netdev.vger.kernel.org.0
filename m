Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124C424EA40
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgHVXN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgHVXNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:13:53 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F5AC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=v0B/+HI6ggac/A7ReSzJ51fZmoHn2VaJGqjN9k4WXks=; b=z20ZptkkIquGhsNSoJIetLFhpc
        6TVl658IxST5bhwlHPgFKqalvYMpwQDlG6jTQdYA7fPDGmo3aCp6k6cm5ozgimExkxEq+3vIdvGGV
        EfFiVqzEJidvz4WqPDmUnZdw0I90t1whRGHN7atoVTmSe6XzIU7aC6j9AOtdmjthyhRy3wfxYhPtS
        LEVstbZzDBijr1iQxXTSbpnZursozFayZdukEQZFp639WRsyf57r8cfO0329JHVzjk3C0bmRA01Dc
        P5K88G5tbwoNXtTji3pfXrTtkVEZbYFlqaFGy170fTDzwynupHwmM8ir6DQio0ChoMOGeE6E4B8SG
        dz1Gljqw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9chq-0006Nf-OV; Sat, 22 Aug 2020 23:13:51 +0000
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
Subject: [PATCH 3/8] net: batman-adv: hard-interface.c: delete duplicated word + fix punctuation
Date:   Sat, 22 Aug 2020 16:13:30 -0700
Message-Id: <20200822231335.31304-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "table".
End a sentence with a period.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/hard-interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/batman-adv/hard-interface.c
+++ linux-next-20200731/net/batman-adv/hard-interface.c
@@ -599,7 +599,7 @@ out:
 	/* report to the other components the maximum amount of bytes that
 	 * batman-adv can send over the wire (without considering the payload
 	 * overhead). For example, this value is used by TT to compute the
-	 * maximum local table table size
+	 * maximum local table size.
 	 */
 	atomic_set(&bat_priv->packet_size_max, min_mtu);
 
