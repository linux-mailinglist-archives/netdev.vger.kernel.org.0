Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B84239BB8A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhFDPTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:19:47 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54916 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhFDPTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBKFhxPsXa9fMNRa2Z76DvOFp9cyO77PK+EqAtHPkcI=;
        b=D7ylREqfEpWAWkunLfhUCnnZHyqZ6G9xnBmi+6goAPQWnlc3hJaEY+EbLZl7PTEBrGrlRD
        sQJERMBUmNwxj3Fw/n9xnwzPBqhkLfbZLlyyhNwXiQhZQo07Fsxc/Qq2bYHl/hLCCqRdzi
        pbsYjQ8wRns1N/RuXdA4emoV0IuJtIE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 38e50d81 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:17:55 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: [PATCH net 1/9] wireguard: selftests: remove old conntrack kconfig value
Date:   Fri,  4 Jun 2021 17:17:30 +0200
Message-Id: <20210604151738.220232-2-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On recent kernels, this config symbol is no longer used.

Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 4eecb432a66c..74db83a0aedd 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -19,7 +19,6 @@ CONFIG_NETFILTER_XTABLES=y
 CONFIG_NETFILTER_XT_NAT=y
 CONFIG_NETFILTER_XT_MATCH_LENGTH=y
 CONFIG_NETFILTER_XT_MARK=y
-CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_NF_NAT_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
-- 
2.31.1

