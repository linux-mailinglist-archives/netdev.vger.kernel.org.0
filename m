Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A9D8DB70
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfHNRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:25:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38666 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbfHNRFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:05:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so111805639wrr.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zLOU89kM0wwKVTB1UPD2cV0f8y3hOpOztYSgdhvell4=;
        b=XHMQDr806G3D5l5dlL1zKIeSGUZWTlyoNf8Gxg0UBdT/WlTMtIwX4sa7r5FPvGGNnP
         lNt7wIN+05DNeoQDkQPUoDkDRgRodpRR7R6Yn34Jtd8HSdKW5FX9ciTU+BZasKxmrWpR
         gUu5kHK9ALQ6JZ5XSZPFycIK6Tc0aDnNfnNZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zLOU89kM0wwKVTB1UPD2cV0f8y3hOpOztYSgdhvell4=;
        b=TVNroAiY59AnlOcFAz4nJGuewgqPCPMuCpQF9MXjWQwDE96JrLgTCVCrxG8twyZT2r
         KU08iScRSHDG2Q+DBQP4kysLV/Sre/w5IA0gkrrU73u7IVTeVj4ywxN5TVuPPvgrgbqa
         lq0HQaLbRsiCIEH4TxWE2oM8A0Nb5LNJQTd0Q1kY8jQdAqjR3I6zL4ErC6Bim7yLMbgQ
         vTtaZ1U1rPoW+KalUIm+lJCs4VJOJ/QFAs0bKceLoNqIgonOd2Yh9ygj+selG2jr1FjT
         RlZHRoQQxsXg0Ii0lq1wJgP5wrjYv8H2kwVY6K9RCbhFxX7rwexyQfj0ryegofWuSglM
         EbmA==
X-Gm-Message-State: APjAAAUGZkSj2GwObMA3BnhITC2Zye/XoMW5fngvEumqU5XLutPR20Wy
        P8CdDQzo2eu3N9LVRRlOAo1ZcJKLsww=
X-Google-Smtp-Source: APXvYqzXTjGDoczmBrIS4Ptf9d6eU4NIc9IATDaUEwIffzi78EuiZw6ZXHuDjQUv3/BikGetwa+PBQ==
X-Received: by 2002:adf:8bd8:: with SMTP id w24mr764204wra.273.1565802350269;
        Wed, 14 Aug 2019 10:05:50 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id c6sm332311wma.25.2019.08.14.10.05.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:05:49 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 1/4] net: bridge: mdb: move vlan comments
Date:   Wed, 14 Aug 2019 20:04:58 +0300
Message-Id: <20190814170501.1808-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814170501.1808-1-nikolay@cumulusnetworks.com>
References: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
 <20190814170501.1808-1-nikolay@cumulusnetworks.com>
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

