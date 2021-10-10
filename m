Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D594280E4
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhJJLmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54719 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhJJLmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 890265C00EA;
        Sun, 10 Oct 2021 07:40:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 10 Oct 2021 07:40:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ynkmxZwRZ0JlZcon5Ri/wrza0rNFKZhKnGfiiCAwdr4=; b=XnGFwTCo
        Rm59QBrkFzm8i01SfS1bF9sXRsrBFzTCUem0HUkcWg53vDmfn92N+05Nd2B34bPM
        Rr8+sBA4kmS6yIYy6sI9BGKG6Qut+kzR31ToIO0vG8zlgl4NBJu2+8v3iaHY54zB
        KJlGTHqwjnKj19pLBIPJNr9C5/R0jtm0WSqCvFAorcS1JfBN57/juUSvAlq3l1IJ
        vgK37d6NpZMMwCND8noHoyUZojtJYKEvsHcelJbrGQwWOXUzVOwZzx1WxFGKMVx2
        rdWIHStmxDxHQnOHVmOZsTe2TjU0gXnnjb7ffJjzon2imvbJaKiy/CAXFBNT/aSj
        vSxH12dxRuwFNA==
X-ME-Sender: <xms:QNFiYSoONnLulw3djujOAEnOXRNtJANlcSouzFLa8PpjaCmCm40Yng>
    <xme:QNFiYQrga_T2Kh1Q39KQrvgLSgVOqP5fXin0dVxHDO3n9ehIy0if6tkfT36SJF67X
    UlBmHbwJGa6IoI>
X-ME-Received: <xmr:QNFiYXO4zykllpgCttePqChMqE37ZBzh-eOYGHNiXVxk1FqqmeB7SOqKFJid4BRqtREJUXsnh2Kajt9ujLXdpzgyV-XEHieoWMLQU4wu6rH_GQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QNFiYR5HEHZmFYEU_6vJpTnu7gQ3fx-hn_vU6lal4eX0QSKwKalYAA>
    <xmx:QNFiYR4Av7S5RTD6daekCLW-bgBmtuo0BGCUoXr_8ULw9LCWzzw81g>
    <xmx:QNFiYRid_C8K8AgwEJ27mChxM1q5Pa6PMVkEh7dpv_7gvWjgG4Hb_A>
    <xmx:QNFiYU0tyh_4uDv9sRtQanVF6dAtdLOIcCPU4AcpwPDDzAvSwxHRhA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] selftests: mlxsw: sch_red_core: Drop two unused variables
Date:   Sun, 10 Oct 2021 14:40:17 +0300
Message-Id: <20211010114018.190266-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
References: <20211010114018.190266-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

These variables are cut'n'pasted from other functions in the file and not
actually used.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 33ddd01689be..88053f8dfd12 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -551,10 +551,8 @@ do_drop_test()
 	local trigger=$1; shift
 	local subtest=$1; shift
 	local fetch_counter=$1; shift
-	local backlog
 	local base
 	local now
-	local pct
 
 	RET=0
 
-- 
2.31.1

