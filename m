Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7BA3959B7
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhEaL2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:28:01 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:13198
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231164AbhEaL17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 07:27:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYVkA7y9sxN/naxDyUO0E5OXpw444APahDAx+zgHE/KwrO3pKkK/nWt6P4JcqnZnwTq5O6Vy9hXhy71y8sYqmFCDqFaFq6nOb00Jlzy6zI+bZ8zIGIT8mF5HNAL7p50dv7/2r/H9vu873Ptx1akEY6DKZj4u8Hqweg5Hf/M9ZVaET4sV2W15umAqQML/4HPAA8h2+aEQdtGhPYd/dhqnwSpNXedxtEQGNxmnUlMkZqCxjJZE0i7VankHPXZcemKUt1RXrTgBbErB0oK7dA7EAYQl+eUOUtYSOiVJPlwfA4A5qt5KxCFSDwV9g2ly06xBV1u+xAuQ95WJb0oKjdUEUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hY38BZrummt/+QBtiPIZuLySO1wBIgIZFI5W0XDoK6A=;
 b=FczmXVgvYMC4vMGkL0o68a3DpMDAq93bKB4dJfUr8VkdCdhUqwS4KmTTuuMEv1pyPLRDtYB0nL+mIJThJPSBgdiWexWTGfB5uyo69DdxthRqo6x04RiMY1aHA6wkLZHrhbPtTiBG/ODrqnAh74c8dhePBdJkkClaCyiyyiO8kOjr0InracuXA8X7kDIMxPaJkWsLmC5juvvhglDO9qOJ8k8nv2hU2V8rmdX6LH1QRAcmSu96ssrJddUNDrChp+6FLtt7vv9kNVtAWJwQSbZVAvvbWjyfQKDn9Y/w05+knSeWc85LcGll4KPOO0cPTgnGqxbMpIpKBrj4kC8OGHUYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hY38BZrummt/+QBtiPIZuLySO1wBIgIZFI5W0XDoK6A=;
 b=fuFU7Kll5C4X3lOSzM2RW4qIxBaXPNrqY2c8QAQXltCP87q1khE2RrwCNvn102mVi9JQ25GBm1mGjCJVCzkYfn0iZgcwh8NmyJu//f6/flAwnzJDmgC6t1Gv9ly2joCjxKL+waE/RZp6WBFAAA4mwbeloGKgVGeX7/2e0nZS1jY=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB3PR0402MB3787.eurprd04.prod.outlook.com (2603:10a6:8:12::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Mon, 31 May
 2021 11:26:18 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 11:26:18 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Topic: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Index: AQHXTfl8MjjmUYWreESzJP4N6mmsJar0KWqAgAADPwCACU1i0A==
Date:   Mon, 31 May 2021 11:26:18 +0000
Message-ID: <DB7PR04MB5017E8CEA0DA148A4EB1EAF9F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
 <20210525124848.GC27498@hoboy.vegasvil.org>
In-Reply-To: <20210525124848.GC27498@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c6d84b8-f5b1-4860-db99-08d92426e8b0
x-ms-traffictypediagnostic: DB3PR0402MB3787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3787FBF8ECF410D64BF6AA1AF83F9@DB3PR0402MB3787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rcb7Eq3J5rSvEXwWc+oAvEQ902uEc12Wb5hbbDurS6X31jfXFg0hbsg1RohHvrq5wJ1GrxK453z4r0GP5YhC8bKzO72ojM00z26d9gmKObMbxFevwMbVo9nLJL/cC+aVTFSlMTV+Ktk4BYi56UI3ceVlCMoNBp7ElcexJ1zylgKf47Nf8W9Qc8Qh+TMQeTUekWI0GhuxuI8wDs/I9k8ggxYXAldcNdpdsukAgYmCNSwjAX1W9kk3YBrA1IQweSe1IbpoNxpcmsFVXzhI3mErWn0CdSKm4dwijVyyh4c8W6vlUVjBJu+cx694HOmLjsJPmYsCmm67u7nOOSOyh3FB7Til0ZZKOFsAmrDaYEkwCdnwEM3mmGDKxiHaDvlp+VlcRqAQT+iOa/uEOs7TUnHHst28qW5kCpTjXuoLmt62FEI7jPuz4ZRIzA0KYOA7gX7H71ouAp87NLy6+pzQkoCW8JNTvnrJcI6ThyW3vtCvWFsL5ntzNTW7t56rU1iLe37Ut5+oZJpEOoL3ptdn1yH0gS9w7KR4KJ270PM3AG4QeaandQXjN9h+lusyr9vXtIDORczem1rAK7J4L6Yx/G5/slfAzothI1eLkFJoPBoEiwQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(376002)(346002)(396003)(55016002)(83380400001)(316002)(26005)(52536014)(71200400001)(66476007)(8676002)(66946007)(53546011)(76116006)(66556008)(7696005)(66446008)(8936002)(9686003)(64756008)(2906002)(6916009)(54906003)(478600001)(86362001)(186003)(6506007)(38100700002)(4326008)(5660300002)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?NUdzV1JsRGdra216dzV1c0dkd2FCR2ovYjVGVVNOTTRQVXpIY1RSSnVZSjB4?=
 =?gb2312?B?NUdqUWw2OTlHb2p6bEpCUXdBbVpTa2w4YVJWbFl3NnMydWJLMW8rQjRlY01K?=
 =?gb2312?B?RWUrRXlHeExvWmhnRUNJcVhXU3VDMTFvQlRRWTZqSUJvU2wrNDVoZWdvaXgz?=
 =?gb2312?B?YzVVUVRHTWJzWWdjRE9VM0NRMHd2bkk2S1RJZ1hIL09IRmdtUEtNYm1hZkpX?=
 =?gb2312?B?eURIbHRQK2wwMnZvbXFIL3RvWGtvcUVzOUY1djBiMnZ6bXp1cldndnV6RlBt?=
 =?gb2312?B?QnYvRDQ3RU5oZlZRdzQya0I2eHdNb1hqYlJaU2ZWd01XN2VnK0JldHpNRnZz?=
 =?gb2312?B?SFNqNTBPZUlBdlhPT3A0RnNZdjJmZ1JWYUFIUFlTVG1KNGZtejZ5Tk5VZytO?=
 =?gb2312?B?S3VZb3RyMUpMRWRqZWRkSzJCcldqMWRFZVFibnBzV2Z2L2NzVGtjemN0cVFW?=
 =?gb2312?B?M296MFh5QmNnckZ5aFZNUXhaR1B2bFJxSG9zT3p3TEtiM0hTeVgxL3dJbW5K?=
 =?gb2312?B?aFV0aXRmK0FwZU9Nd0lUa2k5YW93aWFLU0pEZ3VyWkJNajhjM29SUGx5ZlFp?=
 =?gb2312?B?SVVLNDhkRko4cG0yOUJlaFR4dFUrU3JNM3ZWRGJQN3Jvd2VaNkUralZXa0Ju?=
 =?gb2312?B?d21VSm5MQ1gwanlsNS9PdUdReFJaZ0hZNGZ6N29SM1p4ZHRiVXk4VEdNNE5Z?=
 =?gb2312?B?WUhmRllTTDJuMVNLemJmYm91Z3Z3aXdyQVBNSTRzSjc3YVM5WHNxb0M0aTZL?=
 =?gb2312?B?S1BpS2NlOTFqU0g5VWEvcGxZeWlRdHJuV0lSWDB2YlBpL2p3V0VnKzh6M1Y2?=
 =?gb2312?B?b2s2ZVVEVkJVZ2tHR3BnbDBNL09vQm0vV1Y2VnVQUVk1bmlIZEVvbE52VERG?=
 =?gb2312?B?ZDFJT3VJTTFzMENvTnprOWJDUW1OeTA1SUVCcW5WUzJiRFBScFlRRHNlQmRD?=
 =?gb2312?B?NjBkbWF6bktmVGdPRGxGVGlmOGlhbGFQWWk1Y3VJYUlhK1hoYkJRMlVtMi90?=
 =?gb2312?B?QnN6MUlqZGhtM1JnY0FZTUhPTW03S3Z6WmlyZCtTNXB2dm0zTGtvVlVSM2Qx?=
 =?gb2312?B?Ujd1Z3NwdWpOeC9yTVFEZ1ZEMFNIOTNrVGZyaFFVc0pxcVBSZG9wejRDVnIw?=
 =?gb2312?B?eGR3R0xXWG9GUDVYSjZqQXZTdmdjRmh2YnorYUtIdFFVZ2lDUWp5ZlJzME1R?=
 =?gb2312?B?WkpTbDNST21ZbTlFdGx0c0NmT1RMZ29CdzZPVlY1MzBtbVVDcHI0WUhSMjd6?=
 =?gb2312?B?K1VXK29ONTBLTEwwRE9lcmZwS0JMTFI3cWRYTHNKYzRWYUN4UXRVaUV4enpo?=
 =?gb2312?B?aXVoeEhrcHVjRUJWeWFuY21ZcnFhK0J5REp0NFNaam1lem45ZWlLN1RqZDdJ?=
 =?gb2312?B?TDE0cnN0YTJLYW9NY3RTK0MzY2pjR3pnaGVSbEpDbkM1aTk2cGs0T0JPdHhB?=
 =?gb2312?B?emFNT0s0ZUxvcXNLRW0wWkEyM1RkRU5jbForMEI5SVF1a1dIYXBnaks3clRC?=
 =?gb2312?B?cHRTMUZGVGkvMWtqR1JjaVk4eWdPT054SXcwWG5QRzEwRmFKMXhKU24vNk04?=
 =?gb2312?B?WVg5OWt4dGF2L2U1VFRGdXVmcU5kTzZHcEgzSUZ2RDNPbDhLV0JTc3JMOFRr?=
 =?gb2312?B?WFFnSkNuKzR2SUNyWXJiQ3UvcTJoNnlPUk42QzZ0b25XY1B3alcrZ25vQlhZ?=
 =?gb2312?B?SmsvZEZtd1Z2bXhZM3ZEUDJOaWR6QnlOYnVMQlU0aSswK2tLemRzczdxTHRM?=
 =?gb2312?Q?rAe+Vdg9ndN6AMwJbOgL50dblRHUocVxNxZRzGM?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6d84b8-f5b1-4860-db99-08d92426e8b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 11:26:18.0258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cMjKqVQHSI4GLn/CM6ayqZL8v4NnSTbucZ6NB9b9402Q5qlPMGxj02vC5Kq8Ji23xZ52ur4iRoeojL81lqWBaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTCMjXI1SAyMDo0OQ0KPiBU
bzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQ2xhdWRpdQ0KPiBN
YW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MiwgNy83XSBlbmV0Yzogc3VwcG9y
dCBQVFAgZG9tYWluIHRpbWVzdGFtcA0KPiBjb252ZXJzaW9uDQo+IA0KPiBPbiBUdWUsIE1heSAy
NSwgMjAyMSBhdCAwNTozNzoxMUFNIC0wNzAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6DQo+ID4g
SW5zdGVhZCwgdGhlIGNvbnZlcnNpb24gZnJvbSByYXcgdGltZSBzdGFtcCB0byB2Y2xvY2sgdGlt
ZSBzdGFtcA0KPiA+IHNob3VsZCBoYXBwZW4gaW4gdGhlIGNvcmUgaW5mcmFzdHJ1Y3R1cmUuICBU
aGF0IHdheSwgbm8gZHJpdmVyIGhhY2tzDQo+ID4gd2lsbCBiZSBuZWVkZWQsIGFuZCBpdCB3aWxs
ICJqdXN0IHdvcmsiIGV2ZXJ5d2hlcmUuDQo+IA0KPiBGb3IgdHJhbnNtaXQgdGltZSBzdGFtcHMs
IHdlIGhhdmUgc2tiX2NvbXBsZXRlX3R4X3RpbWVzdGFtcCgpLg0KPiANCj4gRm9yIHJlY2VpdmUs
IG1vc3QgZHJpdmVycyB1c2UgdGhlIGZvbGxvd2luZyBjbGljaGU6DQo+IA0KPiAJc2h3dCA9IHNr
Yl9od3RzdGFtcHMoc2tiKTsNCj4gCW1lbXNldChzaHd0LCAwLCBzaXplb2YoKnNod3QpKTsNCj4g
CXNod3QtPmh3dHN0YW1wID0gbnNfdG9fa3RpbWUobnMpOw0KPiANCj4gU28gdGhlIGZpcnN0IHN0
ZXAgd2lsbCBiZSB0byBpbnRyb2R1Y2UgYSBoZWxwZXIgZnVuY3Rpb24gZm9yIHRoYXQsIGFuZCB0
aGVuDQo+IHJlLWZhY3RvciB0aGUgZHJpdmVycyB0byB1c2UgdGhlIGhlbHBlci4NCg0KU28sIHRo
ZSB0aW1lc3RhbXAgY29udmVyc2lvbiBjb3VsZCBiZSBpbiBza2J1ZmYuYy4NClRoYXQncyBnb29k
IHRvIGRvIHRoaXMuIEJ1dCB0aGVyZSBhcmUgcXVpdGUgYSBsb3Qgb2YgZHJpdmVycyB1c2luZyB0
aW1lc3RhbXBpbmcuDQpTaG91bGQgd2UgY29udmVydCBhbGwgZHJpdmVycyB0byB1c2UgdGhlIGhl
bHBlciwgb3IgbGV0IG90aGVycyBkbyB0aGlzIHdoZW4gdGhleSBuZWVkPw0KVGhhbmtzLg0KDQoN
Cj4gDQo+IFRoYW5rcywNCj4gUmljaGFyZA0KPiANCj4gDQo=
