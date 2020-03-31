Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524E5198CF5
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 09:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgCaHbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 03:31:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:28856 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbgCaHbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 03:31:55 -0400
IronPort-SDR: yD7+2flhITNHXPkpm1kPC6atLt8lumD3wtKesTJjbwLU272f596BudZ3dpLtQkpVr/wIEtnQs/
 clzDPdJ67nIA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 00:31:53 -0700
IronPort-SDR: 3kxJtSVwWb3J9LDXTS0wb95K8nWhGUPKGqd7CC+LqXGLu5NWTHB+JKsAfS3Is2BXgNwIzqozTx
 /wTcYAS93eMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="283904736"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga002.fm.intel.com with ESMTP; 31 Mar 2020 00:31:53 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 00:31:53 -0700
Received: from shsmsx102.ccr.corp.intel.com ([169.254.2.138]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 15:31:50 +0800
From:   "Xia, Hui" <hui.xia@intel.com>
To:     Jason Wang <jasowang@redhat.com>, lkp <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: [vhost:linux-next 8/13] include/linux/vringh.h:18:10: fatal
 error: linux/vhost_iotlb.h: No such file or directory
Thread-Topic: [vhost:linux-next 8/13] include/linux/vringh.h:18:10: fatal
 error: linux/vhost_iotlb.h: No such file or directory
Thread-Index: AQHWBj27rykPim8gFk2JJkvG67mYpahiSuVw
Date:   Tue, 31 Mar 2020 07:31:50 +0000
Message-ID: <2A5F4C9150EECB4DAA6291810D6D61B9745B7754@shsmsx102.ccr.corp.intel.com>
References: <202003292026.dP7OOeCi%lkp@intel.com>
 <f1270de5-7a2c-76d2-431c-34364def851a@redhat.com>
In-Reply-To: <f1270de5-7a2c-76d2-431c-34364def851a@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEphc29uIFdhbmcgPGphc293
YW5nQHJlZGhhdC5jb20+DQo+U2VudDogMjAyMOW5tDPmnIgzMOaXpSAxMDo0Nw0KPlRvOiBsa3Ag
PGxrcEBpbnRlbC5jb20+DQo+Q2M6IGtidWlsZC1hbGxAbGlzdHMuMDEub3JnOyBrdm1Admdlci5r
ZXJuZWwub3JnOyB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC0NCj5mb3VuZGF0aW9uLm9yZzsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNv
bT4NCj5TdWJqZWN0OiBSZTogW3Zob3N0OmxpbnV4LW5leHQgOC8xM10gaW5jbHVkZS9saW51eC92
cmluZ2guaDoxODoxMDogZmF0YWwgZXJyb3I6DQo+bGludXgvdmhvc3RfaW90bGIuaDogTm8gc3Vj
aCBmaWxlIG9yIGRpcmVjdG9yeQ0KPg0KPg0KPk9uIDIwMjAvMy8yOSDkuIvljYg4OjA4LCBrYnVp
bGQgdGVzdCByb2JvdCB3cm90ZToNCj4+IHRyZWU6ICAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbXN0L3Zob3N0LmdpdCBsaW51eC1uZXh0DQo+PiBoZWFk
OiAgIGY0NGE2M2Y5ZWJmNjZhNDUwYzEwMTA4NGEzNWEzZWYxNThlYWQyMDkNCj4+IGNvbW1pdDog
YzQzOTA4YjBiOWE5MDBiZDUxZjg2MWY0YzU3YjgzY2ZkOTMyZjRkMiBbOC8xM10gdnJpbmdoOiBJ
T1RMQg0KPj4gc3VwcG9ydA0KPj4gY29uZmlnOiBhcm0tZW1feDI3MF9kZWZjb25maWcgKGF0dGFj
aGVkIGFzIC5jb25maWcpDQo+PiBjb21waWxlcjogYXJtLWxpbnV4LWdudWVhYmktZ2NjIChHQ0Mp
IDkuMy4wDQo+PiByZXByb2R1Y2U6DQo+PiAgICAgICAgICB3Z2V0IGh0dHBzOi8vcmF3LmdpdGh1
YnVzZXJjb250ZW50LmNvbS9pbnRlbC9sa3AtDQo+dGVzdHMvbWFzdGVyL3NiaW4vbWFrZS5jcm9z
cyAtTyB+L2Jpbi9tYWtlLmNyb3NzDQo+PiAgICAgICAgICBjaG1vZCAreCB+L2Jpbi9tYWtlLmNy
b3NzDQo+PiAgICAgICAgICBnaXQgY2hlY2tvdXQgYzQzOTA4YjBiOWE5MDBiZDUxZjg2MWY0YzU3
YjgzY2ZkOTMyZjRkMg0KPg0KPg0KPkkgY291bGQgbm90IGZpbmQgdGhpcyBjb21taXQgaW4gdGhl
IGFib3ZlIGJyYW5jaC4NCj4NCj4NCj4+ICAgICAgICAgICMgc2F2ZSB0aGUgYXR0YWNoZWQgLmNv
bmZpZyB0byBsaW51eCBidWlsZCB0cmVlDQo+PiAgICAgICAgICBHQ0NfVkVSU0lPTj05LjMuMCBt
YWtlLmNyb3NzIEFSQ0g9YXJtDQo+DQo+DQo+VHJ5IHRvIHVzZSBjb21taXQgZGMzYjA2NzNhZTVl
ZmI3M2VkYWI2NmVjNWMyZjA3NDI3MmU5YTRkZi4NCj4NCj5CdXQgdGhpcyBjb21tYW5kIGRvZXMg
bm90IHdvcmsgKEkgcmVtZW1iZXIgaXQgdXNlZCB0byB3b3JrKToNCj4NCj4jIEdDQ19WRVJTSU9O
PTkuMy4wIG1ha2UuY3Jvc3MgQVJDSD1hcm0NCj5jZDogcmVjZWl2ZWQgcmVkaXJlY3Rpb24gdG8N
Cj5gaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9jcm9zcy1wYWNrYWdlLycNCj5sZnRw
Z2V0IC1jDQo+aHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9jcm9zcy1wYWNrYWdlLy4v
Z2NjLTkuMy4wLW5vbGliYy94ODZfNjQtZ2NjLQ0KPjkuMy4wLW5vbGliY19hcm0tbGludXgtZ251
ZWFiaWhmLnRhci54eg0KPnRhciBKeGYNCj5nY2MtOS4zLjAtbm9saWJjL3g4Nl82NC1nY2MtOS4z
LjAtbm9saWJjX2FybS1saW51eC1nbnVlYWJpaGYudGFyLnh6IC1DDQo+L3Jvb3QvMGRheSBObyBj
cm9zcyBjb21waWxlciBmb3IgYXJtIHNldHVwX2Nyb3NzdG9vbCBmYWlsZWQNCkhpIEphc29uLCB0
aGFua3MgZm9yIHJlcG9ydCB0aGlzIGlzc3VlLiBJdCBpcyBjYXVzZWQgYnkgd3JvbmcgZmluZGlu
ZyBpbiAyIGNyb3NzIHRvb2xzIGZvciBhcm0uIEFuZCBoYXMgYmVlbiBmaXhlZC4gVGhhbmtzLg0K
UmVnYXJkaW5nIHRvIHRoZSB2aG9zdCBidWlsZCBpc3N1ZSBpdHNlbGYsIGl0IGhhcyBnb25lIGlu
IGxhdGVzdCB2aG9zdC9saW51eC1uZXh0LiBUaGUgY2F1c2UgaXMgdGhlIGNvZGUga2J1aWxkIGNh
cHR1cmVkIGRpZG4ndCBoYXZlICBwYXRjaCAiIHZob3N0OiBmYWN0b3Igb3V0IElPVExCICIgd2hp
Y2ggaW50cm9kdWNlIGxpbnV4L3Zob3N0X2lvdGxiLmggYXQgdGhhdCBtb21lbnQuIFNvIGp1c3Qg
aWdub3JlIHRoaXMgaXNzdWUgc2luY2UgdGhlIG1pc3NlZCBwYXRjaCBoYXMgYmVlbiBhZGRlZCBp
biBsYXRlc3Qgdmhvc3QvbGludXgtbmV4dC4NCg0KPg0KPg0KPj4NCj4+IElmIHlvdSBmaXggdGhl
IGlzc3VlLCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWcNCj4+IFJlcG9ydGVkLWJ5OiBrYnVpbGQg
dGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4+DQo+PiBBbGwgZXJyb3JzIChuZXcgb25lcyBw
cmVmaXhlZCBieSA+Pik6DQo+Pg0KPj4gICAgIEluIGZpbGUgaW5jbHVkZWQgZnJvbSBpbmNsdWRl
L2xpbnV4L3ZpcnRpby5oOjEyLA0KPj4gICAgICAgICAgICAgICAgICAgICAgZnJvbSBpbmNsdWRl
L2xpbnV4L3ZpcnRpb19jb25maWcuaDo3LA0KPj4gICAgICAgICAgICAgICAgICAgICAgZnJvbSBp
bmNsdWRlL3VhcGkvbGludXgvdmlydGlvX25ldC5oOjMwLA0KPj4gICAgICAgICAgICAgICAgICAg
ICAgZnJvbSBpbmNsdWRlL2xpbnV4L3ZpcnRpb19uZXQuaDo2LA0KPj4gICAgICAgICAgICAgICAg
ICAgICAgZnJvbSBuZXQvL3BhY2tldC9hZl9wYWNrZXQuYzo4MjoNCj4+Pj4gaW5jbHVkZS9saW51
eC92cmluZ2guaDoxODoxMDogZmF0YWwgZXJyb3I6IGxpbnV4L3Zob3N0X2lvdGxiLmg6IE5vDQo+
Pj4+IHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCj4+ICAgICAgICAxOCB8ICNpbmNsdWRlIDxsaW51
eC92aG9zdF9pb3RsYi5oPg0KPj4gICAgICAgICAgIHwgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+
fn5+fn5+DQo+PiAgICAgY29tcGlsYXRpb24gdGVybWluYXRlZC4NCj4+DQo+PiB2aW0gKzE4IGlu
Y2x1ZGUvbGludXgvdnJpbmdoLmgNCj4+DQo+PiAgICA+IDE4CSNpbmNsdWRlIDxsaW51eC92aG9z
dF9pb3RsYi5oPg0KPj4gICAgICAxOQkjaW5jbHVkZSA8YXNtL2JhcnJpZXIuaD4NCj4+ICAgICAg
MjANCj4NCj4NCj5JIGNhbiBoYXJkbHkgYmVsaWV2ZSBpdCBjYW4ndCB3b3JrLg0KPg0KPkkgZ2V0
DQo+DQo+IyBmaWxlIGluY2x1ZGUvbGludXgvdnJpbmdoLmgNCj5pbmNsdWRlL2xpbnV4L3ZyaW5n
aC5oOiBDIHNvdXJjZSwgQVNDSUkgdGV4dA0KPg0KPlNvIHRoaXMgbG9va3MgbGlrZSBhIGZhbHNl
IHBvc2l0aXZlIHRvIG1lPw0KPg0KPlRoYW5rcw0KPg0KPg0KPj4NCj4+IC0tLQ0KPj4gMC1EQVkg
Q0kgS2VybmVsIFRlc3QgU2VydmljZSwgSW50ZWwgQ29ycG9yYXRpb24NCj4+IGh0dHBzOi8vbGlz
dHMuMDEub3JnL2h5cGVya2l0dHkvbGlzdC9rYnVpbGQtYWxsQGxpc3RzLjAxLm9yZw0KDQo=
