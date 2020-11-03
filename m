Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10A12A4095
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKCJrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:47:17 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38577 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgKCJrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:47:12 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A39kwVbB013830, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A39kwVbB013830
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 3 Nov 2020 17:46:58 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMB04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 3 Nov 2020
 17:46:58 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <oliver@neukum.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 0/2] drivers/net/usb: support ECM mode for RTL8153
Date:   Tue, 3 Nov 2020 17:46:36 +0800
Message-ID: <1394712342-15778-389-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-387-Taiwan-albertk@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
Move original patch to #2. And add a new patch #1 to consolidate vendor ID
of USB devices.

v2:
Add include/linux/usb/r8152.h to avoid the warning about
no previous prototype for rtl8152_get_version.

Hayes Wang (2):
  include/linux/usb: new header file for the vendor ID of USB devices
  net/usb/r8153_ecm: support ECM mode for RTL8153

 drivers/net/usb/Makefile          |   2 +-
 drivers/net/usb/cdc_ether.c       |  93 +++++++----------
 drivers/net/usb/r8152.c           |  68 +++++--------
 drivers/net/usb/r8153_ecm.c       | 162 ++++++++++++++++++++++++++++++
 include/linux/usb/r8152.h         |  30 ++++++
 include/linux/usb/usb_vendor_id.h |  51 ++++++++++
 6 files changed, 306 insertions(+), 100 deletions(-)
 create mode 100644 drivers/net/usb/r8153_ecm.c
 create mode 100644 include/linux/usb/r8152.h
 create mode 100644 include/linux/usb/usb_vendor_id.h

-- 
2.26.2

