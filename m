Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA17117986
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfLIWjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:39:07 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33901 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbfLIWjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:39:05 -0500
Received: by mail-ot1-f68.google.com with SMTP id a15so13788214otf.1;
        Mon, 09 Dec 2019 14:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vck/uz8o9EPjsxRkE6GQtWk8nbm1J4z1jJPNcEvOqWg=;
        b=a8YU+qS++2knEHMlOc+nw3NJtqut3I8pGET8GO21Ff2xdG8dWyfqtbWNmgNw8NoKLb
         nkrDfz5QgDLNYrvX3ONFX1LUfLHjiRtyF2IDMdlfz7ZlChFKT8ukVP7bn+5N9IWAg3Tj
         bthKywChcRNJyUqMx3RfUmSyip5B2uwN2XkA+zU6NahPqvigsNNFIgtKl7O5DMRhk105
         M6cPxt37Mb3q/fWqLbA10wakNOxe5nQGXzmHRlJfss4qN4DUpyFgA+X0ZpGA1SNnWeC5
         BKYPnS7rAwobuaRvSPEm7HX1zNm6Hb/auGvFtexVEV4jAXcYBQ9Rnbxs+HYNN9dDv0ZX
         vQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vck/uz8o9EPjsxRkE6GQtWk8nbm1J4z1jJPNcEvOqWg=;
        b=pPUo7VWV/xOOR2Xgism8CyRYGv0giRYLzWOzeEg0D8SstykeowTQZagCIvH5U5XIT0
         8ENsemv9rRiUl1Tc5cBlpilkLkb9YTWnoinRjRBai0jEf6e03D/ijQEP819UaLbJlI6/
         /+6mBLhfV5weW5N5rXHxyuh5hgbIX7lX6FYoZxSly1VPpW4lSrAU2X3zYsv9IvjYpaJk
         0buusNbxiRb6j4GJycMY+hfdoQaU5YzRtQ0kMiYb8/j6lz9+wvGNLwKAgCm/bJ1QaV1m
         4CoHpkJJEIzx55D1pWZkChZnO4Ij99uYhGSSThZNADlCIVNNwjawHk7CC9rzvlmy4uoO
         1wRQ==
X-Gm-Message-State: APjAAAX6AagO53mU+c+gtVS4tRpy39+QFNno9e2qHPSUryRQpQOebl9m
        GC4IEj0oZftmwikie6PgAuQ=
X-Google-Smtp-Source: APXvYqxh+Djr3wCr0RmQULGU3DV8YZikbsk/kXIuHXrcFJE9DOzbqaYQkElg7aLDkyEGoXTZBlPnzw==
X-Received: by 2002:a9d:68ca:: with SMTP id i10mr22651207oto.178.1575931144149;
        Mon, 09 Dec 2019 14:39:04 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id w8sm504104ote.80.2019.12.09.14.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 14:39:03 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] ppp: Adjust indentation into ppp_async_input
Date:   Mon,  9 Dec 2019 15:38:59 -0700
Message-Id: <20191209223859.19013-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

../drivers/net/ppp/ppp_async.c:877:6: warning: misleading indentation;
statement is not part of the previous 'if' [-Wmisleading-indentation]
                                ap->rpkt = skb;
                                ^
../drivers/net/ppp/ppp_async.c:875:5: note: previous statement is here
                                if (!skb)
                                ^
1 warning generated.

This warning occurs because there is a space before the tab on this
line. Clean up this entire block's indentation so that it is consistent
with the Linux kernel coding style and clang no longer warns.

Fixes: 6722e78c9005 ("[PPP]: handle misaligned accesses")
Link: https://github.com/ClangBuiltLinux/linux/issues/800
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ppp/ppp_async.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index a7b9cf3269bf..29a0917a81e6 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -874,15 +874,15 @@ ppp_async_input(struct asyncppp *ap, const unsigned char *buf,
 				skb = dev_alloc_skb(ap->mru + PPP_HDRLEN + 2);
 				if (!skb)
 					goto nomem;
- 				ap->rpkt = skb;
- 			}
- 			if (skb->len == 0) {
- 				/* Try to get the payload 4-byte aligned.
- 				 * This should match the
- 				 * PPP_ALLSTATIONS/PPP_UI/compressed tests in
- 				 * process_input_packet, but we do not have
- 				 * enough chars here to test buf[1] and buf[2].
- 				 */
+				ap->rpkt = skb;
+			}
+			if (skb->len == 0) {
+				/* Try to get the payload 4-byte aligned.
+				 * This should match the
+				 * PPP_ALLSTATIONS/PPP_UI/compressed tests in
+				 * process_input_packet, but we do not have
+				 * enough chars here to test buf[1] and buf[2].
+				 */
 				if (buf[0] != PPP_ALLSTATIONS)
 					skb_reserve(skb, 2 + (buf[0] & 1));
 			}
-- 
2.24.0

