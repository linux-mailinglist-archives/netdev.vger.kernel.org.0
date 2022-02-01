Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806294A6731
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiBAVnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiBAVnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:43:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC69C061714;
        Tue,  1 Feb 2022 13:43:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id r59so18365489pjg.4;
        Tue, 01 Feb 2022 13:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nfh9neXAUEzcShXHBoAZTFYIWM5MQnmj1xRT6suzivE=;
        b=U/7U1q0tpU/izUCEpHLz4Nd42PkDysmqhgeb4HH/pI75muzBPK2FFvqC22W4WfzKiT
         VXa/h8Oaozae8Z/zzE3cPLxiMKYd4AIDS3SX8bvgtP8ZBcgv6SB3bXGTRlcDOvCraXnO
         M17J+l8f3g9sVAA3n2Bc/fTfxs/Qk/R2QeLhYHF+yGwnIkRR0GEtbBUvhDU9SBBWsIpH
         Opvuhsyf/obr1YykmR2C0OdBBL1htITX7URu4sUJ1URLPAfYlFIhU7C8QOGCpYeVMZWW
         sLn0Q6rR/M3TRCqugFSDuhDEP0vp1+Zox3hwt5GZwwxUepOAnuIvbCAoCWByFO2c9h4z
         8aPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nfh9neXAUEzcShXHBoAZTFYIWM5MQnmj1xRT6suzivE=;
        b=7u72iVyr+/MwrcSFkrqBnR/0VrtkCLX4ZFWTUYPPsHsjqI90na8a/CcaM6oReJDY1Y
         78BZdYuJyjoLcB8v4YFugqODOz8/AGFPL6zJxCYON6aBAdkSsp5czZXmxIGtOGK9YV3e
         RTy99ZUoe2rAivx5FFoMb2+HuhDvp5SunjNg8SV6b5/mtXF9vb+lMsI2Za9mpwDqvgQ0
         9CtQ2XaDWxUrachmOuAzumWL9t6FY0Rc6pVVgFYaLEpjl6uM1hNCCAjS6WY0JPf6uGFO
         3V5f81qh53QhrBdnNJGOlVMPDEo9OtSdBq64zwCrsClPhpS+kYmivV1EaeKInwe5ilgz
         GceA==
X-Gm-Message-State: AOAM533MHg41i2OQ3AcWV7J8xS46ZQT0vVvOBlXaDudmhznsZsI15XdF
        j/UGyeJ4GOLwOseiP+QGYFXCXUfdOQQ=
X-Google-Smtp-Source: ABdhPJx2mNPSJowxUs+A14JZEqlEXjoy+1sUt8VO9q3zaUbCfD6ttenNylq2HrrKmEcd168YG9s6hA==
X-Received: by 2002:a17:902:f541:: with SMTP id h1mr27912716plf.64.1643751799630;
        Tue, 01 Feb 2022 13:43:19 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id mq15sm4284894pjb.8.2022.02.01.13.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 13:43:18 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
X-Google-Original-From: Jeffrey Ji <jeffreyji@google.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>, linux-kernel@vger.kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: [PATCH v6 net-core] net-core
Date:   Tue,  1 Feb 2022 21:43:14 +0000
Message-Id: <20220201214314.3630748-1-jeffreyji@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jeffreyji <jeffreyji@google.com>

Increment InMacErrors counter when packet dropped due to incorrect dest
MAC addr.

An example when this drop can occur is when manually crafting raw
packets that will be consumed by a user space application via a tap
device. For testing purposes local traffic was generated using trafgen
for the client and netcat to start a server

example output from nstat:
\~# nstat -a | grep InMac
Ip6InMacErrors                  0                  0.0
IpExtInMacErrors                1                  0.0

Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
counter was incremented.

changelog:
v6: rebase onto net-next

v5:
Change from SKB_DROP_REASON_BAD_DEST_MAC to SKB_DROP_REASON_OTHERHOST

v3-4:
Remove Change-Id

v2:
Use skb_free_reason() for tracing
Add real-life example in patch msg

Signed-off-by: jeffreyji <jeffreyji@google.com>
---
 include/linux/skbuff.h    |  1 +
 include/uapi/linux/snmp.h |  1 +
 net/ipv4/ip_input.c       |  7 +++++--
 net/ipv4/proc.c           |  1 +
 net/ipv6/ip6_input.c      | 12 +++++++-----
 net/ipv6/proc.c           |  1 +
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a27bcc4f7e9a..1b1114f5c68e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,
 	SKB_DROP_REASON_SOCKET_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
+	SKB_DROP_REASON_OTHERHOST,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..ac2fac12dd7d 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -57,6 +57,7 @@ enum
 	IPSTATS_MIB_ECT0PKTS,			/* InECT0Pkts */
 	IPSTATS_MIB_CEPKTS,			/* InCEPkts */
 	IPSTATS_MIB_REASM_OVERLAPS,		/* ReasmOverlaps */
+	IPSTATS_MIB_INMACERRORS,		/* InMacErrors */
 	__IPSTATS_MIB_MAX
 };
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..780892526166 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -441,8 +441,11 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
-		goto drop;
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP_INC_STATS(net, IPSTATS_MIB_INMACERRORS);
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
+		return NULL;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 28836071f0a6..2be4189197f3 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -117,6 +117,7 @@ static const struct snmp_mib snmp4_ipextstats_list[] = {
 	SNMP_MIB_ITEM("InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("InCEPkts", IPSTATS_MIB_CEPKTS),
 	SNMP_MIB_ITEM("ReasmOverlaps", IPSTATS_MIB_REASM_OVERLAPS),
+	SNMP_MIB_ITEM("InMacErrors", IPSTATS_MIB_INMACERRORS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..da18d9159647 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -149,15 +149,17 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	u32 pkt_len;
 	struct inet6_dev *idev;
 
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
 	rcu_read_lock();
 
 	idev = __in6_dev_get(skb->dev);
 
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
+		rcu_read_unlock();
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
+		return NULL;
+	}
+
 	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1..76e6119ba558 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -84,6 +84,7 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
 	SNMP_MIB_ITEM("Ip6InECT1Pkts", IPSTATS_MIB_ECT1PKTS),
 	SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
+	SNMP_MIB_ITEM("Ip6InMacErrors", IPSTATS_MIB_INMACERRORS),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

