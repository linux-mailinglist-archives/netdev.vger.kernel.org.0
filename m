Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A459A88E
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 09:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392848AbfHWHT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 03:19:29 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:33174 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392504AbfHWHT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 03:19:27 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7N7JPKs022545, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7N7JPKs022545
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 23 Aug 2019 15:19:25 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Fri, 23 Aug 2019
 15:19:23 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 0/2] r8152: save EEE
Date:   Fri, 23 Aug 2019 15:18:59 +0800
Message-ID: <1394712342-15778-308-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-304-Taiwan-albertk@realtek.com>
References: <1394712342-15778-304-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
For patch #2, fix the mistake caused by copying and pasting.

v2:
Adjust patch #1. The EEE has been disabled in the beginning of
r8153_hw_phy_cfg() and r8153b_hw_phy_cfg(), so only check if
it is necessary to enable EEE.

Add the patch #2 for the helper function.

v1:
Saving the settings of EEE to avoid they become the default settings
after reset_resume().

Hayes Wang (2):
  r8152: saving the settings of EEE
  r8152: add a helper function about setting EEE

 drivers/net/usb/r8152.c | 182 +++++++++++++++++++++-------------------
 1 file changed, 95 insertions(+), 87 deletions(-)

-- 
2.21.0

