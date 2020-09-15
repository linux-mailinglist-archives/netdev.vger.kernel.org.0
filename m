Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E376E26A112
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgIOIlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:41:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54157 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgIOIlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C143D5C010E;
        Tue, 15 Sep 2020 04:41:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TlWG5DhzXHIDeG5v7266RVcRUNDgdZPQ7j23v8jTYdI=; b=j7mjwLAv
        hvZE3HeZazBD/FPUmnyzQx+9Sr2huPyHQ68gU0O2JEZX3ZRd1RmVQ6AslcE3cSC1
        HYg9bayTJdli78QANBJg7YRshOzDRAS17QUOXMjAkASR06/khR+ZChQ+PwH36/GJ
        Shs3zsrXCFMXu/xjkvSYxJeEGdhspGUCJkk6XIFQQaUYOJokRt4rXmpIYq3KWsi0
        P9Y1RSew0HvIxspkinTocQIsLJZaKpEfUYahhbLbZtC9Wx8YfR+HVAG7yAt8gFgC
        PIsMxrkxg8cS/ZhRxNhfEH8ajW+5qRLQukryAqvBcMLz8Y+nzMRmJT0GBiqo9UEI
        SngMQG+oiqnoow==
X-ME-Sender: <xms:R35gX33R3c_skxuN7T80YRVi3ImGjQrZtdvCWDlaDjzQ67srqy_O5Q>
    <xme:R35gX2Gc2pj2FqGoemeN0b7-4dIHqXCAwGmVq-uOYsjvZzySJkEWfNmoDmPYi64vV
    lwzTIMZxdhWfVM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:R35gX34TYLxTI8opyzsTqfjGwN61UKhOpjnHU8F1PQATyhUucAuS8w>
    <xmx:R35gX83sdgeh6cw-vQcaRcOMCb3XgyzVoRt4LHfU9Cs5RPioV1pHrg>
    <xmx:R35gX6HFolWVINwlAsdMYE4e78fDD5_KoNFkj3_30P8pdhXPTGdmrw>
    <xmx:R35gX_SFym66gr-d7kLpEI1R1pp1gnFSosK-FiioVSoAsv0dtX2jdw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9910306468A;
        Tue, 15 Sep 2020 04:41:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: Bump firmware version to XX.2008.1310
Date:   Tue, 15 Sep 2020 11:40:51 +0300
Message-Id: <20200915084058.18555-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Among other changes, this version supports FW monitoring.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0097c18d0d67..3ef4b4922fea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -45,8 +45,8 @@
 #include "../mlxfw/mlxfw.h"
 
 #define MLXSW_SP1_FWREV_MAJOR 13
-#define MLXSW_SP1_FWREV_MINOR 2007
-#define MLXSW_SP1_FWREV_SUBMINOR 1168
+#define MLXSW_SP1_FWREV_MINOR 2008
+#define MLXSW_SP1_FWREV_SUBMINOR 1310
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
@@ -62,8 +62,8 @@ static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
 	"." __stringify(MLXSW_SP1_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP2_FWREV_MAJOR 29
-#define MLXSW_SP2_FWREV_MINOR 2007
-#define MLXSW_SP2_FWREV_SUBMINOR 1168
+#define MLXSW_SP2_FWREV_MINOR 2008
+#define MLXSW_SP2_FWREV_SUBMINOR 1310
 
 static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	.major = MLXSW_SP2_FWREV_MAJOR,
@@ -77,8 +77,8 @@ static const struct mlxsw_fw_rev mlxsw_sp2_fw_rev = {
 	"." __stringify(MLXSW_SP2_FWREV_SUBMINOR) ".mfa2"
 
 #define MLXSW_SP3_FWREV_MAJOR 30
-#define MLXSW_SP3_FWREV_MINOR 2007
-#define MLXSW_SP3_FWREV_SUBMINOR 1168
+#define MLXSW_SP3_FWREV_MINOR 2008
+#define MLXSW_SP3_FWREV_SUBMINOR 1310
 
 static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 	.major = MLXSW_SP3_FWREV_MAJOR,
-- 
2.26.2

