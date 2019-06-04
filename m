Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80019353EA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfFDX3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbfFDXYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F158208E3;
        Tue,  4 Jun 2019 23:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690654;
        bh=JuCL/V95sAY2uK9l+vLc6ZVaQuJ16tz1rO39sWszk3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkebFTFoI0vndtYsT8vM0IBJQBJIx70thNRQmI7rC66MLLbrmtNMcj5wy4UDGE12e
         JG+nDsyRJS3d8J2BFc6hwlKZJLL455GYEFesWluNGggYaRJZfQj1Q2NcJVYiX0+g0v
         kOfLmoUwoL2UQSTNPUIFVHnJxdnlC+3+64j81HOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/36] selftests: fib_rule_tests: fix local IPv4 address typo
Date:   Tue,  4 Jun 2019 19:23:21 -0400
Message-Id: <20190604232333.7185-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232333.7185-1-sashal@kernel.org>
References: <20190604232333.7185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit fc82d93e57e3d41f79eff19031588b262fc3d0b6 ]

The IPv4 testing address are all in 192.51.100.0 subnet. It doesn't make
sense to set a 198.51.100.1 local address. Should be a typo.

Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index d84193bdc307..dbd90ca73e44 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -55,7 +55,7 @@ setup()
 
 	$IP link add dummy0 type dummy
 	$IP link set dev dummy0 up
-	$IP address add 198.51.100.1/24 dev dummy0
+	$IP address add 192.51.100.1/24 dev dummy0
 	$IP -6 address add 2001:db8:1::1/64 dev dummy0
 
 	set +e
-- 
2.20.1

