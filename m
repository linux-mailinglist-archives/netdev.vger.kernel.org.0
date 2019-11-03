Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D85ED296
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfKCIg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:29 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49933 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfKCIg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A87E20E72;
        Sun,  3 Nov 2019 03:36:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Hvl5T280L543cVtumFgK4WrNpjjW8IgwrfRoth8Nudg=; b=FMKJVVGR
        25QMeS/1x0/XiF9I2425YGdkKx3yGyScyWlOxFCaBBpO4hCyvKSVU9+upa/LPtpn
        vDlz0RV633YO31lgVTbGiyXmpAGMRu6M07HwuLSUX4LIPf8niu/mes3zCxKBP9B+
        asd68Nf9xqhTQ4PBfU9tINXZGXwB2T4HY4iebRuqQw+BI1X6+aLjWl1f2LWZLLz8
        QZ0Dz+5V8tjm0y3v41uQt56Db81rvEAttAsbKX4w0Q9tRSVDYgsytFxZMAszlFAQ
        IiyhEoctK4aO39uReJElTa9somaSPNeEOzCmCl0pu4wFHgOSZbt8rh7fV3He8Uuz
        k7sceu54RRD0xA==
X-ME-Sender: <xms:jJG-XV8NmkqNJodKWQFDdMCcVOjHt5KV3UyXP2MjZ6uYNlQaoJMR4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jJG-XYkyn-R-0B8g9OXv61-Rex0CT8Pt7J092SYq92-jwHmaD-rMOw>
    <xmx:jJG-XTYm8qggiaKMQBR8ZitCQfKi5uEdd4N_nhLrUDmBrEfIMjjkUg>
    <xmx:jJG-XefRe7aiidZver2MUhW4o-poYW0ETfHhC9q3u7_2iizOrEEAbQ>
    <xmx:jZG-XSLyv2lHmpPxG_KoZZiCv5G7yoxuVaEFyZvegZimF1dHXcLJ7A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFD20306005F;
        Sun,  3 Nov 2019 03:36:27 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/6] mlxsw: emad: Remove deprecated EMAD TLVs
Date:   Sun,  3 Nov 2019 10:35:50 +0200
Message-Id: <20191103083554.6317-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Remove deprecated EMAD TLVs.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/emad.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/emad.h b/drivers/net/ethernet/mellanox/mlxsw/emad.h
index a33b896f4bb8..5d7c78419fa7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/emad.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/emad.h
@@ -19,10 +19,7 @@
 enum {
 	MLXSW_EMAD_TLV_TYPE_END,
 	MLXSW_EMAD_TLV_TYPE_OP,
-	MLXSW_EMAD_TLV_TYPE_DR,
-	MLXSW_EMAD_TLV_TYPE_REG,
-	MLXSW_EMAD_TLV_TYPE_USERDATA,
-	MLXSW_EMAD_TLV_TYPE_OOBETH,
+	MLXSW_EMAD_TLV_TYPE_REG = 0x3,
 };
 
 /* OP TLV */
-- 
2.21.0

