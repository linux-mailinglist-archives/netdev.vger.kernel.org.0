Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A007C43AF44
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhJZJpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:25 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44385 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234508AbhJZJpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:24 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 5C9B85C02B6;
        Tue, 26 Oct 2021 05:43:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 26 Oct 2021 05:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6TN1v7ligCH4CvabXENIMg7tFE1yiIRipVUXR5NaRLI=; b=ROaDoXWs
        vBj/MQtvg81spDgrTKnPM+vWg7Ipo9A1O/36ur2TcPQ23v0y0zehSWYAOHyFQD3O
        ll2EvNEirXl6V6ODe6WbYdLTqCI2BzCK0ymrUE+PHK1yU4tkAMee/ON4K0fGQIyW
        2KWMo+BBUYYWAwBpbm0E2cl8zUHjpxEsxHhKkm9ykC+LU0xc66CX0fLWVqigUeY1
        1TAmTnj5IfQ1wz9zu76oRPk/WcvYzSMWHiVOb1UQIHHWJC8/RZEBusKutx8xrSd3
        epzxegDAMpJebz1L+wXJvZQL/v/AmM3vszrJrgtq2othamjVie6dQiV+k3GPGxEy
        VUVW2rnKXDhsEg==
X-ME-Sender: <xms:pM13Ycb7CXr4FUhr3d2g02Sevi-9qIXEgxCQkXAJ80HdavV8NEmFcg>
    <xme:pM13YXYz8gRwxG9lY11oU-gsgAbehO4sGpP5pH_1LQO5F0wJ-J6dukkOu1k0-WqCT
    4CUErR4TPr5Dtw>
X-ME-Received: <xmr:pM13YW9FhHG_hsaF3Zm026kulI_BnklQcM7SW_Owb1S7V4WxRkJ7WkIDRd4xpjCslJMK8ujB5KafgUwEbPdgWcO9dy3o5DB9pI9M46-Oa7M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pM13YWq26rReaqG5gp8seljEyZEWtSFU1-W7Dyv88jXsiiHe3TGTkw>
    <xmx:pM13YXqrzjkIeTGicXQba7Q7UsHWo8rgjnZ8GQt_2-EJv0wJb9S7Tw>
    <xmx:pM13YUQ7bazP5PUaILmgi81YGWbVWwsEYsSQ-hI5zrhmji-4VjHSTg>
    <xmx:pM13YYB76mX7rnuDGvpLpgKbv8_bsHERDCA4apR1HVuqhxg1EemjWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:42:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/9] mlxsw: resources: Add resource identifier for RIF MAC profiles
Date:   Tue, 26 Oct 2021 12:42:18 +0300
Message-Id: <20211026094225.1265320-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add a resource identifier for maximum RIF MAC profiles so that it could
be later used to query the information from firmware.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index a1512be77867..c7fc650608eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -49,6 +49,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_MAX_VRS,
 	MLXSW_RES_ID_MAX_RIFS,
 	MLXSW_RES_ID_MC_ERIF_LIST_ENTRIES,
+	MLXSW_RES_ID_MAX_RIF_MAC_PROFILES,
 	MLXSW_RES_ID_MAX_LPM_TREES,
 	MLXSW_RES_ID_MAX_NVE_MC_ENTRIES_IPV4,
 	MLXSW_RES_ID_MAX_NVE_MC_ENTRIES_IPV6,
@@ -105,6 +106,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_MAX_VRS] = 0x2C01,
 	[MLXSW_RES_ID_MAX_RIFS] = 0x2C02,
 	[MLXSW_RES_ID_MC_ERIF_LIST_ENTRIES] = 0x2C10,
+	[MLXSW_RES_ID_MAX_RIF_MAC_PROFILES] = 0x2C14,
 	[MLXSW_RES_ID_MAX_LPM_TREES] = 0x2C30,
 	[MLXSW_RES_ID_MAX_NVE_MC_ENTRIES_IPV4] = 0x2E02,
 	[MLXSW_RES_ID_MAX_NVE_MC_ENTRIES_IPV6] = 0x2E03,
-- 
2.31.1

