Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C2933FC26
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 01:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCRARV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 20:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhCRARA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 20:17:00 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD18FC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 17:17:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 11so2255549pfn.9
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 17:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfqCUcdG/h4taUkU/CcjFUse1dOAbxd7xHxgmRnIBsw=;
        b=jp2Hq7X3ugtmtCvR633qnjYFepK6XxbayTISmmGxA79aCnRpK4m6oJYYDqNMcaZCbU
         2/ZZrG7Rnf8NJSYXAUwCybbnpSzxbBSbkipj0jXhAOFZVx6pLaZDo56pqtECTf3ZTdb4
         PMxd7OS80BlEhqLCUUIo1A7CZ/MTindON7eSaee0VNRYx4Ju+5Kmq+jEWsCru9tm9Mzf
         k6u29r/zMp0jDmyGy3ed23A5zhgyHVxOqATEA2n9auFcDytA9DEcULJaenaAPbgjT3Kh
         otnxSlpwQ6PupxHchuQ2OFC/UdcC4jrgFEdG3IqzXurQCOSOntKRg7r8zRzILyAi5uQC
         dNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfqCUcdG/h4taUkU/CcjFUse1dOAbxd7xHxgmRnIBsw=;
        b=pmRWlNdUmFdKNCK9bTvjPdwYh6aRPWcgboztBkP2j87nvlb3lRWGaPt0gmGe0eW3hb
         1xW1gm/qwy2G1ZhlYvAMaOxarqG1mBYoH4X9pqleFIVmYDOh49qBlp0T27ucDGY90hUH
         sHvRcE3V2OCwrCDTZ9MlPN/hv4j+h3XojS39DeqiPPgAG+QK7D24Z+P5ZfTTQvLn8fcL
         445bX/C86E2tO28oc3csJPrTa7xhD7LtopfWbp9200LSuc+XQEhBzIBR4rcOevEzGtH5
         9flF440FKEgUPjPv0NcTn9rlGGQVkpPfaCMM3zoq0x1+VWK6qZduSlcE5bP6YJi1Egjt
         j0xw==
X-Gm-Message-State: AOAM531gxW6/igQ90CRyeg3yVhj+PhOb5oBjZ4VJcFyqpnRJgzuHn2dU
        B62MMP4yLWBEb9Q9R/0XEO2BCrnanu+Iiw==
X-Google-Smtp-Source: ABdhPJw7yfmQVeood+dlOtwAc1aBM7BnYxHpnnBEv/FQOvWtVFXNjq/9JOlhotQ5QgSIawiOxj2xVg==
X-Received: by 2002:a65:5bca:: with SMTP id o10mr4815162pgr.248.1616026614510;
        Wed, 17 Mar 2021 17:16:54 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id y22sm213713pfn.32.2021.03.17.17.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 17:16:53 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] ip: cleanup help message
Date:   Wed, 17 Mar 2021 17:15:31 -0700
Message-Id: <20210318001530.125352-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap help message text at 80 characters, and put list of things
in alpha order.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
Other places may need this as well.

PS: I made a version that auto-generated the text but it was too verbose
especially since many options in iproute2 are dynamically bound.

 ip/ip.c     |  9 +++++----
 ip/iplink.c | 11 +++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/ip/ip.c b/ip/ip.c
index 40d2998ae60b..6781443014d7 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -64,10 +64,11 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       ip [ -force ] -batch filename\n"
-		"where  OBJECT := { link | address | addrlabel | route | rule | neigh | ntable |\n"
-		"                   tunnel | tuntap | maddress | mroute | mrule | monitor | xfrm |\n"
-		"                   netns | l2tp | fou | macsec | tcp_metrics | token | netconf | ila |\n"
-		"                   vrf | sr | nexthop | mptcp }\n"
+		"where  OBJECT := { address | addrlabel | fou | help | ila | l2tp | link |\n"
+		"                   macsec | maddress | monitor | mptcp | mroute | mrule |\n"
+		"                   neighbor | neighbour | netconf | netns | nexthop | ntable |\n"
+		"                   ntbl | route | rule | sr | tap | tcp_metrics | tcpmetrics |\n"
+		"                   token | tunl | tunnel | tuntap | vrf | xfrm }\n"
 		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |\n"
 		"                    -h[uman-readable] | -iec | -j[son] | -p[retty] |\n"
 		"                    -f[amily] { inet | inet6 | mpls | bridge | link } |\n"
diff --git a/ip/iplink.c b/ip/iplink.c
index 27c9be442a7a..10eab97ebea2 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -118,12 +118,11 @@ void iplink_usage(void)
 			"\n"
 			"	ip link help [ TYPE ]\n"
 			"\n"
-			"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
-			"	   bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
-			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
-			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
-			"	   ipvlan | ipvtap | geneve | bareudp | vrf | macsec | netdevsim | rmnet |\n"
-			"	   xfrm }\n");
+			"TYPE := { bareudp | bond | bond_slave | bridge |bridge_slave | dummy | erspan |\n"
+			"          geneve | gre | gretap | ifb | ip6erspan | ip6gre | ip6gretap | ip6tnl |\n"
+			"          ipip | ipoib | ipvlan | ipvtap | macsec | macvlan | macvtap |\n"
+			"          netdevsim| nlmon | rmnet |sit| team| | team_slave | vcan | veth |\n"
+			"          vlan | vrf | vti | vxcan | vxlan | xfrm }\n");
 	}
 	exit(-1);
 }
-- 
2.30.2

