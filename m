Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B4031CA37
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhBPLzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:55:21 -0500
Received: from mail-eopbgr1400092.outbound.protection.outlook.com ([40.107.140.92]:7209
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230232AbhBPLyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 06:54:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5DVSOSnGaNisL1ggM9n3xDYUajHGvGVmmRN8KZLR1Nnzf3ON+ocH9X5H/ib9RNHapH7hBn1JSMkQEW0gypHDjeDShQKSLZOlQjuSJXy7FwtfeYgkW5S6awc9yyfqEuvVX0e7dH/g3XAcTurNJRFElE1ZLTPwDkWHOlaA1iDD9uGaUkQXdzoiCQiRxMEyN7CwEhFhpvzQEEXfpn+TjUUj0eZUxqM49IXfaxEUVQEtdiGENO//FJDonWZ8DCSm0HxIYZoFHPLTQGnvk1Rb0O3c1lQ2eP8IBh4ebtTJbKGyuw9nEIOCbo/9aa3pa8V0kjMCZJRb4JLW9zA/+7XnKtRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlvVRG3EIDHM4+TS1zlkcCU5hRH4BI+krQMuryGixs0=;
 b=VV0ARyF6vo4fLzGglje0uz7x4YMifadoRjZS0piQaFadZyKrcNqQmzeq915JklJXsAiuZ/sTHF5biUvxT++IOloqd0yDNcBJ4up3t0QjHR9+kT76kldvt12xtofj1JwQNqq4rwq2eMvxXdryrBsefoPyzk6jGrywPUA/jwhwraMk20DT0EbIodKNTEzBbsavmYnrXzz9A8HHeZT5kr8aW7l2cUmH8OKzCm72LPhReopvIbyXYvTowoKT9k3+6ijD9Px2baIxXHbZDm8TKmS+9MzRGH8kvCRibReQhmHeypbiWfH042xyimXUf8EejLPs7oBYBc0Opt+X3cYHL0iUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlvVRG3EIDHM4+TS1zlkcCU5hRH4BI+krQMuryGixs0=;
 b=Q5Na97x6/Q809DpJt7XSzoimWE+dQt1NcJCt4uU9OCQJ12GyutRqPile9y6aPBDZByx1cq9PZ9S49OsbKEmJ17pB83WwmUGnmKUn3Z6hwBmamOU4qt54lojiP3UTchxS1KJNEfx8Qi6hD5uE+blEvd2dV/D2+z4bk8g/wuTVxMs=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB3646.jpnprd01.prod.outlook.com (2603:1096:404:cc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Tue, 16 Feb
 2021 11:53:56 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::cb4:9680:bb26:8f3f]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::cb4:9680:bb26:8f3f%4]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 11:53:56 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM <linux-arm-kernel@lists.infradead.org>
CC:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Topic: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Index: AQHXBAh+B+TipWzLUEKtUb6Ddgfgl6paq7qw
Date:   Tue, 16 Feb 2021 11:53:56 +0000
Message-ID: <TY2PR01MB3692F75AF6192AB0B082B493D8879@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210216130449.3d1f0338@canb.auug.org.au>
In-Reply-To: <20210216130449.3d1f0338@canb.auug.org.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0fe8b0d4-84bc-4c86-9a83-08d8d2718a0f
x-ms-traffictypediagnostic: TYAPR01MB3646:
x-microsoft-antispam-prvs: <TYAPR01MB3646A9EA88B123A765068114D8879@TYAPR01MB3646.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /InzbkvNXqoe/qB4o+HWfr4bQjNB0AO+S5ApwWMjBxjWoSaMn2RTTNv3EzRWKdSwJxEEjmYZT4b8+BfX0lli+yLIM9CotCtnBOTGJ0yvUIu7JsNAGlCewdXkjVlm09WeySqwlMntOBaKFIABmZNC27Uqf3pxkH5GwGBxrH0Nb74TpbPNioyrOH2V0B2HQxYKfP3jiQ/axU+8LzPUydkH63UGs4qrTVy2EBamjGHXJQlA4fHzIPYBisB+y8iefFORwU+kakuQTZuhMbTC6mo0lmnpsh3QbhDuUGF94r105G7yP86T2IuUEzYeZ9+tLsNNaDhNtcLIYRSJg9rLqFpXMOvn9NEW4QP1BbeiORVWO9rB1ctQRwG7EXz2X+VF1owqxB+tRT0un8Y9spnStRYC516e3BjHtksLq3gM+EumJB02C3DRMUSM1KYR5ivpHLoXcA9F+2LC8bq5htqW8L2aoxeBZcPPAsCtvebl4NJju3/VwTAVh6LgDpBkBjGobOgHuOTN3+RjV8HXIvhvQrAxUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(33656002)(110136005)(54906003)(4744005)(8676002)(7416002)(5660300002)(8936002)(478600001)(83380400001)(66946007)(66556008)(52536014)(64756008)(4326008)(316002)(86362001)(9686003)(2906002)(55016002)(6506007)(76116006)(186003)(66476007)(71200400001)(55236004)(26005)(7696005)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ubgb3E0k92zAyMI+BcIGsXO/Mf8kOqgkUPNrQlwX4FoG1d5i0+CxqOzVlUxS?=
 =?us-ascii?Q?AXBU2hUUOdfLL5QcdsyU9xe4FtQdvz0vzerRZUEIWeTPLnt7BLN4g1pO4fhD?=
 =?us-ascii?Q?Sj7mtV1YMkRTNmIHolmazpikv7hddOxR0PPrLAhK+txhCHU8uBFF77+zN2PK?=
 =?us-ascii?Q?yUur2+DR36n5LVBWP+rrOV6DtXLdPBTq+uRJdWzaaDjjW2XDz0wfHwbcBPxX?=
 =?us-ascii?Q?cKSX3Js1EhUlXo8Od8M90Or0OV4oKzrdvy9CjdGjd08jE00Bxiaf6U0Ecd4J?=
 =?us-ascii?Q?9WLUYTGTliFigbh6ANI3p2C8enKWtSB08OTst8vwFV9Gm8MSBtGyirrXb62n?=
 =?us-ascii?Q?5F/GjoFPxNMO44a9JlgspiZ+jlBnOCOEzsTe04Wy0P9JvsOWKxAnbd9AxSh4?=
 =?us-ascii?Q?DXlnEyRrxzXFG+jnvLuMrNAARWkSSJ0gWxCVfLbgg8imwl/hNwXTo6xyzYVw?=
 =?us-ascii?Q?QzpVI3DRk5ZVTVUFNVG6yH2guGnI8eEWfE5icS9KkGlAXyY2oRLjOdLBYlOE?=
 =?us-ascii?Q?lW6H8hjcnBLXL9VqU32mV8VH2Oa6sPA5f6PSTf1Vmf3fYWdthdAWQyKPgdLl?=
 =?us-ascii?Q?ge55ir/W+9swHUt2iE6B8jgfUmbo1J/pwb62Hj9LS5eZmWgDu2y0X7qdA7GG?=
 =?us-ascii?Q?bUIOs+CmfVAeB6Bk4WX7axz4qioyonxRbovtkbdOzlpL6FqdgXHPOobzuFnK?=
 =?us-ascii?Q?WqCz6ay91ncP7P43IrHZ8iLWAG7hcs9uTPKfuIMR0oTLmxUF7edNfm1niLAw?=
 =?us-ascii?Q?JlZzDwPOg46H6QNyBUMOEvqE9B6IId4oIMpY4QpdcVA3ZdAvw4kk8I7FwliE?=
 =?us-ascii?Q?h/iPGrApAh7QDepSfyUSKQ5S8VUpi8Lbhpk66QXueSgmQXeF0bPxFbr1h3OR?=
 =?us-ascii?Q?ugu0TiT2ly7MvyAMOEN69pOzG++cx6a0NXjeG8Sv7M8ZF2KzPGuZ2hyb2Kf7?=
 =?us-ascii?Q?qYsqIUThqtjolZpBKathfW0qybI5Z6Y5SvL33ZYUw51/xYbFMrH5lhUwYXtn?=
 =?us-ascii?Q?/kaGm7GpNBlYiXvcekS4lCaKUbI5N1iyKdctonAd11FMWiHyhjX2qznuBhfX?=
 =?us-ascii?Q?lt6StNzy7i3UPKNCaIzigUMkwcZLx5gBucdqBhlUdRWRWZIwwQQa0YkXrx67?=
 =?us-ascii?Q?VvxLMRqFyC51PyTbY3GhrhZ4V593PEGWHDvxyLb3mwiTgegY6BgAr3pq1l9Y?=
 =?us-ascii?Q?0VWeYohFo2o1jLxj/EO+gkd3I9OSB+Gj4V0DRqHnOTQLIUBmDu0XK43ewJkg?=
 =?us-ascii?Q?M6WA2KSMB+kXPFKRnREb6YL7SAf9Jl7svxcE30zYurWlPzDOp3gw48pxOV86?=
 =?us-ascii?Q?sdga4z715VOvw4dRXOxg6FQc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe8b0d4-84bc-4c86-9a83-08d8d2718a0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 11:53:56.1671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x27ZjeF/WSlVzuIg+FGjynCrayEhKudBOO/dgDn2HIXTxTuSF2tun0Tsc8I6JO0wI6oQ7OwaVxOhAOew79ZtyPHE+T9hoyJ6805RzVQhIfvggsedVDXtlixzCxpMVK44
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3646
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> From: Stephen Rothwell, Sent: Tuesday, February 16, 2021 11:05 AM
<snip>
> diff --cc arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> index 2407b2d89c1e,48fa8776e36f..000000000000
> --- a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> +++ b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> @@@ -42,11 -42,20 +42,29 @@@
>   	clock-names =3D "apb_pclk";
>   };
>=20
>  +&wdt {
>  +	status =3D "okay";
>  +	clocks =3D <&wdt_clk>;
>  +};
>  +
>  +&gpio {
>  +	status =3D "okay";
> ++};`

This ` causes the following build error on the next-20210216.

  DTC     arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dtb
Error: arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts:52.3-4 syntax error
FATAL ERROR: Unable to parse input tree
scripts/Makefile.lib:336: recipe for target 'arch/arm64/boot/dts/toshiba/tm=
pv7708-rm-mbrc.dtb' failed
make[2]: *** [arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dtb] Error 1
scripts/Makefile.build:530: recipe for target 'arch/arm64/boot/dts/toshiba'=
 failed

Best regards,
Yoshihiro Shimoda

