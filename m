Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD440FA7F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242854AbhIQOml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33821 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243755AbhIQOmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:35 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id F05E85C003E;
        Fri, 17 Sep 2021 10:41:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 17 Sep 2021 10:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=+NgSVV9rm0SMMf7ijt/zYMOjC5lAdnDUsSNmgCsSwGY=; b=gD0vP0fu
        0wObVa0SY1m00aHN1LsQ5ZR50ydEiRi3EZB9ul57JBpKgWCA47PnJ6MjvNN9IHjn
        Kfz1VYG4TrQUUqrRbnR/kIQ1O730bdvcb6TF21ViJLXzZv0byyBfVQZoqVTUEYPo
        c7RBDwrJ9Oqw7Rv22Dg2HXPW3/ZfhoD4CpmQd/HRi7yktpChoRXjvsYBp/FoSyIg
        dOz8iZ+XOCHPKSbDPBNLH8Gybh0iTLKaKajREQ5KLmbh1VjfjpjyMUFAvMxcO7jj
        iXTeg7Z+aq/wwLNfWPZ8BYeSrGTbZKA6ieotlB88hOnmxj0f0rTQGdzz8TBCcsDO
        QeNqZo6efqNHnA==
X-ME-Sender: <xms:CKlEYX1I4cwuB0jH2iP36fL2O1ErSP5EPAZGl8lnxoKzSzyWtXNmPg>
    <xme:CKlEYWFHPiSdcBwI0xziisivJm0DW0XppAq4gjpQYtTWIyl6KbCvcz1q30-5xd2Qb
    onHLZknQnuHNk8>
X-ME-Received: <xmr:CKlEYX7icUXPdgM4Rv0bP79q3sYbHxcMn5MBTjkyPYc5JV6Rqst4dmvhH91huBi6C7e1ESUG9VtXNxBf2HGmhBYdk57QexjnYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CKlEYc0PBjh6ggE6xbUAFhVk42d6fa1crfgwyiyI_ht6OnWw4Xm-Yw>
    <xmx:CKlEYaGsBuA5NByLKkEP8JCDfzIfkaR3D-OPu_MBogK8Q5wK8XEbAQ>
    <xmx:CKlEYd_CQqUy5WYSgTqQ8-H8m8jiOEU4j72Hf-X-1TAny9VFj86m_A>
    <xmx:CKlEYWgpZca-A3mmSzZDffbMuN5Dk2ASfpgGSGj7-9kTXgku2IkyKw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:41:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 5/7] sff-8636: Fix incorrect function name
Date:   Fri, 17 Sep 2021 17:40:41 +0300
Message-Id: <20210917144043.566049-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The specification is called SFF-8636, not SFF-6836.

Rename the function accordingly.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index 263cf188377d..3401db84352d 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -820,7 +820,7 @@ static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eepro
 }
 
 
-static void sff6836_show_page_zero(const __u8 *id)
+static void sff8636_show_page_zero(const __u8 *id)
 {
 	sff8636_show_ext_identifier(id);
 	sff8636_show_connector(id);
@@ -866,7 +866,7 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 	if ((id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP28)) {
-		sff6836_show_page_zero(id);
+		sff8636_show_page_zero(id);
 		sff8636_show_dom(id, id + 3 * 0x80, eeprom_len);
 	}
 }
@@ -875,7 +875,7 @@ void sff8636_show_all_paged(const struct ethtool_module_eeprom *page_zero,
 			    const struct ethtool_module_eeprom *page_three)
 {
 	sff8636_show_identifier(page_zero->data);
-	sff6836_show_page_zero(page_zero->data);
+	sff8636_show_page_zero(page_zero->data);
 	if (page_three)
 		sff8636_show_dom(page_zero->data, page_three->data - 0x80,
 				 ETH_MODULE_SFF_8636_MAX_LEN);
-- 
2.31.1

