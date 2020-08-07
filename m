Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022FC23F314
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 21:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHGTce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 15:32:34 -0400
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:57908 "EHLO
        mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgHGTce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 15:32:34 -0400
IronPort-SDR: V7AeIIJajMKV4ffn7ai1WZh4wGwVr3S6XxuFEUdpd/hcVCppxJWoEGlocw5gdFcvmvC9eayo0/
 QekAqwLNr4+wgQ/Q1vZbdk3akSiZdK68n3EEahz4Xm7HfOhq8wfWrFtpXcZcGBqs+XtwDm7P/k
 WYOwZ86a7xAleMquu7e5WdJTXOkJj3A/WC7QAeUhywTE8YuC6y20yy1lL/x8+X+C8sprmVgQYe
 9dSgG4JytyWiO7FtoYqwuI/Akhb3/1mCfxCk+yDgvlGmznWFVfXhf7FK0ixtWp5iM33S41bCA9
 LSE=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3Aa++VPRUwr8ttB8CAwF3kgbweHsjV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZRWBvqdThVPEFb/W9+hDw7KP9fy5BypQu93Y6ytKWacPfi?=
 =?us-ascii?q?dNsd8RkQ0kDZzNImzAB9muURYHGt9fXkRu5XCxPBsdMs//Y1rPvi/6tmZKSV?=
 =?us-ascii?q?3wOgVvO+v6BJPZgdip2OCu4Z3TZBhDiCagbb9oIxi6sATcutMVjId8Jao91x?=
 =?us-ascii?q?XEr3VVcOlK2G1kIk6ekQzh7cmq5p5j9CpQu/Ml98FeVKjxYro1Q79FAjk4Km?=
 =?us-ascii?q?45/MLkuwXNQguJ/XscT34ZkgFUDAjf7RH1RYn+vy3nvedgwiaaPMn2TbcpWT?=
 =?us-ascii?q?S+6qpgVRHlhDsbOzM/7WrajNF7gqBGrxK7vxFxw5DabpybOvR9ea3SctwUSH?=
 =?us-ascii?q?FdUstSTSFNHpmxY5cTA+cHIO1Wr5P9p1wLrRamBQejHvjgyj5SiX/wwKY00/?=
 =?us-ascii?q?4hHh/b0wM+BdIOsWjbrNboP6oVX+C61rLHzTvYYvNN2jf86I7IfQ49of2WRr?=
 =?us-ascii?q?1/b9PcxE8yHAzKklues5bqPy+J1usTqWib6fJtW+yshmMjqw98oziiytkih4?=
 =?us-ascii?q?fJm48Z1k3I+Tl4zYg6KtO1VUB2bMC5HZZQtSyXKYR4Tt8sTW9nvCs0yr0ItY?=
 =?us-ascii?q?C/cSUM1Z8pxAbfZuSDfoSV+B7vSeWcLSliiH54eb+yhwy+/VWhx+D6S8K6yk?=
 =?us-ascii?q?xFrjBfndnJrn0N0hvT5dWZRfZl5Ueh3CqP1xjU6uFZPUA4jarbJIAlwr43jp?=
 =?us-ascii?q?cTtUPDETPsl0XyjK+WcV4k+vSy5+TjZbXpuoWTN4tphQH5N6QhgM2/AeIgPg?=
 =?us-ascii?q?gPWWiU5/i82aXn8EHkWrlGk/47nrfDvJzHJMkWprS1DxJU34o77hawFTam0N?=
 =?us-ascii?q?AWnXkdK1JFfQqKj4bzNF7VLvD1Fuy/g1eskTdt2f/GIqftDY7TIXTbirfuYa?=
 =?us-ascii?q?5961JAyAo01d1f/4hbBaoFIPL0QULxssLXDgM3Mwy1x+bnFMty1pkEVWKIGK?=
 =?us-ascii?q?+ZP7vYsUWU6eI3P+mMeIgVtS7+K/c/+vHuiWE2lkMGcKmvw5QXdH64HvViI0?=
 =?us-ascii?q?WFf3XsmM0NEWAQvgoxVObqkkGNUSZPZ3auWKIx/j87CYy9AIfYWoCtmriB0z?=
 =?us-ascii?q?m9HpFMe29JFEiGEW30eIWcR/cMdCWSL9dnkjMaSbihRY4h1RWytADk0bprN/?=
 =?us-ascii?q?fb9TMGtZ390Nh4/PPTlR4s+jxuFcid0H+CT3tynmwWQz86xqd/oVZyyl2by6?=
 =?us-ascii?q?h3n+RYFcBP5/NOSgo1KZncz/ZkBNDuRA3OZNKJRU2gQtq4HTExQNMxw9sSY0?=
 =?us-ascii?q?ljAdWulBfD3zClA7UNjbyEGIQ08r7A33j2P8t9zWjJ1LU8gFY4XMtCLnOmhq?=
 =?us-ascii?q?Fh+AjJHYLJkFuWl7ysdasC2C7B7mCDzXCBvEtASg5/Tb3FXWwDZkvRtdn56F?=
 =?us-ascii?q?nNQKSgCbk8KQtBys6DKq1UZd31l1lJX+nsa5ziZDepkm20Aj6Oy6+CbY72dn?=
 =?us-ascii?q?9b2z/STAAHmgwX8H2uMwUiCCalv2/ESjt0GhanbVzE6vVkrH69CEM5nC+QaE?=
 =?us-ascii?q?g0+bO/+xcTzdKGRv8exLMPu291pTx+En6m3MPQBsbGrQc3L/YUWs80/FoSjT?=
 =?us-ascii?q?GRjAd6JJH1d60=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AqBADUqy1f/xCltltgHQEBAQEJARI?=
 =?us-ascii?q?BBQUBR4FDgxlUX401kiyRegsBAQEBAQEBAQEnDQECBAEBhEyCOSU4EwIDAQE?=
 =?us-ascii?q?BAwIFAQEGAQEBAQEBBQQBhg9Fgjcig0YLASMjgT8SgyYBglcptj0zhBCFIoF?=
 =?us-ascii?q?AgTiIH4UKgUE/hF+KNASPPaZlgmyDC4RZfZEmDyGgDY1lhEahQ4F6TSAYgyQ?=
 =?us-ascii?q?JRxkNjisXjiZCMDcCBggBAQMJVwE9AZANAQE?=
X-IPAS-Result: =?us-ascii?q?A2AqBADUqy1f/xCltltgHQEBAQEJARIBBQUBR4FDgxlUX?=
 =?us-ascii?q?401kiyRegsBAQEBAQEBAQEnDQECBAEBhEyCOSU4EwIDAQEBAwIFAQEGAQEBA?=
 =?us-ascii?q?QEBBQQBhg9Fgjcig0YLASMjgT8SgyYBglcptj0zhBCFIoFAgTiIH4UKgUE/h?=
 =?us-ascii?q?F+KNASPPaZlgmyDC4RZfZEmDyGgDY1lhEahQ4F6TSAYgyQJRxkNjisXjiZCM?=
 =?us-ascii?q?DcCBggBAQMJVwE9AZANAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 07 Aug 2020 21:32:32 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/3 linux-next] selftests: netfilter: kill running process only
Date:   Fri,  7 Aug 2020 21:32:20 +0200
Message-Id: <20200807193220.12735-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid noise like the following:
nft_flowtable.sh: line 250: kill: (4691) - No such process

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index e98cac6f8bfdd..a47d1d8322104 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -250,8 +250,14 @@ test_tcp_forwarding_ip()
 
 	sleep 3
 
-	kill $lpid
-	kill $cpid
+	if ps -p $lpid > /dev/null;then
+		kill $lpid
+	fi
+
+	if ps -p $cpid > /dev/null;then
+		kill $cpid
+	fi
+
 	wait
 
 	check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"
-- 
2.27.0

