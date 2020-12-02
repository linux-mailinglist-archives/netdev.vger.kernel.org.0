Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5472CBD77
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388793AbgLBMxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:53:25 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:38075 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLBMxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:53:23 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1McH1Q-1kCCAH3wiK-00cdol; Wed, 02 Dec 2020 13:50:10 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jmaloy@redhat.com, ying.xue@windriver.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 3/7] net: ipv4: remove unneeded MODULE_VERSION() usage
Date:   Wed,  2 Dec 2020 13:49:55 +0100
Message-Id: <20201202124959.29209-3-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201202124959.29209-1-info@metux.net>
References: <20201202124959.29209-1-info@metux.net>
X-Provags-ID: V03:K1:bthYXGIMbp7XkyEKltam6k4TFGDy+3Gd50QFJXDN3LpygfQn9n0
 dQdDyG2euqqZPfURQ7AETZrHqc7Q3bb8mkzsXXBVL/zbCKBjsT9kgwcpZXL15cpsLLgMMok
 R8Y/Gc6lPCNa0Yd4GVabJpwXORxicX639M42bx62mGQucD7QkaD/p0nB7zBnyobtW90Gbl2
 rDJ2J5fgOj0YfQrmuwuTg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pj4aYPVMf9E=:I2x2S0JUcBDjT2nXrnAsht
 PCs4y11wa6R7HTxYE0o1nK7iph7LPgsD4MkZtykxIrecJ96jWjIvYrN3fE1jHiH2k33faGakQ
 X8dxQpQiecDSjOGY2yi6GzMCG8K2Y5c8lEMj0BjA6o1WtBWSDD47RW3LPKDe2L6oHhgnhx8tj
 m6B29lxrsPTNfvVc5v7LwL9zi4+izBEsFUafXXbGB19tc3FkWze4L+m64vFHcyn6GryJRdH+w
 OPZCpcHh6nTGlX4bubPxTyqYLhKWGJVO0gf6BWWwfxjZeu2Ig8n7d3pWrPiwU24iTb3egGk3H
 YCebTi0bSl7usWiu9djb8acLhVec2x1nojBoB7EW0w3mkM9xZggdQAA8HOnlguHBlVOLU72W2
 Smzmhj5aAnDj1bFigAL5IcbJuc12fj5dDbx4lfRahOMlip33KqUkGspWCJW46
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/ipv4/tcp_cubic.c    | 1 -
 net/ipv4/tcp_illinois.c | 1 -
 net/ipv4/tcp_nv.c       | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index c7bf5b26bf0c..c6bcd445df04 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -537,4 +537,3 @@ module_exit(cubictcp_unregister);
 MODULE_AUTHOR("Sangtae Ha, Stephen Hemminger");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CUBIC TCP");
-MODULE_VERSION("2.3");
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 00e54873213e..8cc9967e82ef 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -355,4 +355,3 @@ module_exit(tcp_illinois_unregister);
 MODULE_AUTHOR("Stephen Hemminger, Shao Liu");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TCP Illinois");
-MODULE_VERSION("1.0");
diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
index 95db7a11ba2a..b3879fb24d33 100644
--- a/net/ipv4/tcp_nv.c
+++ b/net/ipv4/tcp_nv.c
@@ -499,4 +499,3 @@ module_exit(tcpnv_unregister);
 MODULE_AUTHOR("Lawrence Brakmo");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TCP NV");
-MODULE_VERSION("1.0");
-- 
2.11.0

