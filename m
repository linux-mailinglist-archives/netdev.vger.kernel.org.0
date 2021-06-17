Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272B03AA8AC
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 03:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhFQBhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 21:37:37 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:17567
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229713AbhFQBhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 21:37:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3M3JS473Wzty6Ffe+EIfHCVJdMeVK+Rz318dqACQCBKcQRwYqjaDg67XzErgwCTAlMm6Iqo7aNRjHcnmHgpTno7irj1+O17OcqVOWmMJQgYE6JpG83a5QR9qOZaoNvWrIPYS/4AmQitVBt4Ho4PVw4CLGMrtTZoc6d/6UubZUzijJ5qPOSyVOdUDX2neGKtPj21d6TS9OAblqoMUnFONFf2M0e28NivUmYo3OASuMNo15bncNPomIWN7EvcTBXnpCaX12NXEw5Ni7dSTkp6z+PfdfL7DjnXLKC++2f2zEsrb/URXhstnU0uEcLwQoK+e+1imrxBW/j94yJ1CX1+dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Bg9RW/jPMFr9x8Q/dvAkTo+7Jk6Gjdz8/Kt2dZ/ngE=;
 b=cKYpUs8ZiBJQdX24/Kw4hmb1A3NSIDBq+mKd9Yl5SsccLMZJaMOzgMOvhyh1lRBXnrg3ReZwvz5ZOngWjk6OHJg1lTWGVjs1wyjYnaVASIXjBwVKBID7FfRq2tOvNGrSWC+jUDL2YQgmh8f109UORduhhZ3IvFeNLiTVRxpu4GUbXsWiF3Hnfk976Ni2lsE1dlSkAevB724v7aKiI3Kywz+8BAdfW1+QMenpZP4/m5ljTVrW2JoHPlECRTUcGNmr/ZqjczgCp6Nekz0p4+/CXqlZxhLEOAIWA8uHW/97KQtqjfW+3CBIvqSD007mt8xUGS4Cfxr1mwJdzAUUooBalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Bg9RW/jPMFr9x8Q/dvAkTo+7Jk6Gjdz8/Kt2dZ/ngE=;
 b=LmBlLlLDncePJxFTwpJSxKvMysqGIpKP1alfMwC1jG+aQSP+xe3hsJIUxSDL94YS4t19OQxeEod78cFwl3DiluehuGF6ls/pCqznLnyb2ZxNwdT3C4RY4OocDxyAPBP7Ux5AhJsnTqM0rIMjpHB9uDHVyxehz9XNLv6SwYT/qlg=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6137.eurprd04.prod.outlook.com (2603:10a6:10:c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 17 Jun
 2021 01:35:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 01:35:27 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Fugang Duan <fugang.duan@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: RE: linux-next: Fixes tags need some work in the net tree
Thread-Topic: linux-next: Fixes tags need some work in the net tree
Thread-Index: AQHXYvtoHJlcLjJ1M0mzzLiw6wkXP6sXaMwQ
Date:   Thu, 17 Jun 2021 01:35:27 +0000
Message-ID: <DB8PR04MB67951808ECD63EE4A241D6E5E60E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210617080307.3b1771d6@canb.auug.org.au>
In-Reply-To: <20210617080307.3b1771d6@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe8c8b97-8881-41eb-037e-08d931302fbc
x-ms-traffictypediagnostic: DBBPR04MB6137:
x-microsoft-antispam-prvs: <DBBPR04MB613738C733939E5F246C6383E60E9@DBBPR04MB6137.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:88;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5sIP61WfN4iGjQWZI9jtVAYrtELKbG6zgZIJYAxN5M2GPOkliKiKlRmp6LzoIr4Pn88PcHaW20umlaw7pNd7Cs0DpekU7f4bDiPnTQmnfDlHb62RP+rCRtdy+Y9N9Ak9Y7Rgb/o/PHhCj7/m2eX+VPcloeDVd45pbiZ0JTXrPZHkjqbMnw6fAPBl8k2CDZQ8Elwh6B0oizQ/JcJGvxsSg+XadPuBqEJf6pinZoKgETmDs7EYGRPUKrfjjhnJdVma1cME/kDq/XNvOfrv3kz9dCD9PeZ8cp8awfcAllJzDvpMB8PGMwF+56wO3YBNyLabYyjQpwSUOMLxAMULoBlzrELh0josQBlnt9oYZz59SyzoBaf0fc7uJrscIIRS3fnlpl7bgJhowMxrFakHH6Mp9SyuqEDpJBFMawmh717MWmdf+6U70JAOuGpH4buGq2jORoYDR9QPhtDq0TCsKfLP3emhyV76mjoTdjFzm1orI0+9nkfWrtbvUcaF6dreMHSABFDrOVWnUtxqp6loDlNgV21dzqZ9l1KvnMDD/7Un10rNUMnl8b+OeDz5Tm1n4p+RVAolY25eFiO3hc+TmjaIn0jOD/rH5mjJVfsKd5FW2qo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(64756008)(110136005)(66446008)(33656002)(9686003)(66946007)(2906002)(122000001)(52536014)(478600001)(76116006)(71200400001)(66556008)(4326008)(38100700002)(5660300002)(66476007)(53546011)(7696005)(6506007)(8936002)(54906003)(55016002)(26005)(186003)(83380400001)(8676002)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dzlHa3hqRG5teXV1MkxuQjhOWEpQNXo1RkpZOVZjREVrWlNSYWd5NlRKeDhF?=
 =?gb2312?B?RjN3SGI1ekNPendMUU5adWx4YXBOcHJlbFM3ZWFBUGswTWhDTW9Oek12VzNo?=
 =?gb2312?B?YmpqTGtHT1FISTl4dlJvUHJyZDBQUm5tZTVTTVNLcW9Pdm9oQjhocnpYME1s?=
 =?gb2312?B?YjJWalBkSVV6WFZsL0dRWGlneThJc2c3OWlESk9tT0lkamRkS0xncElKd1RS?=
 =?gb2312?B?L3B2S2JXN1NrUkVnaFp4YTIyKzZBREEya1ZaSWJhSmlvbGYyY1JtcUdJbysz?=
 =?gb2312?B?dnd3d1RIZGpTYXRLcDdJMEJOVlZrMVZSVjFhNWxLNlQ0clp4NC9WQzRJUk5z?=
 =?gb2312?B?UU1EaUJCNHBJaUZHYVA4Qk9IZ1dlYmwxcWFZMmpKaFYycGtkai9KUzhEVmVZ?=
 =?gb2312?B?a3NJZEE0TnAzQUt0UWZEcFg1ZlZVdzlpNWdqWlRiRkc3L0QrQUwvcGtnamZx?=
 =?gb2312?B?cGlpQ081SjBuWDBLekRJTGc2QXJscGVibXhtTVptWk84dTVQb2tMYnZKdFc1?=
 =?gb2312?B?WWU0RlVwZk9hWUZVM20yM0hCcEpwV0E1SWpKT2wxUy93OUVzemFUQnZpZHBL?=
 =?gb2312?B?THVwVUd2aW1WMkt4eDgvTm84NkkyZTR1TkFESUNkOW42am04OUd5Sk1idXBr?=
 =?gb2312?B?eEh5bEpWRGZBYlJONlRpR2tVSUc3OEtVbzRCY1hWSmgvbUhSVmluTmZqdVFz?=
 =?gb2312?B?RVREaGQzU001S0VyNGlrVk5EMlFnLzE0M3lLMkNEd1R2b0M3YktRSXNuSGFh?=
 =?gb2312?B?cTdncWJUYkhDZk4yQ2VsY0hFZHQ2dEdjMVFnTlJqQmRXTFllUTBEN0FqZWpr?=
 =?gb2312?B?QmVSTisvTHg1RE0zQlJoYkltVkJ5VjVYVjFVRzRWU3M0MFFwL05rZEtzaktL?=
 =?gb2312?B?a1JTNEFjUktvckRCQXZXdkRIMFAweTE1S0JZSXoxczBWRGk4Y2FkRnpST28v?=
 =?gb2312?B?S3lZZ1lNazFTU0JoNXBSYkszMGVJdWRCWENaVUU5WVBzQVdxWXltclRQRUtK?=
 =?gb2312?B?a3A4R1FnMDdGSmFhTjRPdjltTFRJNG1jQmtobzZueHVBSDJyMXBQaGR1Nlp6?=
 =?gb2312?B?TFJkSUY5bWdEQkk0RDVjNENJSTdiVHg5Kzg4citMa1lIWWdnMXplZXp4NGo5?=
 =?gb2312?B?dWxsaFZyUzFhVGRUUlEzaTBkMXJzVzZ4ZmpBTTJtb3d4OHNFV0NxWUMxTWxX?=
 =?gb2312?B?MkxuMW4vUHIvSXpCSUFnZWFkTFFnUTFtWHJjaENMaDk5RGJMT2I5SWQ5dVRr?=
 =?gb2312?B?SlYya1A1bmNvRlEyamRDOFVxS2RCMTkxRVgrc3F0K0hkQmtnS3NOalhtTTY5?=
 =?gb2312?B?T0xCUDUzY2crWjFsT2FOYis1bThsR2FBQTFwRkJqT0VGbzFBTUNwOVlRdmxI?=
 =?gb2312?B?d3ZuU2QxM29GOWVPVUpZQzRLSDZOWUlqL2w5dXRrbFIxdkpqU0VCWE1SNUhN?=
 =?gb2312?B?UUhlelN6d2NKbXY1VmtmaE1SakRFRXFDL0RGNk5HalZOVk5zTDlyOTR3aGdn?=
 =?gb2312?B?d1lmbjVQNjN3aWJFUmNPRHVvZy8vS3RzSVU4NHBxMlJ6cndDMDNJZ3kweElw?=
 =?gb2312?B?TWJmOGJVOFhjUmMrTWxtQjBrUG0wb3UzU1d2TGhaRzhzSmVtSktmSm1FMmw0?=
 =?gb2312?B?NWFVejZnVnRKcnBla2F6QTJtNnhhS1B2dFVSaTdjd0hpR1FQUFYrTGd4Q1dE?=
 =?gb2312?B?eW5BUzVDTU95c21tbEw2aDk4QXg5cXFpcWUwa1JaaHltNWNuYlFoRXdzKzh4?=
 =?gb2312?Q?4hoUTs5o6wr3/10WeE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8c8b97-8881-41eb-037e-08d931302fbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 01:35:27.7672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywVBASurfF17yYF7o6ai+fBkoJl/ItwkCHwpnxgrmdpT0tvNXB56aG84dJZjYiJbe1/NqGTLI4ZHeFxJU2nGCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTdGVwaGVuLA0KDQpUaGFua3MgZm9yIHJlcG9ydGluZyB0aGlzLCBpdCdzIGEgbWlzdGFr
ZSB3aGVuIGFkZGluZyBGaXhlcyB0YWcuIEFuZCAuL3NjcmlwdHMvY2hlY2twYXRjaC5wbCBzY3Jp
cHQgc2VlbXMgY2FuJ3QgDQpyZXBvcnQgdGhpcyBpc3N1ZShldmVuIHdpdGggLS1zdHJpY3QgcGFy
YW1ldGVyKS4NCg0KQ291bGQgeW91IHRlbGwgbWUgaG93IGNhbiB5b3UgZ2V0IHRoZXNlIGVycm9y
cyBiZWZvcmUgc2VuZGluZyBvdXQgdGhlIHBhdGNoZXMgZm9yIHJldmlld2luZz8NCiAgDQpCZXN0
IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9yZy5hdT4NCj4gU2VudDog
MjAyMcTqNtTCMTfI1SA2OjAzDQo+IFRvOiBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBOZXR3b3JraW5nDQo+IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogRnVnYW5n
IER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+OyBKb2FraW0gWmhhbmcNCj4gPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPjsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZz47IExpbnV4IE5leHQgTWFpbGluZyBMaXN0DQo+IDxsaW51eC1uZXh0
QHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogbGludXgtbmV4dDogRml4ZXMgdGFncyBuZWVk
IHNvbWUgd29yayBpbiB0aGUgbmV0IHRyZWUNCj4gDQo+IEhpIGFsbCwNCj4gDQo+IEluIGNvbW1p
dA0KPiANCj4gICBjYjNjZWZlM2YzZjggKCJuZXQ6IGZlY19wdHA6IGFkZCBjbG9jayByYXRlIHpl
cm8gY2hlY2siKQ0KPiANCj4gRml4ZXMgdGFnDQo+IA0KPiAgIEZpeGVzOiBjb21taXQgODViZDE3
OThiMjRhICgibmV0OiBmZWM6IGZpeCBzcGluX2xvY2sgZGVhZCBsb2NrIikNCj4gDQo+IGhhcyB0
aGVzZSBwcm9ibGVtKHMpOg0KPiANCj4gICAtIGxlYWRpbmcgd29yZCAnY29tbWl0JyB1bmV4cGVj
dGVkDQo+IA0KPiBJbiBjb21taXQNCj4gDQo+ICAgOGYyNjkxMDJiYWY3ICgibmV0OiBzdG1tYWM6
IGRpc2FibGUgY2xvY2tzIGluDQo+IHN0bW1hY19yZW1vdmVfY29uZmlnX2R0KCkiKQ0KPiANCj4g
Rml4ZXMgdGFnDQo+IA0KPiAgIEZpeGVzOiBjb21taXQgZDJlZDBhNzc1NWZlICgibmV0OiBldGhl
cm5ldDogc3RtbWFjOiBmaXggb2Ytbm9kZSBhbmQNCj4gZml4ZWQtbGluay1waHlkZXYgbGVha3Mi
KQ0KPiANCj4gaGFzIHRoZXNlIHByb2JsZW0ocyk6DQo+IA0KPiAgIC0gbGVhZGluZyB3b3JkICdj
b21taXQnIHVuZXhwZWN0ZWQNCj4gDQo+IC0tDQo+IENoZWVycywNCj4gU3RlcGhlbiBSb3Rod2Vs
bA0K
