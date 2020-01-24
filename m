Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9A1491ED
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 00:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgAXXWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 18:22:24 -0500
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:43534
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729147AbgAXXWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 18:22:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeAMGlTlVBOtQ/dZDNau6HADczKwPu1RT4rT/A825abvq70jgcEz/eyli5qXg+qAjLwBdt9qwEb6AF69JPo++GNM2/O3xDTgYjfFa7o5mT7wYk8GhOZWsWJCA6iGQeUlOPWyOotsmV8l9o3vbWS3ZfyhTFW7iwWKmnqcxzXfFtRtgZW4ElYQSW88CoOUe/2ExSShaLx0jPmHXEn6RY0UZww0N8h9xMIEAnvOXoX0J7QGwY2hDqLC8C5KFQhSwdyrqG8cTKrWT4f7xvLAuff7jaqA6hdVaLUIYZ0REJjfYEAR3rdEzg2TTDb/y46pcbudmJ8zgqtpILTv/yRelyAJUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/CiFpJohWCqEALcXJy/H19UBL56im3zg/RPLsXVVv4=;
 b=CJmFhedC02h6gCEDJgpbRzdW5A/bialyYXS5K3nKqHb7lHsoNO567/X03oQQ/IFr2p4xQ8ikCpwu5SFnrTUGtFDfwsiCt+rRPUF5BenN3Wsh5Zj1+uklG8YRE6k9sJCjfumGHYFLfCoJxuQYd2Ljf0HK21JaNRUyX7Y8386wZP/fYbvuIkTJnkNwedY2Y4E7K16wBuGFIa4aZJotQat3E9OUV2FOWGsh5liZnGI3Ju6DaRRM1H+BIO6dGiEMdrWN/9mQ1jU/6N9zXE143jdQP+aKY1QVJLNMGS23HsDohIwNMJ71dPi9sQEzWKCj+/mO89lsldbHdTmEF0ejWL7MtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/CiFpJohWCqEALcXJy/H19UBL56im3zg/RPLsXVVv4=;
 b=bMXlbtdHrTc9o/dr+4SmETx5ehdU68En1oFWszV5hWCIAEWL5YHCdZgjtpI4UAVRD66M4aDmZILytiTcxHNPGGJfRp8ds93rzUzMblkbcXpzXWu27WIRkTvn8bna2B1Fjv23lTu8VG2onafOCLZa+xfpZhya3s6pvDdKdX15nCo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6813.eurprd05.prod.outlook.com (10.186.162.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 23:22:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 23:22:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "joe@perches.com" <joe@perches.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Topic: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
Thread-Index: AQHV0wDwhVlKH3k3QUuFraNLfeJazKf6YZKAgAAHl4CAAAUugIAABeOA
Date:   Fri, 24 Jan 2020 23:22:20 +0000
Message-ID: <4e120049f7c337d2d8d49b8a8f0a290f5b32d530.camel@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
         <20200124215431.47151-7-saeedm@mellanox.com>
         <6713b0b5394cfcc5b2b2c6c2f2fb48920a3f2efa.camel@perches.com>
         <83a85bb8d25d08cb897d4af54b7a71f285238520.camel@mellanox.com>
         <2603295b9f93bebda831079f10a8c6faf9b1c812.camel@perches.com>
In-Reply-To: <2603295b9f93bebda831079f10a8c6faf9b1c812.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f63354fa-91b1-426e-5bc6-08d7a1244334
x-ms-traffictypediagnostic: VI1PR05MB6813:
x-microsoft-antispam-prvs: <VI1PR05MB6813D5DA703C56223BAF00EFBE0E0@VI1PR05MB6813.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(199004)(189003)(6512007)(71200400001)(478600001)(2906002)(66556008)(66946007)(66476007)(6486002)(66446008)(6506007)(64756008)(4326008)(91956017)(76116006)(26005)(316002)(86362001)(186003)(36756003)(110136005)(2616005)(81156014)(5660300002)(4744005)(81166006)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6813;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Nj3dsp5Nb1P0m8oAJ4t43xUhQaEX9UtW98SnTKbXXrBuELNbfBFx2+5Q7dztMht33H49awdTof/whCrscgElIMPRWFqn3gAhj+Qso5p1hibnYK5ANHCaCO9KFHG+BGXxV0urgB8mdVq47Vu/Cmh+hReaQj4YOOzBk03sKs3sOOI61vKLWJTye4f58vzbNHtyhPiJOdP+7vKop8N1FAbGO0diIVWQKYu+PwSVzyRWRRJrjGUDqEE2+zTG7LtucHgV0fTqHu9ruqNQvE+yACXCM2A01Gr88CCzqxO0rNTsKAXlSo4AZkkSLR8dpPfb0zE0nYMDNr6OlAT/JC+MHHMFnnWqBsBwzj1zHEZXTw/eOsUIodCxD/xJMRBmGwO3BQQNzyJW579WgbiEankR3DlssLL3HOMmEfv7ZH1TBRQhtSQHwfZhkc8KiKjjxqfHhP9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <03443581883C4B41AE641F1E9C224AE9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63354fa-91b1-426e-5bc6-08d7a1244334
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 23:22:21.4004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/XIkcmyamjwFq4temJl59gA5JELLBZiLSeciXEmtwWTD0ieA3M2Ijpibczy7d95Xh0z96ESyfrZE2ULdoSCmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAxLTI0IGF0IDE1OjAxIC0wODAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
T24gRnJpLCAyMDIwLTAxLTI0IGF0IDIyOjQyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gPiAyKSBrZWVwIGl0IGFzIGlzLCBhbmQgZml4IHdoYXRldmVyIHlvdSBkb24ndCBsaWtlIGFi
b3V0IHRoZSBjdXJyZW50DQo+ID4gc3RhdGUgb2YgdGhlIHBhdGNoLiAocmVtb3ZlIHRoZSBuZXds
aW5lKS4uIA0KPiANCj4gSnVzdCByZW1vdmluZyB0aGVuIG5ld2xpbmVzIHdpbGwgYmUgZmluZSwg
dGhhbmtzLg0KPiANCj4gVGhlcmUgd2VyZSB0d28gdW5uZWNlc3NhcnkgbmV3bGluZXMgaW4geW91
ciBwb3N0ZWQgcGF0Y2gsDQo+IG9uZSBpbiByeCwgb25lIGluIHR4Lg0KPiANCg0KSSB3aWxsIGZp
eCB0aGVtIQ0KDQpUaGFua3MhDQoNCg==
