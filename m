Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436C01696AE
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWH5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:57:12 -0500
Received: from mx57.baidu.com ([61.135.168.57]:41270 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbgBWH5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:57:12 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id B69D3236C005
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 15:56:53 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] tcpv6: define th variable only once
Date:   Sun, 23 Feb 2020 15:56:54 +0800
Message-Id: <1582444614-6461-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

to remove -Wshadow warning

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/ipv6/tcpv6_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 1796856bc24f..8d9b31ef98bf 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -51,7 +51,7 @@ static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
 
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-		struct tcphdr *th = tcp_hdr(skb);
+		th = tcp_hdr(skb);
 
 		/* Set up pseudo header, usually expect stack to have done
 		 * this.
-- 
2.16.2

