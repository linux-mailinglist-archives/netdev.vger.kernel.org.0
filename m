Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B646CA17
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfGRHkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:40:25 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:2439
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfGRHkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 03:40:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs4mZIUKDXQI1V6tCuCxHImkiU/dK2KhfiP6fkWY4yRTEHnhxbDLJHkndeAoFpAuoNCaes/HomDI8XUS8ynUJE5cIYQSbaxatzAHroX9g01lNOWW1MUGGwX8GmISxuW8OFe0tNO7nfndJeywO+9NUrcfgeotsWk/e8gVoYUvanokm2ZO+9PYBsojlZEC92X9o3T6S8HwyztCCXe+bdCVesFeWA5acUtmmAYN1wzUEYrktvmpauJ1Dh+8uWsw9gSCyq3XD1sXjEpWiGVSj6+Sieg/D3N7KF2O7dqAuajTDXEE+rwj7cr0g0Q1aTI/7fH2dAKaadFKvclojv9k6ZigHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQFMBeGFA8hMcI+WWAgEosgScI9Aib8p0/IC5DoZm2Q=;
 b=Cm6m9VHgu6uEIPjKhx61dli6WH6JD8npYSzRXIAilGt1eFQCjNb65OF47pJgbCKuJir+G460Wb7M4mtohUULKAfNHJA+0GNTzXhtCOFtndV6JBIjDz5FZDVknbYQOC8idCMZDrPFgwm31eK9Z3C3z0E7eVG42zHF7G3sADarliC8vZVv2T8sI7+I4FNV7kK9diqncQM2+LnQX+Pz4qZAXqmB2lFK2+aBwOMRcDL4MylQKbg1RmZhhH5/jK4XFl1qyEmiuajkSmnaZYKMiZ9gMHz0tr1pOJyKPIoqxN3jc6aY2CU5Kv5RnjVralaEwfVHfZqXB/p51YW+uupKs+LoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQFMBeGFA8hMcI+WWAgEosgScI9Aib8p0/IC5DoZm2Q=;
 b=Bc4eGHtI0wY+TiKmIfZ9xocouhW6WkBbAa8VwDal8UPh+PCFe9lrsfprcb1iG8Hejz8PeQ3Nw15sp2uXe162hRC1KtOX1lo4v8rBz4Bcy0LSoc2vMwTYu1CW235XkskDWfB1R2uaz2b2aKFk/nG9h6KmmIsfFfgJcMjMeASKzB0=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6300.eurprd05.prod.outlook.com (20.179.40.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Thu, 18 Jul 2019 07:40:22 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 07:40:22 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Thread-Topic: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Thread-Index: AQHVM0amZ+XSxwyRMEeKcG4BIrzTvqa8rIOAgAI+DgCAEDyqgIAA6k4A
Date:   Thu, 18 Jul 2019 07:40:22 +0000
Message-ID: <1b27ca27-fd33-2e2c-a4c0-ba8878a940db@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
 <20190705.162947.1737460613201841097.davem@davemloft.net>
 <d5d5324e-b62a-ed90-603f-b30c7eea67ea@mellanox.com>
 <20190717104141.37333cc9@cakuba.netronome.com>
In-Reply-To: <20190717104141.37333cc9@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0118.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::34) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09e5af4a-70d0-4ad0-0da3-08d70b53305b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6300;
x-ms-traffictypediagnostic: DBBPR05MB6300:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DBBPR05MB6300D5860BD30BF7494B4304AEC80@DBBPR05MB6300.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(189003)(199004)(5660300002)(54906003)(110136005)(4326008)(256004)(11346002)(316002)(2616005)(2906002)(6506007)(446003)(53546011)(76176011)(26005)(102836004)(31686004)(386003)(52116002)(229853002)(14454004)(99286004)(486006)(476003)(31696002)(186003)(86362001)(25786009)(71200400001)(3846002)(36756003)(6116002)(66946007)(64756008)(66476007)(66556008)(66446008)(7736002)(4744005)(966005)(478600001)(8676002)(6306002)(6512007)(6486002)(6436002)(68736007)(53936002)(6246003)(8936002)(81156014)(107886003)(81166006)(71190400001)(66066001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6300;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cXC2j1STx3bTUjH4ZH6Ih+/Y4asxPkzMWXmBdxATqUFyDeNIklkG44cGcp/0/nalsgcRWq+NbYInUAO0fsuA2c5hVYCUhTU9ZWbvAnV1gN4ytJan6TaYxhqhVcx79lhmXLlaokzx8d72GXjMMhH/R1IMuawMqYfbFMWbUBpgV0mBgT5T9Ae8tuo23VpvpZwwr8OScOn8Bg7aQpYElFnTIb97eFrKvjwwdm82lgaGI3MKp39R5tSJhXVqTcqLQCF/ySPjtmlzEEZXkTxX6j8T9f39k++YfN48vHkFDxSvFptKGINamqUqFZvJYQMKVMbCLXHlX6fOnjeqDvggPfB+bkbZAzAPjDBO0zi9hl/Wi9HeR32jW6IdoZxDzMV4WCSRjnTHxPitpG+oTX29Ebml/CarMZNz8zlptsdbJqBuDR4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6487C977486AD4469FE801D8261760F8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e5af4a-70d0-4ad0-0da3-08d70b53305b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 07:40:22.2256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTcvMjAxOSA4OjQxIFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gU3Vu
LCA3IEp1bCAyMDE5IDA2OjQ0OjI3ICswMDAwLCBUYXJpcSBUb3VrYW4gd3JvdGU6DQo+PiBPbiA3
LzYvMjAxOSAyOjI5IEFNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+Pj4gRnJvbTogVGFyaXEgVG91
a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPj4+IERhdGU6IEZyaSwgIDUgSnVsIDIwMTkgMTg6
MzA6MTAgKzAzMDANCj4+PiAgICANCj4+Pj4gVGhpcyBzZXJpZXMgZnJvbSBFcmFuIGFuZCBtZSwg
YWRkcyBUTFMgVFggSFcgb2ZmbG9hZCBzdXBwb3J0IHRvDQo+Pj4+IHRoZSBtbHg1IGRyaXZlci4N
Cj4+Pg0KPj4+IFNlcmllcyBhcHBsaWVkLCBwbGVhc2UgZGVhbCB3aXRoIGFueSBmdXJ0aGVyIGZl
ZWRiYWNrIHlvdSBnZXQgZnJvbQ0KPj4+IEpha3ViIGV0IGFsLg0KPj4NCj4+IEkgd2lsbCBmb2xs
b3d1cCB3aXRoIHBhdGNoZXMgYWRkcmVzc2luZyBKYWt1YidzIGZlZWRiYWNrLg0KPiANCj4gUGlu
Zy4NCj4gDQoNCkhpIEpha3ViLA0KDQpJJ20gd2FpdGluZyBmb3IgdGhlIHdpbmRvdyB0byBvcGVu
Og0KaHR0cDovL3ZnZXIua2VybmVsLm9yZy9+ZGF2ZW0vbmV0LW5leHQuaHRtbA0KDQpEbyB5b3Ug
dGhpbmsgdGhlc2UgY2FuIGFscmVhZHkgZ28gdG8gbmV0IGFzIGZpeGVzPw0KDQpSZWdhcmRzLA0K
VGFyaXENCg==
