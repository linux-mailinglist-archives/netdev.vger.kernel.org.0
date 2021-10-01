Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412C541F085
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354963AbhJAPIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34597 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354883AbhJAPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D4F645C00FF;
        Fri,  1 Oct 2021 11:06:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 01 Oct 2021 11:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=WCYu8x1gJNSS3ONEg0VlhSKpT5m5gUuOR2veIVDg0c0=; b=NskM7diM
        kK2JHcq1qcPOzDdlpLZmetk3qHO4beIjZ5yaJTnP9sYWkG9eToqIP82cZByZQFL1
        XKpI7CKJym+fg0sKNGBPRlMD/jbwOZk1CXKfbm/UryT3dEi/dtQcGhJ5bycDIEsf
        1mDL5NCMBEAuywLC0UaY9kXCx8xA5D23tCbR662coDfjESAhAccYjkV74yN5BSpB
        TltW61vmGIGCd+LbtrkRdVkT1JLwPVFOf74LOEN8RxGOfH5j0Pzylbupbs5M0n9X
        mazyybIg3CHL74v1+ljyPL6t2JA+UelgqG1ZVlyHLkv0nNUGaDyH1bipIA3M4bll
        zRHKVjkUN+6eVQ==
X-ME-Sender: <xms:DCRXYXRA-ebJje2eQVwBm2QxItV7LxdiRVSP7g9xvHN4WpuXxliebw>
    <xme:DCRXYYzF7pJPKTDdfDaHWaOT2FhBfeWjCyCL9OFTYUR51TF5yBZQSgJLnnxmi6TVI
    2bYUt_t-g5vXf8>
X-ME-Received: <xmr:DCRXYc08lpHXgrmNK0Edsc8DHUdFe3AXAXeXqPywPMajpCjrbrXu9CBf7P4gfvAanRfq2H9XfMWV5SpkCYBeL_2uvpYul-K42w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DCRXYXB9dw_gMZ4BmYW035D8Vyd0RGQ9wc45OgtCZXo-GCzftpKa7A>
    <xmx:DCRXYQjNFvAHV4W9KnWPzLRJDFQpS-JV4DGBPaoZ9g3-ginXa_wKmA>
    <xmx:DCRXYboYMSojQppUbXIQ6jnaw7LPTnLLC56lHxUhCVB796SY0xMKog>
    <xmx:DCRXYTtzO3NJUUTYFWoklqT6mxgrdZe4e3XSgrKtnMHBt-AYEcw6yg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 2/7] cmis: Fix wrong define name
Date:   Fri,  1 Oct 2021 18:06:22 +0300
Message-Id: <20211001150627.1353209-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
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
index 499355d0e024..408db6f26c3b 100644
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
index cfac08f42904..e3012ccfdd79 100644
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

