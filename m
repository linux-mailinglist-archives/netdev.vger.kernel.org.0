Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E5232993
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 03:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgG3Bcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 21:32:53 -0400
Received: from mx22.baidu.com ([220.181.50.185]:42512 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgG3Bcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 21:32:53 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2020 21:32:46 EDT
Received: from BC-Mail-Ex32.internal.baidu.com (unknown [172.31.51.26])
        by Forcepoint Email with ESMTPS id 9DCB7B9FE8469D43DD76;
        Thu, 30 Jul 2020 09:17:34 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex32.internal.baidu.com (172.31.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Thu, 30 Jul 2020 09:17:33 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Thu, 30 Jul 2020 09:15:08 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: =?gb2312?B?tPC4tDogW25ldC1uZXh0IDIvNl0gaTQwZTogcHJlZmV0Y2ggc3RydWN0IHBh?=
 =?gb2312?Q?ge_of_Rx_buffer_conditionally?=
Thread-Topic: [net-next 2/6] i40e: prefetch struct page of Rx buffer
 conditionally
Thread-Index: AQHWZRKIaFSgdN4Dc0O7wcJ77z58xakc5xyAgAEtH/CAAHePgIAAx6LA
Date:   Thu, 30 Jul 2020 01:15:08 +0000
Message-ID: <3ce338590eb04600bdac519ddbdd1a3a@baidu.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
        <20200728190842.1284145-3-anthony.l.nguyen@intel.com>
        <20200728131423.2430b3f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8e1471fdcaed4f46825cd8ff112a8c36@baidu.com>
 <20200729142003.7fe30d67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200729142003.7fe30d67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.48]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex32_2020-07-30 09:17:33:842
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogSmFrdWIgS2ljaW5za2kgW21haWx0
bzprdWJhQGtlcm5lbC5vcmddDQo+ILeiy83KsbzkOiAyMDIwxOo31MIzMMjVIDU6MjANCj4gytW8
/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ILOty806IFRvbnkgTmd1
eWVuIDxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IG5ob3JtYW5AcmVkaGF0LmNvbTsgc2Fzc21hbm5AcmVk
aGF0LmNvbTsNCj4gamVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tOyBBbmRyZXcgQm93ZXJzIDxh
bmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20+DQo+INb3zOI6IFJlOiBbbmV0LW5leHQgMi82XSBpNDBl
OiBwcmVmZXRjaCBzdHJ1Y3QgcGFnZSBvZiBSeCBidWZmZXIgY29uZGl0aW9uYWxseQ0KPiANCj4g
T24gV2VkLCAyOSBKdWwgMjAyMCAwNjoyMDo0NyArMDAwMCBMaSxSb25ncWluZyB3cm90ZToNCj4g
PiA+IExvb2tzIGxpa2Ugc29tZXRoaW5nIHRoYXQgYmVsb25ncyBpbiBhIGNvbW1vbiBoZWFkZXIg
bm90DQo+ID4gPiAocG90ZW50aWFsbHkNCj4gPiA+IG11bHRpcGxlKSBDIHNvdXJjZXMuDQo+ID4N
Cj4gPiBOb3QgY2xlYXIsIGhvdyBzaG91bGQgSSBjaGFuZ2U/DQo+IA0KPiBDYW4geW91IGFkZCBz
b21ldGhpbmcgbGlrZToNCj4gDQo+IHN0YXRpYyBpbmxpbmUgdm9pZCBwcmVmZXRjaF9wYWdlX2Fk
ZHJlc3Moc3RydWN0IHBhZ2UgKnBhZ2UpIHsgI2lmDQo+IGRlZmluZWQoV0FOVF9QQUdFX1ZJUlRV
QUwpIHx8IGRlZmluZWQoSEFTSEVEX1BBR0VfVklSVFVBTCkNCj4gCXByZWZldGNoKHBhZ2UpOw0K
PiAjZW5kaWYNCj4gfQ0KPiANCj4gdG8gbW0uaCBvciBwcmVmZXRjaC5oIG9yIGk0MGUuaCBvciBz
b21lIG90aGVyIGhlYWRlcj8gVGhhdCdzIHByZWZlcnJlZCBvdmVyDQo+IGFkZGluZyAjaWZzIGRp
cmVjdGx5IGluIHRoZSBzb3VyY2UgY29kZS4NCg0KDQpUaGFua3MsIEkgd2lsbCBzZW5kIGEgbmV3
IHZlcnNpb24NCg0KLUxpDQo=
