Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450D14B460
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbfFSIuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:50:44 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:4933
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730783AbfFSIuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 04:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QvYgpxRE0MZL9gFCP4+bkRYQ2YZl+PEph6LjAxHDWM=;
 b=MNRdAUlONH89JsbKWJ9gWdr4tAxUNeQHqj5ECjIOMKUm5lmW0CjbSxO6MseBxMIqkj+ORUiy115QGOL58VPSe3AYYu9TLeaFaPF/tbWz/3z0xlnGOEPQGfafWeBf+25rF+5d9HftY5xxZWRkpLTZd0hWhYRCB2xd8nCZoQPHPRE=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3231.eurprd03.prod.outlook.com (52.134.12.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Wed, 19 Jun 2019 08:50:38 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 08:50:38 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
CC:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVJk5hzMyR81VfUESmZkWOItVGQqaiWvKAgAADTwCAAE1DgA==
Date:   Wed, 19 Jun 2019 08:50:38 +0000
Message-ID: <433DF696-C623-4663-B374-9CFEA6CAD27A@darbyshire-bryant.me.uk>
References: <20190619132326.1846345b@canb.auug.org.au>
 <CAK7LNAQCe0APJ3ggJYRDf_DjYg=dH9+2nNsYoygiFKhTa=givg@mail.gmail.com>
 <CAK7LNARVfXySZK_Wzmww=UeFwpWu+vjbctK33zX9KW8w_adexw@mail.gmail.com>
In-Reply-To: <CAK7LNARVfXySZK_Wzmww=UeFwpWu+vjbctK33zX9KW8w_adexw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5e37117-cb6d-412d-aa76-08d6f49333eb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:VI1PR0302MB3231;
x-ms-traffictypediagnostic: VI1PR0302MB3231:
x-microsoft-antispam-prvs: <VI1PR0302MB323166FD353F0B9729E5F5E2C9E50@VI1PR0302MB3231.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(346002)(39830400003)(376002)(199004)(189003)(54164003)(51914003)(53754006)(64756008)(73956011)(66946007)(66616009)(91956017)(66476007)(76116006)(53936002)(6512007)(316002)(81166006)(6116002)(81156014)(54906003)(8676002)(8936002)(6436002)(4326008)(99936001)(74482002)(68736007)(6486002)(25786009)(33656002)(229853002)(36756003)(6246003)(446003)(14444005)(2906002)(14454004)(66556008)(256004)(5660300002)(99286004)(2616005)(71190400001)(186003)(53546011)(86362001)(76176011)(508600001)(305945005)(476003)(7736002)(6916009)(66446008)(46003)(11346002)(6506007)(102836004)(486006)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3231;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cbzuh6AIcQt24JJoM2xy03am83adlACq5cXcPceOZIRyP3iOKFWgMqwdJLLcnJlPhwbEsI8iCm7dX0+GamQx4yPX6e/G4cQyw97TwnjuXnNkpWwHaJvBqH8CnyTCAQGvQRbCP89ak6Q4oB7Ohb9p5QJgQ1KtliQHWvcQDj4Hh8akPGJsTxe386yfzg3oYLDwLYNgWwcicZqBfxjbTFS+Q7PAaQQqitaEiM+vq3KA4C5KL1W8Kz7iv5TvdOQ9rN/DhYKMfrwn3RMXhqm39yLSS7avMcG2TgWY1FYAIYVRjkmefgnAy0qbZghq14TznW6yJjf5AyT1LtXM5Mxb4QHMfxtmaRqBYQkm2VGeenV75nbnsXcIMqfuz6z7LqYIxnVUSQf7Rufq7C5/M/pj4qRNnjmZC1HCVoUhLOFFQm60q/Q=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_A691540D-2A02-457D-9A54-FD84DA7A967A";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e37117-cb6d-412d-aa76-08d6f49333eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 08:50:38.6805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3231
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_A691540D-2A02-457D-9A54-FD84DA7A967A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Greetings!

As the guilty party in authoring this, and also pretty new around here
I=E2=80=99m wondering what I need to do to help clean it up?

> On 19 Jun 2019, at 05:14, Masahiro Yamada =
<yamada.masahiro@socionext.com> wrote:
>=20
> On Wed, Jun 19, 2019 at 1:02 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
>>=20
>> Hi.
>>=20
>>=20
>> On Wed, Jun 19, 2019 at 12:23 PM Stephen Rothwell =
<sfr@canb.auug.org.au> wrote:
>>>=20
>>> Hi all,
>>>=20
>>> After merging the net-next tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>>=20
>>> In file included from =
usr/include/linux/tc_act/tc_ctinfo.hdrtest.c:1:
>>> ./usr/include/linux/tc_act/tc_ctinfo.h:30:21: error: implicit =
declaration of function 'BIT' [-Werror=3Dimplicit-function-declaration]
>>>  CTINFO_MODE_DSCP =3D BIT(0),
>>>                     ^~~
>>> ./usr/include/linux/tc_act/tc_ctinfo.h:30:2: error: enumerator value =
for 'CTINFO_MODE_DSCP' is not an integer constant
>>>  CTINFO_MODE_DSCP =3D BIT(0),
>>>  ^~~~~~~~~~~~~~~~
>>> ./usr/include/linux/tc_act/tc_ctinfo.h:32:1: error: enumerator value =
for 'CTINFO_MODE_CPMARK' is not an integer constant
>>> };
>>> ^
>>>=20
>>> Caused by commit
>>>=20
>>>  24ec483cec98 ("net: sched: Introduce act_ctinfo action")
>>>=20
>>> Presumably exposed by commit
>>>=20
>>>  b91976b7c0e3 ("kbuild: compile-test UAPI headers to ensure they are =
self-contained")
>>>=20
>>> from the kbuild tree.

Stephen, thanks for the fixup - is that now in the tree or do I need to =
submit
a fix via the normal net-next channel so it gets picked up by the =
iproute2 people
who maintain a local copy of the uapi includes?


>>=20
>>=20
>> My commit correctly blocked the broken UAPI header, Hooray!
>>=20
>> People export more and more headers that
>> are never able to compile in user-space.
>>=20
>> We must block new breakages from coming in.
>>=20
>>=20
>> BIT() is not exported to user-space
>> since it is not prefixed with underscore.
>>=20
>>=20
>> You can use _BITUL() in user-space,
>> which is available in include/uapi/linux/const.h

Thanks for the pointers.

I am confused as to why I didn=E2=80=99t hit this issue when I built & =
run tested locally off
the net-next tree.


>>=20
>>=20
>=20
>=20
> I just took a look at
> include/uapi/linux/tc_act/tc_ctinfo.h
>=20
>=20
> I just wondered why the following can be compiled:
>=20
> struct tc_ctinfo {
>        tc_gen;
> };
>=20
>=20
> Then, I found 'tc_gen' is a macro.
>=20
> #define tc_gen \
>        __u32                 index; \
>        __u32                 capab; \
>        int                   action; \
>        int                   refcnt; \
>        int                   bindcnt
>=20
>=20
>=20
> What a hell.

This is what other actions do e.g. tc_skbedit.  Can you advise what I =
should do instead?

> --
> Best Regards
> Masahiro Yamada

Many thanks to all for your valuable time & advice.


Cheers,

Kevin D-B

gpg: 012C ACB2 28C6 C53E 9775  9123 B3A2 389B 9DE2 334A


--Apple-Mail=_A691540D-2A02-457D-9A54-FD84DA7A967A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl0J910ACgkQs6I4m53i
M0qa2hAAzQspu56yTmCCVNtr/YpO//2GIx44cpOHqCj15smuw6wuumZT6hAvDHKH
0jc1CzAK5QMGlhZRJp3MYLPza8yp118kd1/vrpMzcoojDjozEQ88ocJIU19PBOFU
/jWjjMzW7vFP1UyKzU7yyEA/ApWU9kKR33O3F+iDWRmJq3xOberIPJVAowSug1rP
V/p1he05/whZhCKPtNpJ6kjmVK5X9+tkf1jPp9YzPvYHmyQY7pWq/y3RkjJtVM0Y
jThbEEul774BG3HxVgjGAn3B2KxMRAMalE54eew1adqcPFBoCVIEmUkjNgzxqJsk
fn21UOzzaTw4lZdHpsiDXT5qxpQ/H1S0o9nQG9wQ/Ml5BxK7KsKOq48E4QybU7St
P40HkAbtHCFT9dpIEvh/t2EVhQ51T+BT3szSCsgdkAhMNgGxi46cpdkFKih8n3Ro
qS+7Djij49b39pknHRmGrpLaL6/fFpmzN8q54Kzj/jGPYRLmeYUVmsz4WPw3Fc/2
mbUKd3q6e/DMc75tQmEdWa/R2eizX8XzzgZcj5RdZTUdsPKCqa2v6fJV+Hq1EGad
6ZON/DHkzsp97T82AYbzcMTY+jGJhmVjGIk2fEDUJYgiXGUMiNFirpqs2nX5q8BW
fEOb5yIg9cUOglejS4ZhStt7Rugd+oYNTqHzqo8MgdwU4HOpQOE=
=kGas
-----END PGP SIGNATURE-----

--Apple-Mail=_A691540D-2A02-457D-9A54-FD84DA7A967A--
