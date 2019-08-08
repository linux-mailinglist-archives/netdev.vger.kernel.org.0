Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1177857E6
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 04:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbfHHCAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 22:00:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60109 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730467AbfHHCAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 22:00:40 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7820U8Z007872, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7820U8Z007872
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 8 Aug 2019 10:00:30 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 8 Aug 2019
 10:00:26 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] r8169: allocate rx buffers using alloc_pages_node
Thread-Topic: [PATCH net-next] r8169: allocate rx buffers using
 alloc_pages_node
Thread-Index: AQHVTVezvN6Xl1m4kESyrcWoZBclFabwfEbA
Date:   Thu, 8 Aug 2019 02:00:26 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D09D3@RTITMBSVM03.realtek.com.tw>
References: <7d79d794-b41c-101f-0720-59eea88bf9ab@gmail.com>
In-Reply-To: <7d79d794-b41c-101f-0720-59eea88bf9ab@gmail.com>
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

PiBGcm9tOiBIZWluZXIgS2FsbHdlaXQgW21haWx0bzpoa2FsbHdlaXQxQGdtYWlsLmNvbV0NCj4g
U2VudDogVGh1cnNkYXksIEF1Z3VzdCAwOCwgMjAxOSAzOjM4IEFNDQo+IFRvOiBuaWNfc3dzZDsg
RGF2aWQgTWlsbGVyDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQ
QVRDSCBuZXQtbmV4dF0gcjgxNjk6IGFsbG9jYXRlIHJ4IGJ1ZmZlcnMgdXNpbmcgYWxsb2NfcGFn
ZXNfbm9kZQ0KPiANCj4gV2UgYWxsb2NhdGUgMTZrYiBwZXIgcnggYnVmZmVyLCBzbyB3ZSBjYW4g
YXZvaWQgc29tZSBvdmVyaGVhZCBieSB1c2luZw0KPiBhbGxvY19wYWdlc19ub2RlIGRpcmVjdGx5
IGluc3RlYWQgb2YgYm90aGVyaW5nIGttYWxsb2Nfbm9kZS4gRHVlIHRvDQo+IHRoaXMgY2hhbmdl
IGJ1ZmZlcnMgYXJlIHBhZ2UtYWxpZ25lZCBub3csIHRoZXJlZm9yZSB0aGUgYWxpZ25tZW50IGNo
ZWNrDQo+IGNhbiBiZSByZW1vdmVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGVpbmVyIEthbGx3
ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IEhheWVzIFdhbmcgPGhheWVz
d2FuZ0ByZWFsdGVrLmNvbT4NCg0K
