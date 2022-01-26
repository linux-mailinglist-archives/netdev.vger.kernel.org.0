Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9698449C8FC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiAZLpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:45:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35727 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbiAZLpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:45:49 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20QBjjLjB022732, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20QBjjLjB022732
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jan 2022 19:45:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 19:45:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 19:45:43 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Wed, 26 Jan 2022 19:45:43 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
Thread-Topic: [PATCH net-next 1/1] r8169: enable RTL8125 ASPM L1.2
Thread-Index: AQHYEU71utwpaLacm0G/vN72YItAmaxzrMwAgAFTwtD//5mTgIAAltJA
Date:   Wed, 26 Jan 2022 11:45:43 +0000
Message-ID: <660659d112434614b5b4c0dd0aeecf40@realtek.com>
References: <20220124181937.6331-1-hau@realtek.com>
 <23d3e690-da16-df03-4c75-dc92625b2c96@gmail.com>
 <052d2be6e8f445f3a4890e259bdee8ce@realtek.com>
 <c8df96c7-79b2-8b5b-9036-12bd8bfd5582@gmail.com>
In-Reply-To: <c8df96c7-79b2-8b5b-9036-12bd8bfd5582@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMjYg5LiK5Y2IIDA5OjM0OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAyNi4wMS4yMDIyIDEwOjAyLCBIYXUgd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiBPbiAyNC4w
MS4yMDIyIDE5OjE5LCBDaHVuaGFvIExpbiB3cm90ZToNCj4gPj4+IFRoaXMgcGF0Y2ggd2lsbCBl
bmFibGUgUlRMODEyNSBBU1BNIEwxLjIgb24gdGhlIHBsYXRmb3JtcyB0aGF0IGhhdmUNCj4gPj4+
IHRlc3RlZCBSVEw4MTI1IHdpdGggQVNQTSBMMS4yIGVuYWJsZWQuDQo+ID4+PiBSZWdpc3RlciBt
YWMgb2NwIDB4YzBiMiB3aWxsIGhlbHAgdG8gaWRlbnRpZnkgaWYgUlRMODEyNSBoYXMgYmVlbg0K
PiA+Pj4gdGVzdGVkIG9uIEwxLjIgZW5hYmxlZCBwbGF0Zm9ybS4gSWYgaXQgaXMsIHRoaXMgcmVn
aXN0ZXIgd2lsbCBiZSBzZXQgdG8gMHhmLg0KPiA+Pj4gSWYgbm90LCB0aGlzIHJlZ2lzdGVyIHdp
bGwgYmUgZGVmYXVsdCB2YWx1ZSAwLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IENodW5o
YW8gTGluIDxoYXVAcmVhbHRlay5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYyB8IDk5DQo+ID4+PiArKysrKysrKysrKysrKysr
KystLS0tLQ0KPiA+Pj4gIDEgZmlsZSBjaGFuZ2VkLCA3OSBpbnNlcnRpb25zKCspLCAyMCBkZWxl
dGlvbnMoLSkNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVhbHRlay9yODE2OV9tYWluLmMNCj4gPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRl
ay9yODE2OV9tYWluLmMNCj4gPj4+IGluZGV4IDE5ZTI2MjFlMDY0NS4uYjFlMDEzOTY5ZDRjIDEw
MDY0NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWlu
LmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0ZWsvcjgxNjlfbWFpbi5j
DQo+ID4+PiBAQCAtMjIzOCwyMSArMjIzOCw2IEBAIHN0YXRpYyB2b2lkIHJ0bF93b2xfZW5hYmxl
X3J4KHN0cnVjdA0KPiA+PiBydGw4MTY5X3ByaXZhdGUgKnRwKQ0KPiA+Pj4gIAkJCUFjY2VwdEJy
b2FkY2FzdCB8IEFjY2VwdE11bHRpY2FzdCB8DQo+ID4+IEFjY2VwdE15UGh5cyk7ICB9DQo+ID4+
Pg0KPiA+Pj4gLXN0YXRpYyB2b2lkIHJ0bF9wcmVwYXJlX3Bvd2VyX2Rvd24oc3RydWN0IHJ0bDgx
NjlfcHJpdmF0ZSAqdHApIC17DQo+ID4+PiAtCWlmICh0cC0+ZGFzaF90eXBlICE9IFJUTF9EQVNI
X05PTkUpDQo+ID4+PiAtCQlyZXR1cm47DQo+ID4+PiAtDQo+ID4+PiAtCWlmICh0cC0+bWFjX3Zl
cnNpb24gPT0gUlRMX0dJR0FfTUFDX1ZFUl8zMiB8fA0KPiA+Pj4gLQkgICAgdHAtPm1hY192ZXJz
aW9uID09IFJUTF9HSUdBX01BQ19WRVJfMzMpDQo+ID4+PiAtCQlydGxfZXBoeV93cml0ZSh0cCwg
MHgxOSwgMHhmZjY0KTsNCj4gPj4+IC0NCj4gPj4+IC0JaWYgKGRldmljZV9tYXlfd2FrZXVwKHRw
X3RvX2Rldih0cCkpKSB7DQo+ID4+PiAtCQlwaHlfc3BlZWRfZG93bih0cC0+cGh5ZGV2LCBmYWxz
ZSk7DQo+ID4+PiAtCQlydGxfd29sX2VuYWJsZV9yeCh0cCk7DQo+ID4+PiAtCX0NCj4gPj4+IC19
DQo+ID4+PiAtDQo+ID4+PiAgc3RhdGljIHZvaWQgcnRsX2luaXRfcnhjZmcoc3RydWN0IHJ0bDgx
NjlfcHJpdmF0ZSAqdHApICB7DQo+ID4+PiAgCXN3aXRjaCAodHAtPm1hY192ZXJzaW9uKSB7DQo+
ID4+PiBAQCAtMjY1MCw2ICsyNjM1LDM0IEBAIHN0YXRpYyB2b2lkDQo+ID4+PiBydGxfcGNpZV9z
dGF0ZV9sMmwzX2Rpc2FibGUoc3RydWN0DQo+ID4+IHJ0bDgxNjlfcHJpdmF0ZSAqdHApDQo+ID4+
PiAgCVJUTF9XOCh0cCwgQ29uZmlnMywgUlRMX1I4KHRwLCBDb25maWczKSAmIH5SZHlfdG9fTDIz
KTsgIH0NCj4gPj4+DQo+ID4+PiArc3RhdGljIHZvaWQgcnRsX2Rpc2FibGVfZXhpdF9sMShzdHJ1
Y3QgcnRsODE2OV9wcml2YXRlICp0cCkgew0KPiA+Pj4gKwkvKiBCaXRzIGNvbnRyb2wgd2hpY2gg
ZXZlbnRzIHRyaWdnZXIgQVNQTSBMMSBleGl0Og0KPiA+Pj4gKwkgKiBCaXQgMTI6IHJ4ZHYNCj4g
Pj4+ICsJICogQml0IDExOiBsdHJfbXNnDQo+ID4+PiArCSAqIEJpdCAxMDogdHhkbWFfcG9sbA0K
PiA+Pj4gKwkgKiBCaXQgIDk6IHhhZG0NCj4gPj4+ICsJICogQml0ICA4OiBwa3RhdmkNCj4gPj4+
ICsJICogQml0ICA3OiB0eHBsYQ0KPiA+Pj4gKwkgKi8NCj4gPj4+ICsJc3dpdGNoICh0cC0+bWFj
X3ZlcnNpb24pIHsNCj4gPj4+ICsJY2FzZSBSVExfR0lHQV9NQUNfVkVSXzM0IC4uLiBSVExfR0lH
QV9NQUNfVkVSXzM2Og0KPiA+Pj4gKwkJcnRsX2VyaV9jbGVhcl9iaXRzKHRwLCAweGQ0LCAweDFm
MDApOw0KPiA+Pj4gKwkJYnJlYWs7DQo+ID4+PiArCWNhc2UgUlRMX0dJR0FfTUFDX1ZFUl8zNyAu
Li4gUlRMX0dJR0FfTUFDX1ZFUl8zODoNCj4gPj4+ICsJCXJ0bF9lcmlfY2xlYXJfYml0cyh0cCwg
MHhkNCwgMHgwYzAwKTsNCj4gPj4+ICsJCWJyZWFrOw0KPiA+Pj4gKwljYXNlIFJUTF9HSUdBX01B
Q19WRVJfNDAgLi4uIFJUTF9HSUdBX01BQ19WRVJfNTM6DQo+ID4+PiArCQlydGxfZXJpX2NsZWFy
X2JpdHModHAsIDB4ZDQsIDB4MWY4MCk7DQo+ID4+PiArCQlicmVhazsNCj4gPj4+ICsJY2FzZSBS
VExfR0lHQV9NQUNfVkVSXzYwIC4uLiBSVExfR0lHQV9NQUNfVkVSXzYzOg0KPiA+Pj4gKwkJcjgx
NjhfbWFjX29jcF9tb2RpZnkodHAsIDB4YzBhYywgMHgxZjgwLCAwKTsNCj4gPj4+ICsJCWJyZWFr
Ow0KPiA+Pj4gKwlkZWZhdWx0Og0KPiA+Pj4gKwkJYnJlYWs7DQo+ID4+PiArCX0NCj4gPj4+ICt9
DQo+ID4+PiArDQo+ID4+PiAgc3RhdGljIHZvaWQgcnRsX2VuYWJsZV9leGl0X2wxKHN0cnVjdCBy
dGw4MTY5X3ByaXZhdGUgKnRwKSAgew0KPiA+Pj4gIAkvKiBCaXRzIGNvbnRyb2wgd2hpY2ggZXZl
bnRzIHRyaWdnZXIgQVNQTSBMMSBleGl0Og0KPiA+Pj4gQEAgLTI2OTIsNiArMjcwNSwzMyBAQCBz
dGF0aWMgdm9pZCBydGxfaHdfYXNwbV9jbGtyZXFfZW5hYmxlKHN0cnVjdA0KPiA+PiBydGw4MTY5
X3ByaXZhdGUgKnRwLCBib29sIGVuYWJsZSkNCj4gPj4+ICAJdWRlbGF5KDEwKTsNCj4gPj4+ICB9
DQo+ID4+Pg0KPiA+Pj4gK3N0YXRpYyB2b2lkIHJ0bF9od19hc3BtX2wxMl9lbmFibGUoc3RydWN0
IHJ0bDgxNjlfcHJpdmF0ZSAqdHAsIGJvb2wNCj4gPj4+ICtlbmFibGUpIHsNCj4gPj4+ICsJLyog
RG9uJ3QgZW5hYmxlIEwxLjIgaW4gdGhlIGNoaXAgaWYgT1MgY2FuJ3QgY29udHJvbCBBU1BNICov
DQo+ID4+PiArCWlmIChlbmFibGUgJiYgdHAtPmFzcG1fbWFuYWdlYWJsZSkgew0KPiA+Pj4gKwkJ
cjgxNjhfbWFjX29jcF9tb2RpZnkodHAsIDB4ZTA5NCwgMHhmZjAwLCAwKTsNCj4gPj4+ICsJCXI4
MTY4X21hY19vY3BfbW9kaWZ5KHRwLCAweGUwOTIsIDB4MDBmZiwgQklUKDIpKTsNCj4gPj4+ICsJ
fSBlbHNlIHsNCj4gPj4+ICsJCXI4MTY4X21hY19vY3BfbW9kaWZ5KHRwLCAweGUwOTIsIDB4MDBm
ZiwgMCk7DQo+ID4+PiArCX0NCj4gPj4+ICt9DQo+ID4+PiArDQo+ID4+DQo+ID4+IFJlZ2lzdGVy
IEUwOTQgYml0cyAwLi4xNSBhcmUgY2xlYXJlZCB3aGVuIGVuYWJsaW5nLCBidXQgbm90IHRvdWNo
ZWQNCj4gPj4gb24gZGlzYWJsaW5nLiBJIHRoaXMgY29ycmVjdD8NCj4gPiAgICBSZWdpc3RlciBF
MDk0IGJpdHMgOC4uLjE1IGlzIGEgdGltZXIgY291bnRlciB0aGF0IGlzIHVzZWQgdG8gY29udHJv
bCB3aGVuIHRvDQo+IGRpc2FibGUgZXBoeSB0eC9yeC4NCj4gPiAgICBTZXQgaXQgdG8gMCBtZWFu
cyBkaXNhYmxlIGVwaHkgdHgvcnggaW1tZWRpYXRlbHkgd2hlbiBjZXJ0YWluIGNvbmRpdGlvbg0K
PiBtZWV0Lg0KPiA+ICAgIEl0IGhhcyBubyBtZWFuaW5nIHdoZW4gcmVnaXN0ZXIgRTA5MiBiaXQg
MiBpcyBzZXQgdG8gMC4NCj4gPg0KPiBUaGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbi4NCj4gDQo+
ID4+IEFuZCBmb3IgYmFzaWNhbGx5IHRoZSBzYW1lIHB1cnBvc2Ugd2UgaGF2ZSB0aGUgZm9sbG93
aW5nIGZ1bmN0aW9uLg0KPiA+PiAiZG9uJ3QgZW5hYmxlIEwxLjIgaW4gdGhlIGNoaXAiIGlzIG5v
dCBjb3ZlcmVkIGJ5IEFTUE1fZW4gaW4gQ29uZmlnNT8NCj4gPiAgICBSZWdpc3RlciBFMDkyIGlz
IGxpa2UgIEFTUE1fZW4gaW4gQ29uZmlnNS4gQnV0IGl0IGNvbnRyb2xzIEwxIHN1YnN0YXRlDQo+
IChMMS4xL0wxLjIpIGVuYWJsZSBzdGF0dXMuDQo+ID4NCj4gSG93IGlzIHRoaXMgaGFuZGxlZCBm
b3IgdGhlIFJUTDgxNjggY2hpcCB2ZXJzaW9ucyBzdXBwb3J0aW5nIEwxIHN1Yi1zdGF0ZXMNCj4g
KFJUTDgxNjhoKT8NCj4gSXMgdGhlcmUgYSBzaW1pbGFyIHJlZ2lzdGVyIG9yIGRvZXMgQ29uZmln
NSBBU1BNX2VuIGNvbnRyb2wgYWxzbyB0aGUgTDENCj4gc3Vic3RhdGVzIG9uIHRoZXNlIGNoaXAg
dmVyc2lvbnM/DQo+IA0KWW91IGNvdWxkIGFwcGx5IHRoZSBzYW1lIHNldHRpbmcgb24gUlRMODE2
OEguDQoNCj4gPj4NCj4gPj4gc3RhdGljIHZvaWQgcnRsX2h3X2FzcG1fY2xrcmVxX2VuYWJsZShz
dHJ1Y3QgcnRsODE2OV9wcml2YXRlICp0cCwNCj4gPj4gYm9vbA0KPiA+PiBlbmFibGUpIHsNCj4g
Pj4gCS8qIERvbid0IGVuYWJsZSBBU1BNIGluIHRoZSBjaGlwIGlmIE9TIGNhbid0IGNvbnRyb2wg
QVNQTSAqLw0KPiA+PiAJaWYgKGVuYWJsZSAmJiB0cC0+YXNwbV9tYW5hZ2VhYmxlKSB7DQo+ID4+
IAkJUlRMX1c4KHRwLCBDb25maWc1LCBSVExfUjgodHAsIENvbmZpZzUpIHwgQVNQTV9lbik7DQo+
ID4+IAkJUlRMX1c4KHRwLCBDb25maWcyLCBSVExfUjgodHAsIENvbmZpZzIpIHwgQ2xrUmVxRW4p
Ow0KPiA+PiAJfSBlbHNlIHsNCj4gPj4gCQlSVExfVzgodHAsIENvbmZpZzIsIFJUTF9SOCh0cCwg
Q29uZmlnMikgJiB+Q2xrUmVxRW4pOw0KPiA+PiAJCVJUTF9XOCh0cCwgQ29uZmlnNSwgUlRMX1I4
KHRwLCBDb25maWc1KSAmIH5BU1BNX2VuKTsNCj4gPj4gCX0NCj4gPj4NCj4gPj4gCXVkZWxheSgx
MCk7DQo+ID4+IH0NCj4gPj4NCj4gPj4NCj4gLi4uDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0
aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
