Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1817215417
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgGFIjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:39:53 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:4534 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgGFIjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594024792; x=1625560792;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9RQN94AHwadnzZU73hAipP81vVYY9uaH9A7EGlwCSio=;
  b=SMSswyP2ynyl/xyV0rJPTFNg8v6wt9+eF+8WlOtBNXErmJ/nFTC6MwYM
   OFaCQyEhVhy28jpk6Rv+ZPcKLUKjF08dw7yxSCZC451m9dNDfkCJYObbK
   1U1kx1lHPm5dKx6I+DzUnhiAh0oBNAIizJm2/LimO6Z+MUApfYj8blEiQ
   CCip+hbe1CHMXV6k4tmo1iNr7WhMz3TPun4sXHPTmhqk3ObQ9cRemUVE5
   DZ1oii6kHtj1iAPSZ72Gh/N9OWlkOWAwXWS3U3n/MFxoq8JzxNt3Ks/wY
   n0YJ9/OcXQ/vWPrhgY7XLZTzIwC+QwO9k9AoaFUY+etvDdF3Cd0okIorM
   Q==;
IronPort-SDR: pSjP8rK3LrTWnkQjVqBdd9j0n5dWCH3oebF+7jWE6aSErZAYsPVuj6DskDOIauR7TeQ/gy32xy
 BOlk+sMIdW9wVhoZhDPnfhNt/RAIdlGELdAYqdLi6dgiw+9WL9IvqZFbBDpdIm78MNeAJ7paZV
 S7kXO1gBLuoXWH1vFkNBoxYl8biAiNTclcL64Zx6Qni5umiUiN2jHRouqkn2tRCv5rINeeEFxZ
 4agYh5/yuOvUUOtjCngHj6BY8SEMaFdjP5H59K6vMrRerbgHEebnhvD/BBqp0winqB/iV0b/EQ
 nG4=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="86314530"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 01:39:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 01:39:28 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 6 Jul 2020 01:39:27 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net v2 0/2] smsc95xx: fix smsc95xx_bind
Date:   Mon, 6 Jul 2020 10:39:33 +0200
Message-ID: <20200706083935.19040-1-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset fixes two problems in the function smsc95xx_bind:
 - return of false success
 - memory leak

Changes in v2:
- added "Fixes" tags to both patches

Andre Edich (2):
  smsc95xx: check return value of smsc95xx_reset
  smsc95xx: avoid memory leak in smsc95xx_bind

 drivers/net/usb/smsc95xx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
2.27.0

