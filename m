Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD133399E1B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhFCJwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:52:35 -0400
Received: from m15112.mail.126.com ([220.181.15.112]:38706 "EHLO
        m15112.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFCJwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Tzj37gS5fRDn9Q+o6l
        FL+5giN6Xx20MQgaw/uq7nHlE=; b=geuzV4eWJ5o3ozmnVyB5B1yu7O/QlfnnFh
        dQtDvKSIENK/E2nWhXmpfDm22antUWsvIPJ64hRmnjI0EmRRvPlEE9FkXlaCIqvE
        wxDGIO4m1SSYA/gdw4CeO2mBvXBWLoc7QM6OiMcbeU4jGqMSxb9/ODLBXPoZe+el
        hV3v0EvQU=
Received: from localhost.localdomain (unknown [125.33.196.124])
        by smtp2 (Coremail) with SMTP id DMmowAC3G0nrpbhgzOP9Bw--.8346S4;
        Thu, 03 Jun 2021 17:50:36 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] ipv6: parameter p.name is empty
Date:   Thu,  3 Jun 2021 17:50:30 +0800
Message-Id: <20210603095030.2920-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DMmowAC3G0nrpbhgzOP9Bw--.8346S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RXzV8UUUUU
X-Originating-IP: [125.33.196.124]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi1w2m-l53WW5iUgAAss
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

so do not check it.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv6/addrconf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b0ef65eb9..4c6b3fc7e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2833,9 +2833,6 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
 	if (err)
 		return err;
 
-	dev = __dev_get_by_name(net, p.name);
-	if (!dev)
-		return -ENOBUFS;
 	return dev_open(dev, NULL);
 }
 
-- 
2.17.1

