Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7262545AA32
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbhKWRoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:34 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32999 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhKWRoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:34 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CFF5C5C0116;
        Tue, 23 Nov 2021 12:41:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Nov 2021 12:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=FxvEW7W2NLx6CMPThusI1PYYRxtEoTK5LJ4VL6o5Sf8=; b=QqRE0uvO
        EFNcD42vyUimVR7zvoM0gX67jDK5S3N7CLasIqZyTaB5biyckDzkTlH5yAB90lJr
        lM8eNp6wyF75t+f5q4FW52e3ROWA/XRPF5AGBefe7dQxoQnZxIDkntCbTIGz08/e
        jhST/HLRod63K6DQryUQ7GeKaB1wG+5OY/rVz+asXqY+vK4EkMTYv2FR4d7fERkD
        nRdXqueYr8GRvi6uW2/5aIx3AuDGp81oI94UkUGv0oA+87JlMvJK6NnVHHsePtGr
        yccJmiO3UwC1X8FufZiflTqKtbAAsgrUJiyx1ruEnsqNluvcN4kDKgCjRRqGHr0x
        hYI+GqauT29Bgg==
X-ME-Sender: <xms:xSedYR4WNFxFc2TnEE4jBuwvECd3lwEOCK-e6wdGqx_xTTvTFduICw>
    <xme:xSedYe56qr1-G53RZ6h3stclrhuh_JhpgJASl-E8AnrRRup-xZLW_AVhNc-GNSvix
    V-kgQzOh3csxuY>
X-ME-Received: <xmr:xSedYYeD0Jqj-x9q-T2auMm0o14_S6m0a0AHm7NVC3ZJfxNUSxFZoqClXuWeerqsUCN6sJXGZUVZv7m68L2h1T-SlAay-mdBbch2KqF60G1iZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xSedYaK2Sthd9tnfkxAEAwHcPNYqog5f-ZKBvMC9JzFouq6iNe2KZA>
    <xmx:xSedYVITgU3fGjgTh1cIvTdhJplReDCOsp-WOqgug9ER0MeL4l6KOQ>
    <xmx:xSedYTyCz2NnJStmKueb6EccxnVRuC91fIqW0zUL76ZldYLtu1fLxw>
    <xmx:xSedYSFMUTK5WMRVqnoK4yXcmHHmueUNsKbGVAt5kwTiuoTSuDyIkQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 1/8] sff-8636: Use an SFF-8636 specific define for maximum number of channels
Date:   Tue, 23 Nov 2021 19:40:55 +0200
Message-Id: <20211123174102.3242294-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

'MAX_CHANNEL_NUM' is defined in the common SFF code as 4 and used to set
the size of the per-channel diagnostics array in the common 'sff_diags'
structure.

The CMIS parsing code is also going to use the structure, but it can
have up to 32 channels, unlike SFF-8636 that only has 4.

Therefore, set 'MAX_CHANNEL_NUM' to 32 and change the SFF-8636 code to
use an SFF-8636 specific define instead of the common 'MAX_CHANNEL_NUM'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c       | 9 +++++----
 sff-common.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index e7c2f51cd9c6..58c4c4775e9b 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -71,6 +71,7 @@ struct sff8636_memory_map {
 
 #define SFF8636_PAGE_SIZE	0x80
 #define SFF8636_I2C_ADDRESS	0x50
+#define SFF8636_MAX_CHANNEL_NUM	4
 
 #define MAX_DESC_SIZE	42
 
@@ -761,7 +762,7 @@ static void sff8636_dom_parse(const struct sff8636_memory_map *map,
 
 out:
 	/* Channel Specific Data */
-	for (i = 0; i < MAX_CHANNEL_NUM; i++) {
+	for (i = 0; i < SFF8636_MAX_CHANNEL_NUM; i++) {
 		u8 rx_power_offset, tx_bias_offset;
 		u8 tx_power_offset;
 
@@ -832,13 +833,13 @@ static void sff8636_show_dom(const struct sff8636_memory_map *map)
 	printf("\t%-41s : %s\n", "Alarm/warning flags implemented",
 		(sd.supports_alarms ? "Yes" : "No"));
 
-	for (i = 0; i < MAX_CHANNEL_NUM; i++) {
+	for (i = 0; i < SFF8636_MAX_CHANNEL_NUM; i++) {
 		snprintf(power_string, MAX_DESC_SIZE, "%s (Channel %d)",
 					"Laser tx bias current", i+1);
 		PRINT_BIAS(power_string, sd.scd[i].bias_cur);
 	}
 
-	for (i = 0; i < MAX_CHANNEL_NUM; i++) {
+	for (i = 0; i < SFF8636_MAX_CHANNEL_NUM; i++) {
 		snprintf(power_string, MAX_DESC_SIZE, "%s (Channel %d)",
 					"Transmit avg optical power", i+1);
 		PRINT_xX_PWR(power_string, sd.scd[i].tx_power);
@@ -849,7 +850,7 @@ static void sff8636_show_dom(const struct sff8636_memory_map *map)
 	else
 		rx_power_string = "Rcvr signal avg optical power";
 
-	for (i = 0; i < MAX_CHANNEL_NUM; i++) {
+	for (i = 0; i < SFF8636_MAX_CHANNEL_NUM; i++) {
 		snprintf(power_string, MAX_DESC_SIZE, "%s(Channel %d)",
 					rx_power_string, i+1);
 		PRINT_xX_PWR(power_string, sd.scd[i].rx_power);
diff --git a/sff-common.h b/sff-common.h
index 2183f41ff9c9..aab306e0b74f 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -160,7 +160,7 @@ struct sff_channel_diags {
 /* Module Monitoring Fields */
 struct sff_diags {
 
-#define MAX_CHANNEL_NUM 4
+#define MAX_CHANNEL_NUM 32
 #define LWARN 0
 #define HWARN 1
 #define LALRM 2
-- 
2.31.1

