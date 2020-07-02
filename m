Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360B7211F68
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgGBJGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:06:07 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:48754 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGBJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593680767; x=1625216767;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=dGrx4fAdrMUi1KyKIgge8+65AtfehWqMrbKx0UNoWHk=;
  b=iTZ7fvd14IP2ki1kdaLMPwt49J7T/BTBTu9VVXDl6tONUJdUgkd2kLqg
   aoFSzHjqjcLeuo6Y7loQqK+/C0Fo5nsKhB5srxFX3Z0eoXr7XAbaBYV3T
   iH7PBEDr7xmhdk5Kh++FvtMAQvoKO3OLvCpS8G+TP+6iBnDgP/uIz+nKG
   tQxWQSwr3wA1xpyqZTyTpxfueZmCRxpDV7fQk+vaIat0F8d7HL10H/vuD
   59gOSS0m4msyW6/QxfbWHN4x64OD79bLKJvp7ZikBjhMOMMT2frvWEVQx
   4nBKBS0KulLNOZT4oYtoDxAEcHHCFjniwQfwemDwuGlmFyEbmh0Q54Svu
   w==;
IronPort-SDR: uBCzZCdCFInyK0fpYKjNdavtNqHcJi3jIiAYz70uRI4XoQtyGO5CuX80d//OTHzTY2OFGHrpVd
 ZAcZOcYA8dK8bdcHNcC8iYmvsfI8luKbTAvXf10T2RkK9F/uia6AWvcrDoXOcQLBXwnjPvBDTI
 vpT5EyLoIMnTOl6gXYMPGNbUTKIoeFR9NzyeU6JSavyewj79ZCIFunzVtp5uiYsp8pUT33tTPK
 AtlU0FKFmQGkAYYvM9LN1HzZRcdnmjvm4p1satxA0XCofSXmpzv4YLrgLTEnBaMKj6BXr+v5dt
 BYQ=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="81642855"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:06:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:06:05 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:06:03 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next v2 0/4] net: macb: few code cleanups
Date:   Thu, 2 Jul 2020 12:05:57 +0300
Message-ID: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Patches in this series cleanup a bit macb code.

Thank you,
Claudiu Beznea

Changes in v2:
- in patch 2/4 use hweight32() instead of hweight_long() 

Claudiu Beznea (4):
  net: macb: do not set again bit 0 of queue_mask
  net: macb: use hweight32() to count set bits in queue_mask
  net: macb: do not initialize queue variable
  net: macb: remove is_udp variable

 drivers/net/ethernet/cadence/macb_main.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

-- 
2.7.4

