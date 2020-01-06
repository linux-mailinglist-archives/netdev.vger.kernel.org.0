Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DA0131618
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgAFQcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:32:21 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11453 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgAFQcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 11:32:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578328341; x=1609864341;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WFMFqghBZVNgReMquuCKfj8buAwP//uqy908WUXnvhM=;
  b=LzYMNve662j04z3ombOoeIe4I7Odawy2QwBP2828GmSXi9hq4hbU498+
   gxZAue4hIgZK/E0ecT07YoFKjP99mLgiDuqBJQUtxrb1V14n/viVjt69z
   N9y+JiGMH2HkSqRT1y+bgTzCwVSvYZd2uHKJLNnYJlKAiF8K8f10r5778
   0TRRdwmBxMOntyB8Z9gTflU0OHyWyRJgGWaEdXadUZ4RtP3RC2/ahJz5d
   NrJhg3m+TTh5tMKNFnB3t4eZp2rghzjtDz96sMtwbnfFpruIb7ArWicPT
   e5pL6frJ/lTgMS5X7JvR60JArrRwSsXlKRuEVom/CgLQ5+UNNBdTi/bay
   w==;
IronPort-SDR: XsEZp0YwofaexMiH7DaehMANbwTYEZBWjxSFxuFUXE0iFzs9nZaqeM87SFp8v65BxtjnIMDjA+
 +67Ot0ubsYss4HlGen/vx6FgiCMg0R6EsJrSX72AZv8P3ZvEpxKUbCJzLvREecnVWOBf5UFuDM
 kmdorI9uNjpkws35kJZJj0IeT/CO+oCwlbpOGFVyZnJqsae6reQ+L3K+V8AZtf80MIc04WNGw9
 D4APPHx49Ci38+HHpmP2fvLLYWmmbeZXo7eA5tojRJ/9OiZK3qgfa/k4mIzc7305ujytlFwLBI
 dJk=
X-IronPort-AV: E=Sophos;i="5.69,403,1571673600"; 
   d="scan'208";a="234571335"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jan 2020 00:32:20 +0800
IronPort-SDR: VymyDCbDlaxGV24PlX8g1WkGQJ/Mdb8WWYK44TCKw/S2fEqZe3x9MmJnxEJaGwDYpRn0St1hws
 PUY6+c4p08PfLRhaSgBtckr6lwmt0WlMI2yn8AmmfoyIsyAf2m3KKX4MK8Fy7gid5woe6hou4k
 i98WQXhhuuuS7CiBmzpjXHqJuyRxUOJnp0tURS5p4uvIutw9AmtwQV/iKCy935iQCsLRMpYbEq
 Pn7H7X7+AkZaFfdXtiaza8XEez2MfWeOryU3Zt/vtvYoFPZwCBiA2d4FzqJwzOoYyUgLJjlIF7
 3X+lK7tAvA+Pz/WqyxRtIk9B
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 08:26:11 -0800
IronPort-SDR: uCDnu92e+k+f5kdX2rg0iiSLm5G1OIqf9EBfGXu6hfb5M28iPnK6bT8yKmsZHs73TgomhArZgm
 /kBKmJL63diJUJtBtSityEosDtQFhoELVoa+zpsfTi1ZVUOVjvdgaOsIl/49av/jDgWifpFKw0
 p6VE1ddW6ATWYbjzMYbxcNIElvO6NFE7iJIr9eeMlV8yraO8txPlNIiy2oYgTcIsyw+Yg771Lb
 Or7cmSTcd9FT4BLv/HaUiZRa/MBetaJlZxOGkny8AFya5rCvq2IcDBv5YyA3/cTS0vc4mK3GA4
 aLo=
WDCIronportException: Internal
Received: from usa001466.ad.shared (HELO 2325pk2fy48.ad.shared) ([10.86.51.236])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jan 2020 08:32:18 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Vinod Koul <vkoul@kernel.org>, netdev@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH net-next] MAINTAINERS: Remove myself as co-maintainer for qcom-ethqos
Date:   Mon,  6 Jan 2020 17:31:30 +0100
Message-Id: <20200106163130.258694-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As I am no longer with Linaro, I no longer have access to documentation
for this IP. The Linaro email will start bouncing soon.

Vinod is fully capable to maintain this driver by himself, therefore
remove myself as co-maintainer for qcom-ethqos.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c6c34d04ce95..dfceb2ea2add 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13477,7 +13477,6 @@ F:	drivers/net/ethernet/qualcomm/emac/
 
 QUALCOMM ETHQOS ETHERNET DRIVER
 M:	Vinod Koul <vkoul@kernel.org>
-M:	Niklas Cassel <niklas.cassel@linaro.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
-- 
2.24.1

