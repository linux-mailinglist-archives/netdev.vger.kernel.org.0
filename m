Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451932CBD72
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388467AbgLBMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:53:23 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:56325 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgLBMxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:53:15 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mqrs9-1kO5Cx3RI1-00ms94; Wed, 02 Dec 2020 13:50:15 +0100
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
Subject: [PATCH 7/7] net: tipc: remove unneeded MODULE_VERSION() usage
Date:   Wed,  2 Dec 2020 13:49:59 +0100
Message-Id: <20201202124959.29209-7-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201202124959.29209-1-info@metux.net>
References: <20201202124959.29209-1-info@metux.net>
X-Provags-ID: V03:K1:cwkhICXDufJUAlJsovXQtZ2OyBFVeHR/za/rs5521Cqz6Wh9Ch/
 n2r+/y4jIDyugCIgF5g7uue0fRRFBkrAyTDehF8v0E6LX4lDErP3ysYD0NDeGmQjUjxxaaA
 nFTGgM784D7I7zKZoupqMvSxa0FalL9ALhRllLbOKOVQ+UZi3nlYdpHU6DqBP8RfgTXzRTu
 LRvkO/nAPYZIyscGn/SZA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jcGj6/3kF1g=:AqzM1phRwhfM1zwVGqFIvn
 uWCSSaCTm78/J3ALkHRgiZb5ARZR4qLcVPuAglVED3ww3ubpMwiyWf7eoeMePxvN9YwHwmBwQ
 7dgsTsUCBuzou/TciuwkTjiYBhyX1sqRrcs1mIKDHg1nlHN9uXk5Fer9dpimwnjB2Lf8WP+tT
 C4c85VVOmCHLVSZRCBUE72FDp6NhNUDKz6udiqAx97K9wUdDmXN7yv47xDTpjSLv6FB8tyxAg
 pWsukYJ/9Bvp+ZsPNH5nwCwoYH4Kj/NDGc36TJYRfJyZlBkLJu9Ndus7+Md+m8ic19+Hvbplz
 JOUWD0AqYJikwpiy4hDyeKd+Pf2Wb0CXhj326D0FAfCWcu5Yg9xOKLthZQHnolafWMe6HFAuo
 8cmGOi+jtiHZ5TFd9MGcS4kJ2UK96Q5ve873ySl8iqdwo32C6bso0YridYlmL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/tipc/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index c2ff42900b53..8c0c45347c53 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -227,4 +227,3 @@ module_exit(tipc_exit);
 
 MODULE_DESCRIPTION("TIPC: Transparent Inter Process Communication");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(TIPC_MOD_VER);
-- 
2.11.0

