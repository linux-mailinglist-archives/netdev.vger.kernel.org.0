Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C562CEE1E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgLDMfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:35:41 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5291 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgLDMfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085341; x=1638621341;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ooxPzxrzwJw3JgGledQM6x16vHXhUYhY2vlKUJL6gCk=;
  b=n2tVazx27HzeiqKlRf3sM0HkabNGKGM0kTSXALNy5W7WYqTbJO613lL6
   8RqYyzKdDaf7MEtmdU52TOjyZ9MgwvE94UpQyslHzswRBbJLbPupsKqji
   iHneUNC7YQ6yitYBNIHx3N/tDX6/sThsg4/wfOt415ji38fbpu1UJpxnF
   SYCZKmEW0th8LH1im1W+l82Bwj1MsHMd7k6MzrXRdWkqKFvMtHWdax+yY
   2wvDpLn3kVxFZ0d7M61CvUxhVerFziznVZl+14m0oLx4cp5Aen8Y0ypzA
   nEQCJINbTv9Q506+VUvJGTpUc6mY5JQwMFn1xdyVY6MddHgLrF/rJbNLb
   Q==;
IronPort-SDR: 57QSs6qZ726gYyaXo9KxbpR4x9GrQ93MizO4GCVFjdkN6YFGjOZ4V8dDigRo/cf1Zw6ZslNPix
 iS0usEXSoGLVIFq9KgdE1lI+Cza+W8TRoXqMEtl8VcKg6JYo7C3HFUg2NOPyhcFsrH6KdAdL/f
 6EN4nqCoMjFFRQsksbi0r8MuPkPwrOSaKL0i72titbTwGxxgQKU5nZBol+18O6keRcvJZqC0Fa
 rTKa4fxlAJBT7btlnk3JVBWx7P9lAWBK7Sxn+zR1Moxu9uFP3pryS2SwzxfmV2Mk6EZlLOEmoU
 zzI=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="36119956"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:34:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:34:35 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:34:29 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 0/7] net: macb: add support for sama7g5
Date:   Fri, 4 Dec 2020 14:34:14 +0200
Message-ID: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for SAMA7G5 Ethernet interfaces: one 10/100Mbps
and one 1Gbps interfaces.

Along with it I also included a fix to disable clocks for SiFive FU540-C000
on failure path of fu540_c000_clk_init().

Thank you,
Claudiu Beznea

Claudiu Beznea (7):
  net: macb: add userio bits as platform configuration
  net: macb: add capability to not set the clock rate
  net: macb: unprepare clocks in case of failure
  dt-bindings: add documentation for sama7g5 ethernet interface
  dt-bindings: add documentation for sama7g5 gigabit ethernet interface
  net: macb: add support for sama7g5 gem interface
  net: macb: add support for sama7g5 emac interface

 Documentation/devicetree/bindings/net/macb.txt |  2 +
 drivers/net/ethernet/cadence/macb.h            | 11 +++
 drivers/net/ethernet/cadence/macb_main.c       | 99 +++++++++++++++++++++-----
 3 files changed, 93 insertions(+), 19 deletions(-)

-- 
2.7.4

