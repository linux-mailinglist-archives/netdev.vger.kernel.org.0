Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0800F230FF3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbgG1Qis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731367AbgG1Qis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:38:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A5C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0SU9KSJHS41rnmPJ873SKoJIqeS2DLG4z1bZc3w4rEY=; b=wW1PtlsU6wlYkRAGdM6mfYZCvh
        joZgcKbX2JIyw05g2wwxUTnxdKHWwoucu2ioHDyDEUxbgEkEsMrIi6ujnr2TjECzSlpWFieD4THgc
        mBRt9x1p3kyIQGdB3Jm2JEV54GzLwf3PWJYIWJi05//yAk6Zf6DZd+nQud7qIdNyqUz5Jgeh+4IYZ
        nzP4dZJT6uGMcY/aLkuY3H6d49F3K4aF+OcdOFXu8ienWbxR6JwkV9qm6Wa0GHnG1/y4cG6xTtjAB
        LBoF5SQjGWSmoYBxNbogvHGpEe6QHsUYTyEVR1eLStCD8WMheX106sqqCsEZ6pxi01ZOPfKdvGu/y
        K2LcTs1A==;
Received: from [2001:4bb8:180:6102:fd04:50d8:4827:5508] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Sch-0007WR-2w; Tue, 28 Jul 2020 16:38:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: [PATCH 1/4] netfilter: arp_tables: restore a SPDX identifier
Date:   Tue, 28 Jul 2020 18:38:33 +0200
Message-Id: <20200728163836.562074-2-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728163836.562074-1-hch@lst.de>
References: <20200728163836.562074-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was accidentally removed in an unrelated commit.

Fixes: c2f12630c60f ("netfilter: switch nf_setsockopt to sockptr_t")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/netfilter/arp_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f5b26ef1782001..9a1567dbc022b6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1,4 +1,4 @@
-
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Packet matching code for ARP packets.
  *
-- 
2.27.0

