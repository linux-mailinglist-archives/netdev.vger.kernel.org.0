Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A431ADC47
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 13:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgDQLfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 07:35:47 -0400
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:60896
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730304AbgDQLfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 07:35:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9Qsr/gYr1K0zaafvX9z4+ua6MME6v1bepJzqJTYAVCKGtlCTriCY2a0mu/zd6uRsXAIbM5PDsibbKzrYI4O1gJ9RUSm8hU3ZEPf82QyQyRZd7Ng2pfh4vYtw4yqwC2PiPSFYl6aAP1KfVcHfIPViEhwvRy7hhHqLS4mZkyEHCn8jhyncTHDX+LpSZSUgO0yeSJiG2tUcWcKfwReTtRPf1R6L6LkSyZrHVyDI5aGhdmgmotHENYivsKByu7/tQjbXC9u80gA1oviCih3Rkp9RJVquwUj59+X92YmhYVBmhW0xSw4DS5Scq3GKW7coqDxgJ/TxN2JH9FHPRvffVLmMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoR9T+KK7DG6/DoWfQDHId75z0aCaTFW+5EGh/oKZmo=;
 b=jVNLGn4orh3dWLW2lrPuc0JViJU77kCGexQT9Xa7m/zE5K10uxSL1VmvVhM3H7T2ZewmmzpgvAh38lH8fUtpWAummimhNJSuf5WD+D9eGEc24BT3IuPi+BfUUeF8vv7TmKpSkimGYG4wPH2fuaz7mw4VtIwjojksb6NTCe3k2S5HKL9Q71oKrFPsk5bBKbeywhQ/4oyHWwOJY+Q8kwbm9HHXwz0q5+AFZSMZDuWrmR2a0fvS3v4uAaYL2X+RCPcvQhuYElmfkUp7C7dsbDJVX29aXA4I4UHdgC5OaZstjnuJOt5KngBBI45SbG6bTPUHRygVoMdmWKzYZ+kb2k68HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoR9T+KK7DG6/DoWfQDHId75z0aCaTFW+5EGh/oKZmo=;
 b=SCCEuhQk+5hHitQAS+af/FI3AIsjLK5Fobs+1lrU+2knzSU990/d7SQ8sn4ZvpjMKm+0qXxKMfuoYwYZsUvkXP1vxtHhTfDf9FsrjiZDMlUexMrFRyV1sEly+EPMka3VKgGgxR/b/cF7FzxHJB9zHidn8sCmjZIHoeLJU3kor48=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5837.eurprd05.prod.outlook.com (2603:10a6:803:ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20; Fri, 17 Apr
 2020 11:35:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 11:35:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "arnd@arndb.de" <arnd@arndb.de>
CC:     "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "leon@kernel.org" <leon@kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Thread-Topic: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Thread-Index: AQHWFFU+GtgmZSAXzkWfdBAfhtrsbqh9HDQAgAATvAA=
Date:   Fri, 17 Apr 2020 11:35:40 +0000
Message-ID: <f6f8ff1119123f920d1af5203a04acd7d13f6d90.camel@mellanox.com>
References: <20200417011146.83973-1-saeedm@mellanox.com>
         <CAK8P3a2LXR1pHoid7F69Q6VZp4E0g-Fcdt03PaGdebxWpguexw@mail.gmail.com>
In-Reply-To: <CAK8P3a2LXR1pHoid7F69Q6VZp4E0g-Fcdt03PaGdebxWpguexw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ccdae927-76ea-44d7-60a0-08d7e2c374e6
x-ms-traffictypediagnostic: VI1PR05MB5837:
x-microsoft-antispam-prvs: <VI1PR05MB583710D49EDB34F811377675BED90@VI1PR05MB5837.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(6506007)(86362001)(53546011)(6916009)(316002)(5660300002)(54906003)(71200400001)(966005)(6512007)(478600001)(8936002)(6486002)(7416002)(2906002)(91956017)(36756003)(186003)(4326008)(26005)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(2616005)(81156014)(8676002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vVU5C7oKcxvzOn8wqF1xfgdY/mYScem4AsPR0YrbycS81RxnPvUFb7gHqORt2gCQuN6UKMVDYYm3dUPJzv2hfp7ufMOgcjTF+SoUKE593MeRcVOCipyfYSfOmSNdG6iZbnvwZUtqoLYFRaxNXml9ZMXqy1EllK9Z5S1xv2qpfHeyOr7pokqccNOFNGQwHqri2ZCiYcmqCimQKT/k4mTWegzkJ/HoLbqLs16T99UZTVxScD5lcY0TEqx+zV5ndh1ra5aCaBtmy/UeX5NCJm4U0VMBfx0rWLTARmlF89wTwb3Olmb60FbUC6CeC/E61uWDRo1uSky9/UYhqSfgN4PMAk/66QNp9mh/V4JDS19DKIIwuQLwiU0Jie+tacBHqQeelgoyVOzILrTkFJelK+Y9qsyIRUqCQm6sSB+KDLXGMadUFBfJmGdI60DgNVmEFUdM+yOLlCU9bJd+f7mmiR1QZA0o25auA2X5pDj/bCQ+r6pccSh0YwNV0ozw8KfXUNQ9LTX59NMwKe4yNEqpSGNVUw==
x-ms-exchange-antispam-messagedata: YgAAoWvvc0YiDBYTdlKYHZmVt40Ly6pOMmpDTXAX3awBm2+jxas6B+V4iyLpSgugqxr/qfRamYPhJLwY3xdpwfjuKx916OdQT5/IJCi6T3PfV0u5U++LPyruSl31sL7Th35wOrf69S/ukVgVUc5HNw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <14163460FA14EA42913FD2A51FFF5908@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccdae927-76ea-44d7-60a0-08d7e2c374e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 11:35:40.2250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dr5Z0t1pvCPz8n4x0d95j4YgIYIhAaUEwYkaYHtPXi3jsa0AHMQ4QKIWhWfqri+58HM3WimGEJaD+4WWP07kJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5837
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTE3IGF0IDEyOjI0ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBPbiBGcmksIEFwciAxNywgMjAyMCBhdCAzOjEyIEFNIFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KPiB3cm90ZToNCj4gPiBEdWUgdG8gdGhlIGNoYW5nZXMgdG8gdGhlIHNl
bWFudGljcyBvZiBpbXBseSBrZXl3b3JkIFsxXSwgd2hpY2ggbm93DQo+ID4gZG9lc24ndCBmb3Jj
ZSBhbnkgY29uZmlnIG9wdGlvbnMgdG8gdGhlIGltcGxpZWQgY29uZmlncyBhbnkgbW9yZS4NCj4g
PiANCj4gPiBBIG1vZHVsZSAoRk9PKSB0aGF0IGhhcyBhIHdlYWsgZGVwZW5kZW5jeSBvbiBzb21l
IG90aGVyIG1vZHVsZXMNCj4gPiAoQkFSKQ0KPiA+IGlzIG5vdyBicm9rZW4gaWYgaXQgd2FzIHVz
aW5nIGltcGx5IHRvIGZvcmNlIGRlcGVuZGVuY3kNCj4gPiByZXN0cmljdGlvbnMuDQo+ID4gZS5n
LjogRk9PIG5lZWRzIEJBUiB0byBiZSByZWFjaGFibGUsIGVzcGVjaWFsbHkgd2hlbiBGT089eSBh
bmQNCj4gPiBCQVI9bS4NCj4gPiBXaGljaCBtaWdodCBub3cgaW50cm9kdWNlIGJ1aWxkL2xpbmsg
ZXJyb3JzLg0KPiA+IA0KPiA+IFRoZXJlIGFyZSB0d28gb3B0aW9ucyB0byBzb2x2ZSB0aGlzOg0K
PiA+IDEuIHVzZSBJU19SRUFDSEFCTEUoQkFSKSwgZXZlcnl3aGVyZSBCQVIgaXMgcmVmZXJlbmNl
ZCBpbnNpZGUgRk9PLg0KPiA+IDIuIGluIEZPTydzIEtjb25maWcgYWRkOiBkZXBlbmRzIG9uIChC
QVIgfHwgIUJBUikNCj4gPiANCj4gPiBUaGUgZmlyc3Qgb3B0aW9uIGlzIG5vdCBkZXNpcmFibGUs
IGFuZCB3aWxsIGxlYXZlIHRoZSB1c2VyIGNvbmZ1c2VkDQo+ID4gd2hlbg0KPiA+IHNldHRpbmcg
Rk9PPXkgYW5kIEJBUj1tLCBGT08gd2lsbCBuZXZlciByZWFjaCBCQVIgZXZlbiB0aG91Z2ggYm90
aA0KPiA+IGFyZQ0KPiA+IGNvbXBpbGVkLg0KPiA+IA0KPiA+IFRoZSAybmQgb25lIGlzIHRoZSBw
cmVmZXJyZWQgYXBwcm9hY2gsIGFuZCB3aWxsIGd1YXJhbnRlZSBCQVIgaXMNCj4gPiBhbHdheXMN
Cj4gPiByZWFjaGFibGUgYnkgRk9PIGlmIGJvdGggYXJlIGNvbXBpbGVkLiBCdXQsIChCQVIgfHwg
IUJBUikgaXMgcmVhbGx5DQo+ID4gY29uZnVzaW5nIGZvciB0aG9zZSB3aG8gZG9uJ3QgcmVhbGx5
IGdldCBob3cga2NvbmZpZyB0cmlzdGF0ZQ0KPiA+IGFyaXRobWV0aWNzDQo+ID4gd29yay4NCj4g
PiANCj4gPiBUbyBzb2x2ZSB0aGlzIGFuZCBoaWRlIHRoaXMgd2VpcmQgZXhwcmVzc2lvbiBhbmQg
dG8gYXZvaWQNCj4gPiByZXBldGl0aW9uDQo+ID4gYWNyb3NzIHRoZSB0cmVlLCB3ZSBpbnRyb2R1
Y2UgbmV3IGtleXdvcmQgInVzZXMiIHRvIHRoZSBLY29uZmlnDQo+ID4gb3B0aW9ucw0KPiA+IGZh
bWlseS4NCj4gPiANCj4gPiB1c2VzIEJBUjoNCj4gPiBFcXVpdmFsZW50IHRvOiBkZXBlbmRzIG9u
IHN5bWJvbCB8fCAhc3ltYm9sDQo+ID4gU2VtYW50aWNhbGx5IGl0IG1lYW5zLCBpZiBGT08gaXMg
ZW5hYmxlZCAoeS9tKSBhbmQgaGFzIHRoZSBvcHRpb246DQo+ID4gdXNlcyBCQVIsIG1ha2Ugc3Vy
ZSBpdCBjYW4gcmVhY2gvdXNlIEJBUiB3aGVuIHBvc3NpYmxlLg0KPiA+IA0KPiA+IEZvciBleGFt
cGxlOiBpZiBGT089eSBhbmQgQkFSPW0sIEZPTyB3aWxsIGJlIGZvcmNlZCB0byBtLg0KPiA+IA0K
PiA+IFsxXSANCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1kb2MvMjAyMDAzMDIw
NjIzNDAuMjE0NTMtMS1tYXNhaGlyb3lAa2VybmVsLm9yZy8NCj4gDQo+IFRoYW5rcyBhIGxvdCBm
b3IgZ2V0dGluZyB0aGlzIGRvbmUuIEkndmUgdHJpZWQgaXQgb3V0IG9uIG15DQo+IHJhbmRjb25m
aWcNCj4gYnVpbGQgdHJlZQ0KPiBhbmQgY2FuIGNvbmZpcm0gdGhhdCB0aGlzIHdvcmtzIHRvZ2V0
aGVyIHdpdGggeW91ciBzZWNvbmQgcGF0Y2ggdG8NCj4gYWRkcmVzcyB0aGUNCj4gc3BlY2lmaWMg
TUxYNSBwcm9ibGVtLg0KPiANCj4gSSBhbHNvIHRyaWVkIG91dCByZXBsYWNpbmcgYWxsIG90aGVy
IGluc3RhbmNlcyBvZiAnZGVwZW5kcyBvbiBGT08gfHwNCj4gIUZPTycsIHVzaW5nDQo+IHRoaXMg
b25lbGluZSBzY3JpcHQ6DQo+IA0KPiBnaXQgbHMtZmlsZXMgfCBncmVwIEtjb25maWcgfCAgeGFy
Z3Mgc2VkIC1pDQo+ICdzOmRlcGVuZHMub24uXChbQS1aMC05X2Etel1cK1wpIHx8IFwoXDEgXD89
IFw/blx8IVwxXCk6dXNlcyBcMTonDQo+IA0KPiBVbmZvcnR1bmF0ZWx5LCB0aGlzIGltbWVkaWF0
ZWx5IGNyYXNoZXMgd2l0aDoNCj4gDQo+ICQgbWFrZSAtc2tqMzANCj4gaG93IHRvIGZyZWUgdHlw
ZSAwPw0KPiBkb3VibGUgZnJlZSBvciBjb3JydXB0aW9uIChmYXN0dG9wKQ0KPiBtYWtlWzZdOiAq
KiogWy9naXQvYXJtLXNvYy9zY3JpcHRzL2tjb25maWcvTWFrZWZpbGU6NzE6IG9sZGRlZmNvbmZp
Z10NCj4gQWJvcnRlZCAoY29yZSBkdW1wZWQpDQo+IG1ha2VbNV06ICoqKiBbL2dpdC9hcm0tc29j
L01ha2VmaWxlOjU4Nzogb2xkZGVmY29uZmlnXSBFcnJvciAyDQo+IG1ha2VbNF06ICoqKiBbL2dp
dC9hcm0tc29jL3NjcmlwdHMva2NvbmZpZy9NYWtlZmlsZTo5NToNCj4gYWxscmFuZG9tLmNvbmZp
Z10gRXJyb3IgMg0KPiBtYWtlWzNdOiAqKiogWy9naXQvYXJtLXNvYy9NYWtlZmlsZTo1ODc6IGFs
bHJhbmRvbS5jb25maWddIEVycm9yIDINCj4gbWFrZVsyXTogKioqIFtNYWtlZmlsZToxODA6IHN1
Yi1tYWtlXSBFcnJvciAyDQo+IG1ha2VbMl06IFRhcmdldCAnYWxscmFuZG9tLmNvbmZpZycgbm90
IHJlbWFkZSBiZWNhdXNlIG9mIGVycm9ycy4NCj4gbWFrZVsxXTogKioqIFttYWtlZmlsZToxMjc6
IGFsbHJhbmRvbS5jb25maWddIEVycm9yIDINCj4gDQoNCj4gSXQncyBwcm9iYWJseSBlYXN5IHRv
IGZpeCwgYnV0IEkgZGlkIG5vdCBsb29rIGFueSBkZWVwZXIgaW50byB0aGUNCj4gYnVnLg0KPiAN
Cg0KQWhoLCBJIGtub3cgd2hhdCBpdCBpcywgaSBhbSBhbGxvY2F0aW5nIG9ubHkgb25lIGV4cHJl
c3Npb24gZm9yIHRoZSB0d28NCnN5bWJvbHMgKEZPTyB8fCAhRk9PKSAuLiBpbiB0aGUgcnVsZSBh
Y3Rpb24gaW4gcGFyc2VyLnksIGkgbXVzdA0KYWxsb2NhdGUgdHdvIGluZGl2aWR1YWwgaW5zdGFu
Y2VzIHBlciBlYWNoIG9mIHRoZSBGT08gYXBwZWFyYW5jZXMgLi4gDQoNCnNvbWV0aGluZyBsaWtl
Og0KDQpzdHJ1Y3QgZXhwciAqc3ltZXhwcjEgPSBleHByX2FsbG9jX3N5bWJvbCgkMik7DQpzdHJ1
Y3QgZXhwciAqc3ltZXhwcjIgPSBleHByX2FsbG9jX3N5bWJvbCgkMik7DQoJDQptZW51X2FkZF9k
ZXAoZXhwcl9hbGxvY190d28oRV9PUiwgc3ltZXhwcjEsIGV4cHJfYWxsb2Nfb25lKEVfTk9ULA0K
c3ltZXhwcjIpKSk7DQoNCg0KVGhhbmtzIEFybmQgZm9yIHRlc3RpbmcgdGhpcyAhIEkgd2lsbCB0
ZXN0IHRoaXMgYW5kIHNlbmQgVjIgbGF0ZXIuDQo=
