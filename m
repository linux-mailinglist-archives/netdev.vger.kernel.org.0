Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8571BB47C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgD1DZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:25:17 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2064 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbgD1DZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 23:25:16 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 7F131EF0F6DD1DA90DEA;
        Tue, 28 Apr 2020 11:25:14 +0800 (CST)
Received: from DGGEML424-HUB.china.huawei.com (10.1.199.41) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 28 Apr 2020 11:25:14 +0800
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.137]) by
 dggeml424-hub.china.huawei.com ([10.1.199.41]) with mapi id 14.03.0487.000;
 Tue, 28 Apr 2020 11:25:09 +0800
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
To:     David Lechner <david@lechnology.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: re: [PATCH net-next] drivers: net: davinci_mdio: fix potential NULL
 dereference in davinci_mdio_probe()
Thread-Topic: [PATCH net-next] drivers: net: davinci_mdio: fix potential
 NULL dereference in davinci_mdio_probe()
Thread-Index: AdYdDJhllU98YjTxSV6t/TDCiihblw==
Date:   Tue, 28 Apr 2020 03:25:09 +0000
Message-ID: <6AADFAC011213A4C87B956458587ADB419A6B43E@dggeml532-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.166.215.142]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gNC8yNy8yMCA0OjQwIEFNLCBXZWkgWW9uZ2p1biB3cm90ZToNCj4gPiBwbGF0Zm9y
bV9nZXRfcmVzb3VyY2UoKSBtYXkgZmFpbCBhbmQgcmV0dXJuIE5VTEwsIHNvIHdlIHNob3VsZCBi
ZXR0ZXINCj4gPiBjaGVjayBpdCdzIHJldHVybiB2YWx1ZSB0byBhdm9pZCBhIE5VTEwgcG9pbnRl
ciBkZXJlZmVyZW5jZSBhIGJpdA0KPiA+IGxhdGVyIGluIHRoZSBjb2RlLg0KPiA+DQo+ID4gVGhp
cyBpcyBkZXRlY3RlZCBieSBDb2NjaW5lbGxlIHNlbWFudGljIHBhdGNoLg0KPiA+DQo+ID4gQEAN
Cj4gPiBleHByZXNzaW9uIHBkZXYsIHJlcywgbiwgdCwgZSwgZTEsIGUyOyBAQA0KPiA+DQo+ID4g
cmVzID0gXChwbGF0Zm9ybV9nZXRfcmVzb3VyY2VcfHBsYXRmb3JtX2dldF9yZXNvdXJjZV9ieW5h
bWVcKShwZGV2LCB0LCBuKTsNCj4gPiArIGlmICghcmVzKQ0KPiA+ICsgICByZXR1cm4gLUVJTlZB
TDsNCj4gPiAuLi4gd2hlbiAhPSByZXMgPT0gTlVMTA0KPiA+IGUgPSBkZXZtX2lvcmVtYXAoZTEs
IHJlcy0+c3RhcnQsIGUyKTsNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFdlaSBZb25nanVuIDx3
ZWl5b25nanVuMUBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiANCj4gQ291bGQgd2UgdXNlIGRldm1f
cGxhdGZvcm1faW9yZW1hcF9yZXNvdXJjZSgpIGluc3RlYWQ/DQoNCldlIGNhbm5vdCB1c2UgZGV2
bV9wbGF0Zm9ybV9pb3JlbWFwX3Jlc291cmNlKCkgaGVyZSwgc2VlDQpDb21taXQgMDNmNjZmMDY3
NTYwICgibmV0OiBldGhlcm5ldDogdGk6IGRhdmluY2lfbWRpbzogdXNlIGRldm1faW9yZW1hcCgp
IikNCg0KUmVnYXJkcw0K
