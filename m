Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CEC40FA82
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbhIQOmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:47 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55621 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243717AbhIQOmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0742F5C01CF;
        Fri, 17 Sep 2021 10:41:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 17 Sep 2021 10:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wMgHWGEFDtQMgyF9iJhX0MHEQhexcToVkFgOADVIAoA=; b=cxq6TmkN
        yDddZzupevmoBusnvJCFun+oHOrE1n+qG+jXyEQLwJaCWJX5T/Vm31N3gou4t4XS
        9DXDXpv8w8570Dp8qsdK8LSIB7XhzMCTgwCMWQwhnPAok3vWt9oBW4hqFo011ILa
        xQpjU5TPqQFSzd8L5NevP1knrrXEM5PoIq5tzuqjMVrXaY0cVKKe23TrTwsJ6m6f
        YPTKEscOUso39HPm2sPefTKUCKN6sbxlm8uKVHsBwz4UHQll5ojT1D+77mvo1il3
        7fei3YITVq/auMsudaFRDECGVc0wtpW9UvKE03r1+8Lr8HUOeIRKQEQ2pCFkA/Xf
        b6xGedslynwbMw==
X-ME-Sender: <xms:DalEYSzTRMGEpV0dtTYIQBdc_rwjqZRpU9hKFDOrWLHK-yDqtlYLvQ>
    <xme:DalEYeSNjTwia8dSd_Ql1BxVt-cGxitC_dXVADALdQ_VPFow2ueebhTKsIQPnQaL7
    MSuZepS5yb7-0s>
X-ME-Received: <xmr:DalEYUWaUHM6YK7Hi6kbzZkUi4T-hBxqgnSj2scjLQIuhmx696PQc6gGeV7gd4HbGzqQ5KfkJPRkmiGOmc_JVHgN3PE4cGetJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DalEYYgZa9ax5YYVSwhJW06YS8lpSRUKMnZmiIlHBRf30ekblC_KAg>
    <xmx:DalEYUDTLTqqG5_RfNJjZJ0-CrKMky9yadh7dbHYWP4nmjboJEJMuw>
    <xmx:DalEYZIONbEzi30m0h5gjCy4AGSWBVqbxwdg54c-rYIWWMwZ7vEdBQ>
    <xmx:DqlEYX8G4D5pRn53FymjZG67wks7ibuCjMLFSXt-6N2d74zu82fn4g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:41:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 7/7] sff-8636: Remove extra blank lines
Date:   Fri, 17 Sep 2021 17:40:43 +0300
Message-Id: <20210917144043.566049-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Not needed, so remove them.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index d1464cb50fdc..3f37f1036e96 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -738,7 +738,6 @@ static void sff8636_dom_parse(const __u8 *id, const __u8 *page_three, struct sff
 		sd->scd[i].rx_power = OFFSET_TO_U16(rx_power_offset);
 		sd->scd[i].tx_power = OFFSET_TO_U16(tx_power_offset);
 	}
-
 }
 
 static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eeprom_len)
@@ -819,7 +818,6 @@ static void sff8636_show_dom(const __u8 *id, const __u8 *page_three, __u32 eepro
 	}
 }
 
-
 static void sff8636_show_page_zero(const __u8 *id)
 {
 	sff8636_show_ext_identifier(id);
-- 
2.31.1

