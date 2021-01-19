Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5B2FB320
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 08:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbhASHgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 02:36:45 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:57366 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbhASHgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 02:36:36 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10J7ZKrJ4019225, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10J7ZKrJ4019225
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 15:35:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 19 Jan 2021 15:35:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Tue, 19 Jan 2021 15:35:20 +0800
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
Subject: Re: [PATCH v2] rtlwifi: rtl8192se: Simplify bool comparison.
Thread-Topic: [PATCH v2] rtlwifi: rtl8192se: Simplify bool comparison.
Thread-Index: AQHW7izmHuC9KfGQ3U+TQixYySp3yKouCKEA
Date:   Tue, 19 Jan 2021 07:35:19 +0000
Message-ID: <1611041680.9785.1.camel@realtek.com>
References: <1611037955-105333-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611037955-105333-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FF55E670DAFCB488BE4711BC4C7E884@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTE5IGF0IDE0OjMyICswODAwLCBKaWFwZW5nIFpob25nIHdyb3RlOg0K
PiBGaXggdGhlIGZvbGxvdyBjb2NjaWNoZWNrIHdhcm5pbmdzOg0KPiANCj4gLi9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL2h3LmM6MjMwNTo2LTI3Og0KPiBX
QVJOSU5HOiBDb21wYXJpc29uIG9mIDAvMSB0byBib29sIHZhcmlhYmxlLg0KPiANCj4gLi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MnNlL2h3LmM6MTM3Njo1LTI2
Og0KPiBXQVJOSU5HOiBDb21wYXJpc29uIG9mIDAvMSB0byBib29sIHZhcmlhYmxlLg0KPiANCj4g
UmVwb3J0ZWQtYnk6IEFiYWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGliYWJhLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogSmlhcGVuZyBaaG9uZyA8YWJhY2ktYnVnZml4QGxpbnV4LmFsaWJhYmEuY29t
Pg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gwqAgLU1vZGlmaWVkIHN1YmplY3QuDQo+IA0K
DQpZb3UgZm9yZ2V0IHRvIHJlbW92ZSB0aGUgcGVyaW9kIGF0IHRoZSBlbmQgb2Ygc3ViamVjdC4N
CmkuZS4NCiJydGx3aWZpOiBydGw4MTkyc2U6IFNpbXBsaWZ5IGJvb2wgY29tcGFyaXNvbiINCg0K
LS0tDQpQaW5nLUtlDQoNCg==
