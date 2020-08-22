Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9247724EA56
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgHVXQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbgHVXQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:30 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DDCC061573;
        Sat, 22 Aug 2020 16:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3L/UsgXFqsCf4W0xBIw/XFmX/HWp9gaIOQiCvn/gjeI=; b=TjPviCgXdKtGKO/xSg7eevO5PW
        QI9KPF0JpYDe7Ly7rx8hbl2ZhtQ8vNUwo5nbVqyd4OvX285vXcyXHU2tWG1Z5Tga4jlXa3XCWqoEE
        zp/JHVb3xj2XCvuL1xOhYo6hcI9pqI46fgtbEv8LksmT8utUhHZXGvSGNZzYriWgFXpmNzU26qHRU
        yKX7SjdTDAqU1Vq0UL7gT5hgJszRnY4Ur/qlI7YdET28netI/mHUnhJNAZg4PhVWqR1L3oVcm86vX
        JHw2yUxMpNpz7GE2QxMuz4c4kRWKAcRCIpmnVV839gH9GUwVjcEXFQKWlFuqYBrUiE3YUqAAnQpBS
        KFO/An6g==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ckN-0006VD-U1; Sat, 22 Aug 2020 23:16:28 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7/7] net: sctp: ulpqueue.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:16:01 -0700
Message-Id: <20200822231601.32125-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "an".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/ulpqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/sctp/ulpqueue.c
+++ linux-next-20200731/net/sctp/ulpqueue.c
@@ -740,7 +740,7 @@ static void sctp_ulpq_reasm_drain(struct
 
 
 /* Helper function to gather skbs that have possibly become
- * ordered by an an incoming chunk.
+ * ordered by an incoming chunk.
  */
 static void sctp_ulpq_retrieve_ordered(struct sctp_ulpq *ulpq,
 					      struct sctp_ulpevent *event)
