Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3791304AA5
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbhAZFA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:00:56 -0500
Received: from mail-vi1eur05on2133.outbound.protection.outlook.com ([40.107.21.133]:29442
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728211AbhAYMm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:42:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqDSyihJWNXAACt5N+mKNdtGdy/Key1G8jVVfnJNNtN+Jftr9hTvwrk2SPkxzS9qFW/MVPfv4mAXx8b2xp9U1gUQVgCV8cVONY7z5J/AG6mTykk5CdIyugv2AOnRfCz5IL03ATIbYWjM+a9rvZcX59S4fgPeT0JQ4CvVZxIWpQRu7uWTppimPcEISlCGhGXdQStZ3ysfyjc1oEdQwICpmYWraj84u3DbKIXfF3z4nO0HPiq59KUaI+g134ku4mu5fjsRnGvAQ3BMzXkX1xa1ag/BzUnKeE6bmb9mOW1pEALM0jlzYFqwelYgf74FhI0kwCkrqMN6BPmgksdroFea/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekqe7o0Xxe6QNbggmMcM12cnqvsnnb8R2+Otos5x/pw=;
 b=J6X+Edc9tQUdzPqoitXS3YsHO1LfqnERTx00cTKiH2XnBYB0QyST28RsABUoFrm9Lqvg40I4WwgSHeUrtlc+pc61gUG1Q1U2U2BFzoakRbEHPGYoruCtMs0pTmqQGj6lwoX4q9MejcpjXXUGbAY5VzJqT+34D1rNjNl/Y9cveS2s3ScnefgoNVu9PxrCVdKb1Lra0sMmSTnNmLYn8dzG1unMPPUhGc1q6lo77CGeqZrvH01vncYlGMIJSk3bCtUt4YQEMt7P8mlnm8uWOD/8Xpvj3dqHbskuV72H6T61tgdIxy/TwTaFDYgOAHIuCPD7HwU8MENPGUgGHnn13/wpYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekqe7o0Xxe6QNbggmMcM12cnqvsnnb8R2+Otos5x/pw=;
 b=ZJHAYP7Rxsg6NFKH6RT6/0LgHsl3O9TlRFArcjZI3L0KGe4weV3nrfbSfX3Rj4NPLJZ8k+jGJAEkXZ9u60kDP/jI5W4oMa9gwC5ZlH1ei0bKFuducJKzC4rouYXVKvBDbMq78FGHkeAEjggXrkBUaqhQod0AbBucayLmjavlNpE=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1106.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:270::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 12:24:27 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 12:24:27 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Thread-Topic: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Thread-Index: AQHW7+i5SANyTFamkUKbFKKw5ahdBKoyAC0AgABXy4CABe7wAIAAAiAa
Date:   Mon, 25 Jan 2021 12:24:27 +0000
Message-ID: <AM0P190MB07387522928B6730DBE1BB77E4BD0@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>
 <20210121122152.GA2647590@shredder.lan>
 <20210121093605.49ba26ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>,<20210125121234.GJ3565223@nanopsycho.orion>
In-Reply-To: <20210125121234.GJ3565223@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [213.174.16.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fde272a0-969b-4d79-3939-08d8c12c28b4
x-ms-traffictypediagnostic: AM9P190MB1106:
x-microsoft-antispam-prvs: <AM9P190MB110689C14CCF20D342DB01F4E4BD0@AM9P190MB1106.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NF3h2Ec3hTA7vPLsHGdO0LgkLWQDX0KaHe/fRHfUWkGhiWUdOfcTPYLaFI9+kkGgKLn7eCxbCDe/f6UyrxvwjN5PjRwL8WTrbLnko5HVKBa9EZhtJiRf/fBZBYRXZwqiK6+WshrtIbKme5/hAzhRBpG0r0BvQeQHJWglflMxqeWCd0BLQ7lIzGgvtMHVymD7LhkgoIWSrrVWiynyIKwaca9QRrq2i9h0cymcmeYaLSB4L80EIzo1hOSyAF7NRzZKeOE+MRxbTzX3trCcjTJnTPuF7djaqsk0Mr442mo+H9BlUgrXJ7hzKsg+FVwsuxHpQHblnB6MH2j+1YIHXbOJn5rdTWKzAX12ylV4MTfOgJ7YpIjPo/ey8guj6M7ctfCZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(346002)(39830400003)(71200400001)(52536014)(64756008)(6506007)(66476007)(7696005)(26005)(186003)(44832011)(110136005)(4326008)(54906003)(316002)(8936002)(5660300002)(33656002)(55016002)(478600001)(86362001)(2906002)(83380400001)(76116006)(8676002)(66946007)(66446008)(66556008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?hNjorpjbZOa8kCTtIEqu2u0c+aYJx20yCc6hi1AfgaIawf9bLWcdiynse/?=
 =?iso-8859-1?Q?kzocWqZxpz5nYfZREpjNNNHS9AixhYJGInWv+fNJaCCITkkDhLUAdcTPGs?=
 =?iso-8859-1?Q?4btrYqSLJkjftVRPLNVehKS6ZuSZfWhNn/lp0owcC5Zl7LoQSrKFzitpUJ?=
 =?iso-8859-1?Q?dIo8g0QVBwI4nLmBxey5oTxN/EpUOvVMM4q1imkMBsKhTEJ+fOnw5luyo0?=
 =?iso-8859-1?Q?bPH4GfEvqA1LXqEzVqUQVBSEUx6yRGa06rvWScnuYEnRmFEteMZYC2rhXl?=
 =?iso-8859-1?Q?VXO6g+9GrPBGEtoH2WhB4hba8Ml1GCYdWVpPp6WOzByL7R11pUBvGeKLCd?=
 =?iso-8859-1?Q?nS74d0PtJ9E8fVv6f4W+e2C4kyvIPanYvUSLPkraYKv8VJpKeQS8eIRqvX?=
 =?iso-8859-1?Q?lSZOhWtUd7oBmSsY9D0wSYO+EzUD7wJA9NWH0Bc4KCJNh0pPO+YgvEOce+?=
 =?iso-8859-1?Q?SgiY9noImLSwgWoVvkTX37JYAeR9N2q+1y7lzst3JH5gyNTIjjQO7BpsNc?=
 =?iso-8859-1?Q?eTx2Fv6wXY1fvtA+mJ9EoiokenBE1pfKWfFyDivASQ3T3okLlMGFvhRkOP?=
 =?iso-8859-1?Q?qvFMBCVsBCiKoPvXZTuggH6e2/YTGuneJ5Cf9sG46ajn+x5ilK9x84wGhI?=
 =?iso-8859-1?Q?MxkcAO6je6GR/4jEF39rwea8q02fJVbOFc8mTK5j4kbKjipB510ICouTdN?=
 =?iso-8859-1?Q?4VRoB9+aK+lpE6N2R1NKcH2OpkeYA373dWTzmyae73pOdsAk4AmkIplnBF?=
 =?iso-8859-1?Q?25feRSxTSekdfjJYEI6s/3lz7Sk8XbTjlQaOtSz9d+VM5EfgfAfjysjb4a?=
 =?iso-8859-1?Q?UvfrMD0MXgg0b7ae/xiNVwpWgmYj9sMcf75rsjwYGIcAAzVnD60YQnT3dd?=
 =?iso-8859-1?Q?wOFm1RbGKGUG0d64nqEconW7zq40hBAEOR3WEsmtmS4RSbcV/3CnFhQzMK?=
 =?iso-8859-1?Q?p+p09d7aEBc8fYLis/J9PwvgzxjcQxxc/o377UzQs/zvi6TfSJrw5YdG8t?=
 =?iso-8859-1?Q?rGFvYmuEqI7Aum1P8u4GYOchC/U6oaB5mjW6bHjlQS03S5JeSLcFMvUmav?=
 =?iso-8859-1?Q?8dM4lc+GgVu6TT+3g/Br/lE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fde272a0-969b-4d79-3939-08d8c12c28b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 12:24:27.7949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sD9E/ffajm9uxDqPWElZVuzNJo0AUZGFELn179Gw5YvJWrsp1LkSr4Yms+qywnuPXg+jbFKsriYPyuvmFuS2NFNMnkr1wkCiwKr5HRNdYuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 21, 2021 at 06:36:05PM CET, kuba@kernel.org wrote:=0A=
>On Thu, 21 Jan 2021 14:21:52 +0200 Ido Schimmel wrote:=0A=
>> On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:=0A=
>> > Add new trap action HARD_DROP, which can be used by the=0A=
>> > drivers to register traps, where it's impossible to get=0A=
>> > packet reported to the devlink subsystem by the device=0A=
>> > driver, because it's impossible to retrieve dropped packet=0A=
>> > from the device itself.=0A=
>> > In order to use this action, driver must also register=0A=
>> > additional devlink operation - callback that is used=0A=
>> > to retrieve number of packets that have been dropped by=0A=
>> > the device.=A0 =0A=
>> =0A=
>> Are these global statistics about number of packets the hardware dropped=
=0A=
>> for a specific reason or are these per-port statistics?=0A=
>> =0A=
>> It's a creative use of devlink-trap interface, but I think it makes=0A=
>> sense. Better to re-use an existing interface than creating yet another=
=0A=
>> one.=0A=
>=0A=
>Not sure if I agree, if we can't trap why is it a trap?=0A=
>It's just a counter.=0A=
=0A=
>+1=0A=
Device might be unable to trap only the 'DROP' packets, and this informatio=
n should be transparent for the user.=0A=
=0A=
I agree on the statement, that new action might be an overhead.=0A=
I could continue on with the solution Ido Schimmel proposed: since no new a=
ction would be needed and no UAPI changes are required, i could simply do t=
he dropped statistics (additional field) output added upon trap stats queir=
ing.=0A=
(In case if driver registerd callback, of course; and do so only for DROP a=
ctions)=
