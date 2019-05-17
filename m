Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06252205D
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfEQWgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:36:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:30450 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbfEQWgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 18:36:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 15:36:48 -0700
X-ExtLoop1: 1
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga001.jf.intel.com with ESMTP; 17 May 2019 15:36:47 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.200]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.194]) with mapi id 14.03.0415.000;
 Fri, 17 May 2019 15:36:47 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][next] i40e: mark expected switch
 fall-through
Thread-Topic: [Intel-wired-lan] [PATCH][next] i40e: mark expected switch
 fall-through
Thread-Index: AQHVAGBkv65pMyI0KkarzT0dRkZJ76ZwASjQ
Date:   Fri, 17 May 2019 22:36:47 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D3DB7B9@ORSMSX104.amr.corp.intel.com>
References: <20190501205541.GA17995@embeddedor>
In-Reply-To: <20190501205541.GA17995@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzdlNDk2ZGQtODAyMS00MTYwLTlhMTktODBjYTI2MGM0ZmNmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoid3RIMGdTUzB1M1FMd3NSNDBsc1hsc2JzOVlTb1BSYVZvZEs3WVlCOTY4bEVQVjFNcU9cL2R2QlV4WmlZd2NVU3EifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gW21h
aWx0bzppbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3JnXSBPbg0KPiBCZWhhbGYgT2Yg
R3VzdGF2byBBLiBSLiBTaWx2YQ0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxLCAyMDE5IDE6NTYg
UE0NCj4gVG86IEtpcnNoZXIsIEplZmZyZXkgVCA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29t
PjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IGxpbnV4
LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVt
Lm9yZz4NCj4gU3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIXVtuZXh0XSBpNDBlOiBt
YXJrIGV4cGVjdGVkIHN3aXRjaCBmYWxsLQ0KPiB0aHJvdWdoDQo+IA0KPiBJbiBwcmVwYXJhdGlv
biB0byBlbmFibGluZyAtV2ltcGxpY2l0LWZhbGx0aHJvdWdoLCBtYXJrIHN3aXRjaCBjYXNlcyB3
aGVyZQ0KPiB3ZSBhcmUgZXhwZWN0aW5nIHRvIGZhbGwgdGhyb3VnaC4NCj4gDQo+IFRoaXMgcGF0
Y2ggZml4ZXMgdGhlIGZvbGxvd2luZyB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jOiBJbiBmdW5jdGlvbiDigJhpNDBlX3J1bl94ZHBfemPi
gJk6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYzoyMTc6Mzog
d2FybmluZzogdGhpcyBzdGF0ZW1lbnQNCj4gbWF5IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1m
YWxsdGhyb3VnaD1dDQo+ICAgIGJwZl93YXJuX2ludmFsaWRfeGRwX2FjdGlvbihhY3QpOw0KPiAg
ICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pNDBlL2k0MGVfeHNrLmM6MjE4OjI6IG5vdGU6IGhlcmUNCj4gICBjYXNlIFhEUF9B
Qk9SVEVEOg0KPiAgIF5+fn4NCj4gDQo+IEluIHByZXBhcmF0aW9uIHRvIGVuYWJsaW5nIC1XaW1w
bGljaXQtZmFsbHRocm91Z2gsIG1hcmsgc3dpdGNoIGNhc2VzIHdoZXJlDQo+IHdlIGFyZSBleHBl
Y3RpbmcgdG8gZmFsbCB0aHJvdWdoLg0KPiANCj4gVGhpcyBwYXRjaCBmaXhlcyB0aGUgZm9sbG93
aW5nIHdhcm5pbmc6DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZvIEEuIFIuIFNpbHZhIDxn
dXN0YXZvQGVtYmVkZGVkb3IuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2k0MGUvaTQwZV94c2suYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspDQoNClRlc3RlZC1ieTogQW5kcmV3IEJvd2VycyA8YW5kcmV3eC5ib3dlcnNAaW50ZWwuY29t
Pg0KDQoNCg==
