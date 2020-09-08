Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FBF260E5C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgIHJLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:11:30 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41827 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbgIHJL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7865AF4B;
        Tue,  8 Sep 2020 05:11:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=BGlCjXHlSpXsEhnSB1Y7H5dkZ06FHHGb1EbfvjFmRSY=; b=TthN0ZoX
        ScaPY12THrmjdJ9VTmEcRUlsbutYzPJ501BNh8bedAjZx2fuFbdOX0ITMscwSsoD
        TliVnZ1VaL0+EQamMzFh2cXGGbab3qDbnAsNzlSlNe/plsdVeRXATufH0MLDhInq
        npyxgUukqZyWIZrRzRFaotJmjEhdiyI0tbZuAVNwiPfjPgt/JuT8GQl5x/V6k/F7
        UmbFXj67uBRPE6HUcgY9ZQGqYceT6jzLUt+aSZzV7vzxNX4jtj6GjUoJSjWaCHyI
        MAL9S+2XJ3kBym62on0H35hUdPc6QUdiUNu18zkF5hYw+t/hjQYqgQUHna52B9DC
        fPCsgz05+uAr8A==
X-ME-Sender: <xms:v0pXX26tVA53IKCiTNqq6wta4CBO4uv231yj4A2_5GRosYTbB6ccJA>
    <xme:v0pXX_7HPLvJIKDCujBYufbcWrFJrNdDDBRGaKP0kV7E7DlOEC34Kl9UdQ-k9oi0s
    heRKITHnqsCcPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:v0pXX1ezF-5JvrYxixQJCYVQ5NtaTPw2-GGg5o3YQXQbxcRXbXADlA>
    <xmx:v0pXXzLyTrYt3h4lmRFq_Q_vDi-1QfkjbguK8jpNSixRVzPWSmjzuw>
    <xmx:v0pXX6LPkWtTIfpGfUDaX8HcLcFIsOSRAOYMlLjCYQ5TT2x31B0kyw>
    <xmx:v0pXX20zFX-ZUdCVjoKOTxLIMHLWqMNQAC0H2EBroFTQeFArBY_srw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3C303064605;
        Tue,  8 Sep 2020 05:11:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 01/22] nexthop: Remove unused function declaration from header file
Date:   Tue,  8 Sep 2020 12:10:16 +0300
Message-Id: <20200908091037.2709823-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Not used or implemented anywhere.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
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

