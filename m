Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD10C24EA50
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgHVXQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgHVXQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:20 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B78AC061573;
        Sat, 22 Aug 2020 16:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gdUf/hhWvkpYBoPnnLAIMvjxz9/l5TJRRSOCns8PMbI=; b=DsbTiGEj3nr8J4naewUkyr/SMo
        wS6UpL0T17pETTcJ+bBY5Yk7Ht/p6roUqEpXRT2IvOqyginKjJxT8tjFAZ2M4eCtt1exYmflSzxQS
        kt0ZzMHzH2vjuwP1VpBGLW5yGAgnBvVSlJD9/IwtSL/05fCc1J/pDazQ3zdCKCYRvWhqL/Q+NhP3i
        dI9u8r1fnoSBOjxhbGdWbiBQiWYRYWvqi5XiFVuuQ/BuBuHzFWFN7Q3b1zbKvI1JSLTQLseHk4c5u
        fMW99ntRzi8Km8kvENg8Xiy/3Cgb+gQG057wpkJqFLZofWOfRXsvawUVgd4MVtT0L+cEc+RnSnBBf
        8EJhnh7A==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ckE-0006VD-6A; Sat, 22 Aug 2020 23:16:18 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4/7] net: sctp: chunk.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:15:58 -0700
Message-Id: <20200822231601.32125-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "the".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/chunk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/sctp/chunk.c
+++ linux-next-20200731/net/sctp/chunk.c
@@ -179,7 +179,7 @@ struct sctp_datamsg *sctp_datamsg_from_u
 				    __func__, asoc, max_data);
 	}
 
-	/* If the the peer requested that we authenticate DATA chunks
+	/* If the peer requested that we authenticate DATA chunks
 	 * we need to account for bundling of the AUTH chunks along with
 	 * DATA.
 	 */
