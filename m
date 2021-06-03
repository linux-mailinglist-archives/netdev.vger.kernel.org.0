Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C939A7C0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhFCRM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhFCRLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79BE1613DE;
        Thu,  3 Jun 2021 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740189;
        bh=m90RFx8X7Qq5HLGB4cFqQzdChPN2N1+Kw/SUifmZI4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0RAhSxtM3qT9thTVEI9qPmKeT5rv6Lg5j4o7DIsdYP7OjaFiqHS/CfHHs2MhXGzK
         O8Q5MD20qvB3hyE5SzYGGbuKsHL8ufPwGo2Hv8qiVJSSnyVbBPR8xr7QzdmNPvhH5a
         JUVkwJpEAxFlXBJTgnLl2T5wF+/eijhH4HIIAB5YMxKDQTfMP+7xq1npMsYnEaEC6Z
         0jc/ldScg6v6VBkR9W6vBep10zJdpqqmBa358TeSoF7JtYCB50UCf5yq65smI0Md+1
         sM7dWw3n8btMhR0tpbr4FwSvqUihYtqexdh7RCujArP1WpHKJvLN3u4rZO0A8QHRr5
         UUsL6CKRMMtcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George McCollister <george.mccollister@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/31] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Thu,  3 Jun 2021 13:09:12 -0400
Message-Id: <20210603170919.3169112-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index 49ab1346dc3f..0370e71ed6e0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1520,6 +1520,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.30.2

