Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9891D25EA54
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgIEUOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:14:45 -0400
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:52396
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728103AbgIEUOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 16:14:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Il4NH2AU4Ue+j0JX3p4DaHT7ye6IHA+XRQofxI6OpAUmRT8mqd6ZYIIypOpyjIiZDKnp15sC+JCAYtsFAmfR/MegI9O+UrvTtgwBt2hFQSs7WzxAFKKeBlwfyP1F6EsyBGTE9juEBYlzcQbACmrAlGxzB6jSiAl10VlYtgJNDFG7MnUKgs/YD6FGAQICulhB8sX+/l2yUiIxr4fccgMexFGFGZSoMmUXZXyjXrnFVlHhpWOZftejAzRT5HzSqcmQs8QycUBst4PAMWilkxe98wNNCxHdYcuQy/mbPWYG5m1TJseCu6WgoolMDpKHaQu2H4hbZiVET2of6Sf6F7NoSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFpnjI+DrRmKd2PLv69U6RFx9v1dbMFrrIaNnzJlac4=;
 b=EpvMwy9CoWMc3xU44UvQSF1IU1JoirHFjP+mdsgt5AqmnzLDbwiBLfe5exCC0C8dNJVYoLBQZJYOj7eKk3X47NkPakDoJYuOT1/R0dAKPZVZ/usGAybzocAXwlWGwlyOAD0sP1SiKrNLJ7H+MtlL5u4iK4Gg8ocY+pZ90MtBSFc16kZKkrzECsX1DXxCRHmkErVYkNBAK/4V94VimcDJUXS3/KmuZT1UvadvxHoy7ukMBQOrdON3HSBsaMVQbBSIheoRwc9QYgS5fSTRBx7OvsXm7e6j8FXpEF0iKBtiJHt3IMcr5bNJ77NBooEa4pum4v3oYLdKpNaFD+AVcyfGmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFpnjI+DrRmKd2PLv69U6RFx9v1dbMFrrIaNnzJlac4=;
 b=KwpVtoi/FgKWErSYIiUvC8vCijVA6z/VCwGS+yy8SnuiBJsyrCg8L1K0PTTXAfu5eBAlnSL1TSfSBS5mnyA6H7l4SHzu3aOj+yTjsJqEA9lLuNJ3lrJmqgmDGynpbI/rfzOwR0M+pF3ScNkodA6gJIYbxWTzX3JS0veiowqb1F4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4510.eurprd04.prod.outlook.com
 (2603:10a6:803:65::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Sat, 5 Sep
 2020 20:14:38 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::9488:e177:a8e8:9037%7]) with mapi id 15.20.3348.017; Sat, 5 Sep 2020
 20:14:38 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: repair reference in LYNX PCS MODULE
Thread-Topic: [PATCH] MAINTAINERS: repair reference in LYNX PCS MODULE
Thread-Index: AQHWg3CDYFPbFVYb4kqvsJNhHF1856lafGCQ
Date:   Sat, 5 Sep 2020 20:14:37 +0000
Message-ID: <VI1PR0402MB38710D434D6549E644B241BBE02A0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200905103700.17162-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20200905103700.17162-1-lukas.bulwahn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6357e594-c357-43df-54a5-08d851d850b8
x-ms-traffictypediagnostic: VI1PR04MB4510:
x-microsoft-antispam-prvs: <VI1PR04MB451097C94133F08CBEF9067FE02A0@VI1PR04MB4510.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JHeVFnPdq4JbwpDzB1lPwkjPcvHQe1vOYiuozQSfRDDmXIhVSBW/T7xBRj5Sax8VktIQC/HpedzC72jHKO2Vkrvkgohknl1E+qWc/EudimKgUYT90R7Ir7vDEamKL2Na0rg1Ll+CyaNqkFIAfs9/SlSG4kZ2HbllGTJXjPBvkPN8T4XhlRltagnpXiaIRHqi6NVoeLzjGApQhuk6lpgqh8/k//wnr1n2+f0qIugx3kLQxjnq/Z9sfgJlqikE3c6Wg36E4LLXfaaBsRQuZfzkwwx06hxY4Xtf7p4tZ8SydXQWw8+I5z7BIomyhgD8AOe+D3TbfVuAt8y7WGgJQA1x2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(186003)(55016002)(9686003)(4326008)(33656002)(86362001)(71200400001)(44832011)(5660300002)(52536014)(66446008)(64756008)(66476007)(66556008)(66946007)(76116006)(478600001)(110136005)(54906003)(7696005)(316002)(6506007)(26005)(8936002)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: z0uKZQAFweMEtzQxW68a0irdXA9AAoBpVKVbtfUrstA4QLBWYz9kW9NyMbVcyXbk2e0aLs0L0FMmp72h0yqdx0e7KwpFfmyYdK3AVLCL/jGRCnJw2ho2GTa4N2I1gKez0FjyM6TD7pei8oseAOafxiToWYAOag5UhKFOHqt3IqeZwddxj2rIfCuvGOOJB0TFaFseERseEM39+GFmwLaoBFt+rPyEOFcGa4ZKocWPN2R8tJ7NseDQ+V+EofJM/+VZJQMnCbuaREm88rruFNb8HjGuOZ1U46FUQl1sSGWwZwyMDqskGLL/YJBhkYru85zXwuqFAtsm30VU3Vkgc5NmHe3kCe/wlIuF4W4jxj6mOabmDcXk7IModc5ePboCd9rxmfHyDXaMVJAW31RXElxNCnn//FNpH1thBeea1+N99VfjVJr/qfYaxytiraAY0Xvv+OziaV2HSdjUhBiLh9lr2ovX8f1mc15Lhr09QxkgsOKXwexjvzQi5fKpg4MRUZFmxO1++cbXwQd5qloq5oumA6r4/BrGaZvomc7MFUK9L0bjD3EPa6ACHGj2cAudpfDN4mpsQZQVLSg0ZDU7o0W5pTznfEcG4zrGCeVWm3UqDEOMBtXaL/LucEctqzS1+ejyiIjRNFeMI5nGY9T4WVuAPA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6357e594-c357-43df-54a5-08d851d850b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 20:14:37.9270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++TsK41k45UgMMaxQCX4/2tl/le/t76IQIUFXMDEzTqFodZe2uVZmaapLLYtO0iuKsbaacHR3reHtMA4AmSy0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4510
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: [PATCH] MAINTAINERS: repair reference in LYNX PCS MODULE
>=20
> Commit 0da4c3d393e4 ("net: phy: add Lynx PCS module") added the files in
> ./drivers/net/pcs/, but the new LYNX PCS MODULE section refers to
> ./drivers/net/phy/.
>=20
> Hence, ./scripts/get_maintainer.pl --self-test=3Dpatterns complains:
>=20
>   warning: no file matches    F:    drivers/net/phy/pcs-lynx.c
>=20
> Repair the LYNX PCS MODULE section by referring to the right location.
>=20
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
> applies cleanly on next-20200903
>=20
> Ioana, please ack.
> David, please pick this minor non-urgent patch into your net-next.
>=20
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bb0cb31d323b..918deaa1d96e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10350,7 +10350,7 @@ LYNX PCS MODULE
>  M:	Ioana Ciornei <ioana.ciornei@nxp.com>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	drivers/net/phy/pcs-lynx.c
> +F:	drivers/net/pcs/pcs-lynx.c
>  F:	include/linux/pcs-lynx.h
>=20
>  M68K ARCHITECTURE
> --
> 2.17.1

