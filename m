Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437821239D9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfLQWVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:21:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:65017 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfLQWVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 17:21:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 14:21:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="389978372"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 17 Dec 2019 14:21:31 -0800
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Dec 2019 14:21:31 -0800
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.124]) by
 FMSMSX126.amr.corp.intel.com ([169.254.1.235]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 14:21:30 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Thread-Topic: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
Thread-Index: AQHVtGD6wfSrkAg3wE2y4cWf1VMoIKe+vkZQgACKLID//567AA==
Date:   Tue, 17 Dec 2019 22:21:29 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
References: <20191216223344.2261-1-olteanv@gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
In-Reply-To: <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTAwNjg4OGQtZTlmMy00M2Y2LWJjNTktZTllYTNjOWI0MzU5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSlJDTjdzVDlRWmZuVHZcL2U2TUY1Qnhtdk5wbXNiYjVYM2dJR3RZK3F1d1UwZzNhbG1RMnVaeCtDNjdkSnlWd3QifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5r
ZXJuZWwub3JnIDxuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbg0KPiBCZWhhbGYgT2Yg
VmxhZGltaXIgT2x0ZWFuDQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDE3LCAyMDE5IDEyOjA3
IFBNDQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4g
Q2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb207DQo+
IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgZi5mYWluZWxsaUBnbWFpbC5jb207IHZpdmllbi5k
aWRlbG90QGdtYWlsLmNvbTsNCj4gYW5kcmV3QGx1bm4uY2g7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRdIG5ldDogZHNhOiBzamExMTA1OiBGaXggZG91
YmxlIGRlbGl2ZXJ5IG9mIFRYIHRpbWVzdGFtcHMNCj4gdG8gc29ja2V0IGVycm9yIHF1ZXVlDQo+
IA0KPiBIaSBKYWtlLA0KPiANCj4gPiBJIHRob3VnaHQgdGhlIHBvaW50IG9mIFNLQlRYX0lOX1BS
T0dSRVNTIHdhcyB0byBpbmZvcm0gdGhlIHN0YWNrIHRoYXQgYQ0KPiB0aW1lc3RhbXAgd2FzIHBl
bmRpbmcuIEJ5IG5vdCBzZXR0aW5nIGl0LCB5b3Ugbm8gbG9uZ2VyIGRvIHRoaXMuDQo+ID4NCj4g
PiBNYXliZSB0aGF0IGhhcyBjaGFuZ2VkIHNpbmNlIHRoZSBvcmlnaW5hbCBpbXBsZW1lbnRhdGlv
bj8gT3IgYW0gSQ0KPiBtaXN1bmRlcnN0YW5kaW5nIHRoaXMgcGF0Y2guLj8NCj4gPg0KPiANCj4g
SSBhbSBub3QgcXVpdGUgc3VyZSB3aGF0IHRoZSBwb2ludCBvZiBTS0JUWF9JTl9QUk9HUkVTUyBp
cy4gSWYgeW91DQo+IHNlYXJjaCB0aHJvdWdoIHRoZSBrZXJuZWwgeW91IHdpbGwgZmluZCBhIHNp
bmdsZSBvY2N1cnJlbmNlIHJpZ2h0IG5vdw0KPiB0aGF0IGlzIHN1cHBvc2VkIHRvIGRvIHNvbWV0
aGluZyAoSSBkb24ndCB1bmRlcnN0YW5kIHdoYXQgZXhhY3RseSkNCj4gd2hlbiB0aGVyZSBpcyBh
IGNvbmN1cnJlbnQgc3cgYW5kIGh3IHRpbWVzdGFtcC4NCj4gDQoNCk15IHVuZGVyc3RhbmRpbmcg
d2FzIHRoYXQgc2V0dGluZyBpdCBwcmV2ZW50ZWQgdGhlIHN0YWNrIGZyb20gZ2VuZXJhdGluZyBh
IFNXIHRpbWVzdGFtcCBpZiB0aGUgaGFyZHdhcmUgdGltZXN0YW1wIHdhcyBnb2luZyB0byBiZSBw
cm92aWRlZC4gQmFzaWNhbGx5LCB0aGlzIGlzIGJlY2F1c2Ugd2Ugd291bGQgb3RoZXJ3aXNlIHJl
cG9ydCB0aGUgdGltZXN0YW1wIHR3aWNlIHRvIGFwcGxpY2F0aW9ucyB0aGF0IGV4cGVjdCBvbmx5
IG9uZSB0aW1lc3RhbXAuDQoNClRoZXJlIHdlcmUgc29tZSBwYXRjaGVzIGZyb20gTWlyb3NsYXYg
dGhhdCBlbmFibGVkIG9wdGlvbmFsbHkgYWxsb3dlZCB0aGUgcmVwb3J0aW5nIG9mIGJvdGggU1cg
YW5kIEhXIHRpbWVzdGFtcHMgYXQgdGhlIHNhbWUgdGltZS4NCg0KPiA+IFlvdSdyZSByZW1vdmlu
ZyB0aGUgc2phMTEwNSBhc3NpZ25tZW50LCBub3QgdGhlIG9uZSBmcm9tIHRoZSBnaWFuZmFyLiBI
bW0NCj4gPg0KPiA+IE9rLCBzbyB0aGUgaXNzdWUgaXMgdGhhdCBzamExMTA1X3B0cC5jIHdhcyBp
bmNvcnJlY3RseSBzZXR0aW5nIHRoZSBmbGFnLg0KPiA+DQo+ID4gV291bGQgaXQgbWFrZSBtb3Jl
IHNlbnNlIGZvciBnaWFuZmFyIHRvIHNldCBTS0JUWF9JTl9QUk9HUkVTUywgYnV0IHRoZW4NCj4g
dXNlIHNvbWUgb3RoZXIgaW5kaWNhdG9yIGludGVybmFsbHksIHNvIHRoYXQgb3RoZXIgY2FsbGVy
cyB3aG8gc2V0IGl0IGRvbid0IGNhdXNlDQo+IHRoZSBnaWFuZmFyIGRyaXZlciB0byBiZWhhdmUg
aW5jb3JyZWN0bHk/IEkgYmVsaWV2ZSB3ZSBoYW5kbGUgaXQgaW4gdGhlIEludGVsIGRyaXZlcnMN
Cj4gdGhhdCB3YXkgYnkgc3RvcmluZyB0aGUgc2tiLiBUaGVuIHdlIGRvbid0IGNoZWNrIHRoZSBT
S0JUWF9JTl9QUk9HUkVTUyBsYXRlci4NCj4gDQo+IFllcywgdGhlIHBvaW50IGlzIHRoYXQgaXQg
c2hvdWxkIGNoZWNrIHByaXYtPmh3dHNfdHhfZW4gJiYNCj4gKHNrYl9zaGluZm8oc2tiKS0+dHhf
ZmxhZ3MgJiBTS0JUWF9JTl9QUk9HUkVTUykuIFRoYXQgd2FzIG15IGluaXRpYWwNCj4gZml4IGZv
ciB0aGUgYnVnLCBidXQgUmljaGFyZCBhcmd1ZWQgdGhhdCBzZXR0aW5nIFNLQlRYX0lOX1BST0dS
RVNTIGluDQo+IGl0c2VsZiBpc24ndCBuZWVkZWQuDQo+IA0KDQpJJ2QgdHJ1c3QgUmljaGFyZCBv
biB0aGlzIG9uZSBmb3Igc3VyZS4NCg0KPiBUaGVyZSBhcmUgbWFueSBtb3JlIGRyaXZlcnMgdGhh
dCBhcmUgaW4gcHJpbmNpcGxlIGJyb2tlbiB3aXRoIERTQSBQVFAsDQo+IHNpbmNlIHRoZXkgZG9u
J3QgZXZlbiBoYXZlIHRoZSBlcXVpdmFsZW50IGNoZWNrIGZvciBwcml2LT5od3RzX3R4X2VuLg0K
PiANCg0KUmlnaHQuIEknbSB3b25kZXJpbmcgd2hhdCB0aGUgY29ycmVjdCBmaXggd291bGQgYmUg
c28gdGhhdCB3ZSBjYW4gZml4IHRoZSBkcml2ZXJzIGFuZCBob3BlZnVsbHkgYXZvaWQgaW50cm9k
dWNpbmcgYSBzaW1pbGFyIGlzc3VlIGluIHRoZSBmdXR1cmUuDQoNClRoYW5rcywNCkpha2UNCg0K
PiA+DQo+ID4gVGhhbmtzLA0KPiA+IEpha2UNCj4gPg0KPiA+DQo+IA0KPiBUaGFua3MsDQo+IC1W
bGFkaW1pcg0K
