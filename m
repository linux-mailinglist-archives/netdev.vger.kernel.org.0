Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2986F5F467E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJDPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDPUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:20:51 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34A113F21;
        Tue,  4 Oct 2022 08:20:48 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 274A918847D5;
        Tue,  4 Oct 2022 15:20:46 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 1C11425002BC;
        Tue,  4 Oct 2022 15:20:46 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 1361F9EC000E; Tue,  4 Oct 2022 15:20:46 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 2858B9EC000C;
        Tue,  4 Oct 2022 15:20:45 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2 iproute2-next 1/4] include: uapi: MacAuth and Blackhole feature header changes
Date:   Tue,  4 Oct 2022 17:20:33 +0200
Message-Id: <20221004152036.7848-1-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/neighbour.h | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 7494cffb..58a002de 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -559,6 +559,7 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
+	IFLA_BRPORT_MAB,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index a998bf76..cc7d540e 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -52,7 +52,9 @@ enum {
 #define NTF_STICKY	(1 << 6)
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
-#define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_MANAGED		(1 << 0)
+#define NTF_EXT_LOCKED		(1 << 1)
+#define NTF_EXT_BLACKHOLE	(1 << 2)
 
 /*
  *	Neighbor Cache Entry States.
@@ -86,6 +88,13 @@ enum {
  * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
  * of a user space control plane, and automatically refreshed so that (if
  * possible) they remain in NUD_REACHABLE state.
+ *
+ * NTF_EXT_LOCKED flagged FDB entries are placeholder entries used with the
+ * locked port feature, that ensures that an entry exists while at the same
+ * time dropping packets on ingress with src MAC and VID matching the entry.
+ *
+ * NTF_EXT_BLACKHOLE flagged FDB entries ensure that no forwarding is allowed
+ * from any port to the destination MAC, VID pair associated with it.
  */
 
 struct nda_cacheinfo {
-- 
2.34.1

