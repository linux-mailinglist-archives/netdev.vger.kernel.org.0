Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA87DA5D4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392732AbfJQG4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:56:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35881 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407840AbfJQG4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:56:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BE4F221FB7;
        Thu, 17 Oct 2019 02:56:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=PYRzaoZ3jjiIcnDJWmpgS9vj+OcDVn3likSIe2hUMxs=; b=ULH7ROdi
        gfVCEMTGTnua3XaDE44jjEu2SGSje5dQeBtv7T/QEUz+3AUNlJgULMlLCKvDdQOK
        jUTm+Whx/CJ/OGVh8UIe7vInIRAm1eWHFRTqm0ILbyYw7yXw0YyhHms1heCfFkfh
        U7xgQOivfXXbQTUzrckgQENblR5ZmckZQYIlyr9G/CgrgOSRIlDHEz+j3JKtD2I4
        2yXP9AreK4IyMNjhYZuShzBcFO8FkB0K//oBwVMzU/GYoVfUTKhbIhzIbRSrrRp8
        20Xvw+OmbJQh7FZRNa+GD+yk05NYNfxG1HVYi5DOw1dqQzL0gmUtfLHFqtbcMjnO
        RnQe0/7zmsMdEg==
X-ME-Sender: <xms:kBCoXWcOXWvFIMvldEFBB-GotNnk86FJBjsw6Vlz3tgrN3yQ9xaahw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:kBCoXUehqIvUJAux2kLmKLmytFz_7de4Nzt_bVdmvk93TgnF38LODQ>
    <xmx:kBCoXShi0fjm4paxlQkvvNP2a1Hb7Jsb2wsRLPVFGGGJ7ZDFprJiZQ>
    <xmx:kBCoXYTENUtJP6oLTkmLSQrDaDMicpPgKPO6Vz5TPpAcnVXg046OKA>
    <xmx:kBCoXQNLjdetY7EXDW7kskK7XKJnw8Lqn7GMO1lucALUFoY-cG8Jvw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68242D60057;
        Thu, 17 Oct 2019 02:56:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] selftests: mlxsw: Add Spectrum-2 target scale for tc flower scale test
Date:   Thu, 17 Oct 2019 09:55:18 +0300
Message-Id: <20191017065518.27008-6-idosch@idosch.org>
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

Return the maximum number of tc flower filters that can be offloaded.
Currently, this value corresponds to the number of counters supported by
the driver.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  2 +-
 .../net/mlxsw/spectrum-2/tc_flower_scale.sh   | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 3bb9147890fa..2b5f4f7cc905 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -20,7 +20,7 @@ cleanup()
 
 trap cleanup EXIT
 
-ALL_TESTS="mirror_gre"
+ALL_TESTS="tc_flower mirror_gre"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	source ${current_test}_scale.sh
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
new file mode 100644
index 000000000000..a0795227216e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower_scale.sh
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../tc_flower_scale.sh
+
+tc_flower_get_target()
+{
+	local should_fail=$1; shift
+
+	# The driver associates a counter with each tc filter, which means the
+	# number of supported filters is bounded by the number of available
+	# counters.
+	# Currently, the driver supports 12K (12,288) flow counters and six of
+	# these are used for multicast routing.
+	local target=12282
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
-- 
2.21.0

