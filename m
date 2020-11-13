Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75F2B1F8C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgKMQGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60937 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbgKMQGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A266E5C018D;
        Fri, 13 Nov 2020 11:06:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=BVQVSD3BWOKlqmYXCQPWWatOfcqEuIFS8OE1rp3E1BQ=; b=muYYjwTe
        EipU2p6NfKDWl0AyHB8N5wePtYeUsltXPJOD8vcBqm8OvcMioJrXO60FADld0r30
        qhVZlq86JoHn1OSeVms9ueFmtXSDiF2Ra/KGcKM7Pge2WFa5PDSC6/4noLE+QQrc
        p9WjneYRcWqZStRi36lgcuPxs92T67OEVVnOLKd3lSdFdOuH2D4bouBg9yUt+Mwv
        aX+Bdzski0XMOEyh0spnmdW/Yz9RR4WgcyRC6KxVlqWh7+0Un0YPnZisSEdB1AHB
        jRfc8sOt9gLxcZrvelX61pLEQrP2wJZ/LfHU4F4cGtc4te2VozcClqSFg6BmTTwZ
        9Kst8w/95orWAA==
X-ME-Sender: <xms:FK-uX50WwwCtjmQnCZv72vM0Gi1118jHlyXXcuIRTgOS86joR7DokA>
    <xme:FK-uXwHLE-Bnq6nru_mOhlyR5RGet3TPHhG6n98EVqvi3Dmat2R3HaN_bO6q73erJ
    blqimru31CxaVM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FK-uX56tHCs3RVFaN5doAde8GKmwnwH0G6iJsLQBXrH0yshYLoHhww>
    <xmx:FK-uX21MvXXbZ-6ilC4aIavahlmWH6Lco_SGQ-xqg-Tq9Fwl8nYSFA>
    <xmx:FK-uX8E8A2v_96gEf4YrZ5IdFceUrBnVre2rpgQHWFyaAHjzyVxGWw>
    <xmx:FK-uXwA3V48DZYTxtK1Klq42IzAucKo21_aRhUCrkNNwj5TFGajipA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1450A3280059;
        Fri, 13 Nov 2020 11:06:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/15] mlxsw: spectrum_router: Remove unused field 'prio' from IPv4 FIB entry struct
Date:   Fri, 13 Nov 2020 18:05:50 +0200
Message-Id: <20201113160559.22148-7-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Not used anywhere.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 87acb2bbb6fe..bd4bf9316390 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -433,7 +433,6 @@ struct mlxsw_sp_fib4_entry {
 	struct mlxsw_sp_fib_entry common;
 	struct fib_info *fi;
 	u32 tb_id;
-	u32 prio;
 	u8 tos;
 	u8 type;
 };
@@ -4832,7 +4831,6 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	fib4_entry->fi = fen_info->fi;
 	fib_info_hold(fib4_entry->fi);
-	fib4_entry->prio = fen_info->fi->fib_priority;
 	fib4_entry->tb_id = fen_info->tb_id;
 	fib4_entry->type = fen_info->type;
 	fib4_entry->tos = fen_info->tos;
-- 
2.28.0

