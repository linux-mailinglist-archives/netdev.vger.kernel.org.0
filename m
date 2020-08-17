Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BBA247A9B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbgHQWom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 18:44:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45588 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729273AbgHQWok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 18:44:40 -0400
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k7nre-0000Pw-63; Mon, 17 Aug 2020 22:44:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ipv4: remove duplicate "the the" phrase in Kconfig text
Date:   Mon, 17 Aug 2020 23:44:25 +0100
Message-Id: <20200817224425.5988-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The Kconfig help text contains the phrase "the the" in the help
text. Fix this and reformat the block of help text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/ipv4/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 60db5a6487cc..87983e70f03f 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -661,13 +661,13 @@ config TCP_CONG_BBR
 
 	  BBR (Bottleneck Bandwidth and RTT) TCP congestion control aims to
 	  maximize network utilization and minimize queues. It builds an explicit
-	  model of the the bottleneck delivery rate and path round-trip
-	  propagation delay. It tolerates packet loss and delay unrelated to
-	  congestion. It can operate over LAN, WAN, cellular, wifi, or cable
-	  modem links. It can coexist with flows that use loss-based congestion
-	  control, and can operate with shallow buffers, deep buffers,
-	  bufferbloat, policers, or AQM schemes that do not provide a delay
-	  signal. It requires the fq ("Fair Queue") pacing packet scheduler.
+	  model of the bottleneck delivery rate and path round-trip propagation
+	  delay. It tolerates packet loss and delay unrelated to congestion. It
+	  can operate over LAN, WAN, cellular, wifi, or cable modem links. It can
+	  coexist with flows that use loss-based congestion control, and can
+	  operate with shallow buffers, deep buffers, bufferbloat, policers, or
+	  AQM schemes that do not provide a delay signal. It requires the fq
+	  ("Fair Queue") pacing packet scheduler.
 
 choice
 	prompt "Default TCP congestion control"
-- 
2.27.0

