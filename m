Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18814BDCD
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfFSQMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:12:43 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:39339
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726091AbfFSQMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2llKLl04ylib+R1WEXD7wDTFGggF8q67044CVeH6jU=;
 b=U+su+vHtzysy2DtfpL6vftneEathFPYyZsIEYQ+UHDZeAetYZNNRfRdG94awP24JjF5UXPaOY9jPlVeZUyX9H7uz04X7BkCYJ3br2HJ+bH25iOqg/3h9BDE7auohebhe+C8Ifn1xlA/4G9QAFFQQ7mh6m171xmCmbsZgzsnCb7w=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3440.eurprd03.prod.outlook.com (52.134.14.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Wed, 19 Jun 2019 16:11:57 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 16:11:57 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVJk5hzMyR81VfUESmZkWOItVGQqajBbKAgAAPvYCAABFiAA==
Date:   Wed, 19 Jun 2019 16:11:57 +0000
Message-ID: <E64EDC05-46B5-41A8-BCA8-590FE9645FC8@darbyshire-bryant.me.uk>
References: <20190619132326.1846345b@canb.auug.org.au>
 <20190619.101323.1146505723758856038.davem@davemloft.net>
 <FBCC967B-578C-459A-95EF-4AC123511B12@darbyshire-bryant.me.uk>
In-Reply-To: <FBCC967B-578C-459A-95EF-4AC123511B12@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8f6652b-5a32-47a6-7d36-08d6f4d0da9d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB3440;
x-ms-traffictypediagnostic: VI1PR0302MB3440:
x-microsoft-antispam-prvs: <VI1PR0302MB34405922DED8FC695E035453C9E50@VI1PR0302MB3440.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(39830400003)(346002)(366004)(199004)(189003)(229853002)(486006)(33656002)(8936002)(81166006)(71200400001)(64756008)(6116002)(86362001)(71190400001)(53546011)(8676002)(186003)(102836004)(6512007)(66446008)(66476007)(53936002)(81156014)(6506007)(66946007)(25786009)(73956011)(76116006)(5660300002)(305945005)(91956017)(2906002)(68736007)(14454004)(66616009)(508600001)(6916009)(66556008)(99936001)(6246003)(476003)(7736002)(99286004)(4326008)(36756003)(446003)(74482002)(316002)(6436002)(256004)(46003)(2616005)(11346002)(6486002)(76176011)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3440;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ujAmIDytJM0Oqv6CzPb5Ibty5FseTd43NgI1dhSBxTN9St7poAVmGEzxrhfAcI8ka45OKzzs5wKtqaZk+e9YZHJo5+nVeX+tnLB/K4UQBKsbRRaXqZ/o5FGJyPK0Pwf2AtYwfLjkQmGBNAXnAcTKF8Ad+GUPUn8JzwovM2cbjFWVu7zFfTC2zIqq2yCwCf9ZW1BImAA8uzjPYEbUhszj+YO5DnLj3LYjxHhCnHGLTdZYSggBPPnRXwU8ON6tkY28KmYmq8IQrzVPlBYbZKjyRbXEMW42BsUuwjS2DwWJpfEzcpGlmDCSDB2f/R6mzoEXYR7GRJaDGdt8sMyNfTZgUz5EvqWMm4ihFCkpZSp5MzXtyNoA5QlSPxl2b0bnxCxpmDXNOmeLoBEdtyiGr0rS6bnlswnEs1YcjZQD4Q7VjJE=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_CC1B9169-9B67-4441-BC09-1EF5F7DE38BC";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f6652b-5a32-47a6-7d36-08d6f4d0da9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 16:11:57.5981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_CC1B9169-9B67-4441-BC09-1EF5F7DE38BC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 19 Jun 2019, at 16:09, Kevin 'ldir' Darbyshire-Bryant =
<ldir@darbyshire-bryant.me.uk> wrote:
>=20
>=20
>=20
>> On 19 Jun 2019, at 15:13, David Miller <davem@davemloft.net> wrote:
>>=20
>>=20
>> I've fixed this as follows, thanks:
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> =46rom 23cdf8752b26d4edbd60a6293bca492d83192d4d Mon Sep 17 00:00:00 =
2001
>> From: "David S. Miller" <davem@davemloft.net>
>> Date: Wed, 19 Jun 2019 10:12:58 -0400
>> Subject: [PATCH] act_ctinfo: Don't use BIT() in UAPI headers.
>>=20
>> Use _BITUL() instead.
>>=20
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> ---
>> include/uapi/linux/tc_act/tc_ctinfo.h | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h =
b/include/uapi/linux/tc_act/tc_ctinfo.h
>> index da803e05a89b..32337304fbe5 100644
>> --- a/include/uapi/linux/tc_act/tc_ctinfo.h
>> +++ b/include/uapi/linux/tc_act/tc_ctinfo.h
>> @@ -27,8 +27,8 @@ enum {
>> #define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
>>=20
>> enum {
>> -	CTINFO_MODE_DSCP	=3D BIT(0),
>> -	CTINFO_MODE_CPMARK	=3D BIT(1)
>> +	CTINFO_MODE_DSCP	=3D _BITUL(0),
>> +	CTINFO_MODE_CPMARK	=3D _BITUL(1)
>> };
>>=20
>> #endif
>> --
>> 2.20.1
>>=20
>=20
> Hi David,
>=20
> Thanks for that.  Owe you a beer!
>=20
> Thinking out loud, doesn=E2=80=99t this also require:
>=20
> #include <linux/const.h>
>=20
>=20
> Or at least iproute2 would need to know about _BITUL as it doesn=E2=80=99=
t at present.
> Which also means iproute2=E2=80=99s Linux uapi shadow would also have =
to import
> linux/const.h.  Or have I got wrong end of stick?
>=20
> Cheers,
>=20
> Kevin
>=20

Whilst out walking the dog I realised I=E2=80=99m a moron.

The CTINFO_MODE_FOO is only used within module, it shouldn=E2=80=99t =
even be exposed
to user space.

I=E2=80=99ll send a patch shortly.  Sorry, I=E2=80=99m pretty =
embarrassed at how something so
apparently simple on the surface has had so many issues.

Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_CC1B9169-9B67-4441-BC09-1EF5F7DE38BC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0KXswACgkQs6I4m53i
M0prxg/+P326rn4mttqerO84lVCkjQSz5LcmNlxF9D3o1Lhine4lS5NQMRxqC+Tp
zrnq7SB0drz2XT6YdgP0oEvYQgkLKli4+jHcS62ADZ+hqZyRo/s22f204SOVZ2/l
GaWJLD1iXrDk+93syAfOt9fibP42FvNSggCzwXKVFPDxJvcUWvILUzdYdC4b1v2i
aCdTEicnTnp3RrGJEyD22NrE9pgtKWr6PCO0+mwIRpg/Ht+4wvXdAi7vpkk4/D3l
xFF8o9HzoGwXci3nqhOUmPRlTC3CX+17ZnEmirD08ZpVCeZrImPpwETHLHE2qR7g
6YEA0KsuT0eCQ+33QLqLNB85Im8xq2xAycbeusu20EzujIl23+SNfDofhiO8z4LC
6sVwptMDSfENIpUucubUtwh+Rs3wvzZpVsF+XIH/+dFtm7KH575jz2zFT56ZYPTH
cqyceAeSfvhkf2JH7W+ibk9qSmqOG099wXK5TjzG46YZA0s2oDqjlCqjQM12Q659
D0ZdIEalxy+wULPxfLXrfqHGi52EaC0CHUttNrYlVZ6sLmZ47zltRfBLPUxqZV/0
8ZKwUnJDoUP5PXXbMg8o6MO4VXYyGH4qVE6G+Hq+1z3sBgIvRwGo6cXD2UNa0YUJ
abh9J+IHGSH+Mm5BNtnPs+Czp0sTpu4fK7JLPO8NQBMdhuT0UhQ=
=n7Yl
-----END PGP SIGNATURE-----

--Apple-Mail=_CC1B9169-9B67-4441-BC09-1EF5F7DE38BC--
