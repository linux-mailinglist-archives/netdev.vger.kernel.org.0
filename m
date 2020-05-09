Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09111CBE87
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgEIHuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:50:02 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:29837
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725850AbgEIHuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 03:50:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEg3I6cqg+zxIu0wS7Xq5XQat8X4tDKZMQdaJ3BMuGXCXW3GSJpFPOu4e+Y32WFGUyFU0eruS46+8EO3bATuZZGWc3wWZ+aZsVUCg/bzbUj0OSaTf34HW1fMgX5nHcSwiHrEVkGV7zjBZTh25gBXGLA5ALhwtz0iRStAmpN8YMDUpF4+rvLwG8+i95SzjBYqRCBDioDCI7hwJajrX0hi2DucBjJrKgNO1PFaW++4Ee11IL37rYMQdRBU8fg/PfJVt4gh3kk4aZu6vq3EbUJUz/Z4EhEWRbOLQwxEtC0vjrGEk3C1pdRkmf+7J11YqCRpZ5APLoFeu8PliBS4SGOVVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xDLkTyWywng7PGXnVekYvcEAAm0i4kpM0VVBYtIYQw=;
 b=LOtymBayc4iYm8zEs/3mF25WG1zhzOBB6pXVmWg5aEsQXmSxnoBKBCCN269BRjJxOT/9YtBzQziPO3D0PGrFLwLdSy42EmCXSYmJd8AMgj72RKezaRV79a8VTg+HIX1IGU/mreKWWoXDxXtsgPIASN2r3EJr/mWs9xGkhSpcUK3tRte5TZ9WzBJqrDuQNFiV2H7ak3Yzo6dtNrn+17RSwoDr3U3x1CFb5da/g8E97tLm9/uJb2uefqGtzZmG8UFFd6ui0TnZI2tAVzz+YG7chT3ekmbZSYL0O69HNzvMbyVzTqjAhRhvec+5egjArEeDPdmOCaZ1pAuSGt5p2DMhcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xDLkTyWywng7PGXnVekYvcEAAm0i4kpM0VVBYtIYQw=;
 b=coXpCjTnULlpELbSAW5+FDNZzup3gfs00lv+B9qvomuHGXTdmnZqTQpiS6K5gISDVYMbhGx4yMEFep9mwrtvPapMNxLL4nbKAjv3zLvFRhW7qtzXxU9GIiD+DRB2KhnZ/DoK7jokCrdexfYfrP5PfA6c+Vs6/Q8a837Kf9DU0+o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6462.eurprd05.prod.outlook.com (2603:10a6:803:f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Sat, 9 May
 2020 07:49:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 07:49:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma tree
Thread-Topic: linux-next: manual merge of the net-next tree with the rdma tree
Thread-Index: AQHWJOdqvf+wE0yjPU+ZM+uXTwctcaieIJoAgAFCdAA=
Date:   Sat, 9 May 2020 07:49:58 +0000
Message-ID: <730d7ae9690cb153afd7a39207f009b75d858d91.camel@mellanox.com>
References: <20200508131851.5818d84d@canb.auug.org.au>
         <20200508123550.GG19158@mellanox.com>
In-Reply-To: <20200508123550.GG19158@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c1fc9dc-5d6c-4095-4b72-08d7f3ed9250
x-ms-traffictypediagnostic: VI1PR05MB6462:|VI1PR05MB6462:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB64626EC25295E7416CB5D9F9BEA30@VI1PR05MB6462.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 03982FDC1D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: max3UJpiCA2zRn+ez54m/vv60Dnep7L5imjjiipATPfAXX5JR2sjxzHMjy+6hJ61AhSOaTHCKzYpuVsYLux9Go8TK23lTnm8ZD7BYus+1En2vT0w845bEms1jF7Jm9RDZI5zEopclx8FkriRhqgJnXHxoYhTZIwQZTYTmPAZX3Dgrkbp89I1SrRgKFMeSs9WvQ+lN3hy5r0Oc3vaPn14vymGWKL1uDl+C3QFiBbhYfjGwIzQiIODH9PPnjr5LoFymT9QN6dLecDnbeymaa9Rj8knc11PujgGbSge7qpOLgt0rZuL2JG9yeUiRnVwUBFDFUwDXIP0PXgS0u7MG5rRA++wt92kxRHBrHjGtyvGTUpAqEiOmPEZTnJkhFkx7cT4iSDs0QtcY5r0SsGKDagBjq5sV+KnKzmScGwEJ/Ae6Txxiv3sFQysHjnEuuxU6ZdWHxwB30yGhM61xJ834BKT+XrojtW9X3CK9Mp/xV2f9n3uxfXjWSYS1M74ordHqKd/e4Yv76L0rum1A/0JrV+UuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(33430700001)(6486002)(2906002)(26005)(4326008)(36756003)(6512007)(6506007)(86362001)(33440700001)(110136005)(54906003)(5660300002)(66446008)(71200400001)(316002)(186003)(478600001)(8936002)(2616005)(76116006)(91956017)(66946007)(64756008)(66556008)(8676002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: H5/hmdeBf/RxzdgBz2IrOUhoPiAP9LSuAbAB/QYtvCKjLomN7wfMdo1I9N6Vkaevf4WTqRIxo5lqQzet7ZsCS0HA/jVGLgZJyPhgrJKPo6wSEYLnCaB9GSRG1wdbowcUT2ca6OD8heXNTEyXMQnMR+bFfO3jzOZKkI0nXkXNurkz3QeNnvA2EiPObp6AQ94El+Q5YoHCllb1YECYQJQiShcE+pm8Hd2DYfIiNWiqkpEyAByNhaGXHVsyjVQG35VZ7bO0FX1r7934OqZ4tQeumpFJGIBmnZLuTlI9M6/bi0M6eQjhjtFyw3k7wmZm/mxvsI/kFcvngdIPrlzbIqLZSE1QS2KMy2dGrJc2rnszpyLGOBEwFzgWgOI2f/8ZjYHTJu/e28FHES4YzM56E445SnKpu2pR9wkodYowt1vTNCOpeUb2JK5u7IqMhkQPcrokzuGxFQAJRBTDnICZlHAyf2L8wySbKOXQGu2WkzTf3Z8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12E8EF14DFB330429CB2E9D82FF4B175@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1fc9dc-5d6c-4095-4b72-08d7f3ed9250
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2020 07:49:58.2739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pE6sfAKPVmv6UMsit1ywMz23Rl00ELV3HVZAuoKpGRNub1N7cJJkgL6Krg9uAeEJ7E6oxv5APtTxwo8GwS3eKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6462
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTA4IGF0IDA5OjM1IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIEZyaSwgTWF5IDA4LCAyMDIwIGF0IDAxOjE4OjUxUE0gKzEwMDAsIFN0ZXBoZW4gUm90
aHdlbGwgd3JvdGU6DQo+ID4gSGkgYWxsLA0KPiA+IA0KPiA+IFRvZGF5J3MgbGludXgtbmV4dCBt
ZXJnZSBvZiB0aGUgbmV0LW5leHQgdHJlZSBnb3QgYSBjb25mbGljdCBpbjoNCj4gPiANCj4gPiAg
IGRyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCj4gPiANCj4gPiBiZXR3ZWVuIGNvbW1p
dHM6DQo+ID4gDQo+ID4gICBlZDdkNGYwMjNiMWEgKCJib25kaW5nOiBSZW5hbWUgc2xhdmVfYXJy
IHRvIHVzYWJsZV9zbGF2ZXMiKQ0KPiA+ICAgYzA3MWQ5MWQyYTg5ICgiYm9uZGluZzogQWRkIGhl
bHBlciBmdW5jdGlvbiB0byBnZXQgdGhlIHhtaXQgc2xhdmUNCj4gPiBiYXNlZCBvbiBoYXNoIikN
Cj4gPiAgIDI5ZDViYmNjYjNhMSAoImJvbmRpbmc6IEFkZCBoZWxwZXIgZnVuY3Rpb24gdG8gZ2V0
IHRoZSB4bWl0IHNsYXZlDQo+ID4gaW4gcnIgbW9kZSIpDQo+ID4gDQo+ID4gZnJvbSB0aGUgcmRt
YSBhbmQgbWx4NS1uZXh0IHRyZWVzIGFuZCBjb21taXQ6DQo+ID4gDQo+ID4gICBhZTQ2ZjE4NGJj
MWYgKCJib25kaW5nOiBwcm9wYWdhdGUgdHJhbnNtaXQgc3RhdHVzIikNCj4gPiANCj4gPiBmcm9t
IHRoZSBuZXQtbmV4dCB0cmVlLg0KPiANCj4gU2FlZWQ/IFRoZXNlIHBhdGNoZXMgaW4gdGhlIHNo
YXJlZCBicmFuY2ggd2VyZSBzdXBwb3NlZCB0byBiZSBhIFBSIHRvDQo+IG5ldC1uZXQ/IEkgc2Vl
IGl0IGhhc24ndCBoYXBwZW5lZCB5ZXQgYW5kIG5vdyB3ZSBoYXZlIGNvbmZsaWN0cz8/IA0KPiAN
Cg0KWWVzLCBJIGRvbid0IHVzdWFsbHkgc2VuZCBzdGFuZGFsb25lIFBScyBvZiBtbHg1LW5leHQs
IGFuZCBJIG9ubHkgZG8gaXQNCndpdGggdGhlIGNvcnJlc3BvbmRpbmcgKGRlcGVuZGluZyBvbikg
cGF0Y2hlcyBmcm9tIG5ldC1uZXh0LW1seDUsIGJ1dCBJDQphZ3JlZSB0aGlzIG9uZSB3YXMgZGlm
ZmVyZW50IEkgc2hvdWxkIGhhdmUgc3VibWl0dGVkIGl0IC4uIGFueXdheSB0aGUNCmNvbmZsaWN0
IGlzIG1pbm9yLCBpIGFscmVhZHkgZml4ZWQgaXQgdXAgYW5kIHdpbGwgc3VibWl0IHNvb24uLg0K
DQpUaGFua3MsDQpTYWVlZC4NCg==
