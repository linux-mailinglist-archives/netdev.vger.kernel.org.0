Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CFB2AC49
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfEZVPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:15:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34007 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfEZVPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:15:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id w7so6218421plz.1
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 14:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=munnSaDPYGVqlShjlPVQhzMv5d6uTzrKKUH35RVhkXw=;
        b=gvz2K1gT0oMvIMQYRFjdsqdhtDSFt34x815qZxkl5us+w93A0Ur+YpEizvmeaStxAc
         NwNEClAQsmlMRxTPOyDpFe7FIrdWOz4ZA+iAfzz7s+9hHshk18IC9RkwVK0HsURGtB2E
         TNYxD99zWe3V6vs8QwNkjptFHa92mtDQigBK1eneo3HE+IRA6EuCzSr7Z7bSCi6pOTp6
         tQ2TqfaQFQ27wEhOV8IyV8HIEA80InXQKWce4hO4EyqQbtTlQrv96lHZIa9a1SB/M4pz
         LxdPyhBbLOF4/Gs4umwXbELaEqsb7OwUbYanyZV/F+UbqH9oN0FOfDM9hSpEi6xd1Y5q
         BXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=munnSaDPYGVqlShjlPVQhzMv5d6uTzrKKUH35RVhkXw=;
        b=hQOGcMKbdDLRy7DuLEYZg6eu4svqhfMNRAXjRVioV7vFIZ3aAoKkhL5yFZSUsA2XOe
         Pq9O8arw/ua1OuFMiTRnJMFSrPi3r59tOKa6gxYPchhI21ag+yyUtRElV3HR6TOQoZj3
         mLC4R2y0p0Feqz24rUtCrTgb/1dXhWJrQk9sim4sYaDVN9RygqnhQkHYYmWwRqgPjp9N
         76GfI/Rfpm1FiJT/o8tfD08A6pdB7QTSHh2eYrKYID9RZNX8JzCNMCEnwVbubmprC9XT
         9YJea6ysQUzI1uEcMc+ROqItEHWqbrcGDXRiqCyAbcy2is6EJtYrRiCjHTOmUtxg/qmU
         qg4A==
X-Gm-Message-State: APjAAAWswJGFt3PdSA/JfpBIwjsVWpAhzda2/qDaUjNjEer5zsv11ohM
        MepBQ0JeVwt7wnMczExi6E5ynDJ1IQQzhw==
X-Google-Smtp-Source: APXvYqwJGUxZoho4AYk/czdYnY0UB94R/qj9GXkmXgC/wOnqS98FepGShHNtHHkhsi9Yxe51NLec2w==
X-Received: by 2002:a17:902:b094:: with SMTP id p20mr98470677plr.164.1558905332213;
        Sun, 26 May 2019 14:15:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id f40sm13325325pjg.9.2019.05.26.14.15.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 May 2019 14:15:31 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 2/4] ipv6: Update references from RFC2460 to RFC8200
Date:   Sun, 26 May 2019 14:15:04 -0700
Message-Id: <1558905306-2968-3-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558905306-2968-1-git-send-email-tom@quantonium.net>
References: <1558905306-2968-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 is now a full Internet standard in RFC8200! Update references
in the code to reflect that.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 2 +-
 drivers/net/usb/smsc95xx.c                           | 2 +-
 net/ipv6/exthdrs.c                                   | 4 ++--
 net/ipv6/netfilter/nf_conntrack_reasm.c              | 2 +-
 net/ipv6/reassembly.c                                | 2 +-
 net/ipv6/syncookies.c                                | 2 +-
 net/ipv6/tcp_ipv6.c                                  | 2 +-
 net/ipv6/udp.c                                       | 2 +-
 net/netfilter/xt_TCPMSS.c                            | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 57a9c31..4711150 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -163,7 +163,7 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	if (unlikely(csum_value_final == 0)) {
 		switch (ip6h->nexthdr) {
 		case IPPROTO_UDP:
-			/* RFC 2460 section 8.1
+			/* RFC 8200 section 8.1
 			 * DL6 One's complement rule for UDP checksum 0
 			 */
 			csum_value_final = ~csum_value_final;
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 355be77..496ed4d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1269,7 +1269,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	spin_lock_init(&pdata->mac_cr_lock);
 
 	/* LAN95xx devices do not alter the computed checksum of 0 to 0xffff.
-	 * RFC 2460, ipv6 UDP calculated checksum yields a result of zero must
+	 * RFC 8200, ipv6 UDP calculated checksum yields a result of zero must
 	 * be changed to 0xffff. RFC 768, ipv4 UDP computed checksum is zero,
 	 * it is transmitted as all ones. The zero transmitted checksum means
 	 * transmitter generated no checksum. Hence, enable csum offload only
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 20291c2..fdb4a32 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -150,7 +150,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 			break;
 
 		case IPV6_TLV_PADN:
-			/* RFC 2460 states that the purpose of PadN is
+			/* RFC 8200 states that the purpose of PadN is
 			 * to align the containing header to multiples
 			 * of 8. 7 is therefore the highest valid value.
 			 * See also RFC 4942, Section 2.1.9.5.
@@ -561,7 +561,7 @@ static int ipv6_rthdr_rcv(struct sk_buff *skb)
 
 	/*
 	 *	This is the routing header forwarding algorithm from
-	 *	RFC 2460, page 16.
+	 *	Section 4.4, RFC 8200.
 	 */
 
 	n = hdr->hdrlen >> 1;
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3de0e9b..5fc9a5d 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -228,7 +228,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		 * Required by the RFC.
 		 */
 		if (end & 0x7) {
-			/* RFC2460 says always send parameter problem in
+			/* RFC8200 says always send parameter problem in
 			 * this case. -DaveM
 			 */
 			pr_debug("end of fragment not rounded to 8 bytes.\n");
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1a832f5..bc0a361 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -158,7 +158,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 		 * Required by the RFC.
 		 */
 		if (end & 0x7) {
-			/* RFC2460 says always send parameter problem in
+			/* RFC8200 says always send parameter problem in
 			 * this case. -DaveM
 			 */
 			*prob_offset = offsetof(struct ipv6hdr, payload_len);
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e997141..48e07b2 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -27,7 +27,7 @@
 
 static siphash_key_t syncookie6_secret[2] __read_mostly;
 
-/* RFC 2460, Section 8.3:
+/* RFC 8200, Section 8.3:
  * [ipv6 tcp] MSS must be computed as the maximum packet size minus 60 [..]
  *
  * Due to IPV6_MIN_MTU=1280 the lowest possible MSS is 1220, which allows
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index beaf284..d74537f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -602,7 +602,7 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct tcphdr *_th;
 
 	bp = hp->scratch;
-	/* 1. TCP pseudo-header (RFC2460) */
+	/* 1. TCP pseudo-header (RFC8200) */
 	bp->saddr = *saddr;
 	bp->daddr = *daddr;
 	bp->protocol = cpu_to_be32(IPPROTO_TCP);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 07fa579..f0e0f2a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -739,7 +739,7 @@ static bool __udp_v6_is_mcast_sock(struct net *net, struct sock *sk,
 
 static void udp6_csum_zero_error(struct sk_buff *skb)
 {
-	/* RFC 2460 section 8.1 says that we SHOULD log
+	/* RFC 8200 section 8.1 says that we SHOULD log
 	 * this error. Well, it is reasonable.
 	 */
 	net_dbg_ratelimited("IPv6: udp checksum is 0 for [%pI6c]:%u->[%pI6c]:%u\n",
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 98efb20..2fd6ffd 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -167,7 +167,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	/*
 	 * IPv4: RFC 1122 states "If an MSS option is not received at
 	 * connection setup, TCP MUST assume a default send MSS of 536".
-	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * IPv6: RFC 8200 states IPv6 has a minimum MTU of 1280 and a minimum
 	 * length IPv6 header of 60, ergo the default MSS value is 1220
 	 * Since no MSS was provided, we must use the default values
 	 */
-- 
2.7.4

