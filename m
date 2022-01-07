Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48326487854
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347620AbiAGNkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:40:03 -0500
Received: from mail-am6eur05on2137.outbound.protection.outlook.com ([40.107.22.137]:56833
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347621AbiAGNkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 08:40:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNjVzqfY+POoS1JAb15J5r/2KkZkzc6c1P1sw59qkbCElH9+QtreY7GzpXtDGQWgY2sL8JUp4F1rBC0ahqkA+pZ10gHyV94dpNjE9cfe7bmWUE6jWHQhxgGqzr1icLPMKPrVMmuoMizWB5/Kav5ulWO9tjbRoe9ugeAjT7cLKdEoKn3LVWR/ctq6mAoizGqleXHZ3YpvoC0n2QOW5TdC4TBA4nuvRIrgrOjywDymPGPXINvcXa0fxPe/LlNzc49xmynD03Sn3zlUXBVaAwHCtuzi9WA7hKmZWNm0uPt48c2hqoZ1ItMmfV9PqFqu3R+p6f8UJLzaapxc2sH/IpqP5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebZia8r1hVRsPUxmoNjZuLAzU9hfJ64mv+lrpxNzrI0=;
 b=K1csNs41CFsp+DUZ1orXuryWkCH+e/fe9f0+DiY6I4X2YBC8dADNbSSEjBxplDBo2PczQpPmiJV4eYraSe1gNcV+XxzQyF94v3aD6D7JhKnywlkJYa/fManQO6vsv4iuGQNuU0d5kFbYXyvzZsm9ZVgZ1pG9jMj+N75WRX7Ab+e7nbzUFy+oPZYnFGji2oDmnVnQMPrP517qf1ydXW0P40izUpaGKJJ6grMc2F1zRL7Nr07npWJMzdCVPAUUwyTdKt1QfzRC7qjTIO1lkQFdR5Y4B+kNAbAKijirRoBz/vOR/Ao3Cc1gWDVVNKhZMzLrEBsFuGsmvJhs97Nt07hhrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebZia8r1hVRsPUxmoNjZuLAzU9hfJ64mv+lrpxNzrI0=;
 b=aDjBW2PofFFSOB6unw33uka78xeCCgjM0GyRM/oYryXbpLAlOkij664AJpuhkOlAxb6RfcLjzcDsixFZ6P3+PE9CvnKdkMUWZvKsS4A8DCBCWOu0QgKB3pSSeXFxByzIcM33wLK9q39sotOUA5H95BBU98kd36ymzP3VOvLNjbo=
Received: from AM6PR03MB4296.eurprd03.prod.outlook.com (2603:10a6:20b:3::16)
 by AM6PR0302MB3478.eurprd03.prod.outlook.com (2603:10a6:209:18::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 13:40:00 +0000
Received: from AM6PR03MB4296.eurprd03.prod.outlook.com
 ([fe80::6cf6:10d0:3050:4cf2]) by AM6PR03MB4296.eurprd03.prod.outlook.com
 ([fe80::6cf6:10d0:3050:4cf2%5]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 13:40:00 +0000
From:   =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <Stefan.Maetje@esd.eu>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Thread-Topic: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Thread-Index: AQHX5wAkICfeFtPuKk6B9pq4Q17ihKxXyiCA
Date:   Fri, 7 Jan 2022 13:40:00 +0000
Message-ID: <21a802162e34d3b75d368a99d0c9ac021a77ed32.camel@esd.eu>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
         <c650cf14619a583185c5250a0e7db2bc3c54b0ab.camel@esd.eu>
In-Reply-To: <c650cf14619a583185c5250a0e7db2bc3c54b0ab.camel@esd.eu>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e926a68-1055-48dc-ae20-08d9d1e33386
x-ms-traffictypediagnostic: AM6PR0302MB3478:EE_
x-microsoft-antispam-prvs: <AM6PR0302MB3478F08EF3DFF818D764A5A8814D9@AM6PR0302MB3478.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MMxLE3VQ/iTPk99a71JHXAJrIPWsC0JG+pRaz8d7trHgGqZ5AYUGPGP3ifNDNeeqV2v0wGXlAz3csF5vQCFNrW5NEuWG64wKybzzsQPvqSVP4LrcPljrYoCt4cASRjWEN9sOEq7pyYCxY8S6McWGi6E4oMNTe+5C4ROzcbi5EDQqDlPaT9nJMdQXJ7od+OTlW+LyI0+SiqX3W2heqc8jDQcnw0uBaHwvNwiFrpmQNmxmf5NWg5epU6hzJJa2Oaoq22H2URXrVnzgz+ghIpa+VsupLfRQQiLhvchdajWrlUaZuu88xpVSDKjyjWTSZmYj2FI1wWJLJpLetChDBy+AKSpH3q59jMkeO4jumNBnmxm34Ghk49+ZCT9Z9LoJVR/+k+j73cNHeOZSd55X3vyFzN8iqOZhfnmDyYrHMEZRQcg2blOlgkLi+O1eHAX1By9rK0by3Eci3EQMOguxZhpqURmpuF1cs7j2/KH4tSIhfwHacqCqQm+INZGBmwG3HXDVnz3pxOCy0YF/f+T3euCEPrdOspgJNDDCqwuf4PnblyOdOu94xjV2slnWOW836Hx2LqyyKxuhL3x3I5vl8+tjVm0Hxovf/IPQVEqZ2D++JyJ2nu5Xj8kFs+Irh+fkjPmLtXuMLbso1aJ3XNiBEVokLJ+Iaaz80PvlS8gePc2yJPQvDxEE/i+EZCo53FnoC1UsO0Wbdmx2S6HqE/hOZr344/XUPxnBbPRDQ5ZAmznjOJZrv3nF8WcldzJabI1RaRe/nYE1DuFiZlIlsdShGrDQynkaNoWAOEUxwFw/UFNrTPA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB4296.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39830400003)(376002)(366004)(136003)(66946007)(122000001)(66446008)(64756008)(66476007)(38070700005)(5660300002)(66574015)(66556008)(76116006)(38100700002)(83380400001)(186003)(4326008)(2616005)(71200400001)(6486002)(6512007)(6506007)(316002)(36756003)(110136005)(8676002)(8936002)(2906002)(54906003)(85202003)(966005)(508600001)(85182001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UElCbjBxTnlmcGMxR1R4N0p0NDdGK3VnNVV3cVordC9TNDZSRG9kTjBCTER6?=
 =?utf-8?B?N0ViRUV0cjE0aEJWQ1NXTmF3YkpHdGJxT2VNdXQyc20vbktrMUZNbXA3TXVU?=
 =?utf-8?B?Snp3ejlHNVFBYVdVakFUNzBCamtJeHJGOUdzbFJsWksrK3htbTd1cXFjbktp?=
 =?utf-8?B?alRicVo0QWk0WjU2MkFCVTFOV0NIQVlJcy9vMnpEazYyajBmRzhxOTllM0tC?=
 =?utf-8?B?NWtEVEZibnhBbVJzUXRGZGM2bkhlN0EveXVMRVBpZzBwZlB3ZU5uWlg2Rjlj?=
 =?utf-8?B?N2ZMVmZndmpacFdSelhqTG9rR3p3a3ZYa0IxdVJhVTlZRE9TdzBVNWM5bzdk?=
 =?utf-8?B?bEIwaGhwTzRiNTQxUVVOSjhmQXRlVXJCTnJyM1ZYbit6dVg2S2dEeUJTS1lI?=
 =?utf-8?B?RU5YVzhRTVcxTmtySHhrbjRrNnhnb2RpWW5KOGhaMEpMVHkydU5LMlJIeGRk?=
 =?utf-8?B?bjdiVFAxTDdseTVEaHExNEIwTlNtRUlNWGw4Q2lWYTFXNmJ6LzdRblRTSmpX?=
 =?utf-8?B?U0IzT2ZlWkd2TjZDS2twcXVDNWNZYlQ4L0xvTTc2bWJOOXR4bUdEaFJJODNm?=
 =?utf-8?B?aUovYlVaaVh3dGhlMTFlWitpcXdaNU1zNkNFb1c0RUZMK1pkRDN0WlJzM3M2?=
 =?utf-8?B?OENFM3dTTWllRWxqeG11MUVScHdTVkExR0pCYlQ4VDhHVVBiRTAwekJiZDVW?=
 =?utf-8?B?OTUwSlhBVWxXTWVNdTU4STR2NUl5UExCRFhkckZaL3ZoTk8wTSs1aFR1Sm5p?=
 =?utf-8?B?Q1BFbklnQTRmSE96c3RiT0c3RkNWVVpZSHpqN3Y1S05odm5xaktxSmZnSUU0?=
 =?utf-8?B?Z3NkcE5sY0V1ZGprTG9xczkwd1JUbjdtc01KcUJyWjFFaTJzQUdwUVBvN1B0?=
 =?utf-8?B?STVOTnF1OVZOUnZYaEY1d2R2VldvK3hLUjFBUjFUWUdkTjRmYzJLL1JNYk1p?=
 =?utf-8?B?UkROeUtzdGplYlAyMW9vS3dXN1hiWTZZV3YvcmJvNkNJbDZDTk5pOTFucGNT?=
 =?utf-8?B?WEhKMGcvYVRnNGg2Q2E4d2FLd04zZHhVaEpDMDEwakxXS3UyT084M3lwU3hv?=
 =?utf-8?B?eWZsUVlyWTBpeThtYWRDWUFsUmdIeURkYWRHY3RCZERCTDFzM0thNEFqcjdC?=
 =?utf-8?B?bU9hb1FselI0TnRzUHY0dDZpclgwVjZiUXBMSjRLRWdqOCt6VXRsMUVzMHdu?=
 =?utf-8?B?V2QzSTdLWXlzZlBDdE5YMjB2bEE5Q3dNVWxkbVA1TWwrZU9zYklnSHRudXhJ?=
 =?utf-8?B?WEJNam94Q2diemUvTmtnWFp1bjlNanBWakw0V2hLcHRFM2lIVnA2U0xPMHFj?=
 =?utf-8?B?dzFiWGx0OGRjS2QwTU5nUk93a2pEN2hxOFo3amdXd3VQL3dlZGVrb0UvTXYy?=
 =?utf-8?B?cHA0STF2aUVGazV5RXlBUEtLRzZUYnFYelJWTXhSTW5Fdlp3dFhJRXJ0cjl0?=
 =?utf-8?B?MUZWZWpnRmlycCs4N1pmRW5MUDZPMUVIQ3BueHFqNUFuR2hqYjFaOExhRmVV?=
 =?utf-8?B?N2prZGQyd1k4MjczYUdJd2s2a0VXUlNFcFFXYlE4dnVvQ1FBeUdYSXU1WDZD?=
 =?utf-8?B?NzVzZGlMeWxCYkJ0V0JXWlM4NFNvaTE4cCtGYkxkOVpQM3UxT01TZWRVSEYw?=
 =?utf-8?B?RGZpZGVTdkY0NUp6ajEyeWc3bmFXSS9TZkFXWW0yMHo4MmFhZUZFTy9iVmZm?=
 =?utf-8?B?bEdJSCt1aVU0U2tMVFd0RVZEUW8wbG0yVXZIbC9QY3doWXFWMGV1UzlzRFBU?=
 =?utf-8?B?ek0vankwSE11ekFkeHl1SXBkcFYxNDFJRTlSTUFMWHQ1VFNOQmZjck0rT2JL?=
 =?utf-8?B?SVJkckpQb3J1Zkk0TU04ZnMyU3hzbmJibWorQ3c1aVZWYTczV3hUUVNwVm9Z?=
 =?utf-8?B?WFd6WTNNSnB5UC9mbjIrYjRsVzI5K0dmS1FYbWYxeGJWWi9pRkVuY2hqNjQz?=
 =?utf-8?B?dGNrSzFucUt6bjJWK2pRNGJoS0tCS25vdnM3NzIwcEQwck1kdEdXblphWU5E?=
 =?utf-8?B?ZythZk5DcjZmZUdySTUyTmlyVlRKVUVMaGpwZ2xpemlGVmltR2xYWGs0Q1pk?=
 =?utf-8?B?blNQWWRQY0lMdTltR0VMdVI2N2RiN0JNOTR0QzREU1BZdW1wbXNsMytmTFBG?=
 =?utf-8?B?MmEzU0tXMndWWXZoYlBYTUIxOUwwNGxKN3MrZUVhZ2Y1K3QwZGd5aFR3NDZK?=
 =?utf-8?B?RWRoeXJ1bHhFbGJSQjFQMXQreERJKzNQa0FobUhVK1E3OVkvSHpGZ21wRm5B?=
 =?utf-8?Q?EXVUXrhzYMgwplF/5cUeaPB8C6O84sXBgCjqJg96EU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE55BABEB12D534F8AB5FB52D6A90F0B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB4296.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e926a68-1055-48dc-ae20-08d9d1e33386
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 13:40:00.0475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tEtIQoJdhc0iG3P0HupaHJ4E0kmUswKEeucR2zw4vIe2xf3V0KFBBXP8EkTTL99cTAT8s1OOc2St/bZptu76Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCmlzIHRoZXJlIGFueSBjaGFuY2UgdG8gZ2V0IHRoaXMgcGF0Y2ggDQpodHRwczovL2xv
cmUua2VybmVsLm9yZy9saW51eC1jYW4vMjAyMTEyMDEyMjAzMjguMzA3OTI3MC0xLXN0ZWZhbi5t
YWV0amVAZXNkLmV1Lw0KaW4gdGhlIHVwY29taW5nDQo1LjE3IHJlbGVhc2U/DQoNClRoZSBwYXRj
aCBzdGlsbCBhcHBsaWVzIGNsZWFubHkgdG8gbGludXgtY2FuLW5leHQgInRlc3RpbmciIGF0IHRo
aXMgdGFnOg0KDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9ta2wvbGludXgtY2FuLW5leHQuZ2l0L3RhZy8/aD1saW51eC1jYW4tbmV4dC1mb3ItNS4xNy0y
MDIyMDEwNQ0KDQpJZiBpdCBoZWxwcyBJIHdvdWxkIHByb3ZpZGUgYSBwYXRjaCB2NyB0aGF0IGlz
IHJlYmFzZWQgdG8gdGhlIG1lbnRpb25lZA0KdGFnLg0KDQpBbnkgY29tbWVudCBpcyBhcHByZWNp
YXRlZC4NCg0KQmVzdCByZWdhcmRzLA0KICAgIFN0ZWZhbiBNw6R0amUNCg0KDQpBbSBNaXR0d29j
aCwgZGVuIDAxLjEyLjIwMjEsIDIyOjA5ICswMDAwIHNjaHJpZWIgU3RlZmFuIE3DpHRqZToNCj4g
SGksDQo+IA0KPiB0aGlzIGlzIHJlYWxseSBwYXRjaCB2Ni4gTWlzc2VkIHRvIGNoYW5nZSB0aGUg
ZW1haWwgc3ViamVjdC4gTXkgYmFkLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiAgICAgU3RlZmFu
IE3DpHRqZQ0KPiANCj4gQW0gTWl0dHdvY2gsIGRlbiAwMS4xMi4yMDIxLCAyMzowMyArMDEwMCBz
Y2hyaWViIFN0ZWZhbiBNw6R0amU6DQo+ID4gVGhlIHB1cnBvc2Ugb2YgdGhpcyBwYXRjaCBpcyB0
byBpbnRyb2R1Y2UgYSBuZXcgQ0FOIGRyaXZlciB0byBzdXBwb3J0DQo+ID4gdGhlIGVzZCBHbWJI
IDQwMiBmYW1pbHkgb2YgQ0FOIGludGVyZmFjZSBib2FyZHMuIFRoZSBoYXJkd2FyZSBkZXNpZ24N
Cj4gPiBpcyBiYXNlZCBvbiBhIENBTiBjb250cm9sbGVyIGltcGxlbWVudGVkIGluIGEgRlBHQSBh
dHRhY2hlZCB0byBhDQo+ID4gUENJZSBsaW5rLg0KPiA+IA0KPiA+IE1vcmUgaW5mb3JtYXRpb24g
b24gdGhlc2UgYm9hcmRzIGNhbiBiZSBmb3VuZCBmb2xsb3dpbmcgdGhlIGxpbmtzDQo+ID4gaW5j
bHVkZWQgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2ggc3VwcG9y
dHMgYWxsIGJvYXJkcyBidXQgd2lsbCBvcGVyYXRlIHRoZSBDQU4tRkQgY2FwYWJsZQ0KPiA+IGJv
YXJkcyBvbmx5IGluIENsYXNzaWMtQ0FOIG1vZGUuIFRoZSBDQU4tRkQgc3VwcG9ydCB3aWxsIGJl
IGFkZGVkDQo+ID4gd2hlbiB0aGUgaW5pdGlhbCBwYXRjaCBoYXMgc3RhYmlsaXplZC4NCj4gPiAN
Cj4gPiBUaGUgcGF0Y2ggaXMgcmV1c2VzIHRoZSBwcmV2aW91cyB3b3JrIG9mIG15IGZvcm1lciBj
b2xsZWFndWU6DQo+ID4gTGluazogDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
Y2FuLzE0MjY1OTIzMDgtMjM4MTctMS1naXQtc2VuZC1lbWFpbC10aG9tYXMua29lcnBlckBlc2Qu
ZXUvDQo+ID4gDQo+ID4gKk5vdGUqOiBzY3JpcHRzL2NoZWNrcGF0Y2gucGwgc3RpbGwgZW1pdHMg
dGhlIGZvbGxvd2luZyB3YXJuaW5nczoNCj4gPiAgIC0gZXNkXzQwMl9wY2ktY29yZS5jOjI3MDog
UG9zc2libGUgdW5uZWNlc3NhcnkgJ291dCBvZiBtZW1vcnknIG1lc3NhZ2UNCj4gPiAgICAgVGhp
cyBlcnJvciBtZXNzYWdlIGlzIHRoZXJlIHRvIHRlbGwgdGhlIHVzZXIgdGhhdCB0aGUgRE1BIGFs
bG9jYXRpb24NCj4gPiAgICAgZmFpbGVkIGFuZCBub3QgYW4gYWxsb2NhdGlvbiBmb3Igbm9ybWFs
IGtlcm5lbCBtZW1vcnkuDQo+ID4gICAtIGVzZGFjYy5oOjI1NTogVGhlIGlycV9jbnQgcG9pbnRl
ciBpcyBzdGlsbCBkZWNsYXJlZCB2b2xhdGlsZSBhbmQNCj4gPiAgICAgdGhpcyBoYXMgYSByZWFz
b24gYW5kIGlzIGV4cGxhaW5lZCBpbiBkZXRhaWwgaW4gdGhlIGhlYWRlcg0KPiA+ICAgICByZWZl
cmVuY2luZyB0aGUgZXhjZXB0aW9uIG5vdGVkIGluIHZvbGF0aWxlLWNvbnNpZGVyZWQtaGFybWZ1
bC5yc3QuDQo+ID4gDQo+ID4gVGhlIHBhdGNoIGlzIGJhc2VkIG9uIHRoZSBsaW51eC1jYW4tbmV4
dCB0ZXN0aW5nIGJyYW5jaC4NCj4gPiANCj4gPiBDaGFuZ2VzIGluIHY2Og0KPiA+ICAgLSBGaXhl
ZCB0aGUgc3RhdGlzdGljIGhhbmRsaW5nIG9mIFJYIG92ZXJydW4gZXJyb3JzIGFuZCBpbmNyZWFz
ZSANCj4gPiAgICAgbmV0X2RldmljZV9zdGF0czo6cnhfZXJyb3JzIGluc3RlYWQgb2YgbmV0X2Rl
dmljZV9zdGF0czo6cnhfZHJvcHBlZC4NCj4gPiAgIC0gQWRkZWQgYSBwYXRjaCB0byBub3QgaW5j
cmVhc2Ugcnggc3RhdGlzdGljcyB3aGVuIGdlbmVyYXRpbmcgYSBDQU4NCj4gPiAgICAgcnggZXJy
b3IgbWVzc2FnZSBmcmFtZSBhcyBzdWdnZXN0ZWQgb24gdGhlIGxpbnV4LWNhbiBsaXN0Lg0KPiA+
ICAgLSBBZGRlZCBhIHBhdGNoIHRvIG5vdCBub3QgaW5jcmVhc2UgcnhfYnl0ZXMgc3RhdGlzdGlj
cyBmb3IgUlRSIGZyYW1lcw0KPiA+ICAgICBhcyBzdWdnZXN0ZWQgb24gdGhlIGxpbnV4LWNhbiBs
aXN0Lg0KPiA+IA0KPiA+ICAgICBUaGUgbGFzdCB0d28gcGF0Y2hlcyBjaGFuZ2UgdGhlIHN0YXRp
c3RpY3MgaGFuZGxpbmcgZnJvbSB0aGUgcHJldmlvdXMNCj4gPiAgICAgc3R5bGUgdXNlZCBpbiBv
dGhlciBkcml2ZXJzIHRvIHRoZSBuZXdseSBzdWdnZXN0ZWQgb25lLg0KPiA+IA0K
