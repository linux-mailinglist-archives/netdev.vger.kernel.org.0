Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A409CA62A2
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfICHg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:36:59 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:36343 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfICHg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 03:36:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x837atqU020683, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x837atqU020683
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 3 Sep 2019 15:36:56 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Tue, 3 Sep
 2019 15:36:55 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: modify rtl8152_set_speed function
Thread-Topic: [PATCH net-next] r8152: modify rtl8152_set_speed function
Thread-Index: AQHVYYTrRMaVJv63vEGfeZKbVbiDuqcYMZIAgAEQO0D//7KEAIAAiqfA//9+BQCAAIbSYP//gQCAABEh6DA=
Date:   Tue, 3 Sep 2019 07:36:54 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18DADA1@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
 <280e6a3d-c6c3-ef32-a65d-19566190a1d3@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAB41@RTITMBSVM03.realtek.com.tw>
 <aa9513ff-3cef-4b9f-ecbd-1310660a911c@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DACE1@RTITMBSVM03.realtek.com.tw>
 <56675c6b-c792-245e-54d0-eacd50e7a139@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAD2A@RTITMBSVM03.realtek.com.tw>
 <32d490ae-70af-ba86-93de-be342a2a7e39@gmail.com>
In-Reply-To: <32d490ae-70af-ba86-93de-be342a2a7e39@gmail.com>
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
ZXNkYXksIFNlcHRlbWJlciAwMywgMjAxOSAzOjEzIFBNDQpbLi4uXQ0KPiA+IFNvbWUgb2Ygb3Vy
IGNoaXBzIHN1cHBvcnQgdGhlIGZlYXR1cmUgb2YgVVBTLiBXaGVuIHNhdGlzZnlpbmcgY2VydGFp
bg0KPiA+IGNvbmRpdGlvbiwgdGhlIGh3IHdvdWxkIHJlY292ZXIgdGhlIHNldHRpbmdzIG9mIHNw
ZWVkLiBUaGVyZWZvcmUsIEkgaGF2ZQ0KPiA+IHRvIHJlY29yZCB0aGUgc2V0dGluZ3Mgb2YgdGhl
IHNwZWVkLCBhbmQgc2V0IHRoZW0gdG8gaHcuDQo+ID4NCj4gTm90IGtub3dpbmcgdGhlIFVQUyBm
ZWF0dXJlIGluIGRldGFpbDoNCj4gSW4gbmV0LW5leHQgSSBjaGFuZ2VkIHRoZSBzb2Z0d2FyZSAi
UEhZIHNwZWVkLWRvd24iIGltcGxlbWVudGF0aW9uIHRvDQo+IGJlIG1vcmUgZ2VuZXJpYy4gSXQg
c3RvcmVzIHRoZSBvbGQgYWR2ZXJ0aXNlZCBzZXR0aW5ncyBpbiBhIG5ldw0KPiBwaHlfZGV2aWNl
IG1lbWJlciBhZHZfb2xkLCBhbmQgcmVzdG9yZXMgdGhlbSBpbiBwaHlfc3BlZWRfdXAoKS4NCj4g
TWF5YmUgd2hhdCB5b3UgbmVlZCBpcyBzaW1pbGFyLg0KDQpJdCBpcyBhIGZlYXR1cmUgYWJvdXQg
cG93ZXIgc2F2aW5nLiBXaGVuIHNvbWUgY29uZGl0aW9ucyBhcmUNCnNhdGlzZmllZCwgdGhlIHBv
d2VyIG9mIFBIWSB3b3VsZCBiZSBjdXQuIEFuZCB0aGUgaHcgd291bGQNCnJlc3RvcmUgdGhlIFBI
WSBzZXR0aW5ncyBpbmNsdWRpbmcgdGhlIHNwZWVkIGF1dG9tYXRpY2FsbHksDQp3aGVuIGxlYXZp
bmcgcG93ZXIgc2F2aW5nIG1vZGUuDQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg0K
