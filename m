Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8C314E33E
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgA3T3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:29:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727438AbgA3T3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 14:29:00 -0500
Received: from localhost.localdomain (unknown [194.230.155.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7489D2082E;
        Thu, 30 Jan 2020 19:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580412539;
        bh=hhAIE0Prgk+Wv/0a25D0q0q7GJanUZwEcQHqGsWLry4=;
        h=From:To:Subject:Date:From;
        b=MnUTUMHVFAwPb/97kEX+odytMr/+pt115+l+Em3s9LFRMqDYSBfts0AFOm2WbWmsU
         38pAtsokXDD3NL8jRrUu4gC7VJPRYv1K4g5+5+2pzsIHAmaa99J81XQzMgyyQ22I0L
         xQYcNgUPUlYDSR8vfdfhr6QpTEEmC56cjBSOl01E=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireguard: selftests: Cleanup CONFIG_ENABLE_WARN_DEPRECATED
Date:   Thu, 30 Jan 2020 20:28:53 +0100
Message-Id: <20200130192853.3528-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_ENABLE_WARN_DEPRECATED is gone since
commit 771c035372a0 ("deprecate the '__deprecated' attribute warnings
entirely and for good").

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 tools/testing/selftests/wireguard/qemu/debug.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index b9c72706fe4d..5909e7ef2a5c 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -1,5 +1,4 @@
 CONFIG_LOCALVERSION="-debug"
-CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_POINTER=y
 CONFIG_STACK_VALIDATION=y
-- 
2.17.1

