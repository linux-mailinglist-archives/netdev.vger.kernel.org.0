Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9839F43AF43
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhJZJpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53995 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233382AbhJZJpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 02CD45C02B7;
        Tue, 26 Oct 2021 05:42:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 26 Oct 2021 05:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=xXhpaCjomyJWHVyOWE/BZsvO+Aubx/CXAD9my7sa5x0=; b=neg+DGe+
        l+9awmeBustiwfzbTy09MGj2tPWier/OwwAiKCa1VaKkJjvp+gf3x2Bhi/an2A9b
        pSsQpwEP7HWE768V4GN05TN/Ni5epukygfMq02cQ6tpi4kV0QRh8VgCj/HLvUTnF
        nH1DWNBzaZSCZAFKaHDRLhj+OTKWdyvvvXilEvyuhUTOXHGi5CVfYktFG3AMkeaw
        mF0QYX92Jrcu9FraxJG+pjKMlQ114G069MxNWz79KL0h+e+B/MS0BGEuWo2JXfMK
        TEQTmIpBr5/bU22GFNzeEOf8uGAdTlgS4Zw0GTXzvxss0gHS8E53Fn2Kx/IOFv3y
        GYZHaUeNceuX1A==
X-ME-Sender: <xms:oc13YQ5-0rGv_IlmiB5NVI4cwAwCKjL9rLBmujK_QoiysDf6nTdKZw>
    <xme:oc13YR5cvnSE2lcK8pbETwms2WIGE6mh10gUxCouAF_A2AhF_eDZ-VuuzWVivJX2H
    39AiKwnXmQIZHQ>
X-ME-Received: <xmr:oc13YfeE2KJW9tqtOGi5tww4rw-v1UkpHFy3AQZEYYMBkAwCvdcI085hIxRgwhuPROXxp77QI0caV5uOQtXLyTexjwBiV06hB6fwqdPg9sk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:oc13YVLzPegyjJhHgWvj_0J_5yMVmEerZy3-CtG2eP700W6Zyw33MQ>
    <xmx:oc13YUIK2DL3mUvWQbxQOcRt-A5o6WCF1hGi-_9nvqDvT5D2rno24A>
    <xmx:oc13YWxG8vB9Of7Yk4N2IlYcAbT7U7CEGY449dYgyU4__0ka_6G6IA>
    <xmx:oc13YeijFe2BqUUa9DOseqrgSkwMlHic6AHNJz3KoELMcQ6ZQj4Vug>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:42:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/9] mlxsw: reg: Add MAC profile ID field to RITR register
Date:   Tue, 26 Oct 2021 12:42:17 +0300
Message-Id: <20211026094225.1265320-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add MAC profile ID field to RITR register so that it could be used for
associating a RIF with a MAC profile ID by a later patch.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 48b817ba6d4e..8d420eb8ade2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6526,6 +6526,12 @@ MLXSW_ITEM32(reg, ritr, mtu, 0x34, 0, 16);
  */
 MLXSW_ITEM32(reg, ritr, if_swid, 0x08, 24, 8);
 
+/* reg_ritr_if_mac_profile_id
+ * MAC msb profile ID.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, ritr, if_mac_profile_id, 0x10, 16, 4);
+
 /* reg_ritr_if_mac
  * Router interface MAC address.
  * In Spectrum, all MAC addresses must have the same 38 MSBits.
-- 
2.31.1

