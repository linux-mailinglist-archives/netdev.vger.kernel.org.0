Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58A42BD2E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhJMKkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:40:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57011 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhJMKkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:40:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A10F45C018D;
        Wed, 13 Oct 2021 06:38:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 13 Oct 2021 06:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=2mYkutHChlBFuuAhDBmhrinZDNVLRsEXrIr54m8HBxc=; b=co9IjO05
        EI78qt7okvVpR3JoLlRHBJm71erO5yOQKM1jEkdeJoeqJKJDpM1mbnLvKVpsoYSR
        9qtryG/gA8YkEjWQYqnWSq9pqeNwGtF7Z6fsUCj4OselcQPYqfHlyl0ZGrP6+GLt
        RJLA1oXqgSqsZL4NFlh3kmmH9Ddz5i48Hx66Y+cw1p7eMWsoApj+5QcFHsnI7KU2
        jz4PiV98nCkMdu/SP2n7GnxkE2tqNOQ/4Cs467i47DR3WK/lP4gmvzNWpZyok/CN
        jupuQZxkmLCp1iUTd0gdrOAgjiLvXLI8NqJzKiobnhmcOrOZEkgsdINz/+ir5dLi
        GPTPHMgR0PufZA==
X-ME-Sender: <xms:HLdmYYaHOR9jn32iPsqpAoDbBTuUWAws45ptPEfGkh_IQ8Po9UFYnw>
    <xme:HLdmYTY0v2bd21ESgh3pnQftcbKMBy47fVc9eoEA0n8MPD6nVt6Ad-W6lNh8HZGfK
    i69wC0kDzRrXAk>
X-ME-Received: <xmr:HLdmYS8XenWC2850i6K1Z8GxAZjAZaqKg0yf4h3AB12L1QMvxFuBkXbQlgAwrJq9iX8M_ZL4QzYfv-FGIGLLz5Uc-ev-5iiNuBGtUYdqHSehhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HLdmYSqFBxzMRaaHQBuXfk17XZ7ycYrA5NRjC3_Dowk6YSpNWqGUGg>
    <xmx:HLdmYToz0xuNiVPxBRRFHc-Ffm16MLcPN-z8carOzptjWNCJ3VNxNA>
    <xmx:HLdmYQSIUZ9neoVnCaJa6wMHxbZLzH3Zimmz8zoL84PGleuaJXVEHQ>
    <xmx:HLdmYUkPf-HTcdOHgvUgKMzuXTzD-TY7RuGhzR3cfeRDv4KoPjw7Fw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:38:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] mlxsw: reg: Fix a typo in a group heading
Date:   Wed, 13 Oct 2021 13:37:44 +0300
Message-Id: <20211013103748.492531-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013103748.492531-1-idosch@idosch.org>
References: <20211013103748.492531-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

There is no such thing as "traffic group". The group that this is a heading
of is "per traffic class counters". Fix the heading.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ed6c3356e4eb..62b2df8a0715 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5371,7 +5371,7 @@ MLXSW_ITEM64(reg, ppcnt, tx_pause_duration,
 MLXSW_ITEM64(reg, ppcnt, tx_pause_transition,
 	     MLXSW_REG_PPCNT_COUNTERS_OFFSET + 0x70, 0, 64);
 
-/* Ethernet Per Traffic Group Counters */
+/* Ethernet Per Traffic Class Counters */
 
 /* reg_ppcnt_tc_transmit_queue
  * Contains the transmit queue depth in cells of traffic class
-- 
2.31.1

