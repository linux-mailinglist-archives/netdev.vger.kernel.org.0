Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D0821CC03
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGLXP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59542 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgGLXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPF-Iq; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 03/20] net: core: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:14:59 +0200
Message-Id: <20200712231516.1139335-4-andrew@lunn.ch>
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

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c02bae927812..eab4ebe3c21c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7908,6 +7908,7 @@ EXPORT_SYMBOL(netdev_bonding_info_change);
 
 /**
  * netdev_get_xmit_slave - Get the xmit slave of master device
+ * @dev: device
  * @skb: The packet
  * @all_slaves: assume all the slaves are active
  *
-- 
2.27.0.rc2

