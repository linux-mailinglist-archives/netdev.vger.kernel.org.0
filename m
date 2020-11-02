Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D52A2C30
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgKBN5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:57:01 -0500
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:20613
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbgKBN47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:56:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIJ+tlo+N6DH2qAfzid5c9PRYUJPpKzxP5NCm4/3IDyzawTvJNFz2LDM6rM3xF1/slSSNYtr2h1mY62+rcoyNDPFFsM4DWHJ1h6xieRUNF2qj0KsjvQ6n3nqCIgvML4GOJTVU/0PuW8x6IBjJ4uy/G9MpTioabmS5ABSQMoYuGYCKRy475ozqgddRxkuRXqJpuhVjx9+Jp5WVAGSITbh80qrVRTVtMzkABkXb0A0rlCmfElq83orylbJi3xXYRfSuJq8fJGaemvmkR545fdP63zuWxKTQslglHFFAbM81oPbWWv2yS2IUJjjzLV52WSW9FJQ31FL5FUq5PYHGhSUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmTCVgWonsUFajPXi/IS7Ow9WBBAs0KzsXpMjP4Usmw=;
 b=hprqMIxhXKFeodrrulJeyLd/qQSByoQqb8CTLH8LLtl7Urt9AZYGPt9KLAeG9E4ehyG7r7mPzPOh8fxvfZV+4Ihxypbj6xoR27cstipEP+TtCai1PtRnzuCO0xxrKAcBadd4l416KgdI/VEajjPVDHWj45fBy0DR54YkTp1cxbRN1XVuKJTocQgyRipAbugmXhHvgh8DyV8sCT4hCNnS4tH17ILtdZGBfysys9slZWJAsqcbjTJaCk6kPvuYQl4+LDQVQdYbaIw799gUrcyU9ceIFlxPRaIkgJa/WtMfJ8h0uhnfgvyFA8kZUnWmktTig/Rx5IVQP2vDkdVAq8o+TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmTCVgWonsUFajPXi/IS7Ow9WBBAs0KzsXpMjP4Usmw=;
 b=XGqRuuOORbf6cA6dW3XLTnk6Tetr+HMJUF+djdrFWnHakh2eXCySfOBf3dcBS4v1Zrbk9S70Imq6hxfEyv/+3YIgZff78HHYIYUK667/vIjrQxDZfuTWpYUFjP5nmolW9UoRDs16OfmTjsUoVwHyayjUdacotrT8HdRlGlGNZnw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5134.eurprd04.prod.outlook.com (2603:10a6:803:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 13:56:55 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 13:56:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pujin Shi <shipujin.t@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: mscc: fix missing brace warning for old
 compilers
Thread-Topic: [PATCH] net: ethernet: mscc: fix missing brace warning for old
 compilers
Thread-Index: AQHWsR3tdRvpxbUwu0avLaQhXZnXo6m03c4A
Date:   Mon, 2 Nov 2020 13:56:55 +0000
Message-ID: <20201102135654.gs2fa7q2y3i3sc5k@skbuf>
References: <20201102134136.2565-1-shipujin.t@gmail.com>
In-Reply-To: <20201102134136.2565-1-shipujin.t@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: de83583e-e492-4150-8339-08d87f37287d
x-ms-traffictypediagnostic: VI1PR04MB5134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5134FF6570809C9F37CA3067E0100@VI1PR04MB5134.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JphvdDkq0mNOU0ZUN73eqqX3bvdgbi7h/63Ah6X8SeupddEMDHVDCTCYTcaA5oKtCrRzqmzBMqNJb29bgPDVVtJ/KAKelJyK6pML78qczpt/Nzv1V4XwVhC3hiHHS6/f/Q63MYc1vaK+xwYluqYI6hpFPSwioE5VBZIl7OUDFu1hhnqBW5fuO8V2xGS9bL5mPyZ00iHRJ6ohnc1ndEjx5RpG8mDEyhfIXFYB+DGyuoKKLS1/52bd7pnJwg1TOBIkyYiDhHElVAZ2OkDjfAWKb41TwD6a3p1vYwIifreh4EKWWMvmPscEv2Tq+VxHUEhuFZT83LTIFgQef5p7m84ZCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(44832011)(71200400001)(33716001)(6486002)(316002)(8936002)(186003)(83380400001)(86362001)(8676002)(6506007)(1076003)(66946007)(5660300002)(26005)(66476007)(4326008)(54906003)(9686003)(6512007)(6916009)(76116006)(91956017)(2906002)(66446008)(64756008)(66556008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jYmEZnntxU+HkAa6XI2+JCcFPY++Q+++NlEfC20mJKR5EXBFcdkcuiy3LEZi0MDT8N71NkKjgJU3FrZ2u2/EUN48Ijyr9UQER2QBQDoC2mvMjORyokt0oE8XalFEcibFGTwm0brGp+WCHYBXS1moPpECHjvE9wakkEqNn28Pm8GUPY43q4nGxPBAezsfLktXumm79mLnpLt4659NOEpCYBQaR30byl5+px1b/7eJdqjS/Bq2UEDQ4RD5sfv13GbUqrwOp5bXGRJocYzc8lecX1vxq6eCwvE+LwtTrale5fTC/+YUhf8p1uR+SMMNkTv9A7nmzpklIHhMunhYaw8vxXKtM5S1NpxsKXW3nOztyRuXZrcmzqF79lqy4GllCLcBW8YxdiyRyRyRawWOeWzysaiDLn1JPGvXpzs9UROBX9KXonwwZi7nzTY/SHBFgt10/D03boRIBgZFqJeoAQoGQDJkNUG/q4QsjXd9iVfFeWZt/Uc7qVcXuRq6In9WxFaJpSK9CCdmv9H4L8EZZJK/lPItP+OXNgD+22ebpt0EdRP6chiIa5+NABpBJN+ehFGRiv5vHZTA9hNQFHermBy/0A6Tu0mm0EO1gAeyg4G5sETX9NPwHfgas/znEfvk2p8JJVO1aosFEFTqp3m7tyW52w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8044285B2D066D48AD6D2C367E0A8550@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de83583e-e492-4150-8339-08d87f37287d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 13:56:55.1348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s6xURzdMFavawxoN5ZQrcknQ3v4sP7/5nG/KH1k/6W2bHkkPXfMZB8XMBRrsclO7uoM4UViSSU1PSRtCFYHqLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 09:41:36PM +0800, Pujin Shi wrote:
> For older versions of gcc, the array =3D {0}; will cause warnings:
>=20
> drivers/net/ethernet/mscc/ocelot_vcap.c: In function 'is1_entry_set':
> drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: missing braces a=
round initializer [-Wmissing-braces]
>     struct ocelot_vcap_u16 etype =3D {0};
>            ^
> drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: (near initializa=
tion for 'etype.value') [-Wmissing-braces]
>=20
> 1 warnings generated
>=20
> Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan=
 actions to VCAP IS1")
> Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethern=
et/mscc/ocelot_vcap.c
> index d8c778ee6f1b..b96eab4583e7 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> @@ -752,7 +752,7 @@ static void is1_entry_set(struct ocelot *ocelot, int =
ix,
>  					     dport);
>  		} else {
>  			/* IPv4 "other" frame */
> -			struct ocelot_vcap_u16 etype =3D {0};
> +			struct ocelot_vcap_u16 etype =3D {};
> =20
>  			/* Overloaded field */
>  			etype.value[0] =3D proto.value[0];
> --=20
> 2.18.1
>=20

Sorry, I don't understand what the problem is, or why your patch fixes
it. What version of gcc are you testing with?=
