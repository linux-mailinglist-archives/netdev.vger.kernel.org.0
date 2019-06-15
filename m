Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0604147049
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFOOJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42575 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbfFOOJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5731E21F14;
        Sat, 15 Jun 2019 10:09:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=f7MvnLZ7IsDhMMSwKPMFcvAqbQXbupza9JPFxou6IXY=; b=mnXqpwQr
        kpS153hn29cl9s1MtlDUrbgz5BHk4okM8LEYxe8L/zmLUYGJeyaicknyDERkH6Dc
        bsZng8rbvzm1+h89Vu4xcgRxSZxS+kiIMvSnf5ydR2Gt0tbfVKDckIoirl7TzBeX
        EXg4cob9rZoASOO4wEpjyV13Ykz7mcPeczYBPT/CU9vurrNNrfwnSaBI/gil5Jnc
        NXxrxCGAJG2hfUUGbbwG8VsFwLXvPSDoEwXUhSUaHo1KqnM8oMUrAprPfUR6Vr+R
        iuOtnhfdBcauMIWu5IVgHjUjaaTzhunEJF8mRbisufl7mbu4mU4OXIXh1fc1dlfP
        Y93a04jWORVK7A==
X-ME-Sender: <xms:BvwEXYfYqxGo6AGFRbZUEDiFpU5RwuPJ2aKTP531O7J2h9JKUYemtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:BvwEXSoRio7cu0-NQtL_IopcOkTWPmD9n9lQH_o9H4iHx8iHCtTGTg>
    <xmx:BvwEXcDHxG-LZI2vLx-ohaUZ2uJWRrT4Sw9SCA23ej10o0k3OEEKeg>
    <xmx:BvwEXdclMxvIMIzgWgdaP499g09tKK29nzhW4woziRCCdfcuUSf9ZQ>
    <xmx:BvwEXVeSpylKqYeI6C7uJ71mbok1OZAwtbX6oxHDrCogDZZUqOfOaA>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23BF0380088;
        Sat, 15 Jun 2019 10:09:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/17] netlink: Document all fields of 'struct nl_info'
Date:   Sat, 15 Jun 2019 17:07:35 +0300
Message-Id: <20190615140751.17661-2-idosch@idosch.org>
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

Some fields were not documented. Add documentation.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/netlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 28ece67f5312..ce66e43b9b6a 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -378,7 +378,9 @@ struct nla_policy {
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
+ * @nl_net: Network namespace
  * @portid: Netlink PORTID of requesting application
+ * @skip_notify: Skip netlink notifications to user space
  */
 struct nl_info {
 	struct nlmsghdr		*nlh;
-- 
2.20.1

