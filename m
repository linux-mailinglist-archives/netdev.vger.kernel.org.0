Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19319214EEC
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgGETiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:38:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgGETiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:38:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsASw-003jY6-Ko; Sun, 05 Jul 2020 21:38:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/4] net: dsa: mv88e6xxx: scratch: Fixup kerneldoc
Date:   Sun,  5 Jul 2020 21:38:10 +0200
Message-Id: <20200705193810.890020-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193810.890020-1-andrew@lunn.ch>
References: <20200705193810.890020-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct parameters and add the missing ones.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/global2_scratch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2_scratch.c b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
index 33b7b9570d29..7c2c67405322 100644
--- a/drivers/net/dsa/mv88e6xxx/global2_scratch.c
+++ b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
@@ -44,7 +44,8 @@ static int mv88e6xxx_g2_scratch_write(struct mv88e6xxx_chip *chip, int reg,
 /**
  * mv88e6xxx_g2_scratch_gpio_get_bit - get a bit
  * @chip: chip private data
- * @nr: bit index
+ * @base_reg: base of scratch bits
+ * @offset: index of bit within the register
  * @set: is bit set?
  */
 static int mv88e6xxx_g2_scratch_get_bit(struct mv88e6xxx_chip *chip,
@@ -68,8 +69,9 @@ static int mv88e6xxx_g2_scratch_get_bit(struct mv88e6xxx_chip *chip,
 /**
  * mv88e6xxx_g2_scratch_gpio_set_bit - set (or clear) a bit
  * @chip: chip private data
- * @nr: bit index
- * @set: set if true, clear if false
+ * @base_reg: base of scratch bits
+ * @offset: index of bit within the register
+ * @set: should this bit be set?
  *
  * Helper function for dealing with the direction and data registers.
  */
@@ -165,6 +167,7 @@ static int mv88e6352_g2_scratch_gpio_get_dir(struct mv88e6xxx_chip *chip,
  * mv88e6352_g2_scratch_gpio_set_dir - set direction of gpio pin
  * @chip: chip private data
  * @pin: gpio index
+ * @input: should the gpio be an input, or an output?
  */
 static int mv88e6352_g2_scratch_gpio_set_dir(struct mv88e6xxx_chip *chip,
 					     unsigned int pin, bool input)
-- 
2.27.0.rc2

