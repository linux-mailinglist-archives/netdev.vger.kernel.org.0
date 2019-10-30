Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77191E9511
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 03:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfJ3CqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 22:46:09 -0400
Received: from mail-eopbgr1310130.outbound.protection.outlook.com ([40.107.131.130]:58221
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbfJ3CqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 22:46:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/jgGGFkOf1Uo+5yhFMO65kVm7BMrVbsRt74IYnz4M9PhANR+DKTjU1TEuKBuYBC+Rtgdp0LLQUexQlAbGcbIqAVvlu0My/NX+HS12KAgIuzSqX8yfr9vc+h3tBGP3NQg0l765ERqkQrJmljwH6BLduH/imLdcZPedsSAX1cRFnb/D4jkVz+Rmuj4UYC3OmXIwN6RiQn9md2PIuS/NyiZJ97R5X1ya6Gm+Fys4InzNhAhTKs0xJXlafjq5XlTwLD+5A0mseWj1UVek7F+vZakQQ7wyuMi/7GfPod59S7230yB2FvESgoRvz+txpM+Xa0dgp2s4VWN8eeru+zpiD8gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwnVf/0VIyB5552nZ0j1gi+f/jJekj69kP5d8X/7cg8=;
 b=Rl1FJ9cJxr1sKTyN67pTxF0Qb0ev7WIOjqAMxR0AJFHjCrpfHlvNgLi2iHFimkWtuN+S6V4XPjqxRiSFQfGsgGCwHYTxOpJTSVI+zm5WjSGEt0/mp1Bn6Cwe8iAjc8h17jsFhqgPcztOjdpKq71qfZTfd9TEIm3Bo0QADvbOTSU+Su3Om5bwoX/G5Tb+5wdJ+dT8prbrghrScLn7EBx8Pta5M+9rLL38CAjdbmnlhVBpQ4BkC+nPCmZssVaPJEg3831SRbGzLK3i1DN/N/nhDs/bPbZUJWfVvPCMjdMGD7L0M584DhEOpwDvCGMXhZyylKp5ZqbCPaMzHxLb8GKloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwnVf/0VIyB5552nZ0j1gi+f/jJekj69kP5d8X/7cg8=;
 b=SJ7nxb0rBua2daAfvvfbs42J5PRuq77vYaLiMGfYd4K9ZTtoSn/MwsxvmouzB9faVkImNLyoImAXT+at1VKNHYaqyJTaD2z1chN9FLmv8UEnuX9qzBJXiLm1EM5huTPMO2kGldtwHO2GCg11Wbze3KG0qyoSizfa8TvoGR/MwVk=
Received: from TY2PR01MB3034.jpnprd01.prod.outlook.com (20.177.100.140) by
 TY2PR01MB4970.jpnprd01.prod.outlook.com (20.179.169.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Wed, 30 Oct 2019 02:45:53 +0000
Received: from TY2PR01MB3034.jpnprd01.prod.outlook.com
 ([fe80::3c2f:6301:8f68:4c37]) by TY2PR01MB3034.jpnprd01.prod.outlook.com
 ([fe80::3c2f:6301:8f68:4c37%6]) with mapi id 15.20.2387.025; Wed, 30 Oct 2019
 02:45:53 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Thread-Topic: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Thread-Index: AQHViEnsnceJntXJaUCNpjtJej9X26drxUsAgAW6HgCAAK1EgIAAWvuA
Date:   Wed, 30 Oct 2019 02:45:52 +0000
Message-ID: <20191030024539.GA13815@renesas.com>
References: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
 <20191025193228.GA31398@bogus> <20191029145953.GA29825@renesas.com>
 <CAL_JsqLteAdjk+4KQ2hd5m16irT9_70EAxNWdTDLFHCZkex2Bg@mail.gmail.com>
In-Reply-To: <CAL_JsqLteAdjk+4KQ2hd5m16irT9_70EAxNWdTDLFHCZkex2Bg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::44) To TY2PR01MB3034.jpnprd01.prod.outlook.com
 (2603:1096:404:7c::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2843cab3-f990-46ad-82f9-08d75ce3478f
x-ms-traffictypediagnostic: TY2PR01MB4970:
x-microsoft-antispam-prvs: <TY2PR01MB49703E44BC79DF451CA523D9D2600@TY2PR01MB4970.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(199004)(189003)(51914003)(3846002)(478600001)(64756008)(6486002)(6116002)(11346002)(486006)(7736002)(2906002)(2616005)(6436002)(99286004)(6306002)(86362001)(8936002)(305945005)(476003)(6512007)(8676002)(81166006)(81156014)(4326008)(6246003)(14454004)(1076003)(5660300002)(256004)(386003)(6916009)(229853002)(316002)(14444005)(186003)(6506007)(25786009)(71200400001)(66066001)(66946007)(36756003)(76176011)(52116002)(54906003)(26005)(71190400001)(446003)(102836004)(33656002)(66556008)(66446008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:TY2PR01MB4970;H:TY2PR01MB3034.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OE3VHRgxkw6A5QwQHGLeTjyY4lVIBM+TwgoZYsnqK+5cOZfQzy8rGBLj0aR3WRFNqX2MxuA2Vtncl6J58SxwBDpSIQO4NGDJzhjciRvcvt6E9mK8Q6YltC7dMiCC4d1TNlSnp1WnTXVAft0EVjS9ZYuklOkapYgBc6Lmy/Mn/5D2JmpiPhJqxAlRYZ8YTcnKrpoUEaVdNLIwevAZ5XepCd4Zd73Bcn2xMRtaHOqZEzSw6znLOjpZVlo4K301waRfYz/zosmaUmAWABc3MTBAHvMvVOwAmvVUoJJoONlbm+7sAYYBd9BvcnE9HbYEpJRRLsUWILkLn/cYmV7gBmKSYqIlmuaWVpsUr3rrT97CpU879OdVjNdmHLH9wIuV+p8+dSAfzpLeX+113pjIygHfAiK+yvatF5Hkzc06yZUgyRjAp3tdo8B75CraoGNkHX37
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F553A8CD117CE4DB11506C3D1615967@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2843cab3-f990-46ad-82f9-08d75ce3478f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 02:45:52.8790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqLZdbl1oxewtL4Smx84f8qkr3OcKP/bwHzS+Bh2hbUg862RByNdvo+YHiE5hXlEh0IbuNpULm9FG/IdQnM2LbPKj9jYQujr11kNIEzCEG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4970
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBPY3QgMjksIDIwMTkgYXQgMDU6MjA6MDNQTSBFRFQsIFJvYiBIZXJyaW5nIHdyb3Rl
Og0KPk9uIFR1ZSwgT2N0IDI5LCAyMDE5IGF0IDEwOjAwIEFNIFZpbmNlbnQgQ2hlbmcNCj48dmlu
Y2VudC5jaGVuZy54aEByZW5lc2FzLmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gRnJpLCBPY3QgMjUs
IDIwMTkgYXQgMDM6MzI6MjhQTSBFRFQsIFJvYiBIZXJyaW5nIHdyb3RlOg0KPj4gPk9uIE1vbiwg
T2N0IDIxLCAyMDE5IGF0IDAzOjU3OjQ3UE0gLTA0MDAsIHZpbmNlbnQuY2hlbmcueGhAcmVuZXNh
cy5jb20gd3JvdGU6DQo+PiA+PiBGcm9tOiBWaW5jZW50IENoZW5nIDx2aW5jZW50LmNoZW5nLnho
QHJlbmVzYXMuY29tPg0KPj4gPj4NCj4+ID4+IEFkZCBkZXZpY2UgdHJlZSBiaW5kaW5nIGRvYyBm
b3IgdGhlIElEVCBDbG9ja01hdHJpeCBQVFAgY2xvY2suDQo+PiA+Pg0KPj4gPj4gKw0KPj4gPj4g
K2V4YW1wbGVzOg0KPj4gPj4gKyAgLSB8DQo+PiA+PiArICAgIHBoY0A1YiB7DQo+PiA+DQo+PiA+
cHRwQDViDQo+PiA+DQo+PiA+RXhhbXBsZXMgYXJlIGJ1aWx0IG5vdyBhbmQgdGhpcyBmYWlsczoN
Cj4+ID4NCj4+ID5Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHRwL3B0cC1pZHRj
bS5leGFtcGxlLmR0czoxOS4xNS0yODoNCj4+ID5XYXJuaW5nIChyZWdfZm9ybWF0KTogL2V4YW1w
bGUtMC9waGNANWI6cmVnOiBwcm9wZXJ0eSBoYXMgaW52YWxpZCBsZW5ndGggKDQgYnl0ZXMpICgj
YWRkcmVzcy1jZWxscyA9PSAxLCAjc2l6ZS1jZWxscyA9PSAxKQ0KPj4gPg0KPj4gPlRoZSBwcm9i
bGVtIGlzIGkyYyBkZXZpY2VzIG5lZWQgdG8gYmUgc2hvd24gdW5kZXIgYW4gaTJjIGJ1cyBub2Rl
Lg0KPj4gPg0KPj4gPj4gKyAgICAgICAgICBjb21wYXRpYmxlID0gImlkdCw4YTM0MDAwIjsNCj4+
ID4+ICsgICAgICAgICAgcmVnID0gPDB4NWI+Ow0KPj4gPj4gKyAgICB9Ow0KPj4NCj4+IEkgYW0g
dHJ5aW5nIHRvIHJlcGxpY2F0ZSB0aGUgcHJvYmxlbSBsb2NhbGx5IHRvIGNvbmZpcm0gdGhlIGZp
eCBwcmlvciB0byByZS1zdWJtaXNzaW9uLg0KPj4NCj4+IEkgaGF2ZSB0cmllZCB0aGUgZm9sbG93
aW5nOg0KPj4NCj4+IC4vdG9vbHMvZHQtZG9jLXZhbGlkYXRlIH4vcHJvamVjdHMvbGludXgvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3B0cC9wdHAtaWR0Y20ueWFtbA0KPj4gLi90
b29scy9kdC1leHRyYWN0LWV4YW1wbGUgfi9wcm9qZWN0cy9saW51eC9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvcHRwL3B0cC1pZHRjbS55YW1sID4gZXhhbXBsZS5kdHMNCj4+DQo+
PiBIb3cgdG8gdmFsaWRhdGUgdGhlIGV4YW1wbGUuZHRzIGZpbGUgYWdhaW5zdCB0aGUgc2NoZW1h
IGluIHB0cC1pZHRjbS55YW1sPw0KPg0KPidtYWtlIC1rIGR0X2JpbmRpbmdfY2hlY2snIGluIHRo
ZSBrZXJuZWwgdHJlZS4NCg0KVGhhbmtzIGZvciB0aGUgdGlwIC0gdGhhdCBsZWQgbWUgdG8gcmUt
ZGlzY292ZXIgd3JpdGUtc2NoZW1hLnJzdA0KDQpEaWQgdGhlIGZvbGxvd2luZyB0byBlbnN1cmUg
ZHQtc2NoZW1hIGFuZCB5YW1sIGlzIGluc3RhbGxlZDoNCiQgcGlwMyBpbnN0YWxsIGdpdCtodHRw
czovL2dpdGh1Yi5jb20vZGV2aWNldHJlZS1vcmcvZHQtc2NoZW1hLmdpdEBtYXN0ZXINCg0KJCBw
a2ctY29uZmlnIC0tZXhpc3RzIHlhbWwtMC4xICYmIGVjaG8geWVzDQp5ZXMNCg0KJCBwa2ctY29u
ZmlnIHlhbWwtMC4xIC0tbGlicw0KLWx5YW1sDQoNCg0KSG93ZXZlciwgSSBnZXQgJ05vIHJ1bGUg
dG8gbWFrZSB0YXJnZXQiIGVycm9yIHdpdGggJ21ha2UgLWsgZHRfYmluZGluZ19jaGVjaycuDQoN
Ck9uIGxpbnV4OiBUdWUgT2N0IDI5LCBjb21taXQgMjNmZGIxOThhZTgNCg0KJCBtYWtlIC1rIGR0
X2JpbmRpbmdfY2hlY2sgXA0KICAgIERUX1NDSEVNQV9GSUxFUz1Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvdHJpdmlhbC1kZXZpY2VzLnlhbWwNCiAgU0NIRU1BICBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHJvY2Vzc2VkLXNjaGVtYS55YW1sDQogIENIS0RUICAg
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3RyaXZpYWwtZGV2aWNlcy55YW1sDQpt
YWtlWzFdOiAqKiogTm8gcnVsZSB0byBtYWtlIHRhcmdldA0KCSdEb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvdHJpdmlhbC1kZXZpY2VzLmV4YW1wbGUuZHQueWFtbCcsDQoJIG5lZWRl
ZCBieSAnX19idWlsZCcuDQoJCQkJCQkJCQ0KT24gbGludXgtbmV4dC1taXJyb3I6IFR1ZSBPY3Qg
MjksIGNvbW1pdCBjNTdjZjM4MzNjNg0KDQokIG1ha2UgLWsgZHRfYmluZGluZ19jaGVjayBcDQoJ
RFRfU0NIRU1BX0ZJTEVTPURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy90cml2aWFs
LWRldmljZXMueWFtbA0KICBTQ0hFTUEgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9wcm9jZXNzZWQtc2NoZW1hLnlhbWwNCiAgQ0hLRFQgICBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvdHJpdmlhbC1kZXZpY2VzLnlhbWwNCm1ha2VbMV06ICoqKiBObyBydWxlIHRv
IG1ha2UgdGFyZ2V0IA0KCSdEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdHJpdmlh
bC1kZXZpY2VzLmV4YW1wbGUuZHQueWFtbCcsIA0KCW5lZWRlZCBieSAnX19idWlsZCcuDQoNCkkg
d2lsbCBrZWVwIGdvb2dsaW5nLCBidXQgYW55IHRpcHMgd2lsbCBiZSBncmVhdGx5IGFwcHJlY2lh
dGVkLg0KDQpSZWdhcmRzLA0KVmluY2VudA0K
