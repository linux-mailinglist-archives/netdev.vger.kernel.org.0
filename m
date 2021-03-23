Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DBE3459D5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCWIfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:35:44 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62052 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCWIfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616488538; x=1648024538;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n0QbJ/Z7gyQ6Y1lX/uRkOsxsUGuPQPG7ECU7h9LJUZw=;
  b=GKecO98wF8tVGF1gmAvhL8z8sXfMgPLz2UwUUTlmHCQxnPnNkDpfqbvx
   RpSnELNRAcAvkYwnQ4khw4SJVqtzC5r0H2awUYRSXQDTI8VthYm+GrdkI
   sjVqjVZ0hnOZ8IuSbZUqmjpmJ6iPdr/P1h7WP3/DB3LDq/m3QlnJ4KTvJ
   QCKmj+gmfvzLnaNo0WYJ1kt9pNhO0ryo1nLlJYJIeaukc6YcrYA9pwnv8
   FSfy1r4YNfwSMC2E1c3qSpSoXexnrrCOzS8ieyt8jlmYihRae2hlnx5ob
   XBOJqqF/xQUrO7TDvjw/BxvKu5uPZFlw/B2+bUrzNM9qXGDUI5SmyQhNN
   w==;
IronPort-SDR: pjgrJFbpQTN1gVcjItgPC4kHUqNiCXV4QpL8Ld7cp756DBcXg0TSE5PlFDp3oUJRqE1gS51PdE
 dP56+XHNNgvNJtDgmvWfho8St7TQ3b4/RxCpf6UHJNnDs3GXFIlah9RCS+r+Sk9ynbJTKfxXZ8
 MSeRfw9OK4NX9ZsnF/qM0oTYJ/aCIyL51v4AWZEsoUtyA8UqxCiFS2opP1iCVc7ZX1dakzri61
 Tdx5DDp0xFavR+4J4NHwt3O/PxR9tvERyEbdIHFS6nMY4GJz9VGso7i7scf6WaF1XLyiT74aYE
 u7s=
X-IronPort-AV: E=Sophos;i="5.81,271,1610434800"; 
   d="scan'208";a="120052697"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2021 01:35:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 01:35:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 23 Mar 2021 01:35:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/2] bridge: mrp: Disable roles before deleting
Date:   Tue, 23 Mar 2021 09:33:45 +0100
Message-ID: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch in this series make sures that the driver is notified
that the role is disabled before the MRP instance is deleted. The
second patch uses this so it can simplify the driver.

Horatiu Vultur (2):
  bridge: mrp: Disable roles before deleting the MRP instance
  net: ocelot: Simplify MRP deletion

 drivers/net/ethernet/mscc/ocelot_mrp.c | 16 ----------------
 net/bridge/br_mrp.c                    |  7 +++++++
 2 files changed, 7 insertions(+), 16 deletions(-)

-- 
2.30.1

