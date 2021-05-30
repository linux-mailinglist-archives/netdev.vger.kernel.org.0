Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558023950B8
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 13:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhE3Lxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 07:53:33 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54793 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229500AbhE3Lxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 07:53:33 -0400
X-UUID: 66d3ffed4aec4f699251acbe410c59a7-20210530
X-UUID: 66d3ffed4aec4f699251acbe410c59a7-20210530
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 253908738; Sun, 30 May 2021 19:51:51 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 30 May 2021 19:51:49 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 30 May 2021 19:51:48 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <Rocco.Yue@gmail.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH] ipv6: align code with context
Date:   Sun, 30 May 2021 19:38:11 +0800
Message-ID: <20210530113811.8817-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Tab key is used three times, causing the code block to
be out of alignment with the context.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 net/ipv6/addrconf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b0ef65eb9bd2..048570900fdf 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6903,10 +6903,10 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.proc_handler   = proc_dointvec,
 	},
 	{
-		.procname		= "addr_gen_mode",
-		.data			= &ipv6_devconf.addr_gen_mode,
-		.maxlen			= sizeof(int),
-		.mode			= 0644,
+		.procname	= "addr_gen_mode",
+		.data		= &ipv6_devconf.addr_gen_mode,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
 		.proc_handler	= addrconf_sysctl_addr_gen_mode,
 	},
 	{
-- 
2.18.0

