Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0012AA6192
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfICGhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:37:00 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58251 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfICGhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:37:00 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x836au8R018439, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x836au8R018439
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 3 Sep 2019 14:36:56 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Tue, 3 Sep 2019 14:36:54 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: modify rtl8152_set_speed function
Thread-Topic: [PATCH net-next] r8152: modify rtl8152_set_speed function
Thread-Index: AQHVYYTrRMaVJv63vEGfeZKbVbiDuqcYMZIAgAEQO0D//7KEAIAAiqfA
Date:   Tue, 3 Sep 2019 06:36:53 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18DACE1@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
 <280e6a3d-c6c3-ef32-a65d-19566190a1d3@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAB41@RTITMBSVM03.realtek.com.tw>
 <aa9513ff-3cef-4b9f-ecbd-1310660a911c@gmail.com>
In-Reply-To: <aa9513ff-3cef-4b9f-ecbd-1310660a911c@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVpbmVyIEthbGx3ZWl0IFttYWlsdG86aGthbGx3ZWl0MUBnbWFpbC5jb21dDQo+IFNlbnQ6IFR1
ZXNkYXksIFNlcHRlbWJlciAwMywgMjAxOSAyOjE0IFBNDQpbLi4uXQ0KPiA+PiBTZWVpbmcgYWxs
IHRoaXMgY29kZSBpdCBtaWdodCBiZSBhIGdvb2QgaWRlYSB0byBzd2l0Y2ggdGhpcyBkcml2ZXIN
Cj4gPj4gdG8gcGh5bGliLCBzaW1pbGFyIHRvIHdoYXQgSSBkaWQgd2l0aCByODE2OSBzb21lIHRp
bWUgYWdvLg0KPiA+DQo+ID4gSXQgaXMgdG9vIGNvbXBsZXggdG8gYmUgY29tcGxldGVkIGZvciBt
ZSBhdCB0aGUgbW9tZW50Lg0KPiA+IElmIHRoaXMgcGF0Y2ggaXMgdW5hY2NlcHRhYmxlLCBJIHdv
dWxkIHN1Ym1pdCBvdGhlcg0KPiA+IHBhdGNoZXMgZmlyc3QuIFRoYW5rcy4NCj4gPg0KPiBNeSBy
ZW1hcmsgaXNuJ3QgZGlyZWN0bHkgcmVsYXRlZCB0byB5b3VyIHBhdGNoIGFuZCB3YXNuJ3QNCj4g
bWVhbnQgYXMgYW4gaW1tZWRpYXRlIFRvRG8uIEl0J3MganVzdCBhIGhpbnQsIGJlY2F1c2UgSSB0
aGluaw0KPiB1c2luZyBwaHlsaWIgY291bGQgaGVscCB0byBzaWduaWZpY2FudGx5IHNpbXBsaWZ5
IHRoZSBkcml2ZXIuDQoNCkkgd291bGQgc2NoZWR1bGUgdGhpcyBpbiBteSB3b3JrLiBNYXliZSBJ
IGZpbmlzaCBzdWJtaXR0aW5nDQp0aGUgb3RoZXIgcGF0Y2hlcyBsYXRlci4NCg0KQmVzaWRlcywg
SSBoYXZlIGEgcXVlc3Rpb24uIEkgdGhpbmsgSSBkb24ndCBuZWVkIHJ0bDgxNTJfc2V0X3NwZWVk
KCkNCmlmIEkgaW1wbGVtZW50IHBoeWxpYi4gSG93ZXZlciwgSSBuZWVkIHRvIHJlY29yZCBzb21l
IGluZm9ybWF0aW9uDQphY2NvcmRpbmcgdG8gdGhlIHNldHRpbmdzIG9mIHNwZWVkLiBGb3Igbm93
LCBJIGRvIGl0IGluIHJ0bDgxNTJfc2V0X3NwZWVkKCkuDQpEbyB5b3UgaGF2ZSBhbnkgaWRlYSBh
Ym91dCBob3cgSSBzaG91bGQgZG8gaXQgd2l0aCBwaHlsaWIgd2l0aG91dA0KcnRsODE1Ml9zZXRf
c3BlZWQoKT8NCg0KQmVzdCBSZWdhcmRzLA0KSGF5ZXMNCg0KDQo=
