Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBBE36BDCC
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhD0Dkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhD0Dks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:40:48 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792ECC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 20:40:06 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z14so5752379ioc.12
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 20:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVPOzhfL8Fjkv0VYQNNMPcLZkAwJOlBTfp5jTSkBo5E=;
        b=ar9uu5Nr4qN/l6z2co3wDTB1QFW5FMJkQZ07quTblxtwJ0gYYwk1NZ5dlc4a1QftJp
         x48Ce9/Iam15H6tLT8SU/h/idQiMPjCN6v6FiLnFVCbMm2NF6JGBJoqET2n8WCnCH4uv
         zCHUQW6Oy0QfULfCX33uAIorx0PAaWvdSalGCcnsCjdz3NOmntwjStqsDtett532Qbhi
         KMlBZHdMCf/NReONFNutybcRngnXe+n86ciugnKfV+rBk275GxC6SkdJl7W/uztJp1RG
         f8cG1rA0hGE3AWdYWhZF+6UEhBEC9GWKN6lDYpG+qd5HC94SBH6kXPr2MiLhhLF1PtN+
         TXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVPOzhfL8Fjkv0VYQNNMPcLZkAwJOlBTfp5jTSkBo5E=;
        b=c00C5QTfZ5R8ptt15KI1vpjy9VzmTTjRRwZPa8qZ8v4Ol5W07L68KXqjBtU+y7LHyI
         wcHE1/x5hP4V4rMQPmUsSINy9E+JaNjcuz7WVXEkkpzVuE6B/2fiwtKgpTVebKZEO3Hg
         hEs8v/cBOPAqXUbVkbaJx2QT6nQ6un+DzeLpHJJ8Lx7PDSRbLPBK9+XJR7HISaM76X81
         Z5nq412I1I9uAPlPJm3ExFdqelmsAwPFUV3E3Q/dTojM1ipmHC6pkKY/w87tJknGLPpM
         N6zmB4fHxfysITYLt1MsMyb5viKFG/GHRlbBVeDNMurtSfDuAmitjSgiiI5/EUV/zVxZ
         vsdw==
X-Gm-Message-State: AOAM531s5+VuUviebAR13ADGsXvptwdCvqjy+QyreRoC9VAzQt3PPYjw
        9mQGp3+ziVYFVwGEzU4QwzAnFssy9gY=
X-Google-Smtp-Source: ABdhPJzkon7RJ1v8o9CB+96vq413g8a1ZJCiS0SAPkZIWqDV+kKX7qxNETzkLWKybWVdhzLWT9yU+Q==
X-Received: by 2002:a02:294e:: with SMTP id p75mr19458775jap.34.1619494805793;
        Mon, 26 Apr 2021 20:40:05 -0700 (PDT)
Received: from aroeseler-ly545.hsd1.ut.comcast.net ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.googlemail.com with ESMTPSA id y12sm8450096ioa.12.2021.04.26.20.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 20:40:05 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next] icmp: standardize naming of RFC 8335 PROBE constants
Date:   Mon, 26 Apr 2021 22:40:02 -0500
Message-Id: <20210427034002.291543-1-andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current definitions of constants for PROBE are inconsistent, with
some beginning with ICMP and others with simply EXT. This patch
attempts to standardize the naming conventions of the constants for
PROBE, and update the relevant definitions in net/ipv4/icmp.c.

Similarly, the definitions for the code field (previously
ICMP_EXT_MAL_QUERY, etc) use the same prefixes as the type field. This
patch adds _CODE_ to the prefix to clarify the distinction of these
constants.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmp.h | 28 ++++++++++++++--------------
 net/ipv4/icmp.c           | 16 ++++++++--------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index 222325d1d80e..c1da8244c5e1 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -70,22 +70,22 @@
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
 /* Codes for EXT_ECHO (PROBE) */
-#define ICMP_EXT_ECHO		42
-#define ICMP_EXT_ECHOREPLY	43
-#define ICMP_EXT_MAL_QUERY	1	/* Malformed Query */
-#define ICMP_EXT_NO_IF		2	/* No such Interface */
-#define ICMP_EXT_NO_TABLE_ENT	3	/* No such Table Entry */
-#define ICMP_EXT_MULT_IFS	4	/* Multiple Interfaces Satisfy Query */
+#define ICMP_EXT_ECHO			42
+#define ICMP_EXT_ECHOREPLY		43
+#define ICMP_EXT_CODE_MAL_QUERY		1	/* Malformed Query */
+#define ICMP_EXT_CODE_NO_IF		2	/* No such Interface */
+#define ICMP_EXT_CODE_NO_TABLE_ENT	3	/* No such Table Entry */
+#define ICMP_EXT_CODE_MULT_IFS		4	/* Multiple Interfaces Satisfy Query */
 
 /* Constants for EXT_ECHO (PROBE) */
-#define EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
-#define EXT_ECHOREPLY_IPV4	(1 << 1)/* ipv4 bit in reply message */
-#define EXT_ECHOREPLY_IPV6	1	/* ipv6 bit in reply message */
-#define EXT_ECHO_CTYPE_NAME	1
-#define EXT_ECHO_CTYPE_INDEX	2
-#define EXT_ECHO_CTYPE_ADDR	3
-#define ICMP_AFI_IP		1	/* Address Family Identifier for ipv4 */
-#define ICMP_AFI_IP6		2	/* Address Family Identifier for ipv6 */
+#define ICMP_EXT_ECHOREPLY_ACTIVE	(1 << 2)/* active bit in reply message */
+#define ICMP_EXT_ECHOREPLY_IPV4		(1 << 1)/* ipv4 bit in reply message */
+#define ICMP_EXT_ECHOREPLY_IPV6		1	/* ipv6 bit in reply message */
+#define ICMP_EXT_ECHO_CTYPE_NAME	1
+#define ICMP_EXT_ECHO_CTYPE_INDEX	2
+#define ICMP_EXT_ECHO_CTYPE_ADDR	3
+#define ICMP_AFI_IP			1	/* Address Family Identifier for ipv4 */
+#define ICMP_AFI_IP6			2	/* Address Family Identifier for ipv6 */
 
 struct icmphdr {
   __u8		type;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8bd988fbcb31..7b6931a4d775 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1033,7 +1033,7 @@ static bool icmp_echo(struct sk_buff *skb)
 	status = 0;
 	dev = NULL;
 	switch (iio->extobj_hdr.class_type) {
-	case EXT_ECHO_CTYPE_NAME:
+	case ICMP_EXT_ECHO_CTYPE_NAME:
 		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
 		if (ident_len >= IFNAMSIZ)
 			goto send_mal_query;
@@ -1041,14 +1041,14 @@ static bool icmp_echo(struct sk_buff *skb)
 		memcpy(buff, &iio->ident.name, ident_len);
 		dev = dev_get_by_name(net, buff);
 		break;
-	case EXT_ECHO_CTYPE_INDEX:
+	case ICMP_EXT_ECHO_CTYPE_INDEX:
 		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
 					 sizeof(iio->ident.ifindex), &_iio);
 		if (ident_len != sizeof(iio->ident.ifindex))
 			goto send_mal_query;
 		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
 		break;
-	case EXT_ECHO_CTYPE_ADDR:
+	case ICMP_EXT_ECHO_CTYPE_ADDR:
 		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
 				 iio->ident.addr.ctype3_hdr.addrlen)
 			goto send_mal_query;
@@ -1080,23 +1080,23 @@ static bool icmp_echo(struct sk_buff *skb)
 		goto send_mal_query;
 	}
 	if (!dev) {
-		icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
+		icmp_param.data.icmph.code = ICMP_EXT_CODE_NO_IF;
 		goto send_reply;
 	}
 	/* Fill bits in reply message */
 	if (dev->flags & IFF_UP)
-		status |= EXT_ECHOREPLY_ACTIVE;
+		status |= ICMP_EXT_ECHOREPLY_ACTIVE;
 	if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
-		status |= EXT_ECHOREPLY_IPV4;
+		status |= ICMP_EXT_ECHOREPLY_IPV4;
 	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
-		status |= EXT_ECHOREPLY_IPV6;
+		status |= ICMP_EXT_ECHOREPLY_IPV6;
 	dev_put(dev);
 	icmp_param.data.icmph.un.echo.sequence |= htons(status);
 send_reply:
 	icmp_reply(&icmp_param, skb);
 		return true;
 send_mal_query:
-	icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+	icmp_param.data.icmph.code = ICMP_EXT_CODE_MAL_QUERY;
 	goto send_reply;
 }
 
-- 
2.31.1

