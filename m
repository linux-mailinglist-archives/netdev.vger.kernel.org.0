Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1BE130435
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgADTxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:53:20 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:42201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgADTxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:53:19 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MqJuP-1jS6EH3CRH-00nRo8; Sat, 04 Jan 2020 20:52:14 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 7/8] net: vmw_vsock: remove unneeded MODULE_VERSION() usage
Date:   Sat,  4 Jan 2020 20:51:30 +0100
Message-Id: <20200104195131.16577-7-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:UTysyOOxsiPdVPKeBa5m/lJjiLYWW/Mu033dbYm6NG/oMc+j+aM
 o8+gaqw98Xrb+JaSKI3bjCkxM1a8CdUfW78TjAfonS5+h1ednSgOeJgFAoE2AI3RFulRNPq
 60Ytf3YA/QmCHPLG0ZgndpxN4mxEeO2kAH+XNtZLbSoY3FE20Cb5r20aYnT5yZkXAlnvBFB
 EH78RusR1Y0ZKzHvpQ3xA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7gZ90otsdiY=:6ljOagr0u/5Ta8Q9AnGbia
 eThvRWgPJZ0D5JTYJ08SAB6n/coUQ7XYfRWP9iSv/LuDM4bryBoAEiuIovCHxy2ABgw3hdW5l
 Vhdb1MuV+Bvr0/DF3iGwHfP+eO93nPjfEj48rss0+aSf71hFHH3vnhAhNe3YikJ2TT8iVhQvv
 HRzHxaxH+yrkNlcllp9I7qC6zehtvkVcAbgLaiBrNrQ0j8QPOCnq+hXrtISLrN9BHSjeP2mUz
 so48KWiC8o6XUo10XNHqmLipTsCl68Tdj/TCzc2xzu7jR3K/66FByMs8g+41NXPUua6dSxkRF
 jjkb9pbQsgoh+urZmo30pSagEpRnhc/dPYFa74iWxSiaTs/SNy4tvLpymN4Y/oPzJUa4tybbt
 dDHr7dPvJr/GtR8Iu+zuz3PKP7YA6z2xYfjN1Sd0+j8EhiWYh0wIBqhVzjDQygDwW/IHVGXiI
 Q9sktP3SGoJYL7sYYPcnL2ybJES/rw3NOBVZgg1bFn9yZSGoNNekcaMYVjV9OPtksQQNGsUlm
 gB0N7HRREFLaXKbsQMsGXHRPCZ9qbgP12J/Ufqfe46tmjsIY+gCBXcfcFn/70+ZYrctadbaP3
 SkugpysLsL55CuBUaQs4grj+ojw1N9fokUA579mGapdt6Z0nQk1pSjmWauMtvz2JHX3p2nYag
 jto/acHgGWNLwbDIZcV973j1eu6cVrXbKHRvQ1LRzlbbttOHy4zuDpf1JKjrxPj/0XrBK1HiH
 UWN9WL/0LYaN7jr7GtqUcLKxMX3uJTk/S+D6gKoQsSu1HecR2NNkSS4qVK+LdHqmE3k3dkARt
 Fgtaxh6mYPNjUo2JcNJfkReu1Cg0q7nA1N5tHw0N36f0ELej5/yLuPS/P7yF3glaF+eFCqtjX
 CMIMNYSTa2glsdoebTKw==
Sender: netdev-owner@vger.kernel.org
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
index 74db4cd637a7..7e0cd3220d42 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2203,5 +2203,4 @@ module_exit(vsock_exit);
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Virtual Socket Family");
-MODULE_VERSION("1.0.2.0-k");
 MODULE_LICENSE("GPL v2");
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index b3bdae74c243..f6cb66b62479 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -985,6 +985,5 @@ module_init(hvs_init);
 module_exit(hvs_exit);
 
 MODULE_DESCRIPTION("Hyper-V Sockets");
-MODULE_VERSION("1.0.0");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_VSOCK);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 644d32e43d23..f2f689b7ca9a 100644
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

