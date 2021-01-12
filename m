Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1F2F3173
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbhALNVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:21:23 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:34460 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbhALNVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 08:21:23 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10CDKMWC0013545, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10CDKMWC0013545
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 21:20:22 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 21:20:22 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Tue, 12 Jan 2021 21:20:22 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "abaci-bugfix@linux.alibaba.com" <abaci-bugfix@linux.alibaba.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8821ae: style: Simplify bool comparison
Thread-Topic: [PATCH] rtlwifi: rtl8821ae: style: Simplify bool comparison
Thread-Index: AQHW6L2orBBpKoBBgkeYxkTWwRIaRaojc5qA
Date:   Tue, 12 Jan 2021 13:20:21 +0000
Message-ID: <1610457587.2793.2.camel@realtek.com>
References: <1610440409-73330-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610440409-73330-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [125.224.66.71]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6A38BB325AB144790D7DFD15CA130C6@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTEyIGF0IDE2OjMzICswODAwLCBZQU5HIExJIHdyb3RlOg0KPiBGaXgg
dGhlIGZvbGxvd2luZyBjb2NjaWNoZWNrIHdhcm5pbmc6DQo+IC4vZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGx3aWZpL3J0bDg4MjFhZS9waHkuYzozODUzOjctMTc6DQo+IFdBUk5JTkc6
IENvbXBhcmlzb24gb2YgMC8xIHRvIGJvb2wgdmFyaWFibGUNCj4gDQo+IFJlcG9ydGVkLWJ5OiBB
YmFjaSBSb2JvdCA8YWJhY2lAbGludXguYWxpYmFiYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlB
TkcgTEkgPGFiYWNpLWJ1Z2ZpeEBsaW51eC5hbGliYWJhLmNvbT4NCj4gDQoNCkkgdGhpbmsgeW91
ciBuYW1lIG9mIFNpZ25lZC1vZmYtYnkgc2hvdWxkIGJlICJZYW5nIExpIi4NCg0KQW5kLCB0aGUg
c3ViamVjdCBwcmVmaXggInJ0bHdpZmk6ICIgaXMgcHJlZmVycmVkLg0KDQotLS0NClBpbmctS2UN
Cg==
