Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20612EEB87
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbhAHCzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbhAHCzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 21:55:32 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94844C0612F4;
        Thu,  7 Jan 2021 18:54:52 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id lj6so2885512pjb.0;
        Thu, 07 Jan 2021 18:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y35UHLlMiYde51iVKR+n3JoxvCegZU0uBAWABZsfWpo=;
        b=eQCBTdA+Ch3bNPD2oGxk0hSRW0ovBl0Rm0wBdTk4EF9lFur536Q3u8Bz4+dKmSdnD/
         gUbomYCApSVyXY1zOsWUrhc4oeqfl1+G1OZq40rz40oQeia16ACoHKNQvQETD5cwHPc1
         y5RaYEciKf2BXwKgAJX7j943LUu5EmFf/3LSTRmAG16s9nyBpVdLJXiKP/GzcRksI000
         QwVNOTwpmmfvL9/Ki+sc0Y75e4OqW+rHVb//19GumefJaqE9iOtFf9RPJayGRY5mtFB2
         J2ZrkqBPVnfZccL8vjU5y9ebewsKeGhwUE82pVOeHDOo0Bvd8SUfd/JvSwOaJ1uoc1HB
         qpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y35UHLlMiYde51iVKR+n3JoxvCegZU0uBAWABZsfWpo=;
        b=D0w8jGUdQMZZf9/jgGTaScD/Gvofn+NK/kMbHvxBAvFtu9OBZ7V9XccMU6XrcRAaBA
         BqpI1rEcg9JJKmFBjPoej0fCz1cgN+ZZEX24/wG7ms59WIjOro4elT19OjNE5zs3Dg1S
         P4VdaxUB+Dkp3yso6wUcLVDek7yRf5FiGKwiUUaKU6zv/AEjiNCBiDbY0kurNrVAkdBV
         0doKW7H7cEo4M5instXmld3HyxEnA3lVD8EaDUtfokxRY3b8VGlwZS947OMhJLHFl+87
         aVHS6GUCbjpSxkmbOb1LqbOWvSmyhhR3wHJcFGHJkA6ytUaFxtJ9KuYGbnOjdOb1xS/5
         lfdQ==
X-Gm-Message-State: AOAM5312p+RWDQM/gV7DFRkQozFZnaBrguQhMe6c0srh+XGwzXbqgK2j
        kZTK36IMTSSAEtgIQIHK2bs=
X-Google-Smtp-Source: ABdhPJxVfmfr+RHqVf5h9a5LvsLpxM5Y7ikc00Qn8MOC5QdyoX2BQ+qNspWHuU0k2Cumc090gMjtaQ==
X-Received: by 2002:a17:90a:a10e:: with SMTP id s14mr1417416pjp.133.1610074491116;
        Thu, 07 Jan 2021 18:54:51 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id f193sm7444219pfa.81.2021.01.07.18.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 18:54:50 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     roopa@nvidia.com
Cc:     nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net/bridge: fix misspellings using codespell tool
Date:   Thu,  7 Jan 2021 18:53:32 -0800
Message-Id: <20210108025332.52480-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Some typos are found out by codespell tool:

$ codespell ./net/bridge/
./net/bridge/br_stp.c:604: permanant  ==> permanent
./net/bridge/br_stp.c:605: persistance  ==> persistence
./net/bridge/br.c:125: underlaying  ==> underlying
./net/bridge/br_input.c:43: modue  ==> mode
./net/bridge/br_mrp.c:828: Determin  ==> Determine
./net/bridge/br_mrp.c:848: Determin  ==> Determine
./net/bridge/br_mrp.c:897: Determin  ==> Determine

Fix typos found by codespell.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/bridge/br.c       | 2 +-
 net/bridge/br_input.c | 2 +-
 net/bridge/br_mrp.c   | 6 +++---
 net/bridge/br_stp.c   | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 1b169f8e7491..ef743f94254d 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -122,7 +122,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 		break;
 
 	case NETDEV_PRE_TYPE_CHANGE:
-		/* Forbid underlaying device to change its type. */
+		/* Forbid underlying device to change its type. */
 		return NOTIFY_BAD;
 
 	case NETDEV_RESEND_IGMP:
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8ca1f1bc6d12..222285d9dae2 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -40,7 +40,7 @@ static int br_pass_frame_up(struct sk_buff *skb)
 
 	vg = br_vlan_group_rcu(br);
 	/* Bridge is just like any other port.  Make sure the
-	 * packet is allowed except in promisc modue when someone
+	 * packet is allowed except in promisc mode when someone
 	 * may be running packet capture.
 	 */
 	if (!(brdev->flags & IFF_PROMISC) &&
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index cec2c4e4561d..fc0a98874bfc 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -825,7 +825,7 @@ int br_mrp_start_in_test(struct net_bridge *br,
 	return 0;
 }
 
-/* Determin if the frame type is a ring frame */
+/* Determine if the frame type is a ring frame */
 static bool br_mrp_ring_frame(struct sk_buff *skb)
 {
 	const struct br_mrp_tlv_hdr *hdr;
@@ -845,7 +845,7 @@ static bool br_mrp_ring_frame(struct sk_buff *skb)
 	return false;
 }
 
-/* Determin if the frame type is an interconnect frame */
+/* Determine if the frame type is an interconnect frame */
 static bool br_mrp_in_frame(struct sk_buff *skb)
 {
 	const struct br_mrp_tlv_hdr *hdr;
@@ -894,7 +894,7 @@ static void br_mrp_mrm_process(struct br_mrp *mrp, struct net_bridge_port *port,
 		br_mrp_ring_port_open(port->dev, false);
 }
 
-/* Determin if the test hdr has a better priority than the node */
+/* Determine if the test hdr has a better priority than the node */
 static bool br_mrp_test_better_than_own(struct br_mrp *mrp,
 					struct net_bridge *br,
 					const struct br_mrp_ring_test_hdr *hdr)
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 3e88be7aa269..a3a5745660dd 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -601,8 +601,8 @@ int __set_ageing_time(struct net_device *dev, unsigned long t)
 /* Set time interval that dynamic forwarding entries live
  * For pure software bridge, allow values outside the 802.1
  * standard specification for special cases:
- *  0 - entry never ages (all permanant)
- *  1 - entry disappears (no persistance)
+ *  0 - entry never ages (all permanent)
+ *  1 - entry disappears (no persistence)
  *
  * Offloaded switch entries maybe more restrictive
  */
-- 
2.25.1

