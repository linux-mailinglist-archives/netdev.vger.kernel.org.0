Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6318628A72D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 13:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgJKLS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 07:18:27 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24850 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgJKLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 07:18:06 -0400
X-IronPort-AV: E=Sophos;i="5.77,362,1596492000"; 
   d="scan'208";a="471985692"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 13:18:00 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Eric Dumazet <edumazet@google.com>
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] tcp: use semicolons rather than commas to separate statements
Date:   Sun, 11 Oct 2020 12:34:56 +0200
Message-Id: <1602412498-32025-4-git-send-email-Julia.Lawall@inria.fr>
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
 net/ipv4/tcp_input.c |    3 ++-
 net/ipv4/tcp_vegas.c |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 02d0e2fb77c0..7ff9be52c061 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4418,7 +4418,8 @@ static void tcp_sack_maybe_coalesce(struct tcp_sock *tp)
 				sp[i] = sp[i + 1];
 			continue;
 		}
-		this_sack++, swalk++;
+		this_sack++;
+		swalk++;
 	}
 }
 
diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index 3f51e781562a..c8003c8aad2c 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -293,10 +293,10 @@ size_t tcp_vegas_get_info(struct sock *sk, u32 ext, int *attr,
 	const struct vegas *ca = inet_csk_ca(sk);
 
 	if (ext & (1 << (INET_DIAG_VEGASINFO - 1))) {
-		info->vegas.tcpv_enabled = ca->doing_vegas_now,
-		info->vegas.tcpv_rttcnt = ca->cntRTT,
-		info->vegas.tcpv_rtt = ca->baseRTT,
-		info->vegas.tcpv_minrtt = ca->minRTT,
+		info->vegas.tcpv_enabled = ca->doing_vegas_now;
+		info->vegas.tcpv_rttcnt = ca->cntRTT;
+		info->vegas.tcpv_rtt = ca->baseRTT;
+		info->vegas.tcpv_minrtt = ca->minRTT;
 
 		*attr = INET_DIAG_VEGASINFO;
 		return sizeof(struct tcpvegas_info);

