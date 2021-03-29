Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0088734C9A9
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhC2Ias (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:30:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48181 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233880AbhC2IaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:30:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1B0435C00BC;
        Mon, 29 Mar 2021 04:30:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Mar 2021 04:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=tnqkAHFIPeebRKZP6xC013Qt2LOPMPtCMaWbxt8dABU=; b=Kmn4l3js
        IeDn/NchNodxlf5z1YKf7YQVcSqJpuCEBFcdSHezk8VN7jmrzu2wOkoMMpxeR4lD
        1JwiX92MyQRXG0XLXogCX/+iHeDRVZACqKDl6/ol7YKO4FkyB6E1qbOCQ8un0+MJ
        LeaUJRfP+rnPV0ZOzOBC2flWSlG6pdArDY8moG/0apmm9lJfJ7Wk3RJhfMERFzUT
        YWo1I0aAvH4/Qh7ZL8ksqOAiaBLOPkFtBMQ9E5Vr2Pw3k07rroSAclOW8v3/gkr5
        bNATJevLqaB9ky9AMM0aSGaHG9bRHcNbJd5a1Z4oyMzbBdH0EFTcgo0Q/Q5s5H+l
        0W0dl6J0vrXRpw==
X-ME-Sender: <xms:DZBhYNam5ThbkegwUJewCVNgHMNFGj1HST5qr3csGE8q4aeu_FvBtQ>
    <xme:DZBhYJnbMhe6-YaIuf2zDw4wEx8gCvUUJFsDXiWGZymuvx2fx5163n_Vjrho9i7vI
    JDCAYpCaKkd8xc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DZBhYA30tpHS0yx-Nezp3iqXXLTQgEmY86U0D-uKkGVhYSyEBXS_4A>
    <xmx:DZBhYB3o6C7Fc4qpkHV69L2XucewzCOOF29M1TIoFOkKUk7sSx-LzQ>
    <xmx:DZBhYKrCJI0yMR5F1BDWz5rn-K6zZU8Vm_tcTIUo1UQd0Dk4NJCVSg>
    <xmx:DZBhYNpEnNjlCB7lqd5qFDwRH4ExF90a95ANNtinNpc2DniNYc0jlg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 170F1240067;
        Mon, 29 Mar 2021 04:30:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, toke@redhat.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: forwarding: vxlan_bridge_1d: Add more ECN decap test cases
Date:   Mon, 29 Mar 2021 11:29:24 +0300
Message-Id: <20210329082927.347631-3-idosch@idosch.org>
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
Reviewed-by: Petr Machata <petrm@nvidia.com>
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

