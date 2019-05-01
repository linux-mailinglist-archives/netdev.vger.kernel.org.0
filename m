Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1610E4B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEAUzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:55:54 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:60590
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfEAUzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9V0/CeWL+PHaxNyU5bOhy4j3/2XHXXS6+C3/J7iF+o=;
 b=Y8V/MnMbLwp+SYo3hMTkCspDMLD29s/pNZoTQYN81cDC/dI3ERMO5t4WWwew1AskSuw7IXf/aLzt0gyybwp5tMqonsbVGy96AZ+qj5v3fDxrHg82Z7y7TXAq9Om3rz+8WRL07/0MBt4fOmGz0tkXvhI0yVFYIck6zxOaUZiK0MA=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5883.eurprd05.prod.outlook.com (20.179.11.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 1 May 2019 20:55:50 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 20:55:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix broken hca cap offset
Thread-Topic: [PATCH mlx5-next] net/mlx5: Fix broken hca cap offset
Thread-Index: AQHU/8zpKZTG0FipW0mErfSWRt/QQaZWwOcA
Date:   Wed, 1 May 2019 20:55:49 +0000
Message-ID: <0d704ab0b2bde282cd845d061b44ede87876be6f.camel@mellanox.com>
References: <20190501032037.30846-1-saeedm@mellanox.com>
In-Reply-To: <20190501032037.30846-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bc2f900-0b04-48c4-93b4-08d6ce776464
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5883;
x-ms-traffictypediagnostic: DB8PR05MB5883:
x-microsoft-antispam-prvs: <DB8PR05MB588329119EE24B660FDDD4A8BE3B0@DB8PR05MB5883.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(396003)(39860400002)(199004)(189003)(316002)(68736007)(37006003)(54906003)(6862004)(6512007)(66556008)(2906002)(25786009)(305945005)(6486002)(14454004)(102836004)(118296001)(58126008)(6506007)(66066001)(6436002)(4326008)(229853002)(6116002)(3846002)(36756003)(446003)(476003)(2616005)(486006)(478600001)(11346002)(5660300002)(6246003)(26005)(66946007)(186003)(107886003)(76116006)(66476007)(64756008)(66446008)(71190400001)(81156014)(7736002)(91956017)(8676002)(8936002)(99286004)(71200400001)(76176011)(4744005)(256004)(86362001)(81166006)(73956011)(53936002)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5883;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GTO0hKyewzfu8m3gHewQCCGGQPVYdK3X+rsvnoygitg8pPArQMUzoW4gC0npZhTfwvWgh4/o+8BUcQcG9LyIHXOwSqikt5cWsM3dls9fpXxxyG38bU4EMKiPJOsfVCWd5P2Wsq7shgNP20d4pr5WmxHI9JcqkAcICGclHWUQuQVfhK3xV4MIGU87yFp+dnw48XrM/ft+uu8zt4wMEPM4ON6T+0ZuS/wlcYXep/AXcXRC+zd1N+hH5ctbLdWlWyggyzK6NXw/bjX/nzdQ65H7H+JFtJuXFsD8BdRtFhjSe+CkqUlW1QUzeGA8LedmjeH+IpFy1RvvW2b27PkbBfVqwBQh6ldL3t+AtWMKpXx9diQWqSjro3I0NrZb8qsFaghfsJeMRaFSEpwWYcp2pDQNTeMUiMiIWYYW/ELUTzOAaxY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4741BB41B9B3604DBE324554C7462CCD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc2f900-0b04-48c4-93b4-08d6ce776464
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 20:55:49.9286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5883
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTAxIGF0IDAzOjIxICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gVGhlIGNpdGVkIGNvbW1pdCBicm9rZSB0aGUgb2Zmc2V0cyBvZiBoY2EgY2FwIHN0cnVjdCwg
Zml4IGl0Lg0KPiBXaGlsZSBhdCBpdCwgY2xlYW51cCBhIHdoaXRlIHNwYWNlIGludHJvZHVjZWQg
YnkgdGhlIHNhbWUgY29tbWl0Lg0KPiANCj4gRml4ZXM6IGIxNjllNjRhMjQ0NCAoIm5ldC9tbHg1
OiBHZW5ldmUsIEFkZCBmbG93IHRhYmxlIGNhcGFiaWxpdGllcw0KPiBmb3IgR2VuZXZlIGRlY2Fw
IHdpdGggVExWIG9wdGlvbnMiKQ0KPiBSZXBvcnRlZC1ieTogUWlhbiBDYWkgPGNhaUBsY2EucHc+
DQo+IENjOiBZZXZnZW55IEtsaXRleW5payA8a2xpdGV5bkBtZWxsYW5veC5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiAtLS0NCg0K
DQpBcHBsaWVkIHRvIG1seDUtbmV4dA0KDQpUaGFua3MhDQoNCg==
