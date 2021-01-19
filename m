Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F352FAEEB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 03:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394590AbhASCzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 21:55:46 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:58610 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387973AbhASCzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 21:55:43 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10J2ndZfB028686, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs02.realtek.com.tw[172.21.6.95])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10J2ndZfB028686
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 10:49:40 +0800
Received: from RTEXMB06.realtek.com.tw (172.21.6.99) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 19 Jan 2021 10:49:39 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 19 Jan 2021 10:49:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Tue, 19 Jan 2021 10:49:39 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "abaci-bugfix@linux.alibaba.com" <abaci-bugfix@linux.alibaba.com>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chiu@endlessos.org" <chiu@endlessos.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi/rtl8192se: Simplify bool comparison.
Thread-Topic: [PATCH] rtlwifi/rtl8192se: Simplify bool comparison.
Thread-Index: AQHW6yYrXCXV5MKbPkiauKRwxxOMyaotvt4A
Date:   Tue, 19 Jan 2021 02:49:39 +0000
Message-ID: <1611024540.7826.1.camel@realtek.com>
References: <1610705211-22865-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610705211-22865-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F522E4DD82B3AC4FA1FB9B384752CE80@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAxLTE1IGF0IDEwOjA2ICswMDAwLCBKaWFwZW5nIFpob25nIHdyb3RlOg0K
PiBGaXggdGhlIGZvbGxvdyBjb2NjaWNoZWNrIHdhcm5pbmdzOg0KPiANCj4gLi9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL2h3LmM6MjMwNTo2LTI3Og0KPiBX
QVJOSU5HOiBDb21wYXJpc29uIG9mIDAvMSB0byBib29sIHZhcmlhYmxlLg0KPiANCj4gLi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL2h3LmM6MTM3Njo1LTI2
Og0KPiBXQVJOSU5HOiBDb21wYXJpc29uIG9mIDAvMSB0byBib29sIHZhcmlhYmxlLg0KPiANCj4g
UmVwb3J0ZWQtYnk6IEFiYWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGliYWJhLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogSmlhcGVuZyBaaG9uZyA8YWJhY2ktYnVnZml4QGxpbnV4LmFsaWJhYmEuY29t
Pg0KPiANCg0KW3NuaXBdDQoNClRoZSBzdWJqZWN0IHNob3VsZCBiZSAicnRsd2lmaTogcnRsODE5
MnNlOiBTaW1wbGlmeSBib29sIGNvbXBhcmlzb24iLg0KKE5vIHBlcmlvZCBhdCB0aGUgZW5kIG9m
IHN1YmplY3QpDQoNCk90aGVycyBsb29rIGdvb2QgdG8gbWUuDQoNCi0tLQ0KUGluZy1LZQ0KDQo=
