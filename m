Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E6E4241A3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239264AbhJFPq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhJFPqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E38361175;
        Wed,  6 Oct 2021 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535100;
        bh=YN7rWKYyFKLO+x+bK3vpWhaGAkA5NZiKQjHnn5aL7TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4ZdKZs+Fk+9xecGJgJaT5q9YaFNyD+wQ2HBxKKtKUKZvRTKA5vT849YGWF6WmXwl
         VYKUKDDFrRGvZAjNIOEb5prZictKvj8nBE8O8hJgsQkZ/jSjTVG9j3FrsvE/x0T904
         fmp6Cliam8Cbnj+EfwVXyd4XGhjkEQUqeMg4z7C6z2xmJuis0f9jCs22pIv+E6esFx
         ad89cikK8qyT7WU6P1b8Yz+8vVP2yeLdqbXIPZW4mqAlI6TEOp3HB1oj+ZFaP1rgkY
         5nTf5UD5npQycxOQMND32pCW0Xk7LGi4rwQ9niBf1D/KtModbfLgP3TK5nAH/Z0zhZ
         dCRTaa4HdeSjw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        andrew@lunn.ch, jeremy.linton@arm.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 1/9] of: net: move of_net under net/
Date:   Wed,  6 Oct 2021 08:44:18 -0700
Message-Id: <20211006154426.3222199-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006154426.3222199-1-kuba@kernel.org>
References: <20211006154426.3222199-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob suggests to move of_net.c from under drivers/of/ somewhere
to the networking code.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: new patch
---
 drivers/of/Makefile               | 1 -
 net/core/Makefile                 | 1 +
 {drivers/of => net/core}/of_net.c | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename {drivers/of => net/core}/of_net.c (100%)

diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index c13b982084a3..e0360a44306e 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
-obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_UNITTEST) += unittest.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
diff --git a/net/core/Makefile b/net/core/Makefile
index 35ced6201814..37b1befc39aa 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_OF_NET)	+= of_net.o
diff --git a/drivers/of/of_net.c b/net/core/of_net.c
similarity index 100%
rename from drivers/of/of_net.c
rename to net/core/of_net.c
-- 
2.31.1

