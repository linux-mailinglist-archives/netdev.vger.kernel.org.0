Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6106526F52F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgIREfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIREfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AFBC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tS6kEYellGEptbXY5BXH8Ozb79O6/CoU/yM1JjcttNQ=; b=GUJ/kYAMXSXM0jkkRm4Od6K3e1
        4o/IVnh2hexNZGNPFMGi77w5tzFHi1dXWo1E5JwD4ieRR0WCgqc7i/SbvmMcfqtlmE4KQJorXV1Yv
        Ok6P5mdNa3wajf1VCYrMxvsTOLIRkSLYfTaYv9FqkFs8EuZCEwdiFx66r8V4avZp6ox+pdb7KOKZY
        y3NXSS6ntUesSRREwrn9ZAnlEQRYYuXwG6DqDBnkkpk9boCuJZddT8DBUL+FCDSzKlhzfT2E2YrKo
        IMqcdddPJMgmMn1tbYfwlBqeNlmM97rkYFawaCkCmo54ohVfwu1fKISxizPjRbxIoanSYoJp2uQ6c
        c3JgZnKw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87R-0003Ci-My; Fri, 18 Sep 2020 04:35:34 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH 4/7 net-next] net: bluetooth: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:18 -0700
Message-Id: <20200918043521.17346-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/bluetooth/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
---
 net/bluetooth/hci_conn.c |    2 +-
 net/bluetooth/hci_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/bluetooth/hci_conn.c
+++ linux-next-20200917/net/bluetooth/hci_conn.c
@@ -1388,7 +1388,7 @@ static int hci_conn_auth(struct hci_conn
 	return 0;
 }
 
-/* Encrypt the the link */
+/* Encrypt the link */
 static void hci_conn_encrypt(struct hci_conn *conn)
 {
 	BT_DBG("hcon %p", conn);
--- linux-next-20200917.orig/net/bluetooth/hci_core.c
+++ linux-next-20200917/net/bluetooth/hci_core.c
@@ -808,7 +808,7 @@ static int hci_init4_req(struct hci_requ
 	 * Delete Stored Link Key command. They are clearly indicating its
 	 * absence in the bit mask of supported commands.
 	 *
-	 * Check the supported commands and only if the the command is marked
+	 * Check the supported commands and only if the command is marked
 	 * as supported send it. If not supported assume that the controller
 	 * does not have actual support for stored link keys which makes this
 	 * command redundant anyway.
