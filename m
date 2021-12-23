Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9635F47DF0C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 07:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhLWG0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 01:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbhLWG0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 01:26:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40366C061401
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 22:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=KM4rqlGeUfa4LOuYMurOH9oO/uBQwAqUHts99bo+kjw=; b=M8VQHihAWvWZye0f3dg3bO4dQK
        yl6OJ/Q1wSF3qZs5z4uZ8K67AIEAlqMAu9Zyhy0YeRnFxEssOQeome0jIny+ADyAclL6L29MqaNlS
        JPMsOgKuDhcWOWCaGBwdjKjZf2YlNBvShImPkJDuctKG0aFHTOEdJBUOLozUQRKZmE6KZeT3NCAHt
        uZpovBLXyYXRwDvxbPM30UpQQzdHGMVBiN6PdEkhug29FnBL+LJmNES35aYg+BU4ALsuxyffFyDC0
        22qwP468mW3a3eSwj9IMDNjc0Rhyo6yT9rzXoZ996iJS8l2KaLQZeOLkYtit07XMrZVP/6cSDguHl
        ozYBwh9w==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0HYJ-00Bvme-NB; Thu, 23 Dec 2021 06:26:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: wan/lmc: fix spelling of "its"
Date:   Wed, 22 Dec 2021 22:26:11 -0800
Message-Id: <20211223062611.24125-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the possessive "its" instead of the contraction of "it is" ("it's")
in user messages.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wan/lmc/lmc_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211222.orig/drivers/net/wan/lmc/lmc_main.c
+++ linux-next-20211222/drivers/net/wan/lmc/lmc_main.c
@@ -550,7 +550,7 @@ static int lmc_siocdevprivate(struct net
                            (timeout-- > 0))
                         cpu_relax();
 
-                    printk(KERN_DEBUG "%s: Waited %d for the Xilinx to clear it's memory\n", dev->name, 500000-timeout);
+                    printk(KERN_DEBUG "%s: Waited %d for the Xilinx to clear its memory\n", dev->name, 500000-timeout);
 
                     for(pos = 0; pos < xc.len; pos++){
                         switch(data[pos]){
