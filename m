Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F321BC054
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 15:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgD1NzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 09:55:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:10448 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbgD1NzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 09:55:25 -0400
IronPort-SDR: Q+qI07rxoJcjyj+NDc3yS6kQuVSOYG4Ca1WpUn2aKRZUEdy1R+Y/+5K7xA+D1Ht7fAJgDIPyAT
 +ocBrjjWXHkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 06:55:24 -0700
IronPort-SDR: UqdrexDZQzQ8E1+QY/V3sPjHn0i3RBivOyEWQ7V3IFe5kfipMoXPMYWfAJeZhGb8akXJP9ur7O
 11OoiyRy/B9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,327,1583222400"; 
   d="scan'208";a="275844482"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 28 Apr 2020 06:55:23 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 28 Apr 2020 06:55:23 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 28 Apr 2020 06:55:23 -0700
Received: from shsmsx108.ccr.corp.intel.com ([169.254.8.7]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.129]) with mapi id 14.03.0439.000;
 Tue, 28 Apr 2020 21:55:19 +0800
From:   "Zhang, Rui" <rui.zhang@intel.com>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        "'linux-pm@vger.kernel.org'" <linux-pm@vger.kernel.org>
CC:     "'Rafael J . Wysocki'" <rjw@rjwysocki.net>,
        'Len Brown' <lenb@kernel.org>,
        'Jiri Pirko' <jiri@mellanox.com>,
        'Ido Schimmel' <idosch@mellanox.com>,
        "'David S . Miller'" <davem@davemloft.net>,
        'Peter Kaestle' <peter@piie.net>,
        'Darren Hart' <dvhart@infradead.org>,
        'Andy Shevchenko' <andy@infradead.org>,
        'Support Opensource' <support.opensource@diasemi.com>,
        'Daniel Lezcano' <daniel.lezcano@linaro.org>,
        'Amit Kucheria' <amit.kucheria@verdurent.com>,
        'Shawn Guo' <shawnguo@kernel.org>,
        'Sascha Hauer' <s.hauer@pengutronix.de>,
        'Pengutronix Kernel Team' <kernel@pengutronix.de>,
        'Fabio Estevam' <festevam@gmail.com>,
        'NXP Linux Team' <linux-imx@nxp.com>,
        'Heiko Stuebner' <heiko@sntech.de>,
        'Orson Zhai' <orsonzhai@gmail.com>,
        'Baolin Wang' <baolin.wang7@gmail.com>,
        'Chunyan Zhang' <zhang.lyra@gmail.com>,
        "'linux-acpi@vger.kernel.org'" <linux-acpi@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'platform-driver-x86@vger.kernel.org'" 
        <platform-driver-x86@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
        <linux-arm-kernel@lists.infradead.org>,
        "'kernel@collabora.com'" <kernel@collabora.com>,
        'Barlomiej Zolnierkiewicz' <b.zolnierkie@samsung.com>
Subject: RE: [PATCH v3 2/2] thermal: core: Stop polling DISABLED thermal
 devices
Thread-Topic: [PATCH v3 2/2] thermal: core: Stop polling DISABLED thermal
 devices
Thread-Index: AQHWGZBG4VqXwdwSNk6/8EtFFGs1V6iH9bQAgAUTBvD//8MJgIAByd6w
Date:   Tue, 28 Apr 2020 13:55:19 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926377CFA057@SHSMSX108.ccr.corp.intel.com>
References: <a3998ad2-19bc-0893-a10d-2bb5adf7d99f@samsung.com>
 <20200423165705.13585-1-andrzej.p@collabora.com>
 <20200423165705.13585-3-andrzej.p@collabora.com>
 <744357E9AAD1214791ACBA4B0B90926377CF60E3@SHSMSX108.ccr.corp.intel.com>
 <744357E9AAD1214791ACBA4B0B90926377CF9A10@SHSMSX108.ccr.corp.intel.com>
 <da9f0547-226d-71cf-f508-f4669fb2f5c2@collabora.com>
In-Reply-To: <da9f0547-226d-71cf-f508-f4669fb2f5c2@collabora.com>
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

VGhlIHBhdGNoIGlzIG9uIHRvcCBvZiB0aGlzIHBhdGNoIHNldC4NClJ1biBpbnRvIGFuIGlzc3Vl
IGR1cmluZyB0ZXN0IHRvZGF5LCB3aWxsIHNlbmQgb3V0IGFmdGVyIHRoZSBpc3N1ZSByZXNvbHZl
ZC4NCg0KVGhhbmtzLA0KcnVpDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IGxpbnV4LWFjcGktb3duZXJAdmdlci5rZXJuZWwub3JnIDxsaW51eC1hY3BpLW93bmVyQHZnZXIu
a2VybmVsLm9yZz4NCj4gT24gQmVoYWxmIE9mIEFuZHJ6ZWogUGlldHJhc2lld2ljeg0KPiBTZW50
OiBUdWVzZGF5LCBBcHJpbCAyOCwgMjAyMCAyOjM1IEFNDQo+IFRvOiBaaGFuZywgUnVpIDxydWku
emhhbmdAaW50ZWwuY29tPjsgJ2xpbnV4LXBtQHZnZXIua2VybmVsLm9yZycgPGxpbnV4LQ0KPiBw
bUB2Z2VyLmtlcm5lbC5vcmc+DQo+IENjOiAnUmFmYWVsIEogLiBXeXNvY2tpJyA8cmp3QHJqd3lz
b2NraS5uZXQ+OyAnTGVuIEJyb3duJyA8bGVuYkBrZXJuZWwub3JnPjsNCj4gJ0ppcmkgUGlya28n
IDxqaXJpQG1lbGxhbm94LmNvbT47ICdJZG8gU2NoaW1tZWwnIDxpZG9zY2hAbWVsbGFub3guY29t
PjsNCj4gJ0RhdmlkIFMgLiBNaWxsZXInIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgJ1BldGVyIEth
ZXN0bGUnIDxwZXRlckBwaWllLm5ldD47DQo+ICdEYXJyZW4gSGFydCcgPGR2aGFydEBpbmZyYWRl
YWQub3JnPjsgJ0FuZHkgU2hldmNoZW5rbycNCj4gPGFuZHlAaW5mcmFkZWFkLm9yZz47ICdTdXBw
b3J0IE9wZW5zb3VyY2UnDQo+IDxzdXBwb3J0Lm9wZW5zb3VyY2VAZGlhc2VtaS5jb20+OyAnRGFu
aWVsIExlemNhbm8nDQo+IDxkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnPjsgJ0FtaXQgS3VjaGVy
aWEnDQo+IDxhbWl0Lmt1Y2hlcmlhQHZlcmR1cmVudC5jb20+OyAnU2hhd24gR3VvJyA8c2hhd25n
dW9Aa2VybmVsLm9yZz47DQo+ICdTYXNjaGEgSGF1ZXInIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRl
PjsgJ1Blbmd1dHJvbml4IEtlcm5lbCBUZWFtJw0KPiA8a2VybmVsQHBlbmd1dHJvbml4LmRlPjsg
J0ZhYmlvIEVzdGV2YW0nIDxmZXN0ZXZhbUBnbWFpbC5jb20+OyAnTlhQDQo+IExpbnV4IFRlYW0n
IDxsaW51eC1pbXhAbnhwLmNvbT47ICdIZWlrbyBTdHVlYm5lcicgPGhlaWtvQHNudGVjaC5kZT47
DQo+ICdPcnNvbiBaaGFpJyA8b3Jzb256aGFpQGdtYWlsLmNvbT47ICdCYW9saW4gV2FuZycNCj4g
PGJhb2xpbi53YW5nN0BnbWFpbC5jb20+OyAnQ2h1bnlhbiBaaGFuZycgPHpoYW5nLmx5cmFAZ21h
aWwuY29tPjsNCj4gJ2xpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnJyA8bGludXgtYWNwaUB2Z2Vy
Lmtlcm5lbC5vcmc+Ow0KPiAnbmV0ZGV2QHZnZXIua2VybmVsLm9yZycgPG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc+OyAncGxhdGZvcm0tZHJpdmVyLQ0KPiB4ODZAdmdlci5rZXJuZWwub3JnJyA8cGxh
dGZvcm0tZHJpdmVyLXg4NkB2Z2VyLmtlcm5lbC5vcmc+OyAnbGludXgtYXJtLQ0KPiBrZXJuZWxA
bGlzdHMuaW5mcmFkZWFkLm9yZycgPGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9y
Zz47DQo+ICdrZXJuZWxAY29sbGFib3JhLmNvbScgPGtlcm5lbEBjb2xsYWJvcmEuY29tPjsgJ0Jh
cmxvbWllaiBab2xuaWVya2lld2ljeicNCj4gPGIuem9sbmllcmtpZUBzYW1zdW5nLmNvbT4NCj4g
U3ViamVjdDogUmU6IFtQQVRDSCB2MyAyLzJdIHRoZXJtYWw6IGNvcmU6IFN0b3AgcG9sbGluZyBE
SVNBQkxFRCB0aGVybWFsDQo+IGRldmljZXMNCj4gSW1wb3J0YW5jZTogSGlnaA0KPiANCj4gSGks
DQo+IA0KPiBXIGRuaXUgMjcuMDQuMjAyMCBvwqAxNjoyMCwgWmhhbmcsIFJ1aSBwaXN6ZToNCj4g
Pg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFpoYW5n
LCBSdWkNCj4gPj4gU2VudDogRnJpZGF5LCBBcHJpbCAyNCwgMjAyMCA1OjAzIFBNDQo+ID4+IFRv
OiBBbmRyemVqIFBpZXRyYXNpZXdpY3ogPGFuZHJ6ZWoucEBjb2xsYWJvcmEuY29tPjsgbGludXgt
DQo+ID4+IHBtQHZnZXIua2VybmVsLm9yZw0KPiA+PiBDYzogUmFmYWVsIEogLiBXeXNvY2tpIDxy
andAcmp3eXNvY2tpLm5ldD47IExlbiBCcm93bg0KPiA+PiA8bGVuYkBrZXJuZWwub3JnPjsgSmly
aSBQaXJrbyA8amlyaUBtZWxsYW5veC5jb20+OyBJZG8gU2NoaW1tZWwNCj4gPj4gPGlkb3NjaEBt
ZWxsYW5veC5jb20+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4g
UGV0ZXINCj4gPj4gS2Flc3RsZSA8cGV0ZXJAcGlpZS5uZXQ+OyBEYXJyZW4gSGFydCA8ZHZoYXJ0
QGluZnJhZGVhZC5vcmc+OyBBbmR5DQo+ID4+IFNoZXZjaGVua28gPGFuZHlAaW5mcmFkZWFkLm9y
Zz47IFN1cHBvcnQgT3BlbnNvdXJjZQ0KPiA+PiA8c3VwcG9ydC5vcGVuc291cmNlQGRpYXNlbWku
Y29tPjsgRGFuaWVsIExlemNhbm8NCj4gPj4gPGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc+OyBB
bWl0IEt1Y2hlcmlhDQo+ID4+IDxhbWl0Lmt1Y2hlcmlhQHZlcmR1cmVudC5jb20+OyBTaGF3biBH
dW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+Ow0KPiA+PiBTYXNjaGEgSGF1ZXIgPHMuaGF1ZXJAcGVu
Z3V0cm9uaXguZGU+OyBQZW5ndXRyb25peCBLZXJuZWwgVGVhbQ0KPiA+PiA8a2VybmVsQHBlbmd1
dHJvbml4LmRlPjsgRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPjsgTlhQDQo+ID4+
IExpbnV4IFRlYW0gPGxpbnV4LWlteEBueHAuY29tPjsgSGVpa28gU3R1ZWJuZXIgPGhlaWtvQHNu
dGVjaC5kZT47DQo+ID4+IE9yc29uIFpoYWkgPG9yc29uemhhaUBnbWFpbC5jb20+OyBCYW9saW4g
V2FuZw0KPiA+PiA8YmFvbGluLndhbmc3QGdtYWlsLmNvbT47IENodW55YW4gWmhhbmcgPHpoYW5n
Lmx5cmFAZ21haWwuY29tPjsNCj4gPj4gbGludXgtIGFjcGlAdmdlci5rZXJuZWwub3JnOyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBwbGF0Zm9ybS1kcml2ZXItDQo+ID4+IHg4NkB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gPj4ga2VybmVs
QGNvbGxhYm9yYS5jb207IEJhcmxvbWllaiBab2xuaWVya2lld2ljeg0KPiA+PiA8Yi56b2xuaWVy
a2llQHNhbXN1bmcuY29tPg0KPiA+PiBTdWJqZWN0OiBSRTogW1BBVENIIHYzIDIvMl0gdGhlcm1h
bDogY29yZTogU3RvcCBwb2xsaW5nIERJU0FCTEVEDQo+ID4+IHRoZXJtYWwgZGV2aWNlcw0KPiA+
Pg0KPiA+PiBIaSwgQW5kcnplaiwNCj4gPj4NCj4gPj4gVGhhbmtzIGZvciB0aGUgcGF0Y2hlcy4g
TXkgTGludXggbGFwdG9wIHdhcyBicm9rZW4gYW5kIHdvbid0IGdldA0KPiA+PiBmaXhlZCB0aWxs
IG5leHQgd2Vlaywgc28gSSBtYXkgbG9zdCBzb21lIG9mIHRoZSBkaXNjdXNzaW9ucyBwcmV2aW91
c2x5Lg0KPiA+Pg0KPiA+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4+IEZyb206
IEFuZHJ6ZWogUGlldHJhc2lld2ljeiA8YW5kcnplai5wQGNvbGxhYm9yYS5jb20+DQo+ID4+PiBT
ZW50OiBGcmlkYXksIEFwcmlsIDI0LCAyMDIwIDEyOjU3IEFNDQo+ID4+PiBUbzogbGludXgtcG1A
dmdlci5rZXJuZWwub3JnDQo+ID4+PiBDYzogWmhhbmcsIFJ1aSA8cnVpLnpoYW5nQGludGVsLmNv
bT47IFJhZmFlbCBKIC4gV3lzb2NraQ0KPiA+Pj4gPHJqd0Byand5c29ja2kubmV0PjsgTGVuIEJy
b3duIDxsZW5iQGtlcm5lbC5vcmc+OyBKaXJpIFBpcmtvDQo+ID4+PiA8amlyaUBtZWxsYW5veC5j
b20+OyBJZG8gU2NoaW1tZWwgPGlkb3NjaEBtZWxsYW5veC5jb20+OyBEYXZpZCBTIC4NCj4gPj4+
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFBldGVyIEthZXN0bGUgPHBldGVyQHBpaWUu
bmV0PjsNCj4gRGFycmVuDQo+ID4+PiBIYXJ0IDxkdmhhcnRAaW5mcmFkZWFkLm9yZz47IEFuZHkg
U2hldmNoZW5rbyA8YW5keUBpbmZyYWRlYWQub3JnPjsNCj4gPj4+IFN1cHBvcnQgT3BlbnNvdXJj
ZSA8c3VwcG9ydC5vcGVuc291cmNlQGRpYXNlbWkuY29tPjsgRGFuaWVsDQo+IExlemNhbm8NCj4g
Pj4+IDxkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnPjsgQW1pdCBLdWNoZXJpYQ0KPiA+Pj4gPGFt
aXQua3VjaGVyaWFAdmVyZHVyZW50LmNvbT47IFNoYXduIEd1byA8c2hhd25ndW9Aa2VybmVsLm9y
Zz47DQo+ID4+IFNhc2NoYQ0KPiA+Pj4gSGF1ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU+OyBQ
ZW5ndXRyb25peCBLZXJuZWwgVGVhbQ0KPiA+Pj4gPGtlcm5lbEBwZW5ndXRyb25peC5kZT47IEZh
YmlvIEVzdGV2YW0gPGZlc3RldmFtQGdtYWlsLmNvbT47IE5YUA0KPiA+PiBMaW51eA0KPiA+Pj4g
VGVhbSA8bGludXgtaW14QG54cC5jb20+OyBIZWlrbyBTdHVlYm5lciA8aGVpa29Ac250ZWNoLmRl
PjsNCj4gT3Jzb24NCj4gPj4gWmhhaQ0KPiA+Pj4gPG9yc29uemhhaUBnbWFpbC5jb20+OyBCYW9s
aW4gV2FuZyA8YmFvbGluLndhbmc3QGdtYWlsLmNvbT47DQo+ID4+IENodW55YW4NCj4gPj4+IFpo
YW5nIDx6aGFuZy5seXJhQGdtYWlsLmNvbT47IGxpbnV4LSBhY3BpQHZnZXIua2VybmVsLm9yZzsN
Cj4gPj4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHBsYXRmb3JtLWRyaXZlci0geDg2QHZnZXIu
a2VybmVsLm9yZzsNCj4gPj4+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsN
Cj4gPj4+IGtlcm5lbEBjb2xsYWJvcmEuY29tOyBBbmRyemVqIFBpZXRyYXNpZXdpY3oNCj4gPj4+
IDxhbmRyemVqLnBAY29sbGFib3JhLmNvbT47IEJhcmxvbWllaiBab2xuaWVya2lld2ljeg0KPiA+
Pj4gPGIuem9sbmllcmtpZUBzYW1zdW5nLmNvbT4NCj4gPj4+IFN1YmplY3Q6IFtQQVRDSCB2MyAy
LzJdIHRoZXJtYWw6IGNvcmU6IFN0b3AgcG9sbGluZyBESVNBQkxFRCB0aGVybWFsDQo+ID4+PiBk
ZXZpY2VzDQo+ID4+PiBJbXBvcnRhbmNlOiBIaWdoDQo+ID4+Pg0KPiA+Pj4gUG9sbGluZyBESVNB
QkxFRCBkZXZpY2VzIGlzIG5vdCBkZXNpcmVkLCBhcyBhbGwgc3VjaCAiZGlzYWJsZWQiDQo+ID4+
PiBkZXZpY2VzIGFyZSBtZWFudCB0byBiZSBoYW5kbGVkIGJ5IHVzZXJzcGFjZS4gVGhpcyBwYXRj
aCBpbnRyb2R1Y2VzDQo+ID4+PiBhbmQgdXNlcw0KPiA+Pj4gc2hvdWxkX3N0b3BfcG9sbGluZygp
IHRvIGRlY2lkZSB3aGV0aGVyIHRoZSBkZXZpY2Ugc2hvdWxkIGJlIHBvbGxlZA0KPiA+Pj4gb3IN
Cj4gPj4gbm90Lg0KPiA+Pj4NCj4gPj4gVGhhbmtzIGZvciB0aGUgZml4LCBhbmQgSU1PLCB0aGlz
IHJldmVhbCBzb21lIG1vcmUgcHJvYmxlbXMuDQo+ID4+IFNheSwgd2UgbmVlZCB0byBkZWZpbmUg
IkRJU0FCTEVEIiB0aGVybWFsIHpvbmUuDQo+ID4+IENhbiB3ZSByZWFkIHRoZSB0ZW1wZXJhdHVy
ZT8gQ2FuIHdlIHRydXN0IHRoZSB0cmlwIHBvaW50IHZhbHVlPw0KPiA+Pg0KPiA+PiBJTU8sIGEg
ZGlzYWJsZWQgdGhlcm1hbCB6b25lIGRvZXMgbm90IG1lYW4gaXQgaXMgaGFuZGxlZCBieQ0KPiA+
PiB1c2Vyc3BhY2UsIGJlY2F1c2UgdGhhdCBpcyB3aGF0IHRoZSB1c2Vyc3BhY2UgZ292ZXJub3Ig
ZGVzaWduZWQgZm9yLg0KPiA+PiBJbnN0ZWFkLCBpZiBhIHRoZXJtYWwgem9uZSBpcyBkaXNhYmxl
ZCwgaW4NCj4gPj4gdGhlcm1hbF96b25lX2RldmljZV91cGRhdGUoKSwgd2Ugc2hvdWxkIGJhc2lj
YWxseSBza2lwIGFsbCB0aGUgb3RoZXINCj4gb3BlcmF0aW9ucyBhcyB3ZWxsLg0KPiA+Pg0KPiA+
IEkgb3Zlcmxvb2tlZCB0aGUgbGFzdCBsaW5lIG9mIHRoZSBwYXRjaC4gU28NCj4gPiB0aGVybWFs
X3pvbmVfZGV2aWNlX3VwZGF0ZSgpIHJldHVybnMgaW1tZWRpYXRlbHkgaWYgdGhlIHRoZXJtYWwg
em9uZSBpcw0KPiBkaXNhYmxlZCwgcmlnaHQ/DQo+ID4NCj4gPiBCdXQgaG93IGNhbiB3ZSBzdG9w
IHBvbGxpbmcgaW4gdGhpcyBjYXNlPw0KPiANCj4gSXQgZG9lcyBzdG9wLiBIb3dldmVyLCBJIGlu
ZGVlZCBvYnNlcnZlIGFuIGV4dHJhIGNhbGwgdG8NCj4gdGhlcm1hbF96b25lX2RldmljZV91cGRh
dGUoKSBiZWZvcmUgaXQgZnVsbHkgc3RvcHMuDQo+IEkgdGhpbmsgd2hhdCBoYXBwZW5zIGlzIHRo
aXM6DQo+IA0KPiAtIHN0b3JpbmcgImRpc2FibGVkIiBpbiBtb2RlIGVuZHMgdXAgaW4gdGhlcm1h
bF96b25lX2RldmljZV9zZXRfbW9kZSgpLA0KPiB3aGljaCBjYWxscyBkcml2ZXIncyAtPnNldF9t
b2RlKCkgYW5kIHRoZW4gY2FsbHMNCj4gdGhlcm1hbF96b25lX2RldmljZV91cGRhdGUoKSwgd2hp
Y2ggcmV0dXJucyBpbW1lZGlhdGVseSBhbmQgZG9lcyBub3QNCj4gdG91Y2ggdGhlIHR6LT5wb2xs
X3F1ZXVlIGRlbGF5ZWQgd29yaw0KPiANCj4gLSB0aGVybWFsX3pvbmVfZGV2aWNlX3VwZGF0ZSgp
IGlzIGNhbGxlZCBmcm9tIHRoZSBkZWxheWVkIHdvcmsgd2hlbiBpdHMNCj4gdGltZSBjb21lcyBh
bmQgdGhpcyB0aW1lIGl0IGFsc28gcmV0dXJucyBpbW1lZGlhdGVseSwgbm90IG1vZGlmeWluZyB0
aGUgc2FpZA0KPiBkZWxheWVkIHdvcmssIHNvIHBvbGxpbmcgZWZmZWN0aXZlbHkgc3RvcHMgbm93
Lg0KPiANCj4gPiBUaGVyZSBpcyBubyBjaGFuY2UgdG8gY2FsbCBpbnRvIG1vbml0b3JfdGhlcm1h
bF96b25lKCkgaW4NCj4gPiB0aGVybWFsX3pvbmVfZGV2aWNlX3VwZGF0ZSgpLCBvciBkbyBJIG1p
c3Mgc29tZXRoaW5nPw0KPiANCj4gV2l0aG91dCB0aGUgbGFzdCAiaWYiIHN0YXRlbWVudCBpbiB0
aGlzIHBhdGNoIHBvbGxpbmcgc3RvcHMgd2l0aCB0aGUgZmlyc3QgY2FsbCB0bw0KPiB0aGVybWFs
X3pvbmVfZGV2aWNlX3VwZGF0ZSgpIGJlY2F1c2UgaXQgaW5kZWVkIGRpc2FibGVzIHRoZSBkZWxh
eWVkIHdvcmsuDQo+IA0KPiBTbyB5b3UgYXJlIHByb2JhYmx5IHJpZ2h0IC0gdGhhdCBsYXN0ICJp
ZiIgc2hvdWxkIG5vdCBiZSBpbnRyb2R1Y2VkLg0KPiANCj4gPg0KPiA+PiBJJ2xsIHRyeSB5b3Vy
IHBhdGNoZXMgYW5kIHByb2JhYmx5IG1ha2UgYW4gaW5jcmVtZW50YWwgcGF0Y2guDQo+ID4NCj4g
PiBJIGhhdmUgZmluaXNoZWQgYSBzbWFsbCBwYXRjaCBzZXQgdG8gaW1wcm92ZSB0aGlzIGJhc2Vk
IG9uIG15DQo+ID4gdW5kZXJzdGFuZGluZywgYW5kIHdpbGwgcG9zdCBpdCB0b21vcnJvdyBhZnRl
ciB0ZXN0aW5nLg0KPiA+DQo+IA0KPiBJcyB5b3VyIHNtYWxsIHBhdGNoc2V0IGJhc2VkIG9uIHRv
cCBvZiB0aGlzIHNlcmllcyBvciBpcyBpdCBhIGNvbXBsZXRlbHkNCj4gcmV3cml0dGVuIHZlcnNp
b24/DQo+IA0KPiBBbmRyemVqDQo=
