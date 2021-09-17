Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8D140FA7A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343499AbhIQOm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:29 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35703 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343728AbhIQOm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:27 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 64F815C01F5;
        Fri, 17 Sep 2021 10:41:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 17 Sep 2021 10:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=t5jgAt+413n9aYO/w9Wb0ZHOhtGzq0WhoM1r2TKvIJY=; b=tkbnuFD9
        72ehj57/f2uCjtqsf6NS5rSK0I43LATxBOIFL98gMvDL7S4qXFEILh3OGlwu/+Ti
        7t3FYM9H96sTP9wtffkGrQvD/+zN4nfjyHZ6xfu1phBIMity29lfJva0GguNleyG
        rq7FB0gE5ZZjzW4k4Bnwl2DhlNHuCW57DBrOXP/DiItKJJBAhAraWTa615QmxNMg
        AGuwD9nhoOcVcAwWUl+7bGjp1koxgSvpaJOUmFT550+GyizHQwWNSn/eOgcN6bl9
        6pZy/5xCu21wC/HS3jZxxCK2hvZ/K19dIzeefqmc+Fh0sB1/iXa0hPYiGGhwf1l7
        0I8g285JfWiMTg==
X-ME-Sender: <xms:AKlEYaQv-_gb16lnSjb8z-cju23WBfAQUcG00Z3xTvIj9SrmndrZXg>
    <xme:AKlEYfy85hoKxoSDHT0XyEnXvxdC2XhFkkZiRAqaG-DYLk-x9ecj-NtDgQgLU8s56
    EUcd1RvbZMZwjQ>
X-ME-Received: <xmr:AKlEYX03uXmHLFZFSwbR4kRCRSNNQeUz5TKIVBtVuSfD__lp_X9OzvnR6TnDGmIpRnFef6AbqDjkarWDRjEqYL-e11TZG_yyww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:AKlEYWBa1g1EQ9m3adwtRNXJXREQiWBoknFnQMEoJwMT3xYjJbTsbA>
    <xmx:AKlEYTh_OkYHsdBWZb0_MK__bkHhQ77ipsaQeWzW1fo5DH7ueZp4Ag>
    <xmx:AKlEYSoXu82teCuz5nV1w8B9nU1VRmOb6wbVk8BJnQ0yzOWmWDVtLQ>
    <xmx:AKlEYTee4xzxrnZCFz3xMaZiFLFDMTyYDO--5G_MKKLyHzA-OH4kig>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:41:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 2/7] cmis: Fix wrong define name
Date:   Fri, 17 Sep 2021 17:40:38 +0300
Message-Id: <20210917144043.566049-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Offset 0x10 in the Lower Memory stores the "VccMonVoltage".

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 2 +-
 cmis.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmis.c b/cmis.c
index 2a48c1a1d56a..7fa7da87a92a 100644
--- a/cmis.c
+++ b/cmis.c
@@ -271,7 +271,7 @@ static void cmis_show_mod_lvl_monitors(const __u8 *id)
 	PRINT_TEMP("Module temperature",
 		   OFFSET_TO_TEMP(CMIS_CURR_TEMP_OFFSET));
 	PRINT_VCC("Module voltage",
-		  OFFSET_TO_U16(CMIS_CURR_CURR_OFFSET));
+		  OFFSET_TO_U16(CMIS_CURR_VCC_OFFSET));
 }
 
 static void cmis_show_link_len_from_page(const __u8 *page_one_data)
diff --git a/cmis.h b/cmis.h
index d365252baa48..5fb2efe08265 100644
--- a/cmis.h
+++ b/cmis.h
@@ -11,7 +11,7 @@
 
 /* Module-Level Monitors (Page 0) */
 #define CMIS_CURR_TEMP_OFFSET			0x0E
-#define CMIS_CURR_CURR_OFFSET			0x10
+#define CMIS_CURR_VCC_OFFSET			0x10
 
 #define CMIS_CTOR_OFFSET			0xCB
 
-- 
2.31.1

