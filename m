Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2214AAAC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 20:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgA0TlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 14:41:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:60163 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0TlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 14:41:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 11:17:52 -0800
X-IronPort-AV: E=Sophos;i="5.70,370,1574150400"; 
   d="scan'208,223";a="246489194"
Received: from jmanteyx-desk.jf.intel.com ([10.54.51.75])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 27 Jan 2020 11:17:52 -0800
To:     netdev@vger.kernel.org
Cc:     samjonas <sam@mendozajonas.com>, davem@davemloft.net,
        Johnathan Mantey <johnathanx.mantey@intel.com>
From:   Johnathan Mantey <johnathanx.mantey@intel.com>
Subject: [PATCH ftgmac100:] Return link speed and duplex settings for the NCSI
 channel
Autocrypt: addr=johnathanx.mantey@intel.com; prefer-encrypt=mutual; keydata=
 mQENBFija08BCAC60TO2X22b0tJ2Gy2iQLWx20mGcD7ugBpm1o2IW2M+um3GR0BG/bUcLciw
 dEnX9SWT30jx8TimenyUYeDS1CKML/e4JnCAUhSktNZRPBjzla991OkpqtFJEHj/pHrXTsz0
 ODhmnSaZ49TsY+5BqtRMexICYOtSP8+xuftPN7g2pQNFi7xYlQkutP8WKIY3TacW/6MPiYek
 pqVaaF0cXynCMDvbK0km7m0S4X01RZFKXUwlbuMireNk4IyZ/59hN+fh1MYMQ6RXOgmHqxSu
 04GjkbBLf2Sddplb6KzPMRWPJ5uNdvlkAfyT4P0R5EfkV5wCRdoJ1lNC9WI1bqHkbt07ABEB
 AAG0JUpvaG5hdGhhbiBNYW50ZXkgPG1hbnRleWpnQGdtYWlsLmNvbT6JATcEEwEIACEFAlij
 a08CGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ0EfviT3fHwmcBAgAkENzQ8s0RK+f
 nr4UogrCBS132lDdtlOypm1WgGDOVQNra7A1rvXFgN05RqrdRTpRevv7+S8ipbiG/kxn9P8+
 VhhW1SvUT8Tvkb9YYHos6za3v0YblibFNbYRgQcybYMeKz2/DcVU+ioKZ1SxNJsFXx6wH71I
 V2YumQRHAsh4Je6CmsiMVP4XNadzCQXzzcU9sstKV0A194JM/d8hjXfwMHZE6qnKgAkHIV3Q
 61YCuvkdr5SJSrOVo2IMN0pVxhhW7lqCAGBGb4oOhqePwGqOabU3Ui4qTbHP2BWP5UscehkK
 6TVKcpYApsUcWyxvvOARoktmlPnGYqJPnRwXpQBlqLkBDQRYo2tPAQgAyOv5Lgg2VkHO84R7
 LJJDBxcaCDjyAvHBynznEEk11JHrPuonEWi6pqgB8+Kc588/GerXZqJ9AMkR43UW/5cPlyF2
 wVO4aYaQwryDtiXEu+5rpbQfAvBpKTbrBfYIPc8thuAC2kdB4IO24T6PVSYVXYc/giOL0Iwb
 /WZfMd5ajtKfa727xfbKCEHlzakqmUl0SyrARdrSynhX1R9Wnf2BwtUV7mxFxtMukak0zdTf
 2IXZXDltZC224vWqkXiI7Gt/FDc2y6gcsYY/4a2+vjhWuZk3lEzP0pbXQqOseDM1zZXln/m7
 BFbJ6VUn1zWcrt0c82GTMqkeGUheUhDiYLQ7xwARAQABiQEfBBgBCAAJBQJYo2tPAhsMAAoJ
 ENBH74k93x8JKEUH/3UPZryjmM0F3h8I0ZWuruxAxiqvksLOOtarU6RikIAHhwjvluEcTH4E
 JsDjqtRUvBMU907XNotpqpW2e9jN8tFRyR4wW9CYkilB02qgrDm9DXVGb2BDtC/MY+6KUgsG
 k5Ftr9uaXNd0K4IGRJSyU6ZZn0inTcXlqD+NgOE2eX9qpeKEhDufgF7fKHbKDkS4hj6Z09dT
 Y8eW9d6d2Yf/RzTBJvZxjBFbIgeUGeykbSKztp2OBe6mecpVPhKooTq+X/mJehpRA6mAhuQZ
 28lvie7hbRFjqR3JB7inAKL4eT1/9bT/MqcPh43PXTAzB6/Iclg5B7GGgEFe27VL0hyqiqc=
Message-ID: <ca1ed820-8da4-fad0-7335-ab92501e95a0@intel.com>
Date:   Mon, 27 Jan 2020 11:17:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 2917ebea460252fe465ebd64ee720386eda574ad Mon Sep 17 00:00:00 2001
From: Johnathan Mantey <johnathanx.mantey@intel.com>
Date: Mon, 27 Jan 2020 09:03:56 -0800
Subject: [PATCH ftgmac100:] Return link speed and duplex settings for
the NCSI
 channel

The ftgmac100_open function initializes state for the NCSI
channel. The get link settings function does not return this
data. This caused the link speed, and the duplex value to be returned
incorrectly by the PHY driver (0 Mbps, and duplex off).

Update the driver to return either the PHY settings when not using
NCSI, or the NCSI values that were assigned when the driver is opened.

Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
b/drivers/net/ethernet/faraday/ftgmac100.c
index 8ed85037f021..a53878eecfc8 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1218,10 +1218,30 @@ static int ftgmac100_set_pauseparam(struct
net_device *netdev,
 	return 0;
 }

+int ftgmac100_ethtool_get_link_ksettings(struct net_device *netdev,
+					 struct ethtool_link_ksettings *cmd)
+{
+	struct phy_device *phydev = netdev->phydev;
+	struct ftgmac100 *priv = netdev_priv(netdev);
+	int retval = 0;
+
+	if (phydev) {
+		phy_ethtool_ksettings_get(phydev, cmd);
+	} else if (priv->use_ncsi) {
+		cmd->base.speed = priv->cur_speed;
+		cmd->base.duplex = priv->cur_duplex;
+		cmd->base.autoneg = 0;
+	} else {
+		retval = -ENODEV;
+	}
+
+	return retval;
+}
+
 static const struct ethtool_ops ftgmac100_ethtool_ops = {
 	.get_drvinfo		= ftgmac100_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
-	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.get_link_ksettings	= ftgmac100_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.nway_reset		= phy_ethtool_nway_reset,
 	.get_ringparam		= ftgmac100_get_ringparam,
-- 
2.24.1

-- 
Johnathan Mantey
Senior Software Engineer
*azad technology partners*
Contributing to Technology Innovation since 1992
Phone: (503) 712-6764
Email: johnathanx.mantey@intel.com <mailto:johnathanx.mantey@intel.com>

