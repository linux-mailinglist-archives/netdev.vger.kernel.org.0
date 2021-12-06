Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7962346AE70
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377186AbhLFXbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:31:03 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:24074 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245603AbhLFXa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=guW23mtTiuXwskiyecdg4qte38wrAp/AoTMhy7lWU8Q=;
        b=mgCujg937KxmbAHssJ0ootFafPyQbdzAkwFXoBRbou2mtwdstM5LaGe+qX8HoFR6xHeB
        1KCnlGJUsfd6Wuar/Pmu62I6KeFc+6yv5TawqrieUqNqeudtTGeEaQxpGIAtx9ZkBLgy8V
        nLeRma/mot/cVMeylrbQ8vSzfxqpNZn+grVbblayOYtVf1q8+/Jpp5P8pe9P05p2DKqbLr
        UHHkbCnrV6MNp1IbIt2AzzEHrHo/TAm2xCvPF6Tamt+Gf3VTcjQIKmdruknnoX+0PJvk2y
        sbsQbPmN3nieCWmuSYP+J6euNXLKJMCOTGXGU3HwGDIQsPlTajeBP0NkElreFi6g==
Received: by filterdrecv-7bf5c69d5-rfl26 with SMTP id filterdrecv-7bf5c69d5-rfl26-1-61AE9C61-7
        2021-12-06 23:27:29.145840161 +0000 UTC m=+8298397.887489927
Received: from pearl.egauge.net (unknown)
        by ismtpd0042p1las1.sendgrid.net (SG) with ESMTP
        id yhYDs2-tRiq_G3Ztow9I1A
        Mon, 06 Dec 2021 23:27:28.993 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 2547470016C; Mon,  6 Dec 2021 16:27:28 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 1/2] wilc1000: Fix copy-and-paste typo in wilc_set_mac_address
Date:   Mon, 06 Dec 2021 23:27:29 +0000 (UTC)
Message-Id: <20211206232709.3192856-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206232709.3192856-1-davidm@egauge.net>
References: <20211206232709.3192856-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvE0edDvWCJfLmJJeJ?=
 =?us-ascii?Q?yLdPFdjcmJadQ1tVAys6WtKgGjBcOwi3qJ8nwdk?=
 =?us-ascii?Q?ucZAH+dD5nMbK21Cx50FV9oWEoYF1zOmqu7E5Pk?=
 =?us-ascii?Q?L1GtQ23eMmgDDrstp=2F6sXkkLPmLQjMUZzGXOMn4?=
 =?us-ascii?Q?4WxpbYhahLLk0lOG9sieNt5xclkaQAqMPXez9j?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The messages appears to have been copied from wilc_get_mac_address and
says "get" when it should say "set".

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/hif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index e69b9c7f3d31..a019da0bfc3f 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -1312,7 +1312,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 	result = wilc_send_config_pkt(vif, WILC_SET_CFG, &wid, 1);
 	if (result)
-		netdev_err(vif->ndev, "Failed to get mac address\n");
+		netdev_err(vif->ndev, "Failed to set mac address\n");
 
 	return result;
 }
-- 
2.25.1

