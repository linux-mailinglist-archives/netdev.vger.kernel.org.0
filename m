Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8346CE3C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbhLHHYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhLHHYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:24:03 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6401AC061574;
        Tue,  7 Dec 2021 23:20:32 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r25so5151032edq.7;
        Tue, 07 Dec 2021 23:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W9TCKJjdcDwhOK3FQzFGUkG2xpUReurMabSg9HD7/JE=;
        b=EoUEiWQ4wE3l9p2dmaEbEuNRzbe5YfmD4IH+Y76naydoZtE4CHrjKVCFuryTsZT9Gl
         KoGXFs8VDW9u7H/DHlJZwBBdUa8bQJJHneyhxnXpAvVG6feYYLuXk2GwcBMB6AoPmQTI
         LjvEvME1t8Zi7WjJjpAoq/Mx+qJVdmuJe6GQMUv3DJ/wGMHnNE7Izm37qD1lnCGDS4e/
         pXQ2so8d5UC9AhGKYYEWkCTWXYT1SnFSsjEk4vW98AeLBDYh0zQDbDknh2fP5w6eebO+
         jj3cMmwN7/KGMWtjlwKT7Z3IUoHcvWbV/UG/EABbuXN0C8EKuxBRXXBqWcxss5zSN/7y
         hmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W9TCKJjdcDwhOK3FQzFGUkG2xpUReurMabSg9HD7/JE=;
        b=4i1Laij9dTPoT/KFczXFQgaVltcvvUrl4hEKDiZ4ePKk0Dq6zxXGEfOy+yU570DLl1
         FBM8myQK0qY5xtCqhARsr/W0x66Z76mF3qv/YDSFBOIPDTz/7/Uy0qKIVPI3RLJjwW2v
         5CRVPzGxmGpt365Er7Ms1ggFT/uvII27iMr7fYnE/gI8DGxlOBDwXN3qB36lJetDnsP0
         kbnlUsyRJcLCS0VZaQxiBarm/iUfzmQbq6HKjJl/Fv8cXmLxMuiE7SoN9toH5L9Ri+iO
         f5XZjiEsvv0aOpdzphbRGXI4HucvwtJuQlaxJcNULpORl6h0SkVDhcaf0PTpQMfsh6NL
         egvw==
X-Gm-Message-State: AOAM533SakHJypeVDXrHZ62PNig0Ha9bJ88EjwIj7eFy+PdtzL7CMwP1
        4M6oQq3TnKjqiY0XSCboqDY=
X-Google-Smtp-Source: ABdhPJwSaxUqB0ULcm1tLk8RWeNHwf+5izxvRkppUK5/0ksnP7L0uDdiHM2oW937rINk87q9JcFkxg==
X-Received: by 2002:a05:6402:1450:: with SMTP id d16mr16937872edx.144.1638948031042;
        Tue, 07 Dec 2021 23:20:31 -0800 (PST)
Received: from localhost ([81.17.18.62])
        by smtp.gmail.com with ESMTPSA id u16sm1361426edr.43.2021.12.07.23.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 23:20:30 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: bridge: netfilter: fix code indentation
Date:   Wed,  8 Dec 2021 00:20:21 -0700
Message-Id: <20211208024732.142541-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove the extra space to the left of assignment statement.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index fdbed3158555..4a79d25c6391 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -380,7 +380,7 @@ static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
 		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
 		break;
 	case htons(ETH_P_IPV6): {
-		 unsigned char pnum = ipv6_hdr(skb)->nexthdr;
+		unsigned char pnum = ipv6_hdr(skb)->nexthdr;
 		__be16 frag_off;
 
 		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
