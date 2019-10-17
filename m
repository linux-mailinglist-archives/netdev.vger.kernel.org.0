Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D63CDA5D1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407834AbfJQG4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:56:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43683 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390955AbfJQG4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:56:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BF42F21F69;
        Thu, 17 Oct 2019 02:56:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UCZhmMCFcAPbWvOjGN3VBzzSD6AyT02wfc9kWNT0Ksc=; b=sQjtzUG9
        wQcF9quvElktCFMMgE7smhT9z4Ik2B6Ozxd9PW77iUc/XjpnRPYyf4vl5nOuRBqE
        XOVm99dvn/szbdggKyxkpKIZBMe0HpqUGYETxiA6vJGIn2EGsv3VVJXzr8KOxjYz
        twUg9RZw0ouMSyY5QDmZcv2JmSEEnqtx5JVTKWXd21sv5e0yIYZj06WGvCnhBlQN
        r6/MYzkAe/WVZObWWc1pcYp1wO5PqcibjoEhVYFcVYICR2pvpXayUzxNqy1Rv4lO
        mrwTfXBp39qs4l51ck5wzFn500O2Q/nqAUhS1aWHv1ByVdepXpYqsZVn++PA2FWu
        vkB9lGe6AnbamA==
X-ME-Sender: <xms:jBCoXXeMaRTbuI1UsR6CqFUsDxorr43z9v3B_d0C1WKtd3FzR_5zpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:jBCoXcfwjVmZpn7Z9c0hybd9ja3wIX93C-JfbtRx-RIFEoSw1YfbDg>
    <xmx:jBCoXTVDlUuCKEK0eUfYSMMWonhf_j42Om3qP5OtZ3Kyke98-pwlOA>
    <xmx:jBCoXQcTnbCwiVYcC8Sm49-JRTXCWstTNemIk4y97iJ1rQJRlg-GEw>
    <xmx:jBCoXcfFf2VHwJJLRcQCXJJnU_tA-EMNLvt0Rexj9OmBQa-3y3q0YA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79590D60057;
        Thu, 17 Oct 2019 02:56:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] selftests: mlxsw: Generalize the parameters of mirror_gre test
Date:   Thu, 17 Oct 2019 09:55:15 +0300
Message-Id: <20191017065518.27008-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017065518.27008-1-idosch@idosch.org>
References: <20191017065518.27008-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Use the number of analyzers taken from the devlink command, instead of
hard-coded value, in order to make the test more generic.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/spectrum/mirror_gre_scale.sh         | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/mirror_gre_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/mirror_gre_scale.sh
index 8d2186c7c62b..f7c168decd1e 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/mirror_gre_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/mirror_gre_scale.sh
@@ -4,10 +4,13 @@ source ../mirror_gre_scale.sh
 mirror_gre_get_target()
 {
 	local should_fail=$1; shift
+	local target
+
+	target=$(devlink_resource_size_get span_agents)
 
 	if ((! should_fail)); then
-		echo 3
+		echo $target
 	else
-		echo 4
+		echo $((target + 1))
 	fi
 }
-- 
2.21.0

