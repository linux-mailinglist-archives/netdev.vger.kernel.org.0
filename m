Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F41726B8AA
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgIPAsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:48:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38271 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgIOLmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:42:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B4F965C0080;
        Tue, 15 Sep 2020 07:41:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 07:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=O8hTa9BvVDgAZsqQ/+xJzBwPvnQIqDMbM9Z8a0xuQFk=; b=k5rn1ckp
        b4ZF4x7+wq8THmSmvC2aGiOhKV809128y4mdFOpt+6KmMbMJ97EYEL7z5qukj9VG
        jizIqFCNJzFcAaNl1ZwYivShobzOovXb2a7Rvn+TKlO/copF0Xe8ApbudHQFlL/t
        xj6vB+EAiYPjOgx+HnrAaAen2HNrTsMrDiBM6QtjBCY7XHMxDh27tDmmpyI7A3GG
        a5+tqnPqbB7xgx7BKbFk2D2rCmRnSCPTvl9CiYJyXpTZ3TiSJ/lXecMyK/5Ky/cf
        +uONt55AgeGemCUfkpE2tcS4OX3AFiQOFvnqdowk2EU3gxau3x9me/vq0RyrJbqN
        VBhGf0UigBFpcg==
X-ME-Sender: <xms:f6hgX7FBiewaP7nXehd483fD7dVujOIQc1Ebl7yRE2VMiex6iTdlrg>
    <xme:f6hgX4UamFyPC1rhqjrbbnkEAfxbtGpdfJ7wifmQGvchuMlBXeblcmLvTmO1-ecAd
    RB37kL8FLglB1Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefiedrkedvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:f6hgX9Igk9R1P0IvqWsqwP1-Ct2MCbH7eH7PGLQjENNta-LSSSjatQ>
    <xmx:f6hgX5ERnVTGbx5ggHmU2iNjAtGmg7UkD6tTLEiMzJrZ26SlVqkAWw>
    <xmx:f6hgXxWFmFBEhzEjLMLqfK1Wzs2lvNq5ETLo_9-9LyaU8KeivUD_tQ>
    <xmx:f6hgX-g_JSIdaia7TI8bynFVEaG-m48Xn_mA4wap7ymqgK9ixJVj4g>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 064A83064685;
        Tue, 15 Sep 2020 07:41:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] nexthop: Remove unused function declaration from header file
Date:   Tue, 15 Sep 2020 14:40:59 +0300
Message-Id: <20200915114103.88883-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915114103.88883-1-idosch@idosch.org>
References: <20200915114103.88883-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Not used or implemented anywhere.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 3a4f9e3b91a5..2e44efe5709b 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -109,9 +109,6 @@ enum nexthop_event_type {
 	NEXTHOP_EVENT_DEL
 };
 
-int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
-			  enum nexthop_event_type event_type,
-			  struct nexthop *nh);
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 
-- 
2.26.2

