Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAF539590E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhEaKlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:41:18 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:14222
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230518AbhEaKlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 06:41:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gxf41u2t4IqEdpvXf/m5Ek/r+PA4tL/97pLbRRLsqEOWwcLWaK05EJ60wOCO00VtIC+aLU90tdOdw65LuqMtr62g0ccg5Umd+0csa0JDM2CKcwVpA5AQIQLMda4sHMalP18gn1+DktmMu3nTqZDRFlK6ob+mjUEnWZ+fyMCiXJFDVlqVxfNpQw+to9BAmlUokp602Fp+VJiHhL1UZX8SjIL1nMw+2kXUC4AOOfY2gUoQ63CoXbEnHoFEfbgrVTw36YOHVtZgeuO0auG6bPiDCUdOm2YzZOFRswgu/DiCFJve2CqBMuDBS65qctMclMVN4VwxEPQnXV7mkkdNTKZLjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMkH4OdTooLkpWF7NTBiaKlh1WR5jp+30Ki2py0UHOM=;
 b=eCkfxV/whUQKfLoE3MCCXJg5y3v6sg71x4aqnPop+sP3wi4+vgj10jXkF2dNCeQ11eV4V3dR7DC0dYoRxwyuQpvAeqNf/UYOQNgpYK8gwW/eUnk6k4y0IYYMquk4QVJFXlBQIJNzuCiFdHyYZSwoEV7t9sqJXisBfSt/mgFvoBb7+L5CYXerhf1S8IfI8EzEaM/mYNdoGKyuZI7b+hdygyJnliEUEL08x3AP2s1kesH4ZnJPGa0Kg2vkXyOVfRvKdP3TitW9ueFN2+swBrkcHbk2IjGS4JU/Fbsv0G7SRsR8FJGX5ZoEB8UUkZjQY29iMuEv5rwfdjSbOOn40QzX1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMkH4OdTooLkpWF7NTBiaKlh1WR5jp+30Ki2py0UHOM=;
 b=Ds0V2hNSmiln9jxkbHFY8mQ81d/S6rCshwYD/arB96FHOtp467EbSS4Wvwf0MwsSDgKByH+/KKWC09ZfzEyI1vg0ULYbIXJqqzgjzRui19mT1x2xr6zT2LvI+vdUpohBPamqQmsLCN5Ac9WyTqSojrae9SjzFnWdnHLh8iHMZcQ=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB6PR0401MB2232.eurprd04.prod.outlook.com (2603:10a6:4:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Mon, 31 May
 2021 10:39:34 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 10:39:34 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks
 conversion
Thread-Topic: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks
 conversion
Thread-Index: AQHXTfl6/1N1bm7Iwk2SXkUsOeQDmKr0F4UAgAle54A=
Date:   Mon, 31 May 2021 10:39:34 +0000
Message-ID: <DB7PR04MB501789620261838595804D84F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-3-yangbo.lu@nxp.com>
 <20210525113308.GB15801@hoboy.vegasvil.org>
In-Reply-To: <20210525113308.GB15801@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 713a0af2-8407-4020-533c-08d9242061d9
x-ms-traffictypediagnostic: DB6PR0401MB2232:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB223242A4B3FCF70A62875DB2F83F9@DB6PR0401MB2232.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pTl8eMuDlR3fpqsEtH49T/h2xaUES2tcA4i/+HxUFwPenIvtev6ikFhD0fRb2Pl/R8XRqICHlVzmi7q02cv8kOOzjnvf6RkvqfgT2spRszaxb9VwA6ReyxSdwKmZ2cSdKFEiZQ5LLVgCCNo/besig7N+8/5bdoqEWS8Bfi+WBBLYQkveAzWsBQHN9P0SFmyW9WMkNwBECIfO4dr7gqQWXyHjqOLxnrdAsCCYVhWvqK7TwHyx7K832OfNfR+uXor7+VUqyTynZgnnvobzsSbk5YetHeea2AQPDSwmrVjAebzxBqtjYymqs5SWEiUB6DpEVi7ZZoJGHMs6BhdWqXubu+Ll8E08B4ab0cfPFcevcVicEW1B8wKUYEyoBNlsW4MdF8SNDz3pPm+dNPB1Z2PlAq8R+38ZIn/QuTrTStksNDvUJywueCYb2Sso1lUBymYnua9wXWi2zwOdgWE8bLhTHgjCRABjrHRDnpCs5JjKTyDHpKcLtaVr5xB72TseoymBUkU9NZPBPNGm6SCGoytUVoEzbip5hgqMuBkBElwWVXCdmwE7PNwAjKTdHFf3IIjum35Bb1ElSKsDKIQjDSUyXqXfvQUEc6vI+yz/cZ62w9o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(346002)(366004)(316002)(5660300002)(54906003)(2906002)(9686003)(52536014)(4744005)(478600001)(7696005)(4326008)(122000001)(38100700002)(33656002)(8936002)(26005)(71200400001)(83380400001)(8676002)(66476007)(55016002)(66446008)(64756008)(6916009)(53546011)(86362001)(186003)(76116006)(66946007)(66556008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?a1c2a1FndEtDZHYyUXhwMTlIRndtQTd6ODQrK0o1N1ViTHlnN2M1b0szZ054?=
 =?gb2312?B?VXpJME03U1BVRTU3VGdSdURObVJoR2UvN0hCZE55OUdpMFlUeTI1TjRycHMw?=
 =?gb2312?B?SkZ1MUR4b0Q0a1grQU1MQWZKQWNzM0J1YVd1YVRrQUhXUFEya0NqYjlVbnJm?=
 =?gb2312?B?ZkxnT0V5ZWFHYU55ZUNzbVc5MnNGWlV5bWVKR1RCR2JOOWtHUVNaNUFoVGJM?=
 =?gb2312?B?ZnV0Z0liKzVrdnUyVCtxakdSRlhiSE8wVW9VZ2pzYk1hK2Ryb1ZWMVUwdEZM?=
 =?gb2312?B?b1kzODY0TmZwQ0ZOaWVSNEtFcHpQWnpRZ2dDMCszQTNUZG92SVNMN2ZJTll5?=
 =?gb2312?B?WHJMS1hIdE5UU05qaW43eElnc0VLUEJRSnRjK3k4ZmJ5bTZteCtPelMrZGph?=
 =?gb2312?B?WnR4UmpYVnljcm1ZejhaclJUb2NHK2p2RWltRkd2azlHN2l3dXNEUWN5WTdG?=
 =?gb2312?B?T0l5TWs1NmRxUEx0WnUxV2w5bDNyRG5BTGQ3VmUrbmpkV2FOeUpPRkRlU1kv?=
 =?gb2312?B?Zi9oSUJFYllpQitNd2hMTVdjYUh0b2hMT2hwdGxjMk1FK0NJV1F0Uy92M2lJ?=
 =?gb2312?B?WTdEcjRCTUtsVk5VT2MzbzhIc0NnV2F3TjJzcXBiVEliRTA5cnp3Qi83cktN?=
 =?gb2312?B?Ym1hRS92UmtuNUdWd2J5Vkg5N2NFVjRMNmMzYmxRYjAwR05UV2NYSUhqUjd0?=
 =?gb2312?B?YnplTnBmQ3pSdjkrUk5iZGN5aWJBL0IzZjVKdEhDTnJROTRPUUFGRHpQT3N6?=
 =?gb2312?B?dnFUSTdXRXZYR2c4VFN6ajMyZWd3R1VjNVcrZTNsdUZuRm52dVZtVmpFTWl1?=
 =?gb2312?B?bUxja0pPSU1CbXJsT1lxcGhnSFBKVU52VGJFU1ZpcUdFaUVwcHpURTdveHdQ?=
 =?gb2312?B?VjUzYkw2bVZVU0pUNzhoVWRQR1hzT0VYakJyYlJzcTRoWkJaYkdrbXpTRlZn?=
 =?gb2312?B?dFA3K0ZsVjJZTXBnMlhRRXY4SGtrY3VlOS9nc0RCeHlxN0pJT0RQVFdPK05I?=
 =?gb2312?B?SkJweHhLSXQrL2V6VEZvUUlHT1lFci9xQUJOYngvYVF0T2tyMlVrbDRxWDRP?=
 =?gb2312?B?U3hGTjBQN0FYTE41SzBjMnVDVlN2SGdoWjRCVGVxUlJ3QU5OcVl4TTZmMm1o?=
 =?gb2312?B?eGY0S05sN0VicjMreVE5bXhhZ1kvTnFJZmU0UjN3eWxnU2NQVmdVSm00QmNE?=
 =?gb2312?B?V3NuS2JvVnFLNW1zQTd4a1lBR3hvaVR6MjNDYjdNTnlDTVRNZHFkY1B0bnp1?=
 =?gb2312?B?STVYbC9ZK0hvM000dkdDNjBKU3pBYXpXUjJ5Uk1VYzAyMGNDUmxmSXRHeUUy?=
 =?gb2312?B?aWRzVnI4cUFIcnNaQW42bk9IOGxWUHVaTmM1K1hHWEhObFBaWCs5L2JIU01j?=
 =?gb2312?B?OWtkQmpDRHhONEFhMVYrUWxWWVk3Mm50N3F1M2hIUmdyaW1CM1oxVkEvajVW?=
 =?gb2312?B?TElraVlGNys2NEg3cEpqZkI0R2JtWW9PSTR5N0NYWjUxUjhLNWFhTERDVWpn?=
 =?gb2312?B?dUIwTFFFaTcwelcrZHBoSWVnOWtCK1RjSGNHSFRJTGRwNmY0YVFDOGFwZzlv?=
 =?gb2312?B?OFhuRU94SkF3NlpOb0hLY2pReGhEK0FDVG5zSU5yN2x3aUNRaDh0ZUdhWVlU?=
 =?gb2312?B?aFNQWDdLT2t3bmh0SXB4QWlUNU4remJjY08xRVBJbzZwbC9HV3lxNEhieE9q?=
 =?gb2312?B?RWhxOHorVEZzdkVJUkFkbFFSemJldjkvbEI0bWx1MWFFb3d1VmR0OE05WEpS?=
 =?gb2312?Q?F0aNpQaM+NDW5gyRhltG7vg3ABPoxDK+VFbiQpG?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713a0af2-8407-4020-533c-08d9242061d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 10:39:34.8022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoAk3R0FJ6SERXIWpt80VEs6JW7qwijomRdVIFVznRApy5uApuf/xi0vixUclS8CM9y0sr0oaAewQkR3ZOGFfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2232
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTCMjXI1SAxOTozMw0KPiBU
bzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQ2xhdWRpdQ0KPiBN
YW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MiwgMi83XSBwdHA6IHN1cHBvcnQg
cHRwIHBoeXNpY2FsL3ZpcnR1YWwgY2xvY2tzDQo+IGNvbnZlcnNpb24NCj4gDQo+IE9uIEZyaSwg
TWF5IDIxLCAyMDIxIGF0IDEyOjM2OjE0UE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtcHRwDQo+IGIv
RG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1wdHANCj4gPiBpbmRleCAyMzYzYWQ4MTBk
ZGIuLjY0MDNlNzQ2ZWViNCAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL0FCSS90ZXN0
aW5nL3N5c2ZzLXB0cA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMt
cHRwDQo+ID4gQEAgLTYxLDYgKzYxLDE5IEBAIERlc2NyaXB0aW9uOg0KPiA+ICAJCVRoaXMgZmls
ZSBjb250YWlucyB0aGUgbnVtYmVyIG9mIHByb2dyYW1tYWJsZSBwaW5zDQo+ID4gIAkJb2ZmZXJl
ZCBieSB0aGUgUFRQIGhhcmR3YXJlIGNsb2NrLg0KPiA+DQo+ID4gK1doYXQ6CQkvc3lzL2NsYXNz
L3B0cC9wdHBOL251bV92Y2xvY2tzDQo+IA0KPiBIb3cgYWJvdXQgIm5fdmNsb2NrcyIgdG8gYmUg
Y29uc2lzdGVudCB3aXRoIG5fZXh0ZXJuYWxfdGltZXN0YW1wcywgZXRjLi4uDQoNCk9rLiBXaWxs
IGtlZXAgY29uc2lzdGVudC4NCg==
