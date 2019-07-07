Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8E61458
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfGGICf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:35 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39163 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGICe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B2ADD17A0;
        Sun,  7 Jul 2019 04:02:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Q7wc9bBhpjPTUHTBCbLesY1u7y12kUCiM4Uds7evRCY=; b=Zpca2iQA
        uzru5rCuKrQ84idgBRvFDUr6b8gwNgKVgORmfuDJNyAOATxS9mA1tzeDIPxPIeSV
        x05O191pHUJrXrPjd2QuQXUR/XRghEY2qCIrcyCdW5N0kvjtr1TdjnoXILYQaa28
        h0/ZsQO1sE8XunR5yaGFiw3JVS2NYIT0xkdUxjoG2zAPeW3P4BlVe9SBmYjjqaYw
        MQC+/p+UFXPXqW85fOw1P0Y8n3UAeGV3EPjA2cyvS4h24GDWkVqotjtzigzedTBn
        /cVBfV81t4pApqJ7o28erC3Stc/6WfpC/CkDIIfjRIow6QvE4VSnpMl48yI6VUTb
        nbOURC3sdiTilw==
X-ME-Sender: <xms:GachXUDEE9M8ULlmoxM2MyzQLd9HeLjDxYZYTnX7HIj7ZZhEZUbbUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:GachXXyQlahiiuoP8MOfAOyAHkQf-A-QGiT0p1mh8XMLTKeELvtVWg>
    <xmx:GachXc6nbS8Jylm65-wRR9mDmj-khO0Z_d1RCLcUux9FRHEPdDyYoA>
    <xmx:GachXYsYlNv-AFpbMG9mkA4gB4OPvAKVuwK0ov6_nnBZkSebNGaipA>
    <xmx:GachXVyZfEUO69K6YrQ1Z1r6yZN3-NI_6CvDnhvjHaroM8oZvciscw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F2B38005B;
        Sun,  7 Jul 2019 04:02:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 1/7] devlink: Increase number of supported options
Date:   Sun,  7 Jul 2019 11:01:54 +0300
Message-Id: <20190707080200.3699-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080200.3699-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080200.3699-1-idosch@idosch.org>
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
index 559f624e3666..f631c8241a24 100644
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

