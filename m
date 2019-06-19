Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBA4BC8D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 17:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfFSPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 11:09:48 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:35139
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729468AbfFSPJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 11:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqC08Ttm3TYzIEckPCyBpa3hIFSI+q6EoD/EQTmHStI=;
 b=lAyfSnSh9gcASfZuflyyhREA9Q3bfE3vNTYFJx6soUUg2112tXWaZ74PjArFpcgGHoXEzT6p95eVjd8+6RqSjDfTLtoga2TXwxd6eCsjw0hnbjrek0/+m7btJY8jhOhZ/UQrhHEOBetI8JGMC0PV88F3aMYsi2ytZ97MxTUKjJE=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3199.eurprd03.prod.outlook.com (52.134.11.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Wed, 19 Jun 2019 15:09:44 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 15:09:44 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVJk5hzMyR81VfUESmZkWOItVGQqajBbKAgAAPvYA=
Date:   Wed, 19 Jun 2019 15:09:44 +0000
Message-ID: <FBCC967B-578C-459A-95EF-4AC123511B12@darbyshire-bryant.me.uk>
References: <20190619132326.1846345b@canb.auug.org.au>
 <20190619.101323.1146505723758856038.davem@davemloft.net>
In-Reply-To: <20190619.101323.1146505723758856038.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd555adb-6e77-4c40-b2f8-08d6f4c82991
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB3199;
x-ms-traffictypediagnostic: VI1PR0302MB3199:
x-microsoft-antispam-prvs: <VI1PR0302MB31996EC3AFE658515096F254C9E50@VI1PR0302MB3199.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(376002)(136003)(396003)(366004)(346002)(199004)(189003)(8936002)(36756003)(6916009)(81156014)(8676002)(71200400001)(7736002)(74482002)(229853002)(53936002)(305945005)(71190400001)(76116006)(66446008)(6486002)(66946007)(4326008)(64756008)(86362001)(81166006)(186003)(25786009)(66556008)(91956017)(66616009)(66476007)(476003)(99936001)(46003)(446003)(11346002)(486006)(6246003)(2616005)(6506007)(53546011)(6116002)(316002)(5660300002)(102836004)(99286004)(2906002)(68736007)(76176011)(508600001)(73956011)(14454004)(6512007)(33656002)(6436002)(256004)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3199;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +suF6NkQoZbv2oTxKLPxxDJ4eLeO3U26Q1f0esYxqCUq8f/vwwaapijDMvh1Q8z0z4mRNzRbiy4LDCz/Oygo9zjV3hLGZnayhFgWmoZCRcr27SblGdrK4j24QT7wNtWurvwjVCuo3q+UHf4Etr3BbsRJN0wkMkLC6On524hqrw/BXocYpLYV4XoFGkuannR/cmFqQSMalnEma09IIwHEi0PLg3GSPXxjrSxbr4MS0/g10qAp6rJEflV3l4V6zJJKFov2Nt8u+9c4CBMvPcCWBo35iNlv7M6/j7jsWt5b9Y+LOSFAgsBL2D8SIG+v6I1LIM0jDJdquQz6kXifV0emkoQjKIhqyKtcoYXpm4UWuZiEao5K555taBOQ0xg1bFgFWe8vqIca7QsrWfMFuqIt42BKo32lv5hSxm17xaOvbKE=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_25D6AD64-47A9-4F03-A64C-27AC74F1301B";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: fd555adb-6e77-4c40-b2f8-08d6f4c82991
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 15:09:44.5593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_25D6AD64-47A9-4F03-A64C-27AC74F1301B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 19 Jun 2019, at 15:13, David Miller <davem@davemloft.net> wrote:
>=20
>=20
> I've fixed this as follows, thanks:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =46rom 23cdf8752b26d4edbd60a6293bca492d83192d4d Mon Sep 17 00:00:00 =
2001
> From: "David S. Miller" <davem@davemloft.net>
> Date: Wed, 19 Jun 2019 10:12:58 -0400
> Subject: [PATCH] act_ctinfo: Don't use BIT() in UAPI headers.
>=20
> Use _BITUL() instead.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> include/uapi/linux/tc_act/tc_ctinfo.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h =
b/include/uapi/linux/tc_act/tc_ctinfo.h
> index da803e05a89b..32337304fbe5 100644
> --- a/include/uapi/linux/tc_act/tc_ctinfo.h
> +++ b/include/uapi/linux/tc_act/tc_ctinfo.h
> @@ -27,8 +27,8 @@ enum {
> #define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
>=20
> enum {
> -	CTINFO_MODE_DSCP	=3D BIT(0),
> -	CTINFO_MODE_CPMARK	=3D BIT(1)
> +	CTINFO_MODE_DSCP	=3D _BITUL(0),
> +	CTINFO_MODE_CPMARK	=3D _BITUL(1)
> };
>=20
> #endif
> --
> 2.20.1
>=20

Hi David,

Thanks for that.  Owe you a beer!

Thinking out loud, doesn=E2=80=99t this also require:

#include <linux/const.h>


Or at least iproute2 would need to know about _BITUL as it doesn=E2=80=99t=
 at present.
Which also means iproute2=E2=80=99s Linux uapi shadow would also have to =
import
linux/const.h.  Or have I got wrong end of stick?

Cheers,

Kevin



--Apple-Mail=_25D6AD64-47A9-4F03-A64C-27AC74F1301B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0KUDcACgkQs6I4m53i
M0psUA/9GL1DbVae1av6xy/JwCu5cOprT56nNGsXwKgR55GH03xX2Ym4I3yNgFa7
jKvcT7q7aesL6YR9A8v2HV6CZHfMWJAzrTqVFYjGV0JugsK5yZ5jo2eqGCB/IYKx
6iQasjBLGXUaO+8p7e161AweD4ZL2urrDXjE9HhyVpuBlQjGye35fVMimBzFUQYI
e/Ll66/qyWtpjyCJuW9mZIzomvLtZgXhFDaPFN2+sjNDvtitr96+nSq0UF6sVYTz
6lij4wftOArcNRE/1ytSBbBldrTebgCwe5UJ8DwAtv7gvHzneU+Ncjegg6/bpvXD
mvW3rR1i1iggRPA+j9Vq7TcYHhSL7imz2f7KTh46z53cmX9n9cOsEhgT9y7f1DBD
NSj+UY6x1qZ8K4wPPoZW0w4RsKBSwkN9W6OO8tYROIJIMyxpzz0jCLkEa19VW6bP
jGeDvCmWhnvnugNBnRtpA4dGBa0IQSR66HmURLyU007LAn+bsqHZHCIXp6Nq6FOc
3P1iwOWC3cs8G2H/nSGT2aDuQdOjPJSO9c/13GeSkxeVP8SgREp5DO6JVTKn7Spg
1t3ek61jiEUqkZyyqQnsJn0CtJCGi4qp9UXIM7M4cKvqUD02ISz8aBM+yFGkaJST
HKUu0k1hyUOwUivUtt08oOgdMFWqBbUtlcJaZiuEYOSNSB87bQc=
=T0d1
-----END PGP SIGNATURE-----

--Apple-Mail=_25D6AD64-47A9-4F03-A64C-27AC74F1301B--
