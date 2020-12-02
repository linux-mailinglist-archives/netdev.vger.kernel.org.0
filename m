Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15CD2CBD73
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388746AbgLBMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:53:24 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54711 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbgLBMxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:53:23 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MGi6k-1kx9B018XS-00DoAz; Wed, 02 Dec 2020 13:50:12 +0100
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
Subject: [PATCH 5/7] net: bridge: remove unneeded MODULE_VERSION() usage
Date:   Wed,  2 Dec 2020 13:49:57 +0100
Message-Id: <20201202124959.29209-5-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201202124959.29209-1-info@metux.net>
References: <20201202124959.29209-1-info@metux.net>
X-Provags-ID: V03:K1:cuYtv5vslL3mKfntL9+LNoV+R1fAkyY8wxUdUqYvgUNH+fklE5n
 h9/W/Fkds8W/7VOKYoo5BIlVUv1XasthBQQJ/t8T8PS1lwTRtsL02fELoIEkxe4o0nWGLsy
 CN8CI7r/M3lBFezWUZKYqq3jWd3IQOjCLhN+m0I4TSbdIW0y3IOUe5ZWQMcOBoYiAfGe/AD
 8RRrRDnLBfX6L/eiwjJbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zxgM+5uXlUk=:pc3buvVoCR7nEPUYrJz5LF
 EysIamjRgMmr6hc3N03YgY6dedUyF+M8I6TRBaWJ0lR3GakVl9fBQsfTSGeuBoog56Hez/9l3
 etAr3MbgqVHs4R/0sJUuSX30nSgZax62lCL48USS4wl2ygFzzvnkB1oFNXISvbiLE0IELaeWt
 pv4OMUirWWerHvtecu935TKY4aCrwyuife0QQnsA7sUJFHl2GgCLcOh2BH0Hr4oJDnCZQLllK
 ojCoiVue3jDR/TaO+LBay4K0/H8L4dkw6qUVC92WGDQyv3lRoZ/TLy8U6heMh6Nngw77POB5J
 k1qSxnmfpUpwP2Npc0vkQzulInM1Zl/C552fpTKKIzMZrDk45XbuykAWkD4e3nz7v3CZHesbW
 3OHtjxPl8xZX92P3E2f9NlrGy/i5Wapn+U9z59kySKZfh5JdB8pgqpVHKeM+A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/bridge/br.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 401eeb9142eb..2502fdcbb8b2 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -399,5 +399,4 @@ static void __exit br_deinit(void)
 module_init(br_init)
 module_exit(br_deinit)
 MODULE_LICENSE("GPL");
-MODULE_VERSION(BR_VERSION);
 MODULE_ALIAS_RTNL_LINK("bridge");
-- 
2.11.0

