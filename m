Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139241A99AB
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408479AbgDOJyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:54:32 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58826 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408469AbgDOJyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:54:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TvbOtyc_1586944461;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TvbOtyc_1586944461)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Apr 2020 17:54:21 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH net-next] Documentation: Fix tcp_challenge_ack_limit default value
Date:   Wed, 15 Apr 2020 17:54:04 +0800
Message-Id: <20200415095404.5673-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default value of tcp_challenge_ack_limit has been changed from
100 to 1000 and this patch fixes its documentation.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 Documentation/networking/ip-sysctl.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ee961d322d93..6fcfd313dbe4 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -812,7 +812,7 @@ tcp_limit_output_bytes - INTEGER
 tcp_challenge_ack_limit - INTEGER
 	Limits number of Challenge ACK sent per second, as recommended
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
-	Default: 100
+	Default: 1000
 
 tcp_rx_skb_cache - BOOLEAN
 	Controls a per TCP socket cache of one skb, that might help
-- 
2.16.6

