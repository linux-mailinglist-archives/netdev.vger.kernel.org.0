Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A736049AA8F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385197AbiAYDmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:42:25 -0500
Received: from mail-eus2azon11020026.outbound.protection.outlook.com ([52.101.56.26]:49709
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1325913AbiAYDjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 22:39:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dq8LLbSmnA1/NtU386JuApmnrEW0rvIieYFIhtrBSSZdWzB1RAv9oYuiuFC7vPfeeaIw6/sZVDOnSlQd7SfdYE9hWqhwqiyGQN6yC3LndOJbjq/aqNVyUKaxlmcCoqLPGDydRvHe2sj9/7lG3TSk2Gh6jecd5dPHSvF9ZcHzlbyqYuMM2kJN3Dr3iDRP3r8vd/fmZdrlVMnOqQLpdau5fefeVDD3QTagB6b0Rxbh7wLEHAIEQylM3ILvIVFJPBqqeCAHfPriKdQxy4NCSqrsyXnPccvWqAyi1n7PwDoaVwRaGSqCpEqqM5WTtvzVoVSfbPCb03OROJCLe2ViBXGX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1kjhXXBSEvLykQPkTVNEBnDx23R/+vMyZJUGCnxm5E=;
 b=VtAUxneekgtyEebVXV5Np9atp6CBnivDHM81iA6Tud2PX/nAxZZPdtdg4WM9No3IlUDWaJaCE9BTXqqJaPKf62YtFVYerj8a3QhCTNimAgVVxWNbUOEJT/uN3U6qn9tNaE83YRoq4ZTu6ZErCnAtjCYBywKZUyCPwVQosM7k4FuLLH5JMs3ls5ZubCI9BfO5eBBpO0DXB23KmZNhUEDJMHZyQ1fN32zl7S6EHWnoinsPX2OPdr6/DIBM5qtkcJC6UMWtNuPCNsXD3Ys5pzJJk8xEkkF/4tmiQ5VMVZwz10DEbAUm+FXVmVgT1Z75Ddwo2KVnMORPwNNI1kfo2gqQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1kjhXXBSEvLykQPkTVNEBnDx23R/+vMyZJUGCnxm5E=;
 b=Yh2EMhcBHsVlfxbgXf0ZYy4NxLocZ+FXoZRq3isfIZ/XAii/WaMq3pG/Rv15J52cJfynQsZb4msBw4XiKNoL62rhMpej8LmyaU/scc/oQ4Tpuh02zgIXABhgE7+EsQNRb1RoREnt4vSEby1tW5hdtK3wjZir/d0G7uRUOCWl7ec=
Received: from CH2PR21MB1464.namprd21.prod.outlook.com (2603:10b6:610:89::16)
 by SJ0PR21MB1965.namprd21.prod.outlook.com (2603:10b6:a03:2a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.3; Tue, 25 Jan
 2022 03:39:04 +0000
Received: from CH2PR21MB1464.namprd21.prod.outlook.com
 ([fe80::d530:6c09:56aa:dcac]) by CH2PR21MB1464.namprd21.prod.outlook.com
 ([fe80::d530:6c09:56aa:dcac%5]) with mapi id 15.20.4930.012; Tue, 25 Jan 2022
 03:39:04 +0000
From:   Dave Thaler <dthaler@microsoft.com>
To:     Quentin Monnet <quentin@isovalent.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: RE: Bpftool mirror now available
Thread-Topic: Bpftool mirror now available
Thread-Index: AQHYDUOvChWv7WrZkUSyKloA1xiDRKxr9ViQgAYnrICAAQCp8A==
Date:   Tue, 25 Jan 2022 03:39:04 +0000
Message-ID: <CH2PR21MB1464B0B4A9BFF34D1386DF0EA35F9@CH2PR21MB1464.namprd21.prod.outlook.com>
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
 <CH2PR21MB14640448106792E7197A042CA35A9@CH2PR21MB1464.namprd21.prod.outlook.com>
 <127cb5f6-a969-82df-3dff-a5ac288d7043@isovalent.com>
In-Reply-To: <127cb5f6-a969-82df-3dff-a5ac288d7043@isovalent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7ce3db2d-8efa-411f-b764-44d81a7205c4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-01-25T03:31:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cb1a965-1605-4901-45d4-08d9dfb43c46
x-ms-traffictypediagnostic: SJ0PR21MB1965:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <SJ0PR21MB196565BF51CAA90B4D2FC2A5A35F9@SJ0PR21MB1965.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uw/jkjfhw3GroVUmQXtepXoPDVzuEKV6z7hvxIgZ6p0FLjvS++SdIWQWNfK0HkjwE+0QpW9YJst/EzpR6ncSiSbiksOUNe9s5ms6fgq4+w4j2TWq1t+j09BrOw1qx6Jk6EImaqXBpguOZA3fsdSj85I3mmRHQ0RTMfYUCOaNtzK5kTKSpzP6K1aZ0GY+zXFRT9sCSwZRhVRB/iObRh8JKhPxeOry8mXsJ2tuO2k19rQTD/zEWJAlDEvyg3ccW57ke26TSb4F2+BKfyH2XuJHrLJFV1elO/Y14NyvqnPl5s1abK1Hj2MNxhmTRTAgR2lpoYN/Nd/1Jyk8inQrAxenGeEcyxIhW/c3wyL4Er0aZ/GX2wXpiAjLS/uQAHV7cqu2hSogkeX9LGc8PTocwg8C1dbr3RyjymOmQFsozfeW7sacAMZF9+R5roUiklqHSinFuYqAtohH/GCgGyTfhGeVXjg6ncDL2dgy9EjrK7DVGeMWjmlGuY+BjcoRuAyiG0erlbUzgQXLF7yK3Xp0ZgnB7WOdFn4WDPjWth5+a5UI7p4/e1GUqSNPRDH+4XxGkoZoFqsxHWfL2nknmL/OuMk2P1w+YrH/NuPiqxz4UjlrPVPdGiPvSOc8ZgcmC2efaec5k/vxOvbc4VaExuYNB2saUE87CCrHKWaaaYkx5icECwe4tmYKaroqR3ioUAb34OYArQSltQO7WbRQH8afM3nsPtCxvpBahIzfsfjLLRZwywyDoaVDPrmlkopGcLQyxSMu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR21MB1464.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(52536014)(38100700002)(2906002)(8676002)(6506007)(10290500003)(64756008)(66476007)(508600001)(4326008)(7696005)(3480700007)(316002)(66556008)(8936002)(66946007)(66446008)(9686003)(82960400001)(55016003)(71200400001)(186003)(33656002)(122000001)(38070700005)(8990500004)(82950400001)(5660300002)(110136005)(54906003)(86362001)(76116006)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHQ0aWlFYk5LMjc3Zk5PaDhLcStsMnF3NTJGWGNmclVvSjZsRTczZk1wdzhE?=
 =?utf-8?B?VFFVakxFVTNEbkxOL29KNDE3UkNUVVdiRnVweHRac0xSYlRKVlY2dDVXWVVj?=
 =?utf-8?B?dlloZUhlbnRRa2FRellpM01KS1FvTU9sZnZsQ0tZK2lPbFJCdnhtS3JLZlFI?=
 =?utf-8?B?KzdnMkRDbUNmVzJYd1JHR0V1UktaR0hKMnFLK1dsdHhleE00ekV2cS9Hd3lZ?=
 =?utf-8?B?b25aTXprZWdKNFBjWVp1M0ZLM3liRk1qTEY4MGFTQk9INVphL242T1crV2p3?=
 =?utf-8?B?WWpkMGVQaGk5Rk1OT1RESlNkWjZuNHBhamZGYVo3ZEtaSGs5L1JrWFhaTXhs?=
 =?utf-8?B?eFdhZXVQNUdVUG5GNm9xNEk0ZnBiWW10UXk2b2tjSWJLUTViUUlBUTNFdXFY?=
 =?utf-8?B?Qmw2cEhrU3ZUWHdBZXRBTW5sdm1iNVVBTEwwY2pnWVkrS1Y5dFR2VDcwekto?=
 =?utf-8?B?VGpxd0srZlVoS2JiSVByUlBjRFZmWTJXVmVRZDAyZGFKN3pzaHVIb0k4bk1n?=
 =?utf-8?B?NXUxSWdxQXNDN0tqclRRYWduQkgyaVpZTlJDZWxXajdHS0VORjAyUkFVNms3?=
 =?utf-8?B?dTloc1p4Q1hFVTFRTjUvVC9nMUl3dHNIRGRGaWs4UFd6a3NpNzdlLzV1bitT?=
 =?utf-8?B?NG1SVFg2bWpYenh5SmRCa3ZDaXNveDArNHgyQXZ3N3VTeXhDakhDcmorQVVr?=
 =?utf-8?B?NVoyT1hXUWRNMUhJTHY3b1NZVDA0cFhIWGk4ZlZJZHNrYVBhUXBZTk5QdWIz?=
 =?utf-8?B?b3k5NmtkTSsyTGc3Um1CMXJMeXBkTHplVm5PRmM3bXJVQlIySlRCb1NtTHFR?=
 =?utf-8?B?SW5NQ3NER3ZmazZ6NXNLSlBTWGVBNHE2ODJkV3VuQ3pVWGYwMlUzTkFqMzlk?=
 =?utf-8?B?cW1QeVVGRkVUUDN5ZjBMMGZKYXh5Q2p6R1ZocDZ2YkxDMG95ZzVySVhxdC9P?=
 =?utf-8?B?SmFOaG1ock4vSGNPOS9LQVVVa2l4SExZaVgwVExGUnpvaDR1elRRQ3pML3JZ?=
 =?utf-8?B?eDAwSU9NOXhzcjc5Mk1TNWorNVVobUxxMThHWEJaTXk2TjVmQWtPUFJUeWI0?=
 =?utf-8?B?dXNvS2RYR1NhNnlDbFhhbVN1emNXQkNWUlVLZmJlSGJPU2thWHVoRkg2Ymhn?=
 =?utf-8?B?M0U1STFObUdIUlUzNGhsaml3SzN3eFdGaDB6b0pUR2tRSktsZUN3N2ZDNlI1?=
 =?utf-8?B?NDJMVEN0bkRGdlorQUlDLzhreXd2R1dLMHA5R1ZwcWFXNXc4Nm0zTERxVGVS?=
 =?utf-8?B?V1RxMC9lUzM4MjMyTGpCbkEzRW9uSlRPMlVyd0UraytqdXZMZDBKQ0VtQlFl?=
 =?utf-8?B?SmliRlJCNkorOUlBU3hLZnVCeVdONm5JTXF6RmZxT3dpRzY2WnEzNmdYTXFX?=
 =?utf-8?B?aU9NMVJzRTRrL09UVlhaeEtxUUZMY0w3akkrU1J0Sis4TWpXMitrZGVMSGRn?=
 =?utf-8?B?akZkalUrQm9vNnhhQzAyQm04NEhBNHkzZmV4b0FTaENYZFVHK09WVEJyaVhv?=
 =?utf-8?B?TUQybUM5cmRjbFhaU3kvelIyb3h6UDFyRDJlV29Bc1ErM1hHSU84eTJRbm84?=
 =?utf-8?B?UGhPMHRiL3EzTG8rVHdERWVaUlI2Q1d6UnIya1dod3QzZjErUUpnWWtINk82?=
 =?utf-8?B?VGlHM0lXMU9MdFZyNVduL2Q2QVpNSGtsNkE4Ym43MXhFNmlwMzJHNEJrVTZ3?=
 =?utf-8?B?aWx0YWhrNEVYb2pxOVQzdkh3MWxHNFVNcW5HcG8rWHYxd0k3akhYSlQ2bm96?=
 =?utf-8?B?RjVGSVJzcHpNQVgzSXYxM3BiaEt3RXpUclJyV3hGQ0Q0SmFqcEw5V29TWmlK?=
 =?utf-8?B?MEpvZEMvOUwvTllJcWovRCtUSWdYcnJkVWM0cWtRWVh5dVVPT0ZGMG8rNVVk?=
 =?utf-8?B?ZDdwam41VVZXd2V3UElFT09Wc0wxSXNBNzZUYWtWRjNjSnRSWUt0SHNVa2Qv?=
 =?utf-8?B?M04yVEtMMkdCMUVJMzdXeWMxWHpON0N3cktKZUEzZ09KTFprdGx4enp5RUZG?=
 =?utf-8?B?SHF0cXFiSmpzZi8vMU9sRi9OcG90Ti8welhIeWphL2dWNkhkc0FVSzR3NVEw?=
 =?utf-8?B?Y0pYQ1lNRWdUd1VWL1JnRWx5WnBhMW1uV3VWcStlcTRIMDhkcjFQWTlGQWM4?=
 =?utf-8?B?QUN3K1pEV1R3TDB6U2t3VDh4b3NQRlRVcGJhUlhSaHQxNnc3a3ptZ25DWlhR?=
 =?utf-8?B?WGFiQ0pmYVIwZXhiR2w0QVUyNFc0QTAvaytlb2Q5OTMvbWlRZVJHeldHT2ll?=
 =?utf-8?B?SEdXeko2U29HWG8vOFRyTXhjM1RvNzR3NU85OW9QNEJBUm5qYnNjOElHdmV5?=
 =?utf-8?B?aXpSZUJkMHpwbFpQUDVMUjdvSzJrSG9kVFdJQzI5NThCR1p6QlJUdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR21MB1464.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb1a965-1605-4901-45d4-08d9dfb43c46
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 03:39:04.6332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /MBTOQWuFtMrZNu4xHET4nqAc6VC6DgRhWmTqRIsFz3QZr+uZ0mdpCuuIhb4uOk1Xd6eGyE3VcdlNdVvZSwvhmlrfhkZBOM1DlwGQ5zUu8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UXVlbnRpbiBNb25uZXQgPHF1ZW50aW5AaXNvdmFsZW50LmNvbT4gd3JpdGVzOg0KPiBBbm90aGVy
IHRoaW5nIHRvIGNvbnNpZGVyIGlzIHRoYXQga2VlcGluZyBicGZ0b29sIG5leHQgdG8gdGhlIGtl
cm5lbCBzb3VyY2VzDQo+IGhhcyBiZWVuIHVzZWZ1bCB0byBoZWxwIGtlZXBpbmcgdGhlIHRvb2wg
aW4gc3luYywgZm9yIGV4YW1wbGUgZm9yIGFkZGluZyBuZXcNCj4gdHlwZSBuYW1lcyB0byBicGZ0
b29sJ3MgbGlzdHMgd2hlbiB0aGUga2VybmVsIGdldCBuZXcgcHJvZ3JhbS9tYXAgdHlwZXMuDQo+
IFdlIGhhdmUgcmVjZW50bHkgaW50cm9kdWNlZCBzb21lIENJIGNoZWNrcyB0aGF0IGNvdWxkIGJl
IGFkanVzdGVkIHRvIHdvcmsNCj4gd2l0aCBhbiBleHRlcm5hbCByZXBvIGFuZCBtaXRpZ2F0ZSB0
aGlzIGlzc3VlLCBidXQgc3RpbGwsIGl0IGlzIGhhcmRlciB0byB0ZWxsIHBlb3BsZQ0KPiB0byBz
dWJtaXQgY2hhbmdlcyB0byBhIHNlY29uZCByZXBvc2l0b3J5IHdoZW4gd2hhdCB0aGV5IHdhbnQg
aXMganVzdCB0byB1cGRhdGUNCj4gdGhlIGtlcm5lbC4gSSBmZWFyIHRoaXMgd291bGQgcmVzdWx0
IGluIGEgYml0IG1vcmUgbWFpbnRlbmFuY2Ugb24gYnBmdG9vbCdzIHNpZGUNCj4gKGJ1dCB0aGVu
IGJwZnRvb2wncyByZXF1aXJlbWVudHMgaW4gdGVybXMgb2YgbWFpbnRlbmFuY2UgYXJlIG5vdCB0
aGF0IGJpZw0KPiB3aGVuIGNvbXBhcmVkIHRvIGJpZ2dlciB0b29scywgYW5kIG1heWJlIHNvbWUg
b2YgaXQgY291bGQgYmUgYXV0b21hdGVkKS4NCj4NCj4gVGhlbiB0aGUgb3RoZXIgc29sdXRpb24s
IGFzIHlvdSBtZW50aW9uZWQsIHdvdWxkIGJlIHRvIHRha2UgV2luZG93cy1yZWxhdGVkDQo+IHBh
dGNoZXMgZm9yIGJwZnRvb2wgaW4gdGhlIExpbnV4IHJlcG8uIEZvciB3aGF0IGl0J3Mgd29ydGgs
IEkgZG9uJ3QgaGF2ZSBhbnkNCj4gcGVyc29uYWwgb2JqZWN0aW9uIHRvIGl0LCBidXQgaXQgcmFp
c2VzIHRoZSBwcm9ibGVtcyBvZiB0ZXN0aW5nIGFuZCBvd25lcnNoaXANCj4gKHdobyBmaXhlcyBi
dWdzKSBmb3IgdGhlc2UgcGF0Y2hlcy4NCg0KUGVyc29uYWxseSBJIHdvdWxkIHJlY29tbWVuZCBh
IHRoaXJkIGFwcHJvYWNoLiAgIFRoYXQgaXMsIGJwZnRvb2wgdG9kYXkgDQpjb21iaW5lcyBib3Ro
IHBsYXRmb3JtLWFnbm9zdGljIGNvZGUgYW5kIHBsYXRmb3JtLXNwZWNpZmljIGNvZGUgd2l0aG91
dA0KY2xlYW4gZmFjdG9yaW5nIGJldHdlZW4gdGhlbS4gIEluc3RlYWQgSSB3b3VsZCB3YW50IHRv
IHNlZSBpdCBmYWN0b3JlZCBzdWNoDQp0aGF0IHRoZXJlIGlzIGEgY2xlYW4gQVBJIGJldHdlZW4g
dGhlbSwgd2hlcmUgdGhlIHBsYXRmb3JtLWFnbm9zdGljIGNvZGUNCmNhbiBiZSBvdXQtb2YtdHJl
ZSwgYW5kIHRoZSBwbGF0Zm9ybS1zcGVjaWZpYyBjb2RlIGNhbiBiZSBpbi10cmVlLiAgIFRoaXMg
d291bGQNCmFsbG93IFdpbmRvd3MgcGxhdGZvcm0tc3BlY2lmaWMgY29kZSB0byBzaW1pbGFybHkg
YmUgaW4tdHJlZSBmb3IgdGhlIGVicGYtZm9yLXdpbmRvd3MgcHJvamVjdC4gIEJvdGggdGhlIExp
bnV4IGtlcm5lbCBhbmQgZWJwZi1mb3Itd2luZG93cyAoYW5kIGFueSBvdGhlcg0KZnV0dXJlIHBs
YXRmb3JtcykgY2FuIHRoZW4gZGVwZW5kIG9uIHRoZSBvdXQtb2YtdHJlZSBjb2RlIGFsb25nIHdp
dGggdGhlaXINCm93biBwbGF0Zm9ybS1zcGVjaWZpYyBjb2RlIG5lZWRlZCB0byBidWlsZCBhbmQg
cnVuIG9uIHRoZWlyIG93biBwbGF0Zm9ybS4NClRoYXQncyByb3VnaGx5IHRoZSBhcHByb2FjaCB0
aGF0IEkndmUgdGFrZW4gZm9yIHNvbWUgb3RoZXIgcHJvamVjdHMgd2hlcmUgaXQNCmhhcyB3b3Jr
ZWQgd2VsbC4NCg0KRGF2ZQ0K
