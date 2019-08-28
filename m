Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714349F807
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 03:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfH1BwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 21:52:09 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58298 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfH1BwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 21:52:09 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7S1q5gY022588, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7S1q5gY022588
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 28 Aug 2019 09:52:06 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 28 Aug 2019
 09:52:04 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v3 0/2] r8152: fix side effect
Date:   Wed, 28 Aug 2019 09:51:40 +0800
Message-ID: <1394712342-15778-320-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-314-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
Update the commit message for patch #1.

v2:
Replace patch #2 with "r8152: remove calling netif_napi_del".

v1:
The commit 0ee1f4734967 ("r8152: napi hangup fix after disconnect")
add a check to avoid using napi_disable after netif_napi_del. However,
the commit ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG only for real
disconnection") let the check useless.

Therefore, I revert commit 0ee1f4734967 ("r8152: napi hangup fix
after disconnect") first, and add another patch to fix it.

Hayes Wang (2):
  Revert "r8152: napi hangup fix after disconnect"
  r8152: remove calling netif_napi_del

 drivers/net/usb/r8152.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

-- 
2.21.0

