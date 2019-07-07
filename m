Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D5561435
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 08:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfGGGod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 02:44:33 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:61413
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbfGGGod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 02:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlZG59Rad+o5n590FPad7iYfViPIKLAWf1MyyB5Ynsc=;
 b=Deme6e48bU6smtyUtme3jz1W6qvdtqpXyR/Z/N3t8VyDTk3RhQpNkqPsvydVPdtE9kIoSo4mNc7LntPgE7CIgGRARL+VBJUH0O6mDD4DJLBg8BZTz92hXeqrTKxrds3H0dhiTz6SIoRU8TDz/Yelvqq4royezPXJ+zgRl/czSBM=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Sun, 7 Jul 2019 06:44:27 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2052.019; Sun, 7 Jul 2019
 06:44:27 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Thread-Topic: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Thread-Index: AQHVM0amZ+XSxwyRMEeKcG4BIrzTvqa8rIOAgAILwwA=
Date:   Sun, 7 Jul 2019 06:44:27 +0000
Message-ID: <d5d5324e-b62a-ed90-603f-b30c7eea67ea@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
 <20190705.162947.1737460613201841097.davem@davemloft.net>
In-Reply-To: <20190705.162947.1737460613201841097.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0144.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::36) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8be72247-205e-452e-40c8-08d702a68e7a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6283;
x-ms-traffictypediagnostic: DBBPR05MB6283:
x-microsoft-antispam-prvs: <DBBPR05MB62830A60EED9BF1DA8DCF558AEF70@DBBPR05MB6283.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0091C8F1EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(189003)(199004)(4744005)(14454004)(66066001)(31696002)(11346002)(7736002)(86362001)(52116002)(31686004)(26005)(186003)(446003)(5660300002)(2616005)(73956011)(66446008)(64756008)(486006)(305945005)(68736007)(4326008)(66556008)(66476007)(476003)(66946007)(54906003)(3846002)(386003)(6512007)(8936002)(6506007)(6436002)(6486002)(53546011)(81166006)(2906002)(102836004)(8676002)(76176011)(81156014)(6246003)(107886003)(6116002)(229853002)(256004)(36756003)(71200400001)(99286004)(53936002)(316002)(110136005)(478600001)(71190400001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6283;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9/qbmkaf/RhwM3NcGs5msU6Z++I5gyQF3OltD3owRe4O4KiPQ1vH0NT4RHUi9qt7PD8tQW/ow0peq8O3/NNumIpUwqe4u8Zi6rlF883e/TWgs8HFBL6CsH2T+atu36jzrJaSsUf6qCezgs8QB4MC661E5T6VMiZjOyau1lzIFRpuHCLBzpxhpLT5W25Ehb7Nh4UwgBOo7SYW4xk39uYNFvhyWa+WYdvg+pjZxoxh1msfyFQ4iuRRyyk9c5E+fqwEWT2922JdnRwbaLafCWGRBQ3zznmA6cuVC7UyZpS9iCT+awD2uvowmPWPglPeUe+rA6kehmSbRU5d9ALdE48OdH/t4yNAFJHSY8DOMhR5bIOh0OgAoOsEOFRMqfYvI2kfB0ggB5CciibuJglmEP0QtAg/DH1SbnTK24HrCWtWyEs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96908E2D0D14A64B9D868E7928AA813F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be72247-205e-452e-40c8-08d702a68e7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2019 06:44:27.6096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6283
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNi8yMDE5IDI6MjkgQU0sIERhdmlkIE1pbGxlciB3cm90ZToNCj4gRnJvbTogVGFy
aXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiBEYXRlOiBGcmksICA1IEp1bCAyMDE5
IDE4OjMwOjEwICswMzAwDQo+IA0KPj4gVGhpcyBzZXJpZXMgZnJvbSBFcmFuIGFuZCBtZSwgYWRk
cyBUTFMgVFggSFcgb2ZmbG9hZCBzdXBwb3J0IHRvDQo+PiB0aGUgbWx4NSBkcml2ZXIuDQo+IA0K
PiBTZXJpZXMgYXBwbGllZCwgcGxlYXNlIGRlYWwgd2l0aCBhbnkgZnVydGhlciBmZWVkYmFjayB5
b3UgZ2V0IGZyb20NCj4gSmFrdWIgZXQgYWwuDQo+IA0KPiBUaGFua3MuDQo+IA0KDQpJIHdpbGwg
Zm9sbG93dXAgd2l0aCBwYXRjaGVzIGFkZHJlc3NpbmcgSmFrdWIncyBmZWVkYmFjay4NCg0KVGhh
bmtzLA0KVGFyaXENCg==
