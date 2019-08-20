Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCF396AEF
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfHTUyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:54:53 -0400
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:40901
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729900AbfHTUyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:54:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYxOlUqDsKp0+Nig5iThsc+cds1kwWOB2rH7KVA2un+Gn3cCvUME8Ksna1PFPy2HtvGIZIHGYIZd7AJjPxue6p8oOYSJnoWw1KXvyPcldMlg2cOQ26TIVo+n5IlHWCXjVTYCa2Z1D1w+m2BXzOp8AfCmyrgz6Rg/w3q67lD5gU1I7gLSO3/RyGjbmdaM1+7SS6oYxd1Xd2kcmhRjROm4L+SYTWXhJ4zyYUTnB0m8VZqD6nNKaTy568s2M8GD4FfDlIcKqbTes1Yx2C40K2pjln+PmQogpBL2elRsOu8HEA7V7giCozVDM26tdUoPtnCx/2Y+adMyWnH5DVG4cuIwfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orjSSI1FCSUhVlX008HFF7JMvbAlRNJKKcUqEt6qauk=;
 b=oCOBmdlvAkxnY5TfRdbTtSTwut6vjAmvZF4+nHth/AtuZSGKFwNnVtzCeFNx76nQ+KZFW6DlycNDFza4SMcSJWztvjhuv2uPRLiZRFDfEXcaTqWUB7WZxKO/4wKX1AC2FOgFlMA5EGo6lw11dDlUEdGxayi4H1ZwvKMCG0rw6mezq+iUkKmhmxVNd3MTJJeuIapO1urEf6Fo3BiBzNyIEU7AHqaFNuAkvQLHaGDh6wBc+xSsn1aPZeb/o6TD7/TXgLbiqrK7GmeDbjsSAxGrvV4C9r4/R0X9P7seUBf5wUFYTIpK0/Z1GZSHomatx9N3ZfPep6tDHvrsq7dLAMAiXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orjSSI1FCSUhVlX008HFF7JMvbAlRNJKKcUqEt6qauk=;
 b=iCCdTiiXB4fxpmKlixh4vLYTpMv2mZOg2f+FfFwQz8tQTdXqNm9njCgtEketabIFaTNOv3E+0Ed6dJcZvY+OWtcfmg1XQjrFW+yc3nKwjy8gRUA3tPU5sg+gaRqOBN5jrW2G+O7YdTJHxgJ11Kv3aVnVjgyjrGE6eeDAmv1X6ww=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:54:48 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:54:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, Updates for mlx5-next branch
 2019-08-15
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, Updates for mlx5-next branch
 2019-08-15
Thread-Index: AQHVU6IUZREU+lqw60OtGrhrmpkosacEi7sA
Date:   Tue, 20 Aug 2019 20:54:48 +0000
Message-ID: <9e34f8b0d2f5f80bcc12e902e4010a6d650cafba.camel@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 933581c3-797d-4d40-35ef-08d725b0a389
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB23757C5C0127C2005C50D5A4BEAB0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(53754006)(199004)(189003)(99286004)(450100002)(7736002)(316002)(76116006)(305945005)(91956017)(66476007)(66556008)(64756008)(66446008)(66946007)(6116002)(25786009)(118296001)(37006003)(15650500001)(54906003)(478600001)(2906002)(3846002)(81166006)(58126008)(8676002)(81156014)(6436002)(6486002)(8936002)(256004)(229853002)(186003)(26005)(476003)(486006)(6506007)(71200400001)(102836004)(71190400001)(11346002)(14454004)(4744005)(6512007)(446003)(2616005)(36756003)(66066001)(5660300002)(6862004)(76176011)(53936002)(6636002)(86362001)(4326008)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pHfPZotuXCrWhEh/zQlZifdYujn+CZWli5NPx6psTxQhZD9ONJ1oQtisKpHufL7SFqSJEX5YIzP0G2Cfufgr3zt/nlsyumPv8xqB5V5+iPDY0PjJU88pqo5CPwLztqmRRzY0QxLrRLmv1OMxO8NfzEAAkf23pHr2BzXe4viyBmQGTcL/HMbqnFgcPhYcWfewv1+MQUJx31GE/hyr11cTh2jAuv9Ky3xgRGHqFR4tq7OzF19UwTDlk5nfzBX7Fb8WmEbog718akkT6TW0HV4HHES6TLn3n7g4xRZi1ZEqC6HbUBZex1/8gNc6XbUq8HqfNcAQ+mR02GPZIpHhqtD7KKiYsMYQqmIAOMzLj1RZFw1X2Aj+uRkLM9XzFhKpbyI3RRxF5JSvGQKMtacnogFgcYTSOXSZ9U4dLX3sMfrhMOQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FD151FE310F8C418E380D19E448DEE1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933581c3-797d-4d40-35ef-08d725b0a389
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:54:48.3015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+Uf6xzrqJC5MN58tqY0+cKAUOoD0i6i9C5a8TAcya3tQJxNt4GvpEPCTmHP/JxEOV1kpbJ05gy4wVtKzWwV6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTE1IGF0IDE5OjQ2ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gVGhpcyBzZXJpZXMgaW5jbHVkZXMgbWlzYyB1cGRhdGVzIGZvciBt
bHg1LW5leHQgc2hhcmVkIGJyYW5jaC4NCj4gDQo+IG1seDUgSFcgc3BlYyBhbmQgYml0cyB1cGRh
dGVzOg0KPiAxKSBBeWEgZXhwb3NlcyBJUC1pbi1JUCBjYXBhYmlsaXR5IGluIG1seDVfY29yZS4N
Cj4gMikgTWF4aW0gZXhwb3NlcyBsYWcgdHggcG9ydCBhZmZpbml0eSBjYXBhYmlsaXRpZXMuDQo+
IDMpIE1vc2hlIGFkZHMgVk5JQ19FTlYgaW50ZXJuYWwgcnEgY291bnRlciBiaXRzLg0KPiANCj4g
TWlzYyB1cGRhdGVzOg0KPiA0KSBTYWVlZCwgdHdvIGNvbXBpbGVyIHdhcm5pbmdzIGNsZWFudXBz
DQo+IA0KPiANCg0KQXBwbGllZCB0byBtbHg1LW5leHQuDQo=
