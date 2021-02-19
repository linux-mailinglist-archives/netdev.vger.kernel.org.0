Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A629631F649
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhBSJJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:09:20 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44427 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhBSJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:06:07 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11J95BBF0013696, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11J95BBF0013696
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Feb 2021 17:05:11 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Feb
 2021 17:05:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/4] r8152: minor adjustments
Date:   Fri, 19 Feb 2021 17:04:39 +0800
Message-ID: <1394712342-15778-341-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are used to adjust the code.

Hayes Wang (4):
  r8152: enable U1/U2 for USB_SPEED_SUPER
  r8152: check if the pointer of the function exists
  r8152: replace netif_err with dev_err
  r8152: spilt rtl_set_eee_plus and r8153b_green_en

 drivers/net/usb/r8152.c | 67 ++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 21 deletions(-)

-- 
2.26.2

