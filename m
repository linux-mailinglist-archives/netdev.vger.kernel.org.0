Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463F321CC17
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgGLXQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mQi-K0; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 17/20] net: switchdev: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:13 +0200
Message-Id: <20200712231516.1139335-18-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/switchdev/switchdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index f25604d68337..865f3e037425 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -304,8 +304,8 @@ static int switchdev_port_obj_add_defer(struct net_device *dev,
  *	switchdev_port_obj_add - Add port object
  *
  *	@dev: port device
- *	@id: object ID
  *	@obj: object to add
+ *	@extack: netlink extended ack
  *
  *	Use a 2-phase prepare-commit transaction model to ensure
  *	system is not left in a partially updated state due to
@@ -357,7 +357,6 @@ static int switchdev_port_obj_del_defer(struct net_device *dev,
  *	switchdev_port_obj_del - Delete port object
  *
  *	@dev: port device
- *	@id: object ID
  *	@obj: object to delete
  *
  *	rtnl_lock must be held and must not be in atomic section,
-- 
2.27.0.rc2

