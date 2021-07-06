Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CFB3BDA48
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhGFPhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:37:40 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:54845 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbhGFPhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1625585700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Yzp0lZEtPf/qPN/VXlRlF9/chWLWAwa1+0LQcN2mnA=;
        b=cLyD4tlnHivhy3sZeesRKdsRh5ww5xSnvb1/5tKEY3xoVfzmMlF+R0eWhIyL5JAuzWY7bw
        E8mTT53edO5gguaXVPDOPeSBwKVlMAU2RVib2lS6fXhlG7jB0z4CcSImRMViycM0bAQzYl
        Pp4Y5x0nStSkZxlc/Qv/2imQxWeF1Y0=
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-8x2R1KkyNpi5wDD0VNParA-1; Tue, 06 Jul 2021 11:34:58 -0400
X-MC-Unique: 8x2R1KkyNpi5wDD0VNParA-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB1037.namprd19.prod.outlook.com (2603:10b6:300:a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Tue, 6 Jul
 2021 15:34:56 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 15:34:56 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXblLidA9sMBr3UkmswKjsJw5n+as2HEqA
Date:   Tue, 6 Jul 2021 15:34:56 +0000
Message-ID: <7e2b16b4-839c-0e1d-4d36-3b3fbf5be9eb@maxlinear.com>
References: <20210701082658.21875-1-lxu@maxlinear.com>
 <20210701082658.21875-2-lxu@maxlinear.com>
In-Reply-To: <20210701082658.21875-2-lxu@maxlinear.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d920214a-713c-472b-08c4-08d940939b93
x-ms-traffictypediagnostic: MWHPR19MB1037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB1037BE2778F6D0AD57BEA328BD1B9@MWHPR19MB1037.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: J6U63VvsStLlz8sBseZoMzBRZqpjsOhl4mTjft6a2USVcXp14rhHf/g27qjIbrssnRiBwQRmc15iDH4vrB7ctdOIevUWD42gdUNKljJSuoaCBD+uskNSJEP4slmQJQSpOS/n2622WpQ2WZt6ZvDKqMq7Cf3i2mHwQx+dJVHu0XDqPSB2DXiKGbTN6mWWuJULqnE+GlUrn+6WBphW+lizwQYrXa8spBQXwPmwkRlyFsXLgjUgDagso+b7W/jWGKq1/UxsYi1KZmCSjTGqjz9Hij/QT0oB0yqcBkX/VclG31+BO3rXTxZBJGDN8Nocn+t7gLPagMbTSXWWJWICG8I1rIAIF6BL6mXZNd9RtCToNXjMdASkY/O7bxc/y5N7z86cIR4/QG+/Ed5bhZp6DtCOv3rmansm9bCElk6Q8wmMpYWxFJCpN+EjtcK25YhqcHWpzTPogS80lkVF8kq957srrDlZlInPA3/cQ6jVpP46LdNJrxx7ySy2FdZW4UPah+H+YSAQ0cLEDQUf3VvLDmYnFKS/cSzkNIOMI90MPajSalpN+O1D8is51IYfQx3/Hip84gH4aw14hYMi24jk2/+Pq9yycuywNaUkYHX3MtQ5XEbuNKkZ4mVu+MbZvt4gAVU7todOBfWJ7jzsHy93iR7Z7/6w9OFPnwk1Bu44oJkSM/TYoZpG/rjMW4dm03FJCJ/LOoY0EXI3BzhawR8hf7V7Vnn/48LPIgF/uqyHgkqYHS9Puo2hcd1/AH7tLdSqrp4I/Ocu5EbO+8tXDlSTEpv6IZY+xYFz2cO1n65EXNAe2ReMlV6rzONVJCvyTrNhwtOI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39830400003)(36756003)(6486002)(84040400003)(2616005)(54906003)(6512007)(110136005)(86362001)(316002)(31696002)(478600001)(53546011)(5660300002)(122000001)(966005)(64756008)(66556008)(4326008)(31686004)(71200400001)(26005)(186003)(91956017)(66476007)(8936002)(66946007)(76116006)(83380400001)(6506007)(66446008)(8676002)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUxnZ0l1cGFaVjV5ZVRSVm5KTmNoSHFrRmdnNGx6dUVJRW9TMDBXSnUzUUF3?=
 =?utf-8?B?dk5CS3N6Q2wwU1BNdi93QjVtWGs4TnhpQ3VOWFpBWkVZRDlhdWJYMGUzWklj?=
 =?utf-8?B?aG5BcnVvUVJHbUVxd2RrcjlEbVROMDRORFJVN0NQeXZER1d2bTJGRzdBdmhD?=
 =?utf-8?B?cE16S3JUZzFyeWhBQ3ZGTG5pK1gvbllFZjQzcFFVRkNTNFFVR3FLbWZKcHNm?=
 =?utf-8?B?V0EyT0FpZlEwNGM0Q09YM3o4SFdsQzJIK2hDWXB0VjVFVTMxQWpkMlBRWkd5?=
 =?utf-8?B?aHJzYTlJMnlneWVUOWk1SHpNQS9LbTloUDVQcVBOejhaSS9LWU1mQ0RGcUww?=
 =?utf-8?B?SFJ0dUNQZitEZjRzT1BBenkvaDN5Mm9talRqalM3WHg5RlVONjVFTnRnYkI2?=
 =?utf-8?B?ZTcwYldya2wyMVpRakZJcHBCUnREdUhVaEVkRElBUERlQVFPR1BwSnV1NDFY?=
 =?utf-8?B?Ykg4R0x6QUNnV01QMVlKMlhIUHNDaERYdTZDTnBkZTBKMy9ZT1d1Y3l0cVZI?=
 =?utf-8?B?TjVubGdWMFRsZVcvdEo3a2IvUmV0cHdXNUVUaWdSYmlmR2xzbmhvRjNsckNt?=
 =?utf-8?B?WlB0end4b0wzWGs0VjJ3MTZhdUt2RjJRKzgrc3J1SE81R3BMdXd2UGc5MlVj?=
 =?utf-8?B?N2Y4U0o3dktiYlZnSit0WVlDbVJEZ2FuSzFlb2Z5MDFBeGtNdWgwU3FleTd0?=
 =?utf-8?B?YWtaN01wODdaRGYvSDBVTHBVWVdITytXUG9BNXVXbUowOXNnSEp3d1dXVEpm?=
 =?utf-8?B?bFFpODhDb0NEUit4NnBmb2NRaU4zdEt2cmtVSHEvY2lkM0RlSEZJRzlzUTUx?=
 =?utf-8?B?aU10R2MyQXJXaE8vcjhCUDI2ME9iZER5ZW91VEdFRXhnejRQVXVocXU1RDFH?=
 =?utf-8?B?c005T2FhTEZFck9KWlN3TURyZ1h1SDR0WGFmSUdpalZCc2dOV0VTTWVac0dY?=
 =?utf-8?B?c0JPQlRzUEJxNkRpa3h0RFI5eVYwTGcwbWxaNHdoQ3BWS1I0c3NVaE1oNGZ3?=
 =?utf-8?B?Um5RbEZkalNYelFJa0xla1l4dUE2Ymx6RU55eXkrVWhiUmMzeFA3d0xUbFRH?=
 =?utf-8?B?U3E1d1p1L0VHMWNqUG43N1YzZXJhZVhjR3NEZTF6eTNVbVNIT0tyY2FkQWta?=
 =?utf-8?B?QVNrUndRWGl1blRkUUhQT0VaODRwRVNHVjNudkRRcVMzVVNhb3lhZ29qYUlt?=
 =?utf-8?B?OXlQNXBMR0dmbzJ0ZExScUQ3RXh5V2x0NWFiVGNYVnRIRUIvdWhYNTJHZkor?=
 =?utf-8?B?NDNMVlZFQ2VtSTBMTGJ0eCtVK04wUEYzZ09BWGRQdmo0NHpxeDlZZWlFWWQ5?=
 =?utf-8?B?NW5xT2JaK2twZGdmTnNuY0lkVjhtamRINElobTlpcmppcjU2clJLOURkcDZG?=
 =?utf-8?B?UVU5WElMdHFJSmx4K1A0MmN0NkRUaG5wR1pjQXRKZ2R5Z0kwMlpYWU4wVWRH?=
 =?utf-8?B?WFBPUE9tNkxXY28wRDh3VGlRRGZJMTJWR2dKWEpiMlpvYzBRU1FTWXBiRDBB?=
 =?utf-8?B?cnpZdkR2STc0cktwUG9jbHA3K1dKK3hXRHFJOWFoNVdtUzFyNDNzN2JpL1Bu?=
 =?utf-8?B?MlJ5aHR3d0pqN2wzZTRDT05VcmlmbjVBUnpTdXh4WnlIOXJ0eURFQWdBa1Ba?=
 =?utf-8?B?dWc5VTMyVlMxRnoxcTh0TzhpSjJEQVM1N3AreGQ4dnhxVGxnODIxdWd5ekx6?=
 =?utf-8?B?Z09TY3NWQXUzMjY2TzFHWkV0Z1JZZGxMeE10RkhrekJlNTZlTlpkQVpIcUhM?=
 =?utf-8?Q?x3gNzeuHJ/4AnGOspw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d920214a-713c-472b-08c4-08d940939b93
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2021 15:34:56.3760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NhDwjWdIib8pYfcNJ40mJ7ECHlM3hTxLmu2qsTh0ytgJWvCdxvT+pl8NEl+bCxhUTGdbsGYnU/O9a4Y4m7+ESw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1037
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <3A79B89ADAF791469330F0781A0701FE@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS83LzIwMjEgNDoyNiBwbSwgWHUgTGlhbmcgd3JvdGU6DQo+IEFkZCBkcml2ZXIgdG8gc3Vw
cG9ydCB0aGUgTWF4bGluZWFyIEdQWTExNSwgR1BZMjExLCBHUFkyMTIsIEdQWTIxNSwNCj4gR1BZ
MjQxLCBHUFkyNDUgUEhZcy4gU2VwYXJhdGUgZnJvbSBYV0FZIFBIWSBkcml2ZXIgYmVjYXVzZSB0
aGlzIHNlcmllcw0KPiBoYXMgZGlmZmVyZW50IHJlZ2lzdGVyIGxheW91dCBhbmQgbmV3IGZlYXR1
cmVzIG5vdCBzdXBwb3J0ZWQgaW4gWFdBWSBQSFkuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IFh1IExp
YW5nIDxseHVAbWF4bGluZWFyLmNvbT4NCj4gLS0tDQo+IHYyIGNoYW5nZXM6DQo+ICAgRml4IGZv
cm1hdCB3YXJuaW5nIGZyb20gY2hlY2twYXRoIGFuZCBzb21lIGNvbW1lbnRzLg0KPiAgIFVzZSBz
bWFsbGVyIFBIWSBJRCBtYXNrLg0KPiAgIFNwbGl0IEZXViByZWdpc3RlciBtYXNrLg0KPiAgIENh
bGwgcGh5X3RyaWdnZXJfbWFjaGluZSBpZiBuZWNlc3Nhcnkgd2hlbiBjbGVhciBpbnRlcnJ1cHQu
DQo+IHYzIGNoYW5nZXM6DQo+ICAgUmVwbGFjZSB1bm5lY2Vzc2FyeSBwaHlfbW9kaWZ5X21tZF9j
aGFuZ2VkIHdpdGggcGh5X21vZGlmeV9tbWQNCj4gICBNb3ZlIGZpcm13YXJlIHZlcnNpb24gcHJp
bnQgdG8gcHJvYmUuDQo+IHY0IGNoYW5nZXM6DQo+ICAgU2VwYXJhdGUgUEhZIElEIGZvciBuZXcg
c2lsaWNvbi4NCj4gICBVc2UgZnVsbCBNYXhsaW5lYXIgbmFtZSBpbiBLY29uZmlnLg0KPiAgIEFk
ZCBhbmQgdXNlIEM0NSBJRCByZWFkIEFQSSwgYW5kIHVzZSBnZW5waHlfYzQ1X3BtYV9yZWFkX2Fi
aWxpdGllcy4NCj4gICBVc2UgbXkgbmFtZSBpbnN0ZWFkIG9mIGNvbXBhbnkgYXMgYXV0aG9yLg0K
PiB2NSBjaGFuZ2VzOg0KPiAgIEZpeCBjb21tZW50IGZvciBsaW5rIHNwZWVkIDIuNUcuDQoNCkhp
IEFuZHJldywNCg0KDQpOZWVkIHlvdXIgaGVscCBvbiB0aGlzIHBhdGNoLg0KDQpodHRwczovL3Bh
dGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjEwNzAxMDgyNjU4
LjIxODc1LTEtbHh1QG1heGxpbmVhci5jb20vDQoNCkkgc2VlIHRoZSBzdGF0dXMgaXMgIk5vdCBh
cHBsaWNhYmxlIiBhbmQgZGVzY3JpcHRpb24gIkd1ZXNzaW5nIHRyZWUgbmFtZSANCmZhaWxlZCAt
IHBhdGNoIGRpZCBub3QgYXBwbHkiLg0KDQpIb3cgc2hvdWxkIEkgZml4IHRoZSBwcm9ibGVtPw0K
DQoNClRoYW5rcyAmIFJlZ2FyZHMsDQoNClh1IExpYW5nDQoNCg==

