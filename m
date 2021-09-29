Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6C41BF3D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244430AbhI2GnM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Sep 2021 02:43:12 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:5226 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244420AbhI2GnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:43:10 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480408749069511;
        Wed, 29 Sep 2021 14:41:14 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Wed, 29 Sep 2021 14:41:13 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/dsa/tag_ksz.c: remove superfluous headers
Date:   Wed, 29 Sep 2021 14:41:06 +0800
Message-ID: <20210929064106.4764-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tag_ksz.c hasn't use any macro or function declared in linux/slab.h.
Thus, these files can be removed from tag_ksz.c safely without
affecting the compilation of the ./net/dsa module

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/dsa/tag_ksz.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index fa1d60d13..3509fc967 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -6,7 +6,6 @@
 
 #include <linux/etherdevice.h>
 #include <linux/list.h>
-#include <linux/slab.h>
 #include <net/dsa.h>
 #include "dsa_priv.h"
 
-- 
2.25.1


