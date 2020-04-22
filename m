Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DD91B4A41
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDVQVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:21:49 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21023 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgDVQVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587572507; x=1619108507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xoMFGgH5DELLbtoeobiA873J6IsfnJEOZCpVd+LRec0=;
  b=MjVFIFu4vl0wtv7K9FcS5EMYDFHXcVaswWUjbDRM8fsKc7KS3LjVfHHm
   HW6LRSa47T9rk9Q0jIZiITuIOuPfZQ1+RJnwlwQQ1z0ioYc5SY60+sRJs
   m+5ENXKZ/4PgAwjBlb0j8Np7PsI6q0246VwH0yr1LNe3Twit+OxoyqbiF
   0lvgIFHQOHX/HxMKO3eQLGN83noNKg5aN4d9coxFv1nICY3D7oNcB6ctz
   a1df8ntCp/64BCIBBAxuZIqCnEhUDF+GBFIbf2mnDCebruOIm1gEsUOcY
   pj/qMLSuiCkuVaFfSFXLtT4Tye2Z5WxUOOKsIz9Z/OIp0ggUg8q0/e8w9
   A==;
IronPort-SDR: DN94evDVfPz+jYpaexez0GVVMpuHEi6Nl6OgCEy0+wA5Yx7UcNnSPFbigXdHT4U/INSprDlr9I
 KhtZ6qMW1/KBO9im2S1PlkWujOrN0u00fiPrLHODcQOr4+Qs0L2utnWP8yLLSBzTQ6CShZk6Ai
 CiVx9sAt2912S4VtCrWIZaUflOq137zOvWhBH/RqzCWnf0RU3zVLT4H9S6FoFGCkm2a9f2rhDk
 ATdKyC/kXSo603YN0QVSLk5svO06PFe1LmD5lbE1ZMGPo5kaW4BTqNZcop3+TbV4K6Tuny7kXF
 Ia4=
X-IronPort-AV: E=Sophos;i="5.73,304,1583218800"; 
   d="scan'208";a="73007263"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2020 09:21:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Apr 2020 09:21:47 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 22 Apr 2020 09:21:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 02/11] bridge: mrp: Update Kconfig
Date:   Wed, 22 Apr 2020 18:18:24 +0200
Message-ID: <20200422161833.1123-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422161833.1123-1-horatiu.vultur@microchip.com>
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the option BRIDGE_MRP to allow to build in or not MRP support.
The default value is N.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index e4fb050e2078..51a6414145d2 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -61,3 +61,15 @@ config BRIDGE_VLAN_FILTERING
 	  Say N to exclude this support and reduce the binary size.
 
 	  If unsure, say Y.
+
+config BRIDGE_MRP
+	bool "MRP protocol"
+	depends on BRIDGE
+	default n
+	help
+	  If you say Y here, then the Ethernet bridge will be able to run MRP
+	  protocol to detect loops
+
+	  Say N to exclude this support and reduce the binary size.
+
+	  If unsure, say N.
-- 
2.17.1

