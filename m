Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73764213AE8
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGCNZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:25:16 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11749 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCNZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 09:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593782716; x=1625318716;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vjGJax1Jbcfrp15KAGui9C91mzzcTml4WKMjYMqEVDA=;
  b=1yfgAAvVcNqbhtTeqi8RDczHEWmuslXAXmy1ndCtWBT2iBWoI+G3KND1
   3V390qXFzhlOFb5ftk9jhK1VHL0zdk74v8yBfUd0HRsmrp1JmMtCjuQVo
   CLslnjLsR3Ev+olhRTFrI6BZh0ESvjHkE2VXeO4Td8kWIg1SGfErgwthn
   OtSSU0rbvVEHMatcKyUWLkl8IXwE+ICs06N14yXbUEr3m/6zZVeymgl4p
   /+uB86Xo7NgfOLjejM8FBYs6CzMNd181fTpGt42x4Rgze2pKSA+c0Bwu2
   CRwa/hm7ZQjJUWllriJnCZBk4MgCBAlu0qJhG6kbJe4uB+9Oaovl+Co+a
   A==;
IronPort-SDR: wANyGcDCuuijXpkSrYP7ehFvEfos7L8Pv4siNXO87F5L14KG4l67s9C6n4+8P9brozJ4TTt3Fs
 Cimf5D+KkGmTAUwtGg6MnEw44hFGcV8NqCl1UgR0zV9+DiV75twXZ7N4ctaq/GK4qfbwVvKbsX
 1Tcqjj0u4Gca1NQt+ISR8n1DzjGrL1R4XsIsK4DZD09M/DMeOjHtoJsbcl5fFrImzRndrK6mU7
 xn23or39UmMv3K5QR+p/GfBBCJjdzhOCTsSTIxbwHMgvX/HGh8ayGahit74SRbhJv3zC+NLE80
 lDQ=
X-IronPort-AV: E=Sophos;i="5.75,308,1589266800"; 
   d="scan'208";a="82524435"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jul 2020 06:25:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 3 Jul 2020 06:24:55 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 3 Jul 2020 06:25:14 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net 0/2] smsc95xx: fix smsc95xx_bind
Date:   Fri, 3 Jul 2020 15:25:04 +0200
Message-ID: <20200703132506.12359-1-andre.edich@microchip.com>
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

Andre Edich (2):
  smsc95xx: check return value of smsc95xx_reset
  smsc95xx: avoid memory leak in smsc95xx_bind

 drivers/net/usb/smsc95xx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
2.27.0

