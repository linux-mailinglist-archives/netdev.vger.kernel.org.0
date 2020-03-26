Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C91E193A0E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCZH7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:59:37 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:19662
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgCZH7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 03:59:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gyu6R4s9+gOGsDEiSKgW1oKP4h1oQbveaMgn9K5FMpFbnQrO2PdDCp4M7fUwDz4dwlSezSN23875xofvRFBR7yKgHrUzGI5UDTLxNNIg+RNZxJ3U2Whe3HhfZqn/vIX7ieiQaOGjj/Tss1rszkIvZ6p69Fi0qwijLM2tjvuR9oPtMIkISsl50kVAlto5IO2MrUPVCDsTM6UzN1TWas1EWeZ9/ICazTx6lWRNgwAor7w+x1AVHc4ACJ5mx2+2dpE4zrQDCbQx/V2Mnv4txqUdkvFj80QdjtSGbgSxG7T0h7xuj4OEGMPoLnURI1IpsJp6im0Ssvsor4q3ebEzsNNsHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2pBKvgEbyqkEY8YlrHmw24zvQMoFiAMlkSsQZPTMDU=;
 b=CTHH4jLq/KMeBmoZZHIevgfYhMZDZOU/mB1Ng2CozdULrftuILkfT3W6gaFNnzpWNOMTBGj2Y5pdE42cQWWIHP6QjOF+XEFoOO4f62MY1z8dFPUsgrh9V61eeOFuy2XinO4DU9YAPPqwREBtX5K0D2E2qGH0OeiobLo4LyRkTe/cbvrKGyNTsyfl02w/Zb1T9LfigkELlJD99VYt3fZmsJpL09NO6E7IK6jcUN62CJog+aAGVApfqLb8Ke/xtixKC24bWZyAAPZeKslctpkDBZF1F/EAqdUuAzTsR/cI6DkQ0Zl1RcHliDClzbocjylGuTZLWmIFhGqoPKLWsbshzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2pBKvgEbyqkEY8YlrHmw24zvQMoFiAMlkSsQZPTMDU=;
 b=s/yvs4NnZo/fMeIg9Z6TnLHx5TO+IbU0BR8N1GLtOavCAbD+cyCUZ72t9icVuN071kENMrzhLI6FoMkYvF3NuVkjWAz2tgkqeEcSLy0abYANqB52zAMg/zxvd1A2oYAaBOHWOVJOh5p2DFb+XBR/E+DjFoZIX38NoEVPsjDOBZ0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3597.eurprd04.prod.outlook.com (52.134.7.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 07:59:30 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 07:59:30 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] [PATCH v2 4/4] ARM: dts: imx6: add fec gpr property.
Thread-Topic: [EXT] [PATCH v2 4/4] ARM: dts: imx6: add fec gpr property.
Thread-Index: AQHWAtDidOrpexBDZkW/CHENTh0zcqhagzLg
Date:   Thu, 26 Mar 2020 07:59:30 +0000
Message-ID: <VI1PR0402MB360069F200241776B48A0004FFCF0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
 <1585159919-11491-5-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1585159919-11491-5-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 62d87cb1-5547-40e7-5445-08d7d15b9d41
x-ms-traffictypediagnostic: VI1PR0402MB3597:|VI1PR0402MB3597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB35975D82CC609F40E7F1B688FFCF0@VI1PR0402MB3597.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:345;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(81166006)(9686003)(52536014)(8936002)(55016002)(86362001)(7696005)(8676002)(81156014)(7416002)(5660300002)(2906002)(478600001)(33656002)(66946007)(66556008)(316002)(4326008)(71200400001)(110136005)(186003)(76116006)(26005)(4744005)(6506007)(54906003)(66446008)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3597;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vHOYuHskcFeMqhJho46fR/DcDXjztx5Ol0EUychwXATd7aEq01dCMaQvB9KI/rF2EMFSHBFzXIq482esQgI+eD/MUUSj0nOzyHKqfjmx+n4asAZpL2iIeyAFS+g5oq56ytf7qDyQaKWhd0BA830cmUONFHL9kWb2JjDLH3JoWo57smsitzVjWrudIzQLcREQ9yzs5zpFrcV2RqLQggjXT2v4mA2zTqT/F6TQApaTJ/PkW+VjKsBvR9j8hckt3/XlWDVlpbeYrH/vp3YDTlispQ3o30xbIYqZ9Ejn3pjWDBJm8JvE6g+HK3UrjWjbH8KPRDYJdUTj/wxk+Jelgzr2VjssQm+cC2M4tA+vb+EgayrVTLs+JI/xF/NoC52HGw2S8VxHG3T32SJu8eycC6ZWCkgw0A23H+oZspwBmI7jwINuRByuH40v1ZRc4ePFVl5R
x-ms-exchange-antispam-messagedata: QiUkCcL2DB77fztiibMCIzmiXZyKfQ9voo6WBeos/T6DTEOAxMdefHhsxS/K9JPwf27fsEqAcK+s9eEMhtaGuwo/TKAcSLtgHD6nde5nXJVEBn31ELY/GaujWUKZxKg/rcANtyzrUTduF/5CR9q7/Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d87cb1-5547-40e7-5445-08d7d15b9d41
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 07:59:30.3359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RuC9k28DVCpSnFL6Q565FHE+sBNoltUd2kxlZwOTzPZ+O64cV7v2Yxrx1LVwLdAYxYwNLLf7nkoGp3M92BWzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3597
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group> Sent: Thursday, March 26=
, 2020 2:12 AM
> This is required for wake on lan on i.MX6
>=20
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>

Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.d=
tsi
> index bc488df..65b0c8a 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -1045,6 +1045,7 @@
>                                          <&clks
> IMX6QDL_CLK_ENET>,
>                                          <&clks
> IMX6QDL_CLK_ENET_REF>;
>                                 clock-names =3D "ipg", "ahb", "ptp";
> +                               gpr =3D <&gpr>;
>                                 status =3D "disabled";
>                         };
>=20
> --
> 1.9.1

