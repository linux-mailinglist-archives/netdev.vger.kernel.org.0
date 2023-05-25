Return-Path: <netdev+bounces-5253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB07C7106C2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BE771C20E71
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15A0C136;
	Thu, 25 May 2023 07:52:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E380D1FB8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:52:40 +0000 (UTC)
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E9910EA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:52:11 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
	by ex01.ufhost.com (Postfix) with ESMTP id 45AE224E1BA;
	Thu, 25 May 2023 15:52:09 +0800 (CST)
Received: from EXMBX072.cuchost.com (172.16.6.82) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 25 May
 2023 15:52:09 +0800
Received: from EXMBX172.cuchost.com (172.16.6.92) by EXMBX072.cuchost.com
 (172.16.6.82) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 25 May
 2023 15:52:08 +0800
Received: from EXMBX172.cuchost.com ([fe80::517e:7ab2:ceed:9a4a]) by
 EXMBX172.cuchost.com ([fe80::517e:7ab2:ceed:9a4a%16]) with mapi id
 15.00.1497.044; Thu, 25 May 2023 15:52:08 +0800
From: Genevieve Chan <genevieve.chan@starfivetech.com>
To: Russell King <linux@armlinux.org.uk>
CC: Heiner Kallweit <hkallweit1@gmail.com>, "ddaney@caviumnetworks.com"
	<ddaney@caviumnetworks.com>, Andrew Lunn <andrew@lunn.ch>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Marvell_of_reg_init function
Thread-Topic: Marvell_of_reg_init function
Thread-Index: AdmOAr4bBWX941KOSYOf8PES2HXVVAAA67Bw//+BzoCAACIDgP/99TwQ
Date: Thu, 25 May 2023 07:52:08 +0000
Message-ID: <09924e3c38fe42de8f98daa4e7d05b41@EXMBX172.cuchost.com>
References: <8eb8860a698b453788c29d43c6e3f239@EXMBX172.cuchost.com>
 <907b769ca48a482eaf727b89ead56db4@EXMBX172.cuchost.com>
 <ace88928-93b3-72fe-59e5-c7b5b7527f5e@gmail.com>
 <ZG3Ne7wOo3SeSZTp@shell.armlinux.org.uk>
In-Reply-To: <ZG3Ne7wOo3SeSZTp@shell.armlinux.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [202.188.176.82]
x-yovoleruleagent: yovoleflag
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tm90ZWQuIFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZnJvbSB0aGUgcHJvbXB0IHJlc3BvbnNlIQ0KDQpU
aGFuayB5b3UgYW5kIGhhdmUgYSBuaWNlIGRheSENCg0KQmVzdCByZWdhcmRzLA0KR2VuZXZpZXZl
IENoYW7vvIjpmYjlt6foibPvvIkNClNvZnR3YXJlIFRlYW0sIE1EQw0KU3RhcmZpdmUgVGVjaG5v
bG9neSBTZG4uIEJoZC4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFJ1c3Nl
bGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPiANClNlbnQ6IFdlZG5lc2RheSwgTWF5IDI0
LCAyMDIzIDQ6NDAgUE0NClRvOiBHZW5ldmlldmUgQ2hhbiA8Z2VuZXZpZXZlLmNoYW5Ac3RhcmZp
dmV0ZWNoLmNvbT4NCkNjOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsg
ZGRhbmV5QGNhdml1bW5ldHdvcmtzLmNvbTsgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IE1hcnZlbGxfb2ZfcmVnX2luaXQg
ZnVuY3Rpb24NCg0KT24gV2VkLCBNYXkgMjQsIDIwMjMgYXQgMDg6Mzg6NDNBTSArMDIwMCwgSGVp
bmVyIEthbGx3ZWl0IHdyb3RlOg0KPiBPbiAyNC4wNS4yMDIzIDA4OjEzLCBHZW5ldmlldmUgQ2hh
biB3cm90ZToNCj4gPiArKw0KPiA+IA0KPiA+IEhpIEhlaW5lciwNCj4gPiANCj4gPiDCoA0KPiA+
IA0KPiA+IEhvcGUgeW914oCZcmUgZG9pbmcgd2VsbC4gSSBhbSBHZW5ldmlldmUgQ2hhbiwgYSBs
aW51eCBqdW5pb3Igc29mdHdhcmUgZGV2ZWxvcGVyIGZvciBSSVNDLVYgYmFzZWQgcHJvY2Vzc29y
LiBBcyBtZW50aW9uZWQgaW4gdGhlIGVtYWlsIHRocmVhZCBiZWxvdywgSSBoYXZlIGNhbWUgYWNy
b3NzIGEgcG9zc2libGUgaXNzdWUgd2hlbiBhdHRlbXB0aW5nIHRvIGlzc3VlIHJlZy1pbml0IG9u
dG8gUGFnZSAwIFJlZyA0LCBpbnZvbHZpbmcgYWR2ZXJ0aXNlbWVudCByZWdpc3RlciBvZiBQSFku
IEkgaGF2ZSBzdGF0ZWQgdGhlIG9ic2VydmF0aW9uIGFuZCB0aGUgcm9vdCBjYXVzZSBhbmQgcG9z
c2libGUgc29sdXRpb24uIFdvdWxkIGxpa2UgdG8gYXNrIGlmIHRoaXMgcHJvcG9zZWQgc29sdXRp
b24gaXMgcHJvYmFibGUgYW5kIEkgY291bGQgc3VibWl0IGEgcGF0Y2ggZm9yIHRoaXM/DQo+ID4g
DQo+IA0KPiBQbGVhc2UgYWRkcmVzcyBhbGwgcGh5bGliIG1haW50YWluZXJzIGFuZCB0aGUgbmV0
ZGV2IG1haWxpbmcgbGlzdC4NCj4gDQo+IFlvdSBzaG91bGQgc3RhcnQgd2l0aCBleHBsYWluaW5n
IHdoeSB5b3Ugd2FudCB0byBzZXQgdGhlc2UgcmVnaXN0ZXJzLCANCj4gYW5kIHdoeSB2aWEgZGV2
aWNlIHRyZWUuIFRoZXJlIHNob3VsZCBuZXZlciBiZSB0aGUgbmVlZCB0byBtYW51YWxseSANCj4g
ZmlkZGxlIHdpdGggQzIyIHN0YW5kYXJkIHJlZ2lzdGVycyB2aWEgZGV2aWNlIHRyZWUuDQo+IA0K
PiBJZiB5b3UgbmVlZCBhIHNwZWNpZmljIHJlZ2lzdGVyIGluaXRpYWxpemF0aW9uIGZvciBhIHBh
cnRpY3VsYXIgUEhZLCANCj4gdGhlbiB0aGUgY29uZmlnX2luaXQgY2FsbGJhY2sgb2YgdGhlIFBI
WSBkcml2ZXIgdHlwaWNhbGx5IGlzIHRoZSByaWdodCANCj4gcGxhY2UuDQo+IA0KPiBBbmQgbm8s
IGdlbmVyaWMgY29kZSBzaG91bGQgbm90IHF1ZXJ5IHZlbmRvci1zcGVjaWZpYyBEVCBwcm9wZXJ0
aWVzLg0KDQpUbyBHZW5ldmlldmUgQ2hhbi4uLg0KDQpQYWdlIDAgcmVnaXN0ZXIgNCBpcyBhIHJl
Z2lzdGVyIHRoYXQgaXMgbWFuYWdlZCBieSB0aGUgcGh5bGliIGNvZGUgb24gYmVoYWxmIG9mIHRo
ZSBuZXR3b3JrIGRyaXZlci4gQXR0ZW1wdGluZyB0byBjb25maWd1cmluZyBpdCAob3IgYW55IHJl
Z2lzdGVyIG1hbmFnZWQgYnkgcGh5bGliLCBlLmcuIGZvciBhZHZlcnRpc2VtZW50KSB2aWEgdGhl
IG9mX3JlZ19pbml0IHdpbGwgbm90IHdvcmsgYXMgcGh5bGliIHdpbGwgb3ZlcndyaXRlIGl0LiBE
b2luZyBzbyBpcyBpbnRlbmRlZCBub3QgdG8gd29yaywgaXNuJ3Qgc3VwcG9ydGVkLCBhbmQgYW55
IHZhbHVlIHdyaXR0ZW4gd2lsbCBiZSBvdmVyd3JpdHRlbiBieSBwaHlsaWIgb3IgdGhlIFBIWSBk
cml2ZXIuDQoNCklmIHlvdSB3aXNoIHRvIGNoYW5nZSB0aGUgYWR2ZXJ0aXNlbWVudCwgdGhhdCBo
YXMgdG8gYmUgZG9uZSB2aWEgdGhlICJldGh0b29sIiB1c2Vyc3BhY2UgdXRpbGl0eS4NCg0KLS0N
ClJNSydzIFBhdGNoIHN5c3RlbTogaHR0cHM6Ly93d3cuYXJtbGludXgub3JnLnVrL2RldmVsb3Bl
ci9wYXRjaGVzLw0KRlRUUCBpcyBoZXJlISA4ME1icHMgZG93biAxME1icHMgdXAuIERlY2VudCBj
b25uZWN0aXZpdHkgYXQgbGFzdCENCg==

