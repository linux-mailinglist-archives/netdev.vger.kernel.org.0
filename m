Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD4B27163B
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 19:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgITRRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 13:17:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgITRRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 13:17:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kK2xi-00FUYd-Md; Sun, 20 Sep 2020 19:17:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net-next 1/5] net: netdevice.h: Document proto_down_reason
Date:   Sun, 20 Sep 2020 19:16:59 +0200
Message-Id: <20200920171703.3692328-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920171703.3692328-1-andrew@lunn.ch>
References: <20200920171703.3692328-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the Sphinx warning:

./include/linux/netdevice.h:2162: warning: Function parameter or member
'proto_down_reason' not described in 'net_device'

by adding the needed documentation.

Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fef0eb96cf69..9ea53cb92766 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1774,6 +1774,7 @@ enum netdev_priv_flags {
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
+ *	@proto_down_reason:	Reason protocol is holding an interface down
  *	@watchdog_timer:	List of timers
  *
  *	@pcpu_refcnt:		Number of references to this device
-- 
2.28.0

