Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1B74611E6
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhK2KSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:18:54 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38094 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhK2KQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:16:53 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1ATADXGW0027590, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1ATADXGW0027590
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Nov 2021 18:13:33 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 18:13:33 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 29 Nov
 2021 18:13:33 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [RFC PATCH 0/4] r8169: support dash
Date:   Mon, 29 Nov 2021 18:13:11 +0800
Message-ID: <20211129101315.16372-381-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/29/2021 10:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzExLzI5IKRXpMggMDg6MjY6MDA=?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are used to support dash for RTL8111EP and
RTL8111FP(RTL81117).

Hayes Wang (4):
  r8169: remove the relative code about dash
  r8169: add type2 access functions
  r8169: support CMAC
  r8169: add sysfs for dash

 drivers/net/ethernet/realtek/Makefile     |   2 +-
 drivers/net/ethernet/realtek/r8169.h      |   5 +
 drivers/net/ethernet/realtek/r8169_dash.c | 887 ++++++++++++++++++++++
 drivers/net/ethernet/realtek/r8169_dash.h |  30 +
 drivers/net/ethernet/realtek/r8169_main.c | 349 +++++++--
 5 files changed, 1196 insertions(+), 77 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169_dash.c
 create mode 100644 drivers/net/ethernet/realtek/r8169_dash.h

-- 
2.31.1

