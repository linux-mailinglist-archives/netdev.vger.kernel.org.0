Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576AF40FA80
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245718AbhIQOmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42967 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245668AbhIQOmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 65C1B5C0054;
        Fri, 17 Sep 2021 10:41:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 17 Sep 2021 10:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=x4J8reGaSF8uDtTVxmggr85GwMO34kOnvq4DCaJfDv0=; b=wPHqZ2uz
        f6Si+JDm+dxvUnAQS9dQd6/3j40vyax3naw0N/Mfo3Fxmi1bV28pxn7l/3EKyzmD
        4Ocr7FWari154iaftJXoJJuZcWdKPf/Ic5RLjsL3riQUQqTA9bK/pF/viQGpCWpz
        aPRo4xXKOkpJ/pYBoDfz64pTb276N0ny+JjiclyaYV7HdPisiUjZKkqGpKESvx2J
        cWNyaWMPggHVkyQfj1gwqsvcu80Hvr+B5jxw6oW177CPWnYN0VAI7k6qgtp89j3U
        /s/S+7IeRRzjQuEfzV86G1IciSS2GpE/Fl3RgBVYbh/mMVQaBO/4kap0wiJTjC/i
        /uKf917zTw5rCw==
X-ME-Sender: <xms:C6lEYRXkpmaMDUmej1bGDBrodbwXtutS4PnCGZW4ZoyLi6arnSgl2g>
    <xme:C6lEYRkXTGcw5iqEnmqOB-DmuBV-JTXs0IAEI_7yVspN3KGQtfuQ50jRQt4nMPG7G
    kRAhlGfP9sODh4>
X-ME-Received: <xmr:C6lEYdajkkgSmZILdY63xPZpzHjvE69p78zMkTuisH2sJoyapmMT3DDV2W88B-MCLiTzceYkHdsU3dS_zoMF_CpkNMlEYUlXkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:C6lEYUVyzYcKZGSQOEVxDyeJSjumogNMEMxHTMuurUte2afRamyLcg>
    <xmx:C6lEYblpA9GEqw2ddSiOvDx6kSGW8FvnzLv0KGLVj-IWzxX83osukQ>
    <xmx:C6lEYRfW4nS3_pUEmAXuHZudqLhvl5ipPOVpJx588_YKWRRYijlB9A>
    <xmx:C6lEYUCrAYgjvw3uLqRD-Zllr4UpRZZ50g_Vf0JOMJdRuRFwluKuDA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:41:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 6/7] sff-8636: Convert if statement to switch-case
Date:   Fri, 17 Sep 2021 17:40:42 +0300
Message-Id: <20210917144043.566049-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The indentation is wrong and the statement can be more clearly
represented using a switch-case statement. Convert it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index 3401db84352d..d1464cb50fdc 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -863,11 +863,13 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 	}
 
 	sff8636_show_identifier(id);
-	if ((id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP) ||
-		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
-		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP28)) {
+	switch (id[SFF8636_ID_OFFSET]) {
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP_PLUS:
+	case SFF8024_ID_QSFP28:
 		sff8636_show_page_zero(id);
 		sff8636_show_dom(id, id + 3 * 0x80, eeprom_len);
+		break;
 	}
 }
 
-- 
2.31.1

