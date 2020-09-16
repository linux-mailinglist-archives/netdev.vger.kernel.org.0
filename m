Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFC626C181
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 12:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIPKJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 06:09:44 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:52588 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgIPKJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 06:09:41 -0400
IronPort-SDR: 2YUMVyEGOWA/tfr9WxngXa84kUpu4ds6P5MmREyiwAoeOrjtRtcl7TbMdxPNsOvfC5dNgPtTJU
 IJIwSn5swriaoXGP4MeL5p2uqf7E49z5C/3qHln3uJB9+IskzurGSQt0Fbk3hEGjXK/AXLCMSD
 vKyHoKdDZfhgz7eUTarpaz79aD8HgwgdOXZPbfdssts0GC2kZLAD6y40LZRHaLC4U1yAg7AKDu
 A+8Vn9IXSeun79vuhMI44D8R2FJvSwioenjvdIaWCfm0FmA0fmMSqSz7x1mBzAMy8gIzYRMLk1
 IQY=
X-IronPort-AV: E=Sophos;i="5.76,432,1592863200"; 
   d="scan'208";a="13886499"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 16 Sep 2020 12:08:52 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 16 Sep 2020 12:08:52 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 16 Sep 2020 12:08:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1600250932; x=1631786932;
  h=from:to:cc:subject:date:message-id;
  bh=tKwDDfKEIeokAjENkz+QHEWU2sljEnyvtM1KcwS62K4=;
  b=oGFUJU87l3FIuREKx/UbBstIuye4ETCFLFSIJBXeWiVOfHLzy14vP8RE
   zwK+tmWQt0WDBc28NYM3OIqdLpxrokaUdyHnuju0bmLNLYvqwnhcP4X1V
   4Sr5WReOu39aETPN7XZ3oHe8AzxODqufhqKLNxIpbZ8sNQSMoE4GBZAmK
   uJ/NPD1FXYfgyhKM5gF+m+glQ7TterRdQ7jpO/AjKwdiYrgo0TjWjmMcW
   LvQ6zQx83+kIDnzkxXLWjM/OnGZb5KQHfxwqGnw3YyAJoSJ1aXJ/+kwOY
   DFnv3ql2qVdp1f2a/MhX3ekAcU6wP18m914Czy3harg8RSN59xc8p2Z0J
   Q==;
IronPort-SDR: XXb5JNNPsJ7kfreUjuEXHKvAl7qCd0WdY12sJJtWVIvN/LLlkeaEEbeCyhnCHv5yn5caquGK/k
 S5GczmeJUPwvLYzIkJFH86e2wY/DGboxhpLEG9+jXNnZ7qnpERlVEVJU6SMuM+poWM+SzYGX4F
 BvBG6Uku0rSc0gpst2XacrkiAIBvMXaChYZXPcMUMDZcQBZwgjZCDomtn4FBKmKs9/nG0G6wR8
 YFQ9wOcCsoj+o0j97dEL6X/bo3Qad+JGReVc3Qx6NL3FXkp2R+rGhd2n2uKQ2mC0e0HfYa0mDv
 k6Q=
X-IronPort-AV: E=Sophos;i="5.76,432,1592863200"; 
   d="scan'208";a="13886498"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 16 Sep 2020 12:08:52 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 01134280070;
        Wed, 16 Sep 2020 12:08:51 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net] net: dsa: microchip: ksz8795: really set the correct number of ports
Date:   Wed, 16 Sep 2020 12:08:39 +0200
Message-Id: <20200916100839.843-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9477 and KSZ8795 use the port_cnt field differently: For the
KSZ9477, it includes the CPU port(s), while for the KSZ8795, it doesn't.

It would be a good cleanup to make the handling of both drivers match,
but as a first step, fix the recently broken assignment of num_ports in
the KSZ8795 driver (which completely broke probing, as the CPU port
index was always failing the num_ports check).

Fixes: af199a1a9cb0 ("net: dsa: microchip: set the correct number of
ports")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/dsa/microchip/ksz8795.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f7d59d7b2cbe..f5779e152377 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1260,7 +1260,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	}
 
 	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt;
+	dev->ds->num_ports = dev->port_cnt + 1;
 
 	return 0;
 }
-- 
2.17.1

