Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A6A2A680B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgKDPtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:49:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35294 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgKDPtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:49:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaL2F-005Ebb-W2; Wed, 04 Nov 2020 16:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/7] drivers: net: smc91x: Fix missing kerneldoc reported by W=1
Date:   Wed,  4 Nov 2020 16:48:53 +0100
Message-Id: <20201104154858.1247725-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201104154858.1247725-1-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/smsc/smc91x.c:2199: warning: Function parameter or member 'dev' not described in 'try_toggle_control_gpio'
drivers/net/ethernet/smsc/smc91x.c:2199: warning: Function parameter or member 'desc' not described in 'try_toggle_control_gpio'
drivers/net/ethernet/smsc/smc91x.c:2199: warning: Function parameter or member 'name' not described in 'try_toggle_control_gpio'
drivers/net/ethernet/smsc/smc91x.c:2199: warning: Function parameter or member 'index' not described in 'try_toggle_control_gpio'
drivers/net/ethernet/smsc/smc91x.c:2199: warning: Function parameter or member 'value' not described in 'try_toggle_control_gpio'
drivers/net/ethernet/smsc/smc91x.c:2199: warning: Function parameter or member 'nsdelay' not described in 'try_toggle_control_gpio'

Document these parameters.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc91x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 61333939a73e..83dde7db0851 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2191,6 +2191,12 @@ MODULE_DEVICE_TABLE(of, smc91x_match);
 
 /**
  * of_try_set_control_gpio - configure a gpio if it exists
+ * @dev: net device
+ * @desc: where to store the GPIO descriptor, if it exists
+ * @name: name of the GPIO in DT
+ * @index: index of the GPIO in DT
+ * @value: set the GPIO to this value
+ * @nsdelay: delay before setting the GPIO
  */
 static int try_toggle_control_gpio(struct device *dev,
 				   struct gpio_desc **desc,
-- 
2.28.0

