Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B762A9085
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgKFHkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:40:07 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:33275 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFHkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:40:06 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A67dxXoB015419, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A67dxXoB015419
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 6 Nov 2020 15:39:59 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 6 Nov 2020 15:39:59 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 6 Nov 2020 15:39:59 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Fri, 6 Nov 2020 15:39:59 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Thread-Topic: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Thread-Index: AQHWshawQtN/T3fh9kiJgjvtG4xSCKm2a3wAgACIZwCAAC/9AIAAG2OAgAAC9ICAAAcNgIAAAsSAgAARvwCAAWswAIAAEW8AgAGRtDD//7jZgIAAkFAA
Date:   Fri, 6 Nov 2020 07:39:59 +0000
Message-ID: <96fee294b4ec41e6a389836cff3513fc@realtek.com>
References: <20201103192226.2455-4-kabel@kernel.org>
        <20201103214712.dzwpkj6d5val6536@skbuf> <20201104065524.36a85743@kernel.org>
        <20201104084710.wr3eq4orjspwqvss@skbuf> <20201104112511.78643f6e@kernel.org>
        <20201104113545.0428f3fe@kernel.org>    <20201104110059.whkku3zlck6spnzj@skbuf>
        <20201104121053.44fae8c7@kernel.org>    <20201104121424.th4v6b3ucjhro5d3@skbuf>
        <20201105105418.555d6e54@kernel.org>    <20201105105642.pgdxxlytpindj5fq@skbuf>
        <21f6ca0a96d640558633d6296b81271a@realtek.com>
 <20201106073947.6328280d@kernel.org>
In-Reply-To: <20201106073947.6328280d@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIE5vdmVtYmVy
IDYsIDIwMjAgMjo0MCBQTQ0KWy4uLl0NCj4gSGkgSGF5ZXMsDQo+IA0KPiBqdXN0IHRvIGJlIGNs
ZWFyOg0KPiBBcmUgeW91IGFnYWluc3QgZGVmaW5pbmcgdGhlc2UgZnVuY3Rpb25zIHZpYSBtYWNy
b3M/DQo+IElmIHNvLCBJIGNhbiBzaW1wbHkgcmV3cml0ZSB0aGlzIHNvIHRoYXQgaXQgZG9lcyBu
b3QgdXNlIG1hY3Jvcy4uLg0KDQpJIHdvdWxkIGxpa2UgdGhlIHdheSB3aGljaCBsZXQgbWUgZmlu
ZCB0aGUgc291cmNlIG9mIHRoZQ0KZnVuY3Rpb24gZWFzaWx5LiBJIGRvbid0IGxpa2UgdGhhdCBJ
IGNvdWxkbid0IGZpbmQgd2hlcmUgdGhlc2UNCmZ1bmN0aW9ucyBhcmUgZGVmaW5lZCwgd2hlbiBJ
IHNlYXJjaCB3aG9sZSB0aGUgc291cmNlIGNvZGUuDQoNCkZvciBleGFtcGxlLCBmb3IgdGhlIG1l
dGhvZCB3aGljaCBWbGFkaW1pciBPbHRlYW4gcHJvdmlkZXMsDQp3aGVuIEkgc2VhcmNoIHRoZSBr
ZXl3b3JkICJwbGFfb2NwX3JlYWRfYnl0ZSIsIEkgY291bGQgZWFzaWx5DQpmaW5kIG91dCB0aGF0
IHRoZSBzb3VyY2UgZnVuY3Rpb24gaXMgIm9jcF9yZWFkX2J5dGUiLg0KSG93ZXZlciwgZm9yIHlv
dXIgcGF0Y2gsIEkgY291bGQgb25seSBmaW5kIHdoZXJlIHRoZSBmdW5jdGlvbg0KaXMgdXNlZC4g
SSB0aGluayBpdCBpcyBub3QgZnJpZW5kbHkgZm9yIHRoZSBuZXdiaWUgd2hvIGlzIG5vdA0KZmFt
aWxpYXIgd2l0aCB0aGlzIGRyaXZlci4NCg0KSG93ZXZlciwgSSBkb24ndCB0aGluayBJIGFtIHRo
ZSBkZWNpc2lvbiBtYWtlci4gVGhpcyBpcw0KanVzdCBteSB2aWV3Lg0KDQo+IE9yIGFyZSB5b3Ug
YWdhaW5zdCBpbXBsZW1lbnRpbmcgdGhlc2UgZnVuY3Rpb25zIHRoZW1zZWx2ZXM/DQoNCk5vLg0K
DQo+IA0KPiBCVFcsIHdoYXQgYWJvdXQgcGF0Y2ggNS81IHdoaWNoIGludHJvZHVjZXMgKl9tb2Rp
ZnkgaGVscGVycz8NCg0KSXQgaXMgZmluZS4NCg0KQmVzdCBSZWdhcmRzLA0KSGF5ZXMNCg0KDQo=
