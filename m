Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C2C27163D
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 19:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgITRRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 13:17:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgITRRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 13:17:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kK2xi-00FUYg-Nt; Sun, 20 Sep 2020 19:17:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH net-next 2/5] net: netdevice.h: Document xdp_state
Date:   Sun, 20 Sep 2020 19:17:00 +0200
Message-Id: <20200920171703.3692328-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920171703.3692328-1-andrew@lunn.ch>
References: <20200920171703.3692328-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the Sphinx warning:

Function parameter or member 'xdp_state' not described in 'net_device'

by documenting xdp_state.

Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/netdevice.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9ea53cb92766..99cab8c0a292 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1842,6 +1842,8 @@ enum netdev_priv_flags {
  *				offload capabilities of the device
  *	@udp_tunnel_nic:	UDP tunnel offload state
  *
+ *	@xdp_state:	Info on attached XDP BPF programs
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
-- 
2.28.0

