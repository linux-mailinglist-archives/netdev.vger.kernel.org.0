Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF40123CBCC
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 17:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHEPqC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Aug 2020 11:46:02 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39831 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHEPmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 11:42:19 -0400
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 075BIxjF6020272, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 075BIxjF6020272
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 5 Aug 2020 19:18:59 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 5 Aug 2020 19:18:59 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 5 Aug 2020 19:18:59 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Wed, 5 Aug 2020 19:18:58 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH] rtw88: 8821c: Add RFE 2 support
Thread-Topic: [PATCH] rtw88: 8821c: Add RFE 2 support
Thread-Index: AQHWawTgrZXV5FXpY0mfKjdCxZOrO6kpXYpw
Date:   Wed, 5 Aug 2020 11:18:58 +0000
Message-ID: <c0c336d806584361992d4b52665fbb82@realtek.com>
References: <20200805084559.30092-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200805084559.30092-1-kai.heng.feng@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 8821CE with RFE 2 isn't supported:
> [   12.404834] rtw_8821ce 0000:02:00.0: rfe 2 isn't supported
> [   12.404937] rtw_8821ce 0000:02:00.0: failed to setup chip efuse info
> [   12.404939] rtw_8821ce 0000:02:00.0: failed to setup chip information
> 

NACK

The RFE type 2 should be working with some additional fixes.
Did you tested connecting to AP with BT paired?

The antenna configuration is different with RFE type 0.
I will ask someone else to fix them.
Then the RFE type 2 modules can be supported.

Yen-Hsuan
