Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF12CBD7D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgLBMxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:53:39 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:38683 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbgLBMxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:53:14 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MI5YN-1kvlb82jyB-00FBkq; Wed, 02 Dec 2020 13:50:13 +0100
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
Subject: [PATCH 6/7] net: vmw_vsock: remove unneeded MODULE_VERSION() usage
Date:   Wed,  2 Dec 2020 13:49:58 +0100
Message-Id: <20201202124959.29209-6-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201202124959.29209-1-info@metux.net>
References: <20201202124959.29209-1-info@metux.net>
X-Provags-ID: V03:K1:JrtHV4ba+Vzg45sX9On6dHBZwYlVhTFEdroSCZvyP+aBnSbQBXM
 K0miwa0qLFHJBgYzZmCP9eydB3vGM8EnjrwOkClSzu5+r2ddrtB5K542VsEvyqhGAm5RzGs
 jj9R2YVcRl+T8Y1fOcAII4sRctrWUs1KUvs9mPWHL5LcfeEXGS7/LaxkR6jaB5MFtLcTnyK
 llwJKlQXZXamp0rrfPvrQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UV6JIMI1vE8=:SWYkxoFIsY3VJL/8CDs6SV
 3gi8GpPr9LiYpaZFynhJ6Uc5pD8+d4tb25Qg5NVbMt1xw+A4ERzvl4dgI5aE2BIPbtRimL9tm
 XsU3aBUwqQlTXtY1rpJys3P1+Zi2/zMMZX50L7e5rdz21Jz/pX0khoiCsY6EsFGUIfGAZH2dn
 /BE7jvbpZpvZsatJVWRsPGDGtECat2xJYajafX2kO+VJMpRPLRoiEKmOqsmvD+qp6QNClaJ6E
 2A5eiPxRChUYhw6m/lK4Tc4Of0ksICksfovjizsgBhiV5X1S1EDdDPKl1bPvJxKcEMgL+ek2o
 1d0N0RIGRcmqchRga+y465w1P2ZM5DNc1ISPYPQ9Nfh73EamjgIiqtdl3JA3E1KlyCjc+4+o8
 QMbUEYwPYkq83FiyaaxZxaGvT4AbYkFdMv0HIJu/CkrW0MaUbWZ+xfSwfrAtV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/vmw_vsock/af_vsock.c         | 1 -
 net/vmw_vsock/hyperv_transport.c | 1 -
 net/vmw_vsock/vmci_transport.c   | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d10916ab4526..cc196ffba3ed 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2238,5 +2238,4 @@ module_exit(vsock_exit);
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Virtual Socket Family");
-MODULE_VERSION("1.0.2.0-k");
 MODULE_LICENSE("GPL v2");
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 630b851f8150..dae562f40896 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -929,6 +929,5 @@ module_init(hvs_init);
 module_exit(hvs_exit);
 
 MODULE_DESCRIPTION("Hyper-V Sockets");
-MODULE_VERSION("1.0.0");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_VSOCK);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 8b65323207db..bd39cca58ee6 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2140,7 +2140,6 @@ module_exit(vmci_transport_exit);
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMCI transport for Virtual Sockets");
-MODULE_VERSION("1.0.5.0-k");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("vmware_vsock");
 MODULE_ALIAS_NETPROTO(PF_VSOCK);
-- 
2.11.0

