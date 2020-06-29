Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309E920CB49
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 02:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgF2Ave (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 20:51:34 -0400
Received: from mail-eopbgr50053.outbound.protection.outlook.com ([40.107.5.53]:33923
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbgF2Avd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 20:51:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alJ5kyhhKsFsN7s5q41PhMO9rUw83HhVouw530L1VLf2VW7T16DovQ2sgNr+yFVTTpCFH/mQv6LPuglVu4OCfT1xWeOFRuKRWQEuLLAlM8X3I95MdPh48/Ll+KFG7s+5Dd9ivDwDNQiVjAy9qFCk2dYvoXPLOQHBiebngQfAMMXThALLtmdVGZsYSBXr6EqJg2pe5sjxJUi/JVEl1T7M8O0GqzY0ts0nYq0kqizZ0FF2MX/I9u3T1yaRo9VlhS+9cwfTrRI5xVUu7UiQ+pMDpUbP6QTsLHizQlzHMc/DneHGIwRbSbQGxeqaYqALhYkT2If5/WCRloE0WtdLBSuayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+d9Dm7P7h0MNcF3OL4DLIlCsm4Qgie7XIMFEvUFTEY=;
 b=DZx2GUNmTD9jaKlGR3M3WC/u2uUe+5xdf1Kq0c4KXWKMd7RABN60NpMXSAmSE5rZsWaV3AD6kcGOaCQClcCQbhHzHXWADutmynOsReViLR0JZ/3uciB0FJFThnlGFYT1f1v5V+3EiNxA9RNtxOQl/b0J1aawhe/Bu3VPHin/VHy4UvlReWVyJDgA5vzQkTl0FviXJ0pdEni5ji9yPhyI03sPw0hr2/pM9eRkzAc2JFNdVZyMzgJsksOeMotoiwFfK7d3PNJBSe9bSMVpxlF5DfHrKcvkxRqyz0YMUoLaN2kJ7RG58beOYkLIn5pK3Ge4u1Cwfc7HkO3iXiErlWiM7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+d9Dm7P7h0MNcF3OL4DLIlCsm4Qgie7XIMFEvUFTEY=;
 b=FLloNrAC2dDVT/+sGWG21nCqrJBH+xVHOFUJskrkvizp3n2lL5kT/hUPh661J9Ydu8A3jdPEcjJPr+J2Ld7FHUT8ekeiQE6nOydc1hTtiqOV5ckS9paihBYJYkdbA0GEKlVZpCSptGHUwt/tt5eWemACoesGsGDrZtWaEiBXbUA=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR04MB7072.eurprd04.prod.outlook.com (2603:10a6:800:12c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 00:51:30 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 00:51:30 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: RE:  Re: [iproute2-next] action police: make 'mtu' could be set
 independently in police action
Thread-Topic: Re: [iproute2-next] action police: make 'mtu' could be set
 independently in police action
Thread-Index: AdZNr2sGREQ1dlt4QT2sFwRddjqD3A==
Date:   Mon, 29 Jun 2020 00:51:30 +0000
Message-ID: <VE1PR04MB6496EA762B0749A7CC92FBCE926E0@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.89.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b01e6ce-1cc9-4c53-70c1-08d81bc68ff5
x-ms-traffictypediagnostic: VI1PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB70728F2DE214C8A2A53E557E926E0@VI1PR04MB7072.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ds0YHZ4jw+7oVEJ7Glcf9AsQ449b9rRp1JP0M0c/MQTr51BhAtwuA0WFjt1VvHGSHeI+s6zAhNahb4hKGqPLAfFmGmz/nHSAvUjzx0Ji9tSYQtarft29I/Vy6zGiUWrcuqHJYaIEe52nUFArmz/P0rHaqmXT+mSKKNMgLwZ2zKKjxgM9VOX+wPd77kOGY4TZ2zDaPyVbs/2wWhJShsKPVj8suTauK8yMJOadXIh5mtm7bDfPSqQwCrsz4MaKeFneVKzDICbqXNGbYBQf6BkFm4AWGitSYGquz5Cy30EQasBaoSEXnIrDDbU2K+gd3RaI9R+/fq5dISgmldEFawbWWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(33656002)(8676002)(8936002)(71200400001)(7696005)(478600001)(316002)(6916009)(26005)(83380400001)(4326008)(66946007)(76116006)(2906002)(52536014)(54906003)(186003)(66556008)(86362001)(64756008)(66446008)(66476007)(6506007)(9686003)(53546011)(55016002)(5660300002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: By8h9K6Zh1W5mIJb8jic/Weh/gBTl9rTG43pVE3lLUkghQ7FPJjkxipufh8+sG80Jtv/8OPuKVK3u/NJZohxXM2fJhKkwnU9bV1+jAym6kKYGRdKWyjxOmERBPpk4QI6/O5r6DqXpqYMRsPqmv5WkWFkIPESknYux46F5Pd4xhuzrW9rYRt+X+Vww/tkwg0oKp2Bp4aTxSb236QceyJCHV8NcXS3jg+2gCY3qb+bDFFKK2D+9UMeH+xLkSRbGVAyL99NZMJmI3bmV/+LHt0+ipKFHvB+66ZFwdpsvv6wuy8NQGsyeSAl8CsjEVGkDV5jHZA0jwm8/5JUZRZfSy1fmGvuYdXVvlkr3Gpf1UDFktij9+ZsbxVjuFpxOBoSRsk5MIG72vHkWhq2TclEXRxTJgUngJTr+sNmPUOT4n0ocmjpFk7cJsttEgmsNMf4DWrSvWanT1hHg9tvi60AmxEK+zKyKXdGSpTlZz2oazWevac=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b01e6ce-1cc9-4c53-70c1-08d81bc68ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 00:51:30.4167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRpTBM4+YYJNJTXqmK9LzmU82Q7jAwGrjAMJI6vVuP5Y9U+490JbvtiDj3h431a3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0
ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZz4NCj4gU2VudDogMjAy
MMTqNtTCMjnI1SA0OjE2DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogZHNh
aGVybkBnbWFpbC5jb207IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGpoc0Btb2phdGF0dS5jb207DQo+
IHZsYWRAYnVzbG92LmRldjsgQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+
OyBWbGFkaW1pcg0KPiBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgQWxleGFuZHJ1
IE1hcmdpbmVhbg0KPiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW2lwcm91dGUyLW5leHRdIGFjdGlvbiBwb2xpY2U6IG1ha2UgJ210dScgY291bGQgYmUgc2V0
DQo+IGluZGVwZW5kZW50bHkgaW4gcG9saWNlIGFjdGlvbg0KPiANCj4gT24gU3VuLCAyOCBKdW4g
MjAyMCAwOTo0NjowMiArMDgwMA0KPiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPiB3cm90ZToNCj4g
DQo+ID4gQ3VycmVudCBwb2xpY2UgYWN0aW9uIG11c3Qgc2V0ICdyYXRlJyBhbmQgJ2J1cnN0Jy4g
J210dScgcGFyYW1ldGVyIHNldA0KPiA+IHRoZSBtYXggZnJhbWUgc2l6ZSBhbmQgY291bGQgYmUg
c2V0IGFsb25lIHdpdGhvdXQgJ3JhdGUnIGFuZCAnYnVyc3QnDQo+ID4gaW4gc29tZSBzaXR1YXRp
b24uIE9mZmxvYWRpbmcgdG8gaGFyZHdhcmUgZm9yIGV4YW1wbGUsICdtdHUnIGNvdWxkDQo+ID4g
bGltaXQgdGhlIGZsb3cgbWF4IGZyYW1lIHNpemUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQ
byBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiA+IC0tLQ0KPiA+ICB0Yy9tX3BvbGljZS5jIHwgNCAr
Ky0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdGMvbV9wb2xpY2UuYyBiL3RjL21fcG9saWNlLmMgaW5k
ZXggYTViYzIwYzAuLjg5NDk3ZjY3DQo+ID4gMTAwNjQ0DQo+ID4gLS0tIGEvdGMvbV9wb2xpY2Uu
Yw0KPiA+ICsrKyBiL3RjL21fcG9saWNlLmMNCj4gPiBAQCAtMTYxLDggKzE2MSw4IEBAIGFjdGlv
bl9jdHJsX29rOg0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuIC0xOw0KPiA+DQo+ID4gICAgICAg
LyogTXVzdCBhdCBsZWFzdCBkbyBsYXRlIGJpbmRpbmcsIHVzZSBUQiBvciBld21hIHBvbGljaW5n
ICovDQo+ID4gLSAgICAgaWYgKCFyYXRlNjQgJiYgIWF2cmF0ZSAmJiAhcC5pbmRleCkgew0KPiA+
IC0gICAgICAgICAgICAgZnByaW50ZihzdGRlcnIsICJcInJhdGVcIiBvciBcImF2cmF0ZVwiIE1V
U1QgYmUgc3BlY2lmaWVkLlxuIik7DQo+ID4gKyAgICAgaWYgKCFyYXRlNjQgJiYgIWF2cmF0ZSAm
JiAhcC5pbmRleCAmJiAhbXR1KSB7DQo+ID4gKyAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwg
IlwicmF0ZVwiIG9yIFwiYXZyYXRlXCIgb3IgXCJtdHVcIk1VU1QNCj4gPiArIGJlIHNwZWNpZmll
ZC5cbiIpOw0KPiANCj4gTWlzc2luZyBibGFuay4NCj4gWW91ciBtZXNzYWdlIHdpbGwgY29tZSBv
dXQgYXM6DQo+ICJyYXRlIiBvciAiYXZyYXRlIiBvciAibXR1Ik1VU1QgYmUgc3BlY2lmaWVkLg0K
DQpHZXQgaXQuIFdpbGwgY29ycmVjdC4gDQpUaGFua3MhDQoNCj4gDQo+IA0KPiBUaGUgcXVvdGVz
IGFyZW4ndCBhZGRpbmcgdG8gdGhlIHJlYWRhYmlsaXR5LCB3aHkgbm90IGp1c3QgcmVtb3ZlIHRo
ZW0NCj4gaW5zdGVhZC4NCg0KV2lsbCByZW1vdmUgYWxsIHF1b3Rlcy4NCg0KQnIsDQpQbyBMaXUN
Cg==
