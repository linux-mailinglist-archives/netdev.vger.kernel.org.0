Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C40B1521CB
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgBDVSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:18:03 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54783 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgBDVSD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 16:18:03 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 58b928d1;
        Tue, 4 Feb 2020 21:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=MazMHom6Fpuvh505bTBaWb+DX
        Bc=; b=j1Z/trMoQOH7zqqbi8k6NLHWXP9JU1cWSbnfRUtyqEc4HMYn08Euv+Q6B
        UDKSc6oOD3aZverZcBNam0oF9MJR4KusFDTEbzOwOZjLgVwHGKO9uEjO4jv5yHoc
        jvdPu0TeZxePlsX/o+ArQNncUuFd24hxJV13pZ+Qk+nujnBnvMq44UBW8smZ9DN1
        u3uGPubW5b9G0V/hfwSHqAD98ecyy2Sai3zTmoPVPo+Dl9bnZFb8em9U1hlmIIMT
        EcS519SR6pG5CHPgQPs8Mu+2A58vo0hC5FnUKtgnDwcwVCQ3+CY+W3C2COnniZkX
        3h6i7LvY9iMo12Pi8qqDYTLdQRlpw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1c1116ff (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 4 Feb 2020 21:17:09 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/5] wireguard: selftests: cleanup CONFIG_ENABLE_WARN_DEPRECATED
Date:   Tue,  4 Feb 2020 22:17:28 +0100
Message-Id: <20200204211729.365431-5-Jason@zx2c4.com>
In-Reply-To: <20200204211729.365431-1-Jason@zx2c4.com>
References: <20200204211729.365431-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

CONFIG_ENABLE_WARN_DEPRECATED is gone since commit 771c035372a0
("deprecate the '__deprecated' attribute warnings entirely and for
good").

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
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
2.25.0

