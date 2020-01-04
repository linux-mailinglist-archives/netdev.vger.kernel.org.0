Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C4F130422
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgADTwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:52:43 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:41373 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADTwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:52:43 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MJV9S-1j7YAs0R3Y-00JqFP; Sat, 04 Jan 2020 20:52:10 +0100
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
Subject: [PATCH 2/8] net: 8021q: use netdev_info()/netdev_warn()
Date:   Sat,  4 Jan 2020 20:51:25 +0100
Message-Id: <20200104195131.16577-2-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:sII3sd+wAXxopdb+aGUSdZZDceab3H6iWERVKQ21GCwVBVN0jEy
 vXIuJeLzFn5cN7w0XI1lKFW+8+KRNNh0gA9SBFPF6vrHCwtZNy24KTZG9DFXIu+n0RGEv/1
 NhD3AGIBV8sB0+B6wYWtrFKwlGIf0d2v4OuKoIF7S/XSSgPxOm0HOboYmF127tdWuGKzbL9
 nV55+eez0woQJgnZvGeig==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yXfxtrJnhDI=:b46FVkGMU4kbB/sxNgvbbs
 B+EkLVW0kikn2DKil2Ns104vp2e6/WkkAZ4e/bsiEeFnq2dCWNvIluzXgMdagBo6J1w7SueeN
 rBTlpklQDeBe/SZnhdzFBAJSclLIIZsdBAYUYS62qgVTvl2CpbMXSfWSyVzglqUX1UyElzlYd
 n9Rsdt3NfJ1aH1sxjNCtfdY3DMRvRudr89gjYxlQXPqWrDplOt84KJaf9Z7SxpiuBhLzyq+iG
 SV3eIIfgLhCALG9qrfkVBSfnKygskQgq/PwFv+Pj8iRQPH7jJ6lKIdMKFT792YGZffQDWOKTi
 OQivIvDx5PwumtgqtNdIvJ78GjgNPm7cq1fMnGtHW8XPA4TSjNE6xinxjzxbZYj5ZQlIYkQo3
 MbCGIc/ksmksgZRhDTamCYZmjupj5WjChtRcwVklufb/bxH33RLi6eEE1KB9enh++2+ezLqTo
 eTCq3oDLyvVbBE0d8WEP+MJwYBg8cC4N0NMkju05r02+0TvxvsRqsXXzCYH9h0dRa64CeG6nG
 vHX+jGW5vDTJiH4AuiFmsT5hmVSHF+M7jBag9YY/5QnUDNAS1wRI85kmejPOnTe/cu6PwJb3M
 WSZ59OR5bUx0IuSNvhEmqlyOcOuXr/Y+A9Yo51p7SIilNebwA3XZz5qC0X8YOF9hN3zwkQ5tX
 ZlN2Es1cdaxq7HPycRbvzVQYysLYAwXRpcnfjFMqAsnA80teo4JEG2+D0ObYDnjy9qvRBSEsJ
 koQkaCVvi0CQvDM81cBQE6ubYTQQfgSWoQ+C0y4DWPsOcAyj6ZN1S/XSldiPvkpWO8HMjO/Cm
 o9ruP9P90pvHbDttgSUz+UoKxXAXPwL/trpIgL05E/0lMf7D5JjMUUAPbiVT7Yjy+OgAGvcu9
 Oyv+63x4biWNXetQKC4g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_info() / netdev_warn() instead of pr_info() / pr_warn()
for more consistent log output.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/8021q/vlan.c      | 4 ++--
 net/8021q/vlan_core.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index ded7bf7229cf..7f18c8406ff8 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -123,7 +123,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
 	const char *name = real_dev->name;
 
 	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
-		pr_info("VLANs not supported on %s\n", name);
+		netdev_info(real_dev, "VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
 	}
@@ -376,7 +376,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 
 	if ((event == NETDEV_UP) &&
 	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
-		pr_info("adding VLAN 0 to HW filter on device %s\n",
+		netdev_info(dev, "adding VLAN 0 to HW filter on device %s\n",
 			dev->name);
 		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
 	}
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index a313165e7a67..bc32b33e0da8 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -360,7 +360,7 @@ static void __vlan_vid_del(struct vlan_info *vlan_info,
 
 	err = vlan_kill_rx_filter_info(dev, proto, vid);
 	if (err)
-		pr_warn("failed to kill vid %04x/%d for device %s\n",
+		netdev_warn(dev, "failed to kill vid %04x/%d for device %s\n",
 			proto, vid, dev->name);
 
 	list_del(&vid_info->list);
-- 
2.11.0

