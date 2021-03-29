Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2A34C9B0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhC2IbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:31:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56259 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233977AbhC2IaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:30:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A70C35C00E3;
        Mon, 29 Mar 2021 04:30:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 04:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6FOSWp96nUcuBIkKx7JkR1Cbmjv/2zIeCWKUoQhWLWE=; b=KJII7Itr
        RGi+lUR9dVcxFjcoBP5h7unJkJHNrVi3tqH28s8+1b6IZ+XCAcGIPWyRkj1PUCHr
        pF48X9L3L5eJEWsVhNK9W4vWJhDxyFg5VTOcIE2mI4jly0AMsDxCcVK9+fVq4EZq
        SDtJhI/isme6cssX7dSthyANsp3qqYW7UVXKhZlvmxCLyParJAsoYd/msoRGqc1R
        VYWMNaPCDb2WQFuQeU1KRvc2A/1FZiGKvPX32wqyFJE/DQ/Sg7mG2+iI7sK8hdQY
        oYE5VTOfvmcvq4ixWVJ34amnucmfq7Ab1jVIrwtHFGUzXjXzFtT9gCOBHZ9KBWCE
        RaBGP+yWOZnmdA==
X-ME-Sender: <xms:EpBhYEul0iu2SV0xL6C5NEfmUjWyC3At7OTtlySVrskNYbEEWfhmGQ>
    <xme:EpBhYBZEy7wY2Sroq3DTiyaS0E1rGjslSw3PwYgprjLCVOj7aTaFZ_FyVWfbUVGm9
    82qWGtVaCX7Kss>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EpBhYMq2JHszwp59qllEH9tQLpEqUhSY0vK8gq4lXGxGjWHDJR2l2A>
    <xmx:EpBhYO88vtptgT8hNcVeXy_hssdbzUcTYEhtc-8j2avMiTczIqenKA>
    <xmx:EpBhYD-1EYt7AbavCqi0qPyXE0_lRYgWTnMXZPCgHy5a6UyB9Hl0yg>
    <xmx:EpBhYIIvKsyR6T4CoU4hSlY4gKqeAiUvk7jPQuvgdnw5XNNmbXZFTA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DA42240057;
        Mon, 29 Mar 2021 04:30:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, toke@redhat.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net mlxsw v2 2/2] selftests: forwarding: vxlan_bridge_1d: Add more ECN decap test cases
Date:   Mon, 29 Mar 2021 11:29:27 +0300
Message-Id: <20210329082927.347631-6-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329082927.347631-1-idosch@idosch.org>
References: <20210329082927.347631-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that all possible combinations of inner and outer ECN bits result
in the correct inner ECN marking according to RFC 6040 4.2.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/vxlan_bridge_1d.sh     | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index 0ccb1dda099a..eb307ca37bfa 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -657,10 +657,21 @@ test_ecn_decap()
 {
 	# In accordance with INET_ECN_decapsulate()
 	__test_ecn_decap 00 00 0x00
+	__test_ecn_decap 00 01 0x00
+	__test_ecn_decap 00 02 0x00
+	# 00 03 is tested in test_ecn_decap_error()
+	__test_ecn_decap 01 00 0x01
 	__test_ecn_decap 01 01 0x01
-	__test_ecn_decap 02 01 0x01
+	__test_ecn_decap 01 02 0x01
 	__test_ecn_decap 01 03 0x03
+	__test_ecn_decap 02 00 0x02
+	__test_ecn_decap 02 01 0x01
+	__test_ecn_decap 02 02 0x02
 	__test_ecn_decap 02 03 0x03
+	__test_ecn_decap 03 00 0x03
+	__test_ecn_decap 03 01 0x03
+	__test_ecn_decap 03 02 0x03
+	__test_ecn_decap 03 03 0x03
 	test_ecn_decap_error
 }
 
-- 
2.30.2

