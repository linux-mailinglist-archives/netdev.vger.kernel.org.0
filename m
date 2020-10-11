Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BAF28A730
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgJKLSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 07:18:35 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24868 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729878AbgJKLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 07:18:06 -0400
X-IronPort-AV: E=Sophos;i="5.77,362,1596492000"; 
   d="scan'208";a="471985693"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 13:18:00 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Paul Moore <paul@paul-moore.com>
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] net/ipv6: use semicolons rather than commas to separate statements
Date:   Sun, 11 Oct 2020 12:34:57 +0200
Message-Id: <1602412498-32025-5-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
References: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace commas with semicolons.  Commas introduce unnecessary
variability in the code structure and are hard to see.  What is done
is essentially described by the following Coccinelle semantic patch
(http://coccinelle.lip6.fr/):

// <smpl>
@@ expression e1,e2; @@
e1
-,
+;
e2
... when any
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/ipv6/calipso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 8d3f66c310db..78f766019b7e 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -761,7 +761,7 @@ static int calipso_genopt(unsigned char *buf, u32 start, u32 buf_len,
 	calipso[1] = len - 2;
 	*(__be32 *)(calipso + 2) = htonl(doi_def->doi);
 	calipso[6] = (len - CALIPSO_HDR_LEN) / 4;
-	calipso[7] = secattr->attr.mls.lvl,
+	calipso[7] = secattr->attr.mls.lvl;
 	crc = ~crc_ccitt(0xffff, calipso, len);
 	calipso[8] = crc & 0xff;
 	calipso[9] = (crc >> 8) & 0xff;

