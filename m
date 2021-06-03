Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C94739A75B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhFCRLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhFCRKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B47613DE;
        Thu,  3 Jun 2021 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740147;
        bh=sqob/9gAvgLS5yP52CmR/Jxa1TU4Yw2R3RZ2tNKUKAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWnkbFwcla7veDZPH61uAb6S2oA4Uuqe//TYIrxurLd6DlZHXZGeabZmFpIHQBMU0
         VpGke2L3zbTeO4+xJMYqnke2pFzcoIqANEb+gvmWQlRZdYWNOA1wK89Jn3F+AyQSzm
         YDXwtYNLohnd3Ttn2ABMa/IqvBdfMAoNRxzSPA9AwbvtkM95H8QFvowxdD/k3xWgcH
         01i9GimYPne1aMetHmZ/8NtDuLKzUARqXLXjF8cJTRqZORYsXHHU0AdZLdPMkvax7K
         KVflj0RggspiMJyBnswfO1uYMtMRKuNESZKcp7DIO8ve9Mw93aZ8upQpbPTymG+Fz/
         9KuaFgjdnhBLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/39] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Thu,  3 Jun 2021 13:08:21 -0400
Message-Id: <20210603170829.3168708-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit 8c42a49738f16af0061f9ae5c2f5a955f268d9e3 ]

Also enable phy errata workaround on 9567 since has the same errata as
the 9477 according to the manufacture's documentation.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index abfd3802bb51..b3aa99eb6c2c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1532,6 +1532,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.30.2

