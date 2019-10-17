Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00750DA5D3
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407861AbfJQG4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:56:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58103 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392724AbfJQG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:56:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 67EED21FB6;
        Thu, 17 Oct 2019 02:56:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=gKVdfUaJbZKBLqWxPPWm6RpVFy8J1+7+5C3XzpGCLNs=; b=DYbAWLv3
        gRFGBvZzflVsgMMFLAjyMfkUGTVN2nASu1fRnnqtgO8nJKaS2MPKxaN9yB8chnJ/
        6c3AF0WHpWEZpyru0B30XeOFrhLkDH6qk+J57YwxI4kcTas5WPvkjIfNl+kqWu3f
        oqErsnQiZJblOMLQd0LYeGRJV5Ss/T3zCrbjm+0mVBUm3WI4zcuD0SRNACth/yj8
        lb/dEk0wucbCnJXl6Qql70F2qRlC8ZzaFw8VnM68HNoi3f1oj8V0ZSwnvvL6XQCf
        srWG/kkLQNZcMlBBN8QGXgn9m2A0qlcSSBFBTN31IvBeg3cyKfflN2pMLoJ5oj0T
        WVeWEQU3O84aMA==
X-ME-Sender: <xms:jxCoXWYF2OU8Q_AKkmg-3kERd-V2LCvBqib2IXYUDCbebEXDm-f27w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jxCoXWznW7ZrFTRHoGAfeqeN_rmcSjfuPjafxg1dXBmuToy2W7IRWA>
    <xmx:jxCoXc-Ffgt9xIs1EWzRSr-y1R1aXpLUB_YB84XULLunnjmuIham-g>
    <xmx:jxCoXcV1tQ-jeB0AwykzQAV5vIy_L3Hf7np_6F3CJDcKoJNCyczV6A>
    <xmx:jxCoXeuMM6ro4w2qGsreUzmta86jY9oe4PY5PSjjKkVlizMuoUQAbw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C773D6005D;
        Thu, 17 Oct 2019 02:56:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] selftests: mlxsw: Add a resource scale test for Spectrum-2
Date:   Thu, 17 Oct 2019 09:55:17 +0300
Message-Id: <20191017065518.27008-5-idosch@idosch.org>
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

Add resource_scale test suitable for Spectrum-2.

Invoke the mirror_gre test and check that the advertised scale numbers
are indeed supported.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/spectrum-2/resource_scale.sh    | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
new file mode 100755
index 000000000000..3bb9147890fa
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../../net/forwarding
+
+NUM_NETIFS=6
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+current_test=""
+
+cleanup()
+{
+	pre_cleanup
+	if [ ! -z $current_test ]; then
+		${current_test}_cleanup
+	fi
+}
+
+trap cleanup EXIT
+
+ALL_TESTS="mirror_gre"
+for current_test in ${TESTS:-$ALL_TESTS}; do
+	source ${current_test}_scale.sh
+
+	num_netifs_var=${current_test^^}_NUM_NETIFS
+	num_netifs=${!num_netifs_var:-$NUM_NETIFS}
+
+	for should_fail in 0 1; do
+		RET=0
+		target=$(${current_test}_get_target "$should_fail")
+		${current_test}_setup_prepare
+		setup_wait $num_netifs
+		${current_test}_test "$target" "$should_fail"
+		${current_test}_cleanup
+		if [[ "$should_fail" -eq 0 ]]; then
+			log_test "'$current_test' $target"
+		else
+			log_test "'$current_test' overflow $target"
+		fi
+	done
+done
+current_test=""
+
+exit "$RET"
-- 
2.21.0

