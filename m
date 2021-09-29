Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2233D41BF36
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244447AbhI2GiR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Sep 2021 02:38:17 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:16013 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244426AbhI2GiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:38:16 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480406372945763;
        Wed, 29 Sep 2021 14:36:19 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Wed, 29 Sep 2021 14:36:18 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/dsa/tag_8021q.c: remove superfluous headers
Date:   Wed, 29 Sep 2021 14:36:11 +0800
Message-ID: <20210929063611.3326-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tag_8021q.c hasn't use any macro or function declared in linux/if_bridge.h.
Thus, these files can be removed from tag_8021q.c safely without
affecting the compilation of the ./net/dsa module

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/dsa/tag_8021q.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index f8f7b7c34..935d0264e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -6,7 +6,6 @@
  * dsa_8021q_netdev_ops is registered for API compliance and not used
  * directly by callers.
  */
-#include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
 #include <linux/dsa/8021q.h>
 
-- 
2.25.1


