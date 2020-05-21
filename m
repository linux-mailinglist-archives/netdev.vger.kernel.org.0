Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE31DCCA2
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgEUMMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:12:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42923 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgEUMMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 08:12:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F1715C0089;
        Thu, 21 May 2020 08:12:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 08:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0apFKcWMD/tMPqHVG/6ahaEweQw6IgAHVpKnEz/X02U=; b=amy+OSbv
        xbpQ7W1eXeDTQVNTsIom0whKKYn/z9EsZ6uB88aJzYto1lSLpQzEvbHMpT2apZS9
        buJLwWbSJqhJgdFYftkiXWkTWpEkBMfCDNE3dVuiaxgQ9Dzi26nplbx/Q4kVRwXA
        0YtuKbNsekXJ5uAAukeR6Br5ld+JQvt0F9XRvArmjdWyVrLXvMcvWI6OQT4bT41V
        M9gqbm38UAiBpqOmiXAqWTw4fk1gGnUmL1mwS+4Y4erc4588OyL8fuAr39QrrHNW
        NQiCMIwlKSLb/zouRT5Bt9AeWOXDV3+ew/zz/pyns7fLL3VEbmg3M7IHKFOFDcyy
        CFHsyEtsrpu0Xg==
X-ME-Sender: <xms:EHDGXudpt73NuReZYViguiZG20tzt4YZRAzi1Ttd2FWt8uAMTqqu1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeduteeiveffffevleekleejffekhfekhefgtdfftefhledvjefggfehgfevjeek
    hfenucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EHDGXoO9J8sR9ODn9MsfulBsH3IhC2XJnrGzZn7ilpynVi3c2esW0g>
    <xmx:EHDGXvi6U3pbeCi_NCElma7UgRo-8BBHjAFbbT3ABZpnVzpf9ErQrQ>
    <xmx:EHDGXr_XJAEcW_FgGd_ORAPXjbdfFfvUbnZXLtss2u2Jw0MXFOmb7A>
    <xmx:EHDGXj7SdkhCDtMeKB8_qTi1X2CJlAkTNp_CZvK_a-lrmRPzVH6UQg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1429C3066482;
        Thu, 21 May 2020 08:11:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/2] selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer
Date:   Thu, 21 May 2020 15:11:45 +0300
Message-Id: <20200521121145.1076075-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521121145.1076075-1-idosch@idosch.org>
References: <20200521121145.1076075-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Starting from iputils s20190709 (used in Fedora 31), arping does not
support timeout being specified as a decimal:

$ arping -c 1 -I swp1 -b 192.0.2.66 -q -w 0.1
arping: invalid argument: '0.1'

Previously, such timeouts were rounded to an integer.

Fix this by specifying the timeout as an integer.

Fixes: a5ee171d087e ("selftests: mlxsw: qos_mc_aware: Add a test for UC awareness")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 24dd8ed48580..b025daea062d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -300,7 +300,7 @@ test_uc_aware()
 	local i
 
 	for ((i = 0; i < attempts; ++i)); do
-		if $ARPING -c 1 -I $h1 -b 192.0.2.66 -q -w 0.1; then
+		if $ARPING -c 1 -I $h1 -b 192.0.2.66 -q -w 1; then
 			((passes++))
 		fi
 
-- 
2.26.2

