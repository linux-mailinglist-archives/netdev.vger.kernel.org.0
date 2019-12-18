Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2B125467
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLRVNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:13:25 -0500
Received: from mail-eopbgr00078.outbound.protection.outlook.com ([40.107.0.78]:46563
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfLRVNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 16:13:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWepAXxyLumWAFJXad/BeKwGf7A+ZWfyXA7cKOB5p/7mtWOz33WQccOhOcqJG6WaH5RpBZ4t3PtQsZ4PG4rO1Cf6IFFAePWQTYRaXabXGekAUrSVvTSxKqzP2d4dsiya6GMhnW+jiqMHBrnkbd73GOXoeU6K/sFpCdCN4CphLvMDyETQ3nWlafxNSs9GS2b1k7Co6IlVWPO98DATP07pWB9uF5TWxvtcBSPuSwSe0Iwrg2kOPFhu249IDe0zZ93YUqn1H/bSKb0cU4XBWhBlmsl6AUQbiJA8KYCqDbYxkbAWF9zLe0K/E+2aHhjN3U+W/01OctT5aAGB7zwQN48m4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woktA7+wxHuKQe1ghv4zjRFdbj/QyOeQJxH4w1OAqds=;
 b=RyB6jI3BDvX5J4bs9OLtC7UJA8iI5D8bl3BHMayqBMQ2o0lfVEuLJ3oJ4hi83OCpPniRAI+xa0KP2mnWJCqSj/sxsuDuv5O0OXYPbAe39hV9hRPkiJsVzPDWM8JzKFMWUyjk64lAidxboEn6XerqiNQ1hPzIVuAUfgON83ke/tIo2tbNNGkS5xkzCt5PghSJqTcWBvVTi83utzB85A9X2+or0u0ghZCCSH+6vsiTfkKy18bpeqlhsK0SgM0N7jOxCCzx09PyITWLmPKhPeDeBBokZrukbD+nnYF0M/oqg+vHYk7ccSMN959zgLGSrEiWhyRa0aNrnzjRKxcgCPJXLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woktA7+wxHuKQe1ghv4zjRFdbj/QyOeQJxH4w1OAqds=;
 b=cNGmcKWe8UdmJVBbl5Qb3NlzRU5TOY2RjW+An+6PpqmmI7c5pwCx/IFneCRFe1zF537xIh4Y9+NdiH1X/zPESbMCAXXDygYh8epI7Wj/WPyZRk7xPiVJzjmYMLQfCXWUvGC323T3IokS1sxcOY03PHajQox6rgaVw+Bz0n2EI3w=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3359.eurprd03.prod.outlook.com (52.134.18.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 18 Dec 2019 21:12:41 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 21:12:41 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Thread-Topic: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Thread-Index: AQHVtawqU01I35ZFf0y7jA/tdJ+eDKfALNAAgAAttgCAAAnhAA==
Date:   Wed, 18 Dec 2019 21:12:41 +0000
Message-ID: <B194F90A-7910-45B8-A8C0-6DAAA4ED7829@darbyshire-bryant.me.uk>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
 <20191218095340.7a26e391@cakuba.netronome.com>
 <20191218.123716.1806707418521871245.davem@davemloft.net>
In-Reply-To: <20191218.123716.1806707418521871245.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4039b13b-fb66-433b-391e-08d783ff04ab
x-ms-traffictypediagnostic: VI1PR0302MB3359:
x-microsoft-antispam-prvs: <VI1PR0302MB3359F729801AF9660C0ACCADC9530@VI1PR0302MB3359.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39830400003)(376002)(136003)(366004)(199004)(189003)(71200400001)(2906002)(6916009)(64756008)(2616005)(508600001)(5660300002)(54906003)(186003)(316002)(86362001)(33656002)(81166006)(8676002)(6486002)(66446008)(81156014)(91956017)(6512007)(4326008)(76116006)(6506007)(36756003)(66476007)(66946007)(66616009)(53546011)(8936002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3359;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZmOzb1FuxOpc9+Ifm8tztjUZeqOVVZh47KNEOLBrGF5BHQZh633UmxwY238giYqDnQMrIarQ2lD0KFCiMeJaICCnLRc609rkf3cf5gxKbOgLgODIbADNAirM0t1D43/ZxPnyafg7VE8xe74yUjSna4LA5nFbCWfXc99C7K70uBPok1E7g+lEpZQuUD0Pt3BQ2UIB/zGhOd+JHwZMTBWQf/FmD4KdT3H0jD5KygrgTS9wgq80eqJ1yEOA8al0WkYLL1DddBKFis7bs/jwQi8whwhe+qrFtNd6W7iOVsnE1E0WBokVcjEav+zznh1dYzGCuAD5w79cTR/LhzgNIb2geI3bcNpvcZou6hNJxFFBGXzlmBqA1twVTxnCZmS2OAS+iY1tgpkz5py6CLTXRoo3tTjf+GfYkGBcN46wa43kU0zIhqTtRLX+tDOei68B12p
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed;
        boundary="Apple-Mail=_F45BEB88-67CC-4A64-872D-E904ACE807E5";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 4039b13b-fb66-433b-391e-08d783ff04ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 21:12:41.3434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xCChREub8yiOP7l7sk0yzWEjXZNwibN5IUT6zlGWD57rT4pamPw/Yp20nqGCyXQtzboAv+JIqtMfO1O3pFcdmr3Stpon8u7UQVDvg9rC3FM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_F45BEB88-67CC-4A64-872D-E904ACE807E5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 18 Dec 2019, at 20:37, David Miller <davem@davemloft.net> wrote:
>=20
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Wed, 18 Dec 2019 09:53:40 -0800
>=20
>> On Wed, 18 Dec 2019 14:05:13 +0000, Kevin 'ldir' Darbyshire-Bryant
>> wrote:
>>> Turns out tin_quantum_prio isn't used anymore and is a leftover from =
a
>>> previous implementation of diffserv tins.  Since the variable isn't =
used
>>> in any calculations it can be eliminated.
>>>=20
>>> Drop variable and places where it was set.  Rename remaining =
variable
>>> and consolidate naming of intermediate variables that set it.
>>>=20
>>> Signed-off-by: Kevin Darbyshire-Bryant =
<ldir@darbyshire-bryant.me.uk>
>>=20
>> Checkpatch sayeth:
>>=20
>> WARNING: Missing Signed-off-by: line by nominal patch author 'Kevin =
'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>'
>=20
> Which is kinda rediculous wouldn't you say? :-)
>=20
> The warning stops to be useful if it's going to be applied in =
situations
> like this where merely a nickname 'ldir' is added to the middle of the
> person's formal name.
>=20
> I would never push back on a patch on these grounds, it just wastes =
time.

Hi David,

Thanks for that.  It has prompted confusion/investigation at my end to =
work
why exchange is inserting the alias into the from field though!  Think =
I=E2=80=99ve
worked that out and will try plan B on the next patch submission.

:-)

Kevin

--Apple-Mail=_F45BEB88-67CC-4A64-872D-E904ACE807E5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAl36lkYACgkQs6I4m53i
M0q9Vw//VEbWd/qOhawGWdcVM8y+GNAyPfkbmrMemkURZzf75xFGz13zMma3AJ9A
pGAzadrsIe4LBNQRzvUl9Rhf0KMO0eDy3mm1iOsJnF6LTdpcX1M/3stOf7+DQdGj
kg7q+GufJ6WhsdVpVIuUiexHgw0XND1cPkIntbiIB7SQe4j7ZPTJhSRlGMcXCWw6
QUtRlHdlHqbSFQRrRs9R/P18NhcyxbcoNnczEB9sBsIMm5oq2NeN+W4J/KH2i0d+
T/XWMrh+R5egmvJrBCIKSJiZyXWbFrZg4VPe+DJaPgSCcXlLwfp+ZJIKh/PWWeGU
fM0K3DO+cChahDYq93aLtN3DhT7V1NjnG4LD5XLZIEJq2eB2Lzwjvqy3TbJxDpGj
Xmsnfe5E+jTJzYGLeloyztej/5Jq4G7XhkEDiv2iEA/jgfXpweTsajgh9b2t6wp3
R88w4QEUt3YAITb0zBXk7fwlW8VLaAQomP6cdlpjjCMjrO41d9S74an3+5BfowsD
hreTfGZBe84iF2UmXW9g+hJnDNrCfEcx2xzMdG14uKc/ZjgFvPGGIk4hl1TsHeuP
JJtFDmgOJmsDhIfyXSlk5Jb14+pQOVu1XDjUU61pguPWVLjCy2hl0NR5HLRgjMHT
u8Z4m6ltf3aqt6BXubSAnObG9rD5ojDsudBSSc+KD5J3xtEbT54=
=50zI
-----END PGP SIGNATURE-----

--Apple-Mail=_F45BEB88-67CC-4A64-872D-E904ACE807E5--
