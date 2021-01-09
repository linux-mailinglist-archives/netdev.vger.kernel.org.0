Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833AD2EFDDA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 06:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbhAIFHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 00:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbhAIFHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 00:07:08 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC5BC061573;
        Fri,  8 Jan 2021 21:06:27 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id a109so11909117otc.1;
        Fri, 08 Jan 2021 21:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HLhDeEB86uGsF0AuIV10falkochVgXippMmbTrnpCyg=;
        b=N0jVRtvYiEibP3xZ1/Q0RKATfhw88NJfb99SekIIuE8ayljs1HtSmWkhkcKDmSYHJR
         AF7aUTkjkW3t59Ds5rkvDKwBxr2GoFGEDbIMYsn/35efBSIoyfY5jmox3C2QURCGNvqR
         d/3zbjNb0fHFeqc9M3vZifn0nIihz30m9hgXNw5zX3c4j3u2P3R4GTbIHkbiJo504NJI
         NoaJzsGdpnk9rsY0IgVP+xS1Uu6GYj6eQSlvhb+F0D7LHZwD9RIN6zqSIgmxnDcuZTG4
         pjyr3H0XjSInJKvMyND7UVfRasenVFk0YkE6WeenjIei7rhF7jx0L4FKoZyY17TrRLA3
         c30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HLhDeEB86uGsF0AuIV10falkochVgXippMmbTrnpCyg=;
        b=kie7SMlE6AQtWAANFcSa0ZM3yeZPNg7kZEQEqnTwR+3XYMYDc52uFdqwymkW2ZxNhc
         GPLVXj6j1fX/HZmgWQGhivqVbNiQwslZjRLF96F9xzR3gYXmEHs4Xjjsn5kS1UBNCeYH
         MRDnjfhLVYMa0pBwLe3JakteOtPO04nCbs1gzgSN5gnJcZhQD71HkzxQViLYLM620Q9L
         g6QuOKDkySf5G2H8yrzZrEdyRQdxSz/B3gIhTcrFGqJbuGJvhcuO0/rJjug1PE/Tijb4
         LekU5NiqavhqvRk/zBlKTBotXXSsCH7Q6bFh8BYQ2/QnbqueDm/JB2j589jo3SxGYhUg
         rhUA==
X-Gm-Message-State: AOAM531j/wiejmSGXroRPLTuws77f4LbkLZRsZNd6Si/8LTkKyU8/KCl
        qlWuKFprADTLtda9+MRKOCvC6uZ2szY=
X-Google-Smtp-Source: ABdhPJxVy/wFlgWu7N1Ol2TxegQyV3CuHhfPwYx/JOmtwmNh299krr4Wr4ZfGqDHeJCLzBqgkhbUIg==
X-Received: by 2002:a9d:c01:: with SMTP id 1mr4823172otr.107.1610168786518;
        Fri, 08 Jan 2021 21:06:26 -0800 (PST)
Received: from BENDER.localdomain (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id m3sm2280045ots.72.2021.01.08.21.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 21:06:25 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: marvell: prestera: Correct typo
Date:   Fri,  8 Jan 2021 21:06:22 -0800
Message-Id: <20210109050622.8081-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function was incorrectly named with a trailing 'r' at the end of
prestera.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Jakub, David,

This patch is on top of Vladimir's series: [PATCH v4 net-next 00/11] Get
rid of the switchdev transactional model

 .../net/ethernet/marvell/prestera/prestera_switchdev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index e2374a39e4f8..beb6447fbe40 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -652,9 +652,9 @@ static int prestera_port_bridge_vlan_stp_set(struct prestera_port *port,
 	return 0;
 }
 
-static int presterar_port_attr_stp_state_set(struct prestera_port *port,
-					     struct net_device *dev,
-					     u8 state)
+static int prestera_port_attr_stp_state_set(struct prestera_port *port,
+					    struct net_device *dev,
+					    u8 state)
 {
 	struct prestera_bridge_port *br_port;
 	struct prestera_bridge_vlan *br_vlan;
@@ -702,8 +702,8 @@ static int prestera_port_obj_attr_set(struct net_device *dev,
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		err = presterar_port_attr_stp_state_set(port, attr->orig_dev,
-							attr->u.stp_state);
+		err = prestera_port_attr_stp_state_set(port, attr->orig_dev,
+						       attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		if (attr->u.brport_flags &
-- 
2.25.1

