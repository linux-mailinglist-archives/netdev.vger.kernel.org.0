Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095A0FA776
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfKMDnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:43:55 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55040 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfKMDny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:43:54 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xAD3hk9N032480, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xAD3hk9N032480
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 13 Nov 2019 11:43:47 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Wed, 13 Nov
 2019 11:43:46 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Lucas Stach <dev@lynxeye.de>, wlanfae <wlanfae@realtek.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: long delays in rtl8723 drivers in irq disabled sections
Thread-Topic: long delays in rtl8723 drivers in irq disabled sections
Thread-Index: AQHVmZ3DU4qY/o9NJ0yDyHj2LmPNT6eIcdBQ
Date:   Wed, 13 Nov 2019 03:43:45 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C9CE47@RTITMBSVM04.realtek.com.tw>
References: <5de65447f1d115f436f764a7ec811c478afbe2e0.camel@lynxeye.de>
In-Reply-To: <5de65447f1d115f436f764a7ec811c478afbe2e0.camel@lynxeye.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LXdpcmVsZXNzLW93
bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXdpcmVsZXNzLW93bmVyQHZnZXIua2Vy
bmVsLm9yZ10gT24gQmVoYWxmDQo+IE9mIEx1Y2FzIFN0YWNoDQo+IFNlbnQ6IFdlZG5lc2RheSwg
Tm92ZW1iZXIgMTMsIDIwMTkgNTowMiBBTQ0KPiBUbzogd2xhbmZhZTsgUGtzaGloDQo+IENjOiBs
aW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogbG9uZyBkZWxheXMgaW4gcnRsODcyMyBkcml2ZXJzIGluIGlycSBkaXNhYmxlZCBz
ZWN0aW9ucw0KPiANCj4gSGkgYWxsLA0KPiANCj4gd2hpbGUgaW52ZXN0aWdhdGluZyBzb21lIGxh
dGVuY3kgaXNzdWVzIG9uIG15IGxhcHRvcCBJIHN0dW1ibGVkIGFjcm9zcw0KPiBxdWl0ZSBsYXJn
ZSBkZWxheXMgaW4gdGhlIHJ0bDg3MjMgUEhZIGNvZGUsIHdoaWNoIGFyZSBkb25lIGluIElSUQ0K
PiBkaXNhYmxlZCBhdG9taWMgc2VjdGlvbnMsIHdoaWNoIGlzIGJsb2NraW5nIElSUSBzZXJ2aWNp
bmcgZm9yIGFsbA0KPiBkZXZpY2VzIGluIHRoZSBzeXN0ZW0uDQo+IA0KPiBTcGVjaWZpY2FsbHkg
dGhlcmUgYXJlIDMgY29uc2VjdXRpdmUgMW1zIGRlbGF5cyBpbg0KPiBydGw4NzIzX3BoeV9yZl9z
ZXJpYWxfcmVhZCgpLCB3aGljaCBpcyB1c2VkIGluIGFuIElSUSBkaXNhYmxlZCBjYWxsDQo+IHBh
dGguIFNhZGx5IHRob3NlIGRlbGF5cyBkb24ndCBoYXZlIGFueSBjb21tZW50IGluIHRoZSBjb2Rl
IGV4cGxhaW5pbmcNCj4gd2h5IHRoZXkgYXJlIG5lZWRlZC4gSSBob3BlIHRoYXQgYW55b25lIGNh
biB0ZWxsIGlmIHRob3NlIGRlbGF5cyBhcmUNCj4gc3RyaWN0bHkgbmVjY2Vzc2FyeSBhbmQgaWYg
c28gaWYgdGhleSByZWFsbHkgbmVlZCB0byBiZSB0aGlzIGxvbmcuDQo+IA0KDQpUaGVzZSBkZWxh
eXMgYXJlIGJlY2F1c2UgcmVhZCBSRiByZWdpc3RlciBpcyBhbiBpbmRpcmVjdCBhY2Nlc3MgdGhh
dCBoYXJkd2FyZQ0KbmVlZHMgdGltZSB0byBhY2NvbXBsaXNoIHJlYWQgYWN0aW9uLCBidXQgdGhl
cmUncyBubyByZWFkeSBiaXQsIHNvIGRlbGF5DQppcyByZXF1aXJlZCB0byBndWFyYW50ZWUgdGhl
IHJlYWQgdmFsdWUgaXMgY29ycmVjdC4gSXQgaXMgcG9zc2libGUgdG8NCnVzZSBzbWFsbGVyIGRl
bGF5LCBidXQgaXQncyBleGFjdGx5IHJlcXVpcmVkLg0KDQpBbiBhbHRlcm5hdGl2ZSB3YXkgaXMg
dG8gcHJldmVudCBjYWxsaW5nIHRoaXMgZnVuY3Rpb24gaW4gSVJRIGRpc2FibGVkIGZsb3cuDQpD
b3VsZCB5b3Ugc2hhcmUgdGhlIGNhbGxpbmcgdHJhY2U/DQoNClRoYW5rcw0KUEsNCg0K
