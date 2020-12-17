Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B602DD19A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 13:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgLQMm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 07:42:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17522 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQMm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 07:42:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608208948; x=1639744948;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=g0seu7wCNtS3v9Y956s8yswkKuwOZXvJG6aucJKBbG0=;
  b=MF+LpvtiNMaTRTH335hg6wBgzBVfEoNr3A0MWVPKj19l6xQWv2g0xOwQ
   xq/1lTtCGVdnBq4h50Tpnp54PuyZsj32WSyfYD+8kRybqX7dEShTrxcXs
   N40nj/ime7w0pakZKPB8nKzfJ7YhBBlC1nxv7wVBX6xFLI+lDnHkivlmX
   VG3YDQC8Grdnk4F39ljSHNiaE6bwPGHMxSRZHttbk95Ba7xVepDQoU+jR
   wKEDXEPg1q+eG5u519ZNulsFu55E0O/07qCDtKEU4H2jjfhFdBelVJ+sf
   IwyybiazPy+8PdlddPfSRWgmzwv9apoLHd82IMRZFZlNpF6iFAF6MDWmX
   w==;
IronPort-SDR: m0zWWBcGj+cBpLEyMfnYVLn2QHD2lym7zFl5E+9auc6CqRgPQE4wyQi93DHJyI9KrD4o9mkij1
 Aspsc+sLYDzlvv8uX2M3yk3YGZQxvF0APDLKxaJOLo62o+aRvPG+DDK6qhDWGvOHA7g+D2IhBB
 iew6kz/81PzS9kff+3pviQBxG14hjjrI0Q31I6uVqgftMjC2sfYRw/0riwcNTlvcVVvvO7AAvO
 NWZZFJka8BrSxMhqh5xDO1FZ3nS/eQDSRRbnkgAh1r3BUhe9Y5nWCI/6YHImo8iK7cWqKQiz+c
 Llo=
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="102574548"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2020 05:41:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 05:41:11 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 17 Dec 2020 05:41:07 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v4 net-next 0/2] net: phy: mchp: Add support for 1588 driver and interrupt support 
Date:   Thu, 17 Dec 2020 18:11:04 +0530
Message-ID: <20201217124104.8285-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support for Linkup/Linkdown suport for LAN8814 phy
and 1588 Driver support for the same phy.

v3->v4
-Changed call to MAC API in phy driver to phy_trigger_machine.
-Adding PTP maintainer to CC list for 1588 Driver.

v2->v3
-Split the patch into 2 patches, one is linkup/linkdown interrupt
 and the other is 1588 driver support.

v1->v2
-Fixed warnings
 Reported-by: kernel test robot <lkp@intel.com>

Divya Koppera (2):
  net: phy: mchp: Add interrupt support for Link up and Link down to
    LAN8814 phy
  net: phy: mchp: Add 1588 support for LAN8814 Quad PHY

 drivers/net/phy/micrel.c | 1007 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 1006 insertions(+), 1 deletion(-)

-- 
2.17.1

