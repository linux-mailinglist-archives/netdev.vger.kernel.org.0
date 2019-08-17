Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA9191038
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 13:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfHQLW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 07:22:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37679 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfHQLW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 07:22:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so6090369wmf.2
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 04:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zLOU89kM0wwKVTB1UPD2cV0f8y3hOpOztYSgdhvell4=;
        b=TXmcamN8IcT8ZBgKXUN3NLesuIAUUL7x46HjkvMIMfGewwwHulzc77+29EH8KrHU7Y
         B3yzwPOG3qloRH3y3cK992aC/jSfzZRPVcpEktcAEDdHJcaNYhiuk3aYFunnL0r9zuvm
         8W8wfnSj1z8jwudBnjPFvLL+TUlqWcHjS3toY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zLOU89kM0wwKVTB1UPD2cV0f8y3hOpOztYSgdhvell4=;
        b=UizNATLWX4XFNov8bSZ9I2TqyQZOhH0mQXlfRlu8yrlIIfvaddF307zT/96/Jb1jvW
         kQFIqlFClJw2XqOBoNrcZmOk5/TvbVBJfVjZTsEOQWPt1z+YO30B6jb2Kn2JVZeysUhs
         vL3btq3m6mPPhLqwGk9NnfklXr58O2n1B5Ov/Q2BPEbPYSRgfjntMo0DgUwRIUgQhnUg
         wAgeMzQxDd7FaPgxxqqo6iB58mHUpXUAxKUNieFrtZTjHfNbtHOhEM+TVI/FJT0QvfQZ
         0R6ZOytYSE48pqn6cXRj08OrkzPCASualFstRY2P/BT9ggwbjZV2Z30t+QcmvfSxYZyU
         LGbQ==
X-Gm-Message-State: APjAAAUuSIOCDTmNtp/637ntIchp5X2RAX28bXrfARIJlPainFrh5gWm
        pPCxo0+oiUOrrN0JQQ1BPjL+JB63IyJ8qQ==
X-Google-Smtp-Source: APXvYqx2rwrmVbC7StInA7D0K8/GZ1e2Eu45rlRA9xvkQeV0/cu2Y5ANuDqJSopU+aqwv1mGjvsIQA==
X-Received: by 2002:a1c:a701:: with SMTP id q1mr10891536wme.72.1566040947122;
        Sat, 17 Aug 2019 04:22:27 -0700 (PDT)
Received: from debil.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o14sm13900244wrg.64.2019.08.17.04.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2019 04:22:26 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 1/4] net: bridge: mdb: move vlan comments
Date:   Sat, 17 Aug 2019 14:22:10 +0300
Message-Id: <20190817112213.27097-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817112213.27097-1-nikolay@cumulusnetworks.com>
References: <20190816.130417.1610388599335442981.davem@davemloft.net>
 <20190817112213.27097-1-nikolay@cumulusnetworks.com>
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

