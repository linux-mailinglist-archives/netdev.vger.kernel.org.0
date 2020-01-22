Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4A14496C
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 02:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAVBlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 20:41:53 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56774 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgAVBlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 20:41:53 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00M1fjj8019815, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00M1fjj8019815
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 22 Jan 2020 09:41:47 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV02.realtek.com.tw
 (172.21.6.19) with Microsoft SMTP Server id 14.3.468.0; Wed, 22 Jan 2020
 09:41:43 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v2 0/9] r8152: serial fixes
Date:   Wed, 22 Jan 2020 09:41:12 +0800
Message-ID: <1394712342-15778-348-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-338-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
For patch #2, move declaring the variable "ocp_data".

v1:
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

