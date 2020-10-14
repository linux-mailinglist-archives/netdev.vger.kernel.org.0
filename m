Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5B628DC24
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgJNI4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:56:37 -0400
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:9026
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbgJNI4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 04:56:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoiJbd4UqcpgDmgOf34ZBkn2sEj4WJy/6x8arpMR6fA1ELr2o5oAL1nDPd5pe1+F1auo40bLy2camEqaCYO4iyVUWosrmk0TnCHhFuvYXu0PskzNe/Fpc/WXyhp+2V2R4nPRgtxgMyVmWy1UNjNLKZf4cCNn7yAYVqA4rxQY9QQxEzSLdPuCPXW3p/0ejA4yMI23RiRHocAQqi65qhownJkwBKOl7bc9OhAWoaG6XbDBRqCWp5SPB5ydSniTACDYTQ+QH7NBtYXAEyIGX/UvikotrfU4K2W8KqNsfz/PTLZ9V3B3Sq+SR0TwLzonyfAIIWzUGQESARkbpW4Ca0kV4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEl+iDVHesTQPxh2N5eO6joQU2uckQqQP1CFfckvA+s=;
 b=hF1ELhrwMexLVbAbpss0JnT0t3SoBacRgVjZ8K+zTkF7oyH4TE1y43+cX1s/ptHz38Nb43AUkJNIWMJwKWWI5AT7uUz9JxaYTk4fTany9F/3zwgN0Q2KuJENt0u79N9U4ESZRWWPNVfyBbJExA9ETPFNqpTYX9/MAsW2IfDtZy4wieOCMSYZa1zs1TEOYfMGAT5SBqHvX0bi3XyYzt/u42PhK/axbWzb1zHpJKxpKbBHsQiyFIJJobynPUOGDMFsFaplNn1HGrcwvUxEVbD6gjfCHNRVgyUHHZms2FHoQO9/r58GuY2gXoQZ3uOQ52YIhTc8p2fG5qY8hRa6GOshmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEl+iDVHesTQPxh2N5eO6joQU2uckQqQP1CFfckvA+s=;
 b=YxOi7voXylbWHVniYRZCKjSAa5ksU80t9B1XricNzB4o/0DZo2/YNnCLVFZJF1ypVIIV0B1J3ABy9xInpc4gMv0vuLoh7wtVKqZRsrsX5MVXmPE8nClH5waatJuOvodkkTruEsB0rnxpgV2eGFOKN0T0/bR67g7THtw6W44Oxvg=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 14 Oct
 2020 08:56:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Wed, 14 Oct 2020
 08:56:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mscc: ocelot: Allow using without PCI on t1040 SoC
Thread-Topic: [PATCH] net: mscc: ocelot: Allow using without PCI on t1040 SoC
Thread-Index: AQHWofC7CFYONVQxMEGi2xuAhhgtuamWy/EA
Date:   Wed, 14 Oct 2020 08:56:33 +0000
Message-ID: <20201014085632.7iess2m764uojxjo@skbuf>
References: <20201014061105.26655-1-fido_max@inbox.ru>
In-Reply-To: <20201014061105.26655-1-fido_max@inbox.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: inbox.ru; dkim=none (message not signed)
 header.d=none;inbox.ru; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b22493a9-ec03-4dae-4a25-08d8701f0d34
x-ms-traffictypediagnostic: VI1PR04MB5696:
x-microsoft-antispam-prvs: <VI1PR04MB5696C165B297948EC09EC731E0050@VI1PR04MB5696.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VFd8zQBSAwNhACi7jJEsG/gY7Feo7Gm4t6MF0yKhcEcLCfQiS8yJA57LmxtjoVBM5XKWasQZefByCgVJsTT3OOkiZN2aAGYLL8rbfgiFeVGKp4iM7Y47vL5attYgE2Ve+XyotkJArFf/cDTkBiVjS+u6hQmO/SjgadMj6z6acRqlgyaYZ5O7fdCUcF0qLOwIRcoSV79y0rBbZ/basWGLjwRnVfOIHLkhCxUBSZ/zOhsjb6i62a4wNS8BqsvQa5PsDkoPkDuXBAFs/aEIOw6kIO/DYOd6Ex4TD6G4w9HOHpGfI8aHflZX7mqEIDgu0ZZseZLWCdZnSAvGYMPrq0kMVBukHiHI0fNb7rXO+5aH+Oww3RP3BceZ/6xWpVVtglie3PfH/5tUvodt5Drl4g10+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(316002)(4744005)(4326008)(5660300002)(966005)(83080400001)(33716001)(86362001)(71200400001)(1076003)(478600001)(44832011)(91956017)(6916009)(64756008)(66476007)(66946007)(66556008)(26005)(76116006)(9686003)(6486002)(66446008)(186003)(6512007)(8676002)(6506007)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jWoje3G7XOSbEZf1AZdAL7ulw7yhFPyOLqu+jt5d261Fftb68Mgr+IegY+WVFUbIMpLb/Wve+icRW2cSdjbv6KDgG5bQ/w4N2pLGxEdm0u3g32vI+fgmgssITfu6yccNaNM/X+xH6g1HveJp942OYG6kFNTiVRm4kASaFkCd/MXylQeuO8bg2vmo6xn0kMj6sw5KLaWKDOZOFOzWr9mIHWinZLGGF00t9h9s8v1pkb92v8Qgmtv9MUNm30aA4K9JPuTx9RVirriv4JEc42J75jWJ777qy9zrbPfl+HdGMt/uoD7jXoqJ0qqSOipvgmLPWR5OYz2woeaNhQwBPmtDjLXIrTIFAS0/td1X+C3rxF5N3fylQ63rOrK4fbbMu6IkU29EWLzxbaE0kUdUTMBZ99u0QhVThnKFebwZg+t0/2WiSX91/DCGk5X36Rwjhqu1WnPi0GtfOf5yfexnBi8Pb74iz3uLVEcwaWRatvHbbBrW3zEETYfvTlmBJAPJjoiQ1UhbHPkC2T7xUocCl6lLpa2MeOOndTSQRp6Xss2My+MKaxtBaozIcD28/1z3hpIabz4c94wrwfnK2AQcvsGcudFykGE+f+F6pOqjWlmL+QUlzD70606AiIoLNgh1I3e/77HrpO9J+T7pU5jXk0c2ZA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B387F20C60A22A4FB0A65A7738B548ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22493a9-ec03-4dae-4a25-08d8701f0d34
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 08:56:33.8943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u4oAYctIdUvFPsKA3k8QKfM5XMwn4XmpgyA1lcqpH1y4qodG90NhZusY5I1jZyA7/EjEDD+k8XwfO44YUQ+k8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

On Wed, Oct 14, 2020 at 09:11:05AM +0300, Maxim Kochetkov wrote:
> There is no need to select FSL_ENETC_MDIO on t1040 SoC (ppc).
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---

Please submit your changes after you've used net-next for a while.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/dr=
ivers/net/dsa/ocelot/Kconfig=
