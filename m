Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8729186F67
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgCPPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 11:55:19 -0400
Received: from mail-dm6nam12on2100.outbound.protection.outlook.com ([40.107.243.100]:55614
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731638AbgCPPzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 11:55:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUSxuiexFNdOucmwmR8npzMAjxio5s+rBCQCJj1m0apLXryw2yDgNvxXCGTqbGWfdlv0xH9qK0rVGKt1OLUihIfj+9/K24bHJyTXwlJzMosNmO038aqANSNq/3ZUvVaIr9Sfyz/QuShgaJBZRywnrswmju77euxkqn/589lHnw2j1Q8zlU8wd8b673tNuNSGQSMpiYCWHQiZoTRdqTUkcZZn3v6KmnLM+BJVYdgHx60MIkygpV06I0ryaKix3eQC0V4JgEFQgsKqqR6w0shPtelcMVPWJEFjnXEnaSFYZiSHM/dpX1ogP/Dw005v17MNt9Z7V9CRFKDcknDKh5fBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5IHxIBlXEzpOm++BEHN8i+lK8d/49DUAdY+wFeAyf4=;
 b=IQR30R0a4zcylmfXFZF+Cf5qisvScAJZ3SNksziTtPfMR+hyF+Wp5RiaWirP6VN1Hj26ZiENDE/VGP+RQVxXszM/s8J0r3nlsAfGipCi4vIJwWqXrFoe5YpVXGvePrxZzuZtPFBPokY7IoMNHPFmnOiO5u6mi6Un1GCHkfwdkdNy2WsUcjicsYU6xlvpw/cm8tDGM7RXG7DTDbv9OcgAfFStf/AD3Cb3j3zV2wqWIM9rfWVHQMkkYBpz77sQUHzrsyr2O3BGF6YyXYRSgYaRdDypsClZ/niSMS0308BPz1eiNwzS0dj9urGBZ4cy4QPO03u5yZ0hCgdg+USMe5Kg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5IHxIBlXEzpOm++BEHN8i+lK8d/49DUAdY+wFeAyf4=;
 b=B1939oobaPmR7UUgp/2x73Q6AkAHs3U/lyS2sPikkZs7O6kBh9lCfPP17vh1BlrUc8oYg4TObZmYfayJvqA0QKUrnypARotsWBV3VMGq6eSm8iz+SCXp1tyBssW7bnUInq+cJzOAY4Lo9sjO43mKpwlt7Y8lCSdl9+fZLDVQnCM=
Received: from MWHPR13MB0895.namprd13.prod.outlook.com (2603:10b6:300:2::27)
 by MWHPR13MB1694.namprd13.prod.outlook.com (2603:10b6:300:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.11; Mon, 16 Mar
 2020 15:55:12 +0000
Received: from MWHPR13MB0895.namprd13.prod.outlook.com
 ([fe80::308b:ce00:680a:333e]) by MWHPR13MB0895.namprd13.prod.outlook.com
 ([fe80::308b:ce00:680a:333e%6]) with mapi id 15.20.2835.012; Mon, 16 Mar 2020
 15:55:12 +0000
From:   "Bird, Tim" <Tim.Bird@sony.com>
To:     Kees Cook <keescook@chromium.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH v2 0/4] kselftest: add fixture parameters
Thread-Topic: [PATCH v2 0/4] kselftest: add fixture parameters
Thread-Index: AQHV+ZtzPyFKudNXz0yxRensOrnhGqhHgokAgAPUbPA=
Date:   Mon, 16 Mar 2020 15:55:12 +0000
Message-ID: <MWHPR13MB08957F02680872A2C30DD7F4FDF90@MWHPR13MB0895.namprd13.prod.outlook.com>
References: <20200314005501.2446494-1-kuba@kernel.org>
 <202003132049.3D0CDBB2A@keescook>
In-Reply-To: <202003132049.3D0CDBB2A@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Tim.Bird@sony.com; 
x-originating-ip: [160.33.195.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 90098b92-f608-4f66-4c51-08d7c9c26999
x-ms-traffictypediagnostic: MWHPR13MB1694:
x-microsoft-antispam-prvs: <MWHPR13MB1694B5292125615652DA0FD5FDF90@MWHPR13MB1694.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(199004)(76116006)(66946007)(8936002)(7696005)(66556008)(66476007)(66446008)(8676002)(6506007)(52536014)(64756008)(478600001)(54906003)(81166006)(81156014)(110136005)(55016002)(9686003)(71200400001)(26005)(86362001)(2906002)(33656002)(4326008)(316002)(5660300002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR13MB1694;H:MWHPR13MB0895.namprd13.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: sony.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ew2jnTTpNYNNmimdkbpS0JwVaqFtIq9+k1OSYNjyfCbuBUK6GfZkHUg3Jn4IDLGbb0sJn/gtHqYZ3PydPf0mYx85INbbc41mvzcnHtb+yEJ9hgGbekXjq1leidhTU2VjfWJyOnhJ+zJ9682a0aoa6pOplBdCkHaBptIKrNFgF2pb+A8TE4ugv8sIBQqiVX0nkoaU6/VWTwfRy5qfp8fZDStPzPekUE0mtgIe3wXEEQxh7/BI/cCLNJtg+4yub6A0Pbq8tFkOjEkIlfWsdVCOp27hb4O8/Z5Xq3gr/Mbj+r73yFSanecLrRRgbInDZalLMyjvP9TpefxNnNQGD+HKjxSJmGNsa0EyD5dAgFLr/WBu/leD6idHKWfsIN0uqJ5Dgog2P05X5pbklAJzYf2Unrct3vsZVMyytYJEpLvF7LLS3uhPkMPTryQYZM4nKvdV
x-ms-exchange-antispam-messagedata: U5v1sjBB3S9bEXz3Wr2O1pavM38ne/j2B6zDAYso9+SNjD5++ce0scbSpxCkpy2TAa4V1UAkNppHHopx81SrMJcPWXMvyfQkyhN8EB+MwJuVDvN2m+KkB29i2C8xRbUCZU8Yowug+ZWmdMWNwhCsiQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90098b92-f608-4f66-4c51-08d7c9c26999
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 15:55:12.7377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dZvOpKcVjayEMHQc3q1g1UtPtT7uXgii94EcidXNdTJ2G2KUuxBjde8fvw1NYS78jWgno/+izc9/SA0IbuJdOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1694
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Kees Cook
>=20
> On Fri, Mar 13, 2020 at 05:54:57PM -0700, Jakub Kicinski wrote:
> > Note that we loose a little bit of type safety
> > without passing parameters as an explicit argument.
> > If user puts the name of the wrong fixture as argument
> > to CURRENT_FIXTURE() it will happily cast the type.
>=20
> This got me to take a much closer look at things. I really didn't like
> needing to repeat the fixture name in CURRENT_FIXTURE() calls, and then
> started coming to all the same conclusions you did in your v1, that I
> just didn't quite see yet in my first review. :P
>=20
> Apologies for my wishy-washy-ness on this, but here's me talking myself
> out of my earlier criticisms:
>=20
> - "I want tests to be run in declaration order" In v1, this is actually
>   mostly retained: they're still in declaration order, but they're
>   grouped by fixture (which are run in declaration order). That, I think,
>   is totally fine. Someone writing code that interleaves between fixtures
>   is madness, and having the report retain that ordering seems awful. I
>   had thought the declaration ordering was entirely removed, but I see on
>   closer inspection that's not true.
>=20
> - "I'd like everything attached to _metadata" This results in the
>   type unsafety you call out here. And I stared at your v2 trying to
>   find a way around it, but to get the type attached, it has to be
>   part of the __TEST_F_IMPL() glue, and that means passing it along
>   side "self", which means plumbing it as a function argument
>   everywhere.
>=20
> So, again, sorry for asking to iterate on v1 instead of v2, though the
> v2 _really_ helped me see the problems better. ;)
>=20
> Something I'd like for v3: instead of "parameters" can we call it
> "instances"? It provides a way to run separate instances of the same
> fixtures. Those instances have parameters (i.e. struct fields), so I'd
> prefer the "instance" naming.

Could I humbly suggest "variant" as a possible name here?
IMHO "instance" carries along some semantics related to object
oriented programming, which I think is a bit confusing.  (Maybe that's
intentional though, and you prefer that?)

BTW - Fuego has a similar feature for naming a collection of test
parameters with specific values (if I understand this proposed
feature correctly).  Fuego's feature was named a long time ago
(incorrectly, I think) and it continues to bug me to this day.
It was named 'specs', and after giving it considerable thought
I've been meaning to change it to 'variants'.

Just a suggestion for consideration.  The fact that Fuego got this
wrong is what motivates my suggestion today.  You have to live
with this kind of stuff a long time. :-)

We ran into some issues in Fuego with this concept, that motivate
the comments below.  I'll use your 'instance' terminology in my comments
although the terminology is different in Fuego.

>=20
> Also a change in reporting:
>=20
> 	struct __fixture_params_metadata no_param =3D { .name =3D "", };
>=20
> Let's make ".name =3D NULL" here, and then we can detect instantiation:
>=20
> 	printf("[ RUN      ] %s%s%s.%s\n", f->name, p->name ? "." : "",
> 				p->name ?: "", t->name);
>=20
> That'll give us single-instance fixtures an unchanged name:
>=20
> 	fixture.test1
> 	fixture.test2

We ended up in Fuego adding a 'default' instance name for=20
all tests.  That way, all the parsers don't have to be coded to distinguish
if the test identifier includes an instance name or not, which turns
out to be a tough problem.

So single-instance tests would be:
            fixture.default.test1
            fixture.default.test2
>=20
> and instanced fixtures will be:
>=20
> 	fixture.wayA.test1
> 	fixture.wayA.test2
> 	fixture.wayB.test1
> 	fixture.wayB.test2
>=20

Parsing of the test identifiers starts to become a thorny issue=20
as you get longer and longer sequences of test-name parts
(test suite, test fixture, sub-test, test-case, measurement, instance, etc.=
)
It becomes considerably more difficult if  you have more than
one optional element in the identifier, so it's useful to
avoid any optional element you can.

>=20
> And finally, since we're in the land of endless macros, I think it
> could be possible to make a macro to generate the __register_foo()
> routine bodies. By the end of the series there are three nearly identical
> functions in the harness for __register_test(), __register_fixture(), and
> __register_fixture_instance(). Something like this as an earlier patch to
> refactor the __register_test() that can be used by the latter two in thei=
r
> patches (and counting will likely need to be refactored earlier too):
>=20
> #define __LIST_APPEND(head, item)				\
> {								\
> 	/* Circular linked list where only prev is circular. */	\
> 	if (head =3D=3D NULL) {					\
> 		head =3D item;					\
> 		item->next =3D NULL;				\
> 		item->prev =3D item;				\
> 		return;						\
> 	}							\
> 	if (__constructor_order =3D=3D _CONSTRUCTOR_ORDER_FORWARD) {\
> 		item->next =3D NULL;				\
> 		item->prev =3D head->prev;			\
> 		item->prev->next =3D item;			\
> 		head->prev =3D item;				\
> 	} else {						\
> 		p->next =3D head;					\
> 		p->next->prev =3D item;				\
> 		p->prev =3D item;					\
> 		head =3D item;					\
> 	}							\
> }
>=20
> Which should let it be used, ultimately, as:
>=20
> static inline void __register_test(struct __test_metadata *t)
> __LIST_APPEND(__test_list, t)
>=20
> static inline void __register_fixture(struct __fixture_metadata *f)
> __LIST_APPEND(__fixture_list, f)
>=20
> static inline void
> __register_fixture_instance(struct __fixture_metadata *f,
> 			    struct __fixture_instance_metadata *p)
> __LIST_APPEND(f->instances, p)

With my suggestion of 'variant', this would change to:

static inline void
__register_fixture_variant(struct __fixture_metadata *f,
			    struct __fixture_variant_metadata *p)
__LIST_APPEND(f->variants, p)


Just my 2 cents.
 -- Tim
