Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C79279F75
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgI0IBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:01:22 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:29854
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgI0IBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:01:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPExPl5otDODEhAu7p4KRjVyC5Me4idjywlJLFhU7UoPFPT94HMMFhicTzMr0Vm27kRTYfKknioZ5eLctRkjdB2Ond447BWHAbvh7zxnvrwympwlf9TGeTRwvqrq8zgxwVxSikrmk0XTA3etjRHe0apUoTiIz4lir18r59oDDnbNNpD/XUrPjR9+9SCPZLoHLV19odzrqScxAmuiAdPAquq9F99LsDzZ3nDkzELZT6v0AXTLsZR50Eiu82ovcXZHh9M78IgaTLBC7UJNAtzS+YO8xKzWE0v4SRNCRZyvRyjtF2lcn9qNwwp/5anFqz8I17qKSK8jCj9zouUV07Aw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWIrfHreQ3QJRoFC/iGra2zflKakM21DouLdR1xMyvM=;
 b=g/0xfiMQbyBOCXBXy0t7Q5m+wxunZU4xQ3QBBsFx6GbIKqRt/N8Ttzu6We9XDzWKg52rcTJy6nwttGlYW1uYkBSNHTDopEkpJnGEasp9nwHW170uBQZ7s9dKFGVhhNu5Gs6rjY0OKLjqCx3LwbIE8HHIejQMFDFdXnlHFWz7v17vuBT4Al6lp1ZgKRqJbEtlZASGNByXRxTgZJ7Vsv4RVRBynz7OHBnKAq7knMC6ZvRqJy6+2NoyMZ2LM8zkSlYsNOEExj7W2guMAzN3VPOTgWqz/0uZXZuJBSqENHXfbGHtPIeXZkjoBjHnKTVgaOGNEZXukYgtc3eJm2h4BFbyJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWIrfHreQ3QJRoFC/iGra2zflKakM21DouLdR1xMyvM=;
 b=f3qzuswDdXO/e6ADmN5rZcnlBtpsVYNDV2nVtFsp30gWqAOzj24xzdw+S74UF0/vtHNtdOGRbEwlV8OMxf9Khn1MbhP2JBAHOa4nrdhTP4IZMybiPugI7gWyVNfwQx1eMiQBNQuYe/kG2wjsWKQoakqny5ZOGc8CstQBxjtiJ0U=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Sun, 27 Sep
 2020 08:01:16 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 08:01:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Topic: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49QgAgAMfcAA=
Date:   Sun, 27 Sep 2020 08:01:16 +0000
Message-ID: <DB8PR04MB6795C88B839FE5083283E157E6340@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
In-Reply-To: <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 92f2bf2f-91fc-4484-55ce-08d862bb82dc
x-ms-traffictypediagnostic: DB7PR04MB4953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB49538A578649AC266FAA780EE6340@DB7PR04MB4953.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +1dKEfH9gkQlt/YGnb4a9iCTPLnlmDbDy7OB7B0638PBqNogKsFksxwr6cwxnUZiVmcGMJXR/pfaqx5z5mTGgBtvOJymJrHtupRwTvnEmhnEBQAFOjBS9OBzDHrOMAqbuuNwbeur7meONu+zCC7lJ7Cwb4MmFAmfJa03dEMdnx3u2hKDzjfvrB+qWZ4TZpmq+Raj+/IpLt/Qd3uMgaW09dMXdtPLZK19msEh9xKVduWrKOOVVwCdiTOyqwB2LUHrHAbaE+6o0IV+gCnzdgWFqflJwuVT+ETNDweFo4AyrpvGR8+Drb1o3xzTPl7b0ikiuDbzqx2ZKgBlWyVK2gGWRe3+Gi9KvWiDxyTWGUtb1UTI+Jp1NSamEDAwfH4Uhvam
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39850400004)(376002)(346002)(136003)(478600001)(54906003)(110136005)(6506007)(8676002)(33656002)(86362001)(316002)(71200400001)(8936002)(7696005)(52536014)(2906002)(76116006)(66556008)(64756008)(66446008)(66946007)(66476007)(4326008)(9686003)(26005)(83380400001)(53546011)(55016002)(5660300002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Ghk02pY/q2Lj4bNDYQMj0fCEF30RHuJHYYHsQzaMBOJ9fJG0oX+n8nsExtXhfpG7mHYN7mDzrdOiu6+37gRSRrvKbrdKCgxutLnhVV9OZM2uHJhhLmEnj0W8EdvspFTqqj5grxVjYh2NGOzsEH4rZEccs8/OIeWxpxMsRVt01l/+aPtAmt1cDmMAO9rqchnrytFNvnfyu5lp2AQwaUuLOGNKzPDzVYh+yBVaLTLwrFhdtfaJV5ZTBUmkyBcw85M7wwNeZNsq67m6kU71P8PsqScDYdcJh0F03br3qrePdg2CfLzNFt/ZBd/4ldeFz4IrFC5WctTRJtq3aFwp7nK8vrf2aEj4Yis4uKZGW6IbslcjJqC8SvZRdz5UaA+0OCkN/XBe4vF+yPoTygMWdOlU2RIQ2AoFxRqWD5t0JG69G+/69docX9SWbyJHPX6zkCmI8DBLq13kz1L4xgvxVCFYJSttNC7gwse5wc2vCNBDrKL2/hhAKxd3HgGxg682+P3HGe4QpRUmY5D2TrTqh0+I1GJHwd0LWwZS4osU3rCed0YmCKYft2RAoQl3bJWDBm/itaw/rgNSXAsX8IovKvwXG5QVmPsqMW9OG6OBRUDVmEkcyio6rBvrTz98EKkzQMEz70XTji6thnv9upxEJNke4g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f2bf2f-91fc-4484-55ce-08d862bb82dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 08:01:16.6212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZrxVaQ+TlsULnJvVpyaQH8TeDTh136cHyIvl96mFsvyzLtm6GwJEkr+XUp6jwcz7OWM9UmP7EEkR2AT6iXEVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXm
l6UgMTU6MjkNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBs
aW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBu
eHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxp
bnV4LWNhbi1uZXh0L2ZsZXhjYW4gMS80XSBjYW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxsIGZs
ZXhjYW4NCj4gbWVtb3J5IGZvciBFQ0MgZnVuY3Rpb24NCj4gDQo+IE9uIDkvMjUvMjAgNToxMCBQ
TSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IFRoZXJlIGlzIGEgTk9URSBhdCB0aGUgc2VjdGlv
biAiRGV0ZWN0aW9uIGFuZCBjb3JyZWN0aW9uIG9mIG1lbW9yeSBlcnJvcnMiOg0KPiANCj4gQ2Fu
IHlvdSBhZGQgYSByZWZlcmVuY2UgdG8gb25lIGRhdGFzaGVldCBpbmNsdWRpbmcgbmFtZSwgcmV2
aXNpb24gYW5kDQo+IHNlY3Rpb24/DQo+IA0KPiA+IEFsbCBGbGV4Q0FOIG1lbW9yeSBtdXN0IGJl
IGluaXRpYWxpemVkIGJlZm9yZSBzdGFydGluZyBpdHMgb3BlcmF0aW9uDQo+ID4gaW4gb3JkZXIg
dG8gaGF2ZSB0aGUgcGFyaXR5IGJpdHMgaW4gbWVtb3J5IHByb3Blcmx5IHVwZGF0ZWQuDQo+ID4g
Q1RSTDJbV1JNRlJaXSBncmFudHMgd3JpdGUgYWNjZXNzIHRvIGFsbCBtZW1vcnkgcG9zaXRpb25z
IHRoYXQgcmVxdWlyZQ0KPiA+IGluaXRpYWxpemF0aW9uLCByYW5naW5nIGZyb20gMHgwODAgdG8g
MHhBREYgYW5kIGZyb20gMHhGMjggdG8gMHhGRkYNCj4gPiB3aGVuIHRoZSBDQU4gRkQgZmVhdHVy
ZSBpcyBlbmFibGVkLiBUaGUgUlhNR01BU0ssIFJYMTRNQVNLLA0KPiBSWDE1TUFTSywNCj4gPiBh
bmQgUlhGR01BU0sgcmVnaXN0ZXJzIG5lZWQgdG8gYmUgaW5pdGlhbGl6ZWQgYXMgd2VsbC4gTUNS
W1JGRU5dIG11c3Qgbm90DQo+IGJlIHNldCBkdXJpbmcgbWVtb3J5IGluaXRpYWxpemF0aW9uLg0K
PiA+DQo+ID4gTWVtb3J5IHJhbmdlIGZyb20gMHgwODAgdG8gMHhBREYsIHRoZXJlIGFyZSByZXNl
cnZlZCBtZW1vcnkNCj4gPiAodW5pbXBsZW1lbnRlZCBieSBoYXJkd2FyZSksIHRoZXNlIG1lbW9y
eSBjYW4gYmUgaW5pdGlhbGl6ZWQgb3Igbm90Lg0KPiA+DQo+ID4gSW5pdGlhbGl6ZSBhbGwgRmxl
eENBTiBtZW1vcnkgYmVmb3JlIGFjY2Vzc2luZyB0aGVtLCBvdGhlcndpc2UsIG1lbW9yeQ0KPiA+
IGVycm9ycyBtYXkgYmUgZGV0ZWN0ZWQuIFRoZSBpbnRlcm5hbCByZWdpb24gY2Fubm90IGJlIGlu
aXRpYWxpemVkIHdoZW4NCj4gPiB0aGUgaGFyZHdhcmUgZG9lcyBub3Qgc3VwcG9ydCBFQ0MuDQo+
ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAu
Y29tPg0KPiA+ICsJcmVnX2N0cmwyID0gcHJpdi0+cmVhZCgmcmVncy0+Y3RybDIpOw0KPiA+ICsJ
cmVnX2N0cmwyIHw9IEZMRVhDQU5fQ1RSTDJfV1JNRlJaOw0KPiA+ICsJcHJpdi0+d3JpdGUocmVn
X2N0cmwyLCAmcmVncy0+Y3RybDIpOw0KPiA+ICsNCj4gPiArCS8qIGluaXRpYWxpemUgTUJzIFJB
TSAqLw0KPiA+ICsJc2l6ZSA9IHNpemVvZihyZWdzLT5tYikgLyBzaXplb2YodTMyKTsNCj4gPiAr
CWZvciAoaSA9IDA7IGkgPCBzaXplOyBpKyspDQo+ID4gKwkJcHJpdi0+d3JpdGUoMCwgJnJlZ3Mt
Pm1iWzBdWzBdICsgc2l6ZW9mKHUzMikgKiBpKTsNCj4gDQoNClsuLi5dDQo+IENhbiB5b3UgY3Jl
YXRlIGEgInN0YXRpYyBjb25zdCBzdHJ1Y3QiIGhvbGRpbmcgdGhlIHJlZyAob3Igb2Zmc2V0KSAr
IGxlbiBhbmQgbG9vcA0KPiBvdmVyIGl0LiBTb21ldGhpbmcgbGlua2UgdGhpcz8NCj4gDQo+IGNv
bnN0IHN0cnVjdCBzdHJ1Y3QgZmxleGNhbl9yYW1faW5pdCByYW1faW5pdFtdIHsNCj4gCXZvaWQg
X19pb21lbSAqcmVnOw0KPiAJdTE2IGxlbjsNCj4gfSA9IHsNCj4gCXsNCj4gCQkucmVnID0gcmVn
cy0+bWIsCS8qIE1CIFJBTSAqLw0KPiAJCS5sZW4gPSBzaXplb2YocmVncy0+bWIpLCAvIHNpemVv
Zih1MzIpLA0KPiAJfSwgew0KPiAJCS5yZWcgPSByZWdzLT5yeGltciwJLyogUlhJTVIgUkFNICov
DQo+IAkJLmxlbiA9IHNpemVvZihyZWdzLT5yeGltciksDQo+IAl9LCB7DQo+IAkJLi4uDQo+IAl9
LA0KPiB9Ow0KDQpJbiB0aGlzIHZlcnNpb24sIEkgb25seSBpbml0aWFsaXplIHRoZSBpbXBsZW1l
bnRlZCBtZW1vcnksIHNvIHRoYXQgaXQncyBhIHNldmVyYWwgdHJpdmlhbCBtZW1vcnkgc2xpY2Us
IHJlc2VydmVkIG1lbW9yeSBub3QgaW5pdGlhbGl6ZWQuIEZvbGxvdyB5b3VyIHBvaW50LCBJIG5l
ZWQgY3JlYXRlIGEgZ2xvYmFsIHBvaW50ZXIgZm9yIHN0cnVjdCBmbGV4Y2FuX3JlZywNCmkuZS4g
c3RhdGljIHN0cnVjdCBmbGV4Y2FuX3JlZ3MgKnJlZywgc28gdGhhdCB3ZSBjYW4gdXNlIC5yZWcg
PSByZWdzLT5tYiBpbiByYW1faW5pdFtdLCBJTUhPLCBJIGRvbid0IHF1aXRlIHdhbnQgdG8gYWRk
IHRoaXMsIG9yIGlzIHRoZXJlIGFueSBiZXR0ZXIgc29sdXRpb24gdG8gZ2V0IHRoZSByZWcvbGVu
IHZhbHVlPw0KDQpBY2NvcmRpbmcgdG8gYmVsb3cgbm90ZXMgYW5kIGRpc2N1c3NlZCB3aXRoIElQ
IG93bmVyIGJlZm9yZSwgcmVzZXJ2ZWQgbWVtb3J5IGFsc28gY2FuIGJlIGluaXRpYWxpemVkLiBT
byBJIHdhbnQgdG8gYWRkIHR3byBtZW1vcnkgcmVnaW9ucywgYW5kIGluaXRpYWxpemUgdGhlbSB0
b2dldGhlciwNCnRoaXMgY291bGQgYmUgbW9yZSBjbGVhbi4gSSB3aWxsIHNlbmQgb3V0IGEgVjIs
IHBsZWFzZSBsZXQgbWUga25vdyB3aGljaCBvbmUgZG8geW91IHRoaW5rIGlzIGJldHRlcj8NCg0K
IkNUUkwyW1dSTUZSWl0gZ3JhbnRzIHdyaXRlIGFjY2VzcyB0byBhbGwgbWVtb3J5IHBvc2l0aW9u
cyB0aGF0IHJlcXVpcmUgaW5pdGlhbGl6YXRpb24sIHJhbmdpbmcgZnJvbSAweDA4MCB0byAweEFE
RiBhbmQgZnJvbSAweEYyOCB0byAweEZGRiB3aGVuIHRoZSBDQU4gRkQgZmVhdHVyZSBpcw0KZW5h
YmxlZC4gVGhlIFJYTUdNQVNLLCBSWDE0TUFTSywgUlgxNU1BU0ssIGFuZCBSWEZHTUFTSyByZWdp
c3RlcnMgbmVlZCB0byBiZSBpbml0aWFsaXplZCBhcyB3ZWxsLiBNQ1JbUkZFTl0gbXVzdCBub3Qg
YmUgc2V0IGR1cmluZyBtZW1vcnkgaW5pdGlhbGl6YXRpb24uIg0KDQpCZXN0IFJlZ2FyZHMsDQpK
b2FraW0gWmhhbmcNCg0K
