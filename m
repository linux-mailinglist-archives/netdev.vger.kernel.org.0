Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC68D65F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfHNOkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:40:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41300 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNOkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:40:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so9073816wrr.8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 07:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zLOU89kM0wwKVTB1UPD2cV0f8y3hOpOztYSgdhvell4=;
        b=W0v/34bb+R0t8/FtoFPWcg9lKzEZGSjF6tCn9906Wc61iSdL28yBtox3OkBC+wSXTH
         oj1SJwR12w6ETdbPkfkYI1GAeFWW7I+dkbPxi8tSOoUWLB0I2CVzpMMzhp6dCqu6wd/W
         sh68A4Ceq5sIZsCVdKaTXDVWv6EHamHivP4IM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zLOU89kM0wwKVTB1UPD2cV0f8y3hOpOztYSgdhvell4=;
        b=j364BkyXvm8wbs9oR/i92yz7bC27D2dbYCQJYf6Cj2Zo0Ck3L+VN1e1iGznEjSgqFG
         Ogn1EmC4YO9PWuOwzsHcYyHUB4sRG0CJ4OJOyELvmZGioh1t4nUGCKzzkc/d5Amrhu4l
         2oD/P1cKVS9ymEbdfviXGPR2tGRmE+5rbXc6bmOd4hWUZn2Qc3OwLdPTnddLwXTi0bS+
         opcjthOUJzWbzi1IoVWmUnwuWGjR8K4/jR4tRvD54JLUVaxI9RDw/9y5s4QknsikiofO
         zfys73B6GCWM589wfEL20zgljeYGq2S7q8IIb9OVIP2MmaETIbtfdK11LgcuscodVpzl
         F5LQ==
X-Gm-Message-State: APjAAAW75vRpaHe7yjUwjQKdZYP4lms7oFY4QXp/MGAslreo6cklDPQd
        wj7jEr3ezsHx3WfltHE23zCpxu0qHK0=
X-Google-Smtp-Source: APXvYqy8Xl/Z2si/En5X1hbO2uIR0lFOIogMZBQbk31axfaX8gxzCfh6JidruDKx8vIhNlosak7B5g==
X-Received: by 2002:a5d:470c:: with SMTP id y12mr42605wrq.136.1565793634446;
        Wed, 14 Aug 2019 07:40:34 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id o8sm3383874wma.1.2019.08.14.07.40.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 07:40:33 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/4] net: bridge: mdb: move vlan comments
Date:   Wed, 14 Aug 2019 17:40:21 +0300
Message-Id: <20190814144024.9710-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
References: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial patch to move the vlan comments in their proper places above the
vid 0 checks.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 428af1abf8cc..ee6208c6d946 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -653,9 +653,6 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	/* If vlan filtering is enabled and VLAN is not specified
-	 * install mdb entry on all vlans configured on the port.
-	 */
 	pdev = __dev_get_by_index(net, entry->ifindex);
 	if (!pdev)
 		return -ENODEV;
@@ -665,6 +662,9 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	vg = nbp_vlan_group(p);
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * install mdb entry on all vlans configured on the port.
+	 */
 	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			entry->vid = v->vid;
@@ -745,9 +745,6 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	/* If vlan filtering is enabled and VLAN is not specified
-	 * delete mdb entry on all vlans configured on the port.
-	 */
 	pdev = __dev_get_by_index(net, entry->ifindex);
 	if (!pdev)
 		return -ENODEV;
@@ -757,6 +754,9 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 
 	vg = nbp_vlan_group(p);
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * delete mdb entry on all vlans configured on the port.
+	 */
 	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			entry->vid = v->vid;
-- 
2.21.0

