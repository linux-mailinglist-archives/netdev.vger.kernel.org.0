Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16F22A8EE8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 06:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgKFFaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 00:30:00 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:44699 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbgKFF37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 00:29:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UEOgfMD_1604640596;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEOgfMD_1604640596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 13:29:56 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     Jakub Kicinski <kuba@kernel.org>, Tom Parkin <tparkin@katalix.com>,
        James Chapman <jchapman@katalix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/l2tp: remove unused macros to tame gcc warning
Date:   Fri,  6 Nov 2020 13:29:54 +0800
Message-Id: <1604640594-5750-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There some unused macros cause gcc complain:

net/l2tp/l2tp_core.c:73:0: warning: macro "L2TP_HDRFLAG_P" is not used
[-Wunused-macros]
net/l2tp/l2tp_core.c:80:0: warning: macro "L2TP_SLFLAG_S" is not used
[-Wunused-macros]
net/l2tp/l2tp_core.c:81:0: warning: macro "L2TP_SL_SEQ_MASK" is not used
[-Wunused-macros]

Let's remove them to tame gcc.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Jakub Kicinski <kuba@kernel.org> 
Cc: Tom Parkin <tparkin@katalix.com> 
Cc: James Chapman <jchapman@katalix.com> 
Cc: netdev@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/l2tp/l2tp_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7be5103ff2a8..672a53f602b5 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -73,16 +73,11 @@
 #define L2TP_HDRFLAG_L	   0x4000
 #define L2TP_HDRFLAG_S	   0x0800
 #define L2TP_HDRFLAG_O	   0x0200
-#define L2TP_HDRFLAG_P	   0x0100
 
 #define L2TP_HDR_VER_MASK  0x000F
 #define L2TP_HDR_VER_2	   0x0002
 #define L2TP_HDR_VER_3	   0x0003
 
-/* L2TPv3 default L2-specific sublayer */
-#define L2TP_SLFLAG_S	   0x40000000
-#define L2TP_SL_SEQ_MASK   0x00ffffff
-
 #define L2TP_HDR_SIZE_MAX		14
 
 /* Default trace flags */
-- 
1.8.3.1

