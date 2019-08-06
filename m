Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA883089
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbfHFLSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:18:55 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57484 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfHFLSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 07:18:55 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x76BIqIG023709, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x76BIqIG023709
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 6 Aug 2019 19:18:52 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.439.0; Tue, 6 Aug 2019
 19:18:50 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/5] RX improve
Date:   Tue, 6 Aug 2019 19:17:59 +0800
Message-ID: <1394712342-15778-289-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The different chips use different rx buffer size.

Use skb_add_rx_frag() to reduce memory copy for RX.

Hayes Wang (5):
  r8152: separate the rx buffer size
  r8152: replace array with linking list for rx information
  r8152: use alloc_pages for rx buffer
  r8152: support skb_add_rx_frag
  r8152: change rx_frag_head_sz and rx_max_agg_num dynamically

 drivers/net/usb/r8152.c | 415 +++++++++++++++++++++++++++++++++-------
 1 file changed, 346 insertions(+), 69 deletions(-)

-- 
2.21.0

