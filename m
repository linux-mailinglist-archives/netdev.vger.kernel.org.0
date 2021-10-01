Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15441F08B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355037AbhJAPIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42687 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354962AbhJAPIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E7DCB5C0105;
        Fri,  1 Oct 2021 11:06:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 01 Oct 2021 11:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=+NgSVV9rm0SMMf7ijt/zYMOjC5lAdnDUsSNmgCsSwGY=; b=HNY5nTi4
        niBZdWq96zPpy2Jca9Bvvi8GJAzy4ZxvOKs85dLmabI+/n6bok3IuthGS3kuPhlo
        lfNhO1x55UiJy7li22GEvSCjQfSOc+hkQafvepd45TuiPVb7hXv0IXq0K/TWKV+1
        P3UkllpLamwZcDr84nFe7tYmu6iLiyK+uQ0a56q30QMkjfnS5jEfFmHu+oMrbv8U
        MPFBdhibXaJaRkPmPxT6UL4VXmT/bb8bVOsXA+PqzCRFdm5Ly4F95tC/pwrcb52I
        7StRbgm70LrifBV8/lWBxh8JpHOJEHeBAnv5wueJsLMK9jqpjXyEIBQAbcmU4sZT
        jNYK08/ICdbIAg==
X-ME-Sender: <xms:ESRXYb1-vXMUM3LiOM82zEGw4rjHKRCliDBACq4jel8IifGKVza7Dg>
    <xme:ESRXYaHgvosrGYxbePZr9Sz0E49grktbY_W-C_oMw8sOyMUnsmYgKS26_s4lCWxKM
    TqMLBoj9IRRV4I>
X-ME-Received: <xmr:ESRXYb6i4qdzCVOrKvPGUXCMSVduTCyRHzq5MQ64XMe7Su0l2rw8kr0CXXOysc6aHv038LOwbJQAKgFqGTJHM34HLpGm5YJIgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ESRXYQ1rwSknAWxj6ZRBk0XapHYKTnOqiQIsmVMgTMlPAVN3hSCY9w>
    <xmx:ESRXYeEGyL8434Wb2ULbt4a1VT48xmOBOAty5ux38cnLmLwnAnMQhA>
    <xmx:ESRXYR-wq1Qu32H91nv-bA4_6mjcU2kj4czY2nSP9bZ0RwVHHadi3A>
    <xmx:ESRXYTSvXm_vJrNKU8uomDZlGLBfvP78XRtV9xIJUmM_DgJST20zDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 5/7] sff-8636: Fix incorrect function name
Date:   Fri,  1 Oct 2021 18:06:25 +0300
Message-Id: <20211001150627.1353209-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
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

