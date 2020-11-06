Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618CA2A8F02
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 06:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgKFFn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 00:43:57 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:55759 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgKFFn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 00:43:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UEOghrS_1604641433;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEOghrS_1604641433)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 13:43:54 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/xdp: remove unused macro REG_STATE_NEW
Date:   Fri,  6 Nov 2020 13:43:51 +0800
Message-Id: <1604641431-6295-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To tame gcc warning on it:
net/core/xdp.c:20:0: warning: macro "REG_STATE_NEW" is not used
[-Wunused-macros]

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Jakub Kicinski <kuba@kernel.org> 
Cc: Alexei Starovoitov <ast@kernel.org> 
Cc: Daniel Borkmann <daniel@iogearbox.net> 
Cc: Jesper Dangaard Brouer <hawk@kernel.org> 
Cc: John Fastabend <john.fastabend@gmail.com> 
Cc: netdev@vger.kernel.org 
Cc: bpf@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 net/core/xdp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..3d88aab19c89 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -19,7 +19,6 @@
 #include <trace/events/xdp.h>
 #include <net/xdp_sock_drv.h>
 
-#define REG_STATE_NEW		0x0
 #define REG_STATE_REGISTERED	0x1
 #define REG_STATE_UNREGISTERED	0x2
 #define REG_STATE_UNUSED	0x3
-- 
1.8.3.1

