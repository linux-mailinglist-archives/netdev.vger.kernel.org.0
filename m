Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75FB39A706
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhFCRKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhFCRKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C274613FF;
        Thu,  3 Jun 2021 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740095;
        bh=FkN6Rw5FRuamBtoMbv6YLtAawJtD3g5PU7GlD6qaFyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojZamX678MuCfaq6YHFOuOb1ekhIgnZvABa7S0sc829SouL0dYN41BmmyDAD86TLq
         +6JRDBbpgg0t/Zrf6a8XSnyhcxH/ECyM/FWXJ3HQER0CVub8UxPUycykQ2r1VKV53E
         z0dYKFJdoHS7fv1YJDPNim+IImujjR25O8zqOpJKFgKzVkA0zTKqscrmhIgtwLh56F
         ZdJ1cWBsyQTHwv/fySiB2tdt4Jmdxtzdj+xIZtZKFam5ywAAaSxwmwrzbAt2/+LFPq
         Qaas7Xtm0UB7vA+F51HFlLNGSlvrcvN2AScYLc0Sql4LBq51jdvrfsFdUUGywGo+3w
         DNsHwrnwradoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 33/43] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Thu,  3 Jun 2021 13:07:23 -0400
Message-Id: <20210603170734.3168284-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
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
index 55e5d479acce..854e25f43fa7 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1530,6 +1530,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.30.2

