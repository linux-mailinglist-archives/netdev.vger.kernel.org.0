Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2082B32DA
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 08:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgKOHsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 02:48:45 -0500
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:56640
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbgKOHso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 02:48:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLSmjjMAAu+jfQbxkWVKV56nMg+6yhOuHmEqO/rr1gbQOjQOB09gU3iZulyjImpmjBRSvIqT1ZKygaO9WoVikarrOSad1AFM8G/BAISvIozUCEbxGabBcAJ7K/fd11PvCJEpl1M9cT7kz98D/RgplmQAT6P6AX29wQlWkk1Gl4ZR75a/lPy0FJ+PaJBsiFua6+CCUpMhDlm7x2+i2J+3MP3/+Q43YjDKZkEmwRBN/SpdJatvx4h7IJX/X+ueHd47G5fHSAwzqJE8YwdX/dkVJRAaTV55VK7ic+lHKiH/K8Oo3AVj2tB7X3C6e/pzhQeW043Wa8oc0ixbdEc/Jkqxbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLDKM8BElsTa5UrpssGwvi8185C4SyAyudunWIOyLQM=;
 b=a1Je2l47q5rOB2AQc7lFyrmdxGFsXYtOnBNUDSMgKRCmLtSxoiT58L0F6EJFcAGoTFVgW/zb+Rb/oyZH9JLBvG6Pz3r3xlF9t9Z838O9zZ5f8d5xoikWu02xWmI2e2wpYgFyecVWKBI+AACz3GGP3dtKs4D4xu2ovqDOD6r2/EkFqeTrk6CMfUDVT1hj7vmbunWh70uLjdgSdgXj84pT6E/lCXjf11XNzLo+6KsK/W2pZP/zrfnxr0SMp9RnJGaeKFdQKAUvYafxlO+pHINq8PTxBObDGC9B4wiEUMS0vPrtc1Sd/KB/k7e5RXIK6QU6CIpwdFDkJzAOtSs5YoUMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLDKM8BElsTa5UrpssGwvi8185C4SyAyudunWIOyLQM=;
 b=fdzUG9Jm/vJfvQU0oahKHGsGxaAaW7y/HKVijPyVSh42d/lsIpNnLRk4UC/jU3j4kVs1a2phptqdrxhpRrOJ+aoYNnJ5feJBPYRpRuX4LArpJmTBXzO46i0nGKra3pn+ub/4Rc5KceoV8lbF6UoV3BQtrs+4wPNzWC3Dx8mOCPk=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB5857.eurprd04.prod.outlook.com (2603:10a6:208:128::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sun, 15 Nov
 2020 07:48:40 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::a5fd:3540:9ddd:dc60]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::a5fd:3540:9ddd:dc60%6]) with mapi id 15.20.3564.028; Sun, 15 Nov 2020
 07:48:40 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Kegl Rohit <keglrohit@gmail.com>
CC:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: Fwd: net: fec: rx descriptor ring out of order
Thread-Topic: [EXT] Re: Fwd: net: fec: rx descriptor ring out of order
Thread-Index: AQHWuD4rFwSOt0MMNkWHUhyv65mYbKnDNjYAgAJ35QCAAFBgAIAA475ggAEGw4CAAOju0A==
Date:   Sun, 15 Nov 2020 07:48:40 +0000
Message-ID: <AM8PR04MB7315A098BBB4AF823009382FFFE40@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com>
 <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
 <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
 <CAMeyCbjOzJw7e3+e-AwnCzRpYWYT5OjFSH=+eEsZcEBrJ4BCYg@mail.gmail.com>
 <AM8PR04MB7315635D8FFC131B04B25E00FFE50@AM8PR04MB7315.eurprd04.prod.outlook.com>
 <CAMeyCbiuFAtqpUTtrPx3Afp_Hc41nZTzq0US7vg5HXwPp6SdFQ@mail.gmail.com>
In-Reply-To: <CAMeyCbiuFAtqpUTtrPx3Afp_Hc41nZTzq0US7vg5HXwPp6SdFQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2c8de186-b5fa-4b01-ac10-08d8893ade42
x-ms-traffictypediagnostic: AM0PR04MB5857:
x-microsoft-antispam-prvs: <AM0PR04MB58578FE81FDD3E287F88204CFFE40@AM0PR04MB5857.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 66QXw2mB4pDO+e0sxQifaKaH8opU4SjJgou3oAyGeCtmr4sC68ddVfsR+7TiSNz5+SSEZR4ABet/lqJBFqSEWg2t1qepFW7EGd45Dzxx0FJymg5xfTdWnLu9CBhi14X1EshGHh7UKeAMUurWpLvWyKP2q1SRyC8duQLsIfrMMzMsw+6uk6wKIT4nyHrZRIpJm/XuqjanXTLY8GuGod0YWSQP28YL1d5CqiRBvSzrYhSwrL/eHWSrWbZG2ElsEmGcn6Q+C1L2pPQ3Fk9xr/braB9DweQz0SHeON7iyd3wWLlqH+9qkZTIqWWAssdyITjlnvu936iUJ3M1L2Cf0LhYpVUJ6G9Q2c0EJmsWleWQ1Sc+zeQDlnNl1nZh0z351p2TkDw5Op74L/K96gGapx7bgKoHXpzOrjtzp4j6NKfrrhQg8rVsOafUSS2+FJRAIzNL2SALRkP3aeWMOvBOUzEWCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(376002)(346002)(366004)(7696005)(4326008)(2906002)(54906003)(52536014)(26005)(316002)(6506007)(83380400001)(5660300002)(71200400001)(186003)(53546011)(6916009)(8936002)(55016002)(66446008)(966005)(66556008)(76116006)(9686003)(66946007)(45080400002)(66476007)(64756008)(8676002)(33656002)(86362001)(478600001)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: USXdQIi/hmjTg0XhmgCa/aXTyfSfX+BwH6GhYxVxvVT3JyiE0h2NfWkmtvaBfZG2O0ae2DVBQ/+V5mR26ghI898WqbQJuonpS097RWgmzHuSRFvS/AGD4Om9jcRnri4pNxzPYSK53Ff2cqrodYwpLiQ/RoFEiFyE6P+C92mjDflY3NIlFLx8iAt6f+n0goSSOv3wXj/oyVC4ojRTSFIK8jzqjcnlLOL4itg7zUrinuHZ8KzGNkSY6K7FPRv6IZ1/RTDXr0LcEglFGjwFk3iFrRYSeBeFDHGb7js7qYQTxast58UsYSyeOg/CYZ7njonPtcQ+mZGnDYG5uadu60GlM7PUNo3FCbs+K+gbQ+zqUjB7GWlLTuVyDRNnqRASU1cKaqnTeQcuAw5/f9qR0nrA1u24PpPd4+hWX+H9uHm4DYrk3fy9AGDVKy1TH4MUSoRdFbGWUL0HSU82LJHIM34rI71mzyXC/jDk6uwBqRlO4Pf/8P4A8gOPWBiiWWgE8Iwcxag72j9PMGYVB8vsiHyjqgsSuJ1aNR60xrsXzr+9ylwH+7EYpa1XpZIRxeQi9iVw76QFiprWQ5L+LzjF5vi4eHQtuDeJDERSc5XD7iKPH3Ns9hb573MJcRYlzOmwEM4/CbKof26JkVhIPavlF1qyjw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8de186-b5fa-4b01-ac10-08d8893ade42
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2020 07:48:40.1262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +tK9x6SAQjIMGkAq8vFQICyO7F46MQSHZpUDNEJ14WQL0gXAJ9oEonxpsLBeTaIgsxKNRc4ZJbkMNskpEPEG4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5857
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2VnbCBSb2hpdCA8a2VnbHJvaGl0QGdtYWlsLmNvbT4gU2VudDogU3VuZGF5LCBOb3Zl
bWJlciAxNSwgMjAyMCAxOjM3IEFNDQo+IE9uIFNhdCwgTm92IDE0LCAyMDIwIGF0IDI6NTggQU0g
QW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IEtl
Z2wgUm9oaXQgPGtlZ2xyb2hpdEBnbWFpbC5jb20+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgMTMs
IDIwMjANCj4gPiA4OjIxIFBNDQo+ID4gPiBPbiBGcmksIE5vdiAxMywgMjAyMCBhdCA4OjMzIEFN
IEtlZ2wgUm9oaXQgPGtlZ2xyb2hpdEBnbWFpbC5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4g
PiA+IFdoYXQgYXJlIHRoZSBhZGRyZXNzZXMgb2YgdGhlIHJpbmcgZW50cmllcz8NCj4gPiA+ID4g
PiBJIGJldCB0aGVyZSBpcyBzb21ldGhpbmcgd3Jvbmcgd2l0aCB0aGUgY2FjaGUgY29oZXJlbmN5
IGFuZC9vcg0KPiA+ID4gPiA+IGZsdXNoaW5nLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU28gdGhl
IE1BQyBoYXJkd2FyZSBoYXMgZG9uZSB0aGUgd3JpdGUgYnV0IChzb21ld2hlcmUpIGl0IGlzbid0
DQo+ID4gPiA+ID4gdmlzaWJsZSB0byB0aGUgY3B1IGZvciBhZ2VzLg0KPiA+ID4gPg0KPiA+ID4g
PiBDTUEgbWVtb3J5IGlzIGRpc2FibGVkIGluIG91ciBrZXJuZWwgY29uZmlnLg0KPiA+ID4gPiBT
byB0aGUgZGVzY3JpcHRvcnMgYWxsb2NhdGVkIHdpdGggZG1hX2FsbG9jX2NvaGVyZW50KCkgd29u
J3QgYmUgQ01BDQo+IG1lbW9yeS4NCj4gPiA+ID4gQ291bGQgdGhpcyBjYXVzZSBhIGRpZmZlcmVu
dCBjYWNoaW5nL2ZsdXNoaW5nIGJlaGF2aW91cj8NCj4gPiA+DQo+ID4gPiBZZXMsIGFmdGVyIHRl
c3RzIEkgdGhpbmsgaXQgaXMgY2F1c2VkIGJ5IHRoZSBkaXNhYmxlZCBDTUEuDQo+ID4gPg0KPiA+
ID4gQEFuZHkNCj4gPiA+IEkgY291bGQgZmluZCB0aGlzIG1haWwgYW5kIHRoZSBhdHRhY2hlZCAi
aS5NWDYgZG1hIG1lbW9yeSBidWZmZXJhYmxlDQo+ID4gPiBpc3N1ZS5wcHR4IiBpbiB0aGUgYXJj
aGl2ZQ0KPiA+ID4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNv
bS8/dXJsPWh0dHBzJTNBJTJGJTJGbWENCj4gPiA+IHJjLmluZm8NCj4gPiA+ICUyRiUzRmwlM0Rs
aW51eC1uZXRkZXYlMjZtJTNEMTQwMTM1MTQ3ODIzNzYwJmFtcDtkYXRhPTA0JTdDDQo+IDAxDQo+
ID4gPiAlN0NmdWdhbmcuZHVhbiU0MG54cC5jb20lN0MxMjFlNzNlYzY2Njg0YTEyNWUyYTA4ZDg4
N2NlYTU3OCUNCj4gN0MNCj4gPiA+DQo+IDY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1
JTdDMCU3QzAlN0M2Mzc0MDg2Njg5MjQzNjI5ODMNCj4gPiA+ICU3Q1Vua25vd24lN0NUV0ZwYkda
c2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWkNCj4gTENKDQo+ID4gPg0K
PiBCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1lN0NtMjRBeTFB
eTUyVUt0elQNCj4gPiA+IEJpWDlLbGh1dWJsbmRQMzB2bnd4QWF1Z00lM0QmYW1wO3Jlc2VydmVk
PTANCj4gPiA+IFdhcyB0aGlzIGlzc3VlIHNvbHZlZCBpbiBzb21lIGtlcm5lbCB2ZXJzaW9ucyBs
YXRlciBvbj8NCj4gPiA+IElzIENNQSBzdGlsbCBuZWNlc3Nhcnkgd2l0aCBhIDUuNCBLZXJuZWw/
DQo+ID4NCj4gPiBZZXMsIENNQSBpcyByZXF1aXJlZC4gT3RoZXJ3aXNlIGl0IHJlcXVpcmVzIG9u
ZSBwYXRjaCBmb3IgTDIgY2FjaGUuDQo+IA0KPiBXaGVyZSBjYW4gSSBmaW5kIHRoZSBwYXRjaCAv
IGlzIHRoZSBwYXRjaCBhbHJlYWR5IG1haW5saW5lPw0KTm8sIHRoZSBwYXRjaCBpcyBub3QgaW4g
bWFpbmxpbmUuIENNQSBjYW4gZml4IHRoZSBpc3N1ZS4NCg0KVGhlIG9yaWdpbmFsIHBhdGNoIGlz
OiBzZXQgc2hhcmVkIG92ZXJyaWRlIGJpdCBpbiBQTDMxMCBBVVhfQ1RSTCByZWdpc3Rlcg0KDQo+
IElzIGl0IHNvbWUgZGV2ZWxvcG1lbnQgcGF0Y2ggb3IgYWxyZWFkeSB3ZWxsIHRlc3RlZD8NCj4g
T3Igd291bGQgeW91IHJlY29tbWVuZCBlbmFibGluZyBDTUEgaW5zdGVhZD8NCj4gQXJlIG90aGVy
IGNvbXBvbmVudHMgYWZmZWN0ZWQgYXBhcnQgZnJvbSB0aGUgYWxyZWFkeSBtZW50aW9uZWQgcGVy
aXBoZXJhbHMNCj4gKEVORVQsIEF1ZGlvLCBVU0IpIGluIHRoZSBhdHRhY2htZW50Pw0KWWVzLCAg
cmVjb21tZW5kIENNQSB0aGF0IGNhbiBmaXggdGhlIGNhY2hlIGlzc3VlIGZvciBhbGwgY29tcG9u
ZW50cy4NCg==
