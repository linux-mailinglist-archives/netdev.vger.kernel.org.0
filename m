Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA134704E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfFOOJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:24 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46287 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C43421F30;
        Sat, 15 Jun 2019 10:09:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8SIgl/mfVbuupzqe7seDQjko3F5oeWmAmC09py9L3g8=; b=oDuPeqr7
        6UOhtheQ4CDT+B/voJB7fGozU2Lb/GE6vUQRVNz5o507s1knNr/LbiEEtZjAMda0
        raJwQ0ifrWAMVCWohUwIjDqUp+qjyzhB52p2UwnqVOcsCScMP8WBpD4ygSzsfOa9
        3N/jxI+ohGH0onY8E1foJefFqG1miATBtpSpRQcDLA5AkkVwoHCznv2oqA7ku2DF
        QLkpKYMUfdzs0PQvUZXPOh++4Gg+i8Y75r1YpYk/2LYDGDjg1kOIe58epFo+tqH6
        6S2rGMdd4Gu8k6gcF9MSN9/sf3us0a9KOXnPqjD26wNW0bqcRjJLYopFtr5FuAxc
        qRSGFEQLrzpZwA==
X-ME-Sender: <xms:EvwEXTG6Yz0jsjfJkWFyGiMLXPBsmBPsoiRAH-pI5CPRiWZ_gvayaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepge
X-ME-Proxy: <xmx:EvwEXcvMyiBpFxeKCr_il00AyFFxeVUsNxpsbfRrU1jUMsd9Ye8ryQ>
    <xmx:EvwEXZklN0K9ua_fd5bvo87dN3bD8uHI3Tn0f0wjcthUsac9t5ZeaQ>
    <xmx:EvwEXfOMg5sXA8x4sVcJWaNutcnEwV1dxjHJSVxp1sSNkiCVvSXVYQ>
    <xmx:EvwEXRhJPxKCJV76uJpEFLMrceCu12cwdRiVfaE8Ap3yShSixBQ-Fg>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5D69380085;
        Sat, 15 Jun 2019 10:09:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/17] netdevsim: Ignore IPv6 multipath notifications
Date:   Sat, 15 Jun 2019 17:07:39 +0300
Message-Id: <20190615140751.17661-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to previous patch, have netdevsim ignore IPv6
multipath notifications for now.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/fib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 8c57ba747772..83ba5113210d 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -190,6 +190,13 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
+		if (info->family == AF_INET6) {
+			struct fib6_entry_notifier_info *fen6_info = ptr;
+
+			if (fen6_info->multipath_rt)
+				return NOTIFY_DONE;
+		}
+
 		err = nsim_fib_event(data, info,
 				     event == FIB_EVENT_ENTRY_ADD);
 		break;
-- 
2.20.1

