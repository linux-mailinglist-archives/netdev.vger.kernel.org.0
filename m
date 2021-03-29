Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C1334D236
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhC2ONw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:13:52 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50288 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhC2ONU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 10:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617027200; x=1648563200;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YWzhLIhTlEiqeAWeawPZ9dEYsJeDRmKtb3HYsL4JAog=;
  b=YwEFQhW7+dg5cCBzl/x+JNn/YQS0C+vy9GzkmPDwNc4BXw0cS7+Z9FcY
   RMsB1YbYb147DadSlpQ7U+lV3icuJmRD2RUqRXwwsI+rrio0D9/ZP5t7r
   dx+uRETYzOJECzb+HnHQZA/Afg61ac799mrDRHgMiFdwlrkRpwzffOhkQ
   9jt039f8B3XzCE8biD9TuG3pJgow6EtG0ewAf6B/Aa7ZuLBb4/0c97sBN
   L4oKFSA0CuuMzAA03jaYaCZJo572LVMHAfW/lsWelXbnwHRMxgo5mzH+t
   OxcsR1Yf2DTy78G0VahMI1mmX7AsUE5V1IUiIIRqP9o94LDHVt7tkUgxF
   g==;
IronPort-SDR: V6bdargbvnzBt2MHk21HuctpAVpj0clkf9brXAIiv7tFH80AAGA5kGFtWRWrxJ9CClGJvHj88R
 MuEO7yFDWc6H2+yDzCrp81sIuFkNhtI9wM6h+3fbODR+YEU7o/RLr3BGQvFD88XYzSFq98S5JH
 wePzSGR6rjYlGH/ZiA8Hz0gR0Qj2qcL3a5epSF7hsix5o4mXGvWBsWqFn8zRYbyO88tw+Q81Wr
 8WGVdr7XLFN5MAACwWEdp/gmztnXutQWSae0bMaJrDqICQ+qK6U3NlDdLbYZ5QWeEe30Sc10xJ
 qCs=
X-IronPort-AV: E=Sophos;i="5.81,288,1610434800"; 
   d="scan'208";a="114523151"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 07:13:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 07:13:19 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 29 Mar 2021 07:13:17 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH linux-next v2 0/1] Sparx5 SerDes: Fixed stack frame size warning
Date:   Mon, 29 Mar 2021 16:13:08 +0200
Message-ID: <20210329141309.612459-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

History:
--------

v2:
- Corrected a 10g lane reset signal.

v1:
- The SerDes driver changes its table based register operations into direct
  register operations to avoid the large stack footprint reported by a
  kernel robot.
- The 25g reset operation was changed slightly to make it equivalent to the
  20g reset operation.

Steen Hegelund (1):
  phy: Sparx5 Eth SerDes: Use direct register operations

 drivers/phy/microchip/sparx5_serdes.c | 1869 +++++++++++++------------
 1 file changed, 951 insertions(+), 918 deletions(-)

-- 
2.31.1

