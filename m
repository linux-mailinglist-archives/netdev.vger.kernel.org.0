Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF431254C5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfLRVeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:34:06 -0500
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:56245
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726674AbfLRVeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 16:34:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUf2a7YRJQE4eyMZ1YCpnJnP8p6b86t4LFqhgSayKN693LM/0eMw6YjyKH4aivWyHFGshss9S5y1aZcioGeJ5YEcGuZFJG1fEnkeWKlTe6IFtA7ZnvlJW+X0Pv0RTk0z1/3FyWDu3aXuA4uNzflExiEDP8BcvuFWSNfoSyvr57ZsY0b1YV0N20+3b8BBtq1HeBsV7XXQTD+uuOfKso+Elpaf1rlZ5oTwxgzcKy2Gbbiad5vEBv06PJ5kFwzcgwqMKVzShH4ACqbIK8zXkH6E5XgNB+7NkiGSupyZ+rLlqByAp5FcKGBYj7jNguBy7AzE6uRyuv+X0T4PKeagX2dtUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIUSnTQKFgfNmudYkusp/RBEkHWp+mix29vB1gf/E4c=;
 b=earl2P18g1tiNv0gksWOcJGTJBT7RSYFAcfml5QqKXkhNo1F/QSj/n7CI0Sx+dr+gw3Axz+gE+tf8rEZxJTnmNtgzdKtYdyjLeIVgfuHIeCE+en3QilYTirtoBKGjO88e/1/1C46AWECWH49DHtDQ+CS0jRG0QpXTF57wR8kSQxWt9rlBKRRtmUqqMpVn8pUEFPcO+wwOjf2ETOgApjCbK+VpaVTqfQl0VyFMAVNG1H08IBDnMxK3Kwvq6VKyxVdPrWZs/IAlqlw11vgFahx8fR6lIW1WUDcHFC8U7hbsX60E9q6ygQCibElhnKNpgQrVYBW8h6iZPc3XksXskjx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIUSnTQKFgfNmudYkusp/RBEkHWp+mix29vB1gf/E4c=;
 b=jIPZhhesxN0V74UfgZM5/AYw6vgGy82TGTWC8819YFtsIOeSLQ5NyAbBAjXApGaImQVHd+8W+0iJURmssYPz23Z3LakuYGVuH5tL9ENkdDcdjmjfhXTAF3Ml+jgD+8ANDk5ElQxp/2R/UwDJXVYSwBOC2tMddBDxklqVq+x2ETY=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2768.eurprd03.prod.outlook.com (10.171.106.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Wed, 18 Dec 2019 21:34:00 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 21:34:00 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Thread-Topic: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Thread-Index: AQHVtawqU01I35ZFf0y7jA/tdJ+eDKfAaKcAgAABtYA=
Date:   Wed, 18 Dec 2019 21:33:59 +0000
Message-ID: <74C9225E-77A2-461A-A429-9501E35D3EAB@darbyshire-bryant.me.uk>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
 <20191218.132750.22964331376514008.davem@davemloft.net>
In-Reply-To: <20191218.132750.22964331376514008.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4fb71de-c0eb-465f-f6d9-08d78401fed1
x-ms-traffictypediagnostic: VI1PR0302MB2768:
x-microsoft-antispam-prvs: <VI1PR0302MB2768AE5BF1089AB3F5F2441BC9530@VI1PR0302MB2768.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39830400003)(396003)(199004)(189003)(66446008)(316002)(76116006)(36756003)(6506007)(6916009)(91956017)(66946007)(66616009)(5660300002)(6486002)(6512007)(66556008)(8676002)(4326008)(4744005)(86362001)(66476007)(64756008)(186003)(2616005)(8936002)(53546011)(508600001)(2906002)(71200400001)(81166006)(81156014)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2768;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K0hmAhq+OiqhJGcAdWtSKhTK1a0MUcOSh5IfyKb54sWPY57zaxZVXY5g5qlfZBdi/YiKi3gOdXKG8eii1VhMOrDi23aY3N+aQBYe9tbIFPiOLpNAtiYGYKvZBkmoBeuNVDH+iqrKCaX8koDxCQA4iLrgvKwRoJHdL+7NVcVGdA6I7znlFtddVJw8wF3M3cNDZ5i+q39tzw33E7hy2Fmv+Bwb584lY8S3AecpBYVMEBM23hEA6B2RFUCu4xh72g6De7d3DA73yP1y5s6+RSCrPxHWtrYXqP2o9/DuHgDFKrM/r+wNeMKCX4UTVPmhbZ5Y+HfVlIkmg7qzkg2ckdJx9C9I5D5iZtVxSe/PhYxSWPzJc+BLMSeMtv741wRgpKXBHrPL3FqiN113KFJsor2vsvXztOPv+3UmvEYT0yagjV+5ooUOg7+Kkw+eyDXuwYzL
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed;
        boundary="Apple-Mail=_B9E4E978-6EA8-42AF-95A7-12079C02DCBD";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fb71de-c0eb-465f-f6d9-08d78401fed1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 21:34:00.0101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8HgiXwEGHCmcTVb5rs3mUaDprm06oz5/dqfo4YndvvUB2FMr/VGpjLpPOEeDaQtAqAOzLC6cDmEV/ygEjrYABNU1ZO6WLZzb8L0pnPFKe6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_B9E4E978-6EA8-42AF-95A7-12079C02DCBD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 18 Dec 2019, at 21:27, David Miller <davem@davemloft.net> wrote:
>=20
> From: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> Date: Wed, 18 Dec 2019 14:05:13 +0000
>=20
>> Turns out tin_quantum_prio isn't used anymore and is a leftover from =
a
>> previous implementation of diffserv tins.  Since the variable isn't =
used
>> in any calculations it can be eliminated.
>>=20
>> Drop variable and places where it was set.  Rename remaining variable
>> and consolidate naming of intermediate variables that set it.
>>=20
>> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
>=20
> Applied, thank you.

Wow, thank you!

It=E2=80=99s a great feeling getting a patch into the kernel :-)

Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_B9E4E978-6EA8-42AF-95A7-12079C02DCBD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl36m0UACgkQs6I4m53i
M0oUsw/5Ac44U5vRhBxk6COYM1N5lTqB1IR/ZrXyjLzcxiK0z3n67Uw4cvhJ2BrF
Irj48zoYp7B8n8ucfQajWs7TsGB24u2p8Ke92GVgoXd2pAOov0MUgc7AKoLbwJdg
B6w0g4QbtYLQOBSQrDoB/aR0wIKQngs5Nm8NeHkkKigsEY5YAv62IXYiFnGNuOE3
5ogZGlzE01aVOTjDtydk/Z3oxHNwR6I0rWGeydqsNqDaIqLxKd279AdomN8fJ9FM
/n3v4KQyDNmItiloekn0LAyK5MfcfqhEkJjQI0sYlwHzEMwuKNKLjujZgj4mLgTV
mFgyE0IbXYenhV6HkL2DaNWM3CAJHjVOfMeSdHSaxA9KcZhi8cFM1b9LEJ0WAq56
83yvORX1hxNfIGijyW6qXKkw3D4qXw41EapizQrsvmproVEtu6fnlXheZe9khMRP
Lz0IHQhBCgkF6VDPNj+7fb1e9dIfUUqN/kYlBLLIn7B/YwIaefsshi15BpyqQjo0
fHapgLY0AF+pF6DN1ul/p/q12OAh0KlFZur1obF7IB/yrZxBFX7OFfS5f5sZ0EOd
wLIXw/Ofd2MW6BEs3dZR1tqv5GqWA4AZ/1STh871XbYsVr79e8vTFqSAZ5Te9Z3D
+Amahgkc5GOSTKu5i+QBinpZMnsZuIBOmxkRbg1a/OGIG1ozTtI=
=QfAr
-----END PGP SIGNATURE-----

--Apple-Mail=_B9E4E978-6EA8-42AF-95A7-12079C02DCBD--
