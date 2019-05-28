Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812792C6A3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfE1MgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:36:23 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35783 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726749AbfE1MgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:36:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2069A1CAD;
        Tue, 28 May 2019 08:26:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=GadX4mFMZIDc4Hk5SoaGcHyunKTVV8COGhQinPxIjeQ=; b=GuDTWE5j
        aqbkTpLgfxQSpktsWtorunFCmM71QPSPZGG5W7Npsf7FsYlm9vogVH1qxyvmrYao
        a4OTYyMvKWyHHmuEuKhdL+K1Gp2NUEWPngN0bNg/2Jf8Gr6kuZrVgmeZNyYf/P/Z
        wb26VAHmP7S9ilwDodjh16IDNzv3o9WGvyIm7gXOcKYU6MpDi6zJEbCARa4rBdeX
        acIBNn3gOE4pGJt/Vpmz8oADPlD3ZHE0/8gJbHuIZjyiBe6GvdE5v0DshJZkj5MH
        tWpqIW8f3Zo6kNQFXf6W4bAf3MzkmzJoO6oUP6OCRxQSTj2kZwq3WEp6kH6M09IK
        3B5zFhyWsCtcZA==
X-ME-Sender: <xms:DintXKS_LTU1a_Zo1qQmgMNsDP8XV9ASeRez1BX62mvrsWvXCLGsVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:DintXKr6qg_O-BP--siznGOt3sgQDpICT0jW65XKvE7U0GTUnqAHYQ>
    <xmx:DintXPo26Cz3ftUvRlwvF66z22q_13FBD-PwbgNBkt1I-Hc2O_vd4g>
    <xmx:DintXEMSpqibmLyZCycmsSyeou9on3U2oVaHXh51iXdzVU88E_FvQQ>
    <xmx:DyntXGJlQUNzBp8QB9tihbTHmqWppFMLaiF9NDQ-JbJXqTrJqOZ-Ww>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3BD1B80064;
        Tue, 28 May 2019 08:26:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH iproute2-next 2/5] devlink: Increase number of supported options
Date:   Tue, 28 May 2019 15:26:15 +0300
Message-Id: <20190528122618.30769-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122618.30769-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
 <20190528122618.30769-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the number of supported options is capped at 32 which is a
problem given we are about to add a few more and go over the limit.

Increase the limit to 64 options.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 436935f88bda..40ad61fd0245 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -213,7 +213,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
 
 struct dl_opts {
-	uint32_t present; /* flags of present items */
+	uint64_t present; /* flags of present items */
 	char *bus_name;
 	char *dev_name;
 	uint32_t port_index;
@@ -713,7 +713,7 @@ static int dl_argv_handle_port(struct dl *dl, char **p_bus_name,
 
 static int dl_argv_handle_both(struct dl *dl, char **p_bus_name,
 			       char **p_dev_name, uint32_t *p_port_index,
-			       uint32_t *p_handle_bit)
+			       uint64_t *p_handle_bit)
 {
 	char *str = dl_argv_next(dl);
 	unsigned int slash_count;
@@ -993,7 +993,7 @@ static int param_cmode_get(const char *cmodestr,
 }
 
 struct dl_args_metadata {
-	uint32_t o_flag;
+	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
 };
 
@@ -1020,10 +1020,10 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
 };
 
-static int dl_args_finding_required_validate(uint32_t o_required,
-					     uint32_t o_found)
+static int dl_args_finding_required_validate(uint64_t o_required,
+					     uint64_t o_found)
 {
-	uint32_t o_flag;
+	uint64_t o_flag;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dl_args_required); i++) {
@@ -1036,16 +1036,16 @@ static int dl_args_finding_required_validate(uint32_t o_required,
 	return 0;
 }
 
-static int dl_argv_parse(struct dl *dl, uint32_t o_required,
-			 uint32_t o_optional)
+static int dl_argv_parse(struct dl *dl, uint64_t o_required,
+			 uint64_t o_optional)
 {
 	struct dl_opts *opts = &dl->opts;
-	uint32_t o_all = o_required | o_optional;
-	uint32_t o_found = 0;
+	uint64_t o_all = o_required | o_optional;
+	uint64_t o_found = 0;
 	int err;
 
 	if (o_required & DL_OPT_HANDLE && o_required & DL_OPT_HANDLEP) {
-		uint32_t handle_bit;
+		uint64_t handle_bit;
 
 		err = dl_argv_handle_both(dl, &opts->bus_name, &opts->dev_name,
 					  &opts->port_index, &handle_bit);
@@ -1424,7 +1424,7 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
-			     uint32_t o_required, uint32_t o_optional)
+			     uint64_t o_required, uint64_t o_optional)
 {
 	int err;
 
-- 
2.20.1

