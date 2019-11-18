Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6572DFFFC5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKRHug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:50:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41581 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbfKRHug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:50:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 768C722440;
        Mon, 18 Nov 2019 02:50:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GT3D73Dzwr/rmtRbV4KTFRuOfllPI5/8es2B7fqAfxg=; b=yjqyCS8g
        YDLy3S8Nbj5UKHP7H+wrMq+/IvZxgDjwC+fOQDsWpANpKZC2VyiWeVebQ2jWhonG
        AlhSQg3CVXj7wD+90cxYAgsOzLW9ZDbNUuVVwbijfjtSG4SvUxr6FuDQeBrYG3+q
        uZv6nAQ+8MiUn8fP6c8N1al5c3ZWZxtDgxinlT8+uDZn/gfXxSQSC2QaSgopWoRA
        6C8Nu75Azi/U6zAXBNmZsReysaLpWRWiSXRyU+3Ca4AT6wAtI0opntiihKlGFBUa
        Kx67Yw1eS8OusUSfKhuSY5aoSckY5Yb30zmwB08qggTE190FsGPR+G9a9F6J+hzb
        7Dk2dvgDzACtjw==
X-ME-Sender: <xms:S03SXbWIgfVlbZv7vODgGcMHEIBHXG0MwvHOlsBJ1iXGRya4MbP7Ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:S03SXdNWIWLltAycmG0k3GRp20zx5CPn2yq8FJkS3BwBipNXj-MQtw>
    <xmx:S03SXa3xHO2KqUH0iAjdgSADCuIgC433hCxE9kmDMTxLjMcVoKMiFA>
    <xmx:S03SXdM0-DU7eN-20fz4hUbbOol4Ur-to9Vu9bo0ib_Zx89zL1rWow>
    <xmx:S03SXb2sw4cxvuMyXr085IUod0m9GHbk5Olyi1NRC02-wbMPEq6Ovg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 076933060062;
        Mon, 18 Nov 2019 02:50:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, Danielle Ratson <danieller@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] selftests: mlxsw: Add router scale test for Spectrum-2
Date:   Mon, 18 Nov 2019 09:49:58 +0200
Message-Id: <20191118075002.1699-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118075002.1699-1-idosch@idosch.org>
References: <20191118075002.1699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Same as for Spectrum-1, test the ability to add the maximum number of
routes possible to the switch.

Invoke the test from the 'resource_scale' wrapper script.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/spectrum-2/resource_scale.sh     |  5 ++++-
 .../net/mlxsw/spectrum-2/router_scale.sh       | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/router_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 2b5f4f7cc905..27a712a5ed8e 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -16,11 +16,13 @@ cleanup()
 	if [ ! -z $current_test ]; then
 		${current_test}_cleanup
 	fi
+	# Need to reload in order to avoid router abort.
+	devlink_reload
 }
 
 trap cleanup EXIT
 
-ALL_TESTS="tc_flower mirror_gre"
+ALL_TESTS="router tc_flower mirror_gre"
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	source ${current_test}_scale.sh
 
@@ -34,6 +36,7 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		setup_wait $num_netifs
 		${current_test}_test "$target" "$should_fail"
 		${current_test}_cleanup
+		devlink_reload
 		if [[ "$should_fail" -eq 0 ]]; then
 			log_test "'$current_test' $target"
 		else
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/router_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/router_scale.sh
new file mode 100644
index 000000000000..1897e163e3ab
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/router_scale.sh
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../router_scale.sh
+
+router_get_target()
+{
+	local should_fail=$1
+	local target
+
+	target=$(devlink_resource_size_get kvd)
+
+	if [[ $should_fail -eq 0 ]]; then
+		target=$((target * 85 / 100))
+	else
+		target=$((target + 1))
+	fi
+
+	echo $target
+}
-- 
2.21.0

