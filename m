Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283782A8EF2
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 06:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgKFFhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 00:37:38 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:48070 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbgKFFhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 00:37:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UEOe0vL_1604641052;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEOe0vL_1604641052)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 13:37:32 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     andrew@lunn.ch
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/dsa: remove unused macros to tame gcc warning
Date:   Fri,  6 Nov 2020 13:37:30 +0800
Message-Id: <1604641050-6004-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some macros unused, they causes much gcc warnings. Let's
remove them to tame gcc.

net/dsa/tag_brcm.c:51:0: warning: macro "BRCM_EG_RC_SWITCH" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:53:0: warning: macro "BRCM_EG_RC_MIRROR" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:55:0: warning: macro "BRCM_EG_TC_MASK" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:35:0: warning: macro "BRCM_IG_TS_SHIFT" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:46:0: warning: macro "BRCM_EG_RC_MASK" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:49:0: warning: macro "BRCM_EG_RC_PROT_SNOOP" is not
used [-Wunused-macros]
net/dsa/tag_brcm.c:34:0: warning: macro "BRCM_IG_TE_MASK" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:43:0: warning: macro "BRCM_EG_CID_MASK" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:50:0: warning: macro "BRCM_EG_RC_PROT_TERM" is not
used [-Wunused-macros]
net/dsa/tag_brcm.c:54:0: warning: macro "BRCM_EG_TC_SHIFT" is not used
[-Wunused-macros]
net/dsa/tag_brcm.c:52:0: warning: macro "BRCM_EG_RC_MAC_LEARN" is not
used [-Wunused-macros]
net/dsa/tag_brcm.c:48:0: warning: macro "BRCM_EG_RC_EXCEPTION" is not
used [-Wunused-macros]

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Lunn <andrew@lunn.ch> 
Cc: Vivien Didelot <vivien.didelot@gmail.com> 
Cc: Florian Fainelli <f.fainelli@gmail.com> 
Cc: Vladimir Oltean <olteanv@gmail.com> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Jakub Kicinski <kuba@kernel.org> 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/dsa/tag_brcm.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e934dace3922..ce23b5d4c6b8 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -30,29 +30,14 @@
 /* 1st byte in the tag */
 #define BRCM_IG_TC_SHIFT	2
 #define BRCM_IG_TC_MASK		0x7
-/* 2nd byte in the tag */
-#define BRCM_IG_TE_MASK		0x3
-#define BRCM_IG_TS_SHIFT	7
 /* 3rd byte in the tag */
 #define BRCM_IG_DSTMAP2_MASK	1
 #define BRCM_IG_DSTMAP1_MASK	0xff
 
 /* Egress fields */
 
-/* 2nd byte in the tag */
-#define BRCM_EG_CID_MASK	0xff
-
 /* 3rd byte in the tag */
-#define BRCM_EG_RC_MASK		0xff
 #define  BRCM_EG_RC_RSVD	(3 << 6)
-#define  BRCM_EG_RC_EXCEPTION	(1 << 5)
-#define  BRCM_EG_RC_PROT_SNOOP	(1 << 4)
-#define  BRCM_EG_RC_PROT_TERM	(1 << 3)
-#define  BRCM_EG_RC_SWITCH	(1 << 2)
-#define  BRCM_EG_RC_MAC_LEARN	(1 << 1)
-#define  BRCM_EG_RC_MIRROR	(1 << 0)
-#define BRCM_EG_TC_SHIFT	5
-#define BRCM_EG_TC_MASK		0x7
 #define BRCM_EG_PID_MASK	0x1f
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM) || \
-- 
1.8.3.1

