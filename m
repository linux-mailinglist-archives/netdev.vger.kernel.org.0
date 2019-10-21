Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E30DE2AB
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfJUDla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:41:30 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58979 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfJUDla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:41:30 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9L3fQBq014766, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9L3fQBq014766
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 11:41:26 +0800
Received: from fc30.localdomain (172.21.177.156) by RTITCAS11.realtek.com.tw
 (172.21.6.12) with Microsoft SMTP Server id 14.3.468.0; Mon, 21 Oct 2019
 11:41:24 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <pmalani@chromium.org>, <grundler@chromium.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/4] r8152: PHY firmware
Date:   Mon, 21 Oct 2019 11:41:09 +0800
Message-ID: <1394712342-15778-330-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.156]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support loading the firmware of the PHY with the type of RTL_FW_PHY_NC.

Hayes Wang (4):
  r8152: rename fw_type_1 with fw_mac
  r8152: add checking fw_offset field of struct fw_mac
  r8152: move r8153_patch_request forward
  r8152: support firmware of PHY NC for RTL8153A

 drivers/net/usb/r8152.c | 428 +++++++++++++++++++++++++++++++++-------
 1 file changed, 357 insertions(+), 71 deletions(-)

-- 
2.21.0

