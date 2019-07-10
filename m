Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669EA6469F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfGJM7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:59:47 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:37601
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727245AbfGJM7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 08:59:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glpSn8ARLpykn0SDEqRS+7+G057qkle/xW0XbFgMfaFhgM5KtSWYf+DmFdlREzH9anZjBkWZa4o3J68OndU+J1H7JiNlNxo7VxrvO7FBc1G+BWNRoO09kQpYXezMlc0xfH/Od9PmxWtVJQGt/b8nTdc6f/Tf4p8xuQ4s5n0J98V3XqozYIS5+L3uBJc388hDqW6fE7bYUItk+zrB9oIeHSLpyQn5TC1y8NLxhBKzeUl0foGLFbZADXXUBLW5t1Ty9km2u4w7A8ti9+s/gL1zabXvDThnk0TOOYbGLFtfbjG1mUj4tKKuyJT+mOTUkY4bc61g/y440WeoErnT7fu01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lm3UplaUFnYKBJsYFVbBmS9Qm+rUO9Ds3PrK+WruQuU=;
 b=XLF+6T9AjQC+7RnNfBZ5tgJEuyxhDO/gDHmLdGwmodYObmtBaxevdo8XuFtPIeDW18slDQZXYW98ErHNWu90wCbLoe0IUKheOR46Fbr2+RfNg9AeOT1Kl27mNU0QkVL1DxLgYRhF44xRlkAHPeMZf7WmnYL0ZywuPItBUEQ8Ekw7jMgESOuucU8yRUxjwxJ2NPXqQp77fHdBNoq42dmBS8YrTFdg0jSMyOFGMOfA6giHPNiyotQ2vQJh8A6/5A04+z7FllnphLqKuySrgx6lTCNTqmqliauwJRj3uP4OTPwp8Dhsms0pe6Y2GlrLV42zGTe4+3NjzayLe80Sg0fnqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=ericsson.com;dmarc=pass action=none
 header.from=ericsson.com;dkim=pass header.d=ericsson.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lm3UplaUFnYKBJsYFVbBmS9Qm+rUO9Ds3PrK+WruQuU=;
 b=e8IZjZitcQPuop0sg8Oflj3tegVd7eFF/JWeLtoLrfm6lS5wI6TOKQIrQS/lMPlJg1l9G7X6Xkc+1fhJXqckgRchbHDYe5fD/E6q3KneHiqXPXbapWhF3URGNA/emVf+X6/kHWh7M0p9H8DdAHLix5j/XwJK/2o+Xpo3p7fPHNQ=
Received: from AM6PR07MB5639.eurprd07.prod.outlook.com (20.178.91.76) by
 AM6PR07MB5606.eurprd07.prod.outlook.com (20.178.90.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.8; Wed, 10 Jul 2019 12:59:41 +0000
Received: from AM6PR07MB5639.eurprd07.prod.outlook.com
 ([fe80::a530:36cf:3e2a:a12f]) by AM6PR07MB5639.eurprd07.prod.outlook.com
 ([fe80::a530:36cf:3e2a:a12f%6]) with mapi id 15.20.2073.008; Wed, 10 Jul 2019
 12:59:41 +0000
From:   Jan Szewczyk <jan.szewczyk@ericsson.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Question about linux kernel commit: "net/ipv6: move metrics from
 dst to rt6_info"
Thread-Topic: Question about linux kernel commit: "net/ipv6: move metrics from
 dst to rt6_info"
Thread-Index: AdU2+HKrTE257Ye/RNyCdrk4RqkOOgAImVWAAADYahA=
Date:   Wed, 10 Jul 2019 12:59:41 +0000
Message-ID: <AM6PR07MB5639E2AEF438DD017246DF13F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
References: <AM6PR07MB56397A8BC53D9A525BC9C489F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
 <cb0674df-8593-f14b-f680-ce278042c88c@gmail.com>
In-Reply-To: <cb0674df-8593-f14b-f680-ce278042c88c@gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.szewczyk@ericsson.com; 
x-originating-ip: [193.105.24.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8bd551f-f74f-4da7-e1d1-08d705367926
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR07MB5606;
x-ms-traffictypediagnostic: AM6PR07MB5606:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR07MB560694461880F1BD1AE03FAEF2F00@AM6PR07MB5606.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(13464003)(189003)(199004)(51914003)(2501003)(44832011)(6436002)(66946007)(66066001)(229853002)(476003)(76116006)(33656002)(66446008)(4326008)(110136005)(14454004)(64756008)(486006)(6116002)(3846002)(11346002)(68736007)(66556008)(71190400001)(81166006)(256004)(14444005)(305945005)(86362001)(6506007)(8936002)(76176011)(53546011)(7736002)(26005)(102836004)(478600001)(6306002)(53936002)(55016002)(9686003)(186003)(52536014)(81156014)(316002)(446003)(66476007)(8676002)(966005)(2906002)(74316002)(6246003)(99286004)(25786009)(7696005)(71200400001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR07MB5606;H:AM6PR07MB5639.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VP1bsB39/Vt0eRLpxUn1Uh6708HC0E71pymm1+oZbM4GpFT+CYVRKKO/J7NehlSvhCicDbZli3C9WwEriqYdfbmR/cUykbBWBlWoRQiMB6UdIzQTX/F/MSGJc/jVaLpo/26Sob3+hK1XFc6y5q+a5cNp/u+2pdjsc5WkxJkJIPa0/w1T96JBk+8VY/8Z/5Uidsg0AMqajKvI2DoMVqlBrFQOmBq+dUP8LRfvz73qGP693GCNMcUR+Kehc2nA3mwD30XPn6+6ocJLyYbYwLjg7p3rn/Gdih7Ax0oQ50Z/PJ7IdqzvjuCm5eLNnnuFSbWSTMF9AxuYsMlolZ0L5np9+P0UJndtxl+0k+UnH15aFFNS9p8YD+rtLk5JeJ9ejeYQZIV3DjazCcqLPmdtlnqzic/Yv7lYoM7fP/TEhoO6CTY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8bd551f-f74f-4da7-e1d1-08d705367926
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 12:59:41.4109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jan.szewczyk@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB5606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!
I digged up a little further and maybe it's not a problem with MTU itself. =
I checked every entry I get from RTM_GETROUTE netlink message and after tri=
ggering "too big packet" by pinging ipv6address I get exactly the same mess=
ages on 4.12 and 4.18, except that the one with that pinged ipv6address is =
missing on 4.18 at all. What is weird - it's visible when running "ip route=
 get to ipv6address". Do you know why there is a mismatch there?

It's not easy for me to check this behavior on 4.19, because we have a pret=
ty complex system here, but maybe I could try to reproduce it locally on so=
me virtual box and check if it behaves the same.

Thanks for the tip about the testing tools, I'll try to use them.

BR,
Jan Szewczyk

-----Original Message-----
From: David Ahern <dsahern@gmail.com>=20
Sent: Wednesday, July 10, 2019 14:28
To: Jan Szewczyk <jan.szewczyk@ericsson.com>; davem@davemloft.net
Cc: netdev@vger.kernel.org
Subject: Re: Question about linux kernel commit: "net/ipv6: move metrics fr=
om dst to rt6_info"

[ adding netdev so others can chime in ]

On 7/10/19 2:28 AM, Jan Szewczyk wrote:
> Hi guys!
>=20
> We can see different behavior of one of our commands that supposed to=20
> show pmtu information.
>=20
> It's using netlink message RTM_GETROUTE to get the information and in=20
> Linux kernel version 4.12 after sending big packet (and triggering=20
> "packet too big") there is an entry with PMTU and expiration time.
>=20
> In the version 4.18 unfortunately the entry looks different and there=20
> is no PMTU information.

Can you try with 4.19.58 (latest stable release for 4.19)? Perhaps there wa=
s a bugfix that is missing from 4.18.

The kernel has 2 commands under tools/testing/selftests/net -- pmtu.sh and =
icmp_redirect.sh -- that verify exceptions are created and use 'ip ro get' =
to verify the mtu.


>=20
> I can see that in your commit
> https://protect2.fireeye.com/url?k=3D5be21a17-07361dbb-5be25a8c-8667c4af
> e13e-f99413291ecbed59&q=3D1&u=3Dhttps%3A%2F%2Fgithub.com%2Ftorvalds%2Flin=
u
> x%2Fcommit%2Fd4ead6b34b67fd711639324b6465a050bcb197d4,
> these lines disappeared from route.c:
>=20
> =A0
>=20
> =A0=A0=A0=A0 if (rt->rt6i_pmtu)
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 metrics[RTAX_MTU - 1] =3D rt->rt6i_pmtu;
>=20
> =A0
>=20
> I'm very beginner in linux kernel code, can you help me and tell me if=20
> that could cause this different behavior?
>=20
> =A0
>=20
> =A0
>=20
> BR,
>=20
> Jan Szewczyk
>=20

