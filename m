Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C993567EF3
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 14:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfGNMRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 08:17:14 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:31126
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728302AbfGNMRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jul 2019 08:17:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idB3MM29pFZmSjYH2feGqXGKLgHx6yf9ojbHz7+tmvL5gNa/+owLPwsWdDZ9c1+0HLu6IsJYfJmAqhVDTfTs4mbfZLk5E5bW3OA5SLN1x4tqoqtQRG79Q33uh6KT1d1/aFDXciwdBSUJpFVak+s2W4GhDWSKI5TiACLYh2FeQcWbt6Y7kbuRSEDhcV+i+NDTuav2ygGXZ1w5HGlQvJY8o0K5oHXFbOB0MyaysVPBJ5Llo6MYhBqTmDlH8EGQwsgRHMCiw2XIeYfpZUJl+nrHk/DT5NyJlUM+56L3vTAhR938IuaynBBBOv2QSHS408UAohJAzW7/z6HdIYULhXi8vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KAAXBbowXa6Gsnw4nWI4tDVixjGa9RAfzF4PsWX7ig=;
 b=MEHZIMpkyw6ypQAkjJzRxfbRL7dbsNvdn8InNyNqEnKkYnwMq5asoBF7wCB3yZMolWduo01hXzzLdxlYovnP4pLW13P0E7fWxuAImvrt98XE90NWL/FkLL/Hmuk+EQfohTpf0RGs0P+bP/ahpGXnGS07oNXJtPuzxvS6YZz33Ztr1sMbv5vBWhNK6on81tNnHJ6sJEzaef6TOuqUkTdmr0EOoE1QkKYgIdsAwO5uR3PCeLwYkmLaC0R08xItpypFx6P8CInktJu7jXhiXP6UdVH8HtBI/UxGDwpK/JqEIOxwuorZbfTDhcdypXEffVbTjJm49x613hOuO6do2Dt25A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KAAXBbowXa6Gsnw4nWI4tDVixjGa9RAfzF4PsWX7ig=;
 b=DmFyg/lgF8NBaS06znIKRSYxALBZ/NcHdFKzhIkzh/y5okeyi712Pa7lx3PdrbZc7ESEtLsipzq0+EIAXBKmHmmjt28By7AA5WMJTR3zLz3MX1jUzMB76HItpGKFnJqwWTKmYLqoKFy3UsnRbdhAWCuqp+FCnN7T/GSBOIxhBpQ=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6315.eurprd05.prod.outlook.com (20.179.40.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Sun, 14 Jul 2019 12:17:08 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2073.012; Sun, 14 Jul 2019
 12:17:08 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Thread-Topic: linux-next: Fixes tag needs some work in the net tree
Thread-Index: AQHVOH4jqpLwEYqGE0Kxlz4/p/63C6bJ9GOAgAAWMYCAAACIgA==
Date:   Sun, 14 Jul 2019 12:17:08 +0000
Message-ID: <a03dd9fc-1574-3721-d007-7981bf522908@mellanox.com>
References: <20190712165042.01745c65@canb.auug.org.au>
 <4f524361-9ea3-7c04-736d-d14fcb498178@mellanox.com>
 <20190714221511.7717d6de@canb.auug.org.au>
In-Reply-To: <20190714221511.7717d6de@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0170.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::14) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b4f7d67-aace-43d3-5eef-08d708553136
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6315;
x-ms-traffictypediagnostic: DBBPR05MB6315:
x-microsoft-antispam-prvs: <DBBPR05MB631560236246F3C29AE211E0AECC0@DBBPR05MB6315.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0098BA6C6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(199004)(189003)(316002)(2616005)(3846002)(6116002)(186003)(229853002)(446003)(11346002)(54906003)(102836004)(26005)(5660300002)(486006)(256004)(36756003)(53546011)(66446008)(66476007)(66556008)(64756008)(66946007)(4744005)(6916009)(2906002)(31686004)(8936002)(66066001)(478600001)(31696002)(476003)(6486002)(68736007)(6512007)(6436002)(8676002)(81166006)(14454004)(6246003)(107886003)(81156014)(386003)(6506007)(52116002)(99286004)(76176011)(86362001)(7736002)(4326008)(305945005)(71200400001)(71190400001)(25786009)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6315;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: auW5iu+RNamk5NPkgIgn+nOiJxzs8hvqxR2rUp4RAFKauY2x2JlnOto4jimSZ/rBQ99anapXWMgr18zQf4st6YO07/GuaS7M5yttXCqhrZ+Uut34mQVQF2K0oeFIMjkxzlnY6o6xtVZQ/NvY7SWyK3VyuDwAZz9uCQymBzKRruy2nmJRP/jUVjEJg+W+I5WhLEsJDK/6xjDxx4SAK1kDpaqdTR5UtrpxtnWSG0hheIjB+CUMoS1itcIn23hpB9RKhh6GAJyyofG0WRMUk30BeN5W7WRtAnHecv/fjSqYchbfBcUzhLsPk/E1lgVS8cavWZUvHhb7X+TS0EOJtOz89U5W1GNg6Mos150GEnuAQSPe5XGcZlqNmDAMOAPTUCr6w6KzK7YcmB6MxSxUzPGLPNJh/eoEUxGSqbENdev7uOI=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <A09042D929AB694990C8B662665F00FC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4f7d67-aace-43d3-5eef-08d708553136
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2019 12:17:08.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6315
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2019 3:15 PM, Stephen Rothwell wrote:
> Hi Tariq,
>=20
> On Sun, 14 Jul 2019 07:55:48 +0000 Tariq Toukan <tariqt@mellanox.com> wro=
te:
>>
>> How do you think we should handle this?
>=20
> Dave doesn't rebase his trees, so all you can really do is learn from
> it and not do it again :-)
>=20

Sure.
My bad, used the SHA1 I had on my internal branch.

Thanks,
Tariq
