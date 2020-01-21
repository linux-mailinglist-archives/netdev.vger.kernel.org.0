Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDB143D2F
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgAUMmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:42:51 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54687 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgAUMmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:42:50 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00LCgjM3010986, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (smtpsrv.realtek.com[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00LCgjM3010986
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 21 Jan 2020 20:42:45 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Tue, 21 Jan 2020
 20:42:43 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 0/9] r8152: serial fixes
Date:   Tue, 21 Jan 2020 20:40:26 +0800
Message-ID: <1394712342-15778-338-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are used to fix some issues for RTL8153.

Hayes Wang (9):
  r8152: fix runtime resume for linking change
  r8152: reset flow control patch when linking on for RTL8153B
  r8152: get default setting of WOL before initializing
  r8152: disable U2P3 for RTL8153B
  r8152: Disable PLA MCU clock speed down
  r8152: disable test IO for RTL8153B
  r8152: don't enable U1U2 with USB_SPEED_HIGH for RTL8153B
  r8152: avoid the MCU to clear the lanwake
  r8152: disable DelayPhyPwrChg

 drivers/net/usb/r8152.c | 124 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 113 insertions(+), 11 deletions(-)

-- 
2.21.0

