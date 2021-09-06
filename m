Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA26E401D40
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhIFOwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 10:52:13 -0400
Received: from mail-sn1anam02on2053.outbound.protection.outlook.com ([40.107.96.53]:53059
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239634AbhIFOwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 10:52:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuOr+fGOvfLvkh6SQgCWSSLn9Hf34zhiRaK39weGtCms29NQeTGho030kHWQ81jUOR9tz8s02gYsSUzHRdy85AvVd0yJFssZmal3CtZDwSA2LzQkvD0hgY63JQ4u+L3TX+ybuAtIbkcq7f4BO/YJedh8XeAIFhl94e1hhBw1e64QFBkX+HGLZLCreRvvk1oTywLyH7OTSBpp6Ytb0ZJkZxulMUxcMmSEsonGIKT8Ipz8ydUoXX9mXuuR3/xYZO4Haj13G5xe/cQwKXEhlHHognEVTxicxOoW5AwRc4YE/HLDsiVQGZac5x+CWHKHA6dtoOWz0Os+xWA0bozmlqvoKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hMQO7Q/pm7bCoKk58qpIPOG2OiUZXN7kiPSaIOwJ8zA=;
 b=dCUqjd9chggNFwaGN3Rly1pZpDlybE80TTKdHd31D/7+y82x7bL/f9LNp+hRINzHy9e9gDpt40IqxoyU/wrDRc86SOcUh+ujkIsirkGcqUt9YrBee1aHSAxhej7Y2CmFfzdJ1+Y8EKB/x/hmH18abHVeuxmffuYZ3xCvsKF05fhMptzQSGW2+zyIbPWM0dvkHXXGdXgem61Ij+CwKabBkAIMx6824JlV+kI4sJGOo0P54YwaazrlV8NlvhshMb5hDQgprMHrds2kTwpK8Rw2COhxgZUn4igawb7qMjBUnS95PbAH+jSYoVYSiKoDu9Am785dTJsswuh6pHSn2O03pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMQO7Q/pm7bCoKk58qpIPOG2OiUZXN7kiPSaIOwJ8zA=;
 b=dw+GHfTv8bslmo9LNowe2uOHF7xGucIxcUeX2yY1/KGVA7jelEKhYYgT00Hvtvf8HmQ/iXo/pIw/h/qc9rmR8aj2q3TXoA22GY1j38ftgl7fBt3HJESRT6tmj4hsC1NN8urrDH009q2Ba8gPYLxxJn46d/V1xaWq9YbsnjI+xPA=
Received: from DM5PR05MB3452.namprd05.prod.outlook.com (2603:10b6:4:41::11) by
 DM6PR05MB6843.namprd05.prod.outlook.com (2603:10b6:5:1fa::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.8; Mon, 6 Sep 2021 14:50:59 +0000
Received: from DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::78ee:404b:e2b0:bfc2]) by DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::78ee:404b:e2b0:bfc2%6]) with mapi id 15.20.4500.010; Mon, 6 Sep 2021
 14:50:59 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Thread-Topic: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Thread-Index: AQHXov9LcgQvht1LPEuyoN2LNrCoZKuXExcA
Date:   Mon, 6 Sep 2021 14:50:59 +0000
Message-ID: <52DB430E-AD5D-45A5-BF72-C103B2BD2511@vmware.com>
References: <20210906091159.66181-1-sgarzare@redhat.com>
In-Reply-To: <20210906091159.66181-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a749691d-4797-48ed-4a48-08d97145bd78
x-ms-traffictypediagnostic: DM6PR05MB6843:
x-microsoft-antispam-prvs: <DM6PR05MB68436F18AA8EB54C1C258ED2DAD29@DM6PR05MB6843.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JWfQmRRvucLJxbgIMU/xihZWCBn5tBBOXxeqoTF/p3p0/h3PuKYBfqlHsH1j5KmFipL5eK/at7IEfC2Ude7dNMhU66rpNxXQh1J/TSJnE9kOSYnHF6QAB5Dp6NcWUCZt1R6k/NKyvAkscHnVk2eGtFQQhhg/1IYU3Zd3od5WGX3B5IUYSsXmBlr67WzjaXuWOxvmczP8jVgcalqfM43LiyePuc/DYfUgxh2M/sMlqfZPsK/MsWhq61vqATPY6QN62P3aJsdWgwJIMHrVvdGLbpJOmhZHTMcKl2HtgrRIQi1RZABXug+FU1pYMg7TnwYZkZmu+VULLlp0zc/j/GbZWFARCjNdRH3THaP0p3DACf/e4/+oaUItR2y2/AuTe4Qcj/xbFFsBKQYEBOEFkNyomzPFQkN+xFs8pcanJbBIZagZrAguCS8l3+n/uGDYkTXdbBpyyQCdRXZe+ph8RbjGZgeAj8htJacU4ZduAqVpGOuvE2DPJNhAUm9G7O3jQnGr8FTh18TnBubuJTuySl6cZMQD4xQxoLCaHJWD8zzKaKW9kHygq1ttQ33q731xy46WSe1aNLbEEkzT74DSG/YB34nI0vZ54vVYUgajX64ti9KTVRPfM4CjQ033dm/NGP0vTghctV7noBLJO9pY0BKvFKP/dZSvdh6fSeyjWYYg71LeP6m8WMTcnEByDsDPNfZT3crJM8B8qd0pEx+1YqMEfELAh8diLT5s0IDm2jbAq+I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR05MB3452.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(66946007)(316002)(76116006)(8936002)(5660300002)(4326008)(91956017)(186003)(8676002)(4744005)(38100700002)(33656002)(26005)(36756003)(6512007)(508600001)(71200400001)(2906002)(122000001)(38070700005)(6486002)(66446008)(54906003)(66476007)(2616005)(64756008)(66556008)(53546011)(86362001)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkxpdnFiM3VvS0lWd2N5c3lXa0hHTWEyODNwN3FyeEt2WnB1b21uaTN1SGZ4?=
 =?utf-8?B?ZkN1bnB6M1JEeEh3ZlpELzVxUnc2N1JDSlgvWGxxZVZLRlgwRW9GWkM3T2l6?=
 =?utf-8?B?VXhtWXhrSmZiTHh6OFIyYVFzZ2xWRHFJRloyVXJiK1MycVJOT1NDSkk1M0h5?=
 =?utf-8?B?bG1EYTZpSGx4YXN1R0lKdnI2RnBaU0w4U0NvU2hLa3FaemMvcGRxQm83aVUz?=
 =?utf-8?B?Njk2N21LN0dCSVNXWXhpLzlZNDFuclZGWVFUdGJTZWxNR1VTc3phZFkvM1dL?=
 =?utf-8?B?bXdFbGkwRm5zbHdkK2dFbjN4clh0WHJhY0dVaTYyeVFaNU9MV0FKeDNTbGh3?=
 =?utf-8?B?Y256WVlyS0lPMzJFRHdTUzh2eGh3OXArR1hkb09taGxuenB4OHp6Q2xnYUJR?=
 =?utf-8?B?NzFlNWI4c0U3RjBoaGNiSm4rVG13YTlyd085Z0I2alBtamRvTm5NNDVsa3o5?=
 =?utf-8?B?bFhpanpHN0pMVHE4b1F1U1hXQm91WDZtYmdrcUF0NkdSaDZHMVoxK3hxM2Yv?=
 =?utf-8?B?Q21QZUVIUjZuNWVQODg3bU5QMjJ2eHI2ME9ieUdpNTZVTzVnL1B5d2VMakxj?=
 =?utf-8?B?VXRYOHF2YVV5M2pMOFRXMGEyckgzcXp6bERFZWVHbWNDeVgrak1qdTRkbzVk?=
 =?utf-8?B?VkY1U2RYVk9lY3lSQlZsTFhTSS9IVzhwR2plNHJWT2NwWnR6bHppdjZQUkZx?=
 =?utf-8?B?Vjl2MDR3dDRGNHg4NDV0Y05HaUs3L3piVnlYb1BIY3NMZENtTFpCWDAycGNP?=
 =?utf-8?B?MGltOTBTeWVueThhTGJmdFoyekdRK21TK1FBTzA0VGRlQnZzV3dWdW9MSzIw?=
 =?utf-8?B?dTEwTjVmN3ZNUUFuaTRZdWljZkxkOUFuTjNmZEJpUExJUVUvbllwYlRkbzNU?=
 =?utf-8?B?Tmx1dTY0QWZEenR4ZmZUQnNuQmZ6U08wMmtaRCtKR2M1UUpNeGVVaTdyWFpO?=
 =?utf-8?B?WjN5SStZL3cvUmxuRDZzVmhpazZQdUpYUlBDUVhYSTQvMldzMzQ2MmJ6aFl4?=
 =?utf-8?B?QnVpalRBNUYyTE1GS1E2UUlWQUExZHI1RDAwVFQ5TElPbjFFcVNTZHZEejRx?=
 =?utf-8?B?dzE1aVRCaEpOTTA4UURrWnhOU3UyZWpEa043aERCZ2xuODlTTVM0ZVBMUFB6?=
 =?utf-8?B?UnhIRGswcS9MNUtkSmpmdEVFSHA1cndTcEFwbkhCZ1BiTzVaS3hYQndkVjk5?=
 =?utf-8?B?QzkrRDRrNHNvR0dOMU51TmxoT2NBb0V2RHZhUGRLazBCVStVNTZTeVZCRjBn?=
 =?utf-8?B?RmlrTVBaeGhWelUzNFJlOFVienR2aDhZcXA4cFZUdXBIZFMxREF4R21DdE9U?=
 =?utf-8?B?Y0ZNdVIzZjVOQlNabjA0Wm9BVzJKQXJTQ1BNc0prN3RWZW5FN2kzV0ZpbjB1?=
 =?utf-8?B?NURZc3gzdFpzZmozeHRBd1VHKzE0MHVFK2s4KzFoMUJ4Mis1bW9MK2NnTEMw?=
 =?utf-8?B?Vnoxa3UwRXhNdWNtd01NcWoyK21MREgwNFYvb05sd3BMaU9FTVZ0M2hJcW04?=
 =?utf-8?B?Y2hzUmQ4M1dtK2JBYjVlR0lvUWFEVHphQWpOOUZneEtCZ0FualhJbSs3RzJr?=
 =?utf-8?B?QWh4VjlYZjQwMHA1cjhrcDdTRU16T0NGVG9Oek9uZ1hvVnZwSUJzdmxRVEZq?=
 =?utf-8?B?Wmg4aWNvQm5Ja1N4SXlsQk53Sm94RjRZOS9VMnJnUzZSbHdxWWVWTVZSaWhZ?=
 =?utf-8?B?VUVabkh2UTQxQ1EzdGJZZDRKVC85V1FSZE9JNncvT1VKNTJhRFB3VDJUampO?=
 =?utf-8?Q?onR5mmtTpPLpK8r1SNUfWj8dAgcjhoROFnLfsqy?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C12CC91A6A53744821F851275086CD2@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR05MB3452.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a749691d-4797-48ed-4a48-08d97145bd78
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 14:50:59.4365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7JxYi0mZ85ZARtL9CE4bSuJW2y2geHodCddRidxz2zuYt0GzP8fB1aRgZ2ufrctsAn5MAfFyUr0ymNMF5wGaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB6843
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNiBTZXAgMjAyMSwgYXQgMTE6MTEsIFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnph
cmVAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBBZGQgYSBuZXcgZW50cnkgZm9yIFZNIFNvY2tl
dHMgKEFGX1ZTT0NLKSB0aGF0IGNvdmVycyB2c29jayBjb3JlLA0KPiB0ZXN0cywgYW5kIGhlYWRl
cnMuIE1vdmUgc29tZSBnZW5lcmFsIHZzb2NrIHN0dWZmIGZyb20gdmlydGlvLXZzb2NrDQo+IGVu
dHJ5IGludG8gdGhpcyBuZXcgbW9yZSBnZW5lcmFsIHZzb2NrIGVudHJ5Lg0KPiANCj4gSSd2ZSBi
ZWVuIHJldmlld2luZyBhbmQgY29udHJpYnV0aW5nIGZvciB0aGUgbGFzdCBmZXcgeWVhcnMsDQo+
IHNvIEknbSBhdmFpbGFibGUgdG8gaGVscCBtYWludGFpbiB0aGlzIGNvZGUuDQo+IA0KPiBDYzog
RGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4NCj4gQ2M6IEpvcmdlbiBIYW5zZW4gPGpo
YW5zZW5Adm13YXJlLmNvbT4NCj4gQ2M6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0
LmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5j
b20+DQo+IC0tLQ0KPiANCj4gRGV4dWFuLCBKb3JnZW4sIFN0ZWZhbiwgd291bGQgeW91IGxpa2Ug
dG8gY28tbWFpbnRhaW4gb3INCj4gYmUgYWRkZWQgYXMgYSByZXZpZXdlcj8NCg0KSGkgU3RlZmFu
bywNCg0KUGxlYXNlIGFkZCBtZSBhcyBhIG1haW50YWluZXIgYXMgd2VsbC4gSeKAmWxsIHRyeSB0
byBoZWxwIG1vcmUgb3V0Lg0KDQpUaGFua3MsDQpKb3JnZW4NCg0K
