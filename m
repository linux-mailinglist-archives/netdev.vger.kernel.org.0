Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFA03248A6
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhBYBn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:43:57 -0500
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:63566
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233524AbhBYBny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 20:43:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyorCYC4Nq/Y+7WZ+qXRjk1lpfEWBcgTQh+SdCvf1+uoSdTPiDSdgINjBRmBHezRfx1aRhN6hWLTFRxvw9v2bPtgfh1bQMTrKuiMHUT4jD7AFSzwbOH9oDuUjrWc5vLNuC68B0qqhTzMSIvjbCkXnVKiizz903ufVXbqQ7iT3z9Ew5CVQRk+b34YSB8gOmcxsCiO/F2Toy3rwcPoUzNHquZv/zTH9h7VSpOa55jNsKz2M299tJFapmqWc60IxvS3T15IK8TO9uiQnSryzkKdrKOdACtLrT/pzw3eNJWhshxSSNv4mEd9NZRawAhW9PF6ENaWJsL4dsSLyyOpX8gh1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRifSfmhP1TZKyI4jpRrDrqmd2rRYVXDpwo1iSMCLhQ=;
 b=GFNyWQ0obdYeXqWoTKV9pgtWJbQutS7MYg1Ga83d3YJOZxYKAQvSFPdfmbDX6voFIbgJMnVGUl+z13cZ48zcdPKeo8RJGXrUz99RAAVihBkWnoQj55Zf5EUoEv08x7kZJjyII8e0OO3CzELHsUtulkth/VvxsgyeopLQuq1LxSZYfrhMATOX9SW8Fc89rcGA2uRczn2LIld7Acg8Lu9kxQJ6gKL00Z0yciLX2teCPzVKgfG83xZfwxQxpyx+Iy663UIGE+NsVP2hMhsAUWxeaSkmd3u2B8/D65RxO7X4Tn89n86v7BK2Dvgc7pX4f9FYqi6WK/cncIi+D/msA5jnMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRifSfmhP1TZKyI4jpRrDrqmd2rRYVXDpwo1iSMCLhQ=;
 b=g7RQOkzz1kS6Ocq+JPp9cYSe4VRJpRrYzJ1qG0bcBbkmq2E7yehzf8hbekon5uV9VC9pBxvL6IwjXarHCIoftlyWEJli2JnUcjoHgTs7l6UNMK82sXbkWgu0qT9hYRuChNgujqfekvE/JgGTi70r/Ib8lgLqDsehloJk7pf4nDc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5132.eurprd04.prod.outlook.com (2603:10a6:10:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 01:42:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 01:42:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Topic: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMCAAAgFgIAAA1yAgAAHzQCAAANg8IAAEuGAgAFs/AA=
Date:   Thu, 25 Feb 2021 01:42:59 +0000
Message-ID: <DB8PR04MB6795A78C765E4909BD7FD44EE69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795663DB5336C8BDB16A159E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223183438.0984bc20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795C1D02AAB9F01571AFED9E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <7866cb18-b50e-7e1f-545a-86f4678f868b@gmail.com>
In-Reply-To: <7866cb18-b50e-7e1f-545a-86f4678f868b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22e1a250-da36-451c-e2a8-08d8d92eaec2
x-ms-traffictypediagnostic: DB7PR04MB5132:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5132C5253307A72C262A3270E69E9@DB7PR04MB5132.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tz18AmalNmfS8qyoST2goZwmicTUnA47t6dUAKavW/4WmcFGP20SJ7Wg2ptN+0W1owbHU8CUrNmN8aU+thKbeIe643vt/7hisV5Sp0HCAGC1vXItBXzYd3la6XjZv4/GWCqoaa71kpI1V7eMn4XT51OsV/HeGHatD/WyKcJ2qQPb3eXktPylc2F4g4mJGlYQfPghLsZinbUNX1HiftKCWdidJqty/s0g+/CSHoY87USyJDA48SWGO45yCPxn+6fi0IJJtIJoPDRMODWLC7ig5o9ImbvmNQTdItn1pCCIu4sXV8KP5Dj14XQfabnk67vMiByefY3gIMaslmnfbPeS0KIPS+MZkdFvSnXkLpK/Ct+V/S2ot/w4fE1f749sHWi+wzcAFSsdQH9UVjw3WjCJTH3MxzyNlnm+G9I3tJ3/B6uuzoVwwvDZEV/UGetK/nnryPl/z5MdTR3zkPK6rIqFAkxF4Ag+8PkWs6KOJ4sOIFCiEUjNNa08T31GKshXdOIoFlfQAw1ICkf6v+fAlVCqcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39850400004)(136003)(376002)(478600001)(64756008)(8936002)(66946007)(4326008)(76116006)(66556008)(66476007)(86362001)(6506007)(2906002)(53546011)(26005)(8676002)(52536014)(9686003)(316002)(110136005)(5660300002)(54906003)(55016002)(71200400001)(186003)(66446008)(33656002)(83380400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?TmlGbDE1a2pmQVZDUENBWU9HZk9LelJJS0p5MUk2WTR5enpjSklyamVPeGFK?=
 =?gb2312?B?Y012bjJFRkZNdkFqbWtweXlqamxvY29XNVd6K2V0R2xTeXg1V2tLYzVlUnBZ?=
 =?gb2312?B?MkY2ZTVKUmw0N2syS1pOUXRvbkJaV2JxdnJzTTcydGJZTTNNTzcyc3B4SHcz?=
 =?gb2312?B?djdvaTc1VU5TRmM1dzBkTEpCMzExQmN6eGZlb2pnbmVLa2tnTnBDTGg2M0Ro?=
 =?gb2312?B?UEhmUHBQbEQrbVJNUFFoczNKSTU2SHJidlc1YkprdU44MmMzVy96VUdDMk5Y?=
 =?gb2312?B?MHJEd1B4V3UwTFVoOC9YaHl0bDZUbk9Ic0RlVU1XMHVTN0Nja3Q4ZG4xbG51?=
 =?gb2312?B?ZVJhbWd4M2hxTVorTFpoR21FRUJ6cDVWcnMzb0JtRXZFUWIvWGV1Ti8vZ1gx?=
 =?gb2312?B?SFV5NW9tMk5yK2RNeVJOallTRndBWDFwZFhHbU9MYzZnK3puc3pMSW1CYUpw?=
 =?gb2312?B?Q3pHZ3d4SVlFVWpHdmNDNURnVFM4TlVQUG05OFhTMnZxeFZvNE9EK2huU3Y4?=
 =?gb2312?B?V2RFNG5ybnBIMXFCZWtxdzBWblFXOFB0WWVmUk9ocjNjdURVempkRjd0U3ha?=
 =?gb2312?B?NkhuWVJ6Q05pbzMwclVUL2MxRHB3Q2MvQTIxM0VtWTRRSTJ1bEZDYzFxSnNi?=
 =?gb2312?B?d2dyRWk3QnZCL3gyckswbC9RS2g3Zk1lem9SYjh3NWZoYkZoek85ZUtERUtH?=
 =?gb2312?B?cjU3eHBjWkxuMk43dURvOEpZQmc1Ymh1OWQ5ZmxNeTRwMlZKSUJsTEJUVTVm?=
 =?gb2312?B?QXdZQTVUY09jYlhHMkQyNTg3UGVKdndSRmtIa0RRYkxVV2F1eU9kR1U5aTcr?=
 =?gb2312?B?bG9HcjlRRnZYbDU4TGlHWjJIQ2RGUEZEeDlSa0F0UkNWMk4yOG5WUnpVV05s?=
 =?gb2312?B?TlV1ZzZzaThhSnh3cG1MdFNnYnhsMklMa2xBb3NPdlhsamJPMUVrR0xZYjRh?=
 =?gb2312?B?Q3I3VVBiM1NaMHVjOGNsdTRlUUtJM245bThQOGZ1dUQ3Q0tSa0xoeDc5ZFNN?=
 =?gb2312?B?b2loVGN4UkpydnN4bmwvS1dGdTJFbGhjZnRGRUp2TGRzZ2tQVFExaFh5RUd6?=
 =?gb2312?B?T0ZnSEZMZExGRVNjV2poQXVZUmpLT2VRQ0F4bGhRb3l1cE1qb2JJN2k4eUQ4?=
 =?gb2312?B?Qm1UaGhJTktGY1dFVVNiZzU4aXlzU2lzTmVsMG1qaDlFOEdueGVRKzFRNzZP?=
 =?gb2312?B?QWpBZzlrZy9EMGh4VVRvV0xjeWpHUUg0OGJNdHR3K1lUZXhLY1F5R2tsS0Vs?=
 =?gb2312?B?alZJbVkxQzZ1RHNQc2xBYXo2YmZvNTdGYzBvcm83RjFtc1hTR3dIMG1ZZG45?=
 =?gb2312?B?RXVoV3pqaW81aXU5S3lRUmtTejV4NnpDRzdDSGpMVEJZUmZTUmtoTm9zYy9Z?=
 =?gb2312?B?a2w2TVhPbGlTdHQrd3hReFRLc3Y5bDBFUThLMmxBaHUxU1hNbGVjTUtGSVhF?=
 =?gb2312?B?cnNTQmlYR08xdHk2blN2WHNrSURnTUVHVm9Ib0plSzBGUGcraEFLQWsvS2Ux?=
 =?gb2312?B?NzRLb3BHdGhweUhWUjJiaEEyczdJTjdYd3JtUDVzR0FkbFFtdXkzQ3p6WmZz?=
 =?gb2312?B?NHdlaWJSdlhEU28xRGRNWmdwN1hZdmkyS3BTaFB1S2dEMW9mOWJXQ0d5RW5s?=
 =?gb2312?B?cXU5czExR1N1a25IMXM4M3ZobUNGdXNNWlZGYStkVjRzSzVORDNESW5kcXRk?=
 =?gb2312?B?U0pGZXdKM3d2bVFkTHg2R01WUmJOL2l3RFNtMWladElxUnplQWY1alZpcDJW?=
 =?gb2312?Q?didnwtRACHDnFBnZzvF4uBoig1WDUxc6ez06O3Y?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e1a250-da36-451c-e2a8-08d8d92eaec2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 01:42:59.5799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3b0Sfm2P6pDGfak0rWrN6ZEihONRNE4Lefqx2J/YtwZzQBxP2JyUOvIurcrriXHLu2gddSFWXxQbkDvNk09Vrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOoy1MIyNMjVIDExOjU0DQo+IFRv
OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgSmFrdWIgS2ljaW5za2kN
Cj4gPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhh
bmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGwtbGludXgtaW14IDxsaW51eC1p
bXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMSBuZXQtbmV4dCAwLzNdIG5ldDog
c3RtbWFjOiBpbXBsZW1lbnQgY2xvY2tzDQo+IA0KPiANCj4gDQo+IE9uIDIvMjMvMjAyMSA2OjQ3
IFBNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gPj4gRnJvbTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gPj4g
U2VudDogMjAyMcTqMtTCMjTI1SAxMDozNQ0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCj4gPj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhh
bmRyZS50b3JndWVAc3QuY29tOw0KPiA+PiBqb2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPj4gZGwtbGludXgtaW14IDxs
aW51eC1pbXhAbnhwLmNvbT4NCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMSBuZXQtbmV4dCAw
LzNdIG5ldDogc3RtbWFjOiBpbXBsZW1lbnQgY2xvY2tzDQo+ID4+DQo+ID4+IE9uIFdlZCwgMjQg
RmViIDIwMjEgMDI6MTM6MDUgKzAwMDAgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+Pj4+PiBUaGUg
YWltIGlzIHRvIGVuYWJsZSBjbG9ja3Mgd2hlbiBpdCBuZWVkcywgb3RoZXJzIGtlZXAgY2xvY2tz
IGRpc2FibGVkLg0KPiA+Pj4+DQo+ID4+Pj4gVW5kZXJzdG9vZC4gUGxlYXNlIGRvdWJsZSBjaGVj
ayBldGh0b29sIGNhbGxiYWNrcyB3b3JrIGZpbmUuIFBlb3BsZQ0KPiA+Pj4+IG9mdGVuIGZvcmdl
dCBhYm91dCB0aG9zZSB3aGVuIGRpc2FibGluZyBjbG9ja3MgaW4gLmNsb3NlLg0KPiA+Pj4NCj4g
Pj4+IEhpIEpha3ViLA0KPiA+Pj4NCj4gPj4+IElmIE5JQyBpcyBvcGVuIHRoZW4gY2xvY2tzIGFy
ZSBhbHdheXMgZW5hYmxlZCwgc28gYWxsIGV0aHRvb2wNCj4gPj4+IGNhbGxiYWNrcyBzaG91bGQg
YmUgb2theS4NCj4gPj4+DQo+ID4+PiBDb3VsZCB5b3UgcG9pbnQgbWUgd2hpY2ggZXRodG9vbCBj
YWxsYmFja3MgY291bGQgYmUgaW52b2tlZCB3aGVuIE5JQw0KPiA+Pj4gaXMgY2xvc2VkPyBJJ20g
bm90IHZlcnkgZmFtaWxpYXIgd2l0aCBldGh0b29sIHVzZSBjYXNlLiBUaGFua3MuDQo+ID4+DQo+
ID4+IFdlbGwsIGFsbCBvZiB0aGVtIC0gZXRodG9vbCBkb2VzIG5vdCBjaGVjayBpZiB0aGUgZGV2
aWNlIGlzIG9wZW4uDQo+ID4+IFVzZXIgY2FuIGFjY2VzcyBhbmQgY29uZmlndXJlIHRoZSBkZXZp
Y2Ugd2hlbiBpdCdzIGNsb3NlZC4NCj4gPj4gT2Z0ZW4gdGhlIGNhbGxiYWNrcyBhY2Nlc3Mgb25s
eSBkcml2ZXIgZGF0YSwgYnV0IGl0J3MgaW1wbGVtZW50YXRpb24NCj4gPj4gc3BlY2lmaWMgc28g
eW91J2xsIG5lZWQgdG8gdmFsaWRhdGUgdGhlIGNhbGxiYWNrcyBzdG1tYWMgaW1wbGVtZW50cy4N
Cj4gPg0KPiA+IFRoYW5rcyBKYWt1YiwgSSB3aWxsIGNoZWNrIHRoZXNlIGNhbGxiYWNrcy4NCj4g
DQo+IFlvdSBjYW4gaW1wbGVtZW50IGV0aHRvb2xfb3BzOjpiZWdpbiBhbmQgZXRodG9vbF9vcHM6
OmNvbXBsZXRlIHdoZXJlIHlvdQ0KPiB3b3VsZCBlbmFibGUgdGhlIGNsb2NrLCBhbmQgcmVzcGVj
dGl2ZWx5IGRpc2FibGUgaXQganVzdCBmb3IgdGhlIHRpbWUgb2YgdGhlDQo+IG9wZXJhdGlvbi4g
VGhlIGV0aHRvb2wgZnJhbWV3b3JrIGd1YXJhbnRlZXMgdGhhdCBiZWdpbiBpcyBjYWxsZWQgYXQg
dGhlDQo+IGJlZ2lubmluZyBhbmQgY29tcGxldGUgYXQgdGhlIGVuZC4gWW91IGNhbiBhbHNvIG1h
a2Ugc3VyZSB0aGF0IGlmIHRoZSBpbnRlcmZhY2UNCj4gaXMgZGlzYWJsZWQgeW91IG9ubHkgcmV0
dXJuIGEgY2FjaGVkIGNvcHkgb2YgdGhlIHNldHRpbmdzL01JQiBjb3VudGVycyAodGhleQ0KPiBh
cmUgbm90IHVwZGF0aW5nIHNpbmNlIHRoZSBIVyBpcyBkaXNhYmxlZCkgYW5kIGNvbnZlcnNlbHkg
b25seSBzdG9yZQ0KPiBwYXJhbWV0ZXJzIGluIGEgY2FjaGVkIHN0cnVjdHVyZSBhbmQgYXBwbHkg
dGhvc2Ugd2hlbiB0aGUgbmV0d29yayBkZXZpY2UNCj4gZ2V0cyBvcGVuZWQgYWdhaW4uIEVpdGhl
ciB3YXkgd291bGQgd29yay4NCg0KSGkgRmxvcmlhbiwNCg0KVGhhbmtzIGZvciB5b3UgaGludC4g
WWVzLCBJIG5vdGljZWQgc3RtbWFjIGRyaXZlciBoYXMgaW1wbGVtZW50ZWQgZXRodG9vbF9vcHM6
OmJlZ2luLCB3aGljaCBsZXQgZXRodG9vbCBvbmx5IGNhbiBiZSB1c2VkIHdoZW4gaW50ZXJmYWNl
IGlzIGVuYWJsZWQuIFRoYW5rcyBhIGxvdC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5n
DQo+IC0tDQo+IEZsb3JpYW4NCg==
